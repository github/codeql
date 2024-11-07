using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public interface IDotNet
    {
        RestoreResult Restore(RestoreSettings restoreSettings);
        bool New(string folder);
        bool AddPackage(string folder, string package);
        IList<string> GetListedRuntimes();
        IList<string> GetListedSdks();
        bool Exec(string execArgs);
        IList<string> GetNugetFeeds(string nugetConfig);
        IList<string> GetNugetFeedsFromFolder(string folderPath);
    }

    public record class RestoreSettings(string File, string PackageDirectory, bool ForceDotnetRefAssemblyFetching, string? PathToNugetConfig = null, bool ForceReevaluation = false, bool TargetWindows = false);

    public partial record class RestoreResult(bool Success, IList<string> Output)
    {
        private readonly Lazy<IEnumerable<string>> assetsFilePaths = new(() => GetFirstGroupOnMatch(AssetsFileRegex(), Output));
        public IEnumerable<string> AssetsFilePaths => Success ? assetsFilePaths.Value : Array.Empty<string>();

        private readonly Lazy<IEnumerable<string>> restoredProjects = new(() => GetFirstGroupOnMatch(RestoredProjectRegex(), Output));
        public IEnumerable<string> RestoredProjects => Success ? restoredProjects.Value : Array.Empty<string>();

        private readonly Lazy<bool> hasNugetPackageSourceError = new(() => Output.Any(s => s.Contains("NU1301")));
        public bool HasNugetPackageSourceError => hasNugetPackageSourceError.Value;

        private readonly Lazy<bool> hasNugetNoStablePackageVersionError = new(() => Output.Any(s => s.Contains("NU1103")));
        public bool HasNugetNoStablePackageVersionError => hasNugetNoStablePackageVersionError.Value;

        private static IEnumerable<string> GetFirstGroupOnMatch(Regex regex, IEnumerable<string> lines) =>
            lines
                .Select(line => regex.Match(line))
                .Where(match => match.Success)
                .Select(match => match.Groups[1].Value);

        [GeneratedRegex("Restored\\s+(.+\\.csproj)", RegexOptions.Compiled)]
        private static partial Regex RestoredProjectRegex();

        [GeneratedRegex("[Assets\\sfile\\shas\\snot\\schanged.\\sSkipping\\sassets\\sfile\\swriting.|Writing\\sassets\\sfile\\sto\\sdisk.]\\sPath:\\s(.+)", RegexOptions.Compiled)]
        private static partial Regex AssetsFileRegex();
    }
}
