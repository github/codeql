using System.Collections.Generic;
using System.Linq;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal static class FrameworkPackageNames
    {
        public static string AspNetCoreFramework { get; } = "microsoft.aspnetcore.app.ref";

        public static string WindowsDesktopFramework { get; } = "microsoft.windowsdesktop.app.ref";

        // The order of the packages is important.
        public static string[] NetFrameworks { get; } = new string[]
            {
                "microsoft.netcore.app.ref", // net7.0, ... net5.0, netcoreapp3.1, netcoreapp3.0
                "microsoft.netframework.referenceassemblies.", // net48, ..., net20
                "netstandard.library.ref", // netstandard2.1
                "netstandard.library" // netstandard2.0
            };

        public static IEnumerable<string> AllFrameworks { get; } =
            NetFrameworks
                .Union(new string[] { AspNetCoreFramework, WindowsDesktopFramework });
    }
}
