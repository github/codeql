using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace Semmle.Autobuild.Shared
{
    /// <summary>
    /// Encapsulates build options.
    /// </summary>
    public class AutobuildOptions
    {
        private const string prefix = "LGTM_INDEX_";

        public int SearchDepth { get; } = 3;
        public string RootDirectory { get; }
        public string? VsToolsVersion { get; }
        public string? MsBuildArguments { get; }
        public string? MsBuildPlatform { get; }
        public string? MsBuildConfiguration { get; }
        public string? MsBuildTarget { get; }
        public string? DotNetArguments { get; }
        public string? DotNetVersion { get; }
        public string? BuildCommand { get; }
        public IEnumerable<string> Solution { get; }
        public bool IgnoreErrors { get; }
        public bool Buildless { get; }
        public bool AllSolutions { get; }
        public bool NugetRestore { get; }
        public Language Language { get; }

        /// <summary>
        /// Reads options from environment variables.
        /// Throws ArgumentOutOfRangeException for invalid arguments.
        /// </summary>
        public AutobuildOptions(IBuildActions actions, Language language)
        {
            RootDirectory = actions.GetCurrentDirectory();
            VsToolsVersion = actions.GetEnvironmentVariable(prefix + "VSTOOLS_VERSION");
            MsBuildArguments = actions.GetEnvironmentVariable(prefix + "MSBUILD_ARGUMENTS")?.AsStringWithExpandedEnvVars(actions);
            MsBuildPlatform = actions.GetEnvironmentVariable(prefix + "MSBUILD_PLATFORM");
            MsBuildConfiguration = actions.GetEnvironmentVariable(prefix + "MSBUILD_CONFIGURATION");
            MsBuildTarget = actions.GetEnvironmentVariable(prefix + "MSBUILD_TARGET");
            DotNetArguments = actions.GetEnvironmentVariable(prefix + "DOTNET_ARGUMENTS")?.AsStringWithExpandedEnvVars(actions);
            DotNetVersion = actions.GetEnvironmentVariable(prefix + "DOTNET_VERSION");
            BuildCommand = actions.GetEnvironmentVariable(prefix + "BUILD_COMMAND");
            Solution = actions.GetEnvironmentVariable(prefix + "SOLUTION").AsListWithExpandedEnvVars(actions, Array.Empty<string>());

            IgnoreErrors = actions.GetEnvironmentVariable(prefix + "IGNORE_ERRORS").AsBool("ignore_errors", false);
            Buildless = actions.GetEnvironmentVariable(prefix + "BUILDLESS").AsBool("buildless", false);
            AllSolutions = actions.GetEnvironmentVariable(prefix + "ALL_SOLUTIONS").AsBool("all_solutions", false);
            NugetRestore = actions.GetEnvironmentVariable(prefix + "NUGET_RESTORE").AsBool("nuget_restore", true);

            Language = language;
        }
    }

    public static class OptionsExtensions
    {
        public static bool AsBool(this string? value, string param, bool defaultValue)
        {
            if (value == null)
                return defaultValue;

            switch (value.ToLower())
            {
                case "on":
                case "yes":
                case "true":
                case "enabled":
                    return true;
                case "off":
                case "no":
                case "false":
                case "disabled":
                    return false;
                default:
                    throw new ArgumentOutOfRangeException(param, value, "The Boolean value is invalid.");
            }
        }

        public static string[] AsListWithExpandedEnvVars(this string? value, IBuildActions actions, string[] defaultValue)
        {
            if (value == null)
                return defaultValue;

            return value.
                Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries).
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
