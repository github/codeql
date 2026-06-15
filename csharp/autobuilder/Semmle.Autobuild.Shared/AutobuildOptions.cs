using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using Semmle.Util;

namespace Semmle.Autobuild.Shared
{
    /// <summary>
    /// Encapsulates build options shared between C# and C++.
    /// </summary>
    public abstract class AutobuildOptionsShared
    {
        public int SearchDepth { get; } = 3;
        public string RootDirectory { get; }
        public string? DotNetVersion { get; }
        public abstract Language Language { get; }

        /// <summary>
        /// Reads options from environment variables.
        /// Throws ArgumentOutOfRangeException for invalid arguments.
        /// </summary>
        public AutobuildOptionsShared(IBuildActions actions)
        {
            RootDirectory = actions.GetCurrentDirectory();
            DotNetVersion = actions.GetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_OPTION_DOTNET_VERSION");
        }
    }

    public static class OptionsExtensions
    {
        public static bool AsBool(this string? value, string param, bool defaultValue)
        {
            if (value is null)
                return defaultValue;

            return value.ToLower() switch
            {
                "on" or "yes" or "true" or "enabled" => true,
                "off" or "no" or "false" or "disabled" => false,
                _ => throw new ArgumentOutOfRangeException(param, value, "The Boolean value is invalid."),
            };
        }

        public static string[] AsListWithExpandedEnvVars(this string? value, IBuildActions actions, string[] defaultValue)
        {
            if (value is null)
                return defaultValue;

            return value.
                Split(FileUtils.NewLineCharacters, StringSplitOptions.RemoveEmptyEntries).
                Select(s => AsStringWithExpandedEnvVars(s, actions)).ToArray();
        }

        private static readonly Regex linuxEnvRegEx = new Regex(@"\$([a-zA-Z_][a-zA-Z_0-9]*)", RegexOptions.Compiled);

        public static string AsStringWithExpandedEnvVars(this string value, IBuildActions actions)
        {
            if (string.IsNullOrEmpty(value))
                return value;

            // `Environment.ExpandEnvironmentVariables` only works with Windows-style
            // environment variables
            var windowsStyle = actions.IsWindows()
                ? value
                : linuxEnvRegEx.Replace(value, m => $"%{m.Groups[1].Value}%");
            return actions.EnvironmentExpandEnvironmentVariables(windowsStyle);
        }
    }
}
