using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.IO;
using System.Linq;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.Standalone
{
    /// <summary>
    /// Locates .NET Runtimes.
    /// </summary>
    internal static class Runtime
    {
        private static string ExecutingRuntime => RuntimeEnvironment.GetRuntimeDirectory();

        /// <summary>
        /// Locates .NET Core Runtimes.
        /// </summary>
        private static IEnumerable<string> CoreRuntimes
        {
            get
            {
                var dotnetPath = FileUtils.FindProgramOnPath(Win32.IsWindows() ? "dotnet.exe" : "dotnet");
                var dotnetDirs = dotnetPath != null
                    ? new[] { dotnetPath }
                    : new[] { "/usr/share/dotnet", @"C:\Program Files\dotnet" };
                var coreDirs = dotnetDirs.Select(d => Path.Combine(d, "shared", "Microsoft.NETCore.App"));

                var dir = coreDirs.FirstOrDefault(Directory.Exists);
                if (dir is object)
                {
                    return Directory.EnumerateDirectories(dir).OrderByDescending(Path.GetFileName);
                }

                return Enumerable.Empty<string>();
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
                var monoDirs = monoPath != null
                    ? new[] { monoPath }
                    : new[] { "/usr/lib/mono", @"C:\Program Files\Mono\lib\mono" };

                if (Directory.Exists(@"C:\Windows\Microsoft.NET\Framework64"))
                {
                    return Directory.EnumerateDirectories(@"C:\Windows\Microsoft.NET\Framework64", "v*")
                        .OrderByDescending(Path.GetFileName);
                }

                var dir = monoDirs.FirstOrDefault(Directory.Exists);

                if (dir is object)
                {
                    return Directory.EnumerateDirectories(dir)
                        .Where(d => Char.IsDigit(Path.GetFileName(d)[0]))
                        .OrderByDescending(Path.GetFileName);
                }

                return Enumerable.Empty<string>();
            }
        }

        /// <summary>
        /// Gets the .NET runtime location to use for extraction
        /// </summary>
        public static string GetRuntime(bool useSelfContained) => useSelfContained ? ExecutingRuntime : Runtimes.First();

        private static IEnumerable<string> Runtimes
        {
            get
            {
                foreach (var r in CoreRuntimes)
                    yield return r;

                foreach (var r in DesktopRuntimes)
                    yield return r;

                // A bad choice if it's the self-contained runtime distributed in odasa dist.
                yield return ExecutingRuntime;
            }
        }
    }
}
