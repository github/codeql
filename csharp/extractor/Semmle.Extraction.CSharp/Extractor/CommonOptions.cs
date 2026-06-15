using System;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// Represents the parsed state of the command line arguments.
    /// This represents the common options.
    /// </summary>
    public abstract class CommonOptions : ICommandLineOptions
    {
        /// <summary>
        /// The specified number of threads, or the default if unspecified.
        /// </summary>
        public int Threads { get; private set; } = EnvironmentVariables.GetDefaultNumberOfThreads();

        /// <summary>
        /// The verbosity used specified by the '--silent' or '--verbose' flags or the '--verbosity' option.
        /// </summary>
        public Verbosity LegacyVerbosity { get; protected set; } = Verbosity.Info;

        private Verbosity? verbosity = null;
        public Verbosity Verbosity
        {
            get
            {
                if (verbosity != null)
                {
                    return verbosity.Value;
                }

                var envVarValue = EnvironmentVariables.GetExtractorOption("LOGGING_VERBOSITY");
                verbosity = VerbosityExtensions.ParseVerbosity(envVarValue, logThreadId: true);
                if (verbosity != null)
                {
                    return verbosity.Value;
                }

                envVarValue = Environment.GetEnvironmentVariable("CODEQL_VERBOSITY");
                verbosity = VerbosityExtensions.ParseVerbosity(envVarValue, logThreadId: true);
                if (verbosity != null)
                {
                    return verbosity.Value;
                }

                // This only works, because we already parsed the provided options, so `LegacyVerbosity` is already set (or it still has the default value).
                verbosity = LegacyVerbosity;
                return verbosity.Value;
            }
        }

        /// <summary>
        /// Whether to output to the console.
        /// </summary>
        public bool Console { get; private set; } = false;

        /// <summary>
        /// Holds if assemblies shouldn't be extracted twice.
        /// </summary>
        public bool Cache { get; private set; } = true;

        /// <summary>
        /// Whether extraction is done using `codeql test run`.
        /// </summary>
        public bool QlTest { get; private set; } = false;

        /// <summary>
        /// The compression algorithm used for trap files.
        /// </summary>
        public TrapWriter.CompressionMode TrapCompression { get; private set; } = TrapWriter.CompressionMode.Brotli;

        public virtual bool HandleOption(string key, string value)
        {
            switch (key)
            {
                case "threads":
                    Threads = int.Parse(value);
                    return true;
                case "verbosity":
                    LegacyVerbosity = (Verbosity)int.Parse(value);
                    return true;
                case "trap_compression":
                    if (Enum.TryParse<TrapWriter.CompressionMode>(value, true, out var mode))
                    {
                        TrapCompression = mode;
                        return true;
                    }
                    return false;
                default:
                    return false;
            }
        }

        public abstract bool HandleArgument(string argument);

        public virtual bool HandleFlag(string flag, bool value)
        {
            switch (flag)
            {
                case "silent":
                    LegacyVerbosity = value ? Verbosity.Off : Verbosity.Info;
                    return true;
                case "verbose":
                    LegacyVerbosity = value ? Verbosity.Debug : Verbosity.Error;
                    return true;
                case "console":
                    Console = value;
                    return true;
                case "cache":
                    Cache = value;
                    return true;
                case "qltest":
                    QlTest = value;
                    return true;
                default:
                    return false;
            }
        }

        public abstract void InvalidArgument(string argument);
    }
}
