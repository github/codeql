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
    public sealed partial class DependencyManager : IDisposable
    {
        private readonly AssemblyCache assemblyCache;
        private readonly ILogger logger;
        private readonly IDiagnosticsWriter diagnosticsWriter;

        // Only used as a set, but ConcurrentDictionary is the only concurrent set in .NET.
        private readonly IDictionary<string, bool> usedReferences = new ConcurrentDictionary<string, bool>();
        private readonly IDictionary<string, string> unresolvedReferences = new ConcurrentDictionary<string, string>();
        private readonly List<string> nonGeneratedSources;
        private readonly List<string> generatedSources;
        private int dotnetFrameworkVersionVariantCount = 0;
        private int conflictedReferences = 0;
        private readonly DirectoryInfo sourceDir;
        private string? dotnetPath;
        private readonly IDotNet dotnet;
        private readonly FileContent fileContent;
        private readonly TemporaryDirectory packageDirectory;
        private readonly TemporaryDirectory legacyPackageDirectory;
        private readonly TemporaryDirectory missingPackageDirectory;
        private readonly TemporaryDirectory tempWorkingDirectory;
        private readonly bool cleanupTempWorkingDirectory;

        private readonly Lazy<Runtime> runtimeLazy;
        private Runtime Runtime => runtimeLazy.Value;
        private readonly int threads = EnvironmentVariables.GetDefaultNumberOfThreads();

        /// <summary>
        /// Performs C# dependency fetching.
        /// </summary>
        /// <param name="srcDir">Path to directory containing source code.</param>
        /// <param name="logger">Logger for dependency fetching progress.</param>
        public DependencyManager(string srcDir, ILogger logger)
        {
            var startTime = DateTime.Now;

            this.logger = logger;

            var diagDirEnv = Environment.GetEnvironmentVariable(EnvironmentVariableNames.DiagnosticDir);
            if (!string.IsNullOrWhiteSpace(diagDirEnv) &&
                !Directory.Exists(diagDirEnv))
            {
                try
                {
                    Directory.CreateDirectory(diagDirEnv);
                }
                catch (Exception e)
                {
                    logger.LogError($"Failed to create diagnostic directory {diagDirEnv}: {e.Message}");
                    diagDirEnv = null;
                }
            }

            this.diagnosticsWriter = new DiagnosticsStream(Path.Combine(
                diagDirEnv ?? "",
                $"dependency-manager-{DateTime.UtcNow:yyyyMMddHHmm}-{Environment.ProcessId}.jsonc"));
            this.sourceDir = new DirectoryInfo(srcDir);

            packageDirectory = new TemporaryDirectory(ComputeTempDirectory(sourceDir.FullName, "packages"));
            legacyPackageDirectory = new TemporaryDirectory(ComputeTempDirectory(sourceDir.FullName, "legacypackages"));
            missingPackageDirectory = new TemporaryDirectory(ComputeTempDirectory(sourceDir.FullName, "missingpackages"));

            tempWorkingDirectory = new TemporaryDirectory(FileUtils.GetTemporaryWorkingDirectory(out cleanupTempWorkingDirectory));

            logger.LogInfo($"Finding files in {srcDir}...");

            var allFiles = GetAllFiles().ToList();
            var binaryFileExtensions = new HashSet<string>(new[] { ".dll", ".exe" }); // TODO: add more binary file extensions.
            var allNonBinaryFiles = allFiles.Where(f => !binaryFileExtensions.Contains(f.Extension.ToLowerInvariant())).ToList();
            var smallNonBinaryFiles = allNonBinaryFiles.SelectSmallFiles(logger).SelectFileNames().ToList();
            this.fileContent = new FileContent(logger, smallNonBinaryFiles);
            this.nonGeneratedSources = allNonBinaryFiles.SelectFileNamesByExtension(".cs").ToList();
            this.generatedSources = new();
            var allProjects = allNonBinaryFiles.SelectFileNamesByExtension(".csproj").ToList();
            var allSolutions = allNonBinaryFiles.SelectFileNamesByExtension(".sln").ToList();
            var dllLocations = allFiles.SelectFileNamesByExtension(".dll").Select(x => new AssemblyLookupLocation(x)).ToHashSet();

            logger.LogInfo($"Found {allFiles.Count} files, {nonGeneratedSources.Count} source files, {allProjects.Count} project files, {allSolutions.Count} solution files, {dllLocations.Count} DLLs.");

            void startCallback(string s, bool silent)
            {
                logger.Log(silent ? Severity.Debug : Severity.Info, $"\nRunning {s}");
            }

            void exitCallback(int ret, string msg, bool silent)
            {
                logger.Log(silent ? Severity.Debug : Severity.Info, $"Exit code {ret}{(string.IsNullOrEmpty(msg) ? "" : $": {msg}")}");
            }

            DotNet.WithDotNet(SystemBuildActions.Instance, logger, smallNonBinaryFiles, tempWorkingDirectory.ToString(), shouldCleanUp: false, ensureDotNetAvailable: true, version: null, installDir =>
            {
                this.dotnetPath = installDir;
                return BuildScript.Success;
            }).Run(SystemBuildActions.Instance, startCallback, exitCallback);

            try
            {
                this.dotnet = DotNet.Make(logger, dotnetPath, tempWorkingDirectory);
                runtimeLazy = new Lazy<Runtime>(() => new Runtime(dotnet));
            }
            catch
            {
                logger.LogError("Missing dotnet CLI");
                throw;
            }

            RestoreNugetPackages(allNonBinaryFiles, allProjects, allSolutions, dllLocations);
            // Find DLLs in the .Net / Asp.Net Framework
            // This needs to come after the nuget restore, because the nuget restore might fetch the .NET Core/Framework reference assemblies.
            var frameworkLocations = AddFrameworkDlls(dllLocations);

            assemblyCache = new AssemblyCache(dllLocations, frameworkLocations, logger);
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
                logger.LogInfo($"Resolved reference {r}");
            }

            foreach (var r in unresolvedReferences.OrderBy(r => r.Key))
            {
                logger.LogInfo($"Unresolved reference {r.Key} in project {r.Value}");
            }

            var webViewExtractionOption = Environment.GetEnvironmentVariable(EnvironmentVariableNames.WebViewGeneration);
            if (webViewExtractionOption == null ||
                bool.TryParse(webViewExtractionOption, out var shouldExtractWebViews) &&
                shouldExtractWebViews)
            {
                CompilationInfos.Add(("WebView extraction enabled", "1"));
                GenerateSourceFilesFromWebViews(allNonBinaryFiles);
            }
            else
            {
                CompilationInfos.Add(("WebView extraction enabled", "0"));
            }

            CompilationInfos.Add(("UseWPF set", fileContent.UseWpf ? "1" : "0"));
            CompilationInfos.Add(("UseWindowsForms set", fileContent.UseWindowsForms ? "1" : "0"));

            GenerateSourceFileFromImplicitUsings();

            const int align = 6;
            logger.LogInfo("");
            logger.LogInfo("Build analysis summary:");
            logger.LogInfo($"{nonGeneratedSources.Count,align} source files found on the filesystem");
            logger.LogInfo($"{generatedSources.Count,align} source files have been generated");
            logger.LogInfo($"{allSolutions.Count,align} solution files found on the filesystem");
            logger.LogInfo($"{allProjects.Count,align} project files found on the filesystem");
            logger.LogInfo($"{usedReferences.Keys.Count,align} resolved references");
            logger.LogInfo($"{unresolvedReferences.Count,align} unresolved references");
            logger.LogInfo($"{conflictedReferences,align} resolved assembly conflicts");
            logger.LogInfo($"{dotnetFrameworkVersionVariantCount,align} restored .NET framework variants");
            logger.LogInfo($"Build analysis completed in {DateTime.Now - startTime}");

            CompilationInfos.AddRange([
                ("Source files on filesystem", nonGeneratedSources.Count.ToString()),
                ("Source files generated", generatedSources.Count.ToString()),
                ("Solution files on filesystem", allSolutions.Count.ToString()),
                ("Project files on filesystem", allProjects.Count.ToString()),
                ("Resolved references", usedReferences.Keys.Count.ToString()),
                ("Unresolved references", unresolvedReferences.Count.ToString()),
                ("Resolved assembly conflicts", conflictedReferences.ToString()),
                ("Restored .NET framework variants", dotnetFrameworkVersionVariantCount.ToString()),
            ]);
        }

        private HashSet<string> AddFrameworkDlls(HashSet<AssemblyLookupLocation> dllLocations)
        {
            var frameworkLocations = new HashSet<string>();

            var frameworkReferences = Environment.GetEnvironmentVariable(EnvironmentVariableNames.DotnetFrameworkReferences);
            var useSubfolders = EnvironmentVariables.GetBoolean(EnvironmentVariableNames.DotnetFrameworkReferencesUseSubfolders);
            if (!string.IsNullOrWhiteSpace(frameworkReferences))
            {
                RemoveFrameworkNugetPackages(dllLocations);
                RemoveNugetPackageReference(FrameworkPackageNames.AspNetCoreFramework, dllLocations);
                RemoveNugetPackageReference(FrameworkPackageNames.WindowsDesktopFramework, dllLocations);

                var frameworkPaths = frameworkReferences.Split(Path.PathSeparator, StringSplitOptions.RemoveEmptyEntries);

                foreach (var path in frameworkPaths)
                {
                    if (!Directory.Exists(path))
                    {
                        logger.LogError($"Specified framework reference path '{path}' does not exist.");
                        continue;
                    }

                    dllLocations.Add(new AssemblyLookupLocation(path, _ => true, useSubfolders));
                    frameworkLocations.Add(path);
                }

                return frameworkLocations;
            }

            AddNetFrameworkDlls(dllLocations, frameworkLocations);
            AddAspNetCoreFrameworkDlls(dllLocations, frameworkLocations);
            AddMicrosoftWindowsDesktopDlls(dllLocations, frameworkLocations);

            return frameworkLocations;
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
                        logger.LogInfo($"Removed analyzer reference {filename}");
                    }
                }
            }
        }

        private void SelectNewestFrameworkPath(string frameworkPath, string frameworkType, ISet<AssemblyLookupLocation> dllLocations, ISet<string> frameworkLocations)
        {
            var versionFolders = GetPackageVersionSubDirectories(frameworkPath);
            if (versionFolders.Length > 1)
            {
                var versions = string.Join(", ", versionFolders.Select(d => d.Name));
                logger.LogInfo($"Found multiple {frameworkType} DLLs in NuGet packages at {frameworkPath}. Using the latest version ({versionFolders[0].Name}) from: {versions}.");
            }

            var selectedFrameworkFolder = versionFolders.FirstOrDefault()?.FullName;
            if (selectedFrameworkFolder is null)
            {
                logger.LogInfo($"Found {frameworkType} DLLs in NuGet packages at {frameworkPath}, but no version folder was found.");
                selectedFrameworkFolder = frameworkPath;
            }

            dllLocations.Add(selectedFrameworkFolder);
            frameworkLocations.Add(selectedFrameworkFolder);
            logger.LogInfo($"Found {frameworkType} DLLs in NuGet packages at {selectedFrameworkFolder}.");
        }

        private static DirectoryInfo[] GetPackageVersionSubDirectories(string packagePath)
        {
            return new DirectoryInfo(packagePath)
                .EnumerateDirectories("*", new EnumerationOptions { MatchCasing = MatchCasing.CaseInsensitive, RecurseSubdirectories = false })
                .OrderByDescending(d => d.Name) // TODO: Improve sorting to handle pre-release versions.
                .ToArray();
        }

        private void RemoveFrameworkNugetPackages(ISet<AssemblyLookupLocation> dllLocations, int fromIndex = 0)
        {
            var packagesInPrioOrder = FrameworkPackageNames.NetFrameworks;
            for (var i = fromIndex; i < packagesInPrioOrder.Length; i++)
            {
                RemoveNugetPackageReference(packagesInPrioOrder[i], dllLocations);
            }
        }

        private void AddNetFrameworkDlls(ISet<AssemblyLookupLocation> dllLocations, ISet<string> frameworkLocations)
        {
            // Multiple dotnet framework packages could be present.
            // The order of the packages is important, we're adding the first one that is present in the nuget cache.
            var packagesInPrioOrder = FrameworkPackageNames.NetFrameworks;

            var frameworkPaths = packagesInPrioOrder
                .Select((s, index) => (Index: index, Path: GetPackageDirectory(s, packageDirectory)))
                .Where(pair => pair.Path is not null)
                .ToArray();

            var frameworkPath = frameworkPaths.FirstOrDefault();

            if (frameworkPath.Path is not null)
            {
                foreach (var fp in frameworkPaths)
                {
                    dotnetFrameworkVersionVariantCount += GetPackageVersionSubDirectories(fp.Path!).Length;
                }

                SelectNewestFrameworkPath(frameworkPath.Path, ".NET Framework", dllLocations, frameworkLocations);
                RemoveFrameworkNugetPackages(dllLocations, frameworkPath.Index + 1);
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

                if (runtimeLocation is null)
                {
                    logger.LogInfo("No .NET Desktop Runtime location found. Attempting to restore the .NET Framework reference assemblies manually.");

                    if (TryRestorePackageManually(FrameworkPackageNames.LatestNetFrameworkReferenceAssemblies, null))
                    {
                        runtimeLocation = GetPackageDirectory(FrameworkPackageNames.LatestNetFrameworkReferenceAssemblies, missingPackageDirectory);
                    }
                }
            }

            if (runtimeLocation is null)
            {
                runtimeLocation ??= Runtime.ExecutingRuntime;
                dllLocations.Add(new AssemblyLookupLocation(runtimeLocation, name => !name.StartsWith("Semmle.")));
            }
            else
            {
                dllLocations.Add(runtimeLocation);
            }

            logger.LogInfo($".NET runtime location selected: {runtimeLocation}");
            frameworkLocations.Add(runtimeLocation);
        }

        private void RemoveNugetPackageReference(string packagePrefix, ISet<AssemblyLookupLocation> dllLocations)
        {
            var packageFolder = packageDirectory.DirInfo.FullName.ToLowerInvariant();
            if (packageFolder == null)
            {
                return;
            }

            var packagePathPrefix = Path.Combine(packageFolder, packagePrefix.ToLowerInvariant());
            var toRemove = dllLocations.Where(s => s.Path.StartsWith(packagePathPrefix, StringComparison.InvariantCultureIgnoreCase));
            foreach (var path in toRemove)
            {
                dllLocations.Remove(path);
                logger.LogInfo($"Removed reference {path}");
            }
        }

        private bool IsAspNetCoreDetected()
        {
            return fileContent.IsNewProjectStructureUsed && fileContent.UseAspNetCoreDlls;
        }

        private void AddAspNetCoreFrameworkDlls(ISet<AssemblyLookupLocation> dllLocations, ISet<string> frameworkLocations)
        {
            if (!IsAspNetCoreDetected())
            {
                return;
            }

            // First try to find ASP.NET Core assemblies in the NuGet packages
            if (GetPackageDirectory(FrameworkPackageNames.AspNetCoreFramework, packageDirectory) is string aspNetCorePackage)
            {
                SelectNewestFrameworkPath(aspNetCorePackage, "ASP.NET Core", dllLocations, frameworkLocations);
                return;
            }

            if (Runtime.AspNetCoreRuntime is string aspNetCoreRuntime)
            {
                logger.LogInfo($"ASP.NET runtime location selected: {aspNetCoreRuntime}");
                dllLocations.Add(aspNetCoreRuntime);
                frameworkLocations.Add(aspNetCoreRuntime);
            }
        }

        private void AddMicrosoftWindowsDesktopDlls(ISet<AssemblyLookupLocation> dllLocations, ISet<string> frameworkLocations)
        {
            if (GetPackageDirectory(FrameworkPackageNames.WindowsDesktopFramework, packageDirectory) is string windowsDesktopApp)
            {
                SelectNewestFrameworkPath(windowsDesktopApp, "Windows Desktop App", dllLocations, frameworkLocations);
            }
        }

        private string? GetPackageDirectory(string packagePrefix, TemporaryDirectory root)
        {
            return new DirectoryInfo(root.DirInfo.FullName)
                .EnumerateDirectories(packagePrefix + "*", new EnumerationOptions { MatchCasing = MatchCasing.CaseInsensitive, RecurseSubdirectories = false })
                .FirstOrDefault()?
                .FullName;
        }

        private void GenerateSourceFileFromImplicitUsings()
        {
            var usings = new HashSet<string>();
            if (!fileContent.UseImplicitUsings)
            {
                return;
            }

            // Hardcoded values from https://learn.microsoft.com/en-us/dotnet/core/project-sdk/overview#implicit-using-directives
            usings.UnionWith([ "System", "System.Collections.Generic", "System.IO", "System.Linq", "System.Net.Http", "System.Threading",
                "System.Threading.Tasks" ]);

            if (fileContent.UseAspNetCoreDlls)
            {
                usings.UnionWith([ "System.Net.Http.Json", "Microsoft.AspNetCore.Builder", "Microsoft.AspNetCore.Hosting",
                    "Microsoft.AspNetCore.Http", "Microsoft.AspNetCore.Routing", "Microsoft.Extensions.Configuration",
                    "Microsoft.Extensions.DependencyInjection", "Microsoft.Extensions.Hosting", "Microsoft.Extensions.Logging" ]);
            }

            if (fileContent.UseWindowsForms)
            {
                usings.UnionWith(["System.Drawing", "System.Windows.Forms"]);
            }

            usings.UnionWith(fileContent.CustomImplicitUsings);

            logger.LogInfo($"Generating source file for implicit usings. Namespaces: {string.Join(", ", usings.OrderBy(u => u))}");

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

            logger.LogInfo($"Found {views.Length} cshtml and razor files.");

            if (!IsAspNetCoreDetected())
            {
                logger.LogInfo("Generating source files from cshtml files is only supported for new (SDK-style) project files");
                return;
            }

            logger.LogInfo("Generating source files from cshtml and razor files...");

            var sdk = new Sdk(dotnet).GetNewestSdk();
            if (sdk != null)
            {
                try
                {
                    var razor = new Razor(sdk, dotnet, logger);
                    var targetDir = GetTemporaryWorkingDirectory("razor");
                    var generatedFiles = razor.GenerateFiles(views, usedReferences.Keys, targetDir);
                    this.generatedSources.AddRange(generatedFiles);
                }
                catch (Exception ex)
                {
                    // It's okay, we tried our best to generate source files from cshtml files.
                    logger.LogInfo($"Failed to generate source files from cshtml files: {ex.Message}");
                }
            }
        }

        private IEnumerable<FileInfo> GetAllFiles()
        {
            IEnumerable<FileInfo> files = sourceDir.GetFiles("*.*", new EnumerationOptions { RecurseSubdirectories = true });

            if (dotnetPath != null)
            {
                files = files.Where(f => !f.FullName.StartsWith(dotnetPath, StringComparison.OrdinalIgnoreCase));
            }

            files = files.Where(f =>
            {
                try
                {
                    if (f.Exists)
                    {
                        return true;
                    }

                    logger.LogWarning($"File {f.FullName} could not be processed.");
                    return false;
                }
                catch (Exception ex)
                {
                    logger.LogWarning($"File {f.FullName} could not be processed: {ex.Message}");
                    return false;
                }
            });

            files = new FilePathFilter(sourceDir, logger).Filter(files);
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
                    logger.LogWarning($"Could not load assembly information from {usedReference.Key}");
                }
            }

            sortedReferences = sortedReferences
                .OrderAssemblyInfosByPreference(frameworkPaths)
                .ToList();

            logger.LogInfo($"Reference list contains {sortedReferences.Count} assemblies");

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

            logger.LogInfo($"After conflict resolution, reference list contains {finalAssemblyList.Count} assemblies");

            // Report the results
            foreach (var r in sortedReferences)
            {
                var resolvedInfo = finalAssemblyList[r.Name];
                if (resolvedInfo.Version != r.Version || resolvedInfo.NetCoreVersion != r.NetCoreVersion)
                {
                    var asm = resolvedInfo.Id + (resolvedInfo.NetCoreVersion is null ? "" : $" (.NET Core {resolvedInfo.NetCoreVersion})");
                    logger.LogInfo($"Resolved {r.Id} as {asm}");

                    ++conflictedReferences;
                }

                if (r != resolvedInfo)
                {
                    logger.LogDebug($"Resolved {r.Id} as {resolvedInfo.Id} from {resolvedInfo.Filename}");
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
        /// All of the non-generated source files in the source directory.
        /// </summary>
        public IEnumerable<string> NonGeneratedSourcesFiles => nonGeneratedSources;

        /// <summary>
        /// All of the source files in the source directory.
        /// </summary>
        public IEnumerable<string> AllSourceFiles => generatedSources.Concat(nonGeneratedSources);

        /// <summary>
        /// List of assembly IDs which couldn't be resolved.
        /// </summary>
        public IEnumerable<string> UnresolvedReferences => unresolvedReferences.Select(r => r.Key);

        /// <summary>
        /// List of `(key, value)` tuples, that are stored in the DB for telemetry purposes.
        /// </summary>
        public List<(string, string)> CompilationInfos { get; } = new List<(string, string)>();

        /// <summary>
        /// Record that a particular reference couldn't be resolved.
        /// Note that this records at most one project file per missing reference.
        /// </summary>
        /// <param name="id">The assembly ID.</param>
        /// <param name="projectFile">The project file making the reference.</param>
        private void UnresolvedReference(string id, string projectFile) => unresolvedReferences[id] = projectFile;

        private void AnalyseSolutions(IEnumerable<string> solutions)
        {
            Parallel.ForEach(solutions, new ParallelOptions { MaxDegreeOfParallelism = threads }, solutionFile =>
            {
                try
                {
                    var sln = new SolutionFile(solutionFile);
                    logger.LogInfo($"Analyzing {solutionFile}...");
                    foreach (var proj in sln.Projects.Select(p => new FileInfo(p)))
                    {
                        AnalyseProject(proj);
                    }
                }
                catch (Microsoft.Build.Exceptions.InvalidProjectFileException ex)
                {
                    logger.LogInfo($"Couldn't read solution file {solutionFile}: {ex.BaseMessage}");
                }
            });
        }

        private void AnalyseProject(FileInfo project)
        {
            if (!project.Exists)
            {
                logger.LogInfo($"Couldn't read project file {project.FullName}");
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
                logger.LogInfo($"Couldn't read project file {project.FullName}: {ex.Message}");
            }
        }

        public void Dispose(TemporaryDirectory? dir, string name)
        {
            try
            {
                dir?.Dispose();
            }
            catch (Exception exc)
            {
                logger.LogInfo($"Couldn't delete {name} directory {exc.Message}");
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

            diagnosticsWriter?.Dispose();
        }
    }
}
