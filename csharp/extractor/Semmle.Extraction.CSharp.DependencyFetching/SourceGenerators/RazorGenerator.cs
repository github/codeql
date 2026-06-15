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
            var webViewExtractionOption = EnvironmentVariables.GetBooleanOptOut(EnvironmentVariableNames.WebViewGeneration);
            compilationInfoContainer.CompilationInfos.Add(("WebView extraction enabled", webViewExtractionOption ? "1" : "0"));
            return webViewExtractionOption;
        }

        protected override ICollection<string> AdditionalFiles => fileProvider.RazorViews;

        protected override string FileType => "Razor";

        protected override Razor GetSourceGenerator(Sdk sdk) => new Razor(sdk, dotnet, logger);
    }
}
