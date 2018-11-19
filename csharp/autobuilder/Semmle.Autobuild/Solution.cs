using Microsoft.Build.Construction;
using Microsoft.Build.Exceptions;
using System;
using System.Collections.Generic;
using System.Linq;
using Semmle.Util;

namespace Semmle.Autobuild
{
    /// <summary>
    /// A solution file, extension .sln.
    /// </summary>
    public interface ISolution
    {
        /// <summary>
        /// List of C# or C++ projects contained in the solution.
        /// (There could be other project types as well - these are ignored.)
        /// </summary>

        IEnumerable<Project> Projects { get; }

        /// <summary>
        /// Solution configurations.
        /// </summary>
        IEnumerable<SolutionConfigurationInSolution> Configurations { get; }

        /// <summary>
        /// The default configuration name, e.g. "Release"
        /// </summary>
        string DefaultConfigurationName { get; }

        /// <summary>
        /// The default platform name, e.g. "x86"
        /// </summary>
        string DefaultPlatformName { get; }

        /// <summary>
        /// The path of the solution file.
        /// </summary>
        string Path { get; }

        /// <summary>
        /// The number of C# or C++ projects.
        /// </summary>
        int ProjectCount { get; }

        /// <summary>
        /// Gets the "best" tools version for this solution.
        /// If there are several versions, because the project files
        /// are inconsistent, then pick the highest/latest version.
        /// If no tools versions are present, return 0.0.0.0.
        /// </summary>
        Version ToolsVersion { get; }
    }

    /// <summary>
    /// A solution file on the filesystem, read using Microsoft.Build.
    /// </summary>
    class Solution : ISolution
    {
        readonly SolutionFile solution;

        public IEnumerable<Project>  Projects { get; private set; }

        public IEnumerable<SolutionConfigurationInSolution> Configurations =>
            solution == null ? Enumerable.Empty<SolutionConfigurationInSolution>() : solution.SolutionConfigurations;

        public string DefaultConfigurationName =>
            solution == null ? "" : solution.GetDefaultConfigurationName();

        public string DefaultPlatformName =>
            solution == null ? "" : solution.GetDefaultPlatformName();

        public Solution(Autobuilder builder, string path)
        {
            Path = System.IO.Path.GetFullPath(path);
            try
            {
                solution = SolutionFile.Parse(Path);

                Projects =
                    solution.ProjectsInOrder.
                    Where(p => p.ProjectType == SolutionProjectType.KnownToBeMSBuildFormat).
                    Select(p => System.IO.Path.GetFullPath(FileUtils.ConvertToNative(p.AbsolutePath))).
                    Where(p => builder.Options.Language.ProjectFileHasThisLanguage(p)).
                    Select(p => new Project(builder, p)).
                    ToArray();
            }
            catch (InvalidProjectFileException)
            {
                // We allow specifying projects as solutions in lgtm.yml, so model
                // that scenario as a solution with just that one project
                Projects = Language.IsProjectFileForAnySupportedLanguage(Path)
                    ? new[] { new Project(builder, Path) }
                    : new Project[0];
            }
        }

        public string Path { get; private set; }

        public int ProjectCount => Projects.Count();

        IEnumerable<Version> ToolsVersions => Projects.Where(p => p.ValidToolsVersion).Select(p => p.ToolsVersion);

        public Version ToolsVersion => ToolsVersions.Any() ? ToolsVersions.Max() : new Version();
    }
}
