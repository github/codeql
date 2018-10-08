using Xunit;
using Semmle.Util;

namespace SemmleTests.Semmle.Util
{
    public class TestFileUtils
    {
        [Fact]
        public void TestConvertPaths()
        {
            Assert.Equal("/tmp/abc.cs", FileUtils.ConvertToUnix(@"\tmp\abc.cs"));
            Assert.Equal("tmp/abc.cs", FileUtils.ConvertToUnix(@"tmp\abc.cs"));

            Assert.Equal(@"\tmp\abc.cs", FileUtils.ConvertToWindows(@"/tmp/abc.cs"));
            Assert.Equal(@"tmp\abc.cs", FileUtils.ConvertToWindows(@"tmp/abc.cs"));

            Assert.Equal(Win32.IsWindows() ? @"foo\bar" : "foo/bar", FileUtils.ConvertToNative("foo/bar"));
        }
    }
}
