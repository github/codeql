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
        private readonly ILogger logger;

        public FilePathFilter(DirectoryInfo sourceDir, ILogger logger)
        {
            rootFolder = FileUtils.ConvertToUnix(sourceDir.FullName.ToLowerInvariant());
            this.logger = logger;
        }

        private class FileInclusion(string path, bool include)
        {
            public string Path { get; } = path;

            public bool Include { get; set; } = include;
        }

        private record class PathFilter(Regex Regex, bool Include);

        public IEnumerable<FileInfo> Filter(IEnumerable<FileInfo> files)
        {
            var filters = (Environment.GetEnvironmentVariable("LGTM_INDEX_FILTERS") ?? string.Empty).Split(FileUtils.NewLineCharacters, StringSplitOptions.RemoveEmptyEntries);
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
                    logger.LogInfo($"Invalid filter: {filter}");
                    continue;
                }

                var regex = new FilePattern(filterText).RegexPattern;
                logger.LogInfo($"Filtering {(include ? "in" : "out")} files matching '{regex}'. Original glob filter: '{filter}'");
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

            return unfilteredResult.Where(f =>
            {
                var include = f.FileInclusion.Include;
                // LGTM_INDEX_FILTERS is a prioritized list, where later filters take
                // priority over earlier ones.
                for (int i = pathFilters.Count - 1; i >= 0; i--)
                {
                    var pathFilter = pathFilters[i];
                    if (pathFilter.Regex.IsMatch(f.FileInclusion.Path))
                    {
                        include = pathFilter.Include;
                        break;
                    }
                }

                if (!include)
                {
                    logger.LogInfo($"Excluding '{f.FileInfo.FullName}'");
                }

                return include;
            }).Select(f => f.FileInfo);
        }
    }
}
