using Xunit;
using System;
using System.Collections.Generic;
using Semmle.Extraction.CSharp.DependencyFetching;

namespace Semmle.Extraction.Tests
{
    internal class UnsafeFileReaderStub : IUnsafeFileReader
    {
        private readonly IEnumerable<string> lines;

        public UnsafeFileReaderStub(IEnumerable<string> lines)
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
        public TestFileContent(IEnumerable<string> lines) : base(new ProgressMonitor(new LoggerStub()),
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
            var useAspNetDlls = fileContent.UseAspNetCoreDlls;

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
            var useAspNetDlls = fileContent.UseAspNetCoreDlls;
            var allPackages = fileContent.AllPackages;

            // Verify
            Assert.True(useAspNetDlls);
            Assert.Equal(2, allPackages.Count);
            Assert.Contains("Microsoft.CodeAnalysis.NetAnalyzers".ToLowerInvariant(), allPackages);
            Assert.Contains("StyleCop.Analyzers".ToLowerInvariant(), allPackages);
        }

        private static void ImplicitUsingsTest(string line, bool expected)
        {
            // Setup
            var lines = new List<string>()
                {
                    line
                };
            var fileContent = new TestFileContent(lines);

            // Execute
            var useImplicitUsings = fileContent.UseImplicitUsings;

            // Verify
            Assert.Equal(expected, useImplicitUsings);
        }

        [Fact]
        public void TestFileContent_ImplicitUsings0()
        {
            ImplicitUsingsTest("<ImplicitUsings>false</ImplicitUsings>", false);
        }

        [Fact]
        public void TestFileContent_ImplicitUsings1()
        {
            ImplicitUsingsTest("<ImplicitUsings>true</ImplicitUsings>", true);
        }

        [Fact]
        public void TestFileContent_ImplicitUsings2()
        {
            ImplicitUsingsTest("<ImplicitUsings>enable</ImplicitUsings>", true);
        }

        [Fact]
        public void TestFileContent_ImplicitUsingsAdditional()
        {
            // Setup
            var lines = new List<string>()
                {
                    "<Using Include=\"Ns0.Ns1\" />",
                    "<Using Include=\"Ns2\" />",
                    "<Using Remove=\"Ns3\" />",
                };
            var fileContent = new TestFileContent(lines);

            // Execute
            var customImplicitUsings = fileContent.CustomImplicitUsings;

            // Verify
            Assert.Equal(2, customImplicitUsings.Count);
            Assert.Contains("Ns0.Ns1", customImplicitUsings);
            Assert.Contains("Ns2", customImplicitUsings);
        }

        [Fact]
        public void TestFileContent_LegacyProjectStructure()
        {
            // Setup
            var input =
            """
            <?xml version="1.0" encoding="utf-8"?>
            <Project ToolsVersion="12.0" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
              <Import Project="$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props" Condition="Exists('$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props')" />
              <Import Project="$(MSBuildBinPath)\Microsoft.CSharp.targets" />
            """;
            var lines = input.Split(Environment.NewLine);
            var fileContent = new TestFileContent(lines);

            // Execute
            var isLegacy = fileContent.IsLegacyProjectStructureUsed;
            var isNew = fileContent.IsNewProjectStructureUsed;

            // Verify
            Assert.True(isLegacy);
            Assert.False(isNew);
        }

        [Fact]
        public void TestFileContent_NewProjectStructure()
        {
            // Setup
            var input =
            """
            <Project Sdk="Microsoft.NET.Sdk">
             <PropertyGroup>
              <TargetFrameworks>net461;net70</TargetFrameworks>
             </PropertyGroup>
            </Project>
            """;
            var lines = input.Split(Environment.NewLine);

            var fileContent = new TestFileContent(lines);

            // Execute
            var isLegacy = fileContent.IsLegacyProjectStructureUsed;
            var isNew = fileContent.IsNewProjectStructureUsed;

            // Verify
            Assert.True(isNew);
            Assert.False(isLegacy);
        }
    }
}
