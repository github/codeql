using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal sealed partial class Resx : DotnetSourceGeneratorWrapper
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

        protected override void GenerateAnalyzerConfig(IEnumerable<string> resources, string csprojFile, string analyzerConfigPath)
        {
            using var sw = new StreamWriter(analyzerConfigPath);
            sw.WriteLine("is_global = true");

            var rootNamespace = Path.GetFileNameWithoutExtension(csprojFile);

            var matches = File.ReadAllLines(csprojFile)
                .Select(line => RootNamespace().Match(line))
                .Where(match => match.Success)
                .Select(match => match.Groups[1].Value)
                .ToArray();

            if (matches.Length == 1)
            {
                logger.LogDebug($"RootNamespace found in {csprojFile}: {matches[0]}");
                rootNamespace = matches[0];
            }
            else if (matches.Length > 1)
            {
                logger.LogDebug($"Multiple RootNamespace elements found in {csprojFile}. Using the first one.");
                rootNamespace = matches[0];
            }

            sw.WriteLine($"build_property.RootNamespace = {rootNamespace}");

            foreach (var f in resources.Select(f => f.Replace('\\', '/')))
            {
                sw.WriteLine($"\n[{f}]");
                sw.WriteLine($"build_metadata.AdditionalFiles.EmitFormatMethods = true");
            }
        }

        [GeneratedRegex(@"<RootNamespace>(.*)</RootNamespace>", RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex RootNamespace();
    }
}
