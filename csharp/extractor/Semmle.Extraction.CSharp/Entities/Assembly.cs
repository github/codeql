using Microsoft.CodeAnalysis;
using Semmle.Extraction.CSharp;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Assembly : Extraction.Entities.Location
    {
        public override Context Context => (Context)base.Context;

        private readonly string assemblyPath;
        private readonly IAssemblySymbol assembly;

        private Assembly(Context cx, Microsoft.CodeAnalysis.Location? init)
            : base(cx, init)
        {
            if (init is null)
            {
                // This is the output assembly
                assemblyPath = ((TracingExtractor)cx.Extractor).OutputPath;
                assembly = cx.Compilation.Assembly;
            }
            else
            {
                assembly = init.MetadataModule!.ContainingAssembly;
                var identity = assembly.Identity;
                var idString = identity.Name + " " + identity.Version;
                assemblyPath = cx.Extractor.GetAssemblyFile(idString);
            }
        }

        public override void Populate(TextWriter trapFile)
        {
            if (assemblyPath is not null)
            {
                trapFile.assemblies(this, File.Create(Context, assemblyPath), assembly.ToString() ?? "",
                    assembly.Identity.Name, assembly.Identity.Version.ToString());
            }
        }

        public override bool NeedsPopulation => true;

        public override int GetHashCode() =>
            Symbol is null ? 91187354 : Symbol.GetHashCode();

        public override bool Equals(object? obj)
        {
            if (obj is Assembly other && other.GetType() == typeof(Assembly))
                return Equals(Symbol, other.Symbol);

            return false;
        }

        public static Extraction.Entities.Location Create(Context cx, Microsoft.CodeAnalysis.Location loc) => AssemblyConstructorFactory.Instance.CreateEntity(cx, loc, loc);

        private class AssemblyConstructorFactory : CachedEntityFactory<Microsoft.CodeAnalysis.Location?, Assembly>
        {
            public static AssemblyConstructorFactory Instance { get; } = new AssemblyConstructorFactory();

            public override Assembly Create(Context cx, Microsoft.CodeAnalysis.Location? init) => new Assembly(cx, init);
        }

        private static readonly object outputAssemblyCacheKey = new object();

        public static Assembly CreateOutputAssembly(Context cx)
        {
            if (cx.Extractor.Standalone)
                throw new InternalError("Attempting to create the output assembly in standalone extraction mode");
            return AssemblyConstructorFactory.Instance.CreateEntity(cx, outputAssemblyCacheKey, null);
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write(assembly.ToString());
            if (!(assemblyPath is null))
            {
                trapFile.Write("#file:///");
                trapFile.Write(assemblyPath.Replace("\\", "/"));
            }
            trapFile.Write(";assembly");
        }
    }
}
