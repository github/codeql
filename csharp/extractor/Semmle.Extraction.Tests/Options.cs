using Xunit;
using Semmle.Util.Logging;
using System;
using System.IO;
using Semmle.Util;
using System.Text.RegularExpressions;

namespace Semmle.Extraction.Tests
{
    public class OptionsTests
    {
        private CSharp.Options? options;
        private CSharp.Standalone.Options? standaloneOptions;

        public OptionsTests()
        {
            Environment.SetEnvironmentVariable("LGTM_INDEX_EXTRACTOR", "");
        }

        [Fact]
        public void DefaultOptions()
        {
            options = CSharp.Options.CreateWithEnvironment(Array.Empty<string>());
            Assert.True(options.Cache);
            Assert.False(options.CIL);
            Assert.Null(options.Framework);
            Assert.Null(options.CompilerName);
            Assert.Empty(options.CompilerArguments);
            Assert.True(options.Threads >= 1);
            Assert.Equal(Verbosity.Info, options.Verbosity);
            Assert.False(options.Console);
            Assert.False(options.ClrTracer);
            Assert.False(options.PDB);
            Assert.False(options.Fast);
            Assert.Equal(TrapWriter.CompressionMode.Brotli, options.TrapCompression);
        }

        [Fact]
        public void Threads()
        {
            options = CSharp.Options.CreateWithEnvironment(new string[] { "--threads", "3" });
            Assert.Equal(3, options.Threads);
        }

        [Fact]
        public void Cache()
        {
            options = CSharp.Options.CreateWithEnvironment(new string[] { "--nocache" });
            Assert.False(options.Cache);
        }

        [Fact]
        public void CIL()
        {
            options = CSharp.Options.CreateWithEnvironment(new string[] { "--cil" });
            Assert.True(options.CIL);
            options = CSharp.Options.CreateWithEnvironment(new string[] { "--cil", "--nocil" });
            Assert.False(options.CIL);
        }

        [Fact]
        public void CompilerArguments()
        {
            options = CSharp.Options.CreateWithEnvironment(new string[] { "x", "y", "z" });
            Assert.Equal("x", options.CompilerArguments[0]);
            Assert.Equal("y", options.CompilerArguments[1]);
            Assert.Equal("z", options.CompilerArguments[2]);
        }

        [Fact]
        public void VerbosityTests()
        {
            options = CSharp.Options.CreateWithEnvironment(new string[] { "--verbose" });
            Assert.Equal(Verbosity.Debug, options.Verbosity);

            options = CSharp.Options.CreateWithEnvironment(new string[] { "--verbosity", "0" });
            Assert.Equal(Verbosity.Off, options.Verbosity);

            options = CSharp.Options.CreateWithEnvironment(new string[] { "--verbosity", "1" });
            Assert.Equal(Verbosity.Error, options.Verbosity);

            options = CSharp.Options.CreateWithEnvironment(new string[] { "--verbosity", "2" });
            Assert.Equal(Verbosity.Warning, options.Verbosity);

            options = CSharp.Options.CreateWithEnvironment(new string[] { "--verbosity", "3" });
            Assert.Equal(Verbosity.Info, options.Verbosity);

            options = CSharp.Options.CreateWithEnvironment(new string[] { "--verbosity", "4" });
            Assert.Equal(Verbosity.Debug, options.Verbosity);

            options = CSharp.Options.CreateWithEnvironment(new string[] { "--verbosity", "5" });
            Assert.Equal(Verbosity.Trace, options.Verbosity);

            Assert.Throws<FormatException>(() => CSharp.Options.CreateWithEnvironment(new string[] { "--verbosity", "X" }));
        }

        [Fact]
        public void Console()
        {
            options = CSharp.Options.CreateWithEnvironment(new string[] { "--console" });
            Assert.True(options.Console);
        }

        [Fact]
        public void PDB()
        {
            options = CSharp.Options.CreateWithEnvironment(new string[] { "--pdb" });
            Assert.True(options.PDB);
        }

        [Fact]
        public void Compiler()
        {
            options = CSharp.Options.CreateWithEnvironment(new string[] { "--compiler", "foo" });
            Assert.Equal("foo", options.CompilerName);
        }

        [Fact]
        public void Framework()
        {
            options = CSharp.Options.CreateWithEnvironment(new string[] { "--framework", "foo" });
            Assert.Equal("foo", options.Framework);
        }

