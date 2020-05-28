using System;
using System.Linq;
using System.Text.RegularExpressions;

namespace Semmle.Autobuild
{
    /// <summary>
    /// Encapsulates build options.
    /// </summary>
    public class AutobuildOptions
    {
        public readonly int SearchDepth = 3;
        public readonly string RootDirectory;
        private const string prefix = "LGTM_INDEX_";

        public readonly string? VsToolsVersion;
        public readonly string? MsBuildArguments;
        public readonly string? MsBuildPlatform;
        public readonly string? MsBuildConfiguration;
        public readonly string? MsBuildTarget;
        public readonly string? DotNetArguments;
        public readonly string? DotNetVersion;
        public readonly string? BuildCommand;
        public readonly string[] Solution;

        public readonly bool IgnoreErrors;
        public readonly bool Buildless;
        public readonly bool AllSolutions;
        public readonly bool NugetRestore;

        public readonly Language Language;
        public readonly bool Indexing;

        /// <summary>
        /// Reads options from environment variables.
        /// Throws ArgumentOutOfRangeException for invalid arguments.
        /// </summary>
        public AutobuildOptions(IBuildActions actions)
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
            Solution = actions.GetEnvironmentVariable(prefix + "SOLUTION").AsListWithExpandedEnvVars(actions, new string[0]);

            IgnoreErrors = actions.GetEnvironmentVariable(prefix + "IGNORE_ERRORS").AsBool("ignore_errors", false);
            Buildless = actions.GetEnvironmentVariable(prefix + "BUILDLESS").AsBool("buildless", false);
            AllSolutions = actions.GetEnvironmentVariable(prefix + "ALL_SOLUTIONS").AsBool("all_solutions", false);
            NugetRestore = actions.GetEnvironmentVariable(prefix + "NUGET_RESTORE").AsBool("nuget_restore", true);

            Language = actions.GetEnvironmentVariable("LGTM_PROJECT_LANGUAGE").AsLanguage();
            Indexing = !actions.GetEnvironmentVariable("CODEQL_AUTOBUILDER_CSHARP_NO_INDEXING").AsBool("no_indexing", false);
        }
    }

    public static class OptionsExtensions
    {
        public static bool AsBool(this string? value, string param, bool defaultValue)
        {
            if (value == null) return defaultValue;
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

        public static Language AsLanguage(this string? key)
        {
            switch (key)
            {
                case null:
                    throw new ArgumentException("Environment variable required: LGTM_PROJECT_LANGUAGE");
                case "csharp":
                    return Language.CSharp;
                case "cpp":
                    return Language.Cpp;
                default:
                    throw new ArgumentException("Language key not understood: '" + key + "'");
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

        static readonly Regex linuxEnvRegEx = new Regex(@"\$([a-zA-Z_][a-zA-Z_0-9]*)", RegexOptions.Compiled);

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
