using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
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
            if (AdditionalFiles.Count == 0)
            {
                logger.LogDebug($"No {FileType} files found. Skipping source generation.");
                return [];
            }

            if (!fileContent.IsNewProjectStructureUsed)
            {
                logger.LogInfo($"Generating source files from {FileType} files is only supported for new (SDK-style) project files");
                return [];
            }

            if (fileProvider.Projects.Count == 0)
            {
                logger.LogInfo($"No projects found. Skipping source generation from {FileType} files.");
                return [];
            }

            logger.LogInfo($"Generating source files from {AdditionalFiles.Count} {FileType} files...");

            // group additional files by closes project file:
            var projects = fileProvider.Projects
                .Select(p => (File: p, Directory: FileUtils.SafeGetDirectoryName(p, logger)))
                .Where(p => p.Directory.Length > 0);

            var groupedFiles = new Dictionary<string, List<string>>();

            foreach (var additionalFile in AdditionalFiles)
            {
                var project = projects
                    .Where(p => additionalFile.StartsWith(p.Directory))
                    .OrderByDescending(p => p.Directory.Length)
                    .FirstOrDefault();

                if (project == default)
                {
                    logger.LogDebug($"Failed to find project file for {additionalFile}");
                    continue;
                }

                groupedFiles.AddAnother(project.File, additionalFile);
            }

            try
            {
                var sdk = new Sdk(dotnet, logger);
                var sourceGenerator = GetSourceGenerator(sdk);
                var targetDir = GetTemporaryWorkingDirectory(FileType.ToLowerInvariant());

                return groupedFiles
                    .SelectMany(group => sourceGenerator.RunSourceGenerator(group.Value, group.Key, references, targetDir, fileProvider.SourceDir.FullName));
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
