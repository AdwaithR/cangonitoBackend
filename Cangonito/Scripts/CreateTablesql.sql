USE [Cangonito]

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EventStatus]') AND type in (N'U'))
DROP TABLE [dbo].[EventStatus];

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Events]') AND type in (N'U'))
DROP TABLE [dbo].[Events];

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserActivity]') AND type in (N'U'))
DROP TABLE [dbo].[UserActivity];

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserActivity]') AND type in (N'U'))
CREATE TABLE UserActivity (
    returnId INT PRIMARY KEY,
    sessionDate DATETIME,
    username VARCHAR(50),
);

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Events]') AND type in (N'U'))
CREATE TABLE [Events] (
    eventId INT identity PRIMARY KEY,
    eventName VARCHAR(50)
);

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EventStatus]') AND type in (N'U'))
CREATE TABLE EventStatus (
    id INT identity PRIMARY KEY,
    returnId INT,
    eventId INT,
    status INT,
    error VARCHAR(100),
    FOREIGN KEY (returnId) REFERENCES UserActivity(returnId),
    FOREIGN KEY (eventId) REFERENCES Events(eventId)
);


INSERT INTO [Events] (eventName) VALUES ('interview'), ('tax');

INSERT INTO UserActivity (returnId, sessionDate, username)
VALUES 
(12345, GETDATE(), 'user1@example.com'),
(16347, GETDATE(), 'user2@example.com');

INSERT INTO EventStatus (returnId, eventId, status, error)
VALUES
('12345', (SELECT eventId FROM Events WHERE eventName = 'interview'), 1, NULL),
('12345', (SELECT eventId FROM Events WHERE eventName = 'tax'), 2, 'error 404'),
('16347', (SELECT eventId FROM Events WHERE eventName = 'interview'), 1, NULL),
('16347', (SELECT eventId FROM Events WHERE eventName = 'tax'), 1, NULL);


--select * from EventStatus
--select * from [Events]
--select * from UserActivity