USE [Cangonito]

DROP TABLE [dbo].[EventStatus];
DROP TABLE [dbo].[Events];
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
    error VARCHAR(max),
	createdDate DATETIME,
    FOREIGN KEY (returnId) REFERENCES UserActivity(returnId),
    FOREIGN KEY (eventId) REFERENCES Events(eventId)
);

-------------------------------------------------DIY DATA-----------------------------------------------------------

INSERT INTO [Events] (eventName, isDIY, createdDate) VALUES 
('Get Started',1 , '2024-06-01 17:38:14.820'), 
('Interview',1 , '2024-06-01 17:38:14.820'),
('Government Slips',1 , '2024-06-01 17:38:14.820'),
('Credits and Deductions',1 , '2024-06-1 17:38:14.820'),
('Wrap Up',1 , '2024-06-01 17:38:14.820'),
('File',1 , '2024-06-01 17:38:14.820');

INSERT INTO UserActivity (returnId, sessionDate, username, isDIY, createdDate)
VALUES 
(2699, '2024-06-02 20:38:14.820', 'Adwaith Radhakrishnan', 1, '2024-06-02 20:38:14.820'),
(2569, '2024-06-02 20:38:14.820', 'Alicia Thomas', 1, '2024-06-02 20:38:14.820'),
(2396, '2024-06-02 20:38:14.820', 'John Benny', 1, '2024-06-02 20:38:14.820'),
(2750, '2024-06-03 14:38:14.820', 'Emma Watson', 1, '2024-06-03 14:38:14.820'),
(2873, '2024-06-03 14:38:14.820', 'Oliver Smith', 1, '2024-06-03 14:38:14.820'),
(2934, '2024-06-10 11:38:14.811', 'Sophia Johnson', 1, '2024-06-10 11:38:14.811'),
(3056, '2024-06-10 11:38:14.811', 'Liam Williams', 1, '2024-06-10 11:38:14.811'),
(3145, '2024-06-22 11:23:14.811', 'Ava Brown', 1, '2024-06-22 11:23:14.811'),
(3217, '2024-06-22 11:23:14.811', 'William Jones', 1, '2024-06-22 11:23:14.811'),
(3338, '2024-06-22 11:23:14.811', 'Mia Garcia', 1, '2024-06-22 11:23:14.811');

INSERT INTO EventStatus (returnId, eventId, status, error, createdDate)
VALUES
('2699', (SELECT eventId FROM Events WHERE eventName = 'Get Started' AND isDIY = 1), 2, 'You forgot to enter your social insurance number. [error code: 426]', '2024-06-02 20:38:14.820'),
('2699', (SELECT eventId FROM Events WHERE eventName = 'Interview' AND isDIY = 1), 1, NULL, '2024-06-02 20:38:14.820'),
('2699', (SELECT eventId FROM Events WHERE eventName = 'Government Slips' AND isDIY = 1), 1, NULL, '2024-06-02 20:38:14.820'),
('2699', (SELECT eventId FROM Events WHERE eventName = 'Credits and Deductions' AND isDIY = 1), 2, 'It looks like you forgot to fill out a required field or answer a question. [error code: 107]', '2024-06-02 20:38:14.820'),
('2699', (SELECT eventId FROM Events WHERE eventName = 'Wrap Up' AND isDIY = 1), 1, NULL, '2024-06-02 20:38:14.820'),
('2699', (SELECT eventId FROM Events WHERE eventName = 'File' AND isDIY = 1), 1, NULL, '2024-06-02 20:38:14.820'),

('2569', (SELECT eventId FROM Events WHERE eventName = 'Get Started' AND isDIY = 1), 2, 'You forgot to enter a postal code. [error code: 428]', '2024-06-02 20:38:14.820'),
('2569', (SELECT eventId FROM Events WHERE eventName = 'Interview' AND isDIY = 1), 1, NULL, '2024-06-02 20:38:14.820'),
('2569', (SELECT eventId FROM Events WHERE eventName = 'Government Slips' AND isDIY = 1), 1, NULL, '2024-06-02 20:38:14.820'),
('2569', (SELECT eventId FROM Events WHERE eventName = 'Credits and Deductions' AND isDIY = 1), 2, 'It looks like you forgot to fill out a required field or answer a question. [error code: 107]', '2024-06-02 20:38:14.820'),
('2569', (SELECT eventId FROM Events WHERE eventName = 'Wrap Up' AND isDIY = 1), 1, NULL, '2024-06-02 20:38:14.820'),
('2569', (SELECT eventId FROM Events WHERE eventName = 'File' AND isDIY = 1), 1, NULL, '2024-06-02 20:38:14.820'),

