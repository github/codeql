public static void PrintAllCharInts(string s){
    if (s != null)
    {
        foreach (char c in s)
        {
            Console.WriteLine(c + "=" + (int)c);
        }
    }
}
public static void Main(string[] args)
{
    string[] strings = new string[5];
    if (strings != null)
    {
        foreach(string s in strings){
            PrintAllCharInts(s);
        }
    }
}
