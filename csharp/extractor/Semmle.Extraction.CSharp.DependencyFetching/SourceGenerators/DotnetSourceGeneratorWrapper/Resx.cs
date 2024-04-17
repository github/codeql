using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal class Resx : DotnetSourceGeneratorWrapper
    {
        protected override string FileType => "Resx";

        protected override string SourceGeneratorFolder { get; init; }

        public Resx(Sdk sdk, IDotNet dotNet, ILogger logger, string? sourceGeneratorFolder) : base(sdk, dotNet, logger)
        {
            if (sourceGeneratorFolder is null)
            {
                throw new Exception("No resx source generator folder available.");
            }
            SourceGeneratorFolder = sourceGeneratorFolder;
        }

        protected override void GenerateAnalyzerConfig(IEnumerable<string> resources, string analyzerConfigPath)
        {
            using var sw = new StreamWriter(analyzerConfigPath);
            sw.WriteLine("is_global = true");
            sw.WriteLine("build_property.RootNamespace = abc"); // todo: fix the namespace

            foreach (var f in resources.Select(f => f.Replace('\\', '/')))
            {
                sw.WriteLine($"\n[{f}]");
                sw.WriteLine($"build_metadata.AdditionalFiles.EmitFormatMethods = true");
            }
        }
    }
}
