using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using Semmle.Util;
using Semmle.Extraction.CSharp.Standalone;

namespace Semmle.BuildAnalyser
{
    /// <summary>
    /// The output of a build analysis.
    /// </summary>
    interface IBuildAnalysis
    {
        /// <summary>
        /// Full filepaths of external references.
        /// </summary>
        IEnumerable<string> ReferenceFiles { get; }

        /// <summary>
        /// Full filepaths of C# source files from project files.
        /// </summary>
        IEnumerable<string> ProjectSourceFiles { get; }

        /// <summary>
        /// Full filepaths of C# source files in the filesystem.
        /// </summary>
        IEnumerable<string> AllSourceFiles { get; }

        /// <summary>
        /// The assembly IDs which could not be resolved.
        /// </summary>
        IEnumerable<string> UnresolvedReferences { get; }

        /// <summary>
        /// List of source files referenced by projects but
        /// which were not found in the filesystem.
        /// </summary>
        IEnumerable<string> MissingSourceFiles { get; }
    }

    /// <summary>
    /// Main implementation of the build analysis.
    /// </summary>
    class BuildAnalysis : IBuildAnalysis
    {
        readonly AssemblyCache assemblyCache;
        readonly NugetPackages nuget;
        readonly IProgressMonitor progressMonitor;
        HashSet<string> usedReferences = new HashSet<string>();
        readonly HashSet<string> usedSources = new HashSet<string>();
        readonly HashSet<string> missingSources = new HashSet<string>();
        readonly Dictionary<string, string> unresolvedReferences = new Dictionary<string, string>();
        readonly DirectoryInfo sourceDir;
        int failedProjects, succeededProjects;
        readonly string[] allSources;
        int conflictedReferences = 0;

        /// <summary>
        /// Performs a C# build analysis.
        /// </summary>
        /// <param name="options">Analysis options from the command line.</param>
        /// <param name="progress">Display of analysis progress.</param>
        public BuildAnalysis(Options options, IProgressMonitor progress)
        {
            progressMonitor = progress;
            sourceDir = new DirectoryInfo(options.SrcDir);

            progressMonitor.FindingFiles(options.SrcDir);

            allSources = sourceDir.GetFiles("*.cs", SearchOption.AllDirectories).
                Select(d => d.FullName).
                Where(d => !options.ExcludesFile(d)).
                ToArray();

            var dllDirNames = options.DllDirs.Select(Path.GetFullPath);

            if (options.UseNuGet)
            {
                nuget = new NugetPackages(sourceDir.FullName);
                ReadNugetFiles();
                dllDirNames = dllDirNames.Concat(Enumerators.Singleton(nuget.PackageDirectory));
            }

            // Find DLLs in the .Net Framework
            if (options.ScanNetFrameworkDlls)
            {
                dllDirNames = dllDirNames.Concat(Runtime.Runtimes.Take(1));
            }

            assemblyCache = new BuildAnalyser.AssemblyCache(dllDirNames, progress);

            // Analyse all .csproj files in the source tree.
            if (options.SolutionFile != null)
            {
                AnalyseSolution(options.SolutionFile);
            }
            else if (options.AnalyseCsProjFiles)
            {
                AnalyseProjectFiles();
            }

            if (!options.AnalyseCsProjFiles)
            {
                usedReferences = new HashSet<string>(assemblyCache.AllAssemblies.Select(a => a.Filename));
            }

            ResolveConflicts();

            if (options.UseMscorlib)
            {
                UseReference(typeof(object).Assembly.Location);
            }

            // Output the findings
            foreach (var r in usedReferences)
            {
                progressMonitor.ResolvedReference(r);
            }

            foreach (var r in unresolvedReferences)
            {
                progressMonitor.UnresolvedReference(r.Key, r.Value);
            }

            progressMonitor.Summary(
                AllSourceFiles.Count(),
                ProjectSourceFiles.Count(),
                MissingSourceFiles.Count(),
                ReferenceFiles.Count(),
                UnresolvedReferences.Count(),
                conflictedReferences,
                succeededProjects + failedProjects,
                failedProjects);
        }

