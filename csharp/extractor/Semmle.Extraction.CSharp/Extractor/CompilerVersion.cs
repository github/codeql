using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;

namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// Identifies the compiler and framework from the command line arguments.
    /// --compiler specifies the compiler
    /// --framework specifies the .net framework
    /// </summary>
    public class CompilerVersion
    {
        private const string csc_rsp = "csc.rsp";
        private readonly string? specifiedFramework = null;

        /// <summary>
        /// The value specified by --compiler, or null.
        /// </summary>
        public string? SpecifiedCompiler
        {
            get;
            private set;
        }

        /// <summary>
        /// Why was the candidate exe rejected as a compiler?
        /// </summary>
        public string? SkipReason
        {
            get;
            private set;
        }

        private static readonly Dictionary<string, string> knownCompilerNames = new()
        {
            { "csc.exe", "Microsoft" },
            { "csc2.exe", "Microsoft" },
            { "csc.dll", "Microsoft" },
            { "mcs.exe", "Novell" }
        };

        /// <summary>
        /// Probes the compiler (if specified).
        /// </summary>
        /// <param name="options">The command line arguments.</param>
        public CompilerVersion(Options options)
        {
            SpecifiedCompiler = options.CompilerName;
            specifiedFramework = options.Framework;

            if (SpecifiedCompiler is not null)
            {
                if (!File.Exists(SpecifiedCompiler))
                {
                    SkipExtractionBecause("the specified file does not exist");
                    return;
                }

                // Reads the file details from the .exe
                var compilerDir = Path.GetDirectoryName(SpecifiedCompiler);
                if (compilerDir is null)
                {
                    SkipExtractionBecause("the compiler directory could not be retrieved");
                    return;
                }

                var mscorlibExists = File.Exists(Path.Combine(compilerDir, "mscorlib.dll"));

                if (specifiedFramework is null && mscorlibExists)
                {
                    specifiedFramework = compilerDir;
                }

                var versionInfo = FileVersionInfo.GetVersionInfo(SpecifiedCompiler);
                if (!knownCompilerNames.TryGetValue(versionInfo.OriginalFilename ?? string.Empty, out var vendor))
                {
                    SkipExtractionBecause("the compiler name is not recognised");
                    return;
                }

                if (versionInfo.LegalCopyright is null || !versionInfo.LegalCopyright.Contains(vendor))
                {
                    SkipExtractionBecause($"the compiler isn't copyright {vendor}, but instead {versionInfo.LegalCopyright ?? "<null>"}");
                    return;
                }
            }

            ArgsWithResponse = AddDefaultResponse(CscRsp, options.CompilerArguments).ToArray();
        }

        private void SkipExtractionBecause(string reason)
        {
            SkipExtraction = true;
            SkipReason = reason;
        }

        /// <summary>
        /// The directory containing the .Net Framework.
        /// </summary>
        public string FrameworkPath => specifiedFramework ?? RuntimeEnvironment.GetRuntimeDirectory();

        /// <summary>
        /// The file csc.rsp.
        /// </summary>
        private string CscRsp => Path.Combine(FrameworkPath, csc_rsp);

        /// <summary>
        /// Should we skip extraction?
        /// Only if csc.exe was specified but it wasn't a compiler.
        /// </summary>
        public bool SkipExtraction
        {
            get;
            private set;
        }

        /// <summary>
        /// Gets additional reference directories - the compiler directory.
        /// </summary>
        public string? AdditionalReferenceDirectories => SpecifiedCompiler is not null ? Path.GetDirectoryName(SpecifiedCompiler) : null;

        /// <summary>
        /// Adds @csc.rsp to the argument list to mimic csc.exe.
        /// </summary>
        /// <param name="responseFile">The full pathname of csc.rsp.</param>
        /// <param name="args">The other command line arguments.</param>
        /// <returns>Modified list of arguments.</returns>
        private static IEnumerable<string> AddDefaultResponse(string responseFile, IEnumerable<string> args)
        {
            var ret = SuppressDefaultResponseFile(args) || !File.Exists(responseFile) ?
                args :
                new[] { $"@{responseFile}" }.Concat(args);

            // make sure to never treat warnings as errors in the extractor:
            // our version of Roslyn may report warnings that the actual build
            // doesn't
            return ret.Concat(["/warnaserror-"]);
        }

        private static bool SuppressDefaultResponseFile(IEnumerable<string> args)
        {
            return args.Any(arg => noConfigFlags.Contains(arg.ToLowerInvariant()));
        }

        public IEnumerable<string> ArgsWithResponse { get; } = Enumerable.Empty<string>();

        private static readonly string[] noConfigFlags = ["/noconfig", "-noconfig"];
    }
}
