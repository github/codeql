using System;
using System.IO;
using NuGet.Versioning;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal record DotNetVersion : IComparable<DotNetVersion>
    {
        private readonly string dir;
        private readonly NuGetVersion version;

        private string FullVersion =>
            version.ToString();

        public string FullPath => Path.Combine(dir, FullVersion);

        /**
         * The full path to the reference assemblies for this runtime.
         * This is the same as FullPath, except that we assume that the
         * reference assemblies are in a directory called "packs" and
         * the reference assemblies themselves are in a directory called
         * "[Framework].Ref/ref".
         * Example:
         *  FullPath: /usr/share/dotnet/shared/Microsoft.NETCore.App/7.0.2
         *  FullPathReferenceAssemblies: /usr/share/dotnet/packs/Microsoft.NETCore.App.Ref/7.0.2/ref
         */
        public string? FullPathReferenceAssemblies
        {
            get
            {
                var directories = dir.Split(Path.DirectorySeparatorChar);
                if (directories.Length >= 2)
                {
                    directories[^2] = "packs";
                    directories[^1] = $"{directories[^1]}.Ref";
                    return Path.Combine(string.Join(Path.DirectorySeparatorChar, directories), FullVersion, "ref");
                }
                return null;
            }
        }


        public DotNetVersion(string dir, NuGetVersion version)
        {
            this.dir = dir;
            this.version = version;
        }

        public int CompareTo(DotNetVersion? other) =>
            version.CompareTo(other?.version);

        public override string ToString() => FullPath;
    }
}
