class Players
{
    private ArrayList playerList;
    class ArrayList : System.Collections.ArrayList
    {
        public String GetBestThree()
        {
            return "1st: " + this[0] + "\n 2nd:" + this[1] + "\n 3rd:" + this[2];
        }
    }
}
