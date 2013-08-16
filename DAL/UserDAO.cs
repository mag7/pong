using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;

namespace DAL
{
    class UserDAO:DAO
    {
        public List<User> Read(string statement, SqlParameter[] parameter)
        {
            using (SqlConnection connection = new SqlConnection(@"Data Source=.\SQLEXPRESS;Initial Catalog=Pongshore;Integrated Security=SSPI;"))
            {
                connection.Open();
                using (SqlCommand command = new SqlCommand(statement, connection))
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    if (parameter != null)
                    {
                        command.Parameters.AddRange(parameter);
                    }
                    SqlDataReader data = command.ExecuteReader();

                    List<User> userList = new List<User>();

                    while (data.Read())
                    {
                        User user = new User();
                        user.ID = Convert.ToInt32(data["id"]);
                        user.Email = data["email"].ToString();
                        user.Password = data["password"].ToString();
                        user.GamesWon = Convert.ToInt32(data["gamesWon"]);
                        user.GamesPlayed = Convert.ToInt32(data["gamesPlayed"]);
                        userList.Add(user);
                    }
                    return userList;
                }
            }
        }
    }
}
