using System.Reflection;
using System.Globalization;
using System.Collections.Generic;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// An assembly to extract.
    /// </summary>
    internal class Assembly : LabelledEntity, ILocation
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

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write(FullName);
            trapFile.Write("#file:///");
            trapFile.Write(Context.AssemblyPath.Replace("\\", "/"));
            trapFile.Write(";assembly");
        }

        public override bool Equals(object? obj)
        {
            return GetType() == obj?.GetType() && Equals(file, ((Assembly)obj).file);
        }

        public override int GetHashCode() => 7 * file.GetHashCode();

        private string FullName => assemblyName.GetPublicKey() is null ? assemblyName.FullName + ", PublicKeyToken=null" : assemblyName.FullName;

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return file;
                yield return Tuples.assemblies(this, file, FullName, assemblyName.Name ?? string.Empty, assemblyName.Version?.ToString() ?? string.Empty);

                if (Context.Pdb is not null)
                {
                    foreach (var f in Context.Pdb.SourceFiles)
                    {
                        yield return Context.CreateSourceFile(f);
                    }
                }

                foreach (var handle in Context.MdReader.TypeDefinitions)
                {
                    IExtractionProduct? product = null;
                    try
                    {
                        product = Context.Create(handle);
                    }
                    catch (InternalError e)
                    {
                        Context.ExtractionError("Error processing type definition", e.Message, GeneratedLocation.Create(Context), e.StackTrace);
                    }

                    // Limitation of C#: Cannot yield return inside a try-catch.
                    if (product is not null)
                        yield return product;
                }

                foreach (var handle in Context.MdReader.MethodDefinitions)
                {
                    IExtractionProduct? product = null;
                    try
                    {
                        product = Context.Create(handle);
                    }
                    catch (InternalError e)
                    {
                        Context.ExtractionError("Error processing bytecode", e.Message, GeneratedLocation.Create(Context), e.StackTrace);
                    }

                    if (product is not null)
                        yield return product;
                }
            }
        }
    }
}
