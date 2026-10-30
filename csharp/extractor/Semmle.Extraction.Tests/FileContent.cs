using Xunit;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using Semmle.Extraction.CSharp.DependencyFetching;
using Semmle.Util.Logging;

namespace Semmle.Extraction.Tests
{
    internal class UnsafeFileReaderStub : IUnsafeFileReader
    {
        private readonly IReadOnlyDictionary<string, string> contents;
        public int OpenCount { get; private set; }
        public MemoryStream? LastStream { get; private set; }

        public UnsafeFileReaderStub(IReadOnlyDictionary<string, string> contents)
        {
            this.contents = contents;
        }

        public Stream OpenRead(string file)
        {
            OpenCount++;
            LastStream = new MemoryStream(Encoding.UTF8.GetBytes(contents[file]));
            return LastStream;
        }
    }

    internal class TestFileContent : FileContent
    {
        public TestFileContent(string content, string file = "test1.csproj") : base(new LoggerStub(),
            new[] { file },
            new UnsafeFileReaderStub(new Dictionary<string, string> { [file] = content }))
        { }
    }

    public class FileContentTests
    {
        /// <summary>
        /// Verifies that `FileContent` correctly identifies SDK project structure, package references, and no ASP.NET Core usage.
        /// </summary>
        [Fact]
        public void TestFileContent_ProjectSdkAndNoAspNet()
        {
            // Setup
            var lines =
            """
            <Project Sdk="Microsoft.NET.Sdk">
              <PackageReference Include="DotNetAnalyzers.DocumentationAnalyzers" Version="1.0.0-beta.59" PrivateAssets="all" />
              <PackageReference Version="7.0.0" Include="Microsoft.CodeAnalysis.NetAnalyzers" PrivateAssets="all" />
              <PackageReference Include="StyleCop.Analyzers" Version="1.2.0-beta.406"></PackageReference>
              <!-- <PackageReference Include="NUnit" Version="3.10.1" /> -->
              <FrameworkReference Include="My.Framework"/>
            </Project>
            """;
            var fileContent = new TestFileContent(lines);

            // Execute
            var allPackages = fileContent.AllPackages;
            var isSdkProject = fileContent.IsSdkProjectStructureUsed;
            var useAspNetDlls = fileContent.UseAspNetCoreDlls;

            // Verify
            Assert.False(useAspNetDlls);
            Assert.True(isSdkProject);
            Assert.Equal(3, allPackages.Count);
            Assert.Contains(new PackageReference("DotNetAnalyzers.DocumentationAnalyzers".ToLowerInvariant(), PackageReferenceSource.SdkCsProj), allPackages);
            Assert.Contains(new PackageReference("Microsoft.CodeAnalysis.NetAnalyzers".ToLowerInvariant(), PackageReferenceSource.SdkCsProj), allPackages);
            Assert.Contains(new PackageReference("StyleCop.Analyzers".ToLowerInvariant(), PackageReferenceSource.SdkCsProj), allPackages);
        }

