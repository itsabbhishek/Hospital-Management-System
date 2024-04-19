create database Hospital_db
use Hospital_db

-- Patients Table
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE,
    Gender CHAR(1),
    ContactNumber VARCHAR(15),
    Address VARCHAR(255)
);

-- Doctors Table
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialization VARCHAR(100),
    ContactNumber VARCHAR(15),
    Address VARCHAR(255)
);

-- Rooms Table
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY,
    RoomType VARCHAR(50),
    Availability BIT
);

-- HospitalAdmissions Table
CREATE TABLE HospitalAdmissions (
    AdmissionID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    RoomID INT,
    AdmissionDate DATETIME,
    DischargeDate DATETIME,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);

-- DischargeSummaries Table
CREATE TABLE DischargeSummaries (
    DischargeSummaryID INT PRIMARY KEY,
    AdmissionID INT UNIQUE,
    Diagnosis VARCHAR(255),
    Treatment VARCHAR(255),
    Remarks VARCHAR(255),
    FOREIGN KEY (AdmissionID) REFERENCES HospitalAdmissions(AdmissionID)
);

-- Nurses Table
CREATE TABLE Nurses (
    NurseID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    ContactNumber VARCHAR(15)
);

-- WardBoys Table
CREATE TABLE WardBoys (
    WardBoyID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    ContactNumber VARCHAR(15)
);

-- MedicalStores Table
CREATE TABLE MedicalStores (
    ItemID INT PRIMARY KEY,
    ItemName VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10, 2)
);

-- Intermediate Table for Many-to-Many Relationships
CREATE TABLE AdmissionNurses (
    AdmissionID INT,
    NurseID INT,
    PRIMARY KEY (AdmissionID, NurseID),
    FOREIGN KEY (AdmissionID) REFERENCES HospitalAdmissions(AdmissionID),
    FOREIGN KEY (NurseID) REFERENCES Nurses(NurseID)
);

CREATE TABLE AdmissionWardBoys (
    AdmissionID INT,
    WardBoyID INT,
    PRIMARY KEY (AdmissionID, WardBoyID),
    FOREIGN KEY (AdmissionID) REFERENCES HospitalAdmissions(AdmissionID),
    FOREIGN KEY (WardBoyID) REFERENCES WardBoys(WardBoyID)
);

CREATE TABLE AdmissionMedicalItems (
    AdmissionID INT,
    ItemID INT,
    Quantity INT,
    PRIMARY KEY (AdmissionID, ItemID),
    FOREIGN KEY (AdmissionID) REFERENCES HospitalAdmissions(AdmissionID),
    FOREIGN KEY (ItemID) REFERENCES MedicalStores(ItemID)
);


--- Get Patients Details Procedure

CREATE PROCEDURE GetAdmissionDetails
    @PatientID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT p.FirstName + ' ' + p.LastName AS PatientName,
           d.FirstName + ' ' + d.LastName AS DoctorName,
           r.RoomType,
           ha.AdmissionDate
    FROM HospitalAdmissions ha
    INNER JOIN Patients p ON ha.PatientID = p.PatientID
    INNER JOIN Doctors d ON ha.DoctorID = d.DoctorID
    INNER JOIN Rooms r ON ha.RoomID = r.RoomID
    WHERE ha.PatientID = @PatientID;
END
