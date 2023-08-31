using System.Collections.Generic;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal interface IDotNet
    {
        bool RestoreProjectToDirectory(string project, string directory, string? pathToNugetConfig = null);
        bool RestoreSolutionToDirectory(string solution, string directory, out IList<string> projects);
        bool New(string folder);
        bool AddPackage(string folder, string package);
        IList<string> GetListedRuntimes();
        IList<string> GetListedSdks();
        bool Exec(string execArgs);
    }
}
