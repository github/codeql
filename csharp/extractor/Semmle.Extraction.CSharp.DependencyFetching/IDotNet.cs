using System.Collections.Generic;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal interface IDotNet
    {
        bool RestoreProjectToDirectory(string project, string directory, bool forceDotnetRefAssemblyFetching, out IEnumerable<string> assets, string? pathToNugetConfig = null);
        bool RestoreSolutionToDirectory(string solutionFile, string packageDirectory, bool forceDotnetRefAssemblyFetching, out IEnumerable<string> projects, out IEnumerable<string> assets);
        bool New(string folder);
        bool AddPackage(string folder, string package);
        IList<string> GetListedRuntimes();
        IList<string> GetListedSdks();
        bool Exec(string execArgs);
    }
}