        [Fact]
        public void EnvironmentVariables()
        {
            Environment.SetEnvironmentVariable("LGTM_INDEX_EXTRACTOR", "--cil c");
            options = CSharp.Options.CreateWithEnvironment(new string[] { "a", "b" });
            Assert.True(options.CIL);
            Assert.Equal("a", options.CompilerArguments[0]);
            Assert.Equal("b", options.CompilerArguments[1]);
            Assert.Equal("c", options.CompilerArguments[2]);

            Environment.SetEnvironmentVariable("LGTM_INDEX_EXTRACTOR", "");
            Environment.SetEnvironmentVariable("LGTM_INDEX_EXTRACTOR", "--nocil");
            options = CSharp.Options.CreateWithEnvironment(new string[] { "--cil" });
            Assert.False(options.CIL);
        }

        [Fact]
        public void StandaloneDefaults()
        {
            standaloneOptions = CSharp.Standalone.Options.Create(Array.Empty<string>());
            Assert.Equal(0, standaloneOptions.DllDirs.Count);
            Assert.True(standaloneOptions.UseNuGet);
            Assert.True(standaloneOptions.UseMscorlib);
            Assert.False(standaloneOptions.SkipExtraction);
            Assert.Null(standaloneOptions.SolutionFile);
            Assert.True(standaloneOptions.ScanNetFrameworkDlls);
            Assert.False(standaloneOptions.Errors);
        }

        [Fact]
        public void StandaloneOptions()
        {
            standaloneOptions = CSharp.Standalone.Options.Create(new string[] { "--references:foo", "--silent", "--skip-nuget", "--skip-dotnet", "--exclude", "bar", "--nostdlib" });
            Assert.Equal("foo", standaloneOptions.DllDirs[0]);
            Assert.Equal("bar", standaloneOptions.Excludes[0]);
            Assert.Equal(Verbosity.Off, standaloneOptions.Verbosity);
            Assert.False(standaloneOptions.UseNuGet);
            Assert.False(standaloneOptions.UseMscorlib);
            Assert.False(standaloneOptions.ScanNetFrameworkDlls);
            Assert.False(standaloneOptions.Errors);
            Assert.False(standaloneOptions.Help);
        }

        [Fact]
        public void InvalidOptions()
        {
            standaloneOptions = CSharp.Standalone.Options.Create(new string[] { "--references:foo", "--silent", "--no-such-option" });
            Assert.True(standaloneOptions.Errors);
        }

        [Fact]
        public void ShowingHelp()
        {
            standaloneOptions = CSharp.Standalone.Options.Create(new string[] { "--help" });
            Assert.False(standaloneOptions.Errors);
            Assert.True(standaloneOptions.Help);
        }

        [Fact]
        public void Fast()
        {
            Environment.SetEnvironmentVariable("LGTM_INDEX_EXTRACTOR", "--fast");
            options = CSharp.Options.CreateWithEnvironment(Array.Empty<string>());
            Assert.True(options.Fast);
        }

        [Fact]
        public void ArchiveArguments()
        {
            using var sw = new StringWriter();
            var file = Path.GetTempFileName();

            try
            {
                File.AppendAllText(file, "Test");
                new string[] { "/noconfig", "@" + file }.WriteCommandLine(sw);
                Assert.Equal("Test", Regex.Replace(sw.ToString(), @"\t|\n|\r", ""));
            }
            finally
            {
                File.Delete(file);
            }
        }

        [Fact]
        public void CompressionTests()
        {
            Environment.SetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_OPTION_TRAP_COMPRESSION", "gzip");
            options = CSharp.Options.CreateWithEnvironment(Array.Empty<string>());
            Assert.Equal(TrapWriter.CompressionMode.Gzip, options.TrapCompression);

            Environment.SetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_OPTION_TRAP_COMPRESSION", "brotli");
            options = CSharp.Options.CreateWithEnvironment(Array.Empty<string>());
            Assert.Equal(TrapWriter.CompressionMode.Brotli, options.TrapCompression);

            Environment.SetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_OPTION_TRAP_COMPRESSION", "none");
            options = CSharp.Options.CreateWithEnvironment(Array.Empty<string>());
            Assert.Equal(TrapWriter.CompressionMode.None, options.TrapCompression);

            Environment.SetEnvironmentVariable("CODEQL_EXTRACTOR_CSHARP_OPTION_TRAP_COMPRESSION", null);
            options = CSharp.Options.CreateWithEnvironment(Array.Empty<string>());
            Assert.Equal(TrapWriter.CompressionMode.Brotli, options.TrapCompression);
        }
    }
}
