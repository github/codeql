using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.DependencyFetching
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
        private readonly IUnsafeFileReader unsafeFileReader;
        private readonly IEnumerable<string> files;
        private readonly HashSet<string> allPackages = new HashSet<string>();
        private readonly Initializer initialize;

        public HashSet<string> AllPackages
        {
            get
            {
                initialize.Run();
                return allPackages;
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
                initialize.Run();
                return useAspNetDlls;
            }
        }

        internal FileContent(ProgressMonitor progressMonitor,
            IEnumerable<string> files,
            IUnsafeFileReader unsafeFileReader)
        {
            this.progressMonitor = progressMonitor;
            this.files = files;
            this.unsafeFileReader = unsafeFileReader;
            this.initialize = new Initializer(DoInitialize);
        }


        public FileContent(ProgressMonitor progressMonitor, IEnumerable<string> files) : this(progressMonitor, files, new UnsafeFileReader())
        { }

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

        private void DoInitialize()
        {
            foreach (var file in files)
            {
                try
                {
                    foreach (ReadOnlySpan<char> line in unsafeFileReader.ReadLines(file))
                    {

                        // Find all the packages.
                        foreach (var valueMatch in PackageReference().EnumerateMatches(line))
                        {
                            // We can't get the group from the ValueMatch, so doing it manually:
                            var packageName = GetGroup(line, valueMatch, "Include");
                            if (!string.IsNullOrEmpty(packageName))
                            {
                                allPackages.Add(packageName);
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
        }

        [GeneratedRegex("<PackageReference.*\\sInclude=\"(.*?)\".*/?>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex PackageReference();

        [GeneratedRegex("<FrameworkReference.*\\sInclude=\"(.*?)\".*/?>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex FrameworkReference();

        [GeneratedRegex("<(.*\\s)?Project.*\\sSdk=\"(.*?)\".*/?>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex ProjectSdk();
    }

    internal interface IUnsafeFileReader
    {
        IEnumerable<string> ReadLines(string file);
    }

    internal class UnsafeFileReader : IUnsafeFileReader
    {
        public IEnumerable<string> ReadLines(string file)
        {
            using var sr = new StreamReader(file);
            string? line;
            while ((line = sr.ReadLine()) != null)
            {
                yield return line;
            }
        }
    }
}
