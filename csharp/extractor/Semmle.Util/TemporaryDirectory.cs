using System;
using System.IO;

namespace Semmle.Util
{
    /// <summary>
    /// A temporary directory that is created within the system temp directory.
    /// When this object is disposed, the directory is deleted.
    /// </summary>
    public sealed class TemporaryDirectory : IDisposable
    {
        public DirectoryInfo DirInfo { get; }

        public TemporaryDirectory(string name)
        {
            DirInfo = new DirectoryInfo(name);
            DirInfo.Create();
        }

        public void Dispose()
        {
            DirInfo.Delete(true);
        }

        public override string ToString() => DirInfo.FullName.ToString();
    }
}
