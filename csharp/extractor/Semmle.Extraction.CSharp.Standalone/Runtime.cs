using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Standalone
{
    /// <summary>
    /// Locates .NET Runtimes.
    /// </summary>
    static class Runtime
    {
        static string ExecutingRuntime => RuntimeEnvironment.GetRuntimeDirectory();

        /// <summary>
        /// Locates .NET Core Runtimes.
        /// </summary>
        public static IEnumerable<string> CoreRuntimes
        {
            get
            {
                string[] dotnetDirs = { "/usr/share/dotnet", @"C:\Program Files\dotnet" };

                foreach (var dir in dotnetDirs.Where(Directory.Exists))
                    return Directory.EnumerateDirectories(Path.Combine(dir, "shared", "Microsoft.NETCore.App")).
                        OrderByDescending(d => Path.GetFileName(d));
                return Enumerable.Empty<string>();
            }
        }

        /// <summary>
        /// Locates .NET Desktop Runtimes.
        /// This includes Mono and Microsoft.NET.
        /// </summary>
        public static IEnumerable<string> DesktopRuntimes
        {
            get
            {
                string[] monoDirs = { "/usr/lib/mono", @"C:\Program Files\Mono\lib\mono" };

                if (Directory.Exists(@"C:\Windows\Microsoft.NET\Framework64"))
                {
                    return System.IO.Directory.EnumerateDirectories(@"C:\Windows\Microsoft.NET\Framework64", "v*").
                        OrderByDescending(d => Path.GetFileName(d));
                }

                foreach (var dir in monoDirs.Where(Directory.Exists))
                {
                    return System.IO.Directory.EnumerateDirectories(dir).
                        Where(d => Char.IsDigit(Path.GetFileName(d)[0])).
                        OrderByDescending(d => Path.GetFileName(d));
                }

                return Enumerable.Empty<string>();
            }
        }

        public static IEnumerable<string> Runtimes
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
