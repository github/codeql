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
        public TestFileContent(IEnumerable<string> lines) : base(new LoggerStub(),
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
                "<!-- <PackageReference Include=\"NUnit\" Version=\"3.10.1\" /> -->",
                "<FrameworkReference Include=\"My.Framework\"/>"
            };
            var fileContent = new TestFileContent(lines);

            // Execute
            var allPackages = fileContent.AllPackages;
            var useAspNetDlls = fileContent.UseAspNetCoreDlls;

            // Verify
            Assert.False(useAspNetDlls);
            Assert.Equal(3, allPackages.Count);
            Assert.Contains(new PackageReference("DotNetAnalyzers.DocumentationAnalyzers".ToLowerInvariant(), PackageReferenceSource.SdkCsProj), allPackages);
            Assert.Contains(new PackageReference("Microsoft.CodeAnalysis.NetAnalyzers".ToLowerInvariant(), PackageReferenceSource.SdkCsProj), allPackages);
            Assert.Contains(new PackageReference("StyleCop.Analyzers".ToLowerInvariant(), PackageReferenceSource.SdkCsProj), allPackages);
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
            Assert.Contains(new PackageReference("Microsoft.CodeAnalysis.NetAnalyzers".ToLowerInvariant(), PackageReferenceSource.SdkCsProj), allPackages);
            Assert.Contains(new PackageReference("StyleCop.Analyzers".ToLowerInvariant(), PackageReferenceSource.SdkCsProj), allPackages);
        }

        private static void CsProjSettingsTest(string line, bool expected, Func<FileContent, bool> func)
        {
            // Setup
            var lines = new List<string>()
                {
                    line
                };
            var fileContent = new TestFileContent(lines);

            // Execute
            var actual = func(fileContent);

            // Verify
            Assert.Equal(expected, actual);
        }

        [Fact]
        public void TestFileContent_ImplicitUsings0()
        {
            CsProjSettingsTest("<ImplicitUsings>false</ImplicitUsings>", false, fc => fc.UseImplicitUsings);
        }

        [Fact]
        public void TestFileContent_ImplicitUsings1()
        {
            CsProjSettingsTest("<ImplicitUsings>true</ImplicitUsings>", true, fc => fc.UseImplicitUsings);
        }

        [Fact]
        public void TestFileContent_ImplicitUsings2()
        {
            CsProjSettingsTest("<ImplicitUsings>enable</ImplicitUsings>", true, fc => fc.UseImplicitUsings);
        }

        [Fact]
        public void TestFileContent_UseWpf0()
        {
            CsProjSettingsTest("<UseWPF>false</UseWPF>", false, fc => fc.UseWpf);
        }

        [Fact]
        public void TestFileContent_UseWpf1()
        {
            CsProjSettingsTest("<UseWPF>true</UseWPF>", true, fc => fc.UseWpf);
        }

        [Fact]
        public void TestFileContent_UseWindowsForms0()
        {
            CsProjSettingsTest("<UseWindowsForms>false</UseWindowsForms>", false, fc => fc.UseWindowsForms);
        }

        [Fact]
        public void TestFileContent_UseWindowsForms1()
        {
            CsProjSettingsTest("<UseWindowsForms>true</UseWindowsForms>", true, fc => fc.UseWindowsForms);
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
