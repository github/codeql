using System.Reflection;
using System.Globalization;
using System.Collections.Generic;
using Semmle.Util.Logging;
using System;
using Semmle.Extraction.Entities;
using System.IO;
using Semmle.Util;

namespace Semmle.Extraction.CIL.Entities
{
    public interface ILocation : IEntity
    {
    }

    internal interface IAssembly : ILocation
    {
    }

    /// <summary>
    /// An assembly to extract.
    /// </summary>
    public class Assembly : LabelledEntity, IAssembly
    {
        private readonly File file;
        private readonly AssemblyName assemblyName;

        public Assembly(Context cx) : base(cx)
        {
            cx.Assembly = this;
            var def = cx.MdReader.GetAssemblyDefinition();

            assemblyName = new AssemblyName
            {
                Name = cx.MdReader.GetString(def.Name),
                Version = def.Version,
                CultureInfo = new CultureInfo(cx.MdReader.GetString(def.Culture))
            };

            if (!def.PublicKey.IsNil)
                assemblyName.SetPublicKey(cx.MdReader.GetBlobBytes(def.PublicKey));

            file = new File(cx, cx.AssemblyPath);
        }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.Write(FullName);
            trapFile.Write("#file:///");
            trapFile.Write(Cx.AssemblyPath.Replace("\\", "/"));
        }

        public override bool Equals(object? obj)
        {
            return GetType() == obj?.GetType() && Equals(file, ((Assembly)obj).file);
        }

        public override int GetHashCode() => 7 * file.GetHashCode();

        public override string IdSuffix => ";assembly";

        private string FullName => assemblyName.GetPublicKey() is null ? assemblyName.FullName + ", PublicKeyToken=null" : assemblyName.FullName;

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return file;
                yield return Tuples.assemblies(this, file, FullName, assemblyName.Name ?? string.Empty, assemblyName.Version?.ToString() ?? string.Empty);

                if (Cx.Pdb != null)
                {
                    foreach (var f in Cx.Pdb.SourceFiles)
                    {
                        yield return Cx.CreateSourceFile(f);
                    }
                }

                foreach (var handle in Cx.MdReader.TypeDefinitions)
                {
                    IExtractionProduct? product = null;
                    try
                    {
                        product = Cx.Create(handle);
                    }
                    catch (InternalError e)
                    {
                        Cx.Cx.ExtractionError("Error processing type definition", e.Message, GeneratedLocation.Create(Cx.Cx), e.StackTrace);
                    }

                    // Limitation of C#: Cannot yield return inside a try-catch.
                    if (product != null)
                        yield return product;
                }

                foreach (var handle in Cx.MdReader.MethodDefinitions)
                {
                    IExtractionProduct? product = null;
                    try
                    {
                        product = Cx.Create(handle);
                    }
                    catch (InternalError e)
                    {
                        Cx.Cx.ExtractionError("Error processing bytecode", e.Message, GeneratedLocation.Create(Cx.Cx), e.StackTrace);
                    }

                    if (product != null)
                        yield return product;
                }
            }
        }

        private static void ExtractCIL(Extraction.Context cx, string assemblyPath, bool extractPdbs)
        {
            using var cilContext = new Context(cx, assemblyPath, extractPdbs);
            cilContext.Populate(new Assembly(cilContext));
            cilContext.Cx.PopulateAll();
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
        public static void ExtractCIL(Layout layout, string assemblyPath, ILogger logger, bool nocache, bool extractPdbs, TrapWriter.CompressionMode trapCompression, out string trapFile, out bool extracted)
        {
            trapFile = "";
            extracted = false;
            try
            {
                var canonicalPathCache = CanonicalPathCache.Create(logger, 1000);
                var pathTransformer = new PathTransformer(canonicalPathCache);
                var extractor = new Extractor(false, assemblyPath, logger, pathTransformer);
                var transformedAssemblyPath = pathTransformer.Transform(assemblyPath);
                var project = layout.LookupProjectOrDefault(transformedAssemblyPath);
                using var trapWriter = project.CreateTrapWriter(logger, transformedAssemblyPath.WithSuffix(".cil"), true, trapCompression);
                trapFile = trapWriter.TrapFile;
                if (nocache || !System.IO.File.Exists(trapFile))
                {
                    var cx = extractor.CreateContext(null, trapWriter, null, false);
                    ExtractCIL(cx, assemblyPath, extractPdbs);
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
