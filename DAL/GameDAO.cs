using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;

namespace DAL
{
    public class GameDAO : DAO
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

        public void CreateGame(Game game)
        {
            SqlParameter[] parameter = new SqlParameter[] 
            { new SqlParameter("@WinnerID", game.WinnerID),
              new SqlParameter("@LoserID", game.LoserID),
              new SqlParameter("@WinnerScore", game.WinnerScore),
              new SqlParameter("@LoserScore", game.LoserScore),
              new SqlParameter("@Date", DateTime.Now)
            };
            Write("Create_Game", parameter);
        }

        public void GenerateGame(int winnerID, int loserID, int winnerScore, int loserScore)
        {
            CreateGame(new Game() { WinnerID = winnerID, LoserID = loserID, WinnerScore = winnerScore, LoserScore = loserScore });
        }

        public List<Game> GetGamesByUser(int userID)
        {
            SqlParameter[] parameter = new SqlParameter[] { new SqlParameter("@ID", userID) };
            return Read("Get_Games_By_User", parameter);
        }


    }
}