        /// <summary>
        /// Verifies that `FileContent` correctly identifies package references and ASP.NET Core usage.
        /// </summary>
        [Fact]
        public void TestFileContent2()
        {
            // Setup
            var lines =
            """
            <Project Sdk="Microsoft.NET.Sdk.Web">
              <FrameworkReference Include="My.Framework"/>
              <PackageReference Version="7.0.0" Include="Microsoft.CodeAnalysis.NetAnalyzers" PrivateAssets="all" />
              <PackageReference Include="StyleCop.Analyzers" Version="1.2.0-beta.406" />
            </Project>
            """;
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

        /// <summary>
        /// Verifies that `FileContent` correctly identifies the use of implicit usings.
        /// </summary>
        [Theory]
        [InlineData("<ImplicitUsings>false</ImplicitUsings>", false)]
        [InlineData("<ImplicitUsings>true</ImplicitUsings>", true)]
        [InlineData("<ImplicitUsings>enable</ImplicitUsings>", true)]
        public void TestFileContent_ImplicitUsings(string content, bool expectedImplicitUsings)
        {
            // Setup
            var fileContent = new TestFileContent(content);

            // Execute
            var actual = fileContent.UseImplicitUsings;

            // Verify
            Assert.Equal(expectedImplicitUsings, actual);
        }

        /// <summary>
        /// Verifies that `FileContent` correctly identifies the use of WPF.
        /// </summary>
        [Theory]
        [InlineData("<UseWPF>false</UseWPF>", false)]
        [InlineData("<UseWPF>true</UseWPF>", true)]
        public void TestFileContent_UseWpf(string content, bool expectedUseWpf)
        {
            // Setup
            var fileContent = new TestFileContent(content);

            // Execute
            var actual = fileContent.UseWpf;

            // Verify
            Assert.Equal(expectedUseWpf, actual);
        }

        /// <summary>
        /// Verifies that `FileContent` correctly identifies the use of Windows Forms.
        /// </summary>
        [Theory]
        [InlineData("<UseWindowsForms>false</UseWindowsForms>", false)]
        [InlineData("<UseWindowsForms>true</UseWindowsForms>", true)]
        public void TestFileContent_UseWindowsForms(string content, bool expectedUseWindowsForms)
        {
            // Setup
            var fileContent = new TestFileContent(content);

            // Execute
            var actual = fileContent.UseWindowsForms;

            // Verify
            Assert.Equal(expectedUseWindowsForms, actual);
        }

        /// <summary>
        /// Verifies that `FileContent` correctly identifies custom implicit usings.
        /// </summary>
        [Fact]
        public void TestFileContent_ImplicitUsingsAdditional()
        {
            // Setup
            var content =
            """
            <Project>
              <Using Include="Ns0.Ns1" />
              <Using Include="Ns2" />
              <Using Remove="Ns3" />
            </Project>
            """;
            var fileContent = new TestFileContent(content);

            // Execute
            var customImplicitUsings = fileContent.CustomImplicitUsings;

            // Verify
            Assert.Equal(["Ns0.Ns1", "Ns2"], customImplicitUsings);
        }

        /// <summary>
        /// Verifies that `FileContent` correctly identifies legacy project structure.
        /// </summary>
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
            </Project>
            """;
            var fileContent = new TestFileContent(input);

            // Execute
            var isLegacy = fileContent.IsLegacyProjectStructureUsed;
            var isSdk = fileContent.IsSdkProjectStructureUsed;

            // Verify
            Assert.True(isLegacy);
            Assert.False(isSdk);
        }

        /// <summary>
        /// Verifies that `FileContent` correctly identifies SDK project structure.
        /// </summary>
        [Fact]
        public void TestFileContent_SdkProjectStructure()
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
            var fileContent = new TestFileContent(input);

            // Execute
            var isLegacy = fileContent.IsLegacyProjectStructureUsed;
            var isSdk = fileContent.IsSdkProjectStructureUsed;

            // Verify
            Assert.True(isSdk);
            Assert.False(isLegacy);
        }

        /// <summary>
        /// Verifies that `FileContent` correctly handles XML syntax with namespaces and various elements.
        /// </summary>
        [Fact]
        public void TestFileContent_XmlSyntax()
        {
            // Setup
            var input =
            """
            <msb:Project xmlns:msb="http://schemas.microsoft.com/developer/msbuild/2003"
                         Sdk='Microsoft.NET.Sdk'>
              <msb:ItemGroup>
                <msb:PackageReference
                    Version='1.0' Include='My.Package' />
                <msb:PackageReference Include='Other.Package'><Version>2.0</Version></msb:PackageReference>
                <msb:PackageReference Update='Ignored.Package' />
                <msb:PackageReference Include='' />
                <msb:FrameworkReference
                    Include='Microsoft.AspNetCore.App' />
                <msb:Using Include='My.&#78;amespace' />
              </msb:ItemGroup>
              <msb:PropertyGroup>
                <msb:ImplicitUsings>
                  ENABLE
                </msb:ImplicitUsings><msb:UseWPF> true </msb:UseWPF>
                <msb:UseWindowsForms><![CDATA[true]]></msb:UseWindowsForms>
              </msb:PropertyGroup>
            </msb:Project>
            """;
            var fileContent = new TestFileContent(input);

            // Execute
            var allPackages = fileContent.AllPackages;
            var isAspNetCoreDetected = fileContent.IsAspNetCoreDetected;
            var useImplicitUsings = fileContent.UseImplicitUsings;
            var useWpf = fileContent.UseWpf;
            var useWindowsForms = fileContent.UseWindowsForms;
            var customImplicitUsings = fileContent.CustomImplicitUsings;

            // Verify
            Assert.Equal(2, allPackages.Count);
            Assert.Contains(new PackageReference("my.package", PackageReferenceSource.SdkCsProj), allPackages);
            Assert.Contains(new PackageReference("other.package", PackageReferenceSource.SdkCsProj), allPackages);
            Assert.True(isAspNetCoreDetected);
            Assert.True(useImplicitUsings);
            Assert.True(useWpf);
            Assert.True(useWindowsForms);
            Assert.Equal(["My.Namespace"], customImplicitUsings);
        }

        /// <summary>
        /// Verify that `FileContent` correctly ignores commented-out XML elements.
        /// </summary>
        [Fact]
        public void TestFileContent_CommentsAreIgnored()
        {
            // Setup
            var input =
            """
            <Project>
              <!--
              <Project Sdk="Microsoft.NET.Sdk.Web" />
              <PackageReference Include="Ignored.Package" />
              <FrameworkReference Include="Microsoft.AspNetCore.App" />
              <ImplicitUsings>true</ImplicitUsings>
              <UseWPF>true</UseWPF>
              <UseWindowsForms>true</UseWindowsForms>
              <Using Include="Ignored.Namespace" />
              <Import Project="Microsoft.CSharp.targets" />
              -->
            </Project>
            """;
            var fileContent = new TestFileContent(input);

            // Execute
            var allPackages = fileContent.AllPackages;
            var isAspNetCoreDetected = fileContent.IsAspNetCoreDetected;
            var useImplicitUsings = fileContent.UseImplicitUsings;
            var useWpf = fileContent.UseWpf;
            var useWindowsForms = fileContent.UseWindowsForms;
            var customImplicitUsings = fileContent.CustomImplicitUsings;
            var isLegacyProjectStructureUsed = fileContent.IsLegacyProjectStructureUsed;
            var isSdkProjectStructureUsed = fileContent.IsSdkProjectStructureUsed;

            // Verify
            Assert.Empty(allPackages);
            Assert.Empty(customImplicitUsings);
            Assert.False(isAspNetCoreDetected);
            Assert.False(useImplicitUsings);
            Assert.False(useWpf);
            Assert.False(useWindowsForms);
            Assert.False(isLegacyProjectStructureUsed);
            Assert.False(isSdkProjectStructureUsed);
        }

        /// <summary>
        /// Verify that `FileContent` correctly reads package references from a `packages.config` file.
        /// </summary>
        [Fact]
        public void TestFileContent_PackagesConfig()
        {
            // Setup
            var input =
            """
            <?xml version="1.0" encoding="utf-8"?>
            <packages>
              <package
                  version='1.0' id='My.Package' />
              <package id="Other.Package" version="2.0" />
              <package id="" />
              <package />
              <!-- <package id="Ignored.Package" /> -->
              <PackageReference Include="Ignored.Package" />
            </packages>
            """;
            var fileContent = new TestFileContent(input, "PACKAGES.CONFIG");

            // Execute
            var allPackages = fileContent.AllPackages;

            // Verify
            Assert.Equal(2, allPackages.Count);
            Assert.Contains(new PackageReference("my.package", PackageReferenceSource.PackagesConfig), allPackages);
            Assert.Contains(new PackageReference("other.package", PackageReferenceSource.PackagesConfig), allPackages);
        }

        private sealed class RecordingLogger : ILogger
        {
            public List<string> Messages { get; } = new List<string>();
            public void Log(Severity severity, string message, int? threadId = null) => Messages.Add(message);
            public void Dispose() { }
        }

        /// <summary>
        /// Verify that `FileContent` correctly handles invalid XML files without preventing reading other valid files.
        /// </summary>
        [Theory]
        [InlineData("This is not XML.")]
        [InlineData("<Project><PackageReference Include='Incomplete'")]
        [InlineData("<!DOCTYPE Project [<!ENTITY sdk 'Microsoft.NET.Sdk.Web'>]><Project Sdk='&sdk;' />")]
        public void TestFileContent_InvalidXmlDoesNotPreventReadingOtherFiles(string invalidXml)
        {
            // Setup
            var logger = new RecordingLogger();
            var stub = new UnsafeFileReaderStub(new Dictionary<string, string>
            {
                ["invalid.csproj"] = invalidXml,
                ["valid.csproj"] = "<Project Sdk='Microsoft.NET.Sdk.Web'><PackageReference Include='My.Package' /></Project>"
            });
            var fileContent = new FileContent(logger, ["invalid.csproj", "valid.csproj"], stub);

            // Execute
            var allPackages = fileContent.AllPackages;
            var isAspNetCoreDetected = fileContent.IsAspNetCoreDetected;

            // Verify
            Assert.True(isAspNetCoreDetected);
            Assert.Contains(new PackageReference("my.package", PackageReferenceSource.SdkCsProj), allPackages);
            Assert.Contains("Failed to parse invalid.csproj as an XML file.", logger.Messages);
            Assert.Equal(2, stub.OpenCount);
        }
    }
}
