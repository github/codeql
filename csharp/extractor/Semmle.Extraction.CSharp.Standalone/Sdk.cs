using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using Semmle.BuildAnalyser;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.Standalone
{
    /// <summary>
    /// Locates .NET SDKs.
    /// </summary>
    internal partial class Sdk
    {
        private readonly IDotNet dotNet;

        public Sdk(IDotNet dotNet) => this.dotNet = dotNet;

        [GeneratedRegex(@"^(\d+\.\d+\.\d+)(-([a-z]+)\.(\d+\.\d+\.\d+))?\s\[(\S+)\]$")]
        private static partial Regex SdkRegex();

        private static HashSet<DotnetVersion> ParseSdks(IList<string> listed)
        {
            var sdks = new HashSet<DotnetVersion>();
            var regex = SdkRegex();
            listed.ForEach(r =>
            {
                var match = regex.Match(r);
                if (match.Success)
                {
                    sdks.Add(new DotnetVersion(match.Groups[5].Value, match.Groups[1].Value, match.Groups[3].Value, match.Groups[4].Value));
                }
            });

            return sdks;
        }

        public DotnetVersion? GetLatestSdk()
        {
            var listed = dotNet.GetListedSdks();
            var sdks = ParseSdks(listed);
            return sdks.OrderByDescending(s => s).FirstOrDefault();
        }
    }
}