('2396', (SELECT eventId FROM Events WHERE eventName = 'Get Started' AND isDIY = 1), 1, NULL, '2024-06-02 20:38:14.820'),
('2396', (SELECT eventId FROM Events WHERE eventName = 'Interview' AND isDIY = 1), 1, NULL, '2024-06-02 20:38:14.820'),
('2396', (SELECT eventId FROM Events WHERE eventName = 'Government Slips' AND isDIY = 1), 1, NULL, '2024-06-02 20:38:14.820'),
('2396', (SELECT eventId FROM Events WHERE eventName = 'Credits and Deductions' AND isDIY = 1), 1, NULL, '2024-06-02 20:38:14.820'),
('2396', (SELECT eventId FROM Events WHERE eventName = 'Wrap Up' AND isDIY = 1), 1, NULL, '2024-06-02 20:38:14.820'),
('2396', (SELECT eventId FROM Events WHERE eventName = 'File' AND isDIY = 1), 1, NULL, '2024-06-02 20:38:14.820'),

('2750', (SELECT eventId FROM Events WHERE eventName = 'Get Started' AND isDIY = 1), 2, 'It looks like you forgot to fill out a required field or answer a question. [error code: 107]', '2024-06-03 14:38:14.820'),
('2750', (SELECT eventId FROM Events WHERE eventName = 'Interview' AND isDIY = 1), 1, NULL, '2024-06-03 14:38:14.820'),
('2750', (SELECT eventId FROM Events WHERE eventName = 'Government Slips' AND isDIY = 1), 1, NULL, '2024-06-03 14:38:14.820'),
('2750', (SELECT eventId FROM Events WHERE eventName = 'Credits and Deductions' AND isDIY = 1), 1, NULL, '2024-06-03 14:38:14.820'),
('2750', (SELECT eventId FROM Events WHERE eventName = 'Wrap Up' AND isDIY = 1), 1, NULL, '2024-06-03 14:38:14.820'),
('2750', (SELECT eventId FROM Events WHERE eventName = 'File' AND isDIY = 1), 1, NULL, '2024-06-03 14:38:14.820'),

('2873', (SELECT eventId FROM Events WHERE eventName = 'Get Started' AND isDIY = 1), 2, 'You forgot to enter a postal code. [error code: 428]', '2024-06-03 14:38:14.820'),
('2873', (SELECT eventId FROM Events WHERE eventName = 'Interview' AND isDIY = 1), 1, NULL, '2024-06-03 14:38:14.820'),
('2873', (SELECT eventId FROM Events WHERE eventName = 'Government Slips' AND isDIY = 1), 1, NULL, '2024-06-03 14:38:14.820'),
('2873', (SELECT eventId FROM Events WHERE eventName = 'Credits and Deductions' AND isDIY = 1), 1, NULL, '2024-06-03 14:38:14.820'),
('2873', (SELECT eventId FROM Events WHERE eventName = 'Wrap Up' AND isDIY = 1), 1, NULL, '2024-06-03 14:38:14.820'),
('2873', (SELECT eventId FROM Events WHERE eventName = 'File' AND isDIY = 1), 1, NULL, '2024-06-03 14:38:14.820'),

