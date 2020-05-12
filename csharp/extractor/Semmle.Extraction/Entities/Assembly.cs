using Microsoft.CodeAnalysis;
using System.IO;

namespace Semmle.Extraction.Entities
{
    public class Assembly : Location
    {
        readonly string assemblyPath;
        readonly IAssemblySymbol assembly;

        Assembly(Context cx, Microsoft.CodeAnalysis.Location? init)
            : base(cx, init)
        {
            if (init == null)
            {
                // This is the output assembly
                assemblyPath = cx.Extractor.OutputPath;
                assembly = cx.Compilation.Assembly;
            }
            else
            {
                assembly = init.MetadataModule.ContainingAssembly;
                var identity = assembly.Identity;
                var idString = identity.Name + " " + identity.Version;
                assemblyPath = cx.Extractor.GetAssemblyFile(idString);
            }
        }

        public override void Populate(TextWriter trapFile)
        {
            if (assemblyPath != null)
            {
                trapFile.assemblies(this, File.Create(Context, assemblyPath), assembly.ToString() ?? "",
                    assembly.Identity.Name, assembly.Identity.Version.ToString());
            }
        }

        public override bool NeedsPopulation =>
            !SymbolEqualityComparer.Default.Equals(assembly, Context.Compilation.Assembly) || !Context.IsGlobalContext;

        public override int GetHashCode() =>
            symbol == null ? 91187354 : symbol.GetHashCode();

        public override bool Equals(object? obj)
        {
            var other = obj as Assembly;
            if (other == null || other.GetType() != typeof(Assembly))
                return false;

            return Equals(symbol, other.symbol);
        }

        public new static Location Create(Context cx, Microsoft.CodeAnalysis.Location? loc) => AssemblyConstructorFactory.Instance.CreateNullableEntity(cx, loc);

        class AssemblyConstructorFactory : ICachedEntityFactory<Microsoft.CodeAnalysis.Location?, Assembly>
        {
            public static readonly AssemblyConstructorFactory Instance = new AssemblyConstructorFactory();

            public Assembly Create(Context cx, Microsoft.CodeAnalysis.Location? init) => new Assembly(cx, init);
        }

        public static Location CreateOutputAssembly(Context cx)
        {
            if (cx.Extractor.OutputPath == null)
                throw new InternalError("Attempting to create the output assembly in standalone extraction mode");
            return AssemblyConstructorFactory.Instance.CreateNullableEntity(cx, null);
        }

        public override void WriteId(System.IO.TextWriter trapFile)
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
