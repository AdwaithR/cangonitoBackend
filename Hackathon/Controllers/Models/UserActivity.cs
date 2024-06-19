namespace Cangonito.Controllers.Models
{
    public class UserActivity
    {
        public string ReturnId { get; set; }
        public string SessionId { get; set; }
        public string Username { get; set; }
        public List<Dictionary<string, object>> Events { get; set; }
        public string Status { get; set; }
    }
}
