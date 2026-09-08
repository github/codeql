using System;
using System.Collections.Generic;
using Semmle.Extraction.CSharp.DependencyFetching;

namespace Semmle.Extraction.Tests
{
    internal class DotNetStub : IDotNet
    {
        private readonly IList<string> runtimes;
        private readonly IList<string> sdks;
        private readonly IList<string> nugetFeedsFromConfig;
        private readonly IList<string> nugetFeedsFromFolder;

        public DotNetStub(IList<string> runtimes, IList<string> sdks, IList<string> nugetFeedsFromConfig, IList<string> nugetFeedsFromFolder)
        {
            this.runtimes = runtimes;
            this.sdks = sdks;
            this.nugetFeedsFromConfig = nugetFeedsFromConfig;
            this.nugetFeedsFromFolder = nugetFeedsFromFolder;
        }
        public bool AddPackage(string folder, string package) => true;

        public bool New(string folder) => true;

        public RestoreResult Restore(RestoreSettings restoreSettings) => new(true, Array.Empty<string>());

        public IList<string> GetListedRuntimes() => runtimes;

        public IList<string> GetListedSdks() => sdks;

        public bool Exec(List<string> execArgs) => true;

        public IList<string> GetNugetFeeds(string nugetConfig) => nugetFeedsFromConfig;

        public IList<string> GetNugetFeedsFromFolder(string folderPath) => nugetFeedsFromFolder;
    }
}
