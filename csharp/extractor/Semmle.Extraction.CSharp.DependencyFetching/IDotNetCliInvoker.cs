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
        /// </summary>
        bool RunCommand(string args);

        /// <summary>
        /// Execute `dotnet <args>` and return true if the command succeeded, otherwise false.
        /// The output of the command is returned in `output`.
        /// </summary>
        bool RunCommand(string args, out IList<string> output);
    }
}
