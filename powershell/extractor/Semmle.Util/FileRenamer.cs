using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Util
{
    /// <summary>
    /// Utility to temporarily rename a set of files.
    /// </summary>
    public sealed class FileRenamer : IDisposable
    {
        private readonly string[] files;
        private const string suffix = ".codeqlhidden";

        public FileRenamer(IEnumerable<FileInfo> oldFiles)
        {
            files = oldFiles.Select(f => f.FullName).ToArray();

            foreach (var file in files)
            {
                File.Move(file, file + suffix);
            }
        }

        public void Dispose()
        {
            foreach (var file in files)
            {
                File.Move(file + suffix, file);
            }
        }
    }
}
