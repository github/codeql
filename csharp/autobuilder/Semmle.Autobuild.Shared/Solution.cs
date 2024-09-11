using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Microsoft.Build.Construction;
using Microsoft.Build.Exceptions;
using Semmle.Util.Logging;

namespace Semmle.Autobuild.Shared
{
    /// <summary>
    /// A solution file, extension .sln.
    /// </summary>
    public interface ISolution : IProjectOrSolution
    {
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
    internal class Solution<TAutobuildOptions> : ProjectOrSolution<TAutobuildOptions>, ISolution where TAutobuildOptions : AutobuildOptionsShared
    {
        private readonly SolutionFile? solution;

        private readonly IEnumerable<Project<TAutobuildOptions>> includedProjects;

        public override IEnumerable<IProjectOrSolution> IncludedProjects => includedProjects;

        public IEnumerable<SolutionConfigurationInSolution> Configurations =>
            solution is null ? Enumerable.Empty<SolutionConfigurationInSolution>() : solution.SolutionConfigurations;

        public string DefaultConfigurationName =>
            solution is null ? "" : solution.GetDefaultConfigurationName();

        public string DefaultPlatformName =>
            solution is null ? "" : solution.GetDefaultPlatformName();

        public Solution(Autobuilder<TAutobuildOptions> builder, string path, bool allowProject) : base(builder, path)
        {
            try
            {
                solution = SolutionFile.Parse(FullPath);
            }
            catch (Exception ex) when (ex is InvalidProjectFileException || ex is FileNotFoundException)
            {
                // We allow specifying projects as solutions in lgtm.yml, so model
                // that scenario as a solution with just that one project
                if (allowProject)
                {
                    includedProjects = new[] { new Project<TAutobuildOptions>(builder, path) };
                    return;
                }

                builder.Logger.LogInfo($"Unable to read solution file {path}.");
                includedProjects = Array.Empty<Project<TAutobuildOptions>>();
                return;
            }

            includedProjects = solution.ProjectsInOrder
                .Where(p => p.ProjectType == SolutionProjectType.KnownToBeMSBuildFormat)
                .Select(p => builder.Actions.PathCombine(DirectoryName, builder.Actions.PathCombine(p.RelativePath.Split('\\', StringSplitOptions.RemoveEmptyEntries))))
                .Select(p => new Project<TAutobuildOptions>(builder, p))
                .ToArray();
        }

        private IEnumerable<Version> ToolsVersions => includedProjects
            .Where(p => p.ValidToolsVersion)
            .Select(p => p.ToolsVersion);

        public Version ToolsVersion => ToolsVersions.Any()
            ? ToolsVersions.Max()!
            : new Version();
    }
}
