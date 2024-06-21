USE [Cangonito]
GO
/****** Object:  StoredProcedure [dbo].[SaveUserActivities]    Script Date: 6/21/2024 12:50:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('SaveUserActivities', 'P') IS NOT NULL
    DROP PROCEDURE SaveUserActivities;
GO
-- =============================================
-- Author:		Adwaith R Krishnan
-- Create date: June 21, 2024
-- Description:	Save User Activities
-- ============================================= 
CREATE PROCEDURE SaveUserActivities
    @Mode INT,
    @ReturnId INT = NULL,
    @SessionDate DATETIME = NULL,
    @Username NVARCHAR(255) = NULL,
    @EventName NVARCHAR(255) = NULL,
    @Status INT = NULL,
    @Error NVARCHAR(MAX) = NULL,
	@EventId INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @Mode = 1
    BEGIN
        -- Insert into UserActivity
        INSERT INTO UserActivity (returnId, sessionDate, username, isDIY, createdDate)
        VALUES (@ReturnId, @SessionDate, @Username, 0, GETDATE());
    END
    ELSE IF @Mode = 2
    BEGIN
        -- Insert into Events if not exists and get EventId
        IF NOT EXISTS (SELECT 1 FROM Events WHERE eventName = @EventName)
        BEGIN
            INSERT INTO Events (eventName, isDIY, createdDate)
            VALUES (@EventName, 0, GETDATE());
            SET @EventId = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            SELECT @EventId = eventId FROM Events WHERE eventName = @EventName;
        END
    END
    ELSE IF @Mode = 3
    BEGIN
        -- Insert into EventStatus
        INSERT INTO EventStatus (returnId, eventId, [status], error, createdDate)
        VALUES (@ReturnId, @EventId, @Status, @Error, GETDATE());
    END
END
GO

