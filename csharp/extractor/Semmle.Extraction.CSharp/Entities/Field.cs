using Microsoft.CodeAnalysis;
using Semmle.Extraction.CSharp.Populators;
using System.Linq;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities
{
    class Field : CachedSymbol<IFieldSymbol>, IExpressionParentEntity
    {
        Field(Context cx, IFieldSymbol init)
            : base(cx, init)
        {
            type = new Lazy<Type>(() => Type.Create(cx, symbol.Type));
        }

        public static Field Create(Context cx, IFieldSymbol field) => FieldFactory.Instance.CreateEntity(cx, field);

        // Do not populate backing fields.
        // Populate Tuple fields.
        public override bool NeedsPopulation =>
            (base.NeedsPopulation && !symbol.IsImplicitlyDeclared) || symbol.ContainingType.IsTupleType;

        public override void Populate()
        {
            ExtractMetadataHandle();
            ExtractAttributes();
            ContainingType.ExtractGenerics();

            Field unboundFieldKey = Field.Create(Context, symbol.OriginalDefinition);
            Context.Emit(Tuples.fields(this, (symbol.IsConst ? 2 : 1), symbol.Name, ContainingType, Type.TypeRef, unboundFieldKey));

            ExtractModifiers();

            if (symbol.IsVolatile)
                Modifier.HasModifier(Context, this, "volatile");

            if (symbol.IsConst)
            {
                Modifier.HasModifier(Context, this, "const");

                if (symbol.HasConstantValue)
                {
                    Context.Emit(Tuples.constant_value(this, Expression.ValueAsString(symbol.ConstantValue)));
                }
            }

            foreach (var l in Locations)
                Context.Emit(Tuples.field_location(this, l));

            if (!IsSourceDeclaration || !symbol.FromSource())
                return;

            Context.BindComments(this, Location.symbol);

            int child = 0;
            foreach (var initializer in
                symbol.DeclaringSyntaxReferences.
                Select(n => n.GetSyntax()).
                OfType<VariableDeclaratorSyntax>().
                Where(n => n.Initializer != null))
            {
                Context.PopulateLater(() =>
                {
                    Expression.CreateFromNode(new ExpressionNodeInfo(Context, initializer.Initializer.Value, this, child++));
                });
            }

            foreach (var initializer in symbol.DeclaringSyntaxReferences.
                Select(n => n.GetSyntax()).
                OfType<EnumMemberDeclarationSyntax>().
                Where(n => n.EqualsValue != null))
            {
                // Mark fields that have explicit initializers.
                var expr = new Expression(new ExpressionInfo(Context, Type, Context.Create(initializer.EqualsValue.Value.FixedLocation()), Kinds.ExprKind.FIELD_ACCESS, this, child++, false, null));
                Context.Emit(Tuples.expr_access(expr, this));
            }

            if (IsSourceDeclaration)
                foreach (var syntax in symbol.DeclaringSyntaxReferences.
                    Select(d => d.GetSyntax()).OfType<VariableDeclaratorSyntax>().
                    Select(d => d.Parent).OfType<VariableDeclarationSyntax>())
                    TypeMention.Create(Context, syntax.Type, this, Type);
        }

        readonly Lazy<Type> type;
        public Type Type => type.Value;

        public override IId Id => new Key(ContainingType, ".", symbol.Name, ";field");

        bool IExpressionParentEntity.IsTopLevelParent => true;

        class FieldFactory : ICachedEntityFactory<IFieldSymbol, Field>
        {
            public static readonly FieldFactory Instance = new FieldFactory();

            public Field Create(Context cx, IFieldSymbol init) => new Field(cx, init);
        }
        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.PushesLabel;
    }
}
