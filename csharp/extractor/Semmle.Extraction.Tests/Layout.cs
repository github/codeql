using System.IO;
using Xunit;
using Semmle.Util.Logging;
using System.Runtime.InteropServices;

namespace Semmle.Extraction.Tests
{
    internal struct TransformedPathStub : PathTransformer.ITransformedPath
    {
        private readonly string value;
        public TransformedPathStub(string value) => this.value = value;
        public string Value => value;

        public string Extension => throw new System.NotImplementedException();

        public string NameWithoutExtension => throw new System.NotImplementedException();

        public PathTransformer.ITransformedPath ParentDirectory => throw new System.NotImplementedException();

        public string DatabaseId => throw new System.NotImplementedException();

        public PathTransformer.ITransformedPath WithSuffix(string suffix)
        {
            throw new System.NotImplementedException();
        }
    }

    public class Layout
    {
        private readonly ILogger logger = new LoggerMock();

        [Fact]
        public void TestDefaultLayout()
        {
            var layout = new Semmle.Extraction.Layout(null, null, null);
            var project = layout.LookupProjectOrNull(new TransformedPathStub("foo.cs"));

            Assert.NotNull(project);

            // All files are mapped when there's no layout file.
            Assert.True(layout.FileInLayout(new TransformedPathStub("foo.cs")));

            // Test trap filename
            var tmpDir = Path.GetTempPath();
            Directory.SetCurrentDirectory(tmpDir);
            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            {
                // `Directory.SetCurrentDirectory()` seems to slightly change the path on macOS,
                // so adjusting it:
                Assert.NotEqual(Directory.GetCurrentDirectory(), tmpDir);
                tmpDir = "/private" + tmpDir;
                // Remove trailing slash:
                Assert.Equal('/', tmpDir[tmpDir.Length - 1]);
                tmpDir = tmpDir.Substring(0, tmpDir.Length - 1);
                Assert.Equal(Directory.GetCurrentDirectory(), tmpDir);
            }
            var f1 = project!.GetTrapPath(logger, new TransformedPathStub("foo.cs"), TrapWriter.CompressionMode.Gzip);
            var g1 = TrapWriter.NestPaths(logger, tmpDir, "foo.cs.trap.gz");
            Assert.Equal(f1, g1);

            // Test trap file generation
            var trapwriterFilename = project.GetTrapPath(logger, new TransformedPathStub("foo.cs"), TrapWriter.CompressionMode.Gzip);
            using (var trapwriter = project.CreateTrapWriter(logger, new TransformedPathStub("foo.cs"), TrapWriter.CompressionMode.Gzip, discardDuplicates: false))
            {
                trapwriter.Emit("1=*");
                Assert.False(File.Exists(trapwriterFilename));
            }
            Assert.True(File.Exists(trapwriterFilename));
            File.Delete(trapwriterFilename);
        }

        [Fact]
        public void TestLayoutFile()
        {
            File.WriteAllLines("layout.txt", new string[]
            {
                "# Section",
                "TRAP_FOLDER=" + Path.GetFullPath("snapshot\\trap"),
                "ODASA_DB=snapshot\\db-csharp",
                "SOURCE_ARCHIVE=" + Path.GetFullPath("snapshot\\archive"),
                "ODASA_BUILD_ERROR_DIR=snapshot\build-errors",
                "-foo.cs",
                "bar.cs",
                "-excluded",
                "excluded/foo.cs",
                "included"
            });

            var layout = new Semmle.Extraction.Layout(null, null, "layout.txt");

            // Test general pattern matching
            Assert.True(layout.FileInLayout(new TransformedPathStub("bar.cs")));
            Assert.False(layout.FileInLayout(new TransformedPathStub("foo.cs")));
            Assert.False(layout.FileInLayout(new TransformedPathStub("goo.cs")));
            Assert.False(layout.FileInLayout(new TransformedPathStub("excluded/bar.cs")));
            Assert.True(layout.FileInLayout(new TransformedPathStub("excluded/foo.cs")));
            Assert.True(layout.FileInLayout(new TransformedPathStub("included/foo.cs")));

            // Test the trap file
            var project = layout.LookupProjectOrNull(new TransformedPathStub("bar.cs"));
            Assert.NotNull(project);
            var trapwriterFilename = project!.GetTrapPath(logger, new TransformedPathStub("bar.cs"), TrapWriter.CompressionMode.Gzip);
            Assert.Equal(TrapWriter.NestPaths(logger, Path.GetFullPath("snapshot\\trap"), "bar.cs.trap.gz"),
                trapwriterFilename);

            // Test the source archive
            var trapWriter = project.CreateTrapWriter(logger, new TransformedPathStub("bar.cs"), TrapWriter.CompressionMode.Gzip, discardDuplicates: false);
            trapWriter.Archive("layout.txt", new TransformedPathStub("layout.txt"), System.Text.Encoding.ASCII);
            var writtenFile = TrapWriter.NestPaths(logger, Path.GetFullPath("snapshot\\archive"), "layout.txt");
            Assert.True(File.Exists(writtenFile));
            File.Delete("layout.txt");
        }

