using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;

namespace DAL
{
    class GameDAO:DAO
    {
        public List<Game> Read(string statement, SqlParameter[] parameter)
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

                    List<Game> gameList = new List<Game>();

                    while (data.Read())
                    {
                        Game game = new Game();
                        game.ID = Convert.ToInt32(data["id"]);
                        game.WinnerID = Convert.ToInt32(data["WinnerID"]);
                        game.LoserID = Convert.ToInt32(data["LoserID"]);
                        game.WinnerScore = Convert.ToInt32(data["WinnerScore"]);
                        game.LoserScore = Convert.ToInt32(data["LoserScore"]);
                        game.Date = Convert.ToDateTime(data["Date"]);
                        gameList.Add(game);
                    }
                    return gameList;
                }
            }
        }
    }
}
