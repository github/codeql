using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal interface IDotNetCliInvoker
    {
        /// <summary>
        /// The name of the dotnet executable.
        /// </summary>
        string Exec { get; }

        /// <summary>
        /// A minimal environment for running the .NET CLI.
        /// 
        /// DOTNET_CLI_UI_LANGUAGE: The .NET CLI language is set to English to avoid localized output.
        /// MSBUILDDISABLENODEREUSE: To ensure clean environment for each build.
        /// DOTNET_SKIP_FIRST_TIME_EXPERIENCE: To skip first time experience messages.
        /// </summary>
        static ReadOnlyDictionary<string, string> MinimalEnvironment { get; } = new(new Dictionary<string, string>
        {
            {"DOTNET_CLI_UI_LANGUAGE", "en"},
            {"MSBUILDDISABLENODEREUSE", "1"},
            {"DOTNET_SKIP_FIRST_TIME_EXPERIENCE", "true"}
        });

        /// <summary>
        /// Execute `dotnet <paramref name="args"/>` and return true if the command succeeded, otherwise false.
        /// If `silent` is true the output of the command is logged as `debug` otherwise as `info`.
        /// </summary>
        bool RunCommand(string args, bool silent = true);

        /// <summary>
        /// Execute `dotnet <paramref name="args"/>` and return the exit code.
        /// If `silent` is true the output of the command is logged as `debug` otherwise as `info`.
        /// </summary>
        int RunCommandExitCode(string args, bool silent = true);

        /// <summary>
        /// Execute `dotnet <paramref name="args"/>` and return true if the command succeeded, otherwise false.
        /// The output of the command is returned in `output`.
        /// If `silent` is true the output of the command is logged as `debug` otherwise as `info`.
        /// </summary>
        bool RunCommand(string args, out IList<string> output, bool silent = true);

        /// <summary>
        /// Execute `dotnet <paramref name="args"/>` in `<paramref name="workingDirectory"/>` and return true if the command succeeded, otherwise false.
        /// The output of the command is returned in `output`.
        /// If `silent` is true the output of the command is logged as `debug` otherwise as `info`.
        /// </summary>
        bool RunCommand(string args, string? workingDirectory, out IList<string> output, bool silent = true);
    }
}
