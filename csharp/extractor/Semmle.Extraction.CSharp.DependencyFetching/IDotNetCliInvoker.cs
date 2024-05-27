using System.Collections.Generic;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal interface IDotNetCliInvoker
    {
        /// <summary>
        /// The name of the dotnet executable.
        /// </summary>
        string Exec { get; }

        /// <summary>
        /// Execute `dotnet <args>` and return true if the command succeeded, otherwise false.
        /// If `silent` is true the output of the command is logged as `debug` otherwise as `info`.
        /// </summary>
        bool RunCommand(string args, bool silent = true);

        /// <summary>
        /// Execute `dotnet <args>` and return true if the command succeeded, otherwise false.
        /// The output of the command is returned in `output`.
        /// If `silent` is true the output of the command is logged as `debug` otherwise as `info`.
        /// </summary>
        bool RunCommand(string args, out IList<string> output, bool silent = true);

        /// <summary>
        /// Execute `dotnet <args>` in `<workingDirectory>` and return true if the command succeeded, otherwise false.
        /// The output of the command is returned in `output`.
        /// If `silent` is true the output of the command is logged as `debug` otherwise as `info`.
        /// </summary>
        bool RunCommand(string args, string? workingDirectory, out IList<string> output, bool silent = true);
    }
}
