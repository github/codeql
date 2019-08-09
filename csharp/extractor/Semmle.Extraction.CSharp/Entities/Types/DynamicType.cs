using Microsoft.CodeAnalysis;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    class DynamicType : Type<IDynamicTypeSymbol>
    {
        DynamicType(Context cx, IDynamicTypeSymbol init)
            : base(cx, init) { }

        public static DynamicType Create(Context cx, IDynamicTypeSymbol type) => DynamicTypeFactory.Instance.CreateEntity(cx, type);

        public override Microsoft.CodeAnalysis.Location ReportingLocation => Context.Compilation.ObjectType.Locations.FirstOrDefault();

        public override void Populate(TextWriter trapFile)
        {
            trapFile.Emit(Tuples.types(this, Kinds.TypeKind.DYNAMIC, "dynamic"));
            trapFile.Emit(Tuples.type_location(this, Location));

            trapFile.Emit(Tuples.has_modifiers(this, Modifier.Create(Context, "public")));
            trapFile.Emit(Tuples.parent_namespace(this, Namespace.Create(Context, Context.Compilation.GlobalNamespace)));
        }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.Write("dynamic;type");
        }

        class DynamicTypeFactory : ICachedEntityFactory<IDynamicTypeSymbol, DynamicType>
        {
            public static readonly DynamicTypeFactory Instance = new DynamicTypeFactory();

            public DynamicType Create(Context cx, IDynamicTypeSymbol init) => new DynamicType(cx, init);
        }
    }
}
