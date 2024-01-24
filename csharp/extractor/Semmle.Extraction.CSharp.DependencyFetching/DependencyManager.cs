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

        // Only used as a set, but ConcurrentDictionary is the only concurrent set in .NET.
        private readonly IDictionary<string, bool> usedReferences = new ConcurrentDictionary<string, bool>();
        private readonly IDictionary<string, string> unresolvedReferences = new ConcurrentDictionary<string, string>();
        private readonly List<string> nonGeneratedSources;
        private readonly List<string> generatedSources;
        private int conflictedReferences = 0;
        private readonly IDependencyOptions options;
        private readonly DirectoryInfo sourceDir;
        private readonly IDotNet dotnet;
        private readonly FileContent fileContent;
        private readonly TemporaryDirectory packageDirectory;
        private readonly TemporaryDirectory legacyPackageDirectory;
        private readonly TemporaryDirectory missingPackageDirectory;
        private readonly TemporaryDirectory tempWorkingDirectory;
        private readonly bool cleanupTempWorkingDirectory;

        private readonly Lazy<Runtime> runtimeLazy;
        private Runtime Runtime => runtimeLazy.Value;

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

            packageDirectory = new TemporaryDirectory(ComputeTempDirectory(sourceDir.FullName, "packages"));
            legacyPackageDirectory = new TemporaryDirectory(ComputeTempDirectory(sourceDir.FullName, "legacypackages"));
            missingPackageDirectory = new TemporaryDirectory(ComputeTempDirectory(sourceDir.FullName, "missingpackages"));

            tempWorkingDirectory = new TemporaryDirectory(FileUtils.GetTemporaryWorkingDirectory(out cleanupTempWorkingDirectory));

            try
            {
                this.dotnet = DotNet.Make(options, progressMonitor, tempWorkingDirectory);
                runtimeLazy = new Lazy<Runtime>(() => new Runtime(dotnet));
            }
            catch
            {
                progressMonitor.LogError("Missing dotnet CLI");
                throw;
            }

            progressMonitor.LogInfo($"Finding files in {srcDir}...");

            var allFiles = GetAllFiles().ToList();
            var binaryFileExtensions = new HashSet<string>(new[] { ".dll", ".exe" }); // TODO: add more binary file extensions.
            var allNonBinaryFiles = allFiles.Where(f => !binaryFileExtensions.Contains(f.Extension.ToLowerInvariant())).ToList();
            var smallNonBinaryFiles = allNonBinaryFiles.SelectSmallFiles(progressMonitor).SelectFileNames();
            this.fileContent = new FileContent(progressMonitor, smallNonBinaryFiles);
            this.nonGeneratedSources = allNonBinaryFiles.SelectFileNamesByExtension(".cs").ToList();
            this.generatedSources = new();
            var allProjects = allNonBinaryFiles.SelectFileNamesByExtension(".csproj").ToList();
            var allSolutions = allNonBinaryFiles.SelectFileNamesByExtension(".sln").ToList();
            var dllPaths = allFiles.SelectFileNamesByExtension(".dll").ToHashSet();

            progressMonitor.LogInfo($"Found {allFiles.Count} files, {nonGeneratedSources.Count} source files, {allProjects.Count} project files, {allSolutions.Count} solution files, {dllPaths.Count} DLLs.");

            RestoreNugetPackages(allNonBinaryFiles, allProjects, allSolutions, dllPaths);
            // Find DLLs in the .Net / Asp.Net Framework
            // This needs to come after the nuget restore, because the nuget restore might fetch the .NET Core/Framework reference assemblies.
            var frameworkLocations = AddFrameworkDlls(dllPaths);

            assemblyCache = new AssemblyCache(dllPaths, frameworkLocations, progressMonitor);
            AnalyseSolutions(allSolutions);

            foreach (var filename in assemblyCache.AllAssemblies.Select(a => a.Filename))
            {
                UseReference(filename);
            }

            RemoveNugetAnalyzerReferences();
            ResolveConflicts(frameworkLocations);

            // Output the findings
            foreach (var r in usedReferences.Keys.OrderBy(r => r))
            {
                progressMonitor.LogInfo($"Resolved reference {r}");
            }

            foreach (var r in unresolvedReferences.OrderBy(r => r.Key))
            {
                progressMonitor.LogInfo($"Unresolved reference {r.Key} in project {r.Value}");
            }

            var webViewExtractionOption = Environment.GetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_STANDALONE_EXTRACT_WEB_VIEWS");
            if (bool.TryParse(webViewExtractionOption, out var shouldExtractWebViews) &&
                shouldExtractWebViews)
            {
                progressMonitor.LogInfo("Generating source files from cshtml and razor files...");
                GenerateSourceFilesFromWebViews(allNonBinaryFiles);
            }

            GenerateSourceFileFromImplicitUsings();

            const int align = 6;
            progressMonitor.LogInfo("");
            progressMonitor.LogInfo("Build analysis summary:");
            progressMonitor.LogInfo($"{this.nonGeneratedSources.Count,align} source files in the filesystem");
            progressMonitor.LogInfo($"{this.generatedSources.Count,align} generated source files");
            progressMonitor.LogInfo($"{allSolutions.Count,align} solution files");
            progressMonitor.LogInfo($"{allProjects.Count,align} project files in the filesystem");
            progressMonitor.LogInfo($"{usedReferences.Keys.Count,align} resolved references");
            progressMonitor.LogInfo($"{unresolvedReferences.Count,align} unresolved references");
            progressMonitor.LogInfo($"{conflictedReferences,align} resolved assembly conflicts");
            progressMonitor.LogInfo($"Build analysis completed in {DateTime.Now - startTime}");
        }

        private HashSet<string> AddFrameworkDlls(HashSet<string> dllPaths)
        {
            var frameworkLocations = new HashSet<string>();

            AddNetFrameworkDlls(dllPaths, frameworkLocations);
            AddAspNetCoreFrameworkDlls(dllPaths, frameworkLocations);
            AddMicrosoftWindowsDesktopDlls(dllPaths, frameworkLocations);

            return frameworkLocations;
        }

        private void RestoreNugetPackages(List<FileInfo> allNonBinaryFiles, IEnumerable<string> allProjects, IEnumerable<string> allSolutions, HashSet<string> dllPaths)
        {
            try
            {
                var nuget = new NugetPackages(sourceDir.FullName, legacyPackageDirectory, progressMonitor);
                nuget.InstallPackages();

                var nugetPackageDlls = legacyPackageDirectory.DirInfo.GetFiles("*.dll", new EnumerationOptions { RecurseSubdirectories = true });
                var nugetPackageDllPaths = nugetPackageDlls.Select(f => f.FullName).ToHashSet();
                var excludedPaths = nugetPackageDllPaths
                    .Where(path => IsPathInSubfolder(path, legacyPackageDirectory.DirInfo.FullName, "tools"))
                    .ToList();

                if (nugetPackageDllPaths.Count > 0)
                {
                    progressMonitor.LogInfo($"Restored {nugetPackageDllPaths.Count} Nuget DLLs.");
                }
                if (excludedPaths.Count > 0)
                {
                    progressMonitor.LogInfo($"Excluding {excludedPaths.Count} Nuget DLLs.");
                }

                foreach (var excludedPath in excludedPaths)
                {
                    progressMonitor.LogInfo($"Excluded Nuget DLL: {excludedPath}");
                }

                nugetPackageDllPaths.ExceptWith(excludedPaths);
                dllPaths.UnionWith(nugetPackageDllPaths);
            }
            catch (Exception)
            {
                progressMonitor.LogError("Failed to restore Nuget packages with nuget.exe");
            }

            var restoredProjects = RestoreSolutions(allSolutions, out var assets1);
            var projects = allProjects.Except(restoredProjects);
            RestoreProjects(projects, out var assets2);

            var dependencies = Assets.GetCompilationDependencies(progressMonitor, assets1.Union(assets2));

            var paths = dependencies
                .Paths
                .Select(d => Path.Combine(packageDirectory.DirInfo.FullName, d))
                .ToList();
            dllPaths.UnionWith(paths);

            LogAllUnusedPackages(dependencies);
            DownloadMissingPackages(allNonBinaryFiles, dllPaths);
        }

        private static bool IsPathInSubfolder(string path, string rootFolder, string subFolder)
        {
            return path.IndexOf(
                $"{Path.DirectorySeparatorChar}{subFolder}{Path.DirectorySeparatorChar}",
                rootFolder.Length,
                StringComparison.InvariantCultureIgnoreCase) >= 0;
        }

        private void RemoveNugetAnalyzerReferences()
        {
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
                        progressMonitor.LogInfo($"Removed analyzer reference {filename}");
                    }
                }
            }
        }

        private void SelectNewestFrameworkPath(string frameworkPath, string frameworkType, ISet<string> dllPaths, ISet<string> frameworkLocations)
        {
            var versionFolders = new DirectoryInfo(frameworkPath)
                .EnumerateDirectories("*", new EnumerationOptions { MatchCasing = MatchCasing.CaseInsensitive, RecurseSubdirectories = false })
                .OrderByDescending(d => d.Name) // TODO: Improve sorting to handle pre-release versions.
                .ToArray();

            if (versionFolders.Length > 1)
            {
                var versions = string.Join(", ", versionFolders.Select(d => d.Name));
                progressMonitor.LogInfo($"Found multiple {frameworkType} DLLs in NuGet packages at {frameworkPath}. Using the latest version ({versionFolders[0].Name}) from: {versions}.");
            }

            var selectedFrameworkFolder = versionFolders.FirstOrDefault()?.FullName;
            if (selectedFrameworkFolder is null)
            {
                progressMonitor.LogInfo($"Found {frameworkType} DLLs in NuGet packages at {frameworkPath}, but no version folder was found.");
                selectedFrameworkFolder = frameworkPath;
            }

            dllPaths.Add(selectedFrameworkFolder);
            frameworkLocations.Add(selectedFrameworkFolder);
            progressMonitor.LogInfo($"Found {frameworkType} DLLs in NuGet packages at {selectedFrameworkFolder}.");
        }

        private void AddNetFrameworkDlls(ISet<string> dllPaths, ISet<string> frameworkLocations)
        {
            // Multiple dotnet framework packages could be present.
            // The order of the packages is important, we're adding the first one that is present in the nuget cache.
            var packagesInPrioOrder = FrameworkPackageNames.NetFrameworks;

            var frameworkPath = packagesInPrioOrder
                .Select((s, index) => (Index: index, Path: GetPackageDirectory(s)))
                .FirstOrDefault(pair => pair.Path is not null);

            if (frameworkPath.Path is not null)
            {
                SelectNewestFrameworkPath(frameworkPath.Path, ".NET Framework", dllPaths, frameworkLocations);

                for (var i = frameworkPath.Index + 1; i < packagesInPrioOrder.Length; i++)
                {
                    RemoveNugetPackageReference(packagesInPrioOrder[i], dllPaths);
                }

                return;
            }

            string? runtimeLocation = null;

            if (fileContent.IsNewProjectStructureUsed)
            {
                runtimeLocation = Runtime.NetCoreRuntime;
            }
            else if (fileContent.IsLegacyProjectStructureUsed)
            {
                runtimeLocation = Runtime.DesktopRuntime;
            }

            runtimeLocation ??= Runtime.ExecutingRuntime;

            progressMonitor.LogInfo($".NET runtime location selected: {runtimeLocation}");
            dllPaths.Add(runtimeLocation);
            frameworkLocations.Add(runtimeLocation);
        }

        private void RemoveNugetPackageReference(string packagePrefix, ISet<string> dllPaths)
        {
            var packageFolder = packageDirectory.DirInfo.FullName.ToLowerInvariant();
            if (packageFolder == null)
            {
                return;
            }

            var packagePathPrefix = Path.Combine(packageFolder, packagePrefix.ToLowerInvariant());
            var toRemove = dllPaths.Where(s => s.StartsWith(packagePathPrefix, StringComparison.InvariantCultureIgnoreCase));
            foreach (var path in toRemove)
            {
                dllPaths.Remove(path);
                progressMonitor.LogInfo($"Removed reference {path}");
            }
        }

        private void AddAspNetCoreFrameworkDlls(ISet<string> dllPaths, ISet<string> frameworkLocations)
        {
            if (!fileContent.IsNewProjectStructureUsed || !fileContent.UseAspNetCoreDlls)
            {
                return;
            }

            // First try to find ASP.NET Core assemblies in the NuGet packages
            if (GetPackageDirectory(FrameworkPackageNames.AspNetCoreFramework) is string aspNetCorePackage)
            {
                SelectNewestFrameworkPath(aspNetCorePackage, "ASP.NET Core", dllPaths, frameworkLocations);
                return;
            }

            if (Runtime.AspNetCoreRuntime is string aspNetCoreRuntime)
            {
                progressMonitor.LogInfo($"ASP.NET runtime location selected: {aspNetCoreRuntime}");
                dllPaths.Add(aspNetCoreRuntime);
                frameworkLocations.Add(aspNetCoreRuntime);
            }
        }

        private void AddMicrosoftWindowsDesktopDlls(ISet<string> dllPaths, ISet<string> frameworkLocations)
        {
            if (GetPackageDirectory(FrameworkPackageNames.WindowsDesktopFramework) is string windowsDesktopApp)
            {
                SelectNewestFrameworkPath(windowsDesktopApp, "Windows Desktop App", dllPaths, frameworkLocations);
            }
        }

        private string? GetPackageDirectory(string packagePrefix)
        {
            return new DirectoryInfo(packageDirectory.DirInfo.FullName)
                .EnumerateDirectories(packagePrefix + "*", new EnumerationOptions { MatchCasing = MatchCasing.CaseInsensitive, RecurseSubdirectories = false })
                .FirstOrDefault()?
                .FullName;
        }

        private ICollection<string> GetAllPackageDirectories()
        {
            return new DirectoryInfo(packageDirectory.DirInfo.FullName)
                .EnumerateDirectories("*", new EnumerationOptions { MatchCasing = MatchCasing.CaseInsensitive, RecurseSubdirectories = false })
                .Select(d => d.Name)
                .ToList();
        }

        private void LogAllUnusedPackages(DependencyContainer dependencies)
        {
            var allPackageDirectories = GetAllPackageDirectories();

            progressMonitor.LogInfo($"Restored {allPackageDirectories.Count} packages");
            progressMonitor.LogInfo($"Found {dependencies.Packages.Count} packages in project.asset.json files");

            allPackageDirectories
                .Where(package => !dependencies.Packages.Contains(package))
                .Order()
                .ForEach(package => progressMonitor.LogInfo($"Unused package: {package}"));
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

            progressMonitor.LogInfo($"Generating source file for implicit usings. Namespaces: {string.Join(", ", usings.OrderBy(u => u))}");

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
            var views = allFiles.SelectFileNamesByExtension(".cshtml", ".razor").ToArray();
            if (views.Length == 0)
            {
                return;
            }

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

        public DependencyManager(string srcDir) : this(srcDir, DependencyOptions.Default, new ConsoleLogger(Verbosity.Info, logThreadId: true)) { }

        private IEnumerable<FileInfo> GetAllFiles()
        {
            IEnumerable<FileInfo> files = sourceDir.GetFiles("*.*", new EnumerationOptions { RecurseSubdirectories = true });

            if (options.DotNetPath != null)
            {
                files = files.Where(f => !f.FullName.StartsWith(options.DotNetPath, StringComparison.OrdinalIgnoreCase));
            }

            files = files.Where(f =>
            {
                try
                {
                    if (f.Exists)
                    {
                        return true;
                    }

                    progressMonitor.Log(Severity.Warning, $"File {f.FullName} could not be processed.");
                    return false;
                }
                catch (Exception ex)
                {
                    progressMonitor.Log(Severity.Warning, $"File {f.FullName} could not be processed: {ex.Message}");
                    return false;
                }
            });

            files = new FilePathFilter(sourceDir, progressMonitor).Filter(files);
            return files;
        }

        /// <summary>
        /// Computes a unique temp directory for the packages associated
        /// with this source tree. Use a SHA1 of the directory name.
        /// </summary>
        /// <returns>The full path of the temp directory.</returns>
        private static string ComputeTempDirectory(string srcDir, string subfolderName)
        {
            var bytes = Encoding.Unicode.GetBytes(srcDir);
            var sha = SHA1.HashData(bytes);
            var sb = new StringBuilder();
            foreach (var b in sha.Take(8))
                sb.AppendFormat("{0:x2}", b);

            return Path.Combine(FileUtils.GetTemporaryWorkingDirectory(out var _), sb.ToString(), subfolderName);
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
        private void ResolveConflicts(IEnumerable<string> frameworkPaths)
        {
            var sortedReferences = new List<AssemblyInfo>(usedReferences.Count);
            foreach (var usedReference in usedReferences)
            {
                try
                {
                    var assemblyInfo = assemblyCache.GetAssemblyInfo(usedReference.Key);
                    sortedReferences.Add(assemblyInfo);
                }
                catch (AssemblyLoadException)
                {
                    progressMonitor.Log(Severity.Warning, $"Could not load assembly information from {usedReference.Key}");
                }
            }

            sortedReferences = sortedReferences
                .OrderAssemblyInfosByPreference(frameworkPaths)
                .ToList();

            progressMonitor.LogInfo($"Reference list contains {sortedReferences.Count} assemblies");

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

            progressMonitor.LogInfo($"After conflict resolution, reference list contains {finalAssemblyList.Count} assemblies");

            // Report the results
            foreach (var r in sortedReferences)
            {
                var resolvedInfo = finalAssemblyList[r.Name];
                if (resolvedInfo.Version != r.Version || resolvedInfo.NetCoreVersion != r.NetCoreVersion)
                {
                    var asm = resolvedInfo.Id + (resolvedInfo.NetCoreVersion is null ? "" : $" (.NET Core {resolvedInfo.NetCoreVersion})");
                    progressMonitor.LogInfo($"Resolved {r.Id} as {asm}");
                    ++conflictedReferences;
                }

                if (r != resolvedInfo)
                {
                    progressMonitor.LogDebug($"Resolved {r.Id} as {resolvedInfo.Id} from {resolvedInfo.Filename}");
                }
            }
        }

        /// <summary>
        /// Store that a particular reference file is used.
        /// </summary>
        /// <param name="reference">The filename of the reference.</param>
        private void UseReference(string reference) => usedReferences[reference] = true;

        /// <summary>
        /// The list of resolved reference files.
        /// </summary>
        public IEnumerable<string> ReferenceFiles => usedReferences.Keys;

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
        /// Record that a particular reference couldn't be resolved.
        /// Note that this records at most one project file per missing reference.
        /// </summary>
        /// <param name="id">The assembly ID.</param>
        /// <param name="projectFile">The project file making the reference.</param>
        private void UnresolvedReference(string id, string projectFile) => unresolvedReferences[id] = projectFile;

        private void AnalyseSolutions(IEnumerable<string> solutions)
        {
            Parallel.ForEach(solutions, new ParallelOptions { MaxDegreeOfParallelism = options.Threads }, solutionFile =>
            {
                try
                {
                    var sln = new SolutionFile(solutionFile);
                    progressMonitor.LogInfo($"Analyzing {solutionFile}...");
                    foreach (var proj in sln.Projects.Select(p => new FileInfo(p)))
                    {
                        AnalyseProject(proj);
                    }
                }
                catch (Microsoft.Build.Exceptions.InvalidProjectFileException ex)
                {
                    progressMonitor.LogInfo($"Couldn't read solution file {solutionFile}: {ex.BaseMessage}");
                }
            });
        }

        private void AnalyseProject(FileInfo project)
        {
            if (!project.Exists)
            {
                progressMonitor.LogInfo($"Couldn't read project file {project.FullName}");
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
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                progressMonitor.LogInfo($"Couldn't read project file {project.FullName}: {ex.Message}");
            }
        }

        /// <summary>
        /// Executes `dotnet restore` on all solution files in solutions.
        /// As opposed to RestoreProjects this is not run in parallel using PLINQ
        /// as `dotnet restore` on a solution already uses multiple threads for restoring
        /// the projects (this can be disabled with the `--disable-parallel` flag).
        /// Populates assets with the relative paths to the assets files generated by the restore.
        /// Returns a list of projects that are up to date with respect to restore.
        /// </summary>
        /// <param name="solutions">A list of paths to solution files.</param>
        private IEnumerable<string> RestoreSolutions(IEnumerable<string> solutions, out IEnumerable<string> assets)
        {
            var assetFiles = new List<string>();
            var projects = solutions.SelectMany(solution =>
                {
                    progressMonitor.LogInfo($"Restoring solution {solution}...");
                    var success = dotnet.RestoreSolutionToDirectory(solution, packageDirectory.DirInfo.FullName, forceDotnetRefAssemblyFetching: true, out var restoredProjects, out var a);
                    assetFiles.AddRange(a);
                    return restoredProjects;
                });
            assets = assetFiles;
            return projects;
        }

        /// <summary>
        /// Executes `dotnet restore` on all projects in projects.
        /// This is done in parallel for performance reasons.
        /// Populates assets with the relative paths to the assets files generated by the restore.
        /// </summary>
        /// <param name="projects">A list of paths to project files.</param>
        private void RestoreProjects(IEnumerable<string> projects, out IEnumerable<string> assets)
        {
            var assetFiles = new List<string>();
            Parallel.ForEach(projects, new ParallelOptions { MaxDegreeOfParallelism = options.Threads }, project =>
            {
                progressMonitor.LogInfo($"Restoring project {project}...");
                var success = dotnet.RestoreProjectToDirectory(project, packageDirectory.DirInfo.FullName, forceDotnetRefAssemblyFetching: true, out var a, out var _);
                assetFiles.AddRange(a);
            });
            assets = assetFiles;
        }

        private void DownloadMissingPackages(List<FileInfo> allFiles, ISet<string> dllPaths)
        {
            var alreadyDownloadedPackages = Directory.GetDirectories(packageDirectory.DirInfo.FullName)
                .Select(d => Path.GetFileName(d).ToLowerInvariant());
            var notYetDownloadedPackages = fileContent.AllPackages
                .Except(alreadyDownloadedPackages)
                .ToList();
            if (notYetDownloadedPackages.Count == 0)
            {
                return;
            }

            progressMonitor.LogInfo($"Found {notYetDownloadedPackages.Count} packages that are not yet restored");

            var nugetConfigs = allFiles.SelectFileNamesByName("nuget.config").ToArray();
            string? nugetConfig = null;
            if (nugetConfigs.Length > 1)
            {
                progressMonitor.LogInfo($"Found multiple nuget.config files: {string.Join(", ", nugetConfigs)}.");
                nugetConfig = allFiles
                    .SelectRootFiles(sourceDir)
                    .SelectFileNamesByName("nuget.config")
                    .FirstOrDefault();
                if (nugetConfig == null)
                {
                    progressMonitor.LogInfo("Could not find a top-level nuget.config file.");
                }
            }
            else
            {
                nugetConfig = nugetConfigs.FirstOrDefault();
            }

            if (nugetConfig != null)
            {
                progressMonitor.LogInfo($"Using nuget.config file {nugetConfig}.");
            }

            Parallel.ForEach(notYetDownloadedPackages, new ParallelOptions { MaxDegreeOfParallelism = options.Threads }, package =>
            {
                progressMonitor.LogInfo($"Restoring package {package}...");
                using var tempDir = new TemporaryDirectory(ComputeTempDirectory(package, "missingpackages_workingdir"));
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

                success = dotnet.RestoreProjectToDirectory(tempDir.DirInfo.FullName, missingPackageDirectory.DirInfo.FullName, forceDotnetRefAssemblyFetching: false, out var _, out var outputLines, pathToNugetConfig: nugetConfig);
                if (!success)
                {
                    if (outputLines?.Any(s => s.Contains("NU1301")) == true)
                    {
                        // Restore could not be completed because the listed source is unavailable. Try without the nuget.config:
                        success = dotnet.RestoreProjectToDirectory(tempDir.DirInfo.FullName, missingPackageDirectory.DirInfo.FullName, forceDotnetRefAssemblyFetching: false, out var _, out var _, pathToNugetConfig: null, force: true);
                    }

                    // TODO: the restore might fail, we could retry with a prerelease (*-* instead of *) version of the package.

                    if (!success)
                    {
                        progressMonitor.LogInfo($"Failed to restore nuget package {package}");
                    }
                }
            });

            dllPaths.Add(missingPackageDirectory.DirInfo.FullName);
        }

        public void Dispose(TemporaryDirectory? dir, string name)
        {
            try
            {
                dir?.Dispose();
            }
            catch (Exception exc)
            {
                progressMonitor.LogInfo($"Couldn't delete {name} directory {exc.Message}");
            }
        }

        public void Dispose()
        {
            Dispose(packageDirectory, "package");
            Dispose(legacyPackageDirectory, "legacy package");
            Dispose(missingPackageDirectory, "missing package");
            if (cleanupTempWorkingDirectory)
            {
                Dispose(tempWorkingDirectory, "temporary working");
            }
        }
    }
}
