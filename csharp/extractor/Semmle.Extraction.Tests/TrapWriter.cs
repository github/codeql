using Xunit;
using Semmle.Util.Logging;
using Semmle.Util;
using System.Runtime.InteropServices;
using System.IO;

namespace Semmle.Extraction.Tests
{
    public class TrapWriterTests
    {
        [Fact]
        public void NestedPaths()
        {
            var tempDir = System.IO.Path.GetTempPath();
            string root1, root2, root3;

            if (Win32.IsWindows())
            {
                root1 = "E:";
                root2 = "e:";
                root3 = @"\";
            }
            else
            {
                root1 = "/E_";
                root2 = "/e_";
                root3 = "/";
            }

            var formattedTempDir = tempDir.Replace('/', '\\').Replace(':', '_').Trim('\\');

            var logger = new LoggerMock();
            System.IO.Directory.SetCurrentDirectory(tempDir);

            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            {
                // `Directory.SetCurrentDirectory()` doesn't seem to work on macOS,
                // so disable this test on macOS, for now
                Assert.NotEqual(Directory.GetCurrentDirectory(), tempDir);
                return;
            }

            Assert.Equal($@"C:\Temp\source_archive\{formattedTempDir}\def.cs", TrapWriter.NestPaths(logger, @"C:\Temp\source_archive", "def.cs", TrapWriter.InnerPathComputation.ABSOLUTE).Replace('/', '\\'));

            Assert.Equal(@"C:\Temp\source_archive\def.cs", TrapWriter.NestPaths(logger, @"C:\Temp\source_archive", "def.cs", TrapWriter.InnerPathComputation.RELATIVE).Replace('/', '\\'));

            Assert.Equal(@"C:\Temp\source_archive\E_\source\def.cs", TrapWriter.NestPaths(logger, @"C:\Temp\source_archive", $@"{root1}\source\def.cs", TrapWriter.InnerPathComputation.ABSOLUTE).Replace('/', '\\'));

            Assert.Equal(@"C:\Temp\source_archive\e_\source\def.cs", TrapWriter.NestPaths(logger, @"C:\Temp\source_archive", $@"{root2}\source\def.cs", TrapWriter.InnerPathComputation.RELATIVE).Replace('/', '\\'));

            Assert.Equal(@"C:\Temp\source_archive\source\def.cs", TrapWriter.NestPaths(logger, @"C:\Temp\source_archive", $@"{root3}source\def.cs", TrapWriter.InnerPathComputation.ABSOLUTE).Replace('/', '\\'));

            Assert.Equal(@"C:\Temp\source_archive\source\def.cs", TrapWriter.NestPaths(logger, @"C:\Temp\source_archive", $@"{root3}source\def.cs", TrapWriter.InnerPathComputation.RELATIVE).Replace('/', '\\'));

            Assert.Equal(@"C:\Temp\source_archive\diskstation\share\source\def.cs", TrapWriter.NestPaths(logger, @"C:\Temp\source_archive", $@"{root3}{root3}diskstation\share\source\def.cs", TrapWriter.InnerPathComputation.ABSOLUTE).Replace('/', '\\'));
        }

        class LoggerMock : ILogger
        {
            public void Dispose() { }

            public void Log(Severity s, string text) { }
        }
    }
}
