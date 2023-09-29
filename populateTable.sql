drop table NameToAcronym cascade constraints;
drop table SchoolDetails cascade constraints;
drop table SupportContact cascade constraints;
drop table SupportContactPasswords cascade constraints;
drop table Platform cascade constraints;
drop table Unit cascade constraints;
drop table Management cascade constraints;
drop table LeasingCompany cascade constraints;
drop table Broker cascade constraints;
drop table Owner cascade constraints;
drop table Visit cascade constraints;
drop table Application cascade constraints;
drop table Searcher cascade constraints;
drop table Testimonial cascade constraints;
drop table ContractInfo cascade constraints;
drop table Contract_Duration cascade constraints;
drop table Unit_Searcher cascade constraints;
drop table Unit_Platform cascade constraints;
drop table Unit_School cascade constraints;

create table NameToAcronym (
  Name VARCHAR(50),
  Acronym VARCHAR(5),
  PRIMARY KEY (Name)
);

create table SchoolDetails (
  SchoolID INT,
  Name VARCHAR(50),
  Address VARCHAR(50),
  PRIMARY KEY (SchoolID),
  FOREIGN KEY (Name) REFERENCES NameToAcronym (Name)
);

create table SupportContact (
  ContactID INT,
  FullName VARCHAR(50),
  Email VARCHAR(320),
  PhoneNumber VARCHAR(20),
  Password VARCHAR(128),
  SchoolID INT NOT NULL,
  PRIMARY KEY (ContactID),
  FOREIGN KEY (SchoolID) REFERENCES SchoolDetails ON DELETE CASCADE 
);

create table SupportContactPasswords (
  Email VARCHAR(320),
  Password VARCHAR(128),
  PRIMARY KEY (Email)
);

create table Platform (
  PlatformID INT,
  Name VARCHAR(50),
  Url VARCHAR(2048),
  PRIMARY KEY (PlatformID)
);

create table Management (
  ManagementID INT,
  Name VARCHAR(50),
  Email VARCHAR(320),
  PhoneNumber VARCHAR(20),
  PRIMARY KEY (ManagementID)
);

create table Unit (
  UnitID INT,
  Area FLOAT(5),
  NoBedrooms INT,
  NoBathrooms INT,
  Address VARCHAR(50),
  Furnished CHAR(1), -- This is supposed to be a boolean but oracle no support ( 1 or 0 )
  LeaseTerm INT,
  Sublet CHAR(1), -- This is supposed to be a boolean but oracle no support ( 1 or 0 )
  MoveInDate timestamp,
  AskingPrice INT,
  ManagementID INT NOT NULL,
  PRIMARY KEY (UnitID),
  FOREIGN KEY (ManagementID) REFERENCES Management  -- was no cascade
);


create table LeasingCompany (
  ManagementID INT,
  Url VARCHAR(2048),
  BranchName VARCHAR(50),
  PRIMARY KEY (ManagementID),
  FOREIGN KEY (ManagementID) REFERENCES Management 
    ON DELETE CASCADE
);

create table Broker (
  ManagementID INT,
  PRIMARY KEY (ManagementID),
  FOREIGN KEY (ManagementID) REFERENCES Management 
    ON DELETE CASCADE
);

create table Owner (
  ManagementID INT,
  Validated CHAR(1), -- No boolean values in Oracle
  PRIMARY KEY (ManagementID),
  FOREIGN KEY (ManagementID) REFERENCES Management 
    ON DELETE CASCADE
);


create table Searcher (
  SearcherID INT,
  FullName VARCHAR(50),
  Email VARCHAR(320),
  PhoneNumber VARCHAR(20),
  DateOfBirth timestamp,
  CurrentAddress VARCHAR(50),
  ReasonForLeave VARCHAR(100),
  MonthlyIncome INT,
  Password VARCHAR(128),
  PRIMARY KEY (SearcherID)
);

create table Visit (
  DateTime timestamp,
  Virtual CHAR(1), -- no boolean values in Oracle
  UnitID INT,
  SearcherID INT,
  PRIMARY KEY (UnitID, SearcherID),
  FOREIGN KEY (UnitID) REFERENCES Unit 
    ON DELETE CASCADE,
  FOREIGN KEY (SearcherID) REFERENCES Searcher
    ON DELETE CASCADE
);

create table Application (
  DateReceived timestamp,
  CurrentStatus VARCHAR(50),
  UnitID INT,
  SearcherID INT,
  PRIMARY KEY (UnitID, SearcherID),
  FOREIGN KEY (UnitID) REFERENCES Unit 
    ON DELETE CASCADE,
  FOREIGN KEY (SearcherID) REFERENCES Searcher 
    ON DELETE CASCADE    
);

