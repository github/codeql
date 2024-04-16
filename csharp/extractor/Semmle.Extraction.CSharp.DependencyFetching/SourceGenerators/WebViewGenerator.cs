using System;
using System.Collections.Generic;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal class WebViewGenerator : SourceGeneratorBase
    {
        private readonly FileProvider fileProvider;
        private readonly FileContent fileContent;
        private readonly IDotNet dotnet;
        private readonly ICompilationInfoContainer compilationInfoContainer;
        private readonly IEnumerable<string> references;

        public WebViewGenerator(
            FileProvider fileProvider,
            FileContent fileContent,
            IDotNet dotnet,
            ICompilationInfoContainer compilationInfoContainer,
            ILogger logger,
            TemporaryDirectory tempWorkingDirectory,
            IEnumerable<string> references) : base(logger, tempWorkingDirectory)
        {
            this.fileProvider = fileProvider;
            this.fileContent = fileContent;
            this.dotnet = dotnet;
            this.compilationInfoContainer = compilationInfoContainer;
            this.references = references;
        }

        public override IEnumerable<string> Generate()
        {
            var webViewExtractionOption = Environment.GetEnvironmentVariable(EnvironmentVariableNames.WebViewGeneration);
            if (webViewExtractionOption == null ||
                bool.TryParse(webViewExtractionOption, out var shouldExtractWebViews) &&
                shouldExtractWebViews)
            {
                compilationInfoContainer.CompilationInfos.Add(("WebView extraction enabled", "1"));
                return GenerateSourceFilesFromWebViews();
            }

            compilationInfoContainer.CompilationInfos.Add(("WebView extraction enabled", "0"));
            return [];
        }

        private IEnumerable<string> GenerateSourceFilesFromWebViews()
        {
            var views = fileProvider.RazorViews;
            if (views.Count == 0)
            {
                logger.LogDebug("No cshtml or razor files found.");
                return [];
            }

            logger.LogInfo($"Found {views.Count} cshtml and razor files.");

            if (!fileContent.IsAspNetCoreDetected)
            {
                logger.LogInfo("Generating source files from cshtml files is only supported for new (SDK-style) project files");
                return [];
            }

            logger.LogInfo("Generating source files from cshtml and razor files...");

            var sdk = new Sdk(dotnet).GetNewestSdk();
            if (sdk != null)
            {
                try
                {
                    var razor = new Razor(sdk, dotnet, logger);
                    var targetDir = GetTemporaryWorkingDirectory("razor");
                    var generatedFiles = razor.GenerateFiles(views, references, targetDir);
                    return generatedFiles ?? [];
                }
                catch (Exception ex)
                {
                    // It's okay, we tried our best to generate source files from cshtml files.
                    logger.LogInfo($"Failed to generate source files from cshtml files: {ex.Message}");
                }
            }

            return [];
        }
    }
}
