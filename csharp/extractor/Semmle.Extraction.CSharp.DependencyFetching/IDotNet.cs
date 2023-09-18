using System.Collections.Generic;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal interface IDotNet
    {
        bool RestoreProjectToDirectory(string project, string directory, out string stdout, string? pathToNugetConfig = null);
        bool RestoreSolutionToDirectory(string solutionFile, string packageDirectory, out IEnumerable<string> projects);
        bool New(string folder, out string stdout);
        bool AddPackage(string folder, string package, out string stdout);
        IList<string> GetListedRuntimes();
        IList<string> GetListedSdks();
        bool Exec(string execArgs);
    }
}
