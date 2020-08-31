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
        public string? CompilerName;

        /// <summary>
        /// Specified .Net Framework dir, or null if unspecified.
        /// </summary>
        public string? Framework;

        /// <summary>
        /// All other arguments passed to the compilation.
        /// </summary>
        public IList<string> CompilerArguments = new List<string>();

        /// <summary>
        /// Holds if the extractor was launched from the CLR tracer.
        /// </summary>
        public bool ClrTracer = false;

        public static Options CreateWithEnvironment(string[] arguments)
        {
            var options = new Options();
            var extractionOptions = Environment.GetEnvironmentVariable("SEMMLE_EXTRACTOR_OPTIONS") ??
                Environment.GetEnvironmentVariable("LGTM_INDEX_EXTRACTOR");

            var argsList = new List<string>(arguments);

            if (!string.IsNullOrEmpty(extractionOptions))
                argsList.AddRange(extractionOptions.Split(' '));

            options.ParseArguments(argsList);
            return options;
        }

        public override bool handleArgument(string argument)
        {
            CompilerArguments.Add(argument);
            return true;
        }

        public override void invalidArgument(string argument)
        {
            // Unrecognised arguments are passed to the compiler.
            CompilerArguments.Add(argument);
        }

        public override bool handleOption(string key, string value)
        {
            switch (key)
            {
                case "compiler":
                    CompilerName = value;
                    return true;
                case "framework":
                    Framework = value;
                    return true;
                default:
                    return base.handleOption(key, value);
            }
        }

        public override bool handleFlag(string flag, bool value)
        {
            switch (flag)
            {
                case "clrtracer":
                    ClrTracer = value;
                    return true;
                default:
                    return base.handleFlag(flag, value);
            }
        }

        private Options()
        {
        }
    }
}
