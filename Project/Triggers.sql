-- ТРИГЕРИ

-- Добавяме колона която показва дали дадената карта за посещения е изтекла или не
ALTER TABLE membership_cards
ADD is_active BIT NOT NULL
DEFAULT (1)

-- Тригерите запълват лог таблица, като при всяка промяна на оценъчна цена на картина, скулптура или артефакт
-- се запълва кортеж с уникално id на log-a, каталожен номер на артефакта, новата и старата цена.
CREATE TABLE logs(
	log_id INT IDENTITY(1,1) PRIMARY KEY,
	catalog_number INT,
	new_estimate INT,
	old_estimate INT,
	date_of_change DATE
);
GO

-- За да се създаде тригер, трябва да е първи в терминала за заявки, т.е. да няма нищо над него
-- или всички заявки над него да са с терминиращ GO след себе си

CREATE OR ALTER TRIGGER tr_estimate_info_paintings ON paintings FOR UPDATE
AS
DECLARE @new INT = (SELECT TOP(1) [estimate(EURO)] FROM inserted)
DECLARE @old INT = (SELECT TOP(1) [estimate(EURO)] FROM deleted)

DECLARE @catalog_number INT = (SELECT catalog_number from inserted)

INSERT INTO logs (catalog_number, new_estimate, old_estimate, date_of_change) VALUES
(@catalog_number, @new, @old, GETDATE())
DECLARE @affected_rows INT = (SELECT COUNT(log_id) FROM logs WHERE catalog_number is NULL)
IF (@affected_rows > 0) 
	BEGIN
		ROLLBACK
		RAISERROR('Update on invalid articul.', 16, 1)
		RETURN
	END 
GO

CREATE OR ALTER TRIGGER tr_estimate_info_sculptures ON sculptures FOR UPDATE
AS
DECLARE @new INT = (SELECT TOP(1) [estimate(EURO)] FROM inserted)
DECLARE @old INT = (SELECT TOP(1) [estimate(EURO)] FROM deleted)

DECLARE @catalog_number INT = (SELECT catalog_number from inserted)

INSERT INTO logs (catalog_number, new_estimate, old_estimate, date_of_change) VALUES
(@catalog_number, @new, @old, GETDATE())
DECLARE @affected_rows INT = (SELECT COUNT(log_id) FROM logs WHERE catalog_number is NULL)
IF (@affected_rows > 0) 
	BEGIN
		RAISERROR('Update on invalid articul.', 16, 1)
		ROLLBACK 
		RETURN
	END 
GO

CREATE OR ALTER TRIGGER tr_estimate_info_artefacts ON artefacts FOR UPDATE
AS
DECLARE @new INT = (SELECT TOP(1) [estimate(EURO)] FROM inserted)
DECLARE @old INT = (SELECT TOP(1) [estimate(EURO)] FROM deleted)

DECLARE @catalog_number INT = (SELECT catalog_number from inserted)

INSERT INTO logs (catalog_number, new_estimate, old_estimate, date_of_change) VALUES
(@catalog_number, @new, @old, GETDATE())
DECLARE @affected_rows INT = (SELECT COUNT(log_id) FROM logs WHERE catalog_number is NULL)
IF (@affected_rows > 0) 
	BEGIN
		RAISERROR('Update on invalid exhibit.', 16, 1)
		ROLLBACK
		RETURN
	END 
GO

-- Следващия тригер запълва email таблица, като при всяка изтъркана посетителска карта, ще служи
-- за изпращане на email на собственика със заглавна тема, която казва, че картата му е 
-- изтекла и съдържание - датата на изтичане на картата и галерията за която е била издадена.
CREATE TABLE notification_emails(
	id INT PRIMARY KEY IDENTITY(1,1),
	card_number INT,
	recipient VARCHAR(30),
	subject VARCHAR(80),
	body VARCHAR(150)
);
GO

CREATE OR ALTER TRIGGER tr_log_emails ON membership_cards INSTEAD OF DELETE
AS
DECLARE @del_id INT = (SELECT TOP(1) id FROM deleted)
DECLARE @recipient VARCHAR(80) = (SELECT TOP(1) name FROM deleted)
DECLARE @gallery VARCHAR(30) = (SELECT TOP(1) gallery FROM deleted)
DECLARE @bit BIT = (SELECT TOP(1) is_active FROM deleted)
DECLARE @card_number INT = (SELECT TOP(1) id FROM deleted)
IF(@bit = 1)
	INSERT INTO notification_emails(card_number, recipient, subject, body) VALUES
	(
	@card_number,
	@recipient, 
	'Expired membership card for gallery: ' + @gallery,
	'On ' + CONVERT(varchar(30),CONVERT(date, GETDATE(),20)) + ' your membership card has expired. Thanks for visiting us!'
	)
	UPDATE membership_cards SET is_active = 0 where id = @del_id
GO

CREATE OR ALTER PROCEDURE pr_delete_expired_cards 
AS
BEGIN
DECLARE @local_table_variable TABLE
(
id INT
)
INSERT INTO @local_table_variable
SELECT id FROM membership_cards
WHERE date_of_expiry < GETDATE()

DECLARE @i INT
SELECT @i = min(id) from @local_table_variable
DECLARE @max INT
SELECT @max = max(id) from @local_table_variable

WHILE @i <= @max BEGIN
    DELETE FROM membership_cards WHERE id = (SELECT id FROM @local_table_variable WHERE id = @i) 
    SET @i = @i + 1
END
END
GO

ALTER TABLE notification_emails ADD CONSTRAINT FK_notification_emails_membership_cards FOREIGN KEY(card_number) REFERENCES membership_cards(id);

-- test 1st 3 triggers
--SELECT * from paintings
--SELECT * from artefacts
--UPDATE paintings SET [estimate(EURO)] += 8800 WHERE catalog_number = 10000
--UPDATE artefacts SET [estimate(EURO)] -= 9200 WHERE catalog_number = 40000
--UPDATE artefacts SET [estimate(EURO)] -= 5200 WHERE catalog_number = 10001 -- fake one (no such artefact)
--SELECT * FROM logs

-- test 2nd trigger
--SELECT * FROM membership_cards
--SELECT * FROM notification_emails
--SELECT name, gallery from membership_cards where date_of_expiry < GETDATE()
--select recipient, subject, body from notification_emails
--exec pr_delete_expired_cards