        /// <summary>
        /// Resolves conflicts between all of the resolved references.
        /// If the same assembly name is duplicated with different versions,
        /// resolve to the higher version number.
        /// </summary>
        void ResolveConflicts()
        {
            var sortedReferences = usedReferences.
                Select(r => assemblyCache.GetAssemblyInfo(r)).
                OrderBy(r => r.Version).
                ToArray();

            Dictionary<string, AssemblyInfo> finalAssemblyList = new Dictionary<string, AssemblyInfo>();

            // Pick the highest version for each assembly name
            foreach (var r in sortedReferences)
                finalAssemblyList[r.Name] = r;

            // Update the used references list
            usedReferences = new HashSet<string>(finalAssemblyList.Select(r => r.Value.Filename));

            // Report the results
            foreach (var r in sortedReferences)
            {
                var resolvedInfo = finalAssemblyList[r.Name];
                if (resolvedInfo.Version != r.Version)
                {
                    progressMonitor.ResolvedConflict(r.Id, resolvedInfo.Id);
                    ++conflictedReferences;
                }
            }
        }

        /// <summary>
        /// Find and restore NuGet packages.
        /// </summary>
        void ReadNugetFiles()
        {
            nuget.FindPackages();
            nuget.InstallPackages(progressMonitor);
        }

        /// <summary>
        /// Store that a particular reference file is used.
        /// </summary>
        /// <param name="reference">The filename of the reference.</param>
        void UseReference(string reference)
        {
            usedReferences.Add(reference);
        }

        /// <summary>
        /// Store that a particular source file is used (by a project file).
        /// </summary>
        /// <param name="sourceFile">The source file.</param>
        void UseSource(FileInfo sourceFile)
        {
            if (sourceFile.Exists)
            {
                usedSources.Add(sourceFile.FullName);
            }
            else
            {
                missingSources.Add(sourceFile.FullName);
            }
        }

        /// <summary>
        /// The list of resolved reference files.
        /// </summary>
        public IEnumerable<string> ReferenceFiles => this.usedReferences;

        /// <summary>
        /// The list of source files used in projects.
        /// </summary>
        public IEnumerable<string> ProjectSourceFiles => usedSources;

        /// <summary>
        /// All of the source files in the source directory.
        /// </summary>
        public IEnumerable<string> AllSourceFiles => allSources;

        /// <summary>
        /// List of assembly IDs which couldn't be resolved.
        /// </summary>
        public IEnumerable<string> UnresolvedReferences => this.unresolvedReferences.Select(r => r.Key);

        /// <summary>
        /// List of source files which were mentioned in project files but
        /// do not exist on the file system.
        /// </summary>
        public IEnumerable<string> MissingSourceFiles => missingSources;

        /// <summary>
        /// Record that a particular reference couldn't be resolved.
        /// Note that this records at most one project file per missing reference.
        /// </summary>
        /// <param name="id">The assembly ID.</param>
        /// <param name="projectFile">The project file making the reference.</param>
        void UnresolvedReference(string id, string projectFile)
        {
            unresolvedReferences[id] = projectFile;
        }

        /// <summary>
        /// Performs an analysis of all .csproj files.
        /// </summary>
        void AnalyseProjectFiles()
        {
            AnalyseProjectFiles(sourceDir.GetFiles("*.csproj", SearchOption.AllDirectories));
        }

        /// <summary>
        /// Reads all the source files and references from the given list of projects.
        /// </summary>
        /// <param name="projectFiles">The list of projects to analyse.</param>
        void AnalyseProjectFiles(FileInfo[] projectFiles)
        {
            progressMonitor.AnalysingProjectFiles(projectFiles.Count());

            foreach (var proj in projectFiles)
            {
                try
                {
                    var csProj = new CsProjFile(proj);

                    foreach (var @ref in csProj.References)
                    {
                        AssemblyInfo resolved = assemblyCache.ResolveReference(@ref);
                        if (!resolved.Valid)
                        {
                            UnresolvedReference(@ref, proj.FullName);
                        }
                        else
                        {
                            UseReference(resolved.Filename);
                        }
                    }

                    foreach (var src in csProj.Sources)
                    {
                        // Make a note of which source files the projects use.
                        // This information doesn't affect the build but is dumped
                        // as diagnostic output.
                        UseSource(new FileInfo(src));
                    }
                    ++succeededProjects;
                }
                catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
                {
                    ++failedProjects;
                    progressMonitor.FailedProjectFile(proj.FullName, ex.Message);
                }
            }
        }

        /// <summary>
        /// Delete packages directory.
        /// </summary>
        public void Cleanup()
        {
            if (nuget != null) nuget.Cleanup(progressMonitor);
        }

        /// <summary>
        /// Analyse all project files in a given solution only.
        /// </summary>
        /// <param name="solutionFile">The filename of the solution.</param>
        public void AnalyseSolution(string solutionFile)
        {
            var sln = new SolutionFile(solutionFile);
            AnalyseProjectFiles(sln.Projects.Select(p => new FileInfo(p)).ToArray());
        }
    }
}
