using Semmle.Util.Logging;
using System.Collections.Generic;
using System.IO;
using System.Linq;
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
                    UseNuGet = !value;
                    return true;
                case "all-references":
                    AnalyseCsProjFiles = !value;
                    return true;
                case "stdlib":
                    UseMscorlib = value;
                    return true;
                case "skip-dotnet":
                    ScanNetFrameworkDlls = !value;
                    return true;
                case "self-contained-dotnet":
                    UseSelfContainedDotnet = value;
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
                    Excludes.Add(value);
                    return true;
                case "references":
                    DllDirs.Add(value);
                    return true;
                default:
                    return base.HandleOption(key, value);
            }
        }

        public override bool HandleArgument(string arg)
        {
            SolutionFile = arg;
            var fi = new FileInfo(SolutionFile);
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
        /// Files/patterns to exclude.
        /// </summary>
        public IList<string> Excludes { get; } = new List<string>();


        /// <summary>
        /// The directory containing the source code;
        /// </summary>
        public string SrcDir { get; } = System.IO.Directory.GetCurrentDirectory();

        /// <summary>
        /// Whether to analyse NuGet packages.
        /// </summary>
        public bool UseNuGet { get; private set; } = true;

        /// <summary>
        /// Directories to search DLLs in.
        /// </summary>
        public IList<string> DllDirs { get; } = new List<string>();

        /// <summary>
        /// Whether to search the .Net framework directory.
        /// </summary>
        public bool ScanNetFrameworkDlls { get; private set; } = true;

        /// <summary>
        /// Whether to use mscorlib as a reference.
        /// </summary>
        public bool UseMscorlib { get; private set; } = true;

        /// <summary>
        /// Whether to search .csproj files.
        /// </summary>
        public bool AnalyseCsProjFiles { get; private set; } = true;

        /// <summary>
        /// The solution file to analyse, or null if not specified.
        /// </summary>
        public string? SolutionFile { get; private set; }

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
        /// Whether to use the packaged dotnet runtime.
        /// </summary>
        public bool UseSelfContainedDotnet { get; private set; } = false;

        /// <summary>
        /// Determine whether the given path should be excluded.
        /// </summary>
        /// <param name="path">The path to query.</param>
        /// <returns>True iff the path matches an exclusion.</returns>
        public bool ExcludesFile(string path)
        {
            return Excludes.Any(ex => path.Contains(ex));
        }

        /// <summary>
        /// Outputs the command line options to the console.
        /// </summary>
        public static void ShowHelp(System.IO.TextWriter output)
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
            output.WriteLine("    --nostdlib       Do not link mscorlib.dll (use only for extracting mscorlib itself)");
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
