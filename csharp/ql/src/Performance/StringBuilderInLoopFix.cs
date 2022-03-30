static void Main(string[] args)
{
    var sb = new StringBuilder();  // GOOD: Creation outside loop
    foreach (var arg in args)
    {
        sb.Clear();
        sb.Append("Hello ").Append(arg);
        Console.WriteLine(sb);
    }
}
