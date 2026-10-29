using System;
using System.IO;
using Semmle.Util.Logging;

namespace Semmle.Util
{
    /// <summary>
    /// A temporary directory that is created within the system temp directory.
    /// When this object is disposed, the directory is deleted.
    /// </summary>
    public sealed class TemporaryDirectory : IDisposable
    {
        private readonly string userReportedDirectoryPurpose;
        private readonly ILogger logger;

        public DirectoryInfo DirInfo { get; }

        public TemporaryDirectory(string path, string userReportedDirectoryPurpose, ILogger logger)
        {
            DirInfo = new DirectoryInfo(path);
            DirInfo.Create();
            this.userReportedDirectoryPurpose = userReportedDirectoryPurpose;
            this.logger = logger;
        }

        public void Dispose()
        {
            try
            {
                DirInfo.Delete(true);
            }
            catch (Exception exc)
            {
                logger.LogInfo($"Couldn't delete {userReportedDirectoryPurpose} directory {exc.Message}");
            }
        }

        public override string ToString() => DirInfo.FullName.ToString();
    }
}
