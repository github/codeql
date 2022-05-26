using System;
using System.Collections.Generic;
using Semmle.Util;

namespace Semmle.Extraction.CSharp
{
    public sealed class Options : CommonOptions
    {
        /// <summary>
        /// The compiler exe, or null if unspecified.
        /// </summary>
        public string? CompilerName { get; set; }

        /// <summary>
        /// Specified .Net Framework dir, or null if unspecified.
        /// </summary>
        public string? Framework { get; set; }

        /// <summary>
        /// Project files whose source files should be added to the compilation.
        /// Only used in tests.
        /// </summary>
        public IList<string> ProjectsToLoad { get; } = new List<string>();

        /// <summary>
        /// All other arguments passed to the compilation.
        /// </summary>
        public IList<string> CompilerArguments { get; } = new List<string>();

        /// <summary>
        /// Holds if the extractor was launched from the CLR tracer.
        /// </summary>
        public bool ClrTracer { get; private set; } = false;

        /// <summary>
        /// Holds if assembly information should be prefixed to TRAP labels.
        /// </summary>
        public bool AssemblySensitiveTrap { get; private set; } = false;

        public static Options CreateWithEnvironment(string[] arguments)
        {
            var options = new Options();
            var extractionOptions = Environment.GetEnvironmentVariable("LGTM_INDEX_EXTRACTOR");

            var argsList = new List<string>(arguments);

            if (!string.IsNullOrEmpty(extractionOptions))
            {
                argsList.AddRange(extractionOptions.Split(' '));
            }

            options.ParseArguments(argsList);
            return options;
        }

        public override bool HandleArgument(string argument)
        {
            CompilerArguments.Add(argument);
            return true;
        }

        public override void InvalidArgument(string argument)
        {
            // Unrecognised arguments are passed to the compiler.
            CompilerArguments.Add(argument);
        }

        public override bool HandleOption(string key, string value)
        {
            switch (key)
            {
                case "compiler":
                    CompilerName = value;
                    return true;
                case "framework":
                    Framework = value;
                    return true;
                case "load-sources-from-project":
                    ProjectsToLoad.Add(value);
                    return true;
                default:
                    return base.HandleOption(key, value);
            }
        }

        public override bool HandleFlag(string flag, bool value)
        {
            switch (flag)
            {
                case "clrtracer":
                    ClrTracer = value;
                    return true;
                case "assemblysensitivetrap":
                    AssemblySensitiveTrap = value;
                    return true;
                default:
                    return base.HandleFlag(flag, value);
            }
        }

        private Options()
        {
        }
    }
}