('2934', (SELECT eventId FROM Events WHERE eventName = 'Get Started' AND isDIY = 1), 2, 'You forgot to enter your social insurance number. [error code: 426]', '2024-06-10 11:38:14.811'),
('2934', (SELECT eventId FROM Events WHERE eventName = 'Interview' AND isDIY = 1), 1, NULL, '2024-06-10 11:38:14.811'),
('2934', (SELECT eventId FROM Events WHERE eventName = 'Government Slips' AND isDIY = 1), 1, NULL, '2024-06-10 11:38:14.811'),
('2934', (SELECT eventId FROM Events WHERE eventName = 'Credits and Deductions' AND isDIY = 1), 1, NULL, '2024-06-10 11:38:14.811'),
('2934', (SELECT eventId FROM Events WHERE eventName = 'Wrap Up' AND isDIY = 1), 1, NULL, '2024-06-10 11:38:14.811'),
('2934', (SELECT eventId FROM Events WHERE eventName = 'File' AND isDIY = 1), 1, NULL, '2024-06-10 11:38:14.811'),

('3056', (SELECT eventId FROM Events WHERE eventName = 'Get Started' AND isDIY = 1), 1, NULL, '2024-06-10 11:38:14.811'),
('3056', (SELECT eventId FROM Events WHERE eventName = 'Interview' AND isDIY = 1), 1, NULL, '2024-06-10 11:38:14.811'),
('3056', (SELECT eventId FROM Events WHERE eventName = 'Government Slips' AND isDIY = 1), 1, NULL, '2024-06-10 11:38:14.811'),
('3056', (SELECT eventId FROM Events WHERE eventName = 'Credits and Deductions' AND isDIY = 1), 1, NULL, '2024-06-10 11:38:14.811'),
('3056', (SELECT eventId FROM Events WHERE eventName = 'Wrap Up' AND isDIY = 1), 1, NULL, '2024-06-10 11:38:14.811'),
('3056', (SELECT eventId FROM Events WHERE eventName = 'File' AND isDIY = 1), 1, NULL, '2024-06-10 11:38:14.811'),

('3145', (SELECT eventId FROM Events WHERE eventName = 'Get Started' AND isDIY = 1), 1, NULL, '2024-06-22 11:23:14.811'),
('3145', (SELECT eventId FROM Events WHERE eventName = 'Interview' AND isDIY = 1), 2, NULL, '2024-06-22 11:23:14.811'),
('3145', (SELECT eventId FROM Events WHERE eventName = 'Government Slips' AND isDIY = 1), 1, NULL, '2024-06-22 11:23:14.811'),
('3145', (SELECT eventId FROM Events WHERE eventName = 'Credits and Deductions' AND isDIY = 1), 1, NULL, '2024-06-22 11:23:14.811'),
('3145', (SELECT eventId FROM Events WHERE eventName = 'Wrap Up' AND isDIY = 1), 1, NULL, '2024-06-22 11:23:14.811'),
('3145', (SELECT eventId FROM Events WHERE eventName = 'File' AND isDIY = 1), 1, NULL, '2024-06-22 11:23:14.811'),

('3217', (SELECT eventId FROM Events WHERE eventName = 'Get Started' AND isDIY = 1), 2, 'You forgot to enter a postal code. [error code: 428]', '2024-06-22 11:23:14.811'),
('3217', (SELECT eventId FROM Events WHERE eventName = 'Interview' AND isDIY = 1), 1, NULL, '2024-06-22 11:23:14.811'),
('3217', (SELECT eventId FROM Events WHERE eventName = 'Government Slips' AND isDIY = 1), 1, NULL, '2024-06-22 11:23:14.811'),
('3217', (SELECT eventId FROM Events WHERE eventName = 'Credits and Deductions' AND isDIY = 1), 1, NULL, '2024-06-22 11:23:14.811'),
('3217', (SELECT eventId FROM Events WHERE eventName = 'Wrap Up' AND isDIY = 1), 1, NULL, '2024-06-22 11:23:14.811'),
('3217', (SELECT eventId FROM Events WHERE eventName = 'File' AND isDIY = 1), 1, NULL, '2024-06-22 11:23:14.811'),

