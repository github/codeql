using System;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal class ProgressMonitor
    {
        private readonly ILogger logger;

        public ProgressMonitor(ILogger logger)
        {
            this.logger = logger;
        }

        public void Log(Severity severity, string message) =>
            logger.Log(severity, message);

        public void LogInfo(string message) =>
            logger.Log(Severity.Info, message);

        public void LogDebug(string message) =>
            logger.Log(Severity.Debug, message);

        private void LogError(string message) =>
            logger.Log(Severity.Error, message);

        public void FindingFiles(string dir) =>
            LogInfo($"Finding files in {dir}...");

        public void IndexingReferences(int count)
        {
            LogInfo("Indexing...");
            LogDebug($"Indexing {count} DLLs...");
        }

        public void UnresolvedReference(string id, string project)
        {
            LogInfo($"Unresolved reference {id}");
            LogDebug($"Unresolved {id} referenced by {project}");
        }

        public void AnalysingSolution(string filename) =>
            LogInfo($"Analyzing {filename}...");

        public void FailedProjectFile(string filename, string reason) =>
            LogInfo($"Couldn't read project file {filename}: {reason}");

        public void FailedNugetCommand(string exe, string args, string message)
        {
            LogInfo($"Command failed: {exe} {args}");
            LogInfo($"  {message}");
        }

        public void NugetInstall(string package) =>
            LogInfo($"Restoring {package}...");

        public void ResolvedReference(string filename) =>
            LogInfo($"Resolved reference {filename}");

        public void RemovedReference(string filename) =>
            LogInfo($"Removed reference {filename}");

        public void Summary(int existingSources, int usedSources, int missingSources,
            int references, int unresolvedReferences,
            int resolvedConflicts, int totalProjects, int failedProjects,
            TimeSpan analysisTime)
        {
            const int align = 6;
            LogInfo("");
            LogInfo("Build analysis summary:");
            LogInfo($"{existingSources,align} source files in the filesystem");
            LogInfo($"{usedSources,align} source files in project files");
            LogInfo($"{missingSources,align} sources missing from project files");
            LogInfo($"{references,align} resolved references");
            LogInfo($"{unresolvedReferences,align} unresolved references");
            LogInfo($"{resolvedConflicts,align} resolved assembly conflicts");
            LogInfo($"{totalProjects,align} projects");
            LogInfo($"{failedProjects,align} missing/failed projects");
            LogInfo($"Build analysis completed in {analysisTime}");
        }

        public void ResolvedConflict(string asm1, string asm2) =>
            LogDebug($"Resolved {asm1} as {asm2}");

        public void MissingProject(string projectFile) =>
            LogInfo($"Solution is missing {projectFile}");

        public void CommandFailed(string exe, string arguments, int exitCode) =>
            LogError($"Command {exe} {arguments} failed with exit code {exitCode}");

        public void MissingNuGet() =>
            LogError("Missing nuget.exe");

        public void FoundNuGet(string path) =>
            LogInfo($"Found nuget.exe at {path}");

        public void MissingDotNet() =>
            LogError("Missing dotnet CLI");

        public void RunningProcess(string command) =>
            LogInfo($"Running {command}");

        public void FailedToRestoreNugetPackage(string package) =>
            LogInfo($"Failed to restore nuget package {package}");

        public void FailedToReadFile(string file, Exception ex)
        {
            LogInfo($"Failed to read file {file}");
            LogDebug($"Failed to read file {file}, exception: {ex}");
        }

        public void MultipleNugetConfig(string[] nugetConfigs) =>
            LogInfo($"Found multiple nuget.config files: {string.Join(", ", nugetConfigs)}.");

        internal void NoTopLevelNugetConfig() =>
            LogInfo("Could not find a top-level nuget.config file.");

        internal void RazorSourceGeneratorMissing(string fullPath) =>
            LogInfo($"Razor source generator folder {fullPath} does not exist.");

        internal void CscMissing(string cscPath) =>
            LogInfo($"Csc.exe not found at {cscPath}.");

        internal void RazorCscArgs(string args) =>
            LogInfo($"Running CSC to generate Razor source files. Args: {args}.");
    }
}
