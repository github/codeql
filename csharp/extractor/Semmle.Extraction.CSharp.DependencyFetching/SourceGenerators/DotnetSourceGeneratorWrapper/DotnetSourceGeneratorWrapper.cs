using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal abstract class DotnetSourceGeneratorWrapper
    {
        protected readonly ILogger logger;
        private readonly Sdk sdk;
        protected readonly IDotNet dotnet;

        protected abstract string SourceGeneratorFolder { get; init; }
        protected abstract string FileType { get; }

        public DotnetSourceGeneratorWrapper(
            Sdk sdk,
            IDotNet dotnet,
            ILogger logger)
        {
            this.logger = logger;
            this.sdk = sdk;
            this.dotnet = dotnet;
        }

        protected abstract void GenerateAnalyzerConfig(IEnumerable<string> additionalFiles, string analyzerConfigPath);

        public IEnumerable<string> RunSourceGenerator(IEnumerable<string> additionalFiles, IEnumerable<string> references, string targetDir)
        {
            if (sdk.CscPath is null)
            {
                logger.LogWarning("Not running source generator because csc path is not available.");
                return [];
            }

            var name = Guid.NewGuid().ToString("N").ToUpper();
            var tempPath = FileUtils.GetTemporaryWorkingDirectory(out var shouldCleanUp);
            var analyzerConfig = Path.Combine(tempPath, $"{name}.txt");
            var dllPath = Path.Combine(tempPath, $"{name}.dll");
            var cscArgsPath = Path.Combine(tempPath, $"{name}.rsp");
            var outputFolder = Path.Combine(targetDir, name);
            Directory.CreateDirectory(outputFolder);

            try
            {
                logger.LogInfo("Produce analyzer config content.");
                GenerateAnalyzerConfig(additionalFiles, analyzerConfig);

                logger.LogDebug($"Analyzer config content: {File.ReadAllText(analyzerConfig)}");

                var args = new StringBuilder();
                args.Append($"/target:exe /generatedfilesout:\"{outputFolder}\" /out:\"{dllPath}\" /analyzerconfig:\"{analyzerConfig}\" ");

                foreach (var f in Directory.GetFiles(SourceGeneratorFolder, "*.dll", new EnumerationOptions { RecurseSubdirectories = false, MatchCasing = MatchCasing.CaseInsensitive }))
                {
                    args.Append($"/analyzer:\"{f}\" ");
                }

                foreach (var f in additionalFiles)
                {
                    args.Append($"/additionalfile:\"{f}\" ");
                }

                foreach (var f in references)
                {
                    args.Append($"/reference:\"{f}\" ");
                }

                var argsString = args.ToString();

                logger.LogInfo($"Running CSC to generate source files from {FileType} files.");
                logger.LogDebug($"Running CSC to generate source files from {FileType} files with arguments: {argsString}.");

                using (var sw = new StreamWriter(cscArgsPath))
                {
                    sw.Write(argsString);
                }

                dotnet.Exec($"\"{sdk.CscPath}\" /noconfig @\"{cscArgsPath}\"");

                var files = Directory.GetFiles(outputFolder, "*.*", new EnumerationOptions { RecurseSubdirectories = true });

                logger.LogInfo($"Generated {files.Length} source files from {FileType} files.");

                return files;
            }
            finally
            {
                if (shouldCleanUp)
                {
                    DeleteFile(analyzerConfig);
                    DeleteFile(dllPath);
                    DeleteFile(cscArgsPath);
                }
            }
        }

        private void DeleteFile(string path)
        {
            try
            {
                File.Delete(path);
            }
            catch (Exception exc)
            {
                logger.LogWarning($"Failed to delete file {path}: {exc}");
            }
        }
    }
}
