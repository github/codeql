using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Semmle.Extraction.CSharp.Standalone;
using System.Threading.Tasks;

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
        private readonly AssemblyCache assemblyCache;
        private readonly NugetPackages nuget;
        private readonly IProgressMonitor progressMonitor;
        private HashSet<string> usedReferences = new HashSet<string>();
        private readonly HashSet<string> usedSources = new HashSet<string>();
        private readonly HashSet<string> missingSources = new HashSet<string>();
        private readonly Dictionary<string, string> unresolvedReferences = new Dictionary<string, string>();
        private readonly DirectoryInfo sourceDir;
        private int failedProjects, succeededProjects;
        private readonly string[] allSources;
        private int conflictedReferences = 0;
        private readonly object mutex = new object();

        /// <summary>
        /// Performs a C# build analysis.
        /// </summary>
        /// <param name="options">Analysis options from the command line.</param>
        /// <param name="progress">Display of analysis progress.</param>
        public BuildAnalysis(Options options, IProgressMonitor progress)
        {
            var startTime = DateTime.Now;

            progressMonitor = progress;
            sourceDir = new DirectoryInfo(options.SrcDir);

            progressMonitor.FindingFiles(options.SrcDir);

            allSources = sourceDir.GetFiles("*.cs", SearchOption.AllDirectories).
                Select(d => d.FullName).
                Where(d => !options.ExcludesFile(d)).
                ToArray();

            var dllDirNames = options.DllDirs.Select(Path.GetFullPath).ToList();
            PackageDirectory = TemporaryDirectory.CreateTempDirectory(sourceDir.FullName);

            if (options.UseNuGet)
            {
                try
                {
                    nuget = new NugetPackages(sourceDir.FullName, PackageDirectory);
                    ReadNugetFiles();
                }
                catch(FileNotFoundException)
                {
                    progressMonitor.MissingNuGet();
                }
            }

            // Find DLLs in the .Net Framework
            if (options.ScanNetFrameworkDlls)
            {
                dllDirNames.Add(Runtime.Runtimes.First());
            }
            
            {
                // These files can sometimes prevent `dotnet restore` from working correctly.
                using (new FileRenamer(sourceDir.GetFiles("global.json", SearchOption.AllDirectories)))
                using (new FileRenamer(sourceDir.GetFiles("Directory.Build.props", SearchOption.AllDirectories)))
                {
                    var solutions = options.SolutionFile != null ?
                            new[] { options.SolutionFile } :
                            sourceDir.GetFiles("*.sln", SearchOption.AllDirectories).Select(d => d.FullName);

                    RestoreSolutions(solutions);
                    dllDirNames.Add(PackageDirectory.DirInfo.FullName);
                    assemblyCache = new BuildAnalyser.AssemblyCache(dllDirNames, progress);
                    AnalyseSolutions(solutions);

                    usedReferences = new HashSet<string>(assemblyCache.AllAssemblies.Select(a => a.Filename));
                }
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
                failedProjects,
                DateTime.Now - startTime);
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
            lock (mutex)
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
                lock(mutex)
                    usedSources.Add(sourceFile.FullName);
            }
            else
            {
                lock(mutex)
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
            lock(mutex)
                unresolvedReferences[id] = projectFile;
        }

        readonly TemporaryDirectory PackageDirectory;

        /// <summary>
        /// Reads all the source files and references from the given list of projects.
        /// </summary>
        /// <param name="projectFiles">The list of projects to analyse.</param>
        void AnalyseProjectFiles(IEnumerable<FileInfo> projectFiles)
        {
            foreach (var proj in projectFiles)
                AnalyseProject(proj);
        }

        void AnalyseProject(FileInfo project)
        {
            if(!project.Exists)
            {
                progressMonitor.MissingProject(project.FullName);
                return;
            }

            try
            {
                IProjectFile csProj = new CsProjFile(project);

                foreach (var @ref in csProj.References)
                {
                    AssemblyInfo resolved = assemblyCache.ResolveReference(@ref);
                    if (!resolved.Valid)
                    {
                        UnresolvedReference(@ref, project.FullName);
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
                progressMonitor.FailedProjectFile(project.FullName, ex.Message);
            }

        }

        /// <summary>
        /// Delete packages directory.
        /// </summary>
        public void Cleanup()
        {
            PackageDirectory?.Cleanup();
        }

        void Restore(string projectOrSolution)
        {
            int exit = DotNet.RestoreToDirectory(projectOrSolution, PackageDirectory.DirInfo.FullName);
            switch(exit)
            {
                case 0:
                case 1:
                    // No errors
                    break;
                default:
                    progressMonitor.CommandFailed("dotnet", $"restore \"{projectOrSolution}\"", exit);
                    break;
            }
        }

        public void RestoreSolutions(IEnumerable<string> solutions)
        {
            Parallel.ForEach(solutions, new ParallelOptions { MaxDegreeOfParallelism = 4 }, Restore);
        }

        public void AnalyseSolutions(IEnumerable<string> solutions)
        {
            Parallel.ForEach(solutions, new ParallelOptions { MaxDegreeOfParallelism = 4 } , solutionFile =>
            {
                try
                {
                    var sln = new SolutionFile(solutionFile);
                    progressMonitor.AnalysingSolution(solutionFile);
                    AnalyseProjectFiles(sln.Projects.Select(p => new FileInfo(p)).Where(p => p.Exists).ToArray());
                }
                catch (Microsoft.Build.Exceptions.InvalidProjectFileException ex)
                {
                    progressMonitor.FailedProjectFile(solutionFile, ex.BaseMessage);
                }
            });
        }
    }
}
