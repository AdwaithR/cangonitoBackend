using Cangonito.Controllers.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;

namespace Cangonito.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserActivityController : ControllerBase
    {
        private readonly string connectionString;

        public UserActivityController(IConfiguration configuration)
        {
            connectionString = configuration["ConnectionStrings:SqlServerDb"] ?? "";
        }

        [HttpGet]
        public IActionResult GetUserActivities()
        {
            List<UserActivity> userActivities = new List<UserActivity>();
            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string sql = @"
                    SELECT 
                        ua.returnId, 
                        ua.sessionId, 
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
                        ua.returnId, es.id";

                    using (var command = new SqlCommand(sql, connection))
                    {
                        using (var reader = command.ExecuteReader())
                        {
                            Dictionary<int, UserActivity> userActivityDict = new Dictionary<int, UserActivity>();

                            while (reader.Read())
                            {
                                int returnId = reader.GetInt32(0);
                                if (!userActivityDict.ContainsKey(returnId))
                                {
                                    userActivityDict[returnId] = new UserActivity
                                    {
                                        ReturnId = returnId,
                                        SessionId = reader.GetInt32(1),
                                        Username = reader.GetString(2),
                                        Status = "Pending", // Default status is set to Pending
                                        Events = new List<EventStatus>()
                                    };
                                }

                                EventStatus eventDict = new EventStatus
                                {
                                    EventName = reader.GetString(3),
                                    StatusId = reader.GetInt32(4),
                                    Status = GetEventStatus(reader.GetInt32(4)),
                                };
                                if (!reader.IsDBNull(5))
                                {
                                    eventDict.Error = reader.GetString(5);
                                }
                                userActivityDict[returnId].Events.Add(eventDict);

                                // Update overall status based on event status
                                if (eventDict.StatusId == 2)
                                {
                                    userActivityDict[returnId].Status = "Failed";
                                }
                                else if (userActivityDict[returnId].Status != "Failed" && eventDict.StatusId == 1)
                                {
                                    userActivityDict[returnId].Status = "Success";
                                }
                            }

                            userActivities = new List<UserActivity>(userActivityDict.Values);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("UserActivity", "Exception Occurred: " + ex.Message);
                return BadRequest(ModelState);
            }
            return Ok(userActivities);
        }

        [HttpPost]
        public IActionResult PostUserActivity([FromBody] UserActivity userActivity)
        {
            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    using (var transaction = connection.BeginTransaction())
                    {
                        try
                        {
                            // Insert into UserActivity
                            string userActivitySql = @"
                            INSERT INTO UserActivity (returnId, sessionId, username)
                            VALUES (@ReturnId, @SessionId, @Username)";

                            using (var userActivityCommand = new SqlCommand(userActivitySql, connection, transaction))
                            {
                                userActivityCommand.Parameters.AddWithValue("@ReturnId", userActivity.ReturnId);
                                userActivityCommand.Parameters.AddWithValue("@SessionId", userActivity.SessionId);
                                userActivityCommand.Parameters.AddWithValue("@Username", userActivity.Username);
                                userActivityCommand.ExecuteNonQuery();
                            }

                            // Insert into EventStatus and Events
                            foreach (var eventItem in userActivity.Events)
                            {
                                string eventSql = @"
                                IF NOT EXISTS (SELECT 1 FROM Events WHERE eventName = @EventName)
                                BEGIN
                                    INSERT INTO Events (eventName)
                                    VALUES (@EventName);
                                    SET @EventId = SCOPE_IDENTITY();
                                END
                                ELSE
                                BEGIN
                                    SELECT @EventId = eventId FROM Events WHERE eventName = @EventName;
                                END";

                                int eventId;

                                using (var eventCommand = new SqlCommand(eventSql, connection, transaction))
                                {
                                    eventCommand.Parameters.AddWithValue("@EventName", eventItem.EventName);
                                    var eventIdParam = new SqlParameter("@EventId", System.Data.SqlDbType.Int) { Direction = System.Data.ParameterDirection.Output };
                                    eventCommand.Parameters.Add(eventIdParam);
                                    eventCommand.ExecuteNonQuery();
                                    eventId = (int)eventIdParam.Value;
                                }

                                string eventStatusSql = @"
                                INSERT INTO EventStatus (returnId, eventId, status, error)
                                VALUES (@ReturnId, @EventId, @EventStatus, @Error)";

                                using (var eventStatusCommand = new SqlCommand(eventStatusSql, connection, transaction))
                                {
                                    eventStatusCommand.Parameters.AddWithValue("@ReturnId", userActivity.ReturnId);
                                    eventStatusCommand.Parameters.AddWithValue("@EventId", eventId);
                                    eventStatusCommand.Parameters.AddWithValue("@EventStatus", eventItem.StatusId);
                                    eventStatusCommand.Parameters.AddWithValue("@Error", (object)eventItem.Error ?? DBNull.Value);
                                    eventStatusCommand.ExecuteNonQuery();
                                }
                            }

                            // Commit the transaction
                            transaction.Commit();
                        }
                        catch (Exception ex)
                        {
                            // Rollback the transaction if any exception occurs
                            transaction.Rollback();
                            ModelState.AddModelError("UserActivity", "Exception Occurred: " + ex.Message);
                            return BadRequest(ModelState);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("UserActivity", "Exception Occurred: " + ex.Message);
                return BadRequest(ModelState);
            }
            return Ok("Data inserted successfully");
        }

        private string GetEventStatus(int status)
        {
            switch (status)
            {
                case 1:
                    return "Completed";
                case 2:
                    return "Failed";
                default:
                    return "Unknown";
            }
        }
    }
}
