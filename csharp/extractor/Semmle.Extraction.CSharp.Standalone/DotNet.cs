using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;

namespace Semmle.BuildAnalyser
{
    /// <summary>
    /// Utilities to run the "dotnet" command.
    /// </summary>
    static class DotNet
    {
        public static int RestoreToDirectory(string projectOrSolutionFile, string packageDirectory)
        {
            using var proc = Process.Start("dotnet", $"restore --no-dependencies \"{projectOrSolutionFile}\" --packages \"{packageDirectory}\"");
            proc.WaitForExit();
            return proc.ExitCode;
        }
    }

    /// <summary>
    /// Utility to temporarily rename a set of files.
    /// </summary>
    sealed class FileRenamer : IDisposable
    {
        string[] files;
        const string suffix = ".codeqlhidden";

        public FileRenamer(IEnumerable<FileInfo> oldFiles)
        {
            files = oldFiles.Select(f => f.FullName).ToArray();

            foreach(var file in files)
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
