using Semmle.Util.Logging;
using System;
using Semmle.Util;
using Semmle.Extraction.CIL.Entities;

namespace Semmle.Extraction.CIL
{
    public static class Analyser
    {
        private static void ExtractCIL(TracingExtractor extractor, TrapWriter trapWriter, bool extractPdbs)
        {
            using var cilContext = new Context(extractor, trapWriter, extractor.OutputPath, extractPdbs);
            cilContext.Populate(new Assembly(cilContext));
            cilContext.PopulateAll();
        }

        /// <summary>
        /// Main entry point to the CIL extractor.
        /// Call this to extract a given assembly.
        /// </summary>
        /// <param name="layout">The trap layout.</param>
        /// <param name="assemblyPath">The full path of the assembly to extract.</param>
        /// <param name="logger">The logger.</param>
        /// <param name="nocache">True to overwrite existing trap file.</param>
        /// <param name="extractPdbs">Whether to extract PDBs.</param>
        /// <param name="trapFile">The path of the trap file.</param>
        /// <param name="extracted">Whether the file was extracted (false=cached).</param>
        public static void ExtractCIL(string assemblyPath, ILogger logger, CommonOptions options, out string trapFile, out bool extracted)
        {
            trapFile = "";
            extracted = false;
            try
            {
                var canonicalPathCache = CanonicalPathCache.Create(logger, 1000);
                var pathTransformer = new PathTransformer(canonicalPathCache);
                var extractor = new TracingExtractor(assemblyPath, logger, pathTransformer, options);
                var transformedAssemblyPath = pathTransformer.Transform(assemblyPath);
                using var trapWriter = transformedAssemblyPath.WithSuffix(".cil").CreateTrapWriter(logger, options.TrapCompression, discardDuplicates: true);
                trapFile = trapWriter.TrapFile;
                if (!options.Cache || !System.IO.File.Exists(trapFile))
                {
                    ExtractCIL(extractor, trapWriter, options.PDB);
                    extracted = true;
                }
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                logger.Log(Severity.Error, string.Format("Exception extracting {0}: {1}", assemblyPath, ex));
            }
        }
    }
}
