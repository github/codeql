using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using System.Linq;
using Newtonsoft.Json.Linq;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Class for parsing project.assets.json files.
    /// </summary>
    internal class Assets
    {
        private readonly ILogger logger;

        /// <summary>
        /// Contains the dependencies found in the parsed assets files.
        /// </summary>
        public DependencyContainer Dependencies { get; } = new();

        internal Assets(ILogger logger)
        {
            this.logger = logger;
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
        /// Adds the following dependencies
        ///   Paths: {
        ///     "castle.core/4.4.1/lib/netstandard1.5/Castle.Core.dll",
        ///     "json.net/1.0.33/lib/netstandard2.0/Json.Net.dll"
        ///   }
        ///   Packages: {
        ///     "castle.core",
        ///     "json.net"
        ///   }
        /// </summary>
        private void AddPackageDependencies(JObject json, string jsonPath)
        {
            // If there is more than one framework we need to pick just one.
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
                logger.LogDebug($"No references found in the targets section in '{jsonPath}'");
                return;
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

                    if (info.Compile is null || !info.Compile.Any())
                    {
                        // If this is a framework reference then include everything.
                        if (FrameworkPackageNames.AllFrameworks.Any(framework => name.StartsWith(framework)))
                        {
                            Dependencies.AddFramework(name);
                        }
                        return;
                    }

                    info.Compile
                        .ForEach(r => Dependencies.Add(name, r.Key));
                });
        }

        /// <summary>
        /// Add the framework dependencies from the assets file to dependencies.
        ///
        /// Example:
        /// "project": {
        ///    "version": "1.0.0",
        ///    "frameworks": {
        ///        "net7.0": {
        ///            "frameworkReferences": {
        ///                "Microsoft.AspNetCore.App": {
        ///                    "privateAssets": "none"
        ///                },
        ///                "Microsoft.NETCore.App": {
        ///                    "privateAssets": "all"
        ///                }
        ///            }
        ///        }
        ///    }
        /// }
        ///
        /// Adds the following dependencies
        ///   Paths: {
        ///     "microsoft.aspnetcore.app.ref",
        ///     "microsoft.netcore.app.ref"
        ///   }
        ///   Packages: {
        ///     "microsoft.aspnetcore.app.ref",
        ///     "microsoft.netcore.app.ref"
        ///   }
        /// </summary>
        private void AddFrameworkDependencies(JObject json, string jsonPath)
        {

            var frameworks = json
                .GetProperty("project")?
                .GetProperty("frameworks");

            if (frameworks is null)
            {
                logger.LogDebug($"No framework section in '{jsonPath}'.");
                return;
            }

            // If there is more than one framework we need to pick just one.
            // To ensure stability we pick one based on the lexicographic order of
            // the framework names.
            var references = frameworks
                .Properties()?
                .MaxBy(p => p.Name)?
                .Value["frameworkReferences"] as JObject;

            if (references is null)
            {
                logger.LogDebug($"No framework references in '{jsonPath}'.");
                return;
            }

            references
                .Properties()
                .ForEach(f => Dependencies.AddFramework($"{f.Name}.Ref".ToLowerInvariant()));
        }

        /// <summary>
        /// Parse `json` as project.assets.json content and add relative paths to the dependencies
        /// (together with used package information) required for compilation.
        /// </summary>
        /// <returns>True if parsing succeeds, otherwise false.</returns>
        public bool TryParse(string json, string jsonPath)
        {
            try
            {
                var obj = JObject.Parse(json);
                AddPackageDependencies(obj, jsonPath);
                AddFrameworkDependencies(obj, jsonPath);
                return true;
            }
            catch (Exception e)
            {
                logger.LogDebug($"Failed to parse assets file (unexpected error): {e.Message}");
                return false;
            }
        }

        private static bool TryReadAllText(string path, ILogger logger, [NotNullWhen(returnValue: true)] out string? content)
        {
            try
            {
                content = File.ReadAllText(path);
                return true;
            }
            catch (Exception e)
            {
                logger.LogInfo($"Failed to read assets file '{path}': {e.Message}");
                content = null;
                return false;
            }
        }

        /// <summary>
        /// Add the dependencies from the assets file to the dependencies.
        /// </summary>
        /// <param name="asset">Path to an assets file.</param>
        public void AddDependencies(string asset)
        {
            if (TryReadAllText(asset, logger, out var json))
            {
                TryParse(json, asset);
            }
        }

        /// <summary>
        /// Add the dependencies from the assets files to the dependencies.
        /// </summary>
        /// <param name="assets">Collection of paths to assets files.</param>
        public void AddDependenciesRange(IEnumerable<string> assets) =>
            assets.ForEach(AddDependencies);
    }

    internal static class JsonExtensions
    {
        internal static JObject? GetProperty(this JObject json, string property) =>
            json[property] as JObject;
    }
}