create table Testimonial (
  LetterOfRecomm VARCHAR(500),
  FullName VARCHAR(50),
  Email VARCHAR(320),
  Relationship VARCHAR(100),
  SearcherID INT,
  PRIMARY KEY (Email, SearcherID),
  FOREIGN KEY (SearcherID) REFERENCES Searcher 
    ON DELETE CASCADE
);

create table ContractInfo (
  ContractNumber INT,
  SearcherID INT,
  MoveInDate INT, -- Date not working
  MoveOutDate INT, -- Date not working
  MonthlyPrice INT,
  ManagementID INT,
  PRIMARY KEY (ContractNumber),
  FOREIGN KEY (SearcherID) REFERENCES Searcher 
    ON DELETE CASCADE,
  FOREIGN KEY (ManagementID) REFERENCES Management 
    ON DELETE CASCADE
);

create table Contract_Duration (
  MoveInDate INT, -- Date not working
  MoveOutDate INT, -- Date not working
  Duration INT,
  PRIMARY KEY (MoveInDate, MoveOutDate),
  FOREIGN KEY (MoveInDate) REFERENCES ContractInfo,
  FOREIGN KEY (MoveOutDate) REFERENCES ContractInfo
);

create table Unit_Searcher (
  SearcherID INT,
  UnitID INT,
  PRIMARY KEY (SearcherID, UnitID),
  FOREIGN KEY (SearcherID) REFERENCES Searcher 
    ON DELETE CASCADE,
  FOREIGN KEY (UnitID) REFERENCES Unit
    ON DELETE CASCADE
);
 
create table Unit_Platform (
  UnitID INT,
  PlatformID INT,
  PRIMARY KEY (UnitID, PlatformID),
  FOREIGN KEY (UnitID) REFERENCES Unit
    ON DELETE CASCADE,
  FOREIGN KEY (PlatformID) REFERENCES Platform 
    ON DELETE CASCADE
);

create table Unit_School (
  UnitID INT,
  SchoolID INT,
  Distance FLOAT,
  PRIMARY KEY (UnitID, SchoolID),
  FOREIGN KEY (UnitID) REFERENCES Unit 
    ON DELETE CASCADE,
  FOREIGN KEY (SchoolID) REFERENCES SchoolDetails
    ON DELETE CASCADE
);

INSERT INTO NameToAcronym (Name,Acronym)
VALUES('The University of British Columbia - Vancouver', 'UBCV');
INSERT INTO NameToAcronym (Name,Acronym)
VALUES('The University of British Columbia - Okanagan', 'UBCO');
INSERT INTO NameToAcronym (Name,Acronym)
VALUES('University of Southern California', 'USC');
INSERT INTO NameToAcronym (Name,Acronym)
VALUES('University of South Carolina', 'USC');
INSERT INTO NameToAcronym (Name,Acronym)
VALUES('Simon Fraser University', 'SFU');

INSERT INTO SchoolDetails 
VALUES(1, 'The University of British Columbia - Vancouver', '2329 West Mall, Vancouver, BC, Canada');
INSERT INTO SchoolDetails 
VALUES(2, 'The University of British Columbia - Okanagan', '3287 University Way, Kelowna, BC, Canada');
INSERT INTO SchoolDetails 
VALUES(3, 'University of Southern California', 'Los Angeles, CA 90007, USA');
INSERT INTO SchoolDetails 
VALUES(4, 'University of South Carolina', 'Columbia, SC 29208, USA');
INSERT INTO SchoolDetails 
VALUES(5, 'Simon Fraser University', '8888 University Dr W, Burnaby, Canada');

INSERT INTO SupportContact (ContactID, FullName, Email, PhoneNumber, Password, SchoolID) VALUES
(1, 'Aayush Kogar', '18aayushk@gmail.com', '7783173657', 'abcdefgh1234', 1);
INSERT INTO SupportContact (ContactID, FullName, Email, PhoneNumber, Password, SchoolID) VALUES 
(2, 'Joe Doe', 'jdoe@gmail.com', '7783173847', 'dsofhoise123', 1);
INSERT INTO SupportContact (ContactID, FullName, Email, PhoneNumber, Password, SchoolID) VALUES
(3, 'Lebron James', 'lbj@gmail.com', '7783109373', 'ahfoaih3432', 2);
INSERT INTO SupportContact (ContactID, FullName, Email, PhoneNumber, Password, SchoolID) VALUES
(4, 'Russell Westbrook', 'rs@gmail.com', '7283104373', 'aiobifroih243', 3);
INSERT INTO SupportContact (ContactID, FullName, Email, PhoneNumber, Password, SchoolID) VALUES
(5, 'Carmelo Anthony', 'melo@gmail.com', '2392394234', '123hoih38f', 4);
INSERT INTO SupportContact (ContactID, FullName, Email, PhoneNumber, Password, SchoolID) VALUES
(6, 'JR Smith', 'clutchcity@gmail.com', '2312352349', 'afhoieoc32c', 5);