('3338', (SELECT eventId FROM Events WHERE eventName = 'Get Started' AND isDIY = 1), 1, NULL, '2024-06-22 11:23:14.811'),
('3338', (SELECT eventId FROM Events WHERE eventName = 'Interview' AND isDIY = 1), 1, NULL, '2024-06-22 11:23:14.811'),
('3338', (SELECT eventId FROM Events WHERE eventName = 'Government Slips' AND isDIY = 1), 1, NULL, '2024-06-22 11:23:14.811'),
('3338', (SELECT eventId FROM Events WHERE eventName = 'Credits and Deductions' AND isDIY = 1), 2, 'You forgot to select your tax filing status. [error code: 434]', '2024-06-22 11:23:14.811'),
('3338', (SELECT eventId FROM Events WHERE eventName = 'Wrap Up' AND isDIY = 1), 1, NULL, '2024-06-22 11:23:14.811'),
('3338', (SELECT eventId FROM Events WHERE eventName = 'File' AND isDIY = 1), 1, NULL, '2024-06-22 11:23:14.811');

------------------------------------------------TPSC DATA-----------------------------------------------------------

INSERT INTO [Events] (eventName, isDIY, createdDate) VALUES 
('interview',0 , '2024-06-01 17:11:13.821'), 
('tax',0 , '2024-06-01 17:11:13.821'),
('cra',0 , '2024-06-01 17:11:13.821'),
('return builder ',0 , '2024-06-01 17:11:13.821'),
('optimization',0 , '2024-06-01 17:11:13.821'),
('RC269',0 , '2024-06-01 17:11:13.821'),
('T183',0 , '2024-06-01 17:11:13.821'),
('Efile',0 , '2024-06-01 17:11:13.821');

INSERT INTO UserActivity (returnId, sessionDate, username, isDIY, createdDate)
VALUES 
(2608, '2024-06-10 17:11:13.821', 'Rethnamol Gnanakesari', 0, '2024-06-10 17:11:13.821'),
(2621, '2024-06-10 17:11:13.821', 'Jeniffer Mary', 0, '2024-06-10 17:11:13.821'),
(2648, '2024-06-18 19:11:13.821', 'Vick Doe', 0, '2024-06-18 19:11:13.821'),
(2653, '2024-06-20 12:21:13.811', 'Sarah Connor', 0, '2024-06-20 12:21:13.811'),
(2672, '2024-06-20 12:21:13.811', 'Michael Jordan', 0, '2024-06-20 12:21:13.811'),
(2691, '2024-06-22 18:23:14.811', 'Emily Stone', 0, '2024-06-22 18:23:14.811'),
(2710, '2024-06-22 18:23:14.811', 'David Beckham', 0, '2024-06-22 18:23:14.811'),
(2727, '2024-06-22 18:23:14.811', 'Sophie Loren', 0, '2024-06-22 18:23:14.811');

INSERT INTO EventStatus (returnId, eventId, [status], error, createdDate)
VALUES
('2608', (SELECT eventId FROM Events WHERE eventName = 'interview' AND isDIY = 0), 2, 'Exception occured in EMPLOYEE_DISPLAY_NAME_DETAILS in Sidebar.js (Error: Request failed with status code 500)', '2024-06-10 17:11:13.821'),
('2608', (SELECT eventId FROM Events WHERE eventName = 'tax' AND isDIY = 0), 1, NULL, '2024-06-10 17:11:13.821'),
('2608', (SELECT eventId FROM Events WHERE eventName = 'cra' AND isDIY = 0), 1, NULL, '2024-06-10 17:11:13.821'),
('2608', (SELECT eventId FROM Events WHERE eventName = 'return builder' AND isDIY = 0), 1, NULL, '2024-06-10 17:11:13.821'),
('2608', (SELECT eventId FROM Events WHERE eventName = 'optimization' AND isDIY = 0), 1, NULL, '2024-06-10 17:11:13.821'),
('2608', (SELECT eventId FROM Events WHERE eventName = 'RC269' AND isDIY = 0), 1, NULL, '2024-06-10 17:11:13.821'),
('2608', (SELECT eventId FROM Events WHERE eventName = 'T183' AND isDIY = 0), 1, NULL, '2024-06-10 17:11:13.821'),
('2608', (SELECT eventId FROM Events WHERE eventName = 'Efile' AND isDIY = 0), 1, NULL, '2024-06-10 17:11:13.821'),

