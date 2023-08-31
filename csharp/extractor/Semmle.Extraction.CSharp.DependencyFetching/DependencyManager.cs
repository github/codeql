using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Main implementation of the build analysis.
    /// </summary>
    public sealed class DependencyManager : IDisposable
    {
        private readonly AssemblyCache assemblyCache;
        private readonly ProgressMonitor progressMonitor;
        private readonly IDictionary<string, bool> usedReferences = new ConcurrentDictionary<string, bool>();
        private readonly IDictionary<string, bool> sources = new ConcurrentDictionary<string, bool>();
        private readonly IDictionary<string, string> unresolvedReferences = new ConcurrentDictionary<string, string>();
        private int failedProjects;
        private int succeededProjects;
        private readonly List<string> allSources;
        private int conflictedReferences = 0;
        private readonly IDependencyOptions options;
        private readonly DirectoryInfo sourceDir;
        private readonly DotNet dotnet;
        private readonly FileContent fileContent;
        private readonly TemporaryDirectory packageDirectory;
        private TemporaryDirectory? razorWorkingDirectory;


        /// <summary>
        /// Performs C# dependency fetching.
        /// </summary>
        /// <param name="options">Dependency fetching options</param>
        /// <param name="logger">Logger for dependency fetching progress.</param>
        public DependencyManager(string srcDir, IDependencyOptions options, ILogger logger)
        {
            var startTime = DateTime.Now;

            this.options = options;
            this.progressMonitor = new ProgressMonitor(logger);
            this.sourceDir = new DirectoryInfo(srcDir);

            try
            {
                this.dotnet = new DotNet(progressMonitor);
            }
            catch
            {
                progressMonitor.MissingDotNet();
                throw;
            }

            this.progressMonitor.FindingFiles(srcDir);

            packageDirectory = new TemporaryDirectory(ComputeTempDirectory(sourceDir.FullName));
            var allFiles = GetAllFiles().ToList();
            var smallFiles = allFiles.SelectSmallFiles(progressMonitor).SelectFileNames();
            this.fileContent = new FileContent(progressMonitor, smallFiles);
            this.allSources = allFiles.SelectFileNamesByExtension(".cs").ToList();
            var allProjects = allFiles.SelectFileNamesByExtension(".csproj");
            var solutions = options.SolutionFile is not null
                ? new[] { options.SolutionFile }
                : allFiles.SelectFileNamesByExtension(".sln");

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
                    DownloadMissingPackages(allFiles);
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
            foreach (var r in usedReferences.Keys.OrderBy(r => r))
            {
                progressMonitor.ResolvedReference(r);
            }

            foreach (var r in unresolvedReferences.OrderBy(r => r.Key))
            {
                progressMonitor.UnresolvedReference(r.Key, r.Value);
            }

            var webViewExtractionOption = Environment.GetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_STANDALONE_EXTRACT_WEB_VIEWS");
            if (bool.TryParse(webViewExtractionOption, out var shouldExtractWebViews) &&
                shouldExtractWebViews)
            {
                GenerateSourceFilesFromWebViews(allFiles);
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

        private void GenerateSourceFilesFromWebViews(List<FileInfo> allFiles)
        {
            progressMonitor.LogInfo($"Generating source files from cshtml and razor files.");

            var views = allFiles.SelectFileNamesByExtension(".cshtml", ".razor").ToArray();

            if (views.Length > 0)
            {
                progressMonitor.LogInfo($"Found {views.Length} cshtml and razor files.");

                // TODO: use SDK specified in global.json
                var sdk = new Sdk(dotnet).GetNewestSdk();
                if (sdk != null)
                {
                    try
                    {
                        var razor = new Razor(sdk, dotnet, progressMonitor);
                        razorWorkingDirectory = new TemporaryDirectory(ComputeTempDirectory(sourceDir.FullName, "razor"));
                        var generatedFiles = razor.GenerateFiles(views, usedReferences.Keys, razorWorkingDirectory.ToString());
                        this.allSources.AddRange(generatedFiles);
                    }
                    catch (Exception ex)
                    {
                        // It's okay, we tried our best to generate source files from cshtml files.
                        progressMonitor.LogInfo($"Failed to generate source files from cshtml files: {ex.Message}");
                    }
                }
            }
        }

        public DependencyManager(string srcDir) : this(srcDir, DependencyOptions.Default, new ConsoleLogger(Verbosity.Info)) { }

        private IEnumerable<FileInfo> GetAllFiles() =>
             sourceDir.GetFiles("*.*", new EnumerationOptions { RecurseSubdirectories = true })
                .Where(d => d.Extension != ".dll" && !options.ExcludesFile(d.FullName));

        /// <summary>
        /// Computes a unique temp directory for the packages associated
        /// with this source tree. Use a SHA1 of the directory name.
        /// </summary>
        /// <returns>The full path of the temp directory.</returns>
        private static string ComputeTempDirectory(string srcDir, string subfolderName = "packages")
        {
            var bytes = Encoding.Unicode.GetBytes(srcDir);
            var sha = SHA1.HashData(bytes);
            var sb = new StringBuilder();
            foreach (var b in sha.Take(8))
                sb.AppendFormat("{0:x2}", b);

            return Path.Combine(Path.GetTempPath(), "GitHub", subfolderName, sb.ToString());
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

            var emptyVersion = new Version(0, 0);
            sortedReferences = sortedReferences.OrderBy(r => r.NetCoreVersion ?? emptyVersion).ThenBy(r => r.Version ?? emptyVersion).ToList();

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
                if (resolvedInfo.Version != r.Version || resolvedInfo.NetCoreVersion != r.NetCoreVersion)
                {
                    progressMonitor.ResolvedConflict(r.Id, resolvedInfo.Id + resolvedInfo.NetCoreVersion is null ? "" : $" (.NET Core {resolvedInfo.NetCoreVersion})");
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
                var csProj = new CsProjFile(project);

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

        private void DownloadMissingPackages(List<FileInfo> allFiles)
        {
            var nugetConfigs = allFiles.SelectFileNamesByName("nuget.config").ToArray();
            string? nugetConfig = null;
            if (nugetConfigs.Length > 1)
            {
                progressMonitor.MultipleNugetConfig(nugetConfigs);
                nugetConfig = allFiles
                    .SelectRootFiles(sourceDir)
                    .SelectFileNamesByName("nuget.config")
                    .FirstOrDefault();
                if (nugetConfig == null)
                {
                    progressMonitor.NoTopLevelNugetConfig();
                }
            }
            else
            {
                nugetConfig = nugetConfigs.FirstOrDefault();
            }

            var alreadyDownloadedPackages = Directory.GetDirectories(packageDirectory.DirInfo.FullName)
                .Select(d => Path.GetFileName(d).ToLowerInvariant());
            var notYetDownloadedPackages = fileContent.AllPackages.Except(alreadyDownloadedPackages);
            foreach (var package in notYetDownloadedPackages)
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
            Parallel.ForEach(solutions, new ParallelOptions { MaxDegreeOfParallelism = options.Threads }, solutionFile =>
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

        public void Dispose()
        {
            packageDirectory?.Dispose();
            razorWorkingDirectory?.Dispose();
        }
    }
}
