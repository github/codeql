using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Container class for dependencies found in the assets file.
    /// </summary>
    internal class DependencyContainer
    {
        /// <summary>
        /// Paths to dependencies required for compilation.
        /// </summary>
        public HashSet<string> Paths { get; } = [];

        /// <summary>
        /// Packages that are used as a part of the required dependencies.
        /// </summary>
        public HashSet<string> Packages { get; } = [];

        /// <summary>
        /// If the path specifically adds a .dll we use that, otherwise we as a fallback
        /// add the entire directory.
        /// </summary>
        private static string ParseFilePath(string path)
        {
            if (path.EndsWith(".dll"))
            {
                return path;
            }
            return Path.GetDirectoryName(path) ?? path;
        }

        private static string GetPackageName(string package) =>
            package.Split(Path.DirectorySeparatorChar)[0];

        /// <summary>
        /// Add a dependency inside a package.
        /// </summary>
        public void Add(string package, string dependency)
        {
            var p = package.Replace('/', Path.DirectorySeparatorChar);
            var d = dependency.Replace('/', Path.DirectorySeparatorChar);

            // In most cases paths in assets files point to dll's or the empty _._ file.
            // That is, for _._ we don't need to add anything.
            if (Path.GetFileName(d) == "_._")
            {
                return;
            }

            var path = Path.Combine(p, ParseFilePath(d));
            Paths.Add(path);
            Packages.Add(GetPackageName(p));
        }

        /// <summary>
        /// Add a dependency to an entire framework package.
        /// </summary>
        public void AddFramework(string framework)
        {
            var p = framework.Replace('/', Path.DirectorySeparatorChar);

            Paths.Add(p);
            Packages.Add(GetPackageName(p));
        }
    }

    internal static class DependencyContainerExtensions
    {
        /// <summary>
        /// Flatten a list of containers into a single container.
        /// </summary>
        public static DependencyContainer Flatten(this IEnumerable<DependencyContainer> containers, DependencyContainer init) =>
            containers.Aggregate(init, (acc, container) =>
            {
                acc.Paths.UnionWith(container.Paths);
                acc.Packages.UnionWith(container.Packages);
                return acc;
            });
    }
}
