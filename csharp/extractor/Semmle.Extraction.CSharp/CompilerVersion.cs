using System.Diagnostics;
using System.IO;
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
        readonly string specifiedFramework = null;

        /// <summary>
        /// The value specified by --compiler, or null.
        /// </summary>
        public string SpecifiedCompiler
        {
            get;
            private set;
        }

        /// <summary>
        /// Why was the candidate exe rejected as a compiler?
        /// </summary>
        public string SkipReason
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
                    SkipExtractionBecause("the specified file does not exist");
                    return;
                }

                // Reads the file details from the .exe
                var versionInfo = FileVersionInfo.GetVersionInfo(SpecifiedCompiler);

                var compilerDir = Path.GetDirectoryName(SpecifiedCompiler);
                bool known_compiler_name = versionInfo.OriginalFilename == "csc.exe" || versionInfo.OriginalFilename == "csc2.exe";
                bool copyright_microsoft = versionInfo.LegalCopyright != null && versionInfo.LegalCopyright.Contains("Microsoft");
                bool mscorlib_exists = File.Exists(Path.Combine(compilerDir, "mscorlib.dll"));

                if (specifiedFramework == null && mscorlib_exists)
                {
                    specifiedFramework = compilerDir;
                }

                if (!known_compiler_name)
                {
                    SkipExtractionBecause("the exe name is not recognised");
                }
                else if (!copyright_microsoft)
                {
                    SkipExtractionBecause("the exe isn't copyright Microsoft");
                }
            }
        }

        void SkipExtractionBecause(string reason)
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
        public string CscRsp => Path.Combine(FrameworkPath, csc_rsp);

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
        public string AdditionalReferenceDirectories => SpecifiedCompiler != null ? Path.GetDirectoryName(SpecifiedCompiler) : null;
    }
}
