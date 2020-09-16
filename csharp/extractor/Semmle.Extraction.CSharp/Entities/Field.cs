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
            type = new Lazy<AnnotatedType>(() => Entities.Type.Create(cx, Symbol.GetAnnotatedType()));
        }

        public static Field Create(Context cx, IFieldSymbol field) => FieldFactory.Instance.CreateEntityFromSymbol(cx, field);

        // Do not populate backing fields.
        // Populate Tuple fields.
        public override bool NeedsPopulation =>
            (base.NeedsPopulation && !Symbol.IsImplicitlyDeclared) || Symbol.ContainingType.IsTupleType;

        public override void Populate(TextWriter trapFile)
        {
            PopulateMetadataHandle(trapFile);
            PopulateAttributes();
            ContainingType.PopulateGenerics();
            PopulateNullability(trapFile, Symbol.GetAnnotatedType());

            var unboundFieldKey = Field.Create(Context, Symbol.OriginalDefinition);
            trapFile.fields(this, (Symbol.IsConst ? 2 : 1), Symbol.Name, ContainingType, Type.Type.TypeRef, unboundFieldKey);

            PopulateModifiers(trapFile);

            if (Symbol.IsVolatile)
                Modifier.HasModifier(Context, trapFile, this, "volatile");

            if (Symbol.IsConst)
            {
                Modifier.HasModifier(Context, trapFile, this, "const");

                if (Symbol.HasConstantValue)
                {
                    trapFile.constant_value(this, Expression.ValueAsString(Symbol.ConstantValue));
                }
            }

            foreach (var l in Locations)
                trapFile.field_location(this, l);

            if (!IsSourceDeclaration || !Symbol.FromSource())
                return;

            Context.BindComments(this, Location.Symbol);

            var child = 0;
            foreach (var initializer in
                Symbol.DeclaringSyntaxReferences.
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
                    if (!Symbol.IsStatic)
                    {
                        This.CreateImplicit(Context, Entities.Type.Create(Context, Symbol.ContainingType), Location, access, -1);
                    }
                });
            }

            foreach (var initializer in Symbol.DeclaringSyntaxReferences.
                Select(n => n.GetSyntax()).
                OfType<EnumMemberDeclarationSyntax>().
                Where(n => n.EqualsValue != null))
            {
                // Mark fields that have explicit initializers.
                var expr = new Expression(new ExpressionInfo(Context, Type, Context.Create(initializer.EqualsValue.Value.FixedLocation()), Kinds.ExprKind.FIELD_ACCESS, this, child++, false, null));
                trapFile.expr_access(expr, this);
            }

            if (IsSourceDeclaration)
            {
                foreach (var syntax in Symbol.DeclaringSyntaxReferences.
                   Select(d => d.GetSyntax()).OfType<VariableDeclaratorSyntax>().
                   Select(d => d.Parent).OfType<VariableDeclarationSyntax>())
                {
                    TypeMention.Create(Context, syntax.Type, this, Type);
                }
            }
        }

        readonly Lazy<AnnotatedType> type;
        public AnnotatedType Type => type.Value;

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.WriteSubId(Type.Type);
            trapFile.Write(" ");
            trapFile.WriteSubId(ContainingType);
            trapFile.Write('.');
            trapFile.Write(Symbol.Name);
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
