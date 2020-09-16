using System.Reflection;
using System.Globalization;
using System.Collections.Generic;
using Semmle.Util.Logging;
using System;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    public interface ILocation : IEntity
    {
    }

    interface IAssembly : ILocation
    {
    }

    /// <summary>
    /// An assembly to extract.
    /// </summary>
    public class Assembly : LabelledEntity, IAssembly
    {
        readonly File file;
        readonly AssemblyName assemblyName;

        public Assembly(Context cx) : base(cx)
        {
            cx.assembly = this;
            var def = cx.mdReader.GetAssemblyDefinition();

            assemblyName = new AssemblyName
            {
                Name = cx.mdReader.GetString(def.Name),
                Version = def.Version,
                CultureInfo = new CultureInfo(cx.mdReader.GetString(def.Culture))
            };

            if (!def.PublicKey.IsNil)
                assemblyName.SetPublicKey(cx.mdReader.GetBlobBytes(def.PublicKey));

            file = new File(cx, cx.assemblyPath);
        }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.Write(FullName);
            trapFile.Write("#file:///");
            trapFile.Write(cx.assemblyPath.Replace("\\", "/"));
        }

        public override bool Equals(object? obj)
        {
            return GetType() == obj?.GetType() && Equals(file, ((Assembly)obj).file);
        }

        public override int GetHashCode() => 7 * file.GetHashCode();

        public override string IdSuffix => ";assembly";

        string FullName => assemblyName.GetPublicKey() is null ? assemblyName.FullName + ", PublicKeyToken=null" : assemblyName.FullName;

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return file;
                yield return Tuples.assemblies(this, file, FullName, assemblyName.Name ?? string.Empty, assemblyName.Version?.ToString() ?? string.Empty);

                if (cx.pdb != null)
                {
                    foreach (var f in cx.pdb.SourceFiles)
                    {
                        yield return cx.CreateSourceFile(f);
                    }
                }

                foreach (var handle in cx.mdReader.TypeDefinitions)
                {
                    IExtractionProduct? product = null;
                    try
                    {
                        product = cx.Create(handle);
                    }
                    catch (InternalError e)
                    {
                        cx.cx.ExtractionError("Error processing type definition", e.Message, GeneratedLocation.Create(cx.cx), e.StackTrace);
                    }

                    // Limitation of C#: Cannot yield return inside a try-catch.
                    if (product != null)
                        yield return product;
                }

                foreach (var handle in cx.mdReader.MethodDefinitions)
                {
                    IExtractionProduct? product = null;
                    try
                    {
                        product = cx.Create(handle);
                    }
                    catch (InternalError e)
                    {
                        cx.cx.ExtractionError("Error processing bytecode", e.Message, GeneratedLocation.Create(cx.cx), e.StackTrace);
                    }

                    if (product != null)
                        yield return product;
                }
            }
        }

        static void ExtractCIL(Extraction.Context cx, string assemblyPath, bool extractPdbs)
        {
            using var cilContext = new Context(cx, assemblyPath, extractPdbs);
            cilContext.Populate(new Assembly(cilContext));
            cilContext.cx.PopulateAll();
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
                var extractor = new Extractor(false, assemblyPath, logger);
                var project = layout.LookupProjectOrDefault(assemblyPath);
                using var trapWriter = project.CreateTrapWriter(logger, assemblyPath + ".cil", true, trapCompression);
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
