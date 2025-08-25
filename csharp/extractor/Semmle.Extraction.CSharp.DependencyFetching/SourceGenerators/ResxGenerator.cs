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
            NugetPackageRestorer nugetPackageRestorer,
            TemporaryDirectory tempWorkingDirectory,
            IEnumerable<string> references) : base(fileProvider, fileContent, dotnet, compilationInfoContainer, logger, tempWorkingDirectory, references)
        {
            if (fileProvider.Resources.Count == 0)
            {
                logger.LogDebug("No resources found, skipping resource extraction.");
                sourceGeneratorFolder = null;
                return;
            }

            try
            {
                // The package is downloaded to `missingpackages`, which is okay, we're already after the DLL collection phase.
                var nugetFolder = nugetPackageRestorer.TryRestore("Microsoft.CodeAnalysis.ResxSourceGenerator");
                if (nugetFolder is not null)
                {
                    sourceGeneratorFolder = System.IO.Path.Combine(nugetFolder, "analyzers", "dotnet", "cs");
                }
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
            if (bool.TryParse(resourceExtractionOption, out var shouldExtractResources) &&
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
