using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public interface IFileProvider
    {
        DirectoryInfo SourceDir { get; }
        IEnumerable<string> SmallNonBinary { get; }
        IEnumerable<string> Sources { get; }
        ICollection<string> Projects { get; }
        ICollection<string> Solutions { get; }
        IEnumerable<string> Dlls { get; }
        ICollection<string> NugetConfigs { get; }
        ICollection<string> NugetExes { get; }
        string? RootNugetConfig { get; }
        IEnumerable<string> GlobalJsons { get; }
        ICollection<string> PackagesConfigs { get; }
        ICollection<string> RazorViews { get; }
        ICollection<string> Resources { get; }
    }
}
