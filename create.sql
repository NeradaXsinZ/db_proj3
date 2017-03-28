-- To use just do
	-- mysql --host=db.cs.ship.edu --user=csc371-30 --password=Password30 --database=csc371-30 -vvv < MMO_CREATE.sql
	-- remove -vvv if you don't want verbose


-- Drops all tables
-- Found this part on stackoverflow though im sure i could have come up with something similar given time
-- http://stackoverflow.com/questions/12403662/how-to-remove-all-mysql-tables-from-the-command-line-without-drop-database-permi
-- Create a dummy table to drop in case of empty db


SET FOREIGN_KEY_CHECKS = 0;
SET @tables = NULL;
SELECT GROUP_CONCAT(table_name) INTO @tables
  FROM information_schema.tables
  WHERE table_schema = 'csc371-30';

SET @tables = CONCAT('DROP TABLE IF EXISTS ', @tables);
PREPARE stmt FROM @tables;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
SET FOREIGN_KEY_CHECKS = 1;

-- BEGIN TABLE CREATION

CREATE TABLE Players (
    playerID INT NOT NULL AUTO_INCREMENT,
	playerName VARCHAR(255) NOT NULL,
	class VARCHAR(255),
	experiencePoints INT,
	strength INT,
	charisma INT,
	intelligence INT,
	currentHealth INT,
	maxHealth INT,
	PRIMARY KEY (playerID)
);

CREATE TABLE Logins (
	loginID INT NOT NULL,
	playerID INT NOT NULL,
	logInTime DATETIME NOT NULL,
	logoutTime DATETIME,
	PRIMARY KEY (loginID),
	FOREIGN KEY (playerID) REFERENCES Players(playerID)
);

CREATE TABLE Maps (
	mapName VARCHAR(255) NOT NULL,
	region VARCHAR(255) NOT NULL,
	PRIMARY KEY (mapName, region)
);

CREATE TABLE KnownMaps (
	playerID INT NOT NULL,
	mapName VARCHAR(255) NOT NULL,
	CONSTRAINT PK_Maps PRIMARY KEY (playerID, mapName),
	FOREIGN KEY (playerID) REFERENCES Players(playerID),
	FOREIGN KEY (mapName) REFERENCES Maps(mapName)
);
 

CREATE TABLE StatusEffects (
	statusName VARCHAR(255) NOT NULL,
	timeout INT NOT NULL,
	strength INT,
	charisma INT,
	intelligence INT,
	PRIMARY KEY (statusName)
);

CREATE TABLE PlayerStatus (
	playerID INT NOT NULL,
	statusName VARCHAR(255) NOT NULL,
	timeApplied DATETIME NOT NULL,
	status VARCHAR(255) NOT NULL,
	CONSTRAINT PK_PStatus PRIMARY KEY (playerID, statusName),
	FOREIGN KEY (playerID) REFERENCES Players(playerID),
	FOREIGN KEY (statusName) REFERENCES StatusEffects(statusName)
);

CREATE TABLE Deaths (
	deathID INT NOT NULL AUTO_INCREMENT,
	causeOfDeath VARCHAR(255) NOT NULL,
	timeOfDeath DATETIME NOT NULL,
	PRIMARY KEY (deathID) 
);

CREATE TABLE PlayerDeaths (
	playerID INT NOT NULL,
	deathID INT NOT NULL,
	CONSTRAINT PK_PDeaths PRIMARY KEY (playerID, deathID),
	FOREIGN KEY (playerID) REFERENCES Players(playerID),
	FOREIGN KEY (deathID) REFERENCES Deaths(deathID)
);

-- Neutral is passive until it is attack or otherwise aggravated
CREATE TABLE Creatures (
	creatureID INT NOT NULL AUTO_INCREMENT,
	species VARCHAR(255) NOT NULL,
	maxHealth INT,
	Friendliness VARCHAR(255),
	CONSTRAINT Friend_Val CHECK  (Friendliness = 'aggressive' OR Friendliness = 'neutral' OR Friendliness = 'passive' ),
	PRIMARY KEY (creatureID)
);

CREATE TABLE CreaturesOwned (
	playerID INT NOT NULL,
	creatureID INT NOT NULL,
	CONSTRAINT PK_POwns PRIMARY KEY (playerID, creatureID),
	FOREIGN KEY (playerID) REFERENCES Players(playerID),
	FOREIGN KEY (creatureID) REFERENCES Creatures(creatureID)
);

CREATE TABLE Pets (
	petID INT NOT NULL,
	loyalty VARCHAR(255),
	CONSTRAINT loyalty_Val CHECK  (loyalty = 'disloyal' OR loyalty = 'neutral' OR loyalty = 'loyal' OR loyalty = 'very_loyal'),
	FOREIGN KEY (petID) REFERENCES Creatures(creatureID)
);	

CREATE TABLE NPCs (
	npcID INT NOT NULL,
	npcName VARCHAR(255) NOT NULL,
	class VARCHAR(255),
	PRIMARY KEY (npcID),
	FOREIGN KEY (npcID) REFERENCES Creatures(creatureID)

);

CREATE TABLE Summons (
	summonID INT NOT NULL,
	creatureName VARCHAR(255) NOT NULL,
	duration INT NOT NULL,
	PRIMARY KEY (summonID),
	FOREIGN KEY (summonID) REFERENCES Creatures(creatureID)
);
    
CREATE TABLE Monsters (
	monsterID INT NOT NULL,
	attackValue INT NOT NULL,
	PRIMARY KEY (monsterID),
	FOREIGN KEY (monsterID) REFERENCES Creatures(creatureID)
);

CREATE TABLE Skills (
	skillName VARCHAR(255) NOT NULL,
	maxLevel INT NOT NULL,
	PRIMARY KEY (skillName)
);

CREATE TABLE PlayerSkills (
	playerID INT NOT NULL,
	skillName VARCHAR(255) NOT NULL,
	playerSkillLevel INT,
	CONSTRAINT PK_PSkills PRIMARY KEY (playerID, skillName)
);

-- Added ItemName as a primary key though it is not in the original schema
CREATE TABLE  Items (
	itemID INT NOT NULL AUTO_INCREMENT,
	itemName VARCHAR(255) NOT NULL,
	weight INT,
	cost INT,
	CONSTRAINT PK_items PRIMARY KEY (itemID, itemName)
);

CREATE TABLE Equiptment (
	itemID INT NOT NULL,
	armorValue INT,
	damageValue INT,
	FOREIGN KEY (itemID) REFERENCES Items(itemID)
);

CREATE TABLE PlayerInventory (
	playerID INT NOT NULL,
	itemID INT NOT NULL,
	CONSTRAINT PK_PItems PRIMARY KEY (playerID, itemID),
	FOREIGN KEY (playerID) REFERENCES Players(playerID),
	FOREIGN KEY (itemID) REFERENCES Items(itemID)
);

CREATE TABLE Recipes (
	recipeID INT NOT NULL,
	craftedItemID INT NOT NULL,
	quantityMade INT NOT NULL,
	PRIMARY KEY (recipeID),
	FOREIGN KEY (craftedItemID) REFERENCES Items(itemID)
);

CREATE TABLE CraftingMaterials (
	recipeID INT NOT NULL,
	craftingMaterialID INT NOT NULL,
	CONSTRAINT PK_Craft_Mats PRIMARY KEY (recipeID, craftingMaterialID),
	FOREIGN KEY (recipeID) REFERENCES Recipes(recipeID),
	FOREIGN KEY (craftingMaterialID) REFERENCES Items(itemID)

);

-- END TABLE CREATION