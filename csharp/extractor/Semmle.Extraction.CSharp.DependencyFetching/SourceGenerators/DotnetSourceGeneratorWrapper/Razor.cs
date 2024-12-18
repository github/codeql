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

            foreach (var f in cshtmls.Select(f => f.Replace('\\', '/')))
            {
                sw.WriteLine($"\n[{f}]");
                var base64 = Convert.ToBase64String(Encoding.UTF8.GetBytes(f)); // TODO: this should be the relative path of the file.
                sw.WriteLine($"build_metadata.AdditionalFiles.TargetPath = {base64}");
            }
        }
    }
}