('2621', (SELECT eventId FROM Events WHERE eventName = 'interview' AND isDIY = 0), 2, 'Something went wrong in getting Created Date', '2024-06-10 17:11:13.821'),
('2621', (SELECT eventId FROM Events WHERE eventName = 'tax' AND isDIY = 0), 1, NULL, '2024-06-10 17:11:13.821'),
('2621', (SELECT eventId FROM Events WHERE eventName = 'cra' AND isDIY = 0), 1, NULL, '2024-06-10 17:11:13.821'),
('2621', (SELECT eventId FROM Events WHERE eventName = 'return builder' AND isDIY = 0), 1, NULL, '2024-06-10 17:11:13.821'),
('2621', (SELECT eventId FROM Events WHERE eventName = 'optimization' AND isDIY = 0), 1, NULL, '2024-06-10 17:11:13.821'),
('2621', (SELECT eventId FROM Events WHERE eventName = 'RC269' AND isDIY = 0), 1, NULL, '2024-06-10 17:11:13.821'),
('2621', (SELECT eventId FROM Events WHERE eventName = 'T183' AND isDIY = 0), 1, NULL, '2024-06-10 17:11:13.821'),
('2621', (SELECT eventId FROM Events WHERE eventName = 'Efile' AND isDIY = 0), 2, 'Exception occured in loadFormT183_RC71 (Error: Request failed with status code 500).', '2024-06-10 17:11:13.821'),

('2648', (SELECT eventId FROM Events WHERE eventName = 'interview' AND isDIY = 0), 1, NULL, '2024-06-18 19:11:13.821'),
('2648', (SELECT eventId FROM Events WHERE eventName = 'tax' AND isDIY = 0), 1, NULL, '2024-06-18 19:11:13.821'),
('2648', (SELECT eventId FROM Events WHERE eventName = 'cra' AND isDIY = 0), 1, NULL, '2024-06-18 19:11:13.821'),
('2648', (SELECT eventId FROM Events WHERE eventName = 'return builder' AND isDIY = 0), 1, NULL, '2024-06-18 19:11:13.821'),
('2648', (SELECT eventId FROM Events WHERE eventName = 'optimization' AND isDIY = 0), 1, NULL, '2024-06-18 19:11:13.821'),
('2648', (SELECT eventId FROM Events WHERE eventName = 'RC269' AND isDIY = 0), 1, NULL, '2024-06-18 19:11:13.821'),
('2648', (SELECT eventId FROM Events WHERE eventName = 'T183' AND isDIY = 0), 1, NULL, '2024-06-18 19:11:13.821'),
('2648', (SELECT eventId FROM Events WHERE eventName = 'Efile' AND isDIY = 0), 1, NULL, '2024-06-18 19:11:13.821'),

('2653', (SELECT eventId FROM Events WHERE eventName = 'interview' AND isDIY = 0), 2, 'Exception occurred in EMPLOYEE_DISPLAY_NAME_DETAILS in Sidebar.js (Error: Request failed with status code 500)', '2024-06-20 12:21:13.811'),
('2653', (SELECT eventId FROM Events WHERE eventName = 'tax' AND isDIY = 0), 1, NULL, '2024-06-20 12:21:13.811'),
('2653', (SELECT eventId FROM Events WHERE eventName = 'cra' AND isDIY = 0), 1, NULL, '2024-06-20 12:21:13.811'),
('2653', (SELECT eventId FROM Events WHERE eventName = 'return builder' AND isDIY = 0), 2, 'AFR/TDF]Import--AFR Import Failed Due to an error: TypeError: Cannot read properties of null (reading "SPOUSE")', '2024-06-20 12:21:13.811'),
('2653', (SELECT eventId FROM Events WHERE eventName = 'optimization' AND isDIY = 0), 1, NULL, '2024-06-20 12:21:13.811'),
('2653', (SELECT eventId FROM Events WHERE eventName = 'RC269' AND isDIY = 0), 1, NULL, '2024-06-20 12:21:13.811'),
('2653', (SELECT eventId FROM Events WHERE eventName = 'T183' AND isDIY = 0), 1, NULL, '2024-06-20 12:21:13.811'),
('2653', (SELECT eventId FROM Events WHERE eventName = 'Efile' AND isDIY = 0), 1, NULL, '2024-06-20 12:21:13.811'),

