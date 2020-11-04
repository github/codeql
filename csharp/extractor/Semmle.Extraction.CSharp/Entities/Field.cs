using Microsoft.CodeAnalysis;
using System.Linq;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System;
using Semmle.Extraction.Entities;
using Semmle.Extraction.Kinds;
using Semmle.Extraction.CSharp.Entities.Expressions;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Field : CachedSymbol<IFieldSymbol>, IExpressionParentEntity
    {
        private Field(Context cx, IFieldSymbol init)
            : base(cx, init)
        {
            type = new Lazy<AnnotatedType>(() => Entities.Type.Create(cx, symbol.GetAnnotatedType()));
        }

        public static Field Create(Context cx, IFieldSymbol field) => FieldFactory.Instance.CreateEntityFromSymbol(cx, field);

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

            var unboundFieldKey = Field.Create(Context, symbol.OriginalDefinition);
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

            var child = 0;
            foreach (var initializer in symbol.DeclaringSyntaxReferences
                .Select(n => n.GetSyntax())
                .OfType<VariableDeclaratorSyntax>()
                .Where(n => n.Initializer != null))
            {
                Context.PopulateLater(() =>
                {
                    var loc = Context.Create(initializer.GetLocation());

                    var fieldAccess = AddInitializerAssignment(trapFile, initializer.Initializer.Value, loc, null, ref child);

                    if (!symbol.IsStatic)
                    {
                        This.CreateImplicit(Context, Entities.Type.Create(Context, symbol.ContainingType), Location, fieldAccess, -1);
                    }
                });
            }

            foreach (var initializer in symbol.DeclaringSyntaxReferences
                .Select(n => n.GetSyntax())
                .OfType<EnumMemberDeclarationSyntax>()
                .Where(n => n.EqualsValue != null))
            {
                // Mark fields that have explicit initializers.
                var constValue = symbol.HasConstantValue
                    ? Expression.ValueAsString(symbol.ConstantValue)
                    : null;

                var loc = Context.Create(initializer.GetLocation());

                AddInitializerAssignment(trapFile, initializer.EqualsValue.Value, loc, constValue, ref child);
            }

            if (IsSourceDeclaration)
            {
                foreach (var syntax in symbol.DeclaringSyntaxReferences
                  .Select(d => d.GetSyntax())
                  .OfType<VariableDeclaratorSyntax>()
                  .Select(d => d.Parent)
                  .OfType<VariableDeclarationSyntax>())
                {
                    TypeMention.Create(Context, syntax.Type, this, Type);
                }
            }
        }

        private Expression AddInitializerAssignment(TextWriter trapFile, ExpressionSyntax initializer, Extraction.Entities.Location loc,
            string constValue, ref int child)
        {
            var simpleAssignExpr = new Expression(new ExpressionInfo(Context, Type, loc, ExprKind.SIMPLE_ASSIGN, this, child++, false, constValue));
            Expression.CreateFromNode(new ExpressionNodeInfo(Context, initializer, simpleAssignExpr, 0));
            var access = new Expression(new ExpressionInfo(Context, Type, Location, ExprKind.FIELD_ACCESS, simpleAssignExpr, 1, false, constValue));
            trapFile.expr_access(access, this);
            return access;
        }

        private readonly Lazy<AnnotatedType> type;
        public AnnotatedType Type => type.Value;

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.WriteSubId(Type.Type);
            trapFile.Write(" ");
            trapFile.WriteSubId(ContainingType);
            trapFile.Write('.');
            trapFile.Write(symbol.Name);
            trapFile.Write(";field");
        }

        bool IExpressionParentEntity.IsTopLevelParent => true;

        private class FieldFactory : ICachedEntityFactory<IFieldSymbol, Field>
        {
            public static FieldFactory Instance { get; } = new FieldFactory();

            public Field Create(Context cx, IFieldSymbol init) => new Field(cx, init);
        }
        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.PushesLabel;
    }
}
