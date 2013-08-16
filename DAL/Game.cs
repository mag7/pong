using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL
{
    class Game
    {
        public int ID { get; set; }
        public int WinnerID { get; set; }
        public int LoserID { get; set; }
        public int WinnerScore { get; set; }
        public int LoserScore { get; set; }
        public DateTime Date { get; set; }
    }
}
