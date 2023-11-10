using System.Collections.Generic;
using System.Linq;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal static class FrameworkPackageNames
    {
        // The order of the packages is important.
        public static readonly string[] NetFrameworks = new string[]
            {
                "microsoft.netcore.app.ref", // net7.0, ... net5.0, netcoreapp3.1, netcoreapp3.0
                "microsoft.netframework.referenceassemblies.", // net48, ..., net20
                "netstandard.library.ref", // netstandard2.1
                "netstandard.library" // netstandard2.0
            };

        public static string AspNetCoreFramework =>
            "microsoft.aspnetcore.app.ref";

        public static string WindowsDesktopFramework =>
            "microsoft.windowsdesktop.app.ref";

        public static readonly IEnumerable<string> AllFrameworks =
            NetFrameworks
                .Union(new string[] { AspNetCoreFramework, WindowsDesktopFramework });
    }
}
