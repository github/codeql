using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Autobuild
{
    /// <summary>
    /// A file that can be the target in an invocation of `msbuild` or `dotnet build`.
    /// Either a solution file or a project file (`.proj`, `.csproj`, or `.vcxproj`).
    /// </summary>
    public interface IProjectOrSolution
    {
        /// <summary>
        /// Gets the full path of this file.
        /// </summary>
        string FullPath { get; }

        /// <summary>
        /// Gets a list of other projects included by this file.
        /// </summary>
        IEnumerable<IProjectOrSolution> IncludedProjects { get; }
    }

    public abstract class ProjectOrSolution : IProjectOrSolution
    {
        public string FullPath { get; private set; }

        protected ProjectOrSolution(Autobuilder builder, string path)
        {
            FullPath = builder.Actions.GetFullPath(path);
        }

        public abstract IEnumerable<IProjectOrSolution> IncludedProjects { get; }

        public override string ToString() => FullPath;
    }

    public static class IProjectOrSolutionExtensions
    {
        /// <summary>
        /// Holds if this file includes a project with code from language <paramref name="l"/>.
        /// </summary>
        public static bool HasLanguage(this IProjectOrSolution p, Language l) =>
            l.ProjectFileHasThisLanguage(p.FullPath) ||
            p.IncludedProjects.Any(p0 => l.ProjectFileHasThisLanguage(p0.FullPath));
    }
}
