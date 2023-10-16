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
        private readonly List<string> nonGeneratedSources;
        private readonly List<string> generatedSources;
        private int conflictedReferences = 0;
        private readonly IDependencyOptions options;
        private readonly DirectoryInfo sourceDir;
        private readonly IDotNet dotnet;
        private readonly FileContent fileContent;
        private readonly TemporaryDirectory packageDirectory;
        private readonly TemporaryDirectory tempWorkingDirectory;
        private readonly bool cleanupTempWorkingDirectory;

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

            packageDirectory = new TemporaryDirectory(ComputeTempDirectory(sourceDir.FullName));
            tempWorkingDirectory = new TemporaryDirectory(FileUtils.GetTemporaryWorkingDirectory(out cleanupTempWorkingDirectory));

            try
            {
                this.dotnet = DotNet.Make(options, progressMonitor, tempWorkingDirectory);
            }
            catch
            {
                progressMonitor.MissingDotNet();
                throw;
            }

            this.progressMonitor.FindingFiles(srcDir);


            var allFiles = GetAllFiles();
            var binaryFileExtensions = new HashSet<string>(new[] { ".dll", ".exe" }); // TODO: add more binary file extensions.
            var allNonBinaryFiles = allFiles.Where(f => !binaryFileExtensions.Contains(f.Extension.ToLowerInvariant())).ToList();
            var smallNonBinaryFiles = allNonBinaryFiles.SelectSmallFiles(progressMonitor).SelectFileNames();
            this.fileContent = new FileContent(progressMonitor, smallNonBinaryFiles);
            this.nonGeneratedSources = allNonBinaryFiles.SelectFileNamesByExtension(".cs").ToList();
            this.generatedSources = new();
            var allProjects = allNonBinaryFiles.SelectFileNamesByExtension(".csproj");
            var solutions = options.SolutionFile is not null
                ? new[] { options.SolutionFile }
                : allNonBinaryFiles.SelectFileNamesByExtension(".sln");
            var dllDirNames = options.DllDirs.Count == 0
                ? allFiles.SelectFileNamesByExtension(".dll").ToList()
                : options.DllDirs.Select(Path.GetFullPath).ToList();

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

                var restoredProjects = RestoreSolutions(solutions);
                var projects = allProjects.Except(restoredProjects);
                RestoreProjects(projects);
                DownloadMissingPackages(allNonBinaryFiles);
            }

            var existsNetCoreRefNugetPackage = false;
            var existsNetFrameworkRefNugetPackage = false;

            // Find DLLs in the .Net / Asp.Net Framework
            // This block needs to come after the nuget restore, because the nuget restore might fetch the .NET Core/Framework reference assemblies.
            if (options.ScanNetFrameworkDlls)
            {
                existsNetCoreRefNugetPackage = IsNugetPackageAvailable("microsoft.netcore.app.ref");
                existsNetFrameworkRefNugetPackage = IsNugetPackageAvailable("microsoft.netframework.referenceassemblies");

                if (existsNetCoreRefNugetPackage || existsNetFrameworkRefNugetPackage)
                {
                    progressMonitor.LogInfo("Found .NET Core/Framework DLLs in NuGet packages. Not adding installation directory.");
                }
                else
                {
                    AddNetFrameworkDlls(dllDirNames);
                }
            }

            assemblyCache = new AssemblyCache(dllDirNames, progressMonitor);
            AnalyseSolutions(solutions);

            foreach (var filename in assemblyCache.AllAssemblies.Select(a => a.Filename))
            {
                UseReference(filename);
            }

            RemoveUnnecessaryNugetPackages(existsNetCoreRefNugetPackage, existsNetFrameworkRefNugetPackage);
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
                GenerateSourceFilesFromWebViews(allNonBinaryFiles);
            }

            GenerateSourceFileFromImplicitUsings();

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

        private void RemoveUnnecessaryNugetPackages(bool existsNetCoreRefNugetPackage, bool existsNetFrameworkRefNugetPackage)
        {
            RemoveNugetAnalyzerReferences();
            RemoveRuntimeNugetPackageReferences();

            if (fileContent.IsNewProjectStructureUsed
                && !fileContent.UseAspNetCoreDlls)
            {
                // This might have been restored by the CLI even though the project isn't an asp.net core one.
                RemoveNugetPackageReference("microsoft.aspnetcore.app.ref");
            }

            if (existsNetCoreRefNugetPackage && existsNetFrameworkRefNugetPackage)
            {
                // Multiple packages are available, we keep only one:
                RemoveNugetPackageReference("microsoft.netframework.referenceassemblies.");
            }

            // TODO: There could be multiple `microsoft.netframework.referenceassemblies` packages,
            // we could keep the newest one, but this is covered by the conflict resolution logic
            // (if the file names match)
        }

        private void RemoveNugetAnalyzerReferences()
        {
            if (!options.UseNuGet)
            {
                return;
            }

            var packageFolder = packageDirectory.DirInfo.FullName.ToLowerInvariant();
            if (packageFolder == null)
            {
                return;
            }

            foreach (var filename in usedReferences.Keys)
            {
                var lowerFilename = filename.ToLowerInvariant();

                if (lowerFilename.StartsWith(packageFolder))
                {
                    var firstDirectorySeparatorCharIndex = lowerFilename.IndexOf(Path.DirectorySeparatorChar, packageFolder.Length + 1);
                    if (firstDirectorySeparatorCharIndex == -1)
                    {
                        continue;
                    }
                    var secondDirectorySeparatorCharIndex = lowerFilename.IndexOf(Path.DirectorySeparatorChar, firstDirectorySeparatorCharIndex + 1);
                    if (secondDirectorySeparatorCharIndex == -1)
                    {
                        continue;
                    }
                    var subFolderIndex = secondDirectorySeparatorCharIndex + 1;
                    var isInAnalyzersFolder = lowerFilename.IndexOf("analyzers", subFolderIndex) == subFolderIndex;
                    if (isInAnalyzersFolder)
                    {
                        usedReferences.Remove(filename);
                        progressMonitor.RemovedReference(filename);
                    }
                }
            }
        }
        private void AddNetFrameworkDlls(List<string> dllDirNames)
        {
            var runtime = new Runtime(dotnet);
            string? runtimeLocation = null;

            if (options.UseSelfContainedDotnet)
            {
                runtimeLocation = runtime.ExecutingRuntime;
            }
            else if (fileContent.IsNewProjectStructureUsed)
            {
                runtimeLocation = runtime.NetCoreRuntime;
            }
            else if (fileContent.IsLegacyProjectStructureUsed)
            {
                runtimeLocation = runtime.DesktopRuntime;
            }

            runtimeLocation ??= runtime.ExecutingRuntime;

            progressMonitor.LogInfo($".NET runtime location selected: {runtimeLocation}");
            dllDirNames.Add(runtimeLocation);

            if (fileContent.IsNewProjectStructureUsed
                && fileContent.UseAspNetCoreDlls
                && runtime.AspNetCoreRuntime is string aspRuntime)
            {
                progressMonitor.LogInfo($"ASP.NET runtime location selected: {aspRuntime}");
                dllDirNames.Add(aspRuntime);
            }
        }

        private void RemoveRuntimeNugetPackageReferences()
        {
            var runtimePackagePrefixes = new[]
            {
                "microsoft.netcore.app.runtime",
                "microsoft.aspnetcore.app.runtime",
                "microsoft.windowsdesktop.app.runtime",

                // legacy runtime packages:
                "runtime.linux-x64.microsoft.netcore.app",
                "runtime.osx-x64.microsoft.netcore.app",
                "runtime.win-x64.microsoft.netcore.app",

                // Internal implementation packages not meant for direct consumption:
                "runtime."
            };
            RemoveNugetPackageReference(runtimePackagePrefixes);
        }

        private void RemoveNugetPackageReference(params string[] packagePrefixes)
        {
            if (!options.UseNuGet)
            {
                return;
            }

            var packageFolder = packageDirectory.DirInfo.FullName.ToLowerInvariant();
            if (packageFolder == null)
            {
                return;
            }

            var packagePathPrefixes = packagePrefixes.Select(p => Path.Combine(packageFolder, p.ToLowerInvariant()));

            foreach (var filename in usedReferences.Keys)
            {
                var lowerFilename = filename.ToLowerInvariant();

                if (packagePathPrefixes.Any(prefix => lowerFilename.StartsWith(prefix)))
                {
                    usedReferences.Remove(filename);
                    progressMonitor.RemovedReference(filename);
                }
            }
        }

        private bool IsNugetPackageAvailable(string packagePrefix)
        {
            if (!options.UseNuGet)
            {
                return false;
            }

            return new DirectoryInfo(packageDirectory.DirInfo.FullName)
                .EnumerateDirectories(packagePrefix + "*", new EnumerationOptions { MatchCasing = MatchCasing.CaseInsensitive, RecurseSubdirectories = false })
                .Any();
        }

        private void GenerateSourceFileFromImplicitUsings()
        {
            var usings = new HashSet<string>();
            if (!fileContent.UseImplicitUsings)
            {
                return;
            }

            // Hardcoded values from https://learn.microsoft.com/en-us/dotnet/core/project-sdk/overview#implicit-using-directives
            usings.UnionWith(new[] { "System", "System.Collections.Generic", "System.IO", "System.Linq", "System.Net.Http", "System.Threading",
                "System.Threading.Tasks" });

            if (fileContent.UseAspNetCoreDlls)
            {
                usings.UnionWith(new[] { "System.Net.Http.Json", "Microsoft.AspNetCore.Builder", "Microsoft.AspNetCore.Hosting",
                    "Microsoft.AspNetCore.Http", "Microsoft.AspNetCore.Routing", "Microsoft.Extensions.Configuration",
                    "Microsoft.Extensions.DependencyInjection", "Microsoft.Extensions.Hosting", "Microsoft.Extensions.Logging" });
            }

            usings.UnionWith(fileContent.CustomImplicitUsings);

            if (usings.Count > 0)
            {
                var tempDir = GetTemporaryWorkingDirectory("implicitUsings");
                var path = Path.Combine(tempDir, "GlobalUsings.g.cs");
                using (var writer = new StreamWriter(path))
                {
                    writer.WriteLine("// <auto-generated/>");
                    writer.WriteLine("");

                    foreach (var u in usings.OrderBy(u => u))
                    {
                        writer.WriteLine($"global using global::{u};");
                    }
                }

                this.generatedSources.Add(path);
            }
        }

        private void GenerateSourceFilesFromWebViews(List<FileInfo> allFiles)
        {
            progressMonitor.LogInfo($"Generating source files from cshtml and razor files.");

            var views = allFiles.SelectFileNamesByExtension(".cshtml", ".razor").ToArray();

            if (views.Length > 0)
            {
                progressMonitor.LogInfo($"Found {views.Length} cshtml and razor files.");

                var sdk = new Sdk(dotnet).GetNewestSdk();
                if (sdk != null)
                {
                    try
                    {
                        var razor = new Razor(sdk, dotnet, progressMonitor);
                        var targetDir = GetTemporaryWorkingDirectory("razor");
                        var generatedFiles = razor.GenerateFiles(views, usedReferences.Keys, targetDir);
                        this.generatedSources.AddRange(generatedFiles);
                    }
                    catch (Exception ex)
                    {
                        // It's okay, we tried our best to generate source files from cshtml files.
                        progressMonitor.LogInfo($"Failed to generate source files from cshtml files: {ex.Message}");
                    }
                }
            }
        }

        public DependencyManager(string srcDir) : this(srcDir, DependencyOptions.Default, new ConsoleLogger(Verbosity.Info, logThreadId: true)) { }

        private IEnumerable<FileInfo> GetAllFiles()
        {
            var files = sourceDir.GetFiles("*.*", new EnumerationOptions { RecurseSubdirectories = true })
                .Where(d => !options.ExcludesFile(d.FullName));

            if (options.DotNetPath != null)
            {
                files = files.Where(f => !f.FullName.StartsWith(options.DotNetPath, StringComparison.OrdinalIgnoreCase));
            }

            return files;
        }

        /// <summary>
        /// Computes a unique temp directory for the packages associated
        /// with this source tree. Use a SHA1 of the directory name.
        /// </summary>
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
        /// Creates a temporary directory with the given subfolder name.
        /// The created directory might be inside the repo folder, and it is deleted when the object is disposed.
        /// </summary>
        /// <param name="subfolder"></param>
        /// <returns></returns>
        private string GetTemporaryWorkingDirectory(string subfolder)
        {
            var temp = Path.Combine(tempWorkingDirectory.ToString(), subfolder);
            Directory.CreateDirectory(temp);

            return temp;
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
            sortedReferences = sortedReferences
                .OrderBy(r => r.NetCoreVersion ?? emptyVersion)
                .ThenBy(r => r.Version ?? emptyVersion)
                .ThenBy(r => r.Filename)
                .ToList();

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
        /// All of the generated source files in the source directory.
        /// </summary>
        public IEnumerable<string> GeneratedSourceFiles => generatedSources;

        /// <summary>
        /// All of the source files in the source directory.
        /// </summary>
        public IEnumerable<string> AllSourceFiles => generatedSources.Concat(nonGeneratedSources);

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

        private bool RestoreProject(string project, bool forceDotnetRefAssemblyFetching, string? pathToNugetConfig = null) =>
            dotnet.RestoreProjectToDirectory(project, packageDirectory.DirInfo.FullName, forceDotnetRefAssemblyFetching, pathToNugetConfig);

        private bool RestoreSolution(string solution, out IEnumerable<string> projects) =>
            dotnet.RestoreSolutionToDirectory(solution, packageDirectory.DirInfo.FullName, forceDotnetRefAssemblyFetching: true, out projects);

        /// <summary>
        /// Executes `dotnet restore` on all solution files in solutions.
        /// As opposed to RestoreProjects this is not run in parallel using PLINQ
        /// as `dotnet restore` on a solution already uses multiple threads for restoring
        /// the projects (this can be disabled with the `--disable-parallel` flag).
        /// Returns a list of projects that are up to date with respect to restore.
        /// </summary>
        /// <param name="solutions">A list of paths to solution files.</param>
        private IEnumerable<string> RestoreSolutions(IEnumerable<string> solutions) =>
            solutions.SelectMany(solution =>
                {
                    RestoreSolution(solution, out var restoredProjects);
                    return restoredProjects;
                });

        /// <summary>
        /// Executes `dotnet restore` on all projects in projects.
        /// This is done in parallel for performance reasons.
        /// </summary>
        /// <param name="projects">A list of paths to project files.</param>
        private void RestoreProjects(IEnumerable<string> projects)
        {
            Parallel.ForEach(projects, new ParallelOptions { MaxDegreeOfParallelism = options.Threads }, project =>
            {
                RestoreProject(project, forceDotnetRefAssemblyFetching: true);
            });
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

            Parallel.ForEach(notYetDownloadedPackages, new ParallelOptions { MaxDegreeOfParallelism = options.Threads }, package =>
            {
                progressMonitor.NugetInstall(package);
                using var tempDir = new TemporaryDirectory(ComputeTempDirectory(package));
                var success = dotnet.New(tempDir.DirInfo.FullName);
                if (!success)
                {
                    return;
                }

                success = dotnet.AddPackage(tempDir.DirInfo.FullName, package);
                if (!success)
                {
                    return;
                }

                success = RestoreProject(tempDir.DirInfo.FullName, forceDotnetRefAssemblyFetching: false, pathToNugetConfig: nugetConfig);
                // TODO: the restore might fail, we could retry with a prerelease (*-* instead of *) version of the package.
                if (!success)
                {
                    progressMonitor.FailedToRestoreNugetPackage(package);
                }
            });
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
            try
            {
                packageDirectory?.Dispose();
            }
            catch (Exception exc)
            {
                progressMonitor.LogInfo("Couldn't delete package directory: " + exc.Message);
            }
            if (cleanupTempWorkingDirectory)
            {
                try
                {
                    tempWorkingDirectory?.Dispose();
                }
                catch (Exception exc)
                {
                    progressMonitor.LogInfo("Couldn't delete temporary working directory: " + exc.Message);
                }
            }
        }
    }
}
