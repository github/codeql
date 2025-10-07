using System;
using System.IO;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal record DotNetVersion : IComparable<DotNetVersion>
    {
        private readonly string dir;
        private readonly Version version;
        private readonly Version? preReleaseVersion;
        private readonly string? preReleaseVersionType;
        private bool IsPreRelease => preReleaseVersionType is not null && preReleaseVersion is not null;

        private string FullVersion
        {
            get
            {
                var preRelease = IsPreRelease ? $"-{preReleaseVersionType}.{preReleaseVersion}" : "";
                return this.version + preRelease;
            }
        }

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


        public DotNetVersion(string dir, string version, string preReleaseVersionType, string preReleaseVersion)
        {
            this.dir = dir;
            this.version = Version.Parse(version);
            if (!string.IsNullOrEmpty(preReleaseVersion) && !string.IsNullOrEmpty(preReleaseVersionType))
            {
                this.preReleaseVersionType = preReleaseVersionType;
                this.preReleaseVersion = Version.Parse(preReleaseVersion);
            }
        }

        public int CompareTo(DotNetVersion? other)
        {
            var c = version.CompareTo(other?.version);
            if (c == 0 && IsPreRelease)
            {
                if (!other!.IsPreRelease)
                {
                    return -1;
                }

                // Both are pre-release like runtime versions.
                // The pre-release version types are sorted alphabetically (e.g. alpha, beta, preview, rc)
                // and the pre-release version types are more important that the pre-release version numbers.
                return preReleaseVersionType != other!.preReleaseVersionType
                    ? preReleaseVersionType!.CompareTo(other!.preReleaseVersionType)
                    : preReleaseVersion!.CompareTo(other!.preReleaseVersion);
            }

            return c;
        }

        public override string ToString() => FullPath;
    }
}
