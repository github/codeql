using System;
using System.Collections.Generic;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal class RazorGenerator : DotnetSourceGeneratorBase<Razor>
    {
        public RazorGenerator(
            FileProvider fileProvider,
            FileContent fileContent,
            IDotNet dotnet,
            ICompilationInfoContainer compilationInfoContainer,
            ILogger logger,
            TemporaryDirectory tempWorkingDirectory,
            IEnumerable<string> references) : base(fileProvider, fileContent, dotnet, compilationInfoContainer, logger, tempWorkingDirectory, references)
        {
        }

        protected override bool IsEnabled()
        {
            var webViewExtractionOption = Environment.GetEnvironmentVariable(EnvironmentVariableNames.WebViewGeneration);
            if (webViewExtractionOption == null ||
                bool.TryParse(webViewExtractionOption, out var shouldExtractWebViews) &&
                shouldExtractWebViews)
            {
                compilationInfoContainer.CompilationInfos.Add(("WebView extraction enabled", "1"));
                return true;
            }

            compilationInfoContainer.CompilationInfos.Add(("WebView extraction enabled", "0"));
            return false;
        }

        protected override ICollection<string> AdditionalFiles => fileProvider.RazorViews;

        protected override string FileType => "Razor";

        protected override Razor GetSourceGenerator(Sdk sdk) => new Razor(sdk, dotnet, logger);
    }
}
