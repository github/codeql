﻿using System;
using System.Linq;

namespace Semmle.Autobuild
{
    /// <summary>
    /// Encapsulates build options.
    /// </summary>
    public class AutobuildOptions
    {
        public readonly int SearchDepth = 3;
        public string RootDirectory = null;
        static readonly string prefix = "LGTM_INDEX_";

        public string VsToolsVersion;
        public string MsBuildArguments;
        public string MsBuildPlatform;
        public string MsBuildConfiguration;
        public string MsBuildTarget;
        public string DotNetArguments;
        public string DotNetVersion;
        public string BuildCommand;
        public string[] Solution;

        public bool IgnoreErrors;
        public bool Buildless;
        public bool AllSolutions;
        public bool NugetRestore;

        public Language Language;

        /// <summary>
        /// Reads options from environment variables.
        /// Throws ArgumentOutOfRangeException for invalid arguments.
        /// </summary>
        public void ReadEnvironment(IBuildActions actions)
        {
            RootDirectory = actions.GetCurrentDirectory();
            VsToolsVersion = actions.GetEnvironmentVariable(prefix + "VSTOOLS_VERSION");
            MsBuildArguments = actions.GetEnvironmentVariable(prefix + "MSBUILD_ARGUMENTS");
            MsBuildPlatform = actions.GetEnvironmentVariable(prefix + "MSBUILD_PLATFORM");
            MsBuildConfiguration = actions.GetEnvironmentVariable(prefix + "MSBUILD_CONFIGURATION");
            MsBuildTarget = actions.GetEnvironmentVariable(prefix + "MSBUILD_TARGET");
            DotNetArguments = actions.GetEnvironmentVariable(prefix + "DOTNET_ARGUMENTS");
            DotNetVersion = actions.GetEnvironmentVariable(prefix + "DOTNET_VERSION");
            BuildCommand = actions.GetEnvironmentVariable(prefix + "BUILD_COMMAND");
            Solution = actions.GetEnvironmentVariable(prefix + "SOLUTION").AsList(new string[0]);

            IgnoreErrors = actions.GetEnvironmentVariable(prefix + "IGNORE_ERRORS").AsBool("ignore_errors", false);
            Buildless = actions.GetEnvironmentVariable(prefix + "BUILDLESS").AsBool("buildless", false);
            AllSolutions = actions.GetEnvironmentVariable(prefix + "ALL_SOLUTIONS").AsBool("all_solutions", false);
            NugetRestore = actions.GetEnvironmentVariable(prefix + "NUGET_RESTORE").AsBool("nuget_restore", true);

            Language = actions.GetEnvironmentVariable("LGTM_PROJECT_LANGUAGE").AsLanguage();
        }
    }

    public static class OptionsExtensions
    {
        public static bool AsBool(this string value, string param, bool defaultValue)
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

        public static Language AsLanguage(this string key)
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

        public static string[] AsList(this string value, string[] defaultValue)
        {
            if (value == null)
                return defaultValue;

            return value.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries).ToArray();
        }
    }
}
