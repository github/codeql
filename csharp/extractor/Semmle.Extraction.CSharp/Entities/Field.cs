using Microsoft.CodeAnalysis;
using Semmle.Extraction.CSharp.Populators;
using System.Linq;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System;
using Semmle.Extraction.Entities;
using Semmle.Extraction.Kinds;
using Semmle.Extraction.CSharp.Entities.Expressions;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    class Field : CachedSymbol<IFieldSymbol>, IExpressionParentEntity
    {
        Field(Context cx, IFieldSymbol init)
            : base(cx, init)
        {
            type = new Lazy<AnnotatedType>(() => Entities.Type.Create(cx, symbol.GetAnnotatedType()));
        }

        public static Field Create(Context cx, IFieldSymbol field) => FieldFactory.Instance.CreateEntity(cx, field);

        // Do not populate backing fields.
        // Populate Tuple fields.
        public override bool NeedsPopulation =>
            (base.NeedsPopulation && !symbol.IsImplicitlyDeclared) || symbol.ContainingType.IsTupleType;

        public override void Populate(TextWriter trapFile)
        {
            PopulateMetadataHandle(trapFile);
            PopulateAttributes();
            ContainingType.PopulateGenerics();
            PopulateNullability(trapFile, symbol.GetAnnotatedType());

            Field unboundFieldKey = Field.Create(Context, symbol.OriginalDefinition);
            trapFile.fields(this, (symbol.IsConst ? 2 : 1), symbol.Name, ContainingType, Type.Type.TypeRef, unboundFieldKey);

            PopulateModifiers(trapFile);

            if (symbol.IsVolatile)
                Modifier.HasModifier(Context, trapFile, this, "volatile");

            if (symbol.IsConst)
            {
                Modifier.HasModifier(Context, trapFile, this, "const");

                if (symbol.HasConstantValue)
                {
                    trapFile.constant_value(this, Expression.ValueAsString(symbol.ConstantValue));
                }
            }

            foreach (var l in Locations)
                trapFile.field_location(this, l);

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
                    var loc = Context.Create(initializer.GetLocation());
                    var simpleAssignExpr = new Expression(new ExpressionInfo(Context, Type, loc, ExprKind.SIMPLE_ASSIGN, this, child++, false, null));
                    Expression.CreateFromNode(new ExpressionNodeInfo(Context, initializer.Initializer.Value, simpleAssignExpr, 0));
                    var access = new Expression(new ExpressionInfo(Context, Type, Location, ExprKind.FIELD_ACCESS, simpleAssignExpr, 1, false, null));
                    trapFile.expr_access(access, this);
                    if (!symbol.IsStatic)
                    {
                        This.CreateImplicit(Context, Entities.Type.Create(Context, symbol.ContainingType), Location, access, -1);
                    }
                });
            }

            foreach (var initializer in symbol.DeclaringSyntaxReferences.
                Select(n => n.GetSyntax()).
                OfType<EnumMemberDeclarationSyntax>().
                Where(n => n.EqualsValue != null))
            {
                // Mark fields that have explicit initializers.
                var expr = new Expression(new ExpressionInfo(Context, Type, Context.Create(initializer.EqualsValue.Value.FixedLocation()), Kinds.ExprKind.FIELD_ACCESS, this, child++, false, null));
                trapFile.expr_access(expr, this);
            }

            if (IsSourceDeclaration)
                foreach (var syntax in symbol.DeclaringSyntaxReferences.
                    Select(d => d.GetSyntax()).OfType<VariableDeclaratorSyntax>().
                    Select(d => d.Parent).OfType<VariableDeclarationSyntax>())
                    TypeMention.Create(Context, syntax.Type, this, Type);
        }

        readonly Lazy<AnnotatedType> type;
        public AnnotatedType Type => type.Value;

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.WriteSubId(ContainingType);
            trapFile.Write('.');
            trapFile.Write(symbol.Name);
            trapFile.Write(";field");
        }

        bool IExpressionParentEntity.IsTopLevelParent => true;

        class FieldFactory : ICachedEntityFactory<IFieldSymbol, Field>
        {
            public static readonly FieldFactory Instance = new FieldFactory();

            public Field Create(Context cx, IFieldSymbol init) => new Field(cx, init);
        }
        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.PushesLabel;
    }
}
