using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using Semmle.BuildAnalyser;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.Standalone
{
    /// <summary>
    /// Locates .NET Runtimes.
    /// </summary>
    internal partial class Runtime
    {
        private readonly DotNet dotNet;
        public Runtime(DotNet dotNet) => this.dotNet = dotNet;

        private sealed class Version : IComparable<Version>
        {
            private readonly string Dir;
            public int Major { get; }
            public int Minor { get; }
            public int Patch { get; }


            public string FullPath => Path.Combine(Dir, this.ToString());


            public Version(string version, string dir)
            {
                var parts = version.Split('.');
                Major = int.Parse(parts[0]);
                Minor = int.Parse(parts[1]);
                Patch = int.Parse(parts[2]);
                Dir = dir;
            }

            public int CompareTo(Version? other) =>
                other is null ? 1 : GetHashCode().CompareTo(other.GetHashCode());

            public override bool Equals(object? obj) =>
                obj is not null && obj is Version other && other.FullPath == FullPath;

            public override int GetHashCode() =>
                (Major * 1000 + Minor) * 1000 + Patch;

            public override string ToString() =>
                $"{Major}.{Minor}.{Patch}";
        }

        private static string ExecutingRuntime => RuntimeEnvironment.GetRuntimeDirectory();

        private static readonly string NetCoreApp = "Microsoft.NETCore.App";
        private static readonly string AspNetCoreApp = "Microsoft.AspNetCore.App";

        private static void AddOrUpdate(Dictionary<string, Version> dict, string framework, Version version)
        {
            if (!dict.TryGetValue(framework, out var existing) || existing.CompareTo(version) < 0)
            {
                dict[framework] = version;
            }
        }

        [GeneratedRegex(@"^(\S+)\s(\d+\.\d+\.\d+)\s\[(\S+)\]$")]
        private static partial Regex RuntimeRegex();

        /// <summary>
        /// Parses the output of `dotnet --list-runtimes` to get a map from a runtime to the location of
        /// the newest version of the runtime.
        /// It is assume that the format of a listed runtime is something like:
        /// Microsoft.NETCore.App 7.0.2 [/usr/share/dotnet/shared/Microsoft.NETCore.App]
        /// </summary>
        private static Dictionary<string, Version> ParseRuntimes(IList<string> listed)
        {
            // Parse listed runtimes.
            var runtimes = new Dictionary<string, Version>();
            listed.ForEach(r =>
            {
                var match = RuntimeRegex().Match(r);
                if (match.Success)
                {
                    AddOrUpdate(runtimes, match.Groups[1].Value, new Version(match.Groups[2].Value, match.Groups[3].Value));
                }
            });

            return runtimes;
        }

        private Dictionary<string, Version> GetNewestRuntimes()
        {
            try
            {
                var listed = dotNet.GetListedRuntimes();
                return ParseRuntimes(listed);
            }
            catch (Exception ex)
                when (ex is System.ComponentModel.Win32Exception || ex is FileNotFoundException)
            {
                return new Dictionary<string, Version>();
            }
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

        private IEnumerable<string> GetRuntimes()
        {
            // Gets the newest version of the installed runtimes.
            var newestRuntimes = GetNewestRuntimes();

            // Location of the newest .NET Core Runtime.
            if (newestRuntimes.TryGetValue(NetCoreApp, out var netCoreApp))
            {
                yield return netCoreApp.FullPath;
            }

            // Location of the newest ASP.NET Core Runtime.
            if (newestRuntimes.TryGetValue(AspNetCoreApp, out var aspNetCoreApp))
            {
                yield return aspNetCoreApp.FullPath;
            }

            foreach (var r in DesktopRuntimes)
                yield return r;

            // A bad choice if it's the self-contained runtime distributed in codeql dist.
            yield return ExecutingRuntime;
        }

        /// <summary>
        /// Gets the .NET runtime location to use for extraction
        /// </summary>
        public string GetRuntime(bool useSelfContained) => useSelfContained ? ExecutingRuntime : GetRuntimes().First();
    }
}
