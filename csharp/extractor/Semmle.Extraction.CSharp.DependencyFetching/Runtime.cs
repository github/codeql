using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;
using Semmle.Util;
using Semmle.Util.Logging;

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
        private readonly Lazy<Dictionary<string, DotNetVersion>> newestRuntimes;
        private Dictionary<string, DotNetVersion> NewestRuntimes => newestRuntimes.Value;

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
        private static Dictionary<string, DotNetVersion> ParseRuntimes(IList<string> listed)
        {
            // Parse listed runtimes.
            var runtimes = new Dictionary<string, DotNetVersion>();
            var regex = RuntimeRegex();
            listed.ForEach(r =>
            {
                var match = regex.Match(r);
                if (match.Success)
                {
                    runtimes.AddOrUpdateToLatest(match.Groups[1].Value, new DotNetVersion(match.Groups[6].Value, match.Groups[2].Value, match.Groups[4].Value, match.Groups[5].Value));
                }
            });

            return runtimes;
        }

        /// <summary>
        /// Returns a dictionary mapping runtimes to their newest version.
        /// </summary>
        internal Dictionary<string, DotNetVersion> GetNewestRuntimes()
        {
            var listed = dotNet.GetListedRuntimes();
            return ParseRuntimes(listed);
        }

        /// <summary>
        /// Locates .NET Desktop Runtimes.
        /// This includes Mono and Microsoft.NET.
        /// </summary>
        private IEnumerable<string> DesktopRuntimes
        {
            get
            {
                if (Directory.Exists(@"C:\Windows\Microsoft.NET\Framework64"))
                {
                    return Directory.EnumerateDirectories(@"C:\Windows\Microsoft.NET\Framework64", "v*")
                        .OrderByDescending(Path.GetFileName);
                }

                var monoPath = FileUtils.FindProgramOnPath(Win32.IsWindows() ? "mono.exe" : "mono");
                string[] monoDirs = monoPath is not null
                    ? [Path.GetFullPath(Path.Combine(monoPath, "..", "lib", "mono")), monoPath]
                    : ["/usr/lib/mono", "/usr/local/mono", "/usr/local/bin/mono", @"C:\Program Files\Mono\lib\mono"];

                var monoDir = monoDirs.FirstOrDefault(Directory.Exists);
                if (monoDir is not null)
                {
                    return Directory.EnumerateDirectories(monoDir)
                        .Where(d => char.IsDigit(Path.GetFileName(d)[0]))
                        .OrderByDescending(Path.GetFileName);
                }

                return [];
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
        /// Gets the Dotnet Core location.
        /// </summary>
        public string? NetCoreRuntime => GetVersion(netCoreApp);

        /// <summary>
        /// Gets the .NET Framework location. Either the installation folder on Windows or Mono
        /// </summary>
        public string? DesktopRuntime => DesktopRuntimes?.FirstOrDefault();

        /// <summary>
        /// Gets the executing runtime location, this is the self contained runtime shipped in the CodeQL CLI bundle.
        /// </summary>
        public string ExecutingRuntime => RuntimeEnvironment.GetRuntimeDirectory();

        /// <summary>
        /// Gets the ASP.NET Core location.
        /// </summary>
        public string? AspNetCoreRuntime => GetVersion(aspNetCoreApp);
    }
}
