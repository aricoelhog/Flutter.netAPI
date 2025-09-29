using Microsoft.EntityFrameworkCore;

namespace WebApi.Models
{
    public class DatabaseContext : DbContext
    {
        public DatabaseContext (DbContextOptions options) : base(options)
        {

        }

        public DbSet<Users> users { get; set; }
    }
}
