using System;
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
        const string csc_rsp = "csc.rsp";
        readonly string? specifiedFramework = null;
        public readonly string[] ArgsWithResponse;

        /// <summary>
        /// The value specified by --compiler, or null.
        /// </summary>
        public string? SpecifiedCompiler
        {
            get;
            private set;
        }

        /// <summary>
        /// Probes the compiler (if specified).
        /// </summary>
        /// <param name="options">The command line arguments.</param>
        public CompilerVersion(Options options)
        {
            SpecifiedCompiler = options.CompilerName;
            specifiedFramework = options.Framework;

            if (SpecifiedCompiler != null)
            {
                if (!File.Exists(SpecifiedCompiler))
                {
                    throw new UnrecognizedCompilerException(SpecifiedCompiler, "the specified file does not exist");
                }

                // Reads the file details from the .exe
                var versionInfo = FileVersionInfo.GetVersionInfo(SpecifiedCompiler);

                var compilerDir = Path.GetDirectoryName(SpecifiedCompiler);
                var knownCompilerNames = new Dictionary<string, string>
                {
                    { "csc.exe", "Microsoft" },
                    { "csc2.exe", "Microsoft" },
                    { "csc.dll", "Microsoft" },
                    { "mcs.exe", "Novell" }
                };
                var mscorlibExists = File.Exists(Path.Combine(compilerDir ?? string.Empty, "mscorlib.dll"));

                if (specifiedFramework == null && mscorlibExists)
                {
                    specifiedFramework = compilerDir;
                }

                if (!knownCompilerNames.TryGetValue(versionInfo.OriginalFilename, out var vendor))
                {
                    throw new UnrecognizedCompilerException(SpecifiedCompiler, "the compiler name is not recognised");
                }

                if (versionInfo.LegalCopyright == null || !versionInfo.LegalCopyright.Contains(vendor))
                {
                    throw new UnrecognizedCompilerException(SpecifiedCompiler, $"the compiler isn't copyright {vendor}, but instead {versionInfo.LegalCopyright ?? "<null>"}");
                }
            }

            ArgsWithResponse = AddDefaultResponse(CscRsp, options.CompilerArguments).ToArray();
        }

        /// <summary>
        /// The directory containing the .Net Framework.
        /// </summary>
        public string FrameworkPath => specifiedFramework ?? RuntimeEnvironment.GetRuntimeDirectory();

        /// <summary>
        /// The file csc.rsp.
        /// </summary>
        string CscRsp => Path.Combine(FrameworkPath, csc_rsp);

        /// <summary>
        /// Gets additional reference directories - the compiler directory.
        /// </summary>
        public string? AdditionalReferenceDirectories => SpecifiedCompiler != null ? Path.GetDirectoryName(SpecifiedCompiler) : null;

        /// <summary>
        /// Adds @csc.rsp to the argument list to mimic csc.exe.
        /// </summary>
        /// <param name="responseFile">The full pathname of csc.rsp.</param>
        /// <param name="args">The other command line arguments.</param>
        /// <returns>Modified list of arguments.</returns>
        static IEnumerable<string> AddDefaultResponse(string responseFile, IEnumerable<string> args)
        {
            return SuppressDefaultResponseFile(args) || !File.Exists(responseFile) ?
                args :
                new[] { "@" + responseFile }.Concat(args);
        }

        static bool SuppressDefaultResponseFile(IEnumerable<string> args)
        {
            return args.Any(arg => new[] { "/noconfig", "-noconfig" }.Contains(arg.ToLowerInvariant()));
        }
    }
}
