using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text.RegularExpressions;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public class FilePathFilter
    {
        private readonly string rootFolder;
        private readonly IProgressMonitor progressMonitor;

        public FilePathFilter(DirectoryInfo sourceDir, IProgressMonitor progressMonitor)
        {
            rootFolder = FileUtils.ConvertToUnix(sourceDir.FullName.ToLowerInvariant());
            this.progressMonitor = progressMonitor;
        }

        private class FileInclusion(string path, bool include)
        {
            public string Path { get; } = path;

            public bool Include { get; set; } = include;
        }

        private record class PathFilter(Regex Regex, bool Include);

        public IEnumerable<FileInfo> Filter(IEnumerable<FileInfo> files)
        {
            var filters = (Environment.GetEnvironmentVariable("LGTM_INDEX_FILTERS") ?? string.Empty).Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
            if (filters.Length == 0)
            {
                return files;
            }

            var pathFilters = new List<PathFilter>();

            foreach (var filter in filters)
            {
                bool include;
                string filterText;
                if (filter.StartsWith("include:"))
                {
                    include = true;
                    filterText = filter.Substring("include:".Length);
                }
                else if (filter.StartsWith("exclude:"))
                {
                    include = false;
                    filterText = filter.Substring("exclude:".Length);
                }
                else
                {
                    progressMonitor.Log(Severity.Info, $"Invalid filter: {filter}");
                    continue;
                }

                pathFilters.Add(new PathFilter(new Regex(new FilePattern(filterText).RegexPattern, RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline), include));
            }

            var fileIndex = files.ToDictionary(f => f, f => new FileInclusion(FileUtils.ConvertToUnix(f.FullName.ToLowerInvariant()).Replace(rootFolder, string.Empty).TrimStart('/'), pathFilters.All(f => !f.Include)));

            foreach (var pathFilter in pathFilters.OrderBy(pf => pf.Include ? 0 : 1))
            {
                foreach (var file in fileIndex)
                {
                    if (pathFilter.Regex.IsMatch(file.Value.Path))
                    {
                        fileIndex[file.Key].Include = pathFilter.Include;
                    }
                }
            }

            return fileIndex.Where(f => f.Value.Include).Select(f => f.Key);
        }
    }
}
