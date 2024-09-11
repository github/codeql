using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public interface ICompilationInfoContainer
    {
        /// <summary>
        /// List of `(key, value)` tuples, that are stored in the DB for telemetry purposes.
        /// </summary>
        List<(string, string)> CompilationInfos { get; }
    }

    /// <summary>
    /// Main implementation of the build analysis.
    /// </summary>
    public sealed partial class DependencyManager : IDisposable, ICompilationInfoContainer
    {
        private readonly AssemblyCache assemblyCache;
        private readonly ILogger logger;
        private readonly IDiagnosticsWriter diagnosticsWriter;
        private readonly NugetPackageRestorer nugetPackageRestorer;
        private readonly IDotNet dotnet;
        private readonly FileContent fileContent;
        private readonly FileProvider fileProvider;

        // Only used as a set, but ConcurrentDictionary is the only concurrent set in .NET.
        private readonly IDictionary<string, bool> usedReferences = new ConcurrentDictionary<string, bool>();
        private readonly IDictionary<string, string> unresolvedReferences = new ConcurrentDictionary<string, string>();
        private readonly List<string> nonGeneratedSources;
        private readonly List<string> generatedSources;
        private int dotnetFrameworkVersionVariantCount = 0;
        private int conflictedReferences = 0;
        private readonly DirectoryInfo sourceDir;
        private string? dotnetPath;

        private readonly TemporaryDirectory tempWorkingDirectory;
        private readonly bool cleanupTempWorkingDirectory;

        private readonly Lazy<Runtime> runtimeLazy;
        private Runtime Runtime => runtimeLazy.Value;

        internal static readonly int Threads = EnvironmentVariables.GetDefaultNumberOfThreads();

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

            tempWorkingDirectory = new TemporaryDirectory(
                FileUtils.GetTemporaryWorkingDirectory(out cleanupTempWorkingDirectory),
                "temporary working",
                logger);

            this.fileProvider = new FileProvider(sourceDir, logger);
            this.fileContent = new FileContent(logger, this.fileProvider.SmallNonBinary);
            this.nonGeneratedSources = fileProvider.Sources.ToList();
            this.generatedSources = [];

            void startCallback(string s, bool silent)
            {
                logger.Log(silent ? Severity.Debug : Severity.Info, $"\nRunning {s}");
            }

            void exitCallback(int ret, string msg, bool silent)
            {
                logger.Log(silent ? Severity.Debug : Severity.Info, $"Exit code {ret}{(string.IsNullOrEmpty(msg) ? "" : $": {msg}")}");
            }

            DotNet.WithDotNet(SystemBuildActions.Instance, logger, fileProvider.GlobalJsons, tempWorkingDirectory.ToString(), shouldCleanUp: false, ensureDotNetAvailable: true, version: null, installDir =>
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

            nugetPackageRestorer = new NugetPackageRestorer(fileProvider, fileContent, dotnet, diagnosticsWriter, logger, this);

            var dllLocations = fileProvider.Dlls.Select(x => new AssemblyLookupLocation(x)).ToHashSet();
            dllLocations.UnionWith(nugetPackageRestorer.Restore());
            // Find DLLs in the .Net / Asp.Net Framework
            // This needs to come after the nuget restore, because the nuget restore might fetch the .NET Core/Framework reference assemblies.
            var frameworkLocations = AddFrameworkDlls(dllLocations);

            assemblyCache = new AssemblyCache(dllLocations, frameworkLocations, logger);
            AnalyseSolutions(fileProvider.Solutions);

            foreach (var filename in assemblyCache.AllAssemblies.Select(a => a.Filename))
            {
                UseReference(filename);
            }

            RemoveNugetAnalyzerReferences();
            ResolveConflicts(frameworkLocations);

            // Output the findings
            foreach (var r in usedReferences.Keys.OrderBy(r => r))
            {
                logger.LogDebug($"Resolved reference {r}");
            }

            foreach (var r in unresolvedReferences.OrderBy(r => r.Key))
            {
                logger.LogDebug($"Unresolved reference {r.Key} in project {r.Value}");
            }

            var sourceGenerators = new ISourceGenerator[]
            {
                new ImplicitUsingsGenerator(fileContent, logger, tempWorkingDirectory),
                new RazorGenerator(fileProvider, fileContent, dotnet, this, logger, tempWorkingDirectory, usedReferences.Keys),
                new ResxGenerator(fileProvider, fileContent, dotnet, this, logger, nugetPackageRestorer, tempWorkingDirectory, usedReferences.Keys),
            };

            foreach (var sourceGenerator in sourceGenerators)
            {
                this.generatedSources.AddRange(sourceGenerator.Generate());
            }

            CompilationInfos.Add(("UseWPF set", fileContent.UseWpf ? "1" : "0"));
            CompilationInfos.Add(("UseWindowsForms set", fileContent.UseWindowsForms ? "1" : "0"));

            const int align = 6;
            logger.LogInfo("");
            logger.LogInfo("Build analysis summary:");
            logger.LogInfo($"{nonGeneratedSources.Count,align} source files found on the filesystem");
            logger.LogInfo($"{generatedSources.Count,align} source files have been generated");
            logger.LogInfo($"{fileProvider.Solutions.Count,align} solution files found on the filesystem");
            logger.LogInfo($"{fileProvider.Projects.Count,align} project files found on the filesystem");
            logger.LogInfo($"{usedReferences.Keys.Count,align} resolved references");
            logger.LogInfo($"{unresolvedReferences.Count,align} unresolved references");
            logger.LogInfo($"{conflictedReferences,align} resolved assembly conflicts");
            logger.LogInfo($"{dotnetFrameworkVersionVariantCount,align} restored .NET framework variants");
            logger.LogInfo($"Build analysis completed in {DateTime.Now - startTime}");

            CompilationInfos.AddRange([
                ("Source files on filesystem", nonGeneratedSources.Count.ToString()),
                ("Source files generated", generatedSources.Count.ToString()),
                ("Solution files on filesystem", fileProvider.Solutions.Count.ToString()),
                ("Project files on filesystem", fileProvider.Projects.Count.ToString()),
                ("Resolved references", usedReferences.Keys.Count.ToString()),
                ("Unresolved references", unresolvedReferences.Count.ToString()),
                ("Resolved assembly conflicts", conflictedReferences.ToString()),
                ("Restored .NET framework variants", dotnetFrameworkVersionVariantCount.ToString()),
            ]);
        }

        private HashSet<string> AddFrameworkDlls(HashSet<AssemblyLookupLocation> dllLocations)
        {
            logger.LogInfo("Adding .NET Framework DLLs");
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
            var packageFolder = nugetPackageRestorer.PackageDirectory.DirInfo.FullName.ToLowerInvariant();

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
                        logger.LogDebug($"Removed analyzer reference {filename}");
                    }
                }
            }
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
                .Select((s, index) => (Index: index, Path: GetPackageDirectory(s)))
                .Where(pair => pair.Path is not null)
                .ToArray();

            var frameworkPath = frameworkPaths.FirstOrDefault();

            if (frameworkPath.Path is not null)
            {
                foreach (var fp in frameworkPaths)
                {
                    dotnetFrameworkVersionVariantCount += NugetPackageRestorer.GetOrderedPackageVersionSubDirectories(fp.Path!).Length;
                }

                var folder = nugetPackageRestorer.GetNewestNugetPackageVersionFolder(frameworkPath.Path, ".NET Framework");
                dllLocations.Add(folder);
                frameworkLocations.Add(folder);
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
                    runtimeLocation = nugetPackageRestorer.TryRestore(FrameworkPackageNames.LatestNetFrameworkReferenceAssemblies);
                }
            }

            if (runtimeLocation is null)
            {
                runtimeLocation = Runtime.ExecutingRuntime;
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
            var packageFolder = nugetPackageRestorer.PackageDirectory.DirInfo.FullName.ToLowerInvariant();
            var packagePathPrefix = Path.Combine(packageFolder, packagePrefix.ToLowerInvariant());
            var toRemove = dllLocations.Where(s => s.Path.StartsWith(packagePathPrefix, StringComparison.InvariantCultureIgnoreCase));
            foreach (var path in toRemove)
            {
                dllLocations.Remove(path);
                logger.LogDebug($"Removed reference {path}");
            }
        }

        private void AddAspNetCoreFrameworkDlls(ISet<AssemblyLookupLocation> dllLocations, ISet<string> frameworkLocations)
        {
            if (!fileContent.IsAspNetCoreDetected)
            {
                return;
            }

            // First try to find ASP.NET Core assemblies in the NuGet packages
            if (GetPackageDirectory(FrameworkPackageNames.AspNetCoreFramework) is string aspNetCorePackage)
            {
                var folder = nugetPackageRestorer.GetNewestNugetPackageVersionFolder(aspNetCorePackage, "ASP.NET Core");
                dllLocations.Add(folder);
                frameworkLocations.Add(folder);
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
            if (GetPackageDirectory(FrameworkPackageNames.WindowsDesktopFramework) is string windowsDesktopApp)
            {
                var folder = nugetPackageRestorer.GetNewestNugetPackageVersionFolder(windowsDesktopApp, "Windows Desktop App");
                dllLocations.Add(folder);
                frameworkLocations.Add(folder);
            }
        }

        private string? GetPackageDirectory(string packagePrefix)
        {
            return GetPackageDirectory(packagePrefix, nugetPackageRestorer.PackageDirectory.DirInfo);
        }

        internal static string? GetPackageDirectory(string packagePrefix, DirectoryInfo root)
        {
            return new DirectoryInfo(root.FullName)
                .EnumerateDirectories(packagePrefix + "*", new EnumerationOptions { MatchCasing = MatchCasing.CaseInsensitive, RecurseSubdirectories = false })
                .FirstOrDefault()?
                .FullName;
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
                    logger.LogDebug($"Resolved {r.Id} as {asm}");

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
            Parallel.ForEach(solutions, new ParallelOptions { MaxDegreeOfParallelism = Threads }, solutionFile =>
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

        public void Dispose()
        {
            nugetPackageRestorer?.Dispose();
            if (cleanupTempWorkingDirectory)
            {
                tempWorkingDirectory?.Dispose();
            }
            diagnosticsWriter?.Dispose();
        }
    }
}
