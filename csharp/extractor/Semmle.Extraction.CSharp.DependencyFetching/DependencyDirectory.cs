using System;
using System.IO;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// A directory used for storing fetched dependencies.
    /// When a specific directory is set via the dependency directory extractor option,
    /// we store dependencies in that directory for caching purposes.
    /// Otherwise, we create a temporary directory that is deleted upon disposal.
    /// </summary>
    public sealed class DependencyDirectory : IDisposable
    {
        private readonly string userReportedDirectoryPurpose;
        private readonly ILogger logger;
        private readonly bool attemptCleanup;

        public DirectoryInfo DirInfo { get; }

        public DependencyDirectory(string subfolderName, string userReportedDirectoryPurpose, ILogger logger)
        {
            this.logger = logger;
            this.userReportedDirectoryPurpose = userReportedDirectoryPurpose;

            string path;
            if (EnvironmentVariables.GetBuildlessDependencyDir() is string dir)
            {
                path = dir;
                attemptCleanup = false;
            }
            else
            {
                path = FileUtils.GetTemporaryWorkingDirectory(out _);
                attemptCleanup = true;
            }
            DirInfo = new DirectoryInfo(Path.Join(path, subfolderName));
            DirInfo.Create();
        }

        public void Dispose()
        {
            if (!attemptCleanup)
            {
                logger.LogInfo($"Keeping {userReportedDirectoryPurpose} directory {DirInfo.FullName} for possible caching purposes.");
                return;
            }

            try
            {
                DirInfo.Delete(true);
            }
            catch (Exception exc)
            {
                logger.LogInfo($"Couldn't delete {userReportedDirectoryPurpose} directory {exc.Message}");
            }
        }

        public override string ToString() => DirInfo.FullName;
    }
}
