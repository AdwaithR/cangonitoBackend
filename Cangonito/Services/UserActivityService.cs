namespace Cangonito.Services
{
    public class UserActivityService
    {
        public string GetEventStatus(int status)
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