INSERT INTO SupportContactPasswords (Email, Password) VALUES
('18aayushk@gmail.com', 'abcdefgh1234');
INSERT INTO SupportContactPasswords (Email, Password) VALUES 
('jdoe@gmail.com', 'dsofhoise123');
INSERT INTO SupportContactPasswords (Email, Password) VALUES
('lbj@gmail.com', 'ahfoaih3432');
INSERT INTO SupportContactPasswords (Email, Password) VALUES
('rs@gmail.com', 'aiobifroih243');
INSERT INTO SupportContactPasswords(Email, Password)  VALUES
('melo@gmail.com' ,'123hoih38f');
INSERT INTO SupportContactPasswords (Email, Password) VALUES
('clutchcity@gmail.com', 'afhoieoc32c');

INSERT INTO Platform (PlatformID, Name, Url) VALUES
(1, 'Rentals Canada', 'https://rentals.ca');
INSERT INTO Platform (PlatformID, Name, Url) VALUES 
(2, 'Zumper', 'https://zumper.com');
INSERT INTO Platform (PlatformID, Name, Url) VALUES
(3, 'Craiglist', 'https://craiglist.org');
INSERT INTO Platform (PlatformID, Name, Url) VALUES
(4, 'Apartments', 'https://apartments.com');
INSERT INTO Platform (PlatformID, Name, Url) VALUES
(5, 'First Choice Housing', 'https://firstchoicehousing.com');

INSERT INTO Management (ManagementID, Name, Email, PhoneNumber) VALUES
(1, NULL, NULL, '604-727-4608');
INSERT INTO Management (ManagementID, Name, Email, PhoneNumber) VALUES
(2, 'Cindy Zhang', NULL, '844.243.9986');
INSERT INTO Management (ManagementID, Name, Email, PhoneNumber) VALUES
(3, 'Jovi Realty Inc', 'rentalhousevan@gmail.com', NULL);
INSERT INTO Management (ManagementID, Name, Email, PhoneNumber) VALUES
(4, 'First Choice Housing', 'leasing@firstchoicehousing.com', '(213)-765-3330');
INSERT INTO Management (ManagementID, Name, Email, PhoneNumber) VALUES
(5, 'Don Kim', NULL, '8443265877');
INSERT INTO Management (ManagementID, Name, Email, PhoneNumber) VALUES
(6, 'Sitings Realty', NULL, '604-684-6767');
INSERT INTO Management (ManagementID, Name, Email, PhoneNumber) VALUES
(7, 'Terence May', NULL, '310-270-5928');
INSERT INTO Management (ManagementID, Name, Email, PhoneNumber) VALUES
(8, 'James', NULL, '6046032726 ext. 0873');
INSERT INTO Management (ManagementID, Name, Email, PhoneNumber) VALUES
(9, 'Western Rental Property Management Group', 'info@westernrental.ca', '6042999680');
INSERT INTO Management (ManagementID, Name, Email, PhoneNumber) VALUES
(10, 'Tarence Wong', 'twong@gmail.com', '6673943434');
INSERT INTO Management (ManagementID, Name, Email, PhoneNumber) VALUES
(11, 'Tony Kim', 'tkim@gmail.com', '231.747.0378');
INSERT INTO Management (ManagementID, Name, Email, PhoneNumber) VALUES
(12, 'Chana Firestone', NULL, '(213) 603-9293');
INSERT INTO Management (ManagementID, Name, Email, PhoneNumber) VALUES
(13, 'Nick Phillips', 'nphilips@gmail.com', '338-474-2293');
INSERT INTO Management (ManagementID, Name, Email, PhoneNumber) VALUES
(14, 'J Tatem', 'jt@gmail.com', NULL);
INSERT INTO Management (ManagementID, Name, Email, PhoneNumber) VALUES
(15, 'Corey Wong', 'cwong238@gmail.com', '778-374-0989');
INSERT INTO Management (ManagementID, Name, Email, PhoneNumber) VALUES
(16, 'Khammy Kate', 'khammysah@gmail.com', '778-177-0303');

