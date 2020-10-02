using Xunit;
using Semmle.Util;
using System.IO;
using System.Linq;
using System;

namespace SemmleTests.Semmle.Util
{
    /// <summary>
    /// Ensure that the Extractor works with long paths.
    /// These should be handled by .NET Core.
    /// </summary>
    public sealed class LongPaths : IDisposable
    {
        private static readonly string tmpDir = Path.GetTempPath();
        private static readonly string shortPath = Path.Combine(tmpDir, "test.txt");
        private static readonly string longPath = Path.Combine(tmpDir, "aaaaaaaaaaaaaaaaaaaaaaaaaaaa", "bbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
            "ccccccccccccccccccccccccccccccc", "ddddddddddddddddddddddddddddddddddddd", "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "fffffffffffffffffffffffffffffffff",
            "ggggggggggggggggggggggggggggggggggg", "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhh", "iiiiiiiiiiiiiiii.txt");

        public LongPaths()
        {
            CleanUp();
        }

        public void Dispose()
        {
            CleanUp();
        }

        private static void CleanUp()
        {
            try
            {
                File.Delete(shortPath);
            }
            catch (DirectoryNotFoundException)
            {
            }
            try
            {
                File.Delete(longPath);
            }
            catch (DirectoryNotFoundException)
            {
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
            // OK Do not exist.
            File.Delete(shortPath);
            File.Delete(longPath);
        }

        [Fact]
        public void Move()
        {
            File.WriteAllText(shortPath, "abc");
            Directory.CreateDirectory(Path.GetDirectoryName(longPath));
            File.Delete(longPath);
            File.Move(shortPath, longPath);
            File.Move(longPath, shortPath);
            Assert.Equal("abc", File.ReadAllText(shortPath));
        }

        [Fact]
        public void Replace()
        {
            File.WriteAllText(shortPath, "abc");
            File.Delete(longPath);
            Directory.CreateDirectory(Path.GetDirectoryName(longPath));
            File.Move(shortPath, longPath);
            File.WriteAllText(shortPath, "def");
            FileUtils.MoveOrReplace(shortPath, longPath);
            File.WriteAllText(shortPath, "abc");
            FileUtils.MoveOrReplace(longPath, shortPath);
            Assert.Equal("def", File.ReadAllText(shortPath));
        }

        private readonly byte[] buffer1 = new byte[10] { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

        [Fact]
        public void CreateShortStream()
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
        }

        [Fact]
        public void CreateLongStream()
        {
            var buffer2 = new byte[10];

            Directory.CreateDirectory(Path.GetDirectoryName(longPath));

            using (var s3 = new FileStream(longPath, FileMode.Create, FileAccess.Write, FileShare.None))
            {
                s3.Write(buffer1, 0, 10);
            }

            using (var s4 = new FileStream(longPath, FileMode.Open, FileAccess.Read, FileShare.None))
            {
                Assert.Equal(10, s4.Read(buffer2, 0, 10));
                Assert.True(Enumerable.SequenceEqual(buffer1, buffer2));
            }
        }

        [Fact]
        public void FileDoesNotExist()
        {
            // File does not exist
            Assert.Throws<System.IO.FileNotFoundException>(() =>
            {
                using (new FileStream(longPath, FileMode.Open, FileAccess.Read, FileShare.None))
                {
                    //
                }
            });
        }

        [Fact]
        public void OverwriteFile()
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
        }

        [Fact]
        public void LongFileExists()
        {
            Assert.False(File.Exists("no such file"));
            Assert.False(File.Exists("\":"));
            Assert.False(File.Exists(@"C:\"));  // A directory

            Assert.False(File.Exists(longPath));
            new FileStream(longPath, FileMode.Create, FileAccess.Write, FileShare.None).Close();
            Assert.True(File.Exists(longPath));
        }
    }
}
