using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Newtonsoft.Json.Linq;

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

        /// <summary>
        /// Class needed for deserializing parts of an assets file.
        /// It holds information about a reference.
        /// </summary>
        private class ReferenceInfo
        {
            /// <summary>
            /// This carries the type of the reference.
            /// We are only interested in package references.
            /// </summary>
            public string Type { get; set; } = "";

            /// <summary>
            /// If not a .NET framework reference we assume that only the files mentioned
            /// in the compile section are needed for compilation.
            /// </summary>
            public Dictionary<string, object> Compile { get; set; } = new();
        }

        /// <summary>
        /// Gets the package dependencies from the assets file.
        /// 
        /// Parse a part of the JSon assets file and returns the paths
        /// to the dependencies required for compilation.
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
        /// Returns {
        ///   "castle.core/4.4.1/lib/netstandard1.5/Castle.Core.dll",
        ///   "json.net/1.0.33/lib/netstandard2.0/Json.Net.dll"
        /// }
        /// </summary>
        private IEnumerable<string> GetPackageDependencies(JObject json)
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
                return Array.Empty<string>();
            }

            // Find all the compile dependencies for each reference and
            // create the relative path to the dependency.
            var dependencies = references
                .SelectMany(r =>
                {
                    var info = r.Value;
                    var name = r.Key.ToLowerInvariant();
                    if (info.Type != "package")
                    {
                        return Array.Empty<string>();
                    }

                    // If this is a .NET framework reference then include everything.
                    return netFrameworks.Any(framework => name.StartsWith(framework))
                        ? new[] { name }
                        : info
                            .Compile
                            .Select(p => Path.Combine(name, ParseFilePath(p.Key)));
                })
                .ToList();

            return dependencies;
        }

        /// <summary>
        /// Parse `json` as project.assets.json content and populate `dependencies` with the
        /// relative paths to the dependencies required for compilation.
        /// </summary>
        /// <returns>True if parsing succeeds, otherwise false.</returns>
        public bool TryParse(string json, out IEnumerable<string> dependencies)
        {
            dependencies = Array.Empty<string>();

            try
            {
                var obj = JObject.Parse(json);
                var packages = GetPackageDependencies(obj);

                dependencies = packages.ToList();

                return true;
            }
            catch (Exception e)
            {
                progressMonitor.LogDebug($"Failed to parse assets file (unexpected error): {e.Message}");
                return false;
            }
        }
    }

    internal static class JsonExtensions
    {
        internal static JObject? GetProperty(this JObject json, string property) =>
            json[property] as JObject;
    }
}
