using System;
using System.Collections.Generic;
using System.Linq;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal static class AssemblyCacheExtensions
    {
        private static readonly Version emptyVersion = new Version(0, 0, 0, 0);

        /// <summary>
        /// This method orders AssemblyInfos by version numbers (.net core version first, then assembly version). Finally, it orders by filename to make the order deterministic.
        /// </summary>
        public static IOrderedEnumerable<AssemblyInfo> OrderAssemblyInfosByPreference(this IEnumerable<AssemblyInfo> assemblies, IEnumerable<string> frameworkPaths)
        {
            // prefer framework assemblies over others
            int initialOrdering(AssemblyInfo info) => frameworkPaths.Any(framework => info.Filename.StartsWith(framework, StringComparison.OrdinalIgnoreCase)) ? 1 : 0;

            var ordered = assemblies is IOrderedEnumerable<AssemblyInfo> o
                ? o.ThenBy(initialOrdering)
                : assemblies.OrderBy(initialOrdering);

            return ordered
                .ThenBy(info => info.NetCoreVersion ?? emptyVersion)
                .ThenBy(info => info.Version ?? emptyVersion)
                .ThenBy(info => info.Filename);
        }
    }
}
