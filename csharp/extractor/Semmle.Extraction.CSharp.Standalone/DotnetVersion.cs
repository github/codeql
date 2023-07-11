using System;
using System.IO;

namespace Semmle.Extraction.CSharp.Standalone
{
    /// <summary>
    /// Either a dotnet runtime or an sdk version with its install location.
    /// </summary>
    internal sealed class DotnetVersion : IComparable<DotnetVersion>
    {
        private readonly string installDir;
        private readonly Version version;
        private readonly Version? preReleaseVersion;
        private readonly string? preReleaseVersionType;
        private bool IsPreRelease => preReleaseVersionType is not null && preReleaseVersion is not null;
        public string FullPath
        {
            get
            {
                var preRelease = IsPreRelease ? $"-{preReleaseVersionType}.{preReleaseVersion}" : "";
                var version = this.version + preRelease;
                return Path.Combine(installDir, version);
            }
        }

        public DotnetVersion(string installDir, string version, string preReleaseVersionType, string preReleaseVersion)
        {
            this.installDir = installDir;
            this.version = Version.Parse(version);
            if (!string.IsNullOrEmpty(preReleaseVersion) && !string.IsNullOrEmpty(preReleaseVersionType))
            {
                this.preReleaseVersionType = preReleaseVersionType;
                this.preReleaseVersion = Version.Parse(preReleaseVersion);
            }
        }

        public int CompareTo(DotnetVersion? other)
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

        public override bool Equals(object? obj) =>
            obj is not null && obj is DotnetVersion other && other.FullPath == FullPath;

        public override int GetHashCode() => FullPath.GetHashCode();

        public override string ToString() => FullPath;
    }
}
