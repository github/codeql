using System;
using Semmle.Util.Logging;
using Semmle.Util;

namespace Semmle.Extraction
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
        public int Threads { get; private set; } = System.Environment.ProcessorCount;

        /// <summary>
        /// The verbosity used in output and logging.
        /// </summary>
        public Verbosity Verbosity { get; protected set; } = Verbosity.Info;

        /// <summary>
        /// Whether to output to the console.
        /// </summary>
        public bool Console { get; private set; } = false;

        /// <summary>
        /// Holds if CIL should be extracted.
        /// </summary>
        public bool CIL { get; private set; } = false;

        /// <summary>
        /// Holds if assemblies shouldn't be extracted twice.
        /// </summary>
        public bool Cache { get; private set; } = true;

        /// <summary>
        /// Whether to extract PDB information.
        /// </summary>
        public bool PDB { get; private set; } = false;

        /// <summary>
        /// Whether "fast extraction mode" has been enabled.
        /// </summary>
        public bool Fast { get; private set; } = false;

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
                    Verbosity = (Verbosity)int.Parse(value);
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
                    if (value)
                        Verbosity = Verbosity.Off;
                    return true;
                case "verbose":
                    Verbosity = value ? Verbosity.Debug : Verbosity.Error;
                    return true;
                case "console":
                    Console = value;
                    return true;
                case "cache":
                    Cache = value;
                    return true;
                case "cil":
                    CIL = value;
                    return true;
                case "pdb":
                    PDB = value;
                    CIL = true;
                    return true;
                case "fast":
                    CIL = !value;
                    Fast = value;
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
