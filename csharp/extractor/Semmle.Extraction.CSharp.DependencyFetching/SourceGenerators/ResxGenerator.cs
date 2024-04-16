using System;
using System.Collections.Generic;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal class ResxGenerator : DotnetSourceGeneratorBase<Resx>
    {
        private readonly string? sourceGeneratorFolder = null;

        public ResxGenerator(
            FileProvider fileProvider,
            FileContent fileContent,
            IDotNet dotnet,
            ICompilationInfoContainer compilationInfoContainer,
            ILogger logger,
            TemporaryDirectory tempWorkingDirectory,
            IEnumerable<string> references) : base(fileProvider, fileContent, dotnet, compilationInfoContainer, logger, tempWorkingDirectory, references)
        {
            try
            {
                // todo: download latest `Microsoft.CodeAnalysis.ResxSourceGenerator` and set `sourceGeneratorFolder`
            }
            catch (Exception e)
            {
                logger.LogWarning($"Failed to download source generator: {e.Message}");
                sourceGeneratorFolder = null;
            }
        }

        protected override bool IsEnabled()
        {
            var resourceExtractionOption = Environment.GetEnvironmentVariable(EnvironmentVariableNames.ResourceGeneration);
            if (resourceExtractionOption == null ||
                bool.TryParse(resourceExtractionOption, out var shouldExtractResources) &&
                shouldExtractResources)
            {
                compilationInfoContainer.CompilationInfos.Add(("Resource extraction enabled", "1"));
                return true;
            }

            compilationInfoContainer.CompilationInfos.Add(("Resource extraction enabled", "0"));
            return false;
        }

        protected override ICollection<string> AdditionalFiles => fileProvider.Resources;

        protected override string FileType => "Resx";

        protected override Resx GetSourceGenerator(Sdk sdk) => new Resx(sdk, dotnet, logger, sourceGeneratorFolder);
    }
}
