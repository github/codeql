using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public static class FileInfoExtensions
    {
        private static IEnumerable<string> SelectFilesAux(this IEnumerable<FileInfo> files, Predicate<FileInfo> p) =>
            files.Where(f => p(f)).Select(fi => fi.FullName);

        public static IEnumerable<FileInfo> SelectRootFiles(this IEnumerable<FileInfo> files, DirectoryInfo dir) =>
            files.Where(file => file.DirectoryName == dir.FullName);

        public static IEnumerable<string> SelectFileNamesByExtension(this IEnumerable<FileInfo> files, params string[] extensions) =>
            files.SelectFilesAux(fi => extensions.Contains(fi.Extension));

        public static IEnumerable<string> SelectFileNamesByName(this IEnumerable<FileInfo> files, params string[] names) =>
            files.SelectFilesAux(fi => names.Any(name => string.Compare(name, fi.Name, true) == 0));

        public static IEnumerable<string> SelectFileNames(this IEnumerable<FileInfo> files) =>
            files.SelectFilesAux(_ => true);
    }
}
