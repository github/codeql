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
        private const string lgtmPrefix = "LGTM_INDEX_";
        private const string extractorOptionPrefix = "CODEQL_EXTRACTOR_CSHARP_OPTION_";

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
            VsToolsVersion = actions.GetEnvironmentVariable(lgtmPrefix + "VSTOOLS_VERSION");
            MsBuildArguments = actions.GetEnvironmentVariable(lgtmPrefix + "MSBUILD_ARGUMENTS")?.AsStringWithExpandedEnvVars(actions);
            MsBuildPlatform = actions.GetEnvironmentVariable(lgtmPrefix + "MSBUILD_PLATFORM");
            MsBuildConfiguration = actions.GetEnvironmentVariable(lgtmPrefix + "MSBUILD_CONFIGURATION");
            MsBuildTarget = actions.GetEnvironmentVariable(lgtmPrefix + "MSBUILD_TARGET");
            DotNetArguments = actions.GetEnvironmentVariable(lgtmPrefix + "DOTNET_ARGUMENTS")?.AsStringWithExpandedEnvVars(actions);
            DotNetVersion = actions.GetEnvironmentVariable(lgtmPrefix + "DOTNET_VERSION");
            BuildCommand = actions.GetEnvironmentVariable(lgtmPrefix + "BUILD_COMMAND");
            Solution = actions.GetEnvironmentVariable(lgtmPrefix + "SOLUTION").AsListWithExpandedEnvVars(actions, Array.Empty<string>());

            IgnoreErrors = actions.GetEnvironmentVariable(lgtmPrefix + "IGNORE_ERRORS").AsBool("ignore_errors", false);
            Buildless = actions.GetEnvironmentVariable(lgtmPrefix + "BUILDLESS").AsBool("buildless", false) ||
                actions.GetEnvironmentVariable(extractorOptionPrefix + "BUILDLESS").AsBool("buildless", false);
            AllSolutions = actions.GetEnvironmentVariable(lgtmPrefix + "ALL_SOLUTIONS").AsBool("all_solutions", false);
            NugetRestore = actions.GetEnvironmentVariable(lgtmPrefix + "NUGET_RESTORE").AsBool("nuget_restore", true);

            Language = language;
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
