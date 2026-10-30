using System;
using System.Collections.Generic;
using System.IO;
using System.Xml;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{

    /// <summary>
    /// Lazily reads XML files once to detect dependency and project settings without evaluating MSBuild.
    /// </summary>
    internal class FileContent
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
                return IsSdkProjectStructureUsed && UseAspNetCoreDlls;
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

        private bool isSdkProjectStructureUsed = false;
        public bool IsSdkProjectStructureUsed
        {
            get
            {
                initialize.Run();
                return isSdkProjectStructureUsed;
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

        private static string? GetAttribute(XmlReader reader, string name)
        {
            while (reader.MoveToNextAttribute())
            {
                if (string.Equals(reader.LocalName, name, StringComparison.OrdinalIgnoreCase))
                {
                    var value = reader.Value;
                    reader.MoveToElement();
                    return value;
                }
            }
            reader.MoveToElement();
            return null;
        }

        private void AddPackageReference(string? packageName, PackageReferenceSource source)
        {
            if (!string.IsNullOrEmpty(packageName))
            {
                allPackages.Add(new PackageReference(packageName.ToLowerInvariant(), source));
            }
        }

        private void DoInitialize()
        {
            foreach (var file in files)
            {
                try
                {
                    var isPackagesConfig = string.Equals(FileUtils.SafeGetFileName(file, logger), "packages.config", StringComparison.OrdinalIgnoreCase);
                    using var stream = unsafeFileReader.OpenRead(file);
                    using var reader = XmlReader.Create(stream, new XmlReaderSettings
                    {
                        DtdProcessing = DtdProcessing.Prohibit,
                        XmlResolver = null,
                        IgnoreComments = true,
                        IgnoreProcessingInstructions = true
                    });

                    while (!reader.EOF)
                    {
                        if (reader.NodeType != XmlNodeType.Element)
                        {
                            reader.Read();
                            continue;
                        }

                        switch (reader.LocalName.ToLowerInvariant())
                        {
                            case "package" when isPackagesConfig:
                                AddPackageReference(GetAttribute(reader, "id"), PackageReferenceSource.PackagesConfig);
                                break;
                            case "packagereference" when !isPackagesConfig:
                                AddPackageReference(GetAttribute(reader, "Include"), PackageReferenceSource.SdkCsProj);
                                break;
                            case "project":
                                var sdk = GetAttribute(reader, "Sdk");
                                isSdkProjectStructureUsed |= sdk != null;
                                useAspNetCoreDlls |= string.Equals(sdk, "Microsoft.NET.Sdk.Web", StringComparison.OrdinalIgnoreCase);
                                break;
                            case "frameworkreference":
                                var framework = GetAttribute(reader, "Include");
                                isSdkProjectStructureUsed |= framework != null;
                                useAspNetCoreDlls |= string.Equals(framework, "Microsoft.AspNetCore.App", StringComparison.OrdinalIgnoreCase);
                                break;
                            case "implicitusings":
                                var implicitUsings = reader.ReadElementContentAsString().Trim();
                                useImplicitUsings |= string.Equals(implicitUsings, "enable", StringComparison.OrdinalIgnoreCase)
                                    || string.Equals(implicitUsings, "true", StringComparison.OrdinalIgnoreCase);
                                continue;
                            case "usewpf":
                                useWpf |= string.Equals(reader.ReadElementContentAsString().Trim(), "true", StringComparison.OrdinalIgnoreCase);
                                continue;
                            case "usewindowsforms":
                                useWindowsForms |= string.Equals(reader.ReadElementContentAsString().Trim(), "true", StringComparison.OrdinalIgnoreCase);
                                continue;
                            case "using":
                                var ns = GetAttribute(reader, "Include");
                                if (!string.IsNullOrEmpty(ns))
                                {
                                    implicitUsingNamespaces.Add(ns);
                                }
                                break;
                            case "import":
                                isLegacyProjectStructureUsed |= GetAttribute(reader, "Project")?.EndsWith("Microsoft.CSharp.targets", StringComparison.OrdinalIgnoreCase) == true;
                                break;
                        }

                        reader.Read();
                    }
                }
                catch (Exception ex) when (ex is IOException or UnauthorizedAccessException or XmlException)
                {
                    logger.LogInfo($"Failed to read file {file}");
                    logger.LogDebug($"Failed to read file {file}, exception: {ex}");
                }
            }

            logger.LogInfo("Finished reading project files.");
            logger.LogInfo($"Legacy project structure usage detected: {isLegacyProjectStructureUsed}");
            logger.LogInfo($"SDK project structure usage detected: {isSdkProjectStructureUsed}");
            logger.LogInfo($"ASP.NET usage detected: {useAspNetCoreDlls}");
            logger.LogInfo($"Windows Forms usage detected: {useWindowsForms}");
            logger.LogInfo($"WPF usage detected: {useWpf}");
            logger.LogInfo($"Implicit usings enabled: {useImplicitUsings}");
        }

    }

    internal interface IUnsafeFileReader
    {
        Stream OpenRead(string file);
    }

    internal class UnsafeFileReader : IUnsafeFileReader
    {
        public Stream OpenRead(string file) => File.OpenRead(file);
    }

    public enum PackageReferenceSource
    {
        SdkCsProj,
        PackagesConfig
    }

    public record PackageReference(string Name, PackageReferenceSource PackageReferenceSource);
}