INSERT INTO Unit (UnitID, Area, NoBedrooms, NoBathrooms, Address, Furnished, LeaseTerm, Sublet, MoveInDate, AskingPrice, ManagementID) VALUES
(1, 1439.5, 2, 2, '5410 Shortcut Rd, Vancouver, BC, Canada', 'T', 365, 'F', TO_TIMESTAMP('2023-09-01 00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF2'), 3400, 1);
INSERT INTO Unit (UnitID, Area, NoBedrooms, NoBathrooms, Address, Furnished, LeaseTerm, Sublet, MoveInDate, AskingPrice, ManagementID) VALUES
(2, 852, 2, 1, '2233 Allison Rd, Vancouver, BC, Canada', 'F', 730, 'F', TO_TIMESTAMP('2023-08-05 00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF2'), 2800, 2);
INSERT INTO Unit (UnitID, Area, NoBedrooms, NoBathrooms, Address, Furnished, LeaseTerm, Sublet, MoveInDate, AskingPrice, ManagementID) VALUES
(3, 950.5, 1, 1, '5410 Shortcut Rd, Vancouver, BC, Canada', 'T', 365, 'F', TO_TIMESTAMP('2023-11-10 00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF2'), 3400, 1);
INSERT INTO Unit (UnitID, Area, NoBedrooms, NoBathrooms, Address, Furnished, LeaseTerm, Sublet, MoveInDate, AskingPrice, ManagementID) VALUES
(4, 1100, 3, 1, '1211 W 37th Dr, CA 90007, USA', 'T', 730, 'F', TO_TIMESTAMP('2023-09-01 00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF2'), 3400, 5);
INSERT INTO Unit (UnitID, Area, NoBedrooms, NoBathrooms, Address, Furnished, LeaseTerm, Sublet, MoveInDate, AskingPrice, ManagementID) VALUES
(5, 646, 2, 2, '9266 University Crescent #901, Burnaby, BC, Canada', 'T', 365, 'T', TO_TIMESTAMP('2023-09-01 00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF2'), 3500, 4);


INSERT INTO LeasingCompany (ManagementID, Url, BranchName) VALUES
(2, 'https://realtor.ca', 'Burnaby');
INSERT INTO LeasingCompany (ManagementID, Url, BranchName) VALUES
(4, 'https://firstchoicehousing.com', NULL);
INSERT INTO LeasingCompany (ManagementID, Url, BranchName) VALUES
(5, 'https://realtor.ca', 'Burnaby');
INSERT INTO LeasingCompany (ManagementID, Url, BranchName) VALUES
(6, 'https://wesbrookproperties.com', NULL);
INSERT INTO LeasingCompany (ManagementID, Url, BranchName) VALUES
(9, 'https://sutton1stwest.com', 'Richmond');
INSERT INTO LeasingCompany (ManagementID, Url, BranchName) VALUES
(12, 'https://compass.com/homes-for-sale/', 'Los Angeles');

INSERT INTO Broker (ManagementID) VALUES
(3);
INSERT INTO Broker (ManagementID) VALUES
(7);
INSERT INTO Broker (ManagementID) VALUES
(10);
INSERT INTO Broker (ManagementID) VALUES
(11);


INSERT INTO Owner (ManagementID, Validated) VALUES
(1, '0');
INSERT INTO Owner (ManagementID, Validated) VALUES
(8, '1');
INSERT INTO Owner (ManagementID, Validated) VALUES
(14, '1');
INSERT INTO Owner (ManagementID, Validated) VALUES
(15, '0');
INSERT INTO Owner (ManagementID, Validated) VALUES
(16, '1');

