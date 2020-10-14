using Semmle.Util.Logging;
using System;

namespace Semmle.BuildAnalyser
{
    /// <summary>
    /// Callback for various events that may happen during the build analysis.
    /// </summary>
    internal interface IProgressMonitor
    {
        void FindingFiles(string dir);
        void UnresolvedReference(string id, string project);
        void AnalysingSolution(string filename);
        void FailedProjectFile(string filename, string reason);
        void FailedNugetCommand(string exe, string args, string message);
        void NugetInstall(string package);
        void ResolvedReference(string filename);
        void Summary(int existingSources, int usedSources, int missingSources, int references, int unresolvedReferences, int resolvedConflicts, int totalProjects, int failedProjects, TimeSpan analysisTime);
        void Log(Severity severity, string message);
        void ResolvedConflict(string asm1, string asm2);
        void MissingProject(string projectFile);
        void CommandFailed(string exe, string arguments, int exitCode);
        void MissingNuGet();
    }

    internal class ProgressMonitor : IProgressMonitor
    {
        private readonly ILogger logger;

        public ProgressMonitor(ILogger logger)
        {
            this.logger = logger;
        }

        public void FindingFiles(string dir)
        {
            logger.Log(Severity.Info, "Finding files in {0}...", dir);
        }

        public void IndexingReferences(int count)
        {
            logger.Log(Severity.Info, "Indexing...");
            logger.Log(Severity.Debug, "Indexing {0} DLLs...", count);
        }

        public void UnresolvedReference(string id, string project)
        {
            logger.Log(Severity.Info, "Unresolved reference {0}", id);
            logger.Log(Severity.Debug, "Unresolved {0} referenced by {1}", id, project);
        }

        public void AnalysingSolution(string filename)
        {
            logger.Log(Severity.Info, $"Analyzing {filename}...");
        }

        public void FailedProjectFile(string filename, string reason)
        {
            logger.Log(Severity.Info, "Couldn't read project file {0}: {1}", filename, reason);
        }

        public void FailedNugetCommand(string exe, string args, string message)
        {
            logger.Log(Severity.Info, "Command failed: {0} {1}", exe, args);
            logger.Log(Severity.Info, "  {0}", message);
        }

        public void NugetInstall(string package)
        {
            logger.Log(Severity.Info, "Restoring {0}...", package);
        }

        public void ResolvedReference(string filename)
        {
            logger.Log(Severity.Info, "Resolved {0}", filename);
        }

        public void Summary(int existingSources, int usedSources, int missingSources,
            int references, int unresolvedReferences,
            int resolvedConflicts, int totalProjects, int failedProjects,
            TimeSpan analysisTime)
        {
            logger.Log(Severity.Info, "");
            logger.Log(Severity.Info, "Build analysis summary:");
            logger.Log(Severity.Info, "{0, 6} source files in the filesystem", existingSources);
            logger.Log(Severity.Info, "{0, 6} source files in project files", usedSources);
            logger.Log(Severity.Info, "{0, 6} sources missing from project files", missingSources);
            logger.Log(Severity.Info, "{0, 6} resolved references", references);
            logger.Log(Severity.Info, "{0, 6} unresolved references", unresolvedReferences);
            logger.Log(Severity.Info, "{0, 6} resolved assembly conflicts", resolvedConflicts);
            logger.Log(Severity.Info, "{0, 6} projects", totalProjects);
            logger.Log(Severity.Info, "{0, 6} missing/failed projects", failedProjects);
            logger.Log(Severity.Info, "Build analysis completed in {0}", analysisTime);
        }

        public void Log(Severity severity, string message)
        {
            logger.Log(severity, message);
        }

        public void ResolvedConflict(string asm1, string asm2)
        {
            logger.Log(Severity.Debug, "Resolved {0} as {1}", asm1, asm2);
        }

        public void MissingProject(string projectFile)
        {
            logger.Log(Severity.Info, "Solution is missing {0}", projectFile);
        }

        public void CommandFailed(string exe, string arguments, int exitCode)
        {
            logger.Log(Severity.Error, $"Command {exe} {arguments} failed with exit code {exitCode}");
        }

        public void MissingNuGet()
        {
            logger.Log(Severity.Error, "Missing nuget.exe");
        }
    }
}
