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
            public void Log(Severity severity, string message) { }
        }

        private static (FilePathFilter TestSubject, IEnumerable<FileInfo> Files) TestSetup(string root, IEnumerable<string> paths)
        {
            root = GetPlatformSpecifixPath(root);
            paths = GetPlatformSpecifixPaths(paths);

            var filePathFilter = new FilePathFilter(new DirectoryInfo(root), new ProgressMonitorStub());
            return (filePathFilter, paths.Select(p => new FileInfo(p)));
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

        private static void AssertEquivalence(IEnumerable<FileInfo>? expected, IEnumerable<FileInfo>? actual)
        {
            Assert.Equivalent(expected?.Select(f => f.FullName), actual?.Select(f => f.FullName), strict: true);
        }

        [Fact]
        public void TestNoFilter()
        {
            (var testSubject, var files) = TestSetup(
                "/a/b",
                [
                    "/a/b/c/d/e/f.cs",
                    "/a/b/c/d/e/g.cs",
                    "/a/b/c/d/e/h.cs",
                    "/a/b/c/x/y/i.cs",
                    "/a/b/c/x/z/i.cs"
                ]);

            Environment.SetEnvironmentVariable("LGTM_INDEX_FILTERS", null);

            var filtered = testSubject.Filter(files);

            AssertEquivalence(files, filtered);
        }

        [Fact]
        public void TestFiltersWithOnlyInclude()
        {
            (var testSubject, var files) = TestSetup(
                "/a/b",
                [
                    "/a/b/c/d/e/f.cs",
                    "/a/b/c/d/e/g.cs",
                    "/a/b/c/d/e/h.cs",
                    "/a/b/c/x/y/i.cs",
                    "/a/b/c/x/z/i.cs"
                ]);

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

            AssertEquivalence(expected, filtered);
        }

        [Fact]
        public void TestFiltersWithOnlyExclude()
        {
            (var testSubject, var files) = TestSetup("/a/b",
            [
                "/a/b/c/d/e/f.cs",
                "/a/b/c/d/e/g.cs",
                "/a/b/c/d/e/h.cs",
                "/a/b/c/x/y/i.cs",
                "/a/b/c/x/z/i.cs"
            ]);

            Environment.SetEnvironmentVariable("LGTM_INDEX_FILTERS", """
                exclude:c/d/e
                """);

            var filtered = testSubject.Filter(files);

            var expected = GetExpected(
                [
                    "/a/b/c/x/y/i.cs",
                    "/a/b/c/x/z/i.cs"
                ]);

            AssertEquivalence(expected, filtered);
        }

        [Fact]
        public void TestFiltersWithIncludeExclude()
        {
            (var testSubject, var files) = TestSetup("/a/b",
            [
                "/a/b/c/d/e/f.cs",
                "/a/b/c/d/e/g.cs",
                "/a/b/c/d/e/h.cs",
                "/a/b/c/x/y/i.cs",
                "/a/b/c/x/z/i.cs"
            ]);

            Environment.SetEnvironmentVariable("LGTM_INDEX_FILTERS", """
                include:c/x
                exclude:c/x/z
                """);

            var filtered = testSubject.Filter(files);

            var expected = GetExpected(
                 [
                     "/a/b/c/x/y/i.cs"
                 ]);

            AssertEquivalence(expected, filtered);
        }

        [Fact]
        public void TestFiltersWithIncludeExcludeExcludeFirst()
        {
            (var testSubject, var files) = TestSetup("/a/b",
            [
                "/a/b/c/d/e/f.cs",
                "/a/b/c/d/e/g.cs",
                "/a/b/c/d/e/h.cs",
                "/a/b/c/x/y/i.cs",
                "/a/b/c/x/z/i.cs"
            ]);

            Environment.SetEnvironmentVariable("LGTM_INDEX_FILTERS", """
                exclude:c/x/z
                include:c/x
                """);

            var filtered = testSubject.Filter(files);

            var expected = GetExpected(
                [
                    "/a/b/c/x/y/i.cs"
                ]);

            AssertEquivalence(expected, filtered);
        }

        [Fact]
        public void TestFiltersWithIncludeExcludeComplexPatterns1()
        {
            (var testSubject, var files) = TestSetup("/a/b",
            [
                "/a/b/c/d/e/f.cs",
                "/a/b/c/d/e/g.cs",
                "/a/b/c/d/e/h.cs",
                "/a/b/c/x/y/i.cs",
                "/a/b/c/x/z/i.cs"
            ]);

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

            AssertEquivalence(expected, filtered);
        }

        [Fact]
        public void TestFiltersWithIncludeExcludeComplexPatterns2()
        {
            (var testSubject, var files) = TestSetup("/a/b",
            [
                "/a/b/c/d/e/f.cs",
                "/a/b/c/d/e/g.cs",
                "/a/b/c/d/e/h.cs",
                "/a/b/c/x/y/i.cs",
                "/a/b/c/x/z/i.cs"
            ]);

            Environment.SetEnvironmentVariable("LGTM_INDEX_FILTERS", """
                include:**/i.*
                exclude:**/z/i.cs
                """);

            var filtered = testSubject.Filter(files);

            var expected = GetExpected(
                [
                    "/a/b/c/x/y/i.cs"
                ]);

            AssertEquivalence(expected, filtered);
        }
    }
}
