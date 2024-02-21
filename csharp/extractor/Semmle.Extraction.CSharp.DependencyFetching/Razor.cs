using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Linq;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal class Razor
    {
        private readonly DotNetVersion sdk;
        private readonly ILogger logger;
        private readonly IDotNet dotNet;
        private readonly string sourceGeneratorFolder;
        private readonly string cscPath;

        public Razor(DotNetVersion sdk, IDotNet dotNet, ILogger logger)
        {
            this.sdk = sdk;
            this.logger = logger;
            this.dotNet = dotNet;

            sourceGeneratorFolder = Path.Combine(this.sdk.FullPath, "Sdks", "Microsoft.NET.Sdk.Razor", "source-generators");
            this.logger.LogInfo($"Razor source generator folder: {sourceGeneratorFolder}");
            if (!Directory.Exists(sourceGeneratorFolder))
            {
                this.logger.LogInfo($"Razor source generator folder {sourceGeneratorFolder} does not exist.");
                throw new Exception($"Razor source generator folder {sourceGeneratorFolder} does not exist.");
            }

            cscPath = Path.Combine(this.sdk.FullPath, "Roslyn", "bincore", "csc.dll");
            this.logger.LogInfo($"Razor source generator CSC: {cscPath}");
            if (!File.Exists(cscPath))
            {
                this.logger.LogInfo($"Csc.exe not found at {cscPath}.");
                throw new Exception($"csc.dll {cscPath} does not exist.");
            }
        }

        private static void GenerateAnalyzerConfig(IEnumerable<string> cshtmls, string analyzerConfigPath)
        {
            using var sw = new StreamWriter(analyzerConfigPath);
            sw.WriteLine("is_global = true");

            foreach (var f in cshtmls.Select(f => f.Replace('\\', '/')))
            {
                sw.WriteLine($"\n[{f}]");
                var base64 = Convert.ToBase64String(Encoding.UTF8.GetBytes(f)); // TODO: this should be the relative path of the file.
                sw.WriteLine($"build_metadata.AdditionalFiles.TargetPath = {base64}");
            }
        }

        public IEnumerable<string> GenerateFiles(IEnumerable<string> cshtmls, IEnumerable<string> references, string workingDirectory)
        {
            var name = Guid.NewGuid().ToString("N").ToUpper();
            var tempPath = FileUtils.GetTemporaryWorkingDirectory(out var shouldCleanUp);
            var analyzerConfig = Path.Combine(tempPath, $"{name}.txt");
            var dllPath = Path.Combine(tempPath, $"{name}.dll");
            var cscArgsPath = Path.Combine(tempPath, $"{name}.rsp");
            var outputFolder = Path.Combine(workingDirectory, name);
            Directory.CreateDirectory(outputFolder);

            try
            {
                GenerateAnalyzerConfig(cshtmls, analyzerConfig);

                logger.LogInfo($"Analyzer config content: {File.ReadAllText(analyzerConfig)}");

                var args = new StringBuilder();
                args.Append($"/target:exe /generatedfilesout:\"{outputFolder}\" /out:\"{dllPath}\" /analyzerconfig:\"{analyzerConfig}\" ");

                foreach (var f in Directory.GetFiles(sourceGeneratorFolder, "*.dll", new EnumerationOptions { RecurseSubdirectories = false, MatchCasing = MatchCasing.CaseInsensitive }))
                {
                    args.Append($"/analyzer:\"{f}\" ");
                }

                foreach (var f in cshtmls)
                {
                    args.Append($"/additionalfile:\"{f}\" ");
                }

                foreach (var f in references)
                {
                    args.Append($"/reference:\"{f}\" ");
                }

                var argsString = args.ToString();

                logger.LogInfo($"Running CSC to generate Razor source files with arguments: {argsString}.");

                using (var sw = new StreamWriter(cscArgsPath))
                {
                    sw.Write(argsString);
                }

                dotNet.Exec($"\"{cscPath}\" /noconfig @\"{cscArgsPath}\"");

                var files = Directory.GetFiles(outputFolder, "*.*", new EnumerationOptions { RecurseSubdirectories = true });

                logger.LogInfo($"Generated {files.Length} source files from cshtml files.");

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