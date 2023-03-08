using System.Collections.Generic;
using System.Linq;
using Semmle.Util;

namespace Semmle.Autobuild.Shared
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
        /// Gets a list of other projects directly included by this file.
        /// </summary>
        IEnumerable<IProjectOrSolution> IncludedProjects { get; }
    }

    public abstract class ProjectOrSolution<TAutobuildOptions> : IProjectOrSolution where TAutobuildOptions : AutobuildOptionsShared
    {
        public string FullPath { get; }

        public string DirectoryName { get; }

        protected ProjectOrSolution(Autobuilder<TAutobuildOptions> builder, string path)
        {
            FullPath = builder.Actions.GetFullPath(path);
            DirectoryName = builder.Actions.GetDirectoryName(path) ?? "";
        }

        public abstract IEnumerable<IProjectOrSolution> IncludedProjects { get; }

        public override string ToString() => FullPath;
    }

    public static class IProjectOrSolutionExtensions
    {
        /// <summary>
        /// Holds if this file includes a project with code from language <paramref name="l"/>.
        /// </summary>
        public static bool HasLanguage(this IProjectOrSolution p, Language l)
        {
            bool HasLanguage(IProjectOrSolution p0, HashSet<string> seen)
            {
                if (seen.Contains(p0.FullPath))
                    return false;
                seen.Add(p0.FullPath); // guard against cyclic includes
                return l.ProjectFileHasThisLanguage(p0.FullPath) || p0.IncludedProjects.Any(p1 => HasLanguage(p1, seen));
            }
            return HasLanguage(p, new HashSet<string>());
        }
    }
}
