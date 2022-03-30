using System;
using System.Collections.Generic;

namespace Semmle.Util
{
    /// <summary>
    /// Represents a parsed set of command line options.
    /// </summary>
    public interface ICommandLineOptions
    {
        /// <summary>
        /// Handle an option of the form "--threads 5" or "--threads:5"
        /// </summary>
        /// <param name="key">The name of the key. This is case sensitive.</param>
        /// <param name="value">The supplied value.</param>
        /// <returns>True if the option was handled, or false otherwise.</returns>
        bool HandleOption(string key, string value);

        /// <summary>
        /// Handle a flag of the form "--cil" or "--nocil"
        /// </summary>
        /// <param name="key">The name of the flag. This is case sensitive.</param>
        /// <param name="value">True if set, or false if prefixed by "--no"</param>
        /// <returns>True if the flag was handled, or false otherwise.</returns>
        bool HandleFlag(string key, bool value);

        /// <summary>
        /// Handle an argument, not prefixed by "--".
        /// </summary>
        /// <param name="argument">The command line argument.</param>
        /// <returns>True if the argument was handled, or false otherwise.</returns>
        bool HandleArgument(string argument);

        /// <summary>
        /// Process an unhandled option, or an unhandled argument.
        /// </summary>
        /// <param name="argument">The argument.</param>
        void InvalidArgument(string argument);
    }

    public static class OptionsExtensions
    {
        private static string? GetExtractorOption(string name) =>
            Environment.GetEnvironmentVariable($"CODEQL_EXTRACTOR_CSHARP_OPTION_{name.ToUpper()}");

        private static List<string> GetExtractorOptions()
        {
            var extractorOptions = new List<string>();

            var trapCompression = GetExtractorOption("trap_compression");
            if (!string.IsNullOrEmpty(trapCompression))
            {
                extractorOptions.Add($"--trap_compression:{trapCompression}");
            }

            return extractorOptions;
        }

        public static void ParseArguments(this ICommandLineOptions options, IReadOnlyList<string> providedArguments)
        {
            var arguments = GetExtractorOptions();
            arguments.AddRange(providedArguments);
            for (var i = 0; i < arguments.Count; ++i)
            {
                var arg = arguments[i];
                if (arg.StartsWith("--"))
                {
                    var colon = arg.IndexOf(':');
                    if (colon > 0 && options.HandleOption(arg.Substring(2, colon - 2), arg.Substring(colon + 1)))
                    { }
                    else if (arg.StartsWith("--no") && options.HandleFlag(arg.Substring(4), false))
                    { }
                    else if (options.HandleFlag(arg.Substring(2), true))
                    { }
                    else if (i + 1 < arguments.Count && options.HandleOption(arg.Substring(2), arguments[i + 1]))
                    {
                        ++i;
                    }
                    else
                    {
                        options.InvalidArgument(arg);
                    }
                }
                else
                {
                    if (!options.HandleArgument(arg))
                    {
                        options.InvalidArgument(arg);
                    }
                }
            }
        }
    }
}
