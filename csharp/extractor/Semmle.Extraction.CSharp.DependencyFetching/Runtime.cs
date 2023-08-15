using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Locates .NET Runtimes.
    /// </summary>
    internal partial class Runtime
    {
        private const string netCoreApp = "Microsoft.NETCore.App";
        private const string aspNetCoreApp = "Microsoft.AspNetCore.App";

        private readonly IDotNet dotNet;
        private readonly Lazy<Dictionary<string, DotnetVersion>> newestRuntimes;
        private Dictionary<string, DotnetVersion> NewestRuntimes => newestRuntimes.Value;
        private static string ExecutingRuntime => RuntimeEnvironment.GetRuntimeDirectory();

        public Runtime(IDotNet dotNet)
        {
            this.dotNet = dotNet;
            this.newestRuntimes = new(GetNewestRuntimes);
        }

        [GeneratedRegex(@"^(\S+)\s(\d+\.\d+\.\d+)(-([a-z]+)\.(\d+\.\d+\.\d+))?\s\[(.+)\]$")]
        private static partial Regex RuntimeRegex();

        /// <summary>
        /// Parses the output of `dotnet --list-runtimes` to get a map from a runtime to the location of
        /// the newest version of the runtime.
        /// It is assume that the format of a listed runtime is something like:
        /// Microsoft.NETCore.App 7.0.2 [/usr/share/dotnet/shared/Microsoft.NETCore.App]
        /// </summary>
        private static Dictionary<string, DotnetVersion> ParseRuntimes(IList<string> listed)
        {
            // Parse listed runtimes.
            var runtimes = new Dictionary<string, DotnetVersion>();
            var regex = RuntimeRegex();
            listed.ForEach(r =>
            {
                var match = regex.Match(r);
                if (match.Success)
                {
                    runtimes.AddOrUpdateToLatest(match.Groups[1].Value, new DotnetVersion(match.Groups[6].Value, match.Groups[2].Value, match.Groups[4].Value, match.Groups[5].Value));
                }
            });

            return runtimes;
        }

        /// <summary>
        /// Returns a dictionary mapping runtimes to their newest version.
        /// </summary>
        internal Dictionary<string, DotnetVersion> GetNewestRuntimes()
        {
            var listed = dotNet.GetListedRuntimes();
            return ParseRuntimes(listed);
        }

        /// <summary>
        /// Locates .NET Desktop Runtimes.
        /// This includes Mono and Microsoft.NET.
        /// </summary>
        private static IEnumerable<string> DesktopRuntimes
        {
            get
            {
                var monoPath = FileUtils.FindProgramOnPath(Win32.IsWindows() ? "mono.exe" : "mono");
                var monoDirs = monoPath is not null
                    ? new[] { monoPath }
                    : new[] { "/usr/lib/mono", @"C:\Program Files\Mono\lib\mono" };

                if (Directory.Exists(@"C:\Windows\Microsoft.NET\Framework64"))
                {
                    return Directory.EnumerateDirectories(@"C:\Windows\Microsoft.NET\Framework64", "v*")
                        .OrderByDescending(Path.GetFileName);
                }

                var dir = monoDirs.FirstOrDefault(Directory.Exists);

                if (dir is not null)
                {
                    return Directory.EnumerateDirectories(dir)
                        .Where(d => Char.IsDigit(Path.GetFileName(d)[0]))
                        .OrderByDescending(Path.GetFileName);
                }

                return Enumerable.Empty<string>();
            }
        }

        private string? GetVersion(string framework)
        {
            if (NewestRuntimes.TryGetValue(framework, out var version))
            {
                var refAssemblies = version.FullPathReferenceAssemblies;
                return Directory.Exists(refAssemblies)
                    ? refAssemblies
                    : version.FullPath;
            }
            return null;
        }

        /// <summary>
        /// Gets the .NET runtime location to use for extraction.
        /// </summary>
        public string GetRuntime(bool useSelfContained)
        {
            if (useSelfContained)
            {
                return ExecutingRuntime;
            }

            // Location of the newest .NET Core Runtime.
            if (GetVersion(netCoreApp) is string path)
            {
                return path;
            }

            if (DesktopRuntimes.Any())
            {
                return DesktopRuntimes.First();
            }

            // A bad choice if it's the self-contained runtime distributed in codeql dist.
            return ExecutingRuntime;
        }

        /// <summary>
        /// Gets the ASP.NET runtime location to use for extraction, if one exists.
        /// </summary>
        public string? GetAspRuntime() => GetVersion(aspNetCoreApp);
    }
}
