using Microsoft.CodeAnalysis;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class DynamicType : Type<IDynamicTypeSymbol>
    {
        private DynamicType(Context cx, IDynamicTypeSymbol init)
            : base(cx, init) { }

        public static DynamicType Create(Context cx, IDynamicTypeSymbol type) => DynamicTypeFactory.Instance.CreateEntityFromSymbol(cx, type);

        public override Microsoft.CodeAnalysis.Location ReportingLocation => Context.Compilation.ObjectType.Locations.FirstOrDefault();

        public override void Populate(TextWriter trapFile)
        {
            trapFile.types(this, Kinds.TypeKind.DYNAMIC, "dynamic");
            trapFile.type_location(this, Location);

            trapFile.has_modifiers(this, Modifier.Create(Context, "public"));
            trapFile.parent_namespace(this, Namespace.Create(Context, Context.Compilation.GlobalNamespace));
        }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.Write("dynamic;type");
        }

        private class DynamicTypeFactory : ICachedEntityFactory<IDynamicTypeSymbol, DynamicType>
        {
            public static DynamicTypeFactory Instance { get; } = new DynamicTypeFactory();

            public DynamicType Create(Context cx, IDynamicTypeSymbol init) => new DynamicType(cx, init);
        }
    }
}
