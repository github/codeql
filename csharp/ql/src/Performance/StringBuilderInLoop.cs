static void Main(string[] args)
{
    foreach (var arg in args)
    {
        var sb = new StringBuilder();  // BAD: Creation in loop
        sb.Append("Hello ").Append(arg);
        Console.WriteLine(sb);
    }
}
