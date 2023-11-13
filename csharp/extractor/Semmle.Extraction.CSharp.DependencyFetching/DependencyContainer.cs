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
        public List<string> Paths { get; } = new();

        /// <summary>
        /// Packages that are used as a part of the required dependencies.
        /// </summary>
        public HashSet<string> Packages { get; } = new();

        /// <summary>
        /// In most cases paths in asset files point to dll's or the empty _._ file, which
        /// is sometimes there to avoid the directory being empty.
        /// That is, if the path specifically adds a .dll we use that, otherwise we as a fallback
        /// add the entire directory (which should be fine in case of _._ as well).
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
            package
                .Split(Path.DirectorySeparatorChar)
                .First();

        /// <summary>
        /// Add a dependency inside a package.
        /// </summary>
        public void Add(string package, string dependency)
        {
            var p = package.Replace('/', Path.DirectorySeparatorChar);
            var d = dependency.Replace('/', Path.DirectorySeparatorChar);

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
}