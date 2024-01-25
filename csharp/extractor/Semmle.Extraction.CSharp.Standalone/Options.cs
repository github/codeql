using System.IO;
using Semmle.Util;
using Semmle.Util.Logging;
using Semmle.Extraction.CSharp.DependencyFetching;
using System;

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
                case "silent":
                    Verbosity = value ? Verbosity.Off : Verbosity.Info;
                    return true;
                case "help":
                    Help = true;
                    return true;
                default:
                    return base.HandleFlag(key, value);
            }
        }

        public override bool HandleOption(string key, string value)
        {
            switch (key)
            {
                case "dotnet":
                    dependencies.DotNetPath = value;
                    return true;
                default:
                    return base.HandleOption(key, value);
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

        private readonly DependencyOptions dependencies = new DependencyOptions();
        /// <summary>
        /// Dependency fetching related options.
        /// </summary>
        public IDependencyOptions Dependencies => dependencies;

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
            output.WriteLine("    --pdb            Cross-reference information from PDBs where available");
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
