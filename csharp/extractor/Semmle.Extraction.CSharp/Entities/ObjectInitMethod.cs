using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal sealed class ObjectInitMethod : CachedEntity, IMethodEntity
    {
        private Type ContainingType { get; }

        private ObjectInitMethod(Context cx, Type containingType)
            : base(cx)
        {
            this.ContainingType = containingType;
        }

        private static readonly string Name = "<object initializer>";

        public static ObjectInitMethod Create(Context cx, Type containingType)
        {
            return ObjectInitMethodFactory.Instance.CreateEntity(cx, (typeof(ObjectInitMethod), containingType), containingType);
        }

        public override void Populate(TextWriter trapFile)
        {
            var returnType = Type.Create(Context, Context.Compilation.GetSpecialType(SpecialType.System_Void));

            trapFile.methods(this, Name, ContainingType, returnType.TypeRef, this);

            trapFile.compiler_generated(this);

            trapFile.method_location(this, Context.CreateLocation(ReportingLocation));
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(ContainingType);
            trapFile.Write(".");
            trapFile.Write(Name);
            trapFile.Write(";method");
        }

        public override Microsoft.CodeAnalysis.Location? ReportingLocation => ContainingType.ReportingLocation;

        public override bool NeedsPopulation => true;

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;

        private class ObjectInitMethodFactory : CachedEntityFactory<Type, ObjectInitMethod>
        {
            public static ObjectInitMethodFactory Instance { get; } = new ObjectInitMethodFactory();

            public override ObjectInitMethod Create(Context cx, Type containingType) =>
                new ObjectInitMethod(cx, containingType);
        }
    }
}
