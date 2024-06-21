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
	isDIY bit,
	createdDate DATETIME
);

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Events]') AND type in (N'U'))
CREATE TABLE [Events] (
    eventId INT identity PRIMARY KEY,
    eventName VARCHAR(50),
	isDIY bit,
	createdDate DATETIME
);

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EventStatus]') AND type in (N'U'))
CREATE TABLE EventStatus (
    id INT identity PRIMARY KEY,
    returnId INT,
    eventId INT,
    status INT,
    error VARCHAR(100),
	createdDate DATETIME,
    FOREIGN KEY (returnId) REFERENCES UserActivity(returnId),
    FOREIGN KEY (eventId) REFERENCES Events(eventId)
);

INSERT INTO [Events] (eventName, isDIY, createdDate) VALUES 
('Get Started',1 , GETDATE()), 
('Interview',1 , GETDATE()),
('Government Slips',1 , GETDATE()),
('Credits and Deductions',1 , GETDATE()),
('Wrap Up',1 , GETDATE()),
('File',1 , GETDATE());

INSERT INTO UserActivity (returnId, sessionDate, username, isDIY, createdDate)
VALUES 
(2699, GETDATE(), 'Adwaith Radhakrishnan',1 , GETDATE()),
(2569, GETDATE(), 'Alicia Thomas',1 , GETDATE()),
(2396, GETDATE(), 'John Benny',1 , GETDATE());

INSERT INTO EventStatus (returnId, eventId, status, error, createdDate)
VALUES
('2699', (SELECT eventId FROM Events WHERE eventName = 'Get Started'), 2, 'You forgot to enter your social insurance number. [error code: 426]', GETDATE()),
('2699', (SELECT eventId FROM Events WHERE eventName = 'Interview'), 1, NULL, GETDATE()),
('2699', (SELECT eventId FROM Events WHERE eventName = 'Government Slips'), 1, NULL, GETDATE()),
('2699', (SELECT eventId FROM Events WHERE eventName = 'Credits and Deductions'), 2, 'It looks like you forgot to fill out a required field or answer a question. [error code: 107]', GETDATE()),
('2699', (SELECT eventId FROM Events WHERE eventName = 'Wrap Up'), 1, NULL, GETDATE()),
('2699', (SELECT eventId FROM Events WHERE eventName = 'File'), 1, NULL, GETDATE()),

('2569', (SELECT eventId FROM Events WHERE eventName = 'Get Started'), 2, 'You forgot to enter a postal code. [error code: 428]', GETDATE()),
('2569', (SELECT eventId FROM Events WHERE eventName = 'Interview'), 1, NULL, GETDATE()),
('2569', (SELECT eventId FROM Events WHERE eventName = 'Government Slips'), 1, NULL, GETDATE()),
('2569', (SELECT eventId FROM Events WHERE eventName = 'Credits and Deductions'), 2, 'It looks like you forgot to fill out a required field or answer a question. [error code: 107]', GETDATE()),
('2569', (SELECT eventId FROM Events WHERE eventName = 'Wrap Up'), 1, NULL, GETDATE()),
('2569', (SELECT eventId FROM Events WHERE eventName = 'File'), 1, NULL, GETDATE()),

('2396', (SELECT eventId FROM Events WHERE eventName = 'Get Started'), 1, NULL, GETDATE()),
('2396', (SELECT eventId FROM Events WHERE eventName = 'Interview'), 1, NULL, GETDATE()),
('2396', (SELECT eventId FROM Events WHERE eventName = 'Government Slips'), 1, NULL, GETDATE()),
('2396', (SELECT eventId FROM Events WHERE eventName = 'Credits and Deductions'), 1, NULL, GETDATE()),
('2396', (SELECT eventId FROM Events WHERE eventName = 'Wrap Up'), 1, NULL, GETDATE()),
('2396', (SELECT eventId FROM Events WHERE eventName = 'File'), 1, NULL, GETDATE());

select * from [Events]
select * from UserActivity
select * from EventStatus
