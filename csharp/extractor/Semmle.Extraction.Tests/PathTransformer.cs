using Semmle.Util;
using Xunit;

namespace Semmle.Extraction.Tests
{
    internal class PathCacheStub : IPathCache
    {
        public string GetCanonicalPath(string path) => path;
    }

    public class PathTransformerTests
    {
        [Fact]
        public void TestTransformerFile()
        {
            var spec = new string[]
            {
                @"#D:\src",
                @"C:\agent*\src//",
                @"-C:\agent*\src\external",
                @"",
                @"#empty",
                @"",
                @"#src2",
                @"/agent*//src",
                @"",
                @"#optsrc",
                @"opt/src//"
            };

            var pathTransformer = new PathTransformer(new PathCacheStub(), spec);

            // Windows-style matching
            Assert.Equal(@"C:/bar.cs", pathTransformer.Transform(@"C:\bar.cs").Value);
            Assert.Equal("D:/src/file.cs", pathTransformer.Transform(@"C:\agent42\src\file.cs").Value);
            Assert.Equal("D:/src/file.cs", pathTransformer.Transform(@"C:\agent43\src\file.cs").Value);
            Assert.Equal(@"C:/agent43/src/external/file.cs", pathTransformer.Transform(@"C:\agent43\src\external\file.cs").Value);

            // Linux-style matching
            Assert.Equal(@"src2/src/file.cs", pathTransformer.Transform(@"/agent/src/file.cs").Value);
            Assert.Equal(@"src2/src/file.cs", pathTransformer.Transform(@"/agent42/src/file.cs").Value);
            Assert.Equal(@"optsrc/file.cs", pathTransformer.Transform(@"/opt/src/file.cs").Value);
        }
    }
}
