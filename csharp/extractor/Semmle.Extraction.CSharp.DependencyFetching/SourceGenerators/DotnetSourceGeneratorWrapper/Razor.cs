using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal sealed class Razor : DotnetSourceGeneratorWrapper
    {
        protected override string FileType => "Razor";

        protected override string SourceGeneratorFolder { get; init; }

        public Razor(Sdk sdk, IDotNet dotNet, ILogger logger) : base(sdk, dotNet, logger)
        {
            var sdkPath = sdk.Version?.FullPath;
            if (sdkPath is null)
            {
                throw new Exception("No SDK path available.");
            }

            SourceGeneratorFolder = Path.Combine(sdkPath, "Sdks", "Microsoft.NET.Sdk.Razor", "source-generators");
            this.logger.LogInfo($"Razor source generator folder: {SourceGeneratorFolder}");
            if (!Directory.Exists(SourceGeneratorFolder))
            {
                throw new Exception($"Razor source generator folder {SourceGeneratorFolder} does not exist.");
            }
        }

        protected override void GenerateAnalyzerConfig(IEnumerable<string> cshtmls, string csprojFile, string analyzerConfigPath)
        {
            using var sw = new StreamWriter(analyzerConfigPath);
            sw.WriteLine("is_global = true");

            foreach (var cshtml in cshtmls)
            {
                var adjustedPath = cshtml.Replace('\\', '/');
                string? relativePath;

                try
                {
                    var csprojFolder = Path.GetDirectoryName(csprojFile);
                    relativePath = csprojFolder is not null ? Path.GetRelativePath(csprojFolder, cshtml) : cshtml;
                    relativePath = relativePath.Replace('\\', '/');
                }
                catch (Exception e)
                {
                    logger.LogWarning($"Failed to get relative path for {cshtml}: {e.Message}");
                    relativePath = adjustedPath;
                }

                sw.WriteLine($"\n[{adjustedPath}]");
                var base64 = Convert.ToBase64String(Encoding.UTF8.GetBytes(relativePath));
                sw.WriteLine($"build_metadata.AdditionalFiles.TargetPath = {base64}");
            }
        }
    }
}
