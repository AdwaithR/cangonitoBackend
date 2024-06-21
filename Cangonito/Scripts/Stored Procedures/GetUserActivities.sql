USE [Cangonito]
GO
/****** Object:  StoredProcedure [dbo].[GetUserActivities]    Script Date: 6/21/2024 12:50:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('GetUserActivities', 'P') IS NOT NULL
    DROP PROCEDURE GetUserActivities;
GO
-- =============================================
-- Author:		Adwaith R Krishnan
-- Create date: June 21, 2024
-- Description:	Get User Activities
-- ============================================= 
CREATE PROCEDURE GetUserActivities
AS
BEGIN
    SELECT 
        ua.returnId, 
        ua.sessionDate, 
        ua.username, 
        e.eventName, 
        es.status, 
        es.error
    FROM 
        UserActivity ua
    JOIN 
        EventStatus es ON ua.returnId = es.returnId
    JOIN 
        Events e ON es.eventId = e.eventId
    ORDER BY 
        ua.returnId, es.id
END
GO
