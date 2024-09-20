using Xunit;
using System;
using System.IO;
using System.Text.RegularExpressions;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.Tests
{
    public class OptionsTests
    {
        private CSharp.Options? options;
        private CSharp.Standalone.Options? standaloneOptions;

        [Fact]
        public void DefaultOptions()
        {
            options = CSharp.Options.CreateWithEnvironment(Array.Empty<string>());
            Assert.True(options.Cache);
            Assert.Null(options.Framework);
            Assert.Null(options.CompilerName);
            Assert.Empty(options.CompilerArguments);
            Assert.True(options.Threads >= 1);
            Assert.Equal(Verbosity.Info, options.LegacyVerbosity);
            Assert.False(options.Console);
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
            Assert.Equal(Verbosity.Debug, options.LegacyVerbosity);

            options = CSharp.Options.CreateWithEnvironment(new string[] { "--verbosity", "0" });
            Assert.Equal(Verbosity.Off, options.LegacyVerbosity);

            options = CSharp.Options.CreateWithEnvironment(new string[] { "--verbosity", "1" });
            Assert.Equal(Verbosity.Error, options.LegacyVerbosity);

            options = CSharp.Options.CreateWithEnvironment(new string[] { "--verbosity", "2" });
            Assert.Equal(Verbosity.Warning, options.LegacyVerbosity);

            options = CSharp.Options.CreateWithEnvironment(new string[] { "--verbosity", "3" });
            Assert.Equal(Verbosity.Info, options.LegacyVerbosity);

            options = CSharp.Options.CreateWithEnvironment(new string[] { "--verbosity", "4" });
            Assert.Equal(Verbosity.Debug, options.LegacyVerbosity);

            options = CSharp.Options.CreateWithEnvironment(new string[] { "--verbosity", "5" });
            Assert.Equal(Verbosity.Trace, options.LegacyVerbosity);

            Assert.Throws<FormatException>(() => CSharp.Options.CreateWithEnvironment(new string[] { "--verbosity", "X" }));
        }


        private const string extractorVariableName = "CODEQL_EXTRACTOR_CSHARP_OPTION_LOGGING_VERBOSITY";
        private const string cliVariableName = "CODEQL_VERBOSITY";

        private void CheckVerbosity(string? extractor, string? cli, Verbosity expected)
        {
            var currentExtractorVerbosity = Environment.GetEnvironmentVariable(extractorVariableName);
            var currentCliVerbosity = Environment.GetEnvironmentVariable(cliVariableName);
            try
            {
                Environment.SetEnvironmentVariable(extractorVariableName, extractor);
                Environment.SetEnvironmentVariable(cliVariableName, cli);

                options = CSharp.Options.CreateWithEnvironment(new string[] { "--verbose" });
                Assert.Equal(expected, options.Verbosity);
            }
            finally
            {
                Environment.SetEnvironmentVariable(extractorVariableName, currentExtractorVerbosity);
                Environment.SetEnvironmentVariable(cliVariableName, currentCliVerbosity);
            }
        }

        [Fact]
        public void VerbosityTests_WithExtractorOption()
        {
            CheckVerbosity("progress+++", "progress++", Verbosity.All);
            CheckVerbosity(null, "progress++", Verbosity.Trace);
            CheckVerbosity(null, null, Verbosity.Debug);
        }

        [Fact]
        public void Console()
        {
            options = CSharp.Options.CreateWithEnvironment(new string[] { "--console" });
            Assert.True(options.Console);
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
        public void StandaloneDefaults()
        {
            standaloneOptions = CSharp.Standalone.Options.Create(Array.Empty<string>());
            Assert.False(standaloneOptions.Errors);
        }

        [Fact]
        public void StandaloneOptions()
        {
            standaloneOptions = CSharp.Standalone.Options.Create(new string[] { "--silent" });
            Assert.Equal(Verbosity.Off, standaloneOptions.LegacyVerbosity);
            Assert.False(standaloneOptions.Errors);
            Assert.False(standaloneOptions.Help);
        }

        [Fact]
        public void InvalidOptions()
        {
            standaloneOptions = CSharp.Standalone.Options.Create(new string[] { "--silent", "--no-such-option" });
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
        public void ArchiveArguments()
        {
            using var sw = new StringWriter();
            var file = Path.GetTempFileName();

            try
            {
                File.AppendAllText(file, "Test");
                sw.WriteContentFromArgumentFile(new string[] { "/noconfig", $"@{file}" });
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