        [Fact]
        public void TestTrapOverridesLayout()
        {
            // When you specify both a trap file and a layout, use the trap file.
            var layout = new Semmle.Extraction.Layout(Path.GetFullPath("snapshot\\trap"), null, "something.txt");
            Assert.True(layout.FileInLayout(new TransformedPathStub("bar.cs")));
            var subProject = layout.LookupProjectOrNull(new TransformedPathStub("foo.cs"));
            Assert.NotNull(subProject);
            var f1 = subProject!.GetTrapPath(logger, new TransformedPathStub("foo.cs"), TrapWriter.CompressionMode.Gzip);
            var g1 = TrapWriter.NestPaths(logger, Path.GetFullPath("snapshot\\trap"), "foo.cs.trap.gz");
            Assert.Equal(f1, g1);
        }

        [Fact]
        public void TestMultipleSections()
        {
            File.WriteAllLines("layout.txt", new string[]
            {
                "# Section 1",
                "TRAP_FOLDER=" + Path.GetFullPath("snapshot\\trap1"),
                "ODASA_DB=snapshot\\db-csharp",
                "SOURCE_ARCHIVE=" + Path.GetFullPath("snapshot\\archive1"),
                "ODASA_BUILD_ERROR_DIR=snapshot\build-errors",
                "foo.cs",
                "# Section 2",
                "TRAP_FOLDER=" + Path.GetFullPath("snapshot\\trap2"),
                "ODASA_DB=snapshot\\db-csharp",
                "SOURCE_ARCHIVE=" + Path.GetFullPath("snapshot\\archive2"),
                "ODASA_BUILD_ERROR_DIR=snapshot\build-errors",
                "bar.cs",
            });

            var layout = new Semmle.Extraction.Layout(null, null, "layout.txt");

            // Use Section 2
            Assert.True(layout.FileInLayout(new TransformedPathStub("bar.cs")));
            var subProject = layout.LookupProjectOrNull(new TransformedPathStub("bar.cs"));
            Assert.NotNull(subProject);
            var f1 = subProject!.GetTrapPath(logger, new TransformedPathStub("bar.cs"), TrapWriter.CompressionMode.Gzip);
            var g1 = TrapWriter.NestPaths(logger, Path.GetFullPath("snapshot\\trap2"), "bar.cs.trap.gz");
            Assert.Equal(f1, g1);

            // Use Section 1
            Assert.True(layout.FileInLayout(new TransformedPathStub("foo.cs")));
            subProject = layout.LookupProjectOrNull(new TransformedPathStub("foo.cs"));
            Assert.NotNull(subProject);
            var f2 = subProject!.GetTrapPath(logger, new TransformedPathStub("foo.cs"), TrapWriter.CompressionMode.Gzip);
            var g2 = TrapWriter.NestPaths(logger, Path.GetFullPath("snapshot\\trap1"), "foo.cs.trap.gz");
            Assert.Equal(f2, g2);

            // boo.dll is not in the layout, so use layout from first section.
            Assert.False(layout.FileInLayout(new TransformedPathStub("boo.dll")));
            var f3 = layout.LookupProjectOrDefault(new TransformedPathStub("boo.dll")).GetTrapPath(logger, new TransformedPathStub("boo.dll"), TrapWriter.CompressionMode.Gzip);
            var g3 = TrapWriter.NestPaths(logger, Path.GetFullPath("snapshot\\trap1"), "boo.dll.trap.gz");
            Assert.Equal(f3, g3);

            // boo.cs is not in the layout, so return null
            Assert.False(layout.FileInLayout(new TransformedPathStub("boo.cs")));
            Assert.Null(layout.LookupProjectOrNull(new TransformedPathStub("boo.cs")));
        }

        [Fact]
        public void MissingLayout()
        {
            Assert.Throws<Extraction.Layout.InvalidLayoutException>(() =>
               new Semmle.Extraction.Layout(null, null, "nosuchfile.txt"));
        }

        [Fact]
        public void EmptyLayout()
        {
            File.Create("layout.txt").Close();
            Assert.Throws<Extraction.Layout.InvalidLayoutException>(() =>
                new Semmle.Extraction.Layout(null, null, "layout.txt"));
        }

        [Fact]
        public void InvalidLayout()
        {
            File.WriteAllLines("layout.txt", new string[]
            {
                "# Section 1"
            });

            Assert.Throws<Extraction.Layout.InvalidLayoutException>(() =>
                new Semmle.Extraction.Layout(null, null, "layout.txt"));
        }

        private sealed class LoggerMock : ILogger
        {
            public void Dispose() { }

            public void Log(Severity s, string text) { }
        }
    }

    internal static class TrapWriterTestExtensions
    {
        public static void Emit(this TrapWriter trapFile, string s)
        {
            trapFile.Emit(new StringTrapEmitter(s));
        }

        private class StringTrapEmitter : ITrapEmitter
        {
            private readonly string content;
            public StringTrapEmitter(string content)
            {
                this.content = content;
            }

            public void EmitTrap(TextWriter trapFile)
            {
                trapFile.Write(content);
            }
        }
    }
}
