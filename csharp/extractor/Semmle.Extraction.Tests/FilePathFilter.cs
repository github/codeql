using Xunit;
using Semmle.Extraction.CSharp.DependencyFetching;
using Semmle.Util.Logging;
using System.Linq;
using System.Collections.Generic;
using System.IO;
using System;

namespace Semmle.Extraction.Tests
{
    public class FilePathFilterTest
    {
        private class ProgressMonitorStub : IProgressMonitor
        {
            public List<string> Messages { get; } = [];

            public void Log(Severity severity, string message)
            {
                Messages.Add(message);
            }
        }

        private static (FilePathFilter TestSubject, ProgressMonitorStub progressMonitor, IEnumerable<FileInfo> Files) TestSetup()
        {
            return TestSetup("/a/b",
            [
                "/a/b/c/d/e/f.cs",
                "/a/b/c/d/e/g.cs",
                "/a/b/c/d/e/h.cs",
                "/a/b/c/x/y/i.cs",
                "/a/b/c/x/z/i.cs"
            ]);
        }

        private static (FilePathFilter TestSubject, ProgressMonitorStub progressMonitor, IEnumerable<FileInfo> Files) TestSetup(string root, IEnumerable<string> paths)
        {
            root = GetPlatformSpecifixPath(root);
            paths = GetPlatformSpecifixPaths(paths);

            var progressMonitor = new ProgressMonitorStub();

            var filePathFilter = new FilePathFilter(new DirectoryInfo(root), progressMonitor);
            return (filePathFilter, progressMonitor, paths.Select(p => new FileInfo(p)));
        }

        private static string GetPlatformSpecifixPath(string file)
        {
            return file.Replace('/', Path.DirectorySeparatorChar);
        }

        private static IEnumerable<string> GetPlatformSpecifixPaths(IEnumerable<string> files)
        {
            return files.Select(GetPlatformSpecifixPath);
        }

        private static IEnumerable<FileInfo> GetExpected(IEnumerable<string> files)
        {
            files = GetPlatformSpecifixPaths(files);
            return files.Select(f => new FileInfo(f));
        }

        private static void AssertFileInfoEquivalence(IEnumerable<FileInfo>? expected, IEnumerable<FileInfo>? actual)
        {
            Assert.Equivalent(expected?.Select(f => f.FullName), actual?.Select(f => f.FullName), strict: true);
        }

        [Fact]
        public void TestNoFilter()
        {
            (var testSubject, var progressMonitor, var files) = TestSetup();

            Environment.SetEnvironmentVariable("LGTM_INDEX_FILTERS", null);

            var filtered = testSubject.Filter(files);

            AssertFileInfoEquivalence(files, filtered);
            Assert.Equivalent(Array.Empty<string>(), progressMonitor.Messages, strict: true);
        }

        [Fact]
        public void TestFiltersWithOnlyInclude()
        {
            (var testSubject, var progressMonitor, var files) = TestSetup();

            Environment.SetEnvironmentVariable("LGTM_INDEX_FILTERS", """
                include:c/d
                include:c/x/y
                """);

            var filtered = testSubject.Filter(files);

            var expected = GetExpected(
                [
                    "/a/b/c/d/e/f.cs",
                    "/a/b/c/d/e/g.cs",
                    "/a/b/c/d/e/h.cs",
                    "/a/b/c/x/y/i.cs"
                ]);

            AssertFileInfoEquivalence(expected, filtered);

            var expectedRegexMessages = new[]
            {
                "Filtering in files matching '^c/d.*'. Original glob filter: 'include:c/d'",
                "Filtering in files matching '^c/x/y.*'. Original glob filter: 'include:c/x/y'"
            };
            Assert.Equivalent(expectedRegexMessages, progressMonitor.Messages, strict: false);
        }

        [Fact]
        public void TestFiltersWithOnlyExclude()
        {
            (var testSubject, var progressMonitor, var files) = TestSetup();

            Environment.SetEnvironmentVariable("LGTM_INDEX_FILTERS", """
                exclude:c/d/e
                """);

            var filtered = testSubject.Filter(files);

            var expected = GetExpected(
                [
                    "/a/b/c/x/y/i.cs",
                    "/a/b/c/x/z/i.cs"
                ]);

            AssertFileInfoEquivalence(expected, filtered);

            var expectedRegexMessages = new[]
            {
                "Filtering out files matching '^c/d/e.*'. Original glob filter: 'exclude:c/d/e'"
            };
            Assert.Equivalent(expectedRegexMessages, progressMonitor.Messages, strict: false);
        }

