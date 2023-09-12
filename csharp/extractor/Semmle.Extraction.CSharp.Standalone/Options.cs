using System.IO;
using Semmle.Util;
using Semmle.Util.Logging;
using Semmle.Extraction.CSharp.DependencyFetching;

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
                case "dry-run":
                    SkipExtraction = value;
                    return true;
                case "skip-nuget":
                    dependencies.UseNuGet = !value;
                    return true;
                case "all-references":
                    AnalyseCsProjFiles = !value;
                    return true;
                case "skip-dotnet":
                    dependencies.ScanNetFrameworkDlls = !value;
                    return true;
                case "self-contained-dotnet":
                    dependencies.UseSelfContainedDotnet = value;
                    return true;
                default:
                    return base.HandleFlag(key, value);
            }
        }

        public override bool HandleOption(string key, string value)
        {
            switch (key)
            {
                case "exclude":
                    dependencies.Excludes.Add(value);
                    return true;
                case "references":
                    dependencies.DllDirs.Add(value);
                    return true;
                default:
                    return base.HandleOption(key, value);
            }
        }

        public override bool HandleArgument(string arg)
        {
            dependencies.SolutionFile = arg;
            var fi = new FileInfo(dependencies.SolutionFile);
            if (!fi.Exists)
            {
                System.Console.WriteLine("Error: The solution {0} does not exist", fi.FullName);
                Errors = true;
            }
            return true;
        }

        public override void InvalidArgument(string argument)
        {
            System.Console.WriteLine($"Error: Invalid argument {argument}");
            Errors = true;
        }

        /// <summary>
        /// The directory containing the source code;
        /// </summary>
        public string SrcDir { get; } = System.IO.Directory.GetCurrentDirectory();

        private readonly DependencyOptions dependencies = new DependencyOptions();
        /// <summary>
        /// Dependency fetching related options.
        /// </summary>
        public IDependencyOptions Dependencies => dependencies;

        /// <summary>
        /// Whether to search .csproj files.
        /// </summary>
        public bool AnalyseCsProjFiles { get; private set; } = true;

        /// <summary>
        /// Whether the extraction phase should be skipped (dry-run).
        /// </summary>
        public bool SkipExtraction { get; private set; } = false;

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
            output.WriteLine("    xxx.sln          Restrict sources to given solution");
            output.WriteLine("    --exclude:xxx    Exclude a file or directory (can be specified multiple times)");
            output.WriteLine("    --references:xxx Scan additional files or directories for assemblies (can be specified multiple times)");
            output.WriteLine("    --skip-dotnet    Do not reference the .Net Framework");
            output.WriteLine("    --dry-run        Stop before extraction");
            output.WriteLine("    --skip-nuget     Do not download nuget packages");
            output.WriteLine("    --all-references Use all references (default is to only use references in .csproj files)");
            output.WriteLine("    --threads:nnn    Specify number of threads (default=CPU cores)");
            output.WriteLine("    --verbose        Produce more output");
            output.WriteLine("    --pdb            Cross-reference information from PDBs where available");
            output.WriteLine("    --self-contained-dotnet    Use the .Net Framework packaged with the extractor");
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
