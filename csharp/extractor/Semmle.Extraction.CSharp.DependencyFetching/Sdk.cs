using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal partial class Sdk
    {
        private readonly IDotNet dotNet;
        private readonly ILogger logger;
        private readonly Lazy<string?> cscPath;
        public string? CscPath => cscPath.Value;

        private readonly Lazy<DotNetVersion?> newestSdkVersion;
        public DotNetVersion? Version => newestSdkVersion.Value;

        public Sdk(IDotNet dotNet, ILogger logger)
        {
            this.dotNet = dotNet;
            this.logger = logger;

            newestSdkVersion = new Lazy<DotNetVersion?>(GetNewestSdkVersion);
            cscPath = new Lazy<string?>(GetCscPath);
        }

        [GeneratedRegex(@"^(\d+\.\d+\.\d+)(-([a-z]+)\.(\d+\.\d+\.\d+))?\s\[(.+)\]$")]
        private static partial Regex SdkRegex();

        private static HashSet<DotNetVersion> ParseSdks(IList<string> listed)
        {
            var sdks = new HashSet<DotNetVersion>();
            var regex = SdkRegex();
            listed.ForEach(r =>
            {
                var match = regex.Match(r);
                if (match.Success)
                {
                    sdks.Add(new DotNetVersion(match.Groups[5].Value, match.Groups[1].Value, match.Groups[3].Value, match.Groups[4].Value));
                }
            });

            return sdks;
        }

        private DotNetVersion? GetNewestSdkVersion()
        {
            var listed = dotNet.GetListedSdks();
            var sdks = ParseSdks(listed);
            return sdks.Max();
        }

        private string? GetCscPath()
        {
            var version = Version;
            if (version is null)
            {
                logger.LogWarning("No dotnet SDK found.");
                return null;
            }

            var path = Path.Combine(version.FullPath, "Roslyn", "bincore", "csc.dll");
            logger.LogDebug($"Source generator CSC: '{path}'");
            if (!File.Exists(path))
            {
                logger.LogWarning($"csc.dll not found at '{path}'.");
                return null;
            }

            return path;
        }
    }
}