        [Fact]
        public void TestFiltersWithIncludeExclude()
        {
            (var testSubject, var progressMonitor, var files) = TestSetup();

            Environment.SetEnvironmentVariable("LGTM_INDEX_FILTERS", """
                include:c/x
                exclude:c/x/z
                """);

            var filtered = testSubject.Filter(files);

            var expected = GetExpected(
                 [
                     "/a/b/c/x/y/i.cs"
                 ]);

            AssertFileInfoEquivalence(expected, filtered);

            var expectedRegexMessages = new[]
            {
                "Filtering in files matching '^c/x.*'. Original glob filter: 'include:c/x'",
                "Filtering out files matching '^c/x/z.*'. Original glob filter: 'exclude:c/x/z'"
            };
            Assert.Equivalent(expectedRegexMessages, progressMonitor.Messages, strict: false);
        }

        [Fact]
        public void TestFiltersWithIncludeExcludeExcludeFirst()
        {
            (var testSubject, var progressMonitor, var files) = TestSetup();

            Environment.SetEnvironmentVariable("LGTM_INDEX_FILTERS", """
                exclude:c/x/z
                include:c/x
                """);

            var filtered = testSubject.Filter(files);

            var expected = GetExpected(
                [
                    "/a/b/c/x/y/i.cs"
                ]);

            AssertFileInfoEquivalence(expected, filtered);

            var expectedRegexMessages = new[]
            {
                "Filtering in files matching '^c/x.*'. Original glob filter: 'include:c/x'",
                "Filtering out files matching '^c/x/z.*'. Original glob filter: 'exclude:c/x/z'"
            };
            Assert.Equivalent(expectedRegexMessages, progressMonitor.Messages, strict: false);
        }

        [Fact]
        public void TestFiltersWithIncludeExcludeComplexPatterns1()
        {
            (var testSubject, var progressMonitor, var files) = TestSetup();

            Environment.SetEnvironmentVariable("LGTM_INDEX_FILTERS", """
                include:c/**/i.*
                include:c/d/**/*.cs
                exclude:**/z/i.cs
                """);

            var filtered = testSubject.Filter(files);

            var expected = GetExpected(
                [
                    "/a/b/c/d/e/f.cs",
                    "/a/b/c/d/e/g.cs",
                    "/a/b/c/d/e/h.cs",
                    "/a/b/c/x/y/i.cs"
                ]);

            AssertFileInfoEquivalence(expected, filtered);

            var expectedRegexMessages = new[]
            {
                "Filtering in files matching '^c/.*/i\\.[^/]*.*'. Original glob filter: 'include:c/**/i.*'",
                "Filtering in files matching '^c/d/.*/[^/]*\\.cs.*'. Original glob filter: 'include:c/d/**/*.cs'",
                "Filtering out files matching '^.*/z/i\\.cs.*'. Original glob filter: 'exclude:**/z/i.cs'"
            };
            Assert.Equivalent(expectedRegexMessages, progressMonitor.Messages, strict: false);
        }

        [Fact]
        public void TestFiltersWithIncludeExcludeComplexPatterns2()
        {
            (var testSubject, var progressMonitor, var files) = TestSetup();

            Environment.SetEnvironmentVariable("LGTM_INDEX_FILTERS", """
                include:**/i.*
                exclude:**/z/i.cs
                """);

            var filtered = testSubject.Filter(files);

            var expected = GetExpected(
                [
                    "/a/b/c/x/y/i.cs"
                ]);

            AssertFileInfoEquivalence(expected, filtered);

            var expectedRegexMessages = new[]
            {
                "Filtering in files matching '^.*/i\\.[^/]*.*'. Original glob filter: 'include:**/i.*'",
                "Filtering out files matching '^.*/z/i\\.cs.*'. Original glob filter: 'exclude:**/z/i.cs'"
            };
            Assert.Equivalent(expectedRegexMessages, progressMonitor.Messages, strict: false);
        }
    }
}
