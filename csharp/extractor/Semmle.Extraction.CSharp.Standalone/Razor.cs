using System;
using System.Collections.Generic;
using System.IO;
using Semmle.BuildAnalyser;
using Semmle.Util;
using System.Text;

namespace Semmle.Extraction.CSharp.Standalone
{
    internal class Razor
    {
        private readonly DotnetVersion sdk;
        private readonly ProgressMonitor progressMonitor;
        private readonly DotNet dotNet;
        private readonly string sourceGeneratorFolder;
        private readonly string cscPath;

        public Razor(DotnetVersion sdk, DotNet dotNet, ProgressMonitor progressMonitor)
        {
            this.sdk = sdk;
            this.progressMonitor = progressMonitor;
            this.dotNet = dotNet;

            sourceGeneratorFolder = Path.Combine(this.sdk.FullPath, "Sdks/Microsoft.NET.Sdk.Razor/source-generators");
            if (!Directory.Exists(sourceGeneratorFolder))
            {
                this.progressMonitor.RazorSourceGeneratorMissing(sourceGeneratorFolder);
                throw new Exception($"Razor source generator folder {sourceGeneratorFolder} does not exist.");
            }

            cscPath = Path.Combine(this.sdk.FullPath, "Roslyn/bincore/csc.dll");
            if (!File.Exists(cscPath))
            {
                this.progressMonitor.CscMissing(cscPath);
                throw new Exception($"csc.dll {cscPath} does not exist.");
            }
        }

        private static void GenerateAnalyzerConfig(IEnumerable<string> cshtmls, string analyzerConfigPath)
        {
            using var sw = new StreamWriter(analyzerConfigPath);
            sw.WriteLine("is_global = true");

            foreach (var f in cshtmls)
            {
                sw.WriteLine($"\n[{f}]");
                var base64 = Convert.ToBase64String(Encoding.UTF8.GetBytes(f)); // TODO: this should be the relative path of the file.
                sw.WriteLine($"build_metadata.AdditionalFiles.TargetPath = {base64}");
            }
        }

        public IEnumerable<string> GenerateFiles(IEnumerable<string> cshtmls, IEnumerable<string> references, string workingDirectory)
        {
            // TODO: the below command might be too long. It should be written to a temp file and passed to csc via @.

            var name = Guid.NewGuid().ToString("N").ToUpper();
            var analyzerConfig = Path.Combine(Path.GetTempPath(), name + ".txt");
            var dllPath = Path.Combine(Path.GetTempPath(), name + ".dll");
            var outputFolder = Path.Combine(workingDirectory, name);
            Directory.CreateDirectory(outputFolder);

            try
            {
                GenerateAnalyzerConfig(cshtmls, Path.Combine(sourceGeneratorFolder, analyzerConfig));

                var args = new StringBuilder();
                args.Append($"\"{cscPath}\" /target:exe /generatedfilesout:\"{outputFolder}\" /out:\"{dllPath}\" /analyzerconfig:\"{analyzerConfig}\" ");

                // TODO: quote paths:
                foreach (var f in Directory.GetFiles(sourceGeneratorFolder, "*.dll"))
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

                dotNet.Exec(args.ToString());

                return Directory.GetFiles(outputFolder, "*.*", new EnumerationOptions { RecurseSubdirectories = true });
            }
            finally
            {
                DeleteFile(analyzerConfig);
                DeleteFile(dllPath);
            }
        }

        private static void DeleteFile(string path)
        {
            try
            {
                File.Delete(path);
            }
            catch
            {
                // Ignore
            }
        }
    }
}