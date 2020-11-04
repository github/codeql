using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    internal enum Variance
    {
        None = 0,
        Out = 1,
        In = 2
    }

    internal class TypeParameter : Type<ITypeParameterSymbol>
    {
        private TypeParameter(Context cx, ITypeParameterSymbol init)
            : base(cx, init) { }

        public override void Populate(TextWriter trapFile)
        {
            var constraints = new TypeParameterConstraints(Context);
            trapFile.type_parameter_constraints(constraints, this);

            if (symbol.HasReferenceTypeConstraint)
                trapFile.general_type_parameter_constraints(constraints, 1);

            if (symbol.HasValueTypeConstraint)
                trapFile.general_type_parameter_constraints(constraints, 2);

            if (symbol.HasConstructorConstraint)
                trapFile.general_type_parameter_constraints(constraints, 3);

            if (symbol.HasUnmanagedTypeConstraint)
                trapFile.general_type_parameter_constraints(constraints, 4);

            if (symbol.ReferenceTypeConstraintNullableAnnotation == NullableAnnotation.Annotated)
                trapFile.general_type_parameter_constraints(constraints, 5);

            foreach (var abase in symbol.GetAnnotatedTypeConstraints())
            {
                var t = Create(Context, abase.Symbol);
                trapFile.specific_type_parameter_constraints(constraints, t.TypeRef);
                if (!abase.HasObliviousNullability())
                    trapFile.specific_type_parameter_nullability(constraints, t.TypeRef, NullabilityEntity.Create(Context, Nullability.Create(abase)));
            }

            trapFile.types(this, Kinds.TypeKind.TYPE_PARAMETER, symbol.Name);

            var parentNs = Namespace.Create(Context, symbol.TypeParameterKind == TypeParameterKind.Method ? Context.Compilation.GlobalNamespace : symbol.ContainingNamespace);
            trapFile.parent_namespace(this, parentNs);

            foreach (var l in symbol.Locations)
            {
                trapFile.type_location(this, Context.Create(l));
            }

            if (IsSourceDeclaration)
            {
                var declSyntaxReferences = symbol.DeclaringSyntaxReferences
                    .Select(d => d.GetSyntax())
                    .Select(s => s.Parent)
                    .Where(p => p != null)
                    .Select(p => p.Parent)
                    .ToArray();
                var clauses = declSyntaxReferences.OfType<MethodDeclarationSyntax>().SelectMany(m => m.ConstraintClauses);
                clauses = clauses.Concat(declSyntaxReferences.OfType<ClassDeclarationSyntax>().SelectMany(c => c.ConstraintClauses));
                clauses = clauses.Concat(declSyntaxReferences.OfType<InterfaceDeclarationSyntax>().SelectMany(c => c.ConstraintClauses));
                clauses = clauses.Concat(declSyntaxReferences.OfType<StructDeclarationSyntax>().SelectMany(c => c.ConstraintClauses));
                foreach (var clause in clauses.Where(c => c.Name.Identifier.Text == symbol.Name))
                {
                    TypeMention.Create(Context, clause.Name, this, this);
                    foreach (var constraint in clause.Constraints.OfType<TypeConstraintSyntax>())
                    {
                        var ti = Context.GetModel(constraint).GetTypeInfo(constraint.Type);
                        var target = Type.Create(Context, ti.Type);
                        TypeMention.Create(Context, constraint.Type, this, target);
                    }
                }
            }
        }

        public static TypeParameter Create(Context cx, ITypeParameterSymbol p) =>
            TypeParameterFactory.Instance.CreateEntityFromSymbol(cx, p);

        /// <summary>
        /// The variance of this type parameter.
        /// </summary>
        public Variance Variance
        {
            get
            {
                switch (symbol.Variance)
                {
                    case VarianceKind.None: return Variance.None;
                    case VarianceKind.Out: return Variance.Out;
                    case VarianceKind.In: return Variance.In;
                    default:
                        throw new InternalError($"Unexpected VarianceKind {symbol.Variance}");
                }
            }
        }

        public override void WriteId(TextWriter trapFile)
        {
            string kind;
            IEntity containingEntity;
            switch (symbol.TypeParameterKind)
            {
                case TypeParameterKind.Method:
                    kind = "methodtypeparameter";
                    containingEntity = Method.Create(Context, (IMethodSymbol)symbol.ContainingSymbol);
                    break;
                case TypeParameterKind.Type:
                    kind = "typeparameter";
                    containingEntity = Create(Context, symbol.ContainingType);
                    break;
                default:
                    throw new InternalError(symbol, $"Unhandled type parameter kind {symbol.TypeParameterKind}");
            }
            trapFile.WriteSubId(containingEntity);
            trapFile.Write('_');
            trapFile.Write(symbol.Ordinal);
            trapFile.Write(';');
            trapFile.Write(kind);
        }

        private class TypeParameterFactory : ICachedEntityFactory<ITypeParameterSymbol, TypeParameter>
        {
            public static TypeParameterFactory Instance { get; } = new TypeParameterFactory();

            public TypeParameter Create(Context cx, ITypeParameterSymbol init) => new TypeParameter(cx, init);
        }
    }
}
