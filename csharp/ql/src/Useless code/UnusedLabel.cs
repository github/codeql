static void Main(string[] args)
{
    using (var file = File.Open("values.xml", FileMode.Create))
    using (var stream = new StreamWriter(file))
    {
        stream.WriteLine("<values>");
        foreach (var arg in args)
        {
            uint value;
            if (UInt32.TryParse(arg, out value))
                stream.WriteLine("    <value>{0}</value>", value);
            else
                goto Finish;  // Should be goto Error
        }
        goto Finish;
        Error:  // BAD: Unused label
        Console.WriteLine("Error: All arguments must be non-negative integers");
        Finish:
        stream.WriteLine("</values>");
    }
}
