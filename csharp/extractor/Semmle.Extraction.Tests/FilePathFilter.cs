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
        private class LoggerStub : ILogger
        {
            public List<string> Messages { get; } = [];

            public void Log(Severity s, string text, int? threadId = null)
            {
                Messages.Add(text);
            }

            public void Dispose() { }
        }

        private static (FilePathFilter TestSubject, LoggerStub Logger, IEnumerable<FileInfo> Files) TestSetup()
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

        private static (FilePathFilter TestSubject, LoggerStub Logger, IEnumerable<FileInfo> Files) TestSetup(string root, IEnumerable<string> paths)
        {
            root = GetPlatformSpecifixPath(root);
            paths = GetPlatformSpecifixPaths(paths);

            var logger = new LoggerStub();

            var filePathFilter = new FilePathFilter(new DirectoryInfo(root), logger);
            return (filePathFilter, logger, paths.Select(p => new FileInfo(p)));
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
            (var testSubject, var logger, var files) = TestSetup();

            Environment.SetEnvironmentVariable("LGTM_INDEX_FILTERS", null);

            var filtered = testSubject.Filter(files);

            AssertFileInfoEquivalence(files, filtered);
            Assert.Equivalent(Array.Empty<string>(), logger.Messages, strict: true);
        }

        [Fact]
        public void TestFiltersWithOnlyInclude()
        {
            (var testSubject, var logger, var files) = TestSetup();

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
            Assert.Equivalent(expectedRegexMessages, logger.Messages, strict: false);
        }

        [Fact]
        public void TestFiltersWithOnlyExclude()
        {
            (var testSubject, var logger, var files) = TestSetup();

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
            Assert.Equivalent(expectedRegexMessages, logger.Messages, strict: false);
        }

        [Fact]
        public void TestFiltersWithIncludeExclude()
        {
            (var testSubject, var logger, var files) = TestSetup();

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
            Assert.Equivalent(expectedRegexMessages, logger.Messages, strict: false);
        }

        [Fact]
        public void TestFiltersWithIncludeExcludeExcludeFirst()
        {
            (var testSubject, var logger, var files) = TestSetup();

            // NOTE: the ordering DOES matter, later filters takes priority, so the exclude will end up not mattering at all.
            Environment.SetEnvironmentVariable("LGTM_INDEX_FILTERS", """
                exclude:c/x/z
                include:c/x
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
                "Filtering in files matching '^c/x.*'. Original glob filter: 'include:c/x'",
                "Filtering out files matching '^c/x/z.*'. Original glob filter: 'exclude:c/x/z'"
            };
            Assert.Equivalent(expectedRegexMessages, logger.Messages, strict: false);
        }

        [Fact]
        public void TestFiltersWithIncludeExcludeComplexPatterns1()
        {
            (var testSubject, var logger, var files) = TestSetup();

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
                "Filtering in files matching '^c/(.*/|)i\\.[^/]*.*'. Original glob filter: 'include:c/**/i.*'",
                "Filtering in files matching '^c/d/(.*/|)[^/]*\\.cs.*'. Original glob filter: 'include:c/d/**/*.cs'",
                "Filtering out files matching '^(.*/|)z/i\\.cs.*'. Original glob filter: 'exclude:**/z/i.cs'"
            };
            Assert.Equivalent(expectedRegexMessages, logger.Messages, strict: false);
        }

        [Fact]
        public void TestFiltersWithIncludeExcludeComplexPatterns2()
        {
            (var testSubject, var logger, var files) = TestSetup();

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
                "Filtering in files matching '^(.*/|)i\\.[^/]*.*'. Original glob filter: 'include:**/i.*'",
                "Filtering out files matching '^(.*/|)z/i\\.cs.*'. Original glob filter: 'exclude:**/z/i.cs'"
            };
            Assert.Equivalent(expectedRegexMessages, logger.Messages, strict: false);
        }

        [Fact]
        public void TestFiltersWithIncludeExcludeComplexPatternsRelativeRoot()
        {
            (var testSubject, var logger, var files) = TestSetup();

            // 'c' is the start of the relative path so we want to ensure the `**/` glob can match start
            Environment.SetEnvironmentVariable("LGTM_INDEX_FILTERS", """
                include:**/c/**/i.*
                exclude:**/c/**/z/i.cs
                exclude:**/**/c/**/z/i.cs
                """);

            var filtered = testSubject.Filter(files);

            var expected = GetExpected(
                [
                    "/a/b/c/x/y/i.cs",
                ]);

            AssertFileInfoEquivalence(expected, filtered);
            var expectedRegexMessages = new[]
            {
                "Filtering in files matching '^(.*/|)c/(.*/|)i\\.[^/]*.*'. Original glob filter: 'include:**/c/**/i.*'",
                "Filtering out files matching '^(.*/|)c/(.*/|)z/i\\.cs.*'. Original glob filter: 'exclude:**/c/**/z/i.cs'",
                "Filtering out files matching '^(.*/|)(.*/|)c/(.*/|)z/i\\.cs.*'. Original glob filter: 'exclude:**/**/c/**/z/i.cs'"
            };


            Assert.Equivalent(expectedRegexMessages, logger.Messages, strict: false);
        }
    }
}
