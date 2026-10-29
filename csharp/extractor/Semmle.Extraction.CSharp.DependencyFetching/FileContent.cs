using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using Semmle.Util;
using Semmle.Util.Logging;

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
        private readonly ILogger logger;
        private readonly IUnsafeFileReader unsafeFileReader;
        private readonly IEnumerable<string> files;
        private readonly HashSet<PackageReference> allPackages = new HashSet<PackageReference>();
        private readonly HashSet<string> implicitUsingNamespaces = new HashSet<string>();
        private readonly Initializer initialize;

        public HashSet<PackageReference> AllPackages
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
        ///     &lt;Project Sdk="Microsoft.NET.Sdk.Web"&gt;
        ///     &lt;FrameworkReference Include="Microsoft.AspNetCore.App"/&gt;
        /// </summary>
        public bool UseAspNetCoreDlls
        {
            get
            {
                initialize.Run();
                return useAspNetCoreDlls;
            }
        }

        public bool IsAspNetCoreDetected
        {
            get
            {
                return IsNewProjectStructureUsed && UseAspNetCoreDlls;
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

        private bool useWpf = false;

        public bool UseWpf
        {
            get
            {
                initialize.Run();
                return useWpf;
            }
        }

        private bool useWindowsForms = false;

        public bool UseWindowsForms
        {
            get
            {
                initialize.Run();
                return useWindowsForms;
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

        internal FileContent(ILogger logger,
            IEnumerable<string> files,
            IUnsafeFileReader unsafeFileReader)
        {
            this.logger = logger;
            this.files = files;
            this.unsafeFileReader = unsafeFileReader;
            this.initialize = new Initializer(DoInitialize);
        }


        public FileContent(ILogger logger, IEnumerable<string> files) : this(logger, files, new UnsafeFileReader())
        { }

        private static string GetGroup(ReadOnlySpan<char> input, ValueMatch valueMatch, string groupPrefix)
        {
            var match = input.Slice(valueMatch.Index, valueMatch.Length);
            var includeIndex = match.IndexOf(groupPrefix, StringComparison.OrdinalIgnoreCase);
            if (includeIndex == -1)
            {
                return string.Empty;
            }

            match = match.Slice(includeIndex + groupPrefix.Length + 1);

            var quoteIndex1 = match.IndexOf("\"");
            var quoteIndex2 = match.Slice(quoteIndex1 + 1).IndexOf("\"");

            return match.Slice(quoteIndex1 + 1, quoteIndex2).ToString();
        }

        private static bool IsGroupMatch(ReadOnlySpan<char> line, Regex regex, string groupPrefix, string value)
        {
            foreach (var valueMatch in regex.EnumerateMatches(line))
            {
                // We can't get the group from the ValueMatch, so doing it manually:
                if (string.Equals(GetGroup(line, valueMatch, groupPrefix), value, StringComparison.OrdinalIgnoreCase))
                {
                    return true;
                }
            }
            return false;
        }

        private void AddPackageReference(ReadOnlySpan<char> line, string groupName, Func<Regex> regex, PackageReferenceSource source)
        {
            foreach (var valueMatch in regex().EnumerateMatches(line))
            {
                // We can't get the group from the ValueMatch, so doing it manually:
                var packageName = GetGroup(line, valueMatch, groupName).ToLowerInvariant();
                if (!string.IsNullOrEmpty(packageName))
                {
                    allPackages.Add(new PackageReference(packageName, source));
                }
            }
        }

        private void DoInitialize()
        {
            foreach (var file in files)
            {
                try
                {
                    var isPackagesConfig = string.Equals(FileUtils.SafeGetFileName(file, logger), "packages.config", StringComparison.OrdinalIgnoreCase);

                    foreach (ReadOnlySpan<char> line in unsafeFileReader.ReadLines(file))
                    {
                        // Find all the packages.
                        if (isPackagesConfig)
                        {
                            AddPackageReference(line, "id", LegacyPackageReference, PackageReferenceSource.PackagesConfig);
                        }
                        else
                        {
                            AddPackageReference(line, "Include", PackageReference, PackageReferenceSource.SdkCsProj);
                        }

                        // Determine if ASP.NET is used.
                        useAspNetCoreDlls = useAspNetCoreDlls
                            || IsGroupMatch(line, ProjectSdk(), "Sdk", "Microsoft.NET.Sdk.Web")
                            || IsGroupMatch(line, FrameworkReference(), "Include", "Microsoft.AspNetCore.App");

                        // Determine if implicit usings are used.
                        useImplicitUsings = useImplicitUsings
                            || line.Contains("<ImplicitUsings>enable</ImplicitUsings>".AsSpan(), StringComparison.OrdinalIgnoreCase)
                            || line.Contains("<ImplicitUsings>true</ImplicitUsings>".AsSpan(), StringComparison.OrdinalIgnoreCase);

                        // Determine if WPF is used.
                        useWpf = useWpf
                            || line.Contains("<UseWPF>true</UseWPF>".AsSpan(), StringComparison.OrdinalIgnoreCase);

                        // Determine if Windows Forms is used.
                        useWindowsForms = useWindowsForms
                            || line.Contains("<UseWindowsForms>true</UseWindowsForms>".AsSpan(), StringComparison.OrdinalIgnoreCase);

                        // Find all custom implicit usings.
                        foreach (var valueMatch in CustomImplicitUsingDeclarations().EnumerateMatches(line))
                        {
                            var ns = GetGroup(line, valueMatch, "Include");
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
                    logger.LogInfo($"Failed to read file {file}");
                    logger.LogDebug($"Failed to read file {file}, exception: {ex}");
                }
            }
        }

        [GeneratedRegex("(?<!<!--.*)<PackageReference.*\\sInclude=\"(.*?)\".*/?>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex PackageReference();

        [GeneratedRegex("(?<!<!--.*)<package.*\\sid=\"(.*?)\".*/?>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex LegacyPackageReference();

        [GeneratedRegex("(?<!<!--.*)<FrameworkReference.*\\sInclude=\"(.*?)\".*/?>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex FrameworkReference();

        [GeneratedRegex("(?<!<!--.*)<(.*\\s)?Project.*\\sSdk=\"(.*?)\".*/?>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex ProjectSdk();

        [GeneratedRegex("(?<!<!--.*)<Using.*\\sInclude=\"(.*?)\".*/?>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex CustomImplicitUsingDeclarations();

        [GeneratedRegex("(?<!<!--.*)<Import.*\\sProject=\".*Microsoft\\.CSharp\\.targets\".*/?>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
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

    public enum PackageReferenceSource
    {
        SdkCsProj,
        PackagesConfig
    }

    public record PackageReference(string Name, PackageReferenceSource PackageReferenceSource);
}
