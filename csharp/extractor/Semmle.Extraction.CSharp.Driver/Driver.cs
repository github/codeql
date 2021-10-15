using System;
using System.Text.RegularExpressions;
using System.Collections.Generic;

namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// A command-line driver for the extractor.
    /// </summary>
    public static class Driver
    {
        public static int Main(string[] args)
        {
            Extractor.SetInvariantCulture();

            Console.WriteLine($"Semmle.Extraction.CSharp.Driver: called with {string.Join(", ", args)}");

            if (args.Length > 0 && args[0] == "--dotnetexec")
            {
                var compilerRegEx = new Regex(@"csc\.exe|mcs\.exe|csc\.dll", RegexOptions.Compiled);
                var cil = args.Length > 1 && args[1] == "--cil";
                for (var i = cil ? 2 : 1; i < args.Length; i++)
                {
                    if (compilerRegEx.IsMatch(args[i]))
                    {
                        var argsList = new List<string>();
                        if (cil)
                            argsList.Add("--cil");
                        argsList.Add("--compiler");
                        argsList.Add(args[i]);
                        if (i + 1 < args.Length)
                            argsList.AddRange(args[(i + 1)..]);
                        return (int)Extractor.Run(argsList.ToArray());
                    }
                }

                Console.WriteLine($"Semmle.Extraction.CSharp.Driver: not a compiler invocation");
                return 0;
            }

            return (int)Extractor.Run(args);
        }
    }
}
