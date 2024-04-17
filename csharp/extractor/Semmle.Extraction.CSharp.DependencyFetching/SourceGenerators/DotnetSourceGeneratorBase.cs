using System;
using System.Collections.Generic;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal abstract class DotnetSourceGeneratorBase<T> : SourceGeneratorBase where T : DotnetSourceGeneratorWrapper
    {
        protected readonly FileProvider fileProvider;
        protected readonly FileContent fileContent;
        protected readonly IDotNet dotnet;
        protected readonly ICompilationInfoContainer compilationInfoContainer;
        protected readonly IEnumerable<string> references;

        public DotnetSourceGeneratorBase(
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

        protected override IEnumerable<string> Run()
        {
            var additionalFiles = AdditionalFiles;
            if (additionalFiles.Count == 0)
            {
                logger.LogDebug($"No {FileType} files found. Skipping source generation.");
                return [];
            }

            if (!fileContent.IsAspNetCoreDetected)
            {
                logger.LogInfo($"Generating source files from {FileType} files is only supported for new (SDK-style) project files");
                return [];
            }

            logger.LogInfo($"Generating source files from {additionalFiles.Count} {FileType} files...");

            try
            {
                var sdk = new Sdk(dotnet, logger);
                var sourceGenerator = GetSourceGenerator(sdk);
                var targetDir = GetTemporaryWorkingDirectory(FileType.ToLowerInvariant());
                // todo: run the below in a loop, on groups of files belonging to the same project:
                var generatedFiles = sourceGenerator.RunSourceGenerator(additionalFiles, references, targetDir);
                return generatedFiles ?? [];
            }
            catch (Exception ex)
            {
                // It's okay, we tried our best to generate source files.
                logger.LogInfo($"Failed to generate source files from {FileType} files: {ex.Message}");
                return [];
            }
        }

        protected abstract ICollection<string> AdditionalFiles { get; }

        protected abstract string FileType { get; }

        protected abstract T GetSourceGenerator(Sdk sdk);

    }
}