INSERT INTO Searcher (SearcherID, FullName, Email, PhoneNumber, DateOfBirth, CurrentAddress, ReasonForLeave, MonthlyIncome, Password) VALUES
(1, 'Rahul Dravid', 'rdravid1@gmail.com', '778-333-3333', TO_DATE('2000-07-06', 'YYYY-MM-DD'), '3945 Student Union Blvd, Vancouver, BC, Canada', 'Roommates', 3700, 'abcd4343');
INSERT INTO Searcher VALUES
(2, 'Virat Kohli', 'vk2@gmail.com', '378-328-3283', TO_DATE('1998-07-04', 'YYYY-MM-DD'), '3533 Ross Drive, Vancouver, BC, Canada', 'Cost', 2000, 'aui3h34jkfe');
INSERT INTO Searcher VALUES
(3, 'Jason Kidd', 'msd_csk@gmail.com', '238-3874-3822', TO_DATE('2002-07-04', 'YYYY-MM-DD'), '1405 Armacost Rd, Parkton, MD 21120, USA', NULL, 200, 'DHONI233');
INSERT INTO Searcher VALUES
(4, 'Serena Williams', 'swilliamsiscool@hotmail.com', '238-238-2378', TO_DATE('2001-08-21', 'YYYY-MM-DD'), '100 SPAUGH LN, MOCKSVILLE NC 27028-5438, USA', 'Moving closer to campus', 4000, 'PASSWORDISPASSWORD');
INSERT INTO Searcher VALUES
(5, 'Lin Dan', 'badminton232@gmail.com', '283-2389-4444', TO_DATE('2002-04-09', 'YYYY-MM-DD'), '101 SPAUGH LN, MOCKSVILLE NC 27028-5438, USA', 'Moving closer to campus', 4000, 'PASSWORDISPASSWORD');

INSERT INTO Visit (DateTime, Virtual, UnitID, SearcherID) VALUES (TO_TIMESTAMP('2023-08-05 17:00:00', 'YYYY-MM-DD HH24:MI:SS.FF2'), '0', 1, 3);
INSERT INTO Visit (DateTime, Virtual, UnitID, SearcherID) VALUES (TO_TIMESTAMP('2023-08-05 17:15:00', 'YYYY-MM-DD HH24:MI:SS.FF2'), '0', 1, 4);
INSERT INTO Visit (DateTime, Virtual, UnitID, SearcherID) VALUES (TO_TIMESTAMP('2023-09-04 08:15:00', 'YYYY-MM-DD HH24:MI:SS.FF2'), '1', 2, 4);
INSERT INTO Visit (DateTime, Virtual, UnitID, SearcherID) VALUES (TO_TIMESTAMP('2023-09-04 08:45:00', 'YYYY-MM-DD HH24:MI:SS.FF2'), '1', 3, 4);
INSERT INTO Visit (DateTime, Virtual, UnitID, SearcherID) VALUES (TO_TIMESTAMP('2023-10-04 09:45:00', 'YYYY-MM-DD HH24:MI:SS.FF2'), '1', 5, 4);

INSERT INTO Application (DateReceived, CurrentStatus, UnitID, SearcherID) VALUES(TO_TIMESTAMP('2023-07-04 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF2'), 'PENDING', 1,1);
INSERT INTO Application (DateReceived, CurrentStatus, UnitID, SearcherID) VALUES(TO_TIMESTAMP('2023-05-04 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF2'), 'REJECTED', 1,2);
INSERT INTO Application (DateReceived, CurrentStatus, UnitID, SearcherID) VALUES(TO_TIMESTAMP('2023-05-17 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF2'), 'ACCEPTED-AWAITING CONTRACT SIGNING', 1,3);
INSERT INTO Application (DateReceived, CurrentStatus, UnitID, SearcherID) VALUES(TO_TIMESTAMP('2023-06-05 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF2'), 'PENDING', 2,2);
INSERT INTO Application (DateReceived, CurrentStatus, UnitID, SearcherID) VALUES(TO_TIMESTAMP('2023-06-07 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF2'), 'ACCEPTED-AWAITING CONTRACT SIGNING', 3,1);

INSERT INTO Testimonial (LetterOfRecomm, FullName, Email, Relationship, SearcherID) VALUES
('I can confidently say that he is a responsible and trustworthy individual.', 'Sarah Michell', 'smich@gmail.com', 'Neighbor', 1);
INSERT INTO Testimonial (LetterOfRecomm, FullName, Email, Relationship, SearcherID) VALUES
('Rahul was my roommate for two years during college, and I couldnt have asked for a better person to live with.', 'Mark Coombs', 'mcoom338@gmail.com', 'Former Roommate', 1);
INSERT INTO Testimonial (LetterOfRecomm, FullName, Email, Relationship, SearcherID) VALUES
('As Virats former supervisor at his previous job, I can attest to his exceptional work ethic and reliability.', 'Mark Coombs', 'mcoom338@gmail.com', 'Former Supervisor', 2);
INSERT INTO Testimonial (LetterOfRecomm, FullName, Email, Relationship, SearcherID) VALUES
('I have known Serena for many years as a close friend, and I can vouch for her integrity and character.', 'Bob Marley', 'bobbym@gmail.com', 'Brother', 4);
INSERT INTO Testimonial (LetterOfRecomm, FullName, Email, Relationship, SearcherID) VALUES
('As Jasons college professor, I had the pleasure of witnessing his dedication to his studies and his commitment to achieving excellence.', 'Dr. Johnson', 'jb@ubc.ca', 'College Professor', 3);


