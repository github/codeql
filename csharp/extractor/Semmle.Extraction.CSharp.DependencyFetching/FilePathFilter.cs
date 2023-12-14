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

                var regex = new FilePattern(filterText).RegexPattern;
                progressMonitor.Log(Severity.Info, $"Filtering {(include ? "in" : "out")} files matching '{regex}'. Original glob filter: '{filter}'");
                pathFilters.Add(new PathFilter(new Regex(regex, RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline), include));
            }

            var includeByDefault = pathFilters.All(f => !f.Include);
            var unfilteredResult = files.Select(f =>
                new
                {
                    FileInfo = f,
                    FileInclusion = new FileInclusion(
                        FileUtils.ConvertToUnix(f.FullName.ToLowerInvariant()).Replace(rootFolder, string.Empty).TrimStart('/'),
                        includeByDefault)
                });

            // Move included pathfilters to the front of the list:
            pathFilters.Sort((pf1, pf2) => -1 * pf1.Include.CompareTo(pf2.Include));
            return unfilteredResult.Where(f =>
            {
                var include = f.FileInclusion.Include;
                foreach (var pathFilter in pathFilters)
                {
                    if (pathFilter.Regex.IsMatch(f.FileInclusion.Path))
                    {
                        include = pathFilter.Include;
                    }
                }

                if (!include)
                {
                    progressMonitor.Log(Severity.Info, $"Excluding '{f.FileInfo.FullName}'");
                }

                return include;
            }).Select(f => f.FileInfo);
        }
    }
}
