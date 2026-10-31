using System;
using System.Collections.Generic;
using System.IO;
using System.Xml;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{

    /// <summary>
    /// Lazily reads XML files to detect dependency and project settings without evaluating MSBuild.
    /// </summary>
    internal class FileContent
    {
        private readonly ILogger logger;
        private readonly IUnsafeFileReader unsafeFileReader;
        private readonly IEnumerable<string> files;
        private readonly HashSet<PackageReference> allPackages = new HashSet<PackageReference>();
        private readonly HashSet<string> implicitUsingNamespaces = new HashSet<string>();
        private readonly Initializer initialize;

        /// <summary>
        /// All detected package references in the project.
        /// </summary>
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
        /// If any XML file in the source directory contains something like (this will most like be a .csproj file)
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

        /// <summary>
        /// True if there is an indication that ASP.NET Core is used.
        /// </summary>
        public bool IsAspNetCoreDetected
        {
            get
            {
                return IsSdkProjectStructureUsed && UseAspNetCoreDlls;
            }
        }

        private bool useImplicitUsings = false;

        /// <summary>
        /// True if there is an indication that implicit usings are used.
        /// </summary>
        public bool UseImplicitUsings
        {
            get
            {
                initialize.Run();
                return useImplicitUsings;
            }
        }

        private bool useWpf = false;

        /// <summary>
        /// True if there is an indication that WPF is used.
        /// </summary>
        public bool UseWpf
        {
            get
            {
                initialize.Run();
                return useWpf;
            }
        }

        private bool useWindowsForms = false;

        /// <summary>
        /// True if there is an indication that Windows Forms is used.
        /// </summary>
        public bool UseWindowsForms
        {
            get
            {
                initialize.Run();
                return useWindowsForms;
            }
        }

        private bool isLegacyProjectStructureUsed = false;

        /// <summary>
        /// True if there is an indication that the legacy project structure is used (e.g., non-SDK-style .csproj files).
        /// </summary>
        public bool IsLegacyProjectStructureUsed
        {
            get
            {
                initialize.Run();
                return isLegacyProjectStructureUsed;
            }
        }

        private bool isSdkProjectStructureUsed = false;

        /// <summary>
        /// True if there is an indication that the new project structure is used (e.g., SDK-style .csproj files).
        /// </summary>
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

        private void AddPackageReference(string? packageName, PackageReferenceSource source)
        {
            if (!string.IsNullOrEmpty(packageName))
            {
                allPackages.Add(new PackageReference(packageName.ToLowerInvariant(), source));
            }
        }

        private void ProcessFile(string file, Action<XmlReader> processElement)
        {
            try
            {
                using var stream = unsafeFileReader.OpenRead(file);
                using var reader = XmlReader.Create(stream, new XmlReaderSettings
                {
                    DtdProcessing = DtdProcessing.Prohibit,
                    XmlResolver = null,
                    IgnoreComments = true,
                    IgnoreProcessingInstructions = true
                });

                while (reader.Read())
                {
                    if (reader.NodeType != XmlNodeType.Element)
                    {
                        continue;
                    }

                    processElement(reader);
                }
            }
            catch (XmlException)
            {
                logger.LogDebug($"Failed to parse {file} as an XML file.");
            }
        }

        /// <summary>
        /// Parses a packages.config XML file to extract package references.
        /// </summary>
        /// <param name="file"></param>
        private void ParsePackagesConfigFile(string file)
        {
            ProcessFile(file, r =>
            {
                if (r.LocalName == "package")
                {
                    AddPackageReference(r.GetAttribute("id"), PackageReferenceSource.PackagesConfig);
                }
            });
        }

        /// <summary>
        /// Checks if the content of the current XML element equals any of the specified values, ignoring case.
        /// A new reader is created to avoid modifying the state of the original reader.
        /// </summary>
        /// <param name="reader">The XML reader positioned at the element to read.</param>
        /// <returns>True if the element content equals any of the specified values, ignoring case; otherwise, false.</returns>
        private bool ElementContentEquals(XmlReader reader, params string[] values)
        {
            using (XmlReader subReader = reader.ReadSubtree())
            {
                if (subReader.Read())
                {
                    var content = subReader.ReadElementContentAsString().Trim();
                    foreach (var value in values)
                    {
                        if (string.Equals(content, value, StringComparison.OrdinalIgnoreCase))
                        {
                            return true;
                        }
                    }
                }
            }
            return false;
        }

        /// <summary>
        /// Attempt to parse the specified file as an XML file for project dependencies and settings.
        /// </summary>
        /// <param name="file"></param>
        private void Parse(string file)
        {
            ProcessFile(file, reader =>
            {
                switch (reader.LocalName.ToLowerInvariant())
                {
                    case "packagereference":
                        AddPackageReference(reader.GetAttribute("Include"), PackageReferenceSource.SdkCsProj);
                        break;
                    case "project":
                        var sdk = reader.GetAttribute("Sdk");
                        isSdkProjectStructureUsed |= sdk != null;
                        useAspNetCoreDlls |= string.Equals(sdk, "Microsoft.NET.Sdk.Web", StringComparison.OrdinalIgnoreCase);
                        break;
                    case "frameworkreference":
                        var framework = reader.GetAttribute("Include");
                        isSdkProjectStructureUsed |= framework != null;
                        useAspNetCoreDlls |= string.Equals(framework, "Microsoft.AspNetCore.App", StringComparison.OrdinalIgnoreCase);
                        break;
                    case "implicitusings":
                        useImplicitUsings = useImplicitUsings || ElementContentEquals(reader, "enable", "true");
                        break;
                    case "usewpf":
                        useWpf = useWpf || ElementContentEquals(reader, "true");
                        break;
                    case "usewindowsforms":
                        useWindowsForms = useWindowsForms || ElementContentEquals(reader, "true");
                        break;
                    case "using":
                        var ns = reader.GetAttribute("Include");
                        if (!string.IsNullOrEmpty(ns))
                        {
                            implicitUsingNamespaces.Add(ns);
                        }
                        break;
                    case "import":
                        isLegacyProjectStructureUsed = isLegacyProjectStructureUsed || reader.GetAttribute("Project")?.EndsWith("Microsoft.CSharp.targets", StringComparison.OrdinalIgnoreCase) == true;
                        break;
                }
            });
        }

        private void DoInitialize()
        {
            foreach (var file in files)
            {
                try
                {
                    var isPackagesConfig = string.Equals(FileUtils.SafeGetFileName(file, logger), "packages.config", StringComparison.OrdinalIgnoreCase);
                    if (isPackagesConfig)
                    {
                        ParsePackagesConfigFile(file);
                    }
                    else
                    {
                        Parse(file);
                    }
                }
                catch (Exception ex)
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