INSERT INTO ContractInfo (ContractNumber, SearcherID, MoveInDate, MoveOutDate, MonthlyPrice, ManagementID) VALUES
(1, 5, 2023-08-21, 2024-08-21, 3400, 2);
INSERT INTO ContractInfo (ContractNumber, SearcherID, MoveInDate, MoveOutDate, MonthlyPrice, ManagementID) VALUES
(2, 4, 2025-08-21, 2026-08-21, 4100, 3);
INSERT INTO ContractInfo (ContractNumber, SearcherID, MoveInDate, MoveOutDate, MonthlyPrice, ManagementID) VALUES
(3, 3, 2027-08-21, 2028-08-21, 3330, 2);
INSERT INTO ContractInfo (ContractNumber, SearcherID, MoveInDate, MoveOutDate, MonthlyPrice, ManagementID) VALUES
(4, 2, 2029-08-21, 2030-08-21, 1800, 4);
INSERT INTO ContractInfo (ContractNumber, SearcherID, MoveInDate, MoveOutDate, MonthlyPrice, ManagementID) VALUES
(5, 1, 2031-08-21, 2032-08-21, 1100, 5);

-- INSERT INTO Contract_Duration (MoveInDate, MoveOutDate, Duration) VALUES
-- (2023-08-21, 2024-08-21, 365);
-- INSERT INTO Contract_Duration (MoveInDate, MoveOutDate, Duration) VALUES
-- (2025-08-21, 2026-08-21, 730);
-- INSERT INTO Contract_Duration (MoveInDate, MoveOutDate, Duration) VALUES
-- (2027-08-21, 2028-08-21, 365);
-- INSERT INTO Contract_Duration (MoveInDate, MoveOutDate, Duration) VALUES
-- (2029-08-21, 2030-08-21, 730);
-- INSERT INTO Contract_Duration (MoveInDate, MoveOutDate, Duration) VALUES
-- (2031-08-21, 2032-08-21, 365);

INSERT INTO Unit_Searcher (SearcherID, UnitID) VALUES
(1, 1);
INSERT INTO Unit_Searcher (SearcherID, UnitID) VALUES
(1, 2);
INSERT INTO Unit_Searcher (SearcherID, UnitID) VALUES
(1, 3);
INSERT INTO Unit_Searcher (SearcherID, UnitID) VALUES
(1, 4);
INSERT INTO Unit_Searcher (SearcherID, UnitID) VALUES
(1, 5);
INSERT INTO Unit_Searcher (SearcherID, UnitID) VALUES
(2, 1);
INSERT INTO Unit_Searcher (SearcherID, UnitID) VALUES
(2, 2);
INSERT INTO Unit_Searcher (SearcherID, UnitID) VALUES
(3, 1);

INSERT INTO Unit_Platform (UnitID, PlatformID) VALUES
(1, 1);
INSERT INTO Unit_Platform (UnitID, PlatformID) VALUES
(2, 1);
INSERT INTO Unit_Platform (UnitID, PlatformID) VALUES
(3, 1);
INSERT INTO Unit_Platform (UnitID, PlatformID) VALUES
(4, 2);
INSERT INTO Unit_Platform (UnitID, PlatformID) VALUES
(5, 2);
INSERT INTO Unit_Platform (UnitID, PlatformID) VALUES
(5, 4);

INSERT INTO Unit_School (UnitID, SchoolID, Distance) VALUES
(1, 1, 3.2);
INSERT INTO Unit_School (UnitID, SchoolID, Distance) VALUES
(1, 2, 12.5);
INSERT INTO Unit_School (UnitID, SchoolID, Distance) VALUES
(2, 1, 6.5);
INSERT INTO Unit_School (UnitID, SchoolID, Distance) VALUES
(3, 1, 7.5);
INSERT INTO Unit_School (UnitID, SchoolID, Distance) VALUES
(4, 3, 12.4);
INSERT INTO Unit_School (UnitID, SchoolID, Distance) VALUES
(5, 4, 22.2);
INSERT INTO Unit_School (UnitID, SchoolID, Distance) VALUES
(5, 5, 0.3);

