﻿namespace Cangonito.Controllers.Models
{
    public class UserActivity
    {
        public int ReturnId { get; set; }
        public DateTime SessionDate { get; set; }
        public string Username { get; set; }
        public List<EventStatus> Events { get; set; }
        public string Status { get; set; }
    }
}
