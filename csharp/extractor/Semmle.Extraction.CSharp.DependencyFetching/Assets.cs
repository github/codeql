using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Newtonsoft.Json.Linq;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Class for parsing project.assets.json files.
    /// </summary>
    internal class Assets
    {
        private readonly ProgressMonitor progressMonitor;

        private static readonly string[] netFrameworks = new[] {
            "microsoft.aspnetcore.app.ref",
            "microsoft.netcore.app.ref",
            "microsoft.netframework.referenceassemblies",
            "microsoft.windowsdesktop.app.ref",
            "netstandard.library.ref"
        };

        internal Assets(ProgressMonitor progressMonitor)
        {
            this.progressMonitor = progressMonitor;
        }

        /// <summary>
        /// Class needed for deserializing parts of an assets file.
        /// It holds information about a reference.
        ///
        /// Type carries the type of the reference.
        /// We are only interested in package references.
        ///
        /// Compile holds information about the files needed for compilation.
        /// However, if it is a .NET framework reference we assume that all files in the
        /// package are needed for compilation.
        /// </summary>
        private record class ReferenceInfo(string? Type, Dictionary<string, object>? Compile);

        /// <summary>
        /// Add the package dependencies from the assets file to dependencies.
        /// 
        /// Parse a part of the JSon assets file and add the paths
        /// to the dependencies required for compilation (and collect
        /// information about used packages).
        ///
        /// Example:
        /// {
        ///   "Castle.Core/4.4.1": {
        ///     "type": "package",
        ///     "compile": {
        ///       "lib/netstandard1.5/Castle.Core.dll": {
        ///         "related": ".xml"
        ///        }
        ///     }
        ///   },
        ///   "Json.Net/1.0.33": {
        ///     "type": "package",
        ///     "compile": {
        ///       "lib/netstandard2.0/Json.Net.dll": {}
        ///     },
        ///     "runtime": {
        ///       "lib/netstandard2.0/Json.Net.dll": {}
        ///     }
        ///   }
        /// }
        /// 
        /// Returns dependencies
        ///   RequiredPaths = {
        ///     "castle.core/4.4.1/lib/netstandard1.5/Castle.Core.dll",
        ///     "json.net/1.0.33/lib/netstandard2.0/Json.Net.dll"
        ///   }
        ///   UsedPackages = {
        ///     "castle.core",
        ///     "json.net"
        ///   }
        /// </summary>
        private DependencyContainer AddPackageDependencies(JObject json, DependencyContainer dependencies)
        {
            // If there are more than one framework we need to pick just one.
            // To ensure stability we pick one based on the lexicographic order of
            // the framework names.
            var references = json
                .GetProperty("targets")?
                .Properties()?
                .MaxBy(p => p.Name)?
                .Value
                .ToObject<Dictionary<string, ReferenceInfo>>();

            if (references is null)
            {
                progressMonitor.LogDebug("No references found in the targets section in the assets file.");
                return dependencies;
            }

            // Find all the compile dependencies for each reference and
            // create the relative path to the dependency.
            references
                .ForEach(r =>
                {
                    var info = r.Value;
                    var name = r.Key.ToLowerInvariant();
                    if (info.Type != "package")
                    {
                        return;
                    }

                    // If this is a .NET framework reference then include everything.
                    if (netFrameworks.Any(framework => name.StartsWith(framework)))
                    {
                        dependencies.Add(name);
                    }
                    else
                    {
                        info.Compile?
                            .ForEach(r => dependencies.Add(name, r.Key));
                    }
                });

            return dependencies;
        }

        /// <summary>
        /// Parse `json` as project.assets.json content and add relative paths to the dependencies
        /// (together with used package information) required for compilation.
        /// </summary>
        /// <returns>True if parsing succeeds, otherwise false.</returns>
        public bool TryParse(string json, DependencyContainer dependencies)
        {
            try
            {
                var obj = JObject.Parse(json);
                AddPackageDependencies(obj, dependencies);
                return true;
            }
            catch (Exception e)
            {
                progressMonitor.LogDebug($"Failed to parse assets file (unexpected error): {e.Message}");
                return false;
            }
        }

        public static DependencyContainer GetCompilationDependencies(ProgressMonitor progressMonitor, IEnumerable<string> assets)
        {
            var parser = new Assets(progressMonitor);
            var dependencies = new DependencyContainer();
            assets.ForEach(asset =>
            {
                var json = File.ReadAllText(asset);
                parser.TryParse(json, dependencies);
            });
            return dependencies;
        }
    }

    internal static class JsonExtensions
    {
        internal static JObject? GetProperty(this JObject json, string property) =>
            json[property] as JObject;
    }
}
