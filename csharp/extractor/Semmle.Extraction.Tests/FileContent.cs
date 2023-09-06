using Xunit;
using System.Collections.Generic;
using System.Linq;
using Semmle.Util.Logging;
using Semmle.Extraction.CSharp.DependencyFetching;

namespace Semmle.Extraction.Tests
{

    internal class LoggerStub : ILogger
    {
        public void Log(Severity severity, string message) { }

        public void Dispose() { }
    }

    internal class UnsafeFileReaderStub : IUnsafeFileReader
    {
        private readonly List<string> lines;

        public UnsafeFileReaderStub(List<string> lines)
        {
            this.lines = lines;
        }

        public IEnumerable<string> ReadLines(string file)
        {
            foreach (var line in lines)
            {
                yield return line;
            }
        }
    }

    internal class TestFileContent : FileContent
    {
        public TestFileContent(List<string> lines) : base(new ProgressMonitor(new LoggerStub()),
            new List<string>() { "test1.cs" },
            new UnsafeFileReaderStub(lines))
        { }
    }

    public class FileContentTests
    {
        [Fact]
        public void TestFileContent1()
        {
            // Setup
            var lines = new List<string>()
            {
                "<Project Sdk=\"Microsoft.NET.Sdk\">",
                "<PackageReference Include=\"DotNetAnalyzers.DocumentationAnalyzers\" Version=\"1.0.0-beta.59\" PrivateAssets=\"all\" />",
                "<PackageReference Version=\"7.0.0\" Include=\"Microsoft.CodeAnalysis.NetAnalyzers\"PrivateAssets=\"all\" />",
                "<PackageReference Include=\"StyleCop.Analyzers\" Version=\"1.2.0-beta.406\">",
                "<FrameworkReference Include=\"My.Framework\"/>"
            };
            var fileContent = new TestFileContent(lines);

            // Execute
            var allPackages = fileContent.AllPackages;
            var useAspNetDlls = fileContent.UseAspNetDlls;

            // Verify
            Assert.False(useAspNetDlls);
            Assert.Equal(3, allPackages.Count);
            Assert.Contains("DotNetAnalyzers.DocumentationAnalyzers".ToLowerInvariant(), allPackages);
            Assert.Contains("Microsoft.CodeAnalysis.NetAnalyzers".ToLowerInvariant(), allPackages);
            Assert.Contains("StyleCop.Analyzers".ToLowerInvariant(), allPackages);
        }

        [Fact]
        public void TestFileContent2()
        {
            // Setup
            var lines = new List<string>()
                {
                    "<Project Sdk=\"Microsoft.NET.Sdk.Web\">",
                    "<FrameworkReference Include=\"My.Framework\"/>",
                    "<PackageReference Version=\"7.0.0\" Include=\"Microsoft.CodeAnalysis.NetAnalyzers\"PrivateAssets=\"all\" />",
                    "<PackageReference Include=\"StyleCop.Analyzers\" Version=\"1.2.0-beta.406\">"
                };
            var fileContent = new TestFileContent(lines);

            // Execute
            var useAspNetDlls = fileContent.UseAspNetDlls;
            var allPackages = fileContent.AllPackages;

            // Verify
            Assert.True(useAspNetDlls);
            Assert.Equal(2, allPackages.Count);
            Assert.Contains("Microsoft.CodeAnalysis.NetAnalyzers".ToLowerInvariant(), allPackages);
            Assert.Contains("StyleCop.Analyzers".ToLowerInvariant(), allPackages);
        }
    }
}
