using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;

namespace DAL
{
    public class UserDAO:DAO
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

        public User GetUser(int userID)
        {
            SqlParameter[] parameter = new SqlParameter[] { new SqlParameter("@ID", userID) };
            User user =  Read("Get_User", parameter).SingleOrDefault();
            if (user == null)
            {
                User computer = new User();
                computer.Email = "Computer";
                return computer;
            }
            return user;
        }

        public User GetUser(string email)
        {
            SqlParameter[] parameter = new SqlParameter[] {new SqlParameter("@Email", email)};
            return Read("Get_User_By_Email", parameter).SingleOrDefault();
        }

        public void CreateUser(User user)
        {
            SqlParameter[] parameter = new SqlParameter[]
            {new SqlParameter("@Email", user.Email), 
             new SqlParameter("@Password", user.Password)
            };
            Write("Insert_User", parameter);
        }

        public void GenerateUser(string email, string password)
        {
            CreateUser(new User() { Email = email, Password = password });
        }

        public void UpdateUser(User user, string newEmail)
        {
            SqlParameter[] parameter = new SqlParameter[]
            {new SqlParameter("@ID", user.ID), 
             new SqlParameter("@Password", user.Password),
             new SqlParameter("@NewEmail", newEmail)
            };
            Write("Update_User", parameter);
        }

        public void UpdateGamesPlayed(int userID)
        {
            SqlParameter[] parameter = new SqlParameter[] { new SqlParameter("@ID", userID) };
            Write("Add_Game_Played", parameter);
        }

        public void UpdateGamesWon(int userID)
        {
            SqlParameter[] parameter = new SqlParameter[] { new SqlParameter("@ID", userID) };
            Write("Add_Player_Win", parameter);
        }


    }
}
