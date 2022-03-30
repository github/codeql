using System;
using System.Text;

class Program
{
    static void Main(string[] args)
    {
        foreach (var arg in args)
        {
            var sb = new StringBuilder();  // BAD: Creation in loop
            sb.Append("Hello ").Append(arg);
            Console.WriteLine(sb);
        }
    }

    void Fixed(string[] args)
    {
        var sb = new StringBuilder();  // GOOD: Not in loop
        foreach (var arg in args)
        {
            sb.Clear();
            sb.Append("Hello ").Append(arg);
            Console.WriteLine(sb);
        }
    }

    void ControlFlow(string[] args)
    {
        StringBuilder sb = null;
        foreach (var arg in args)
        {
            if (sb == null)
                sb = new StringBuilder();  // GOOD: Not in all control paths
            else
                sb.Clear();
            lock (sb) sb = new StringBuilder();  // BAD: In all control paths
            sb.Append("Hello ").Append(arg);
            Console.WriteLine(sb);
        }
    }
}
