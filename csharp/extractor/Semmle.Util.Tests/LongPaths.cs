using Xunit;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Semmle.Util;

namespace SemmleTests.Semmle.Util
{
    /// <summary>
    /// Ensure that the Extractor works with long paths.
    /// These should be handled by .NET Core.
    /// </summary>
    public sealed class LongPaths
    {
        private static readonly string tmpDir = Environment.GetEnvironmentVariable("TEST_TMPDIR") ?? Path.GetTempPath();
        private static readonly string longPathDir = Path.Combine(tmpDir, "aaaaaaaaaaaaaaaaaaaaaaaaaaaa", "bbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
            "ccccccccccccccccccccccccccccccc", "ddddddddddddddddddddddddddddddddddddd", "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "fffffffffffffffffffffffffffffffff",
            "ggggggggggggggggggggggggggggggggggg", "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");

        private static string MakeLongPath()
        {
            var uniquePostfix = Guid.NewGuid().ToString("N");
            return Path.Combine(longPathDir, $"iiiiiiiiiiiiiiii{uniquePostfix}.txt");
        }

        private static string MakeShortPath()
        {
            var uniquePostfix = Guid.NewGuid().ToString("N");
            return Path.Combine(tmpDir, $"test{uniquePostfix}.txt");
        }

        public LongPaths()
        {
            // Create directory to avoid directory not found exceptions when deleting files
            Directory.CreateDirectory(longPathDir);
        }

        private static void Cleanup(params IEnumerable<string> paths)
        {
            foreach (var path in paths)
            {
                File.Delete(path);
            }
        }

        private static void WithSetUpAndTearDown(Action<string, string> test)
        {
            var longPath = MakeLongPath();
            var shortPath = MakeShortPath();
            Cleanup(longPath, shortPath);
            try
            {
                test(longPath, shortPath);
            }
            finally
            {
                Cleanup(longPath, shortPath);
            }
        }

        [Fact]
        public void ParentDirectory()
        {
            Assert.Equal("abc", Path.GetDirectoryName(Path.Combine("abc", "def")));
            Assert.Equal(Win32.IsWindows() ? "\\" : "/", Path.GetDirectoryName($@"{Path.DirectorySeparatorChar}def"));
            Assert.Equal("", Path.GetDirectoryName(@"def"));

            if (Win32.IsWindows())
            {
                Assert.Null(Path.GetDirectoryName(@"C:"));
                Assert.Null(Path.GetDirectoryName(@"C:\"));
            }
        }

        [Fact]
        public void Delete()
        {
            WithSetUpAndTearDown((longPath, shortPath) =>
            {
                // OK Do not exist.
                File.Delete(shortPath);
                File.Delete(longPath);
            });
        }

        [Fact]
        public void Move()
        {
            WithSetUpAndTearDown((longPath, shortPath) =>
            {
                File.WriteAllText(shortPath, "abc");
                File.Delete(longPath);
                File.Move(shortPath, longPath);
                File.Move(longPath, shortPath);
                Assert.Equal("abc", File.ReadAllText(shortPath));
            });
        }

        [Fact]
        public void Replace()
        {
            WithSetUpAndTearDown((longPath, shortPath) =>
            {
                File.WriteAllText(shortPath, "abc");
                File.Move(shortPath, longPath);
                File.WriteAllText(shortPath, "def");
                FileUtils.MoveOrReplace(shortPath, longPath);
                File.WriteAllText(shortPath, "abc");
                FileUtils.MoveOrReplace(longPath, shortPath);
                Assert.Equal("def", File.ReadAllText(shortPath));
            });
        }

        private readonly byte[] buffer1 = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

        [Fact]
        public void CreateShortStream()
        {
            WithSetUpAndTearDown((_, shortPath) =>
            {
                var buffer2 = new byte[10];

                using (var s1 = new FileStream(shortPath, FileMode.Create, FileAccess.Write, FileShare.None))
                {
                    s1.Write(buffer1, 0, 10);
                }

                using (var s2 = new FileStream(shortPath, FileMode.Open, FileAccess.Read, FileShare.None))
                {
                    Assert.Equal(10, s2.Read(buffer2, 0, 10));
                    Assert.True(Enumerable.SequenceEqual(buffer1, buffer2));
                }
            });
        }

        [Fact]
        public void CreateLongStream()
        {
            WithSetUpAndTearDown((longPath, _) =>
            {
                var buffer2 = new byte[10];

                Directory.CreateDirectory(Path.GetDirectoryName(longPath)!);

                using (var s3 = new FileStream(longPath, FileMode.Create, FileAccess.Write, FileShare.None))
                {
                    s3.Write(buffer1, 0, 10);
                }

                using (var s4 = new FileStream(longPath, FileMode.Open, FileAccess.Read, FileShare.None))
                {
                    Assert.Equal(10, s4.Read(buffer2, 0, 10));
                    Assert.True(Enumerable.SequenceEqual(buffer1, buffer2));
                }
            });
        }

        [Fact]
        public void FileDoesNotExist()
        {
            WithSetUpAndTearDown((longPath, _) =>
            {
                // File does not exist
                Assert.Throws<System.IO.FileNotFoundException>(() =>
                {
                    using (new FileStream(longPath, FileMode.Open, FileAccess.Read, FileShare.None))
                    {
                        //
                    }
                });
            });
        }

        [Fact]
        public void OverwriteFile()
        {
            WithSetUpAndTearDown((longPath, _) =>
            {
                using (var s1 = new FileStream(longPath, FileMode.Create, FileAccess.Write, FileShare.None))
                {
                    s1.Write(buffer1, 0, 10);
                }

                byte[] buffer2 = { 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 };

                using (var s2 = new FileStream(longPath, FileMode.Create, FileAccess.Write, FileShare.None))
                {
                    s2.Write(buffer2, 0, 10);
                }

                byte[] buffer3 = new byte[10];

                using (var s3 = new FileStream(longPath, FileMode.Open, FileAccess.Read, FileShare.None))
                {
                    Assert.Equal(10, s3.Read(buffer3, 0, 10));
                }

                Assert.True(Enumerable.SequenceEqual(buffer2, buffer3));
            });
        }

        [Fact]
        public void LongFileExists()
        {
            WithSetUpAndTearDown((longPath, _) =>
            {
                Assert.False(File.Exists("no such file"));
                Assert.False(File.Exists("\":"));
                Assert.False(File.Exists(@"C:\"));  // A directory

                Assert.False(File.Exists(longPath));
                new FileStream(longPath, FileMode.Create, FileAccess.Write, FileShare.None).Close();
                Assert.True(File.Exists(longPath));
            });
        }
    }
}
