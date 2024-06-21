namespace Cangonito.Models
{
    public class UserActivity
    {
        public int ReturnId { get; set; }
        public DateTime SessionDate { get; set; }
        public string UserName { get; set; }
        public List<EventStatus> Events { get; set; }
        public string Status { get; set; }
    }
}
