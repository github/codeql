﻿using System;
using System.Linq;
using System.Threading.Tasks;
using Semmle.Util.Logging;
using System.Diagnostics;

namespace Semmle.Extraction.CIL.Driver
{
    public static class Program
    {
        private static void DisplayHelp()
        {
            Console.WriteLine("CIL command line extractor");
            Console.WriteLine();
            Console.WriteLine("Usage: Semmle.Extraction.CIL.Driver.exe [options] path ...");
            Console.WriteLine("    --verbose  Turn on verbose output");
            Console.WriteLine("    --dotnet   Extract the .Net Framework");
            Console.WriteLine("    --nocache  Overwrite existing trap files");
            Console.WriteLine("    --no-pdb   Do not extract PDB files");
            Console.WriteLine("    path       A directory/dll/exe to analyze");
        }

        private static void ExtractAssembly(string assemblyPath, ILogger logger, CommonOptions options)
        {
            var sw = new Stopwatch();
            sw.Start();
            Analyser.ExtractCIL(assemblyPath, logger, options, out _, out _);
            sw.Stop();
            logger.Log(Severity.Info, "  {0} ({1})", assemblyPath, sw.Elapsed);
        }

        public static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                DisplayHelp();
                return;
            }

            var options = new ExtractorOptions(args);
            using var logger = new ConsoleLogger(options.Verbosity);

            var actions = options.AssembliesToExtract
                .Select(asm => asm.Filename)
                .Select<string, Action>(filename => () => ExtractAssembly(filename, logger, options))
                .ToArray();

            foreach (var missingRef in options.MissingReferences)
                logger.Log(Severity.Info, "  Missing assembly " + missingRef);

            var sw = new Stopwatch();
            sw.Start();
            var piOptions = new ParallelOptions
            {
                MaxDegreeOfParallelism = options.Threads
            };

            Parallel.Invoke(piOptions, actions);

            sw.Stop();
            logger.Log(Severity.Info, "Extraction completed in {0}", sw.Elapsed);
        }
    }
}
