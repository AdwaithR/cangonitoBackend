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

        //[HttpPost]
        //public IActionResult CreateClient(ClientDto clientDto)
        //{
        //    try
        //    {
        //        using (var connection = new SqlConnection(connectionString))
        //        {
        //            connection.Open();
        //            string sql = "INSERT INTO [dbo].[clients]" +
        //               "([name],[location]) VALUES" +
        //               "(@name, @location)";
        //            using (var command = new SqlCommand(sql, connection))
        //            {
        //                command.Parameters.AddWithValue("@name", clientDto.Name);
        //                command.Parameters.AddWithValue("@location", clientDto.Location);
        //                command.ExecuteNonQuery();
        //            }
        //        }

        //    }
        //    catch (Exception ex)
        //    {
        //        ModelState.AddModelError("Client", "Exception Occurred");
        //        return BadRequest(ModelState);
        //    }
        //    return Ok();
        //}      

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
                        es.status AS eventStatus, 
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
                            Dictionary<string, UserActivity> userActivityDict = new Dictionary<string, UserActivity>();

                            while (reader.Read())
                            {
                                string returnId = reader.GetString(0);
                                if (!userActivityDict.ContainsKey(returnId))
                                {
                                    userActivityDict[returnId] = new UserActivity
                                    {
                                        ReturnId = returnId,
                                        SessionId = reader.GetString(1),
                                        Username = reader.GetString(2),
                                        Status = "Pending", // Default status is set to Pending
                                        Events = new List<Dictionary<string, object>>()
                                    };
                                }

                                var eventName = reader.GetString(3);
                                var eventStatus = GetEventStatus(reader.GetInt32(4)); // Convert integer status to string
                                var eventEntry = new Dictionary<string, object>
                            {
                                { eventName, eventStatus }
                            };

                                if (!reader.IsDBNull(5))
                                {
                                    eventEntry.Add("error", reader.GetString(5));
                                }

                                userActivityDict[returnId].Events.Add(eventEntry);

                                // Update overall status based on event status
                                if (eventStatus == "Failed")
                                {
                                    userActivityDict[returnId].Status = "Failed";
                                }
                                else if (userActivityDict[returnId].Status != "Failed" && eventStatus == "Completed")
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

        // Helper method to map integer status to string status
        private string GetEventStatus(int status)
        {
            switch (status)
            {
                case 1:
                    return "Pending";
                case 2:
                    return "Completed";
                case 3:
                    return "Failed";
                default:
                    return "Unknown";
            }
        }
    }
}
