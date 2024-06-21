using Cangonito.Models;
using Cangonito.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;

namespace Cangonito.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserActivityController : ControllerBase
    {
        private readonly string connectionString;
        private readonly UserActivityService _userActivityService;
        public UserActivityController(IConfiguration configuration, UserActivityService userActivityService)
        {
            connectionString = configuration["ConnectionStrings:SqlServerDb"] ?? "";
            _userActivityService = userActivityService;
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
                    string storedProcedure = "GetUserActivities";

                    using (var command = new SqlCommand(storedProcedure, connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

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
                                        SessionDate = reader.GetDateTime(1),
                                        UserName = reader.GetString(2),
                                        IsDIY = reader.GetBoolean(3),
                                        Status = "Success",
                                        Events = new List<EventStatus>()
                                    };
                                }

                                EventStatus eventDict = new EventStatus
                                {
                                    EventName = reader.GetString(4),
                                    StatusId = reader.GetInt32(5),
                                    Status = _userActivityService.GetEventStatus(reader.GetInt32(5)),
                                };
                                if (!reader.IsDBNull(6))
                                {
                                    eventDict.Error = reader.GetString(6);
                                }
                                userActivityDict[returnId].Events.Add(eventDict);

                                // Update overall status based on event status
                                if (eventDict.StatusId == 2) // Failed
                                {
                                    userActivityDict[returnId].Status = "Failed";
                                }
                                else if (userActivityDict[returnId].Status != "Failed" && eventDict.StatusId == 1) // Completed
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

        //[HttpPost]
        //public IActionResult PostUserActivity([FromBody] UserActivity userActivity)
        //{
        //    try
        //    {
        //        using (var connection = new SqlConnection(connectionString))
        //        {
        //            connection.Open();

        //            using (var transaction = connection.BeginTransaction())
        //            {
        //                try
        //                {
        //                    // Insert into UserActivity using stored procedure with Mode = 1
        //                    using (var userActivityCommand = new SqlCommand("SaveUserActivities", connection, transaction))
        //                    {
        //                        userActivityCommand.CommandType = CommandType.StoredProcedure;
        //                        userActivityCommand.Parameters.AddWithValue("@Mode", 1);
        //                        userActivityCommand.Parameters.AddWithValue("@ReturnId", userActivity.ReturnId);
        //                        userActivityCommand.Parameters.AddWithValue("@SessionDate", userActivity.SessionDate);
        //                        userActivityCommand.Parameters.AddWithValue("@Username", userActivity.Username);
        //                        userActivityCommand.ExecuteNonQuery();
        //                    }

        //                    // Insert into EventStatus and Events using stored procedures with Mode = 2 and 3
        //                    foreach (var eventItem in userActivity.Events)
        //                    {
        //                        int eventId;

        //                        // Insert into Events table if not exists and get EventId using stored procedure with Mode = 2
        //                        using (var eventCommand = new SqlCommand("SaveUserActivities", connection, transaction))
        //                        {
        //                            eventCommand.CommandType = CommandType.StoredProcedure;
        //                            eventCommand.Parameters.AddWithValue("@Mode", 2);
        //                            eventCommand.Parameters.AddWithValue("@EventName", eventItem.EventName);

        //                            // Add @EventId as OUTPUT parameter
        //                            SqlParameter eventIdParam = new SqlParameter("@EventId", SqlDbType.Int);
        //                            eventIdParam.Direction = ParameterDirection.Output;
        //                            eventCommand.Parameters.Add(eventIdParam);

        //                            eventCommand.ExecuteNonQuery();

        //                            // Retrieve the value of @EventId after executing the stored procedure
        //                            eventId = Convert.ToInt32(eventCommand.Parameters["@EventId"].Value);
        //                        }

        //                        // Insert into EventStatus table using stored procedure with Mode = 3
        //                        using (var eventStatusCommand = new SqlCommand("SaveUserActivities", connection, transaction))
        //                        {
        //                            eventStatusCommand.CommandType = CommandType.StoredProcedure;
        //                            eventStatusCommand.Parameters.AddWithValue("@Mode", 3);
        //                            eventStatusCommand.Parameters.AddWithValue("@ReturnId", userActivity.ReturnId);
        //                            eventStatusCommand.Parameters.AddWithValue("@EventId", eventId);
        //                            eventStatusCommand.Parameters.AddWithValue("@Status", eventItem.StatusId);
        //                            eventStatusCommand.Parameters.AddWithValue("@Error", (object)eventItem.Error ?? DBNull.Value);
        //                            eventStatusCommand.ExecuteNonQuery();
        //                        }
        //                    }

        //                    // Commit the transaction
        //                    transaction.Commit();
        //                }
        //                catch (Exception ex)
        //                {
        //                    // Rollback the transaction if any exception occurs
        //                    transaction.Rollback();
        //                    ModelState.AddModelError("UserActivity", "Exception Occurred: " + ex.Message);
        //                    return BadRequest(ModelState);
        //                }
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        ModelState.AddModelError("UserActivity", "Exception Occurred: " + ex.Message);
        //        return BadRequest(ModelState);
        //    }
        //    return Ok("Data inserted successfully");
        //}

        [HttpPost("activity")]
        public async Task<IActionResult> PostActivity([FromBody] UserActivity userActivity)
        {
            if (userActivity == null)
            {
                return BadRequest("UserActivity is null.");
            }

            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    await connection.OpenAsync();

                    string storedProcedure = "SaveUserActivities";

                    using (var command = new SqlCommand(storedProcedure, connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@Mode", 1);
                        command.Parameters.AddWithValue("@ReturnId", userActivity.ReturnId);
                        command.Parameters.AddWithValue("@SessionDate", userActivity.SessionDate);
                        command.Parameters.AddWithValue("@Username", userActivity.UserName);

                        await command.ExecuteNonQueryAsync();
                    }
                }

                return Ok("Data inserted successfully");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("UserActivity", "Exception Occurred: " + ex.Message);
                return BadRequest(ModelState);
            }
        }

        [HttpPost("events")]
        public async Task<IActionResult> AddActivity([FromBody] UserActivity userActivity)
        {
            if (userActivity == null)
            {
                return BadRequest("UserActivity is null.");
            }

            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    await connection.OpenAsync();

                    // Check if the ReturnId exists
                    bool returnIdExists;
                    using (var checkCommand = new SqlCommand("SELECT COUNT(1) FROM UserActivity WHERE returnId = @ReturnId", connection))
                    {
                        checkCommand.Parameters.AddWithValue("@ReturnId", userActivity.ReturnId);
                        returnIdExists = (int)await checkCommand.ExecuteScalarAsync() > 0;
                    }

                    if (!returnIdExists)
                    {
                        return BadRequest("ReturnId does not exists.");
                    }

                    using (var transaction = connection.BeginTransaction())
                    {
                        try
                        {
                            foreach (var eventItem in userActivity.Events)
                            {
                                int eventId;

                                // Insert into Events table if not exists and get EventId using stored procedure with Mode = 2
                                using (var eventCommand = new SqlCommand("SaveUserActivities", connection, transaction))
                                {
                                    eventCommand.CommandType = CommandType.StoredProcedure;
                                    eventCommand.Parameters.AddWithValue("@Mode", 2);
                                    eventCommand.Parameters.AddWithValue("@EventName", eventItem.EventName);

                                    // Add @EventId as OUTPUT parameter
                                    SqlParameter eventIdParam = new SqlParameter("@EventId", SqlDbType.Int)
                                    {
                                        Direction = ParameterDirection.Output
                                    };
                                    eventCommand.Parameters.Add(eventIdParam);

                                    await eventCommand.ExecuteNonQueryAsync();

                                    // Retrieve the value of @EventId after executing the stored procedure
                                    eventId = Convert.ToInt32(eventCommand.Parameters["@EventId"].Value);
                                }

                                // Insert into EventStatus table using stored procedure with Mode = 3
                                using (var eventStatusCommand = new SqlCommand("SaveUserActivities", connection, transaction))
                                {
                                    eventStatusCommand.CommandType = CommandType.StoredProcedure;
                                    eventStatusCommand.Parameters.AddWithValue("@Mode", 3);
                                    eventStatusCommand.Parameters.AddWithValue("@ReturnId", userActivity.ReturnId);
                                    eventStatusCommand.Parameters.AddWithValue("@EventId", eventId);
                                    eventStatusCommand.Parameters.AddWithValue("@Status", eventItem.StatusId);
                                    eventStatusCommand.Parameters.AddWithValue("@Error", (object)eventItem.Error ?? DBNull.Value);

                                    await eventStatusCommand.ExecuteNonQueryAsync();
                                }
                            }

                            transaction.Commit();
                        }
                        catch (Exception)
                        {
                            transaction.Rollback();
                            throw;
                        }
                    }
                }

                return Ok("Data inserted successfully");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
    }
}
