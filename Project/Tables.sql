USE master
GO
if exists (select * from sysdatabases where name='museum')
	DROP DATABASE museum
GO

CREATE DATABASE museum
GO
USE museum
GO

----- Create Tables -----

CREATE TABLE paintings(
	catalog_number INT IDENTITY(10000,1) NOT NULL, --better perfomance and space (4bits vs 5bits) than decimal;
	name VARCHAR(100) NOT NULL,
	year SMALLINT, 
	artist VARCHAR(50) NOT NULL,
	technique CHAR(20) NOT NULL,
	style CHAR(20) NOT NULL,
	movement CHAR(30) NOT NULL,
	[height(mm)] SMALLINT NOT NULL, 
	[width(mm)] SMALLINT NOT NULL, 
	gallery CHAR(30) NOT NULL,
	[estimate(EURO)] INT NOT NULL
);

CREATE TABLE artefacts(
	catalog_number INT IDENTITY(40000,1) NOT NULL,
	name VARCHAR(50) NOT NULL,
	century CHAR(15),
	discovery_site VARCHAR(30),
	civilization CHAR(20),
	material CHAR(20) NOT NULL,
	portable CHAR(1) NOT NULL,
	count SMALLINT NOT NULL,
	gallery CHAR(30) NOT NULL,
	[estimate(EURO)] INT NOT NULL
);

CREATE TABLE sculptures(
	catalog_number INT IDENTITY(70000,1) NOT NULL,
	name VARCHAR(50) NOT NULL,
	year SMALLINT,
	artist VARCHAR(50),
	material CHAR(20) NOT NULL,
	country CHAR(20) NOT NULL,
	[area_requiered(sq_cm)] SMALLINT NOT NULL,
	gallery CHAR(30) NOT NULL,
	[estimate(EURO)] INT NOT NULL
);

CREATE TABLE artists(
	name VARCHAR(50) NOT NULL,
	born SMALLINT,
	died SMALLINT,
	country CHAR(20) NOT NULL,
	style CHAR(30) NOT NULL,
	CONSTRAINT UK_artists UNIQUE (name)
);

CREATE TABLE membership_cards(
	id INT IDENTITY(30000, 1) NOT NULL,
	name VARCHAR(30) NOT NULL,
	address VARCHAR(80) NOT NULL,
	city VARCHAR(30) NOT NULL,
	date_of_birth DATE NOT NULL, -- yyyy-mm-dd
	date_of_expiry DATE NOT NULL,
	gallery CHAR(30) NOT NULL,
	price DECIMAL(4,2) NOT NULL
);

CREATE TABLE galleries(
	name CHAR(30) NOT NULL,
	most_famous_exhibit VARCHAR(50) NOT NULL,
	[curator(EGN)] CHAR(10) NOT NULL,
	halls SMALLINT NOT NULL,
	CONSTRAINT UK_galleries UNIQUE (name)
);

CREATE TABLE curators(	
	EGN CHAR(10) NOT NULL,
	name CHAR(30) NOT NULL,
	address VARCHAR(80) NOT NULL,
	date_of_birth DATE NOT NULL,
	university VARCHAR(50),
	date_of_appointment DATE NOT NULL,
	academic_title CHAR(30) NOT NULL,
	participation_in_exhibitions SMALLINT NOT NULL,
	CONSTRAINT UK_curators UNIQUE (EGN)
);
