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
        private readonly HashSet<string> implicitUsingNamespaces = new HashSet<string>();
        private readonly Initializer initialize;

        public HashSet<string> AllPackages
        {
            get
            {
                initialize.Run();
                return allPackages;
            }
        }

        private bool useAspNetCoreDlls = false;

        /// <summary>
        /// True if any file in the source directory indicates that ASP.NET Core is used.
        /// The following heuristic is used to decide, if ASP.NET Core is used:
        /// If any file in the source directory contains something like (this will most like be a .csproj file)
        ///     <Project Sdk="Microsoft.NET.Sdk.Web">
        ///     <FrameworkReference Include="Microsoft.AspNetCore.App"/>
        /// </summary>
        public bool UseAspNetCoreDlls
        {
            get
            {
                initialize.Run();
                return useAspNetCoreDlls;
            }
        }

        private bool useImplicitUsings = false;

        public bool UseImplicitUsings
        {
            get
            {
                initialize.Run();
                return useImplicitUsings;
            }
        }

        private bool isLegacyProjectStructureUsed = false;

        public bool IsLegacyProjectStructureUsed
        {
            get
            {
                initialize.Run();
                return isLegacyProjectStructureUsed;
            }
        }

        private bool isNewProjectStructureUsed = false;
        public bool IsNewProjectStructureUsed
        {
            get
            {
                initialize.Run();
                return isNewProjectStructureUsed;
            }
        }

        public HashSet<string> CustomImplicitUsings
        {
            get
            {
                initialize.Run();
                return implicitUsingNamespaces;
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

        private static string GetGroup(ReadOnlySpan<char> input, ValueMatch valueMatch, string groupPrefix, bool toLower)
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

            var result = match.Slice(quoteIndex1 + 1, quoteIndex2).ToString();

            if (toLower)
            {
                result = result.ToLowerInvariant();
            }

            return result;
        }

        private static bool IsGroupMatch(ReadOnlySpan<char> line, Regex regex, string groupPrefix, string value)
        {
            foreach (var valueMatch in regex.EnumerateMatches(line))
            {
                // We can't get the group from the ValueMatch, so doing it manually:
                if (GetGroup(line, valueMatch, groupPrefix, toLower: true) == value.ToLowerInvariant())
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
                            var packageName = GetGroup(line, valueMatch, "Include", toLower: true);
                            if (!string.IsNullOrEmpty(packageName))
                            {
                                allPackages.Add(packageName);
                            }
                        }

                        // Determine if ASP.NET is used.
                        useAspNetCoreDlls = useAspNetCoreDlls
                            || IsGroupMatch(line, ProjectSdk(), "Sdk", "Microsoft.NET.Sdk.Web")
                            || IsGroupMatch(line, FrameworkReference(), "Include", "Microsoft.AspNetCore.App");


                        // Determine if implicit usings are used.
                        useImplicitUsings = useImplicitUsings
                            || line.Contains("<ImplicitUsings>enable</ImplicitUsings>".AsSpan(), StringComparison.Ordinal)
                            || line.Contains("<ImplicitUsings>true</ImplicitUsings>".AsSpan(), StringComparison.Ordinal);

                        // Find all custom implicit usings.
                        foreach (var valueMatch in CustomImplicitUsingDeclarations().EnumerateMatches(line))
                        {
                            var ns = GetGroup(line, valueMatch, "Include", toLower: false);
                            if (!string.IsNullOrEmpty(ns))
                            {
                                implicitUsingNamespaces.Add(ns);
                            }
                        }

                        // Determine project structure:
                        isLegacyProjectStructureUsed = isLegacyProjectStructureUsed || MicrosoftCSharpTargets().IsMatch(line);
                        isNewProjectStructureUsed = isNewProjectStructureUsed
                            || ProjectSdk().IsMatch(line)
                            || FrameworkReference().IsMatch(line);
                        // TODO: we could also check `<Sdk Name="Microsoft.NET.Sdk" />`
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

        [GeneratedRegex("<Using.*\\sInclude=\"(.*?)\".*/?>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex CustomImplicitUsingDeclarations();

        [GeneratedRegex("<Import.*\\sProject=\".*Microsoft\\.CSharp\\.targets\".*/?>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex MicrosoftCSharpTargets();
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
