using Semmle.Util;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Semmle.Extraction.CSharp.Standalone;
using System.Threading.Tasks;
using System.Collections.Concurrent;
using System.Text;
using System.Security.Cryptography;

namespace Semmle.BuildAnalyser
{
    /// <summary>
    /// Main implementation of the build analysis.
    /// </summary>
    internal sealed class BuildAnalysis : IDisposable
    {
        private readonly AssemblyCache assemblyCache;
        private readonly ProgressMonitor progressMonitor;
        private readonly IDictionary<string, bool> usedReferences = new ConcurrentDictionary<string, bool>();
        private readonly IDictionary<string, bool> sources = new ConcurrentDictionary<string, bool>();
        private readonly IDictionary<string, string> unresolvedReferences = new ConcurrentDictionary<string, string>();
        private int failedProjects;
        private int succeededProjects;
        private readonly string[] allSources;
        private int conflictedReferences = 0;
        private readonly Options options;
        private readonly DirectoryInfo sourceDir;
        private readonly DotNet dotnet;
        private readonly FileContent fileContent;
        private readonly TemporaryDirectory packageDirectory;


        /// <summary>
        /// Performs a C# build analysis.
        /// </summary>
        /// <param name="options">Analysis options from the command line.</param>
        /// <param name="progressMonitor">Display of analysis progress.</param>
        public BuildAnalysis(Options options, ProgressMonitor progressMonitor)
        {
            var startTime = DateTime.Now;

            this.options = options;
            this.progressMonitor = progressMonitor;
            this.sourceDir = new DirectoryInfo(options.SrcDir);

            try
            {
                this.dotnet = new DotNet(progressMonitor);
            }
            catch
            {
                progressMonitor.MissingDotNet();
                throw;
            }

            this.progressMonitor.FindingFiles(options.SrcDir);

            packageDirectory = new TemporaryDirectory(ComputeTempDirectory(sourceDir.FullName));

            this.fileContent = new FileContent(packageDirectory, progressMonitor, () => GetFiles("*.*"));
            this.allSources = GetFiles("*.cs").ToArray();
            var allProjects = GetFiles("*.csproj");
            var solutions = options.SolutionFile is not null
                ? new[] { options.SolutionFile }
                : GetFiles("*.sln");

            var dllDirNames = options.DllDirs.Select(Path.GetFullPath).ToList();

            // Find DLLs in the .Net / Asp.Net Framework
            if (options.ScanNetFrameworkDlls)
            {
                var runtime = new Runtime(dotnet);
                var runtimeLocation = runtime.GetRuntime(options.UseSelfContainedDotnet);
                progressMonitor.LogInfo($".NET runtime location selected: {runtimeLocation}");
                dllDirNames.Add(runtimeLocation);

                if (fileContent.UseAspNetDlls && runtime.GetAspRuntime() is string aspRuntime)
                {
                    progressMonitor.LogInfo($"ASP.NET runtime location selected: {aspRuntime}");
                    dllDirNames.Add(aspRuntime);
                }
            }

            if (options.UseMscorlib)
            {
                UseReference(typeof(object).Assembly.Location);
            }

            if (options.UseNuGet)
            {
                dllDirNames.Add(packageDirectory.DirInfo.FullName);
                try
                {
                    var nuget = new NugetPackages(sourceDir.FullName, packageDirectory, progressMonitor);
                    nuget.InstallPackages();
                }
                catch (FileNotFoundException)
                {
                    progressMonitor.MissingNuGet();
                }

                // TODO: remove the below when the required SDK is installed
                using (new FileRenamer(sourceDir.GetFiles("global.json", SearchOption.AllDirectories)))
                {
                    Restore(solutions);
                    Restore(allProjects);
                    DownloadMissingPackages(allProjects);
                }
            }

            assemblyCache = new AssemblyCache(dllDirNames, progressMonitor);
            AnalyseSolutions(solutions);

            foreach (var filename in assemblyCache.AllAssemblies.Select(a => a.Filename))
            {
                UseReference(filename);
            }

            ResolveConflicts();

            // Output the findings
            foreach (var r in usedReferences.Keys)
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

        private IEnumerable<string> GetFiles(string pattern, bool recurseSubdirectories = true)
        {
            return sourceDir.GetFiles(pattern, new EnumerationOptions { RecurseSubdirectories = recurseSubdirectories, MatchCasing = MatchCasing.CaseInsensitive })
                .Select(d => d.FullName)
                .Where(d => !options.ExcludesFile(d));
        }

        /// <summary>
        /// Computes a unique temp directory for the packages associated
        /// with this source tree. Use a SHA1 of the directory name.
        /// </summary>
        /// <param name="srcDir"></param>
        /// <returns>The full path of the temp directory.</returns>
        private static string ComputeTempDirectory(string srcDir)
        {
            var bytes = Encoding.Unicode.GetBytes(srcDir);
            var sha = SHA1.HashData(bytes);
            var sb = new StringBuilder();
            foreach (var b in sha.Take(8))
                sb.AppendFormat("{0:x2}", b);

            return Path.Combine(Path.GetTempPath(), "GitHub", "packages", sb.ToString());
        }

        /// <summary>
        /// Resolves conflicts between all of the resolved references.
        /// If the same assembly name is duplicated with different versions,
        /// resolve to the higher version number.
        /// </summary>
        private void ResolveConflicts()
        {
            var sortedReferences = new List<AssemblyInfo>();
            foreach (var usedReference in usedReferences)
            {
                try
                {
                    var assemblyInfo = assemblyCache.GetAssemblyInfo(usedReference.Key);
                    sortedReferences.Add(assemblyInfo);
                }
                catch (AssemblyLoadException)
                {
                    progressMonitor.Log(Util.Logging.Severity.Warning, $"Could not load assembly information from {usedReference.Key}");
                }
            }

            sortedReferences = sortedReferences.OrderBy(r => r.Version).ToList();

            var finalAssemblyList = new Dictionary<string, AssemblyInfo>();

            // Pick the highest version for each assembly name
            foreach (var r in sortedReferences)
            {
                finalAssemblyList[r.Name] = r;
            }

            // Update the used references list
            usedReferences.Clear();
            foreach (var r in finalAssemblyList.Select(r => r.Value.Filename))
            {
                UseReference(r);
            }

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
        /// Store that a particular reference file is used.
        /// </summary>
        /// <param name="reference">The filename of the reference.</param>
        private void UseReference(string reference) => usedReferences[reference] = true;

        /// <summary>
        /// Store that a particular source file is used (by a project file).
        /// </summary>
        /// <param name="sourceFile">The source file.</param>
        private void UseSource(FileInfo sourceFile) => sources[sourceFile.FullName] = sourceFile.Exists;

        /// <summary>
        /// The list of resolved reference files.
        /// </summary>
        public IEnumerable<string> ReferenceFiles => usedReferences.Keys;

        /// <summary>
        /// The list of source files used in projects.
        /// </summary>
        public IEnumerable<string> ProjectSourceFiles => sources.Where(s => s.Value).Select(s => s.Key);

        /// <summary>
        /// All of the source files in the source directory.
        /// </summary>
        public IEnumerable<string> AllSourceFiles => allSources;

        /// <summary>
        /// List of assembly IDs which couldn't be resolved.
        /// </summary>
        public IEnumerable<string> UnresolvedReferences => unresolvedReferences.Select(r => r.Key);

        /// <summary>
        /// List of source files which were mentioned in project files but
        /// do not exist on the file system.
        /// </summary>
        public IEnumerable<string> MissingSourceFiles => sources.Where(s => !s.Value).Select(s => s.Key);

        /// <summary>
        /// Record that a particular reference couldn't be resolved.
        /// Note that this records at most one project file per missing reference.
        /// </summary>
        /// <param name="id">The assembly ID.</param>
        /// <param name="projectFile">The project file making the reference.</param>
        private void UnresolvedReference(string id, string projectFile) => unresolvedReferences[id] = projectFile;

        /// <summary>
        /// Reads all the source files and references from the given list of projects.
        /// </summary>
        /// <param name="projectFiles">The list of projects to analyse.</param>
        private void AnalyseProjectFiles(IEnumerable<FileInfo> projectFiles)
        {
            foreach (var proj in projectFiles)
            {
                AnalyseProject(proj);
            }
        }

        private void AnalyseProject(FileInfo project)
        {
            if (!project.Exists)
            {
                progressMonitor.MissingProject(project.FullName);
                return;
            }

            try
            {
                var csProj = new Extraction.CSharp.CsProjFile(project);

                foreach (var @ref in csProj.References)
                {
                    try
                    {
                        var resolved = assemblyCache.ResolveReference(@ref);
                        UseReference(resolved.Filename);
                    }
                    catch (AssemblyLoadException)
                    {
                        UnresolvedReference(@ref, project.FullName);
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

        private bool Restore(string target, string? pathToNugetConfig = null) =>
            dotnet.RestoreToDirectory(target, packageDirectory.DirInfo.FullName, pathToNugetConfig);

        private void Restore(IEnumerable<string> targets, string? pathToNugetConfig = null)
        {
            foreach (var target in targets)
            {
                Restore(target, pathToNugetConfig);
            }
        }


        private void DownloadMissingPackages(IEnumerable<string> restoreTargets)
        {
            var nugetConfigs = GetFiles("nuget.config", recurseSubdirectories: true).ToArray();
            string? nugetConfig = null;
            if (nugetConfigs.Length > 1)
            {
                progressMonitor.MultipleNugetConfig(nugetConfigs);
                nugetConfig = GetFiles("nuget.config", recurseSubdirectories: false).FirstOrDefault();
                if (nugetConfig == null)
                {
                    progressMonitor.NoTopLevelNugetConfig();
                }
            }
            else
            {
                nugetConfig = nugetConfigs.FirstOrDefault();
            }

            foreach (var package in fileContent.NotYetDownloadedPackages)
            {
                progressMonitor.NugetInstall(package);
                using var tempDir = new TemporaryDirectory(ComputeTempDirectory(package));
                var success = dotnet.New(tempDir.DirInfo.FullName);
                if (!success)
                {
                    continue;
                }
                success = dotnet.AddPackage(tempDir.DirInfo.FullName, package);
                if (!success)
                {
                    continue;
                }

                success = Restore(tempDir.DirInfo.FullName, nugetConfig);

                // TODO: the restore might fail, we could retry with a prerelease (*-* instead of *) version of the package.

                if (!success)
                {
                    progressMonitor.FailedToRestoreNugetPackage(package);
                }
            }
        }

        private void AnalyseSolutions(IEnumerable<string> solutions)
        {
            Parallel.ForEach(solutions, new ParallelOptions { MaxDegreeOfParallelism = 4 }, solutionFile =>
            {
                try
                {
                    var sln = new SolutionFile(solutionFile);
                    progressMonitor.AnalysingSolution(solutionFile);
                    AnalyseProjectFiles(sln.Projects.Select(p => new FileInfo(p)).Where(p => p.Exists));
                }
                catch (Microsoft.Build.Exceptions.InvalidProjectFileException ex)
                {
                    progressMonitor.FailedProjectFile(solutionFile, ex.BaseMessage);
                }
            });
        }

        public void Dispose() => packageDirectory?.Dispose();
    }
}
