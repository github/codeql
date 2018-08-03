public void printCharacterCodes(string[] strings)
{
    if (strings != null)
    {
        foreach(string s in strings){
            if (s != null)
            {
                foreach (char c in s)
                {
                    Console.WriteLine(c + "=" + (int)c);
                }
            }
        }
    }
}
