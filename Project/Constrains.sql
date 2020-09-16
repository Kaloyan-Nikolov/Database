ALTER TABLE paintings ADD CONSTRAINT PK_paintings PRIMARY KEY(catalog_number);
ALTER TABLE artefacts ADD CONSTRAINT PK_artefacts PRIMARY KEY(catalog_number);
ALTER TABLE sculptures ADD CONSTRAINT PK_sculptures PRIMARY KEY(catalog_number);
ALTER TABLE artists ADD CONSTRAINT PK_artists PRIMARY KEY(name);
ALTER TABLE membership_cards ADD CONSTRAINT PK_membership_cards PRIMARY KEY(id);
ALTER TABLE galleries ADD CONSTRAINT PK_galleries PRIMARY KEY(name);
ALTER TABLE curators ADD CONSTRAINT PK_curators PRIMARY KEY(EGN);

ALTER TABLE paintings ADD CONSTRAINT FK_paintings_artists FOREIGN KEY(artist) REFERENCES artists(name);
ALTER TABLE paintings ADD CONSTRAINT FK_paintings_galleries FOREIGN KEY(gallery) REFERENCES galleries(name);
ALTER TABLE artefacts ADD CONSTRAINT FK_artefacts_galleries FOREIGN KEY(gallery) REFERENCES galleries(name);
ALTER TABLE sculptures ADD CONSTRAINT FK_sculptures_artists FOREIGN KEY(artist) REFERENCES artists(name);
ALTER TABLE sculptures ADD CONSTRAINT FK_sculptures_galleries FOREIGN KEY(gallery) REFERENCES galleries(name);
ALTER TABLE membership_cards ADD CONSTRAINT FK_membership_cards_galleries FOREIGN KEY(gallery) REFERENCES galleries(name);
ALTER TABLE galleries ADD CONSTRAINT FK_galleries_curator FOREIGN KEY([curator(EGN)]) REFERENCES curators(EGN);

ALTER TABLE paintings ADD CONSTRAINT CHK_paintings_year CHECK (year >= 0);
ALTER TABLE paintings ADD CONSTRAINT CHK_paintings_height CHECK ([height(mm)] >= 0);
ALTER TABLE paintings ADD CONSTRAINT CHK_paintings_width CHECK ([width(mm)] >= 0);
ALTER TABLE paintings ADD CONSTRAINT CHK_paintings_gallery CHECK (gallery IN ('Ancient Greece', 'Ancient Egypt', 'Rome', 'Asian',
		'Gothic', 'Renaissanse', 'Expressionism', 'Classicism', 'Futurism', 'Abstract Expressionism'));
ALTER TABLE paintings ADD CONSTRAINT CHK_paintings_estimate CHECK ([estimate(EURO)] >= 0);
ALTER TABLE artefacts ADD CONSTRAINT CHK_artefacts_portable CHECK (portable IN ('y','n'));
ALTER TABLE artefacts ADD CONSTRAINT CHK_artefacts_count CHECK (count >= 0);
ALTER TABLE artefacts ADD CONSTRAINT CHK_artefacts_gallery CHECK (gallery IN ('Ancient Greece', 'Ancient Egypt', 'Rome', 'Asian',
		'Gothic', 'Renaissanse', 'Expressionism', 'Classicism', 'Futurism', 'Abstract Expressionism'));
ALTER TABLE artefacts ADD CONSTRAINT CHK_artefacts_estimate CHECK ([estimate(EURO)] >= 0);
ALTER TABLE artefacts ADD CONSTRAINT CHK_Person_Age CHECK ([estimate(EURO)] >= 0);
ALTER TABLE sculptures ADD CONSTRAINT CHK_sculptures_year CHECK (year >= 0);
ALTER TABLE sculptures ADD CONSTRAINT CHK_sculptures_area CHECK ([area_requiered(sq_cm)] >= 0);
ALTER TABLE sculptures ADD CONSTRAINT CHK_sculptures_gallery CHECK (gallery IN ('Ancient Greece', 'Ancient Egypt', 'Rome', 'Asian',
		'Gothic', 'Renaissanse', 'Expressionism', 'Classicism', 'Futurism', 'Abstract Expressionism'));
ALTER TABLE sculptures ADD CONSTRAINT CHK_sculptures_estimate CHECK ([estimate(EURO)] >= 0);
ALTER TABLE artists ADD CONSTRAINT CHK_artists_born CHECK (born >= 0);
ALTER TABLE artists ADD CONSTRAINT CHK_artists_died CHECK (died >= 0);
ALTER TABLE artists ADD CONSTRAINT CHK_artists_lived CHECK (born < died);
ALTER TABLE membership_cards ADD CONSTRAINT CHK_membership_cards_gallery CHECK (gallery IN ('Ancient Greece', 'Ancient Egypt', 'Rome', 'Asian',
		'Gothic', 'Renaissanse', 'Expressionism', 'Classicism', 'Futurism', 'Abstract Expressionism'));
ALTER TABLE membership_cards ADD CONSTRAINT CHK_membership_cards_price CHECK (price >= 0);
ALTER TABLE galleries ADD CONSTRAINT CHK_galleries_halls CHECK (halls >= 0);
ALTER TABLE curators ADD CONSTRAINT CHK_curators_exhibitions CHECK (participation_in_exhibitions >= 0);
