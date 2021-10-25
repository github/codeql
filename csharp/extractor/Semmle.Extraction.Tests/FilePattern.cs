using Xunit;

namespace Semmle.Extraction.Tests
{
    public class FilePatternTests
    {
        [Fact]
        public void TestRegexCompilation()
        {
            var fp = new FilePattern("/hadoop*");
            Assert.Equal("^hadoop[^/]*.*", fp.RegexPattern);
            fp = new FilePattern("**/org/apache/hadoop");
            Assert.Equal("^.*/org/apache/hadoop.*", fp.RegexPattern);
            fp = new FilePattern("hadoop-common/**/test//    ");
            Assert.Equal("^hadoop-common/.*/test(?<doubleslash>/).*", fp.RegexPattern);
            fp = new FilePattern(@"-C:\agent\root\asdf//");
            Assert.Equal("^C:/agent/root/asdf(?<doubleslash>/).*", fp.RegexPattern);
            fp = new FilePattern(@"-C:\agent+\[root]\asdf//");
            Assert.Equal(@"^C:/agent\+/\[root]/asdf(?<doubleslash>/).*", fp.RegexPattern);
        }

        [Fact]
        public void TestMatching()
        {
            var fp1 = new FilePattern(@"C:\agent\root\abc//");
            var fp2 = new FilePattern(@"C:\agent\root\def//ghi");
            var patterns = new[] { fp1, fp2 };

            var success = FilePattern.Matches(patterns, @"C:\agent\root\abc\file.cs", out var s);
            Assert.True(success);
            Assert.Equal("/file.cs", s);

            success = FilePattern.Matches(patterns, @"C:\agent\root\def\ghi\file.cs", out s);
            Assert.True(success);
            Assert.Equal("/ghi/file.cs", s);

            success = FilePattern.Matches(patterns, @"C:\agent\root\def\file.cs", out _);
            Assert.False(success);
        }

        [Fact]
        public void TestInvalidPatterns()
        {
            Assert.Throws<InvalidFilePatternException>(() => new FilePattern("/abc//def//ghi"));
            Assert.Throws<InvalidFilePatternException>(() => new FilePattern("/abc**def"));
        }
    }
}
