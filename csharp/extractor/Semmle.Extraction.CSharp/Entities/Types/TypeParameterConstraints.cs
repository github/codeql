using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class TypeParameterConstraints : CachedEntity<ITypeParameterSymbol>
    {
        private readonly TypeParameter parent;

        public TypeParameterConstraints(Context cx, TypeParameter parent)
            : base(cx, parent.Symbol)
        {
            this.parent = parent;
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(parent);
            trapFile.Write(";typeparameterconstraints");
        }

        public override bool NeedsPopulation => true;

        public override void Populate(TextWriter trapFile)
        {
            trapFile.type_parameter_constraints(this, parent);

            if (Symbol.HasReferenceTypeConstraint)
                trapFile.general_type_parameter_constraints(this, 1);

            if (Symbol.HasValueTypeConstraint)
                trapFile.general_type_parameter_constraints(this, 2);

            if (Symbol.HasConstructorConstraint)
                trapFile.general_type_parameter_constraints(this, 3);

            if (Symbol.HasUnmanagedTypeConstraint)
                trapFile.general_type_parameter_constraints(this, 4);

            if (Symbol.ReferenceTypeConstraintNullableAnnotation == NullableAnnotation.Annotated)
                trapFile.general_type_parameter_constraints(this, 5);

            if (Symbol.HasNotNullConstraint)
                trapFile.general_type_parameter_constraints(this, 6);

            if (Symbol.AllowsRefLikeType)
                trapFile.general_type_parameter_constraints(this, 7);

            foreach (var abase in Symbol.GetAnnotatedTypeConstraints())
            {
                var t = Type.Create(Context, abase.Symbol);
                trapFile.specific_type_parameter_constraints(this, t.TypeRef);
                if (!abase.HasObliviousNullability())
                    trapFile.specific_type_parameter_nullability(this, t.TypeRef, NullabilityEntity.Create(Context, Nullability.Create(abase)));
            }
        }

        public override Microsoft.CodeAnalysis.Location? ReportingLocation => null;

        public static TypeParameterConstraints Create(Context cx, TypeParameter p) =>
            TypeParameterConstraintsFactory.Instance.CreateEntity(cx, (typeof(TypeParameterConstraints), p), p);

        private class TypeParameterConstraintsFactory : CachedEntityFactory<TypeParameter, TypeParameterConstraints>
        {
            public static TypeParameterConstraintsFactory Instance { get; } = new TypeParameterConstraintsFactory();

            public override TypeParameterConstraints Create(Context cx, TypeParameter init) => new(cx, init);
        }
    }
}