('2672', (SELECT eventId FROM Events WHERE eventName = 'interview' AND isDIY = 0), 2, 'Something went wrong in getting Created Date', '2024-06-20 12:21:13.811'),
('2672', (SELECT eventId FROM Events WHERE eventName = 'tax' AND isDIY = 0), 1, NULL, '2024-06-20 12:21:13.811'),
('2672', (SELECT eventId FROM Events WHERE eventName = 'cra' AND isDIY = 0), 1, NULL, '2024-06-20 12:21:13.811'),
('2672', (SELECT eventId FROM Events WHERE eventName = 'return builder' AND isDIY = 0), 1, NULL, '2024-06-20 12:21:13.811'),
('2672', (SELECT eventId FROM Events WHERE eventName = 'optimization' AND isDIY = 0), 1, NULL, '2024-06-20 12:21:13.811'),
('2672', (SELECT eventId FROM Events WHERE eventName = 'RC269' AND isDIY = 0), 1, NULL, '2024-06-20 12:21:13.811'),
('2672', (SELECT eventId FROM Events WHERE eventName = 'T183' AND isDIY = 0), 1, NULL, '2024-06-20 12:21:13.811'),
('2672', (SELECT eventId FROM Events WHERE eventName = 'Efile' AND isDIY = 0), 1, NULL, '2024-06-20 12:21:13.811'),

('2691', (SELECT eventId FROM Events WHERE eventName = 'interview' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2691', (SELECT eventId FROM Events WHERE eventName = 'tax' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2691', (SELECT eventId FROM Events WHERE eventName = 'cra' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2691', (SELECT eventId FROM Events WHERE eventName = 'return builder' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2691', (SELECT eventId FROM Events WHERE eventName = 'optimization' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2691', (SELECT eventId FROM Events WHERE eventName = 'RC269' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2691', (SELECT eventId FROM Events WHERE eventName = 'T183' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2691', (SELECT eventId FROM Events WHERE eventName = 'Efile' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),

('2710', (SELECT eventId FROM Events WHERE eventName = 'interview' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2710', (SELECT eventId FROM Events WHERE eventName = 'tax' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2710', (SELECT eventId FROM Events WHERE eventName = 'cra' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2710', (SELECT eventId FROM Events WHERE eventName = 'return builder' AND isDIY = 0), 2, 'AFR/TDF]Import--AFR Import Failed Due to an error: TypeError: Cannot read properties of null (reading "SPOUSE")', '2024-06-22 18:23:14.811'),
('2710', (SELECT eventId FROM Events WHERE eventName = 'optimization' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2710', (SELECT eventId FROM Events WHERE eventName = 'RC269' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2710', (SELECT eventId FROM Events WHERE eventName = 'T183' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2710', (SELECT eventId FROM Events WHERE eventName = 'Efile' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),

('2727', (SELECT eventId FROM Events WHERE eventName = 'interview' AND isDIY = 0), 2, 'Something went wrong in getting Created Date', '2024-06-22 18:23:14.811'),
('2727', (SELECT eventId FROM Events WHERE eventName = 'tax' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2727', (SELECT eventId FROM Events WHERE eventName = 'cra' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2727', (SELECT eventId FROM Events WHERE eventName = 'return builder' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2727', (SELECT eventId FROM Events WHERE eventName = 'optimization' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2727', (SELECT eventId FROM Events WHERE eventName = 'RC269' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2727', (SELECT eventId FROM Events WHERE eventName = 'T183' AND isDIY = 0), 1, NULL, '2024-06-22 18:23:14.811'),
('2727', (SELECT eventId FROM Events WHERE eventName = 'Efile' AND isDIY = 0), 2, 'Exception occurred in loadFormT183_RC71 (Error: Request failed with status code 500).', '2024-06-22 18:23:14.811');

--------------------------------------------------------------------------------------------------------

select * from [Events]
select * from UserActivity
select * from EventStatus