using System.ComponentModel.DataAnnotations;

namespace WebApi.Models
{
    public class Users
    {
        [Key]
        public Guid userId { get; set; }

        [Required]
        public String name { get; set; } = "";

        [Required]
        public String address { get; set; } = "";
    }
}
