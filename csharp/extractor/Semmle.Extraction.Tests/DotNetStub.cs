using System;
using System.Collections.Generic;
using Semmle.Extraction.CSharp.DependencyFetching;

namespace Semmle.Extraction.Tests
{
    internal class DotNetStub : IDotNet
    {
        private readonly IList<string> runtimes;
        private readonly IList<string> sdks;

        public DotNetStub(IList<string> runtimes, IList<string> sdks)
        {
            this.runtimes = runtimes;
            this.sdks = sdks;
        }
        public bool AddPackage(string folder, string package) => true;

        public bool New(string folder) => true;

        public RestoreResult Restore(RestoreSettings restoreSettings) => new(true, Array.Empty<string>());

        public IList<string> GetListedRuntimes() => runtimes;

        public IList<string> GetListedSdks() => sdks;

        public bool Exec(List<string> execArgs) => true;

        public IList<string> GetNugetFeeds(string nugetConfig) => [];

        public IList<string> GetNugetFeedsFromFolder(string folderPath) => [];
    }
}
