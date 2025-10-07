using System;
using System.IO;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.Standalone
{
    /// <summary>
    /// The options controlling standalone extraction.
    /// </summary>
    public sealed class Options : CommonOptions
    {
        public override bool HandleFlag(string key, bool value)
        {
            switch (key)
            {
                case "help":
                    Help = true;
                    return true;
                default:
                    return base.HandleFlag(key, value);
            }
        }

        public override bool HandleArgument(string arg)
        {
            return true;
        }

        public override void InvalidArgument(string argument)
        {
            System.Console.WriteLine($"[{Environment.CurrentManagedThreadId:D3}] Error: Invalid argument {argument}");
            Errors = true;
        }

        /// <summary>
        /// The directory containing the source code;
        /// </summary>
        public string SrcDir { get; } = Directory.GetCurrentDirectory();

        /// <summary>
        /// Whether errors were encountered parsing the arguments.
        /// </summary>
        public bool Errors { get; private set; } = false;

        /// <summary>
        /// Whether to show help.
        /// </summary>
        public bool Help { get; private set; } = false;

        /// <summary>
        /// Outputs the command line options to the console.
        /// </summary>
        public static void ShowHelp(TextWriter output)
        {
            output.WriteLine("C# standalone extractor\n\nExtracts a C# project in the current directory without performing a build.\n");
            output.WriteLine("Additional options:\n");
            output.WriteLine("    --threads:nnn    Specify number of threads (default=CPU cores)");
            output.WriteLine("    --verbose        Produce more output");
        }

        private Options()
        {
        }

        public static Options Create(string[] args)
        {
            var options = new Options();
            options.ParseArguments(args);
            return options;
        }
    }
}
