using Xunit;
using Semmle.Util;
using System.IO;
using Semmle.Util.Logging;
using System;

namespace SemmleTests.Semmle.Util
{
    public sealed class CanonicalPathCacheTest : IDisposable
    {
        private readonly ILogger Logger = new LoggerMock();
        private readonly string root;
        private CanonicalPathCache cache;

        public CanonicalPathCacheTest()
        {
            File.Create("abc").Close();
            cache = CanonicalPathCache.Create(Logger, 1000, CanonicalPathCache.Symlinks.Follow);

            // Change directories to a directory that is in canonical form.
            Directory.SetCurrentDirectory(cache.GetCanonicalPath(Path.GetTempPath()));

            root = Win32.IsWindows() ? @"X:\" : "/";
        }

        public void Dispose()
        {
            File.Delete("abc");
            Logger.Dispose();
        }

        [Fact]
        public void CanonicalPathRelativeFile()
        {
            var abcPath = Path.GetFullPath("abc");

            Assert.Equal(abcPath, cache.GetCanonicalPath("abc"));
        }

        [Fact]
        public void CanonicalPathAbsoluteFile()
        {
            var abcPath = Path.GetFullPath("abc");

            Assert.Equal(abcPath, cache.GetCanonicalPath(abcPath));
        }

        [Fact]
        public void CanonicalPathDirectory()
        {
            var cwd = Directory.GetCurrentDirectory();

            Assert.Equal(cwd, cache.GetCanonicalPath(cwd));
        }

        [Fact]
        public void CanonicalPathInvalidRoot()
        {
            if (Win32.IsWindows())
                Assert.Equal(@"X:\", cache.GetCanonicalPath(@"x:\"));
        }

        [Fact]
        public void CanonicalPathMissingRoot()
        {
            if (Win32.IsWindows())
                Assert.Equal(@"X:\nosuchfile", cache.GetCanonicalPath(@"X:\nosuchfile"));
        }

        [Fact]
        public void CanonicalPathUNCRoot()
        {
            CanonicalPathCache cache2 = CanonicalPathCache.Create(Logger, 1000, CanonicalPathCache.Symlinks.Preserve);

            if (Win32.IsWindows())
            {
                var windows = cache.GetCanonicalPath(@"\WINDOWS").Replace(":", "$");
                Assert.Equal($@"\\LOCALHOST\{windows}\bar", cache2.GetCanonicalPath($@"\\localhost\{windows}\bar"));
            }
        }

        [Fact]
        public void CanonicalPathMissingFile()
        {
            Assert.Equal(Path.Combine(Directory.GetCurrentDirectory(), "NOSUCHFILE"), cache.GetCanonicalPath("NOSUCHFILE"));
        }

        [Fact]
        public void CanonicalPathMissingAbsolutePath()
        {
            Assert.Equal(Path.Combine(root, "no", "such", "file"), cache.GetCanonicalPath(Path.Combine(root, "no", "such", "file")));

            if (Win32.IsWindows())
                Assert.Equal(@"C:\Windows\no\such\file", cache.GetCanonicalPath(@"C:\windOws\no\such\file"));
        }

        [Fact]
        public void CanonicalPathMissingRelativePath()
        {
            Assert.Equal(Path.Combine(Directory.GetCurrentDirectory(), "NO", "SUCH"), cache.GetCanonicalPath(Path.Combine("NO", "SUCH")));
        }

        [Fact]
        public void CanonicalPathLowercaseDrive()
        {
            if (Win32.IsWindows())
                Assert.Equal(@"C:\Windows", cache.GetCanonicalPath(@"c:\Windows"));
        }

        [Fact]
        public void CanonicalPathCorrectsCase()
        {
            if (!Win32.IsWindows())
                return;

            var abcPath = Path.GetFullPath("abc");

            Assert.Equal(abcPath, cache.GetCanonicalPath("ABC"));
            Assert.Equal(abcPath, cache.GetCanonicalPath("abc"));
            Assert.Equal(abcPath, cache.GetCanonicalPath(abcPath.ToUpperInvariant()));
            Assert.Equal(abcPath, cache.GetCanonicalPath(abcPath.ToLowerInvariant()));
        }

        [Fact]
        public void CanonicalPathDots()
        {
            var abcPath = Path.GetFullPath("abc");
            Assert.Equal(abcPath, cache.GetCanonicalPath(Path.Combine("foo", ".", "..", "abc")));
        }

        [Fact]
        public void CanonicalPathCacheSize()
        {
            cache = CanonicalPathCache.Create(Logger, 2, CanonicalPathCache.Symlinks.Preserve);
            Assert.Equal(0, cache.CacheSize);

            // The file "ABC" will fill the cache with parent directory info.
            cache.GetCanonicalPath("ABC");
            Assert.True(cache.CacheSize == 2);

            string cp = cache.GetCanonicalPath("def");
            Assert.Equal(2, cache.CacheSize);
            Assert.Equal(Path.GetFullPath("def"), cp);
        }

        [Fact]
        public void CanonicalPathFollowLinksTests()
        {
            cache = CanonicalPathCache.Create(Logger, 1000, CanonicalPathCache.Symlinks.Follow);
            RunAllTests();
        }

        [Fact]
        public void CanonicalPathPreserveLinksTests()
        {
            cache = CanonicalPathCache.Create(Logger, 1000, CanonicalPathCache.Symlinks.Preserve);
            RunAllTests();
        }

        private void RunAllTests()
        {
            CanonicalPathRelativeFile();
            CanonicalPathAbsoluteFile();
            CanonicalPathDirectory();
            CanonicalPathInvalidRoot();
            CanonicalPathMissingRoot();
            CanonicalPathMissingFile();
            CanonicalPathMissingAbsolutePath();
            CanonicalPathMissingRelativePath();
            CanonicalPathLowercaseDrive();
            CanonicalPathCorrectsCase();
            CanonicalPathDots();
        }

        private sealed class LoggerMock : ILogger
        {
            public void Dispose() { }

            public void Log(Severity s, string text) { }
        }
    }
}
