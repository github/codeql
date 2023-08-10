using Semmle.Util;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace Semmle.BuildAnalyser
{

    // <summary>
    // This class is used to read a set of files and decide different properties about the
    // content (by reading the content of the files only once).
    // The implementation is lazy, so the properties are only calculated when
    // the first property is accessed. 
    // </summary>
    internal partial class FileContent
    {
        private readonly ProgressMonitor progressMonitor;
        private readonly TemporaryDirectory packageDirectory;
        private readonly Func<IEnumerable<string>> getFiles;
        private readonly HashSet<string> notYetDownloadedPackages = new HashSet<string>();

        private bool IsInitialized { get; set; } = false;

        public HashSet<string> NotYetDownloadedPackages
        {
            get
            {
                Initialize();
                return notYetDownloadedPackages;
            }
        }

        private bool useAspNetDlls = false;

        /// <summary>
        /// True if any file in the source directory indicates that ASP.NET is used.
        /// The following heuristic is used to decide, if ASP.NET is used:
        /// If any file in the source directory contains something like (this will most like be a .csproj file)
        ///     <Project Sdk="Microsoft.NET.Sdk.Web">
        ///     <FrameworkReference Include="Microsoft.AspNetCore.App"/>
        /// </summary>
        public bool UseAspNetDlls
        {
            get
            {
                Initialize();
                return useAspNetDlls;
            }
        }

        public FileContent(TemporaryDirectory packageDirectory, ProgressMonitor progressMonitor, Func<IEnumerable<string>> getFiles)
        {
            this.progressMonitor = progressMonitor;
            this.packageDirectory = packageDirectory;
            this.getFiles = getFiles;
        }

        private static string GetGroup(ReadOnlySpan<char> input, ValueMatch valueMatch, string groupPrefix)
        {
            var match = input.Slice(valueMatch.Index, valueMatch.Length);
            var includeIndex = match.IndexOf(groupPrefix, StringComparison.InvariantCultureIgnoreCase);
            if (includeIndex == -1)
            {
                return string.Empty;
            }

            match = match.Slice(includeIndex + groupPrefix.Length + 1);

            var quoteIndex1 = match.IndexOf("\"");
            var quoteIndex2 = match.Slice(quoteIndex1 + 1).IndexOf("\"");

            return match.Slice(quoteIndex1 + 1, quoteIndex2).ToString().ToLowerInvariant();
        }

        private static bool IsGroupMatch(ReadOnlySpan<char> line, Regex regex, string groupPrefix, string value)
        {
            foreach (var valueMatch in regex.EnumerateMatches(line))
            {
                // We can't get the group from the ValueMatch, so doing it manually:
                if (GetGroup(line, valueMatch, groupPrefix) == value.ToLowerInvariant())
                {
                    return true;
                }
            }
            return false;
        }

        private void Initialize()
        {
            if (IsInitialized)
            {
                return;
            }

            var alreadyDownloadedPackages = Directory.GetDirectories(packageDirectory.DirInfo.FullName).Select(d => Path.GetFileName(d).ToLowerInvariant()).ToHashSet();
            foreach (var file in getFiles())
            {
                try
                {
                    using var sr = new StreamReader(file);
                    ReadOnlySpan<char> line;
                    while ((line = sr.ReadLine()) != null)
                    {

                        // Find the not yet downloaded packages.
                        foreach (var valueMatch in PackageReference().EnumerateMatches(line))
                        {
                            // We can't get the group from the ValueMatch, so doing it manually:
                            var packageName = GetGroup(line, valueMatch, "Include");
                            if (!string.IsNullOrEmpty(packageName) && !alreadyDownloadedPackages.Contains(packageName))
                            {
                                notYetDownloadedPackages.Add(packageName);
                            }
                        }

                        // Determine if ASP.NET is used.
                        if (!useAspNetDlls)
                        {
                            useAspNetDlls =
                                IsGroupMatch(line, ProjectSdk(), "Sdk", "Microsoft.NET.Sdk.Web") ||
                                IsGroupMatch(line, FrameworkReference(), "Include", "Microsoft.AspNetCore.App");
                        }

                    }
                }
                catch (Exception ex)
                {
                    progressMonitor.FailedToReadFile(file, ex);
                }
            }
            IsInitialized = true;
        }

        [GeneratedRegex("<PackageReference.*\\sInclude=\"(.*?)\".*/?>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex PackageReference();

        [GeneratedRegex("<FrameworkReference.*\\sInclude=\"(.*?)\".*/?>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex FrameworkReference();

        [GeneratedRegex("<(.*\\s)?Project.*\\sSdk=\"(.*?)\".*/?>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex ProjectSdk();
    }
}