using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml;

namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// Represents a .csproj file and reads information from it.
    /// </summary>
    public class CsProjFile
    {
        private string Filename { get; }

        private string Directory { get; }

        /// <summary>
        /// Reads the .csproj file.
        /// </summary>
        /// <param name="filename">The .csproj file.</param>
        public CsProjFile(FileInfo filename)
        {
            Filename = filename.FullName;

            var directoryName = Path.GetDirectoryName(Filename);

            if (directoryName is null)
            {
                throw new InternalError($"Directory of file '{Filename}' is null");
            }

            Directory = directoryName;

            try
            {
                // This can fail if the .csproj is invalid or has
                // unrecognised content or is the wrong version.
                // This currently always fails on Linux because
                // Microsoft.Build is not cross platform.
                (csFiles, references, projectReferences) = ReadMsBuildProject(filename);
            }
            catch  // lgtm[cs/catch-of-all-exceptions]
            {
                // There was some reason why the project couldn't be loaded.
                // Fall back to reading the Xml document directly.
                // This method however doesn't handle variable expansion.
                (csFiles, references, projectReferences) = ReadProjectFileAsXml(filename, Directory);
            }
        }

        /// <summary>
        /// Read the .csproj file using Microsoft Build.
        /// This occasionally fails if the project file is incompatible for some reason,
        /// and there seems to be no way to make it succeed. Fails on Linux.
        /// </summary>
        /// <param name="filename">The file to read.</param>
        private static (string[] csFiles, string[] references, string[] projectReferences) ReadMsBuildProject(FileInfo filename)
        {
            var msbuildProject = new Microsoft.Build.Execution.ProjectInstance(filename.FullName);

            var references = msbuildProject.Items
                .Where(item => item.ItemType == "Reference")
                .Select(item => item.EvaluatedInclude)
                .ToArray();

            var projectReferences = msbuildProject.Items
                .Where(item => item.ItemType == "ProjectReference")
                .Select(item => item.EvaluatedInclude)
                .ToArray();

            var csFiles = msbuildProject.Items
                .Where(item => item.ItemType == "Compile")
                .Select(item => item.GetMetadataValue("FullPath"))
                .Where(fn => fn.EndsWith(".cs"))
                .ToArray();

            return (csFiles, references, projectReferences);
        }

        /// <summary>
        /// Reads the .csproj file directly as XML.
        /// This doesn't handle variables etc, and should only used as a
        /// fallback if ReadMsBuildProject() fails.
        /// </summary>
        /// <param name="fileName">The .csproj file.</param>
        private static (string[] csFiles, string[] references, string[] projectReferences) ReadProjectFileAsXml(FileInfo fileName, string directoryName)
        {
            var projFile = new XmlDocument();
            var mgr = new XmlNamespaceManager(projFile.NameTable);
            mgr.AddNamespace("msbuild", "http://schemas.microsoft.com/developer/msbuild/2003");
            projFile.Load(fileName.FullName);
            var projDir = fileName.Directory;
            var root = projFile.DocumentElement;

            if (root is null)
            {
                throw new NotSupportedException("Project file without root is not supported.");
            }

            // Figure out if it's dotnet core

            var netCoreProjectFile = root.GetAttribute("Sdk").StartsWith("Microsoft.NET.Sdk");

            if (netCoreProjectFile)
            {
                var explicitCsFiles = root
                    .SelectNodes("/Project/ItemGroup/Compile/@Include", mgr)
                    ?.NodeList()
                    .Select(node => node.Value)
                    .Select(cs => GetFullPath(cs, projDir))
                    .Where(s => s is not null)
                    ?? Enumerable.Empty<string>();

                var additionalCsFiles = System.IO.Directory.GetFiles(directoryName, "*.cs", new EnumerationOptions { RecurseSubdirectories = true, MatchCasing = MatchCasing.CaseInsensitive });

                var projectReferences = root
                    .SelectNodes("/Project/ItemGroup/ProjectReference/@Include", mgr)
                    ?.NodeList()
                    .Select(node => node.Value)
                    .Select(csproj => GetFullPath(csproj, projDir))
                    .Where(s => s is not null)
                    ?? Enumerable.Empty<string>();

#nullable disable warnings
                return (explicitCsFiles.Concat(additionalCsFiles).ToArray(), Array.Empty<string>(), projectReferences.ToArray());
#nullable restore warnings
            }

            var references = root
                .SelectNodes("/msbuild:Project/msbuild:ItemGroup/msbuild:Reference/@Include", mgr)
                ?.NodeList()
                .Select(node => node.Value)
                .Where(s => s is not null)
                .ToArray()
                ?? Array.Empty<string>();

            var relativeCsIncludes = root
                .SelectNodes("/msbuild:Project/msbuild:ItemGroup/msbuild:Compile/@Include", mgr)
                ?.NodeList()
                .Select(node => node.Value)
                .ToArray()
                ?? Array.Empty<string>();

            var csFiles = relativeCsIncludes
                .Select(cs => GetFullPath(cs, projDir))
                .Where(s => s is not null)
                .ToArray();

#nullable disable warnings
            return (csFiles, references, Array.Empty<string>());
#nullable restore warnings
        }

        private static string? GetFullPath(string? file, DirectoryInfo? projDir)
        {
            if (file is null)
            {
                return null;
            }

            return Path.GetFullPath(Path.Combine(projDir?.FullName ?? string.Empty, Path.DirectorySeparatorChar == '/' ? file.Replace("\\", "/") : file));
        }

        private readonly string[] references;
        private readonly string[] projectReferences;
        private readonly string[] csFiles;

        /// <summary>
        /// The list of references as a list of assembly IDs.
        /// </summary>
        public IEnumerable<string> References => references;

        /// <summary>
        /// The list of project references in full path format.
        /// </summary>
        public IEnumerable<string> ProjectReferences => projectReferences;

        /// <summary>
        /// The list of C# source files in full path format.
        /// </summary>
        public IEnumerable<string> Sources => csFiles;
    }

    internal static class XmlNodeHelper
    {
        /// <summary>
        /// Helper to convert an XmlNodeList into an IEnumerable.
        /// This allows it to be used with Linq.
        /// </summary>
        /// <param name="list">The list to convert.</param>
        /// <returns>A more useful data type.</returns>
        public static IEnumerable<XmlNode> NodeList(this XmlNodeList list)
        {
            return list.OfType<XmlNode>();
        }
    }
}
