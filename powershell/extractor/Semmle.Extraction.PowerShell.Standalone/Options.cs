using System.Collections.Generic;
using System.IO;
using System.Linq;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.PowerShell.Standalone
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
                case "file-list":
                    Files = File.ReadAllLines(value).Select(f => new FileInfo(f)).ToArray();
                    return true;
                default:
                    return base.HandleOption(key, value);
            }
        }

        public override bool HandleArgument(string arg)
        {
            if (!new FileInfo(arg).Exists)
            {
                var di = new DirectoryInfo(arg);
                if (!di.Exists)
                {
                    System.Console.WriteLine(
                        "Error: The file or directory {0} does not exist",
                        di.FullName
                    );
                    Errors = true;
                }
                else
                {
                    Files = di.GetFiles("*.*", SearchOption.AllDirectories);
                }
            }
            return true;
        }

        public override void InvalidArgument(string argument)
        {
            System.Console.WriteLine($"Error: Invalid argument {argument}");
            Errors = true;
        }

        /// <summary>
        /// List of extensions to include.
        /// </summary>
        public IList<string> Extensions { get; } = new List<string>() { ".ps1", ".psd1", ".psm1" };

        /// <summary>
        /// Files/patterns to exclude.
        /// </summary>
        public IList<string> Excludes { get; } =
            new List<string>() { "node_modules", "bower_components" };

        /// <summary>
        /// Returns a FileInfo object for each file in the given path (recursively).
        /// </summary>
        private static FileInfo[] GetFiles(string path)
        {
            var di = new DirectoryInfo(path);
            return di.Exists
                ? di.GetFiles("*.*", SearchOption.AllDirectories)
                : new FileInfo[] { new FileInfo(path) };
        }

        /// <summary>
        /// Returns a list of files to extract. By default, this is the list of all files in
        /// the current directory. However, if the LGTM_INDEX_INCLUDE environment variable is
        /// set, it is used as a list of files to include instead of the files from the current
        /// directory.
        /// </summary>
        private static FileInfo[] GetDefaultFiles()
        {
            // Check if the LGTM_INDEX_INCLUDE environmen variable exists
            var include = System.Environment.GetEnvironmentVariable("LGTM_INDEX_INCLUDE");
            if (include != null)
            {
                System.Console.WriteLine("Using LGTM_INDEX_INCLUDE: {0}", include);
                return include.Split(';').Select(GetFiles).SelectMany(f => f).ToArray();
            }
            else
            {
                return new DirectoryInfo(Directory.GetCurrentDirectory()).GetFiles(
                    "*.*",
                    SearchOption.AllDirectories
                );
            }
        }

        /// <summary>
        /// The directory or file containing the source code;
        /// </summary>
        public FileInfo[] Files { get; set; } = GetDefaultFiles();

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

        public string OutDir { get; set; } = Directory.GetCurrentDirectory();

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
            output.WriteLine(
                "PowerShell# standalone extractor\n\nExtracts PowerShell scripts in the current directory.\n"
            );
            output.WriteLine("Additional options:\n");
            output.WriteLine("    <path>           Use the provided path instead.");
            output.WriteLine(
                "    --exclude:xxx    Exclude a file or directory (can be specified multiple times)"
            );
            output.WriteLine("    --dry-run        Stop before extraction");
            output.WriteLine("    --threads:nnn    Specify number of threads (default=CPU cores)");
            output.WriteLine("    --verbose        Produce more output");
        }

        private Options() { }

        public static Options Create(string[] args)
        {
            var options = new Options();
            options.ParseArguments(args);
            return options;
        }
    }
}
