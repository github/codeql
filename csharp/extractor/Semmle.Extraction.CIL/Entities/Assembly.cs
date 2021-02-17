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

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.Write(FullName);
            trapFile.Write("#file:///");
            trapFile.Write(Cx.AssemblyPath.Replace("\\", "/"));
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
                        Cx.ExtractionError("Error processing type definition", e.Message, GeneratedLocation.Create(Cx), e.StackTrace);
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
                        Cx.ExtractionError("Error processing bytecode", e.Message, GeneratedLocation.Create(Cx), e.StackTrace);
                    }

                    if (product != null)
                        yield return product;
                }
            }
        }
    }
}
