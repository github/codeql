using System;
using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Entities.Expressions;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Field : CachedSymbol<IFieldSymbol>, IExpressionParentEntity
    {
        private Field(Context cx, IFieldSymbol init)
            : base(cx, init)
        {
            type = new Lazy<Type>(() => Entities.Type.Create(cx, Symbol.Type));
        }

        public static Field Create(Context cx, IFieldSymbol field) => FieldFactory.Instance.CreateEntityFromSymbol(cx, field.CorrespondingTupleField ?? field);

        // Do not populate backing fields.
        // Populate Tuple fields.
        public override bool NeedsPopulation =>
            (base.NeedsPopulation && !Symbol.IsImplicitlyDeclared) || Symbol.ContainingType.IsTupleType;

        public override void Populate(TextWriter trapFile)
        {
            PopulateAttributes();
            ContainingType!.PopulateGenerics();
            PopulateNullability(trapFile, Symbol.GetAnnotatedType());
            PopulateRefKind(trapFile, Symbol.RefKind);

            var unboundFieldKey = Field.Create(Context, Symbol.OriginalDefinition);
            var kind = Symbol.IsConst ? VariableKind.Const : VariableKind.None;
            trapFile.fields(this, kind, Symbol.Name, ContainingType, Type.TypeRef, unboundFieldKey);

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
            foreach (var initializer in Symbol.DeclaringSyntaxReferences
                .Select(n => n.GetSyntax())
                .OfType<VariableDeclaratorSyntax>()
                .Where(n => n.Initializer is not null))
            {
                Context.PopulateLater(() =>
                {
                    var loc = Context.CreateLocation(initializer.GetLocation());

                    var fieldAccess = AddInitializerAssignment(trapFile, initializer.Initializer!.Value, loc, null, ref child);

                    if (!Symbol.IsStatic)
                    {
                        This.CreateImplicit(Context, Symbol.ContainingType, Location, fieldAccess, -1);
                    }
                });
            }

            foreach (var initializer in Symbol.DeclaringSyntaxReferences
                .Select(n => n.GetSyntax())
                .OfType<EnumMemberDeclarationSyntax>()
                .Where(n => n.EqualsValue is not null))
            {
                // Mark fields that have explicit initializers.
                var constValue = Symbol.HasConstantValue
                    ? Expression.ValueAsString(Symbol.ConstantValue)
                    : null;

                var loc = Context.CreateLocation(initializer.GetLocation());

                AddInitializerAssignment(trapFile, initializer.EqualsValue!.Value, loc, constValue, ref child);
            }

            if (IsSourceDeclaration)
            {
                foreach (var syntax in Symbol.DeclaringSyntaxReferences
                  .Select(d => d.GetSyntax())
                  .OfType<VariableDeclaratorSyntax>()
                  .Select(d => d.Parent)
                  .OfType<VariableDeclarationSyntax>())
                {
                    TypeMention.Create(Context, syntax.Type, this, Type);
                }
            }
        }

        private Expression AddInitializerAssignment(TextWriter trapFile, ExpressionSyntax initializer, Location loc,
            string? constValue, ref int child)
        {
            var type = Symbol.GetAnnotatedType();
            var simpleAssignExpr = new Expression(new ExpressionInfo(Context, type, loc, ExprKind.SIMPLE_ASSIGN, this, child++, isCompilerGenerated: true, constValue));
            Expression.CreateFromNode(new ExpressionNodeInfo(Context, initializer, simpleAssignExpr, 0));
            var access = new Expression(new ExpressionInfo(Context, type, Location, ExprKind.FIELD_ACCESS, simpleAssignExpr, 1, isCompilerGenerated: true, constValue));
            trapFile.expr_access(access, this);
            return access;
        }

        private readonly Lazy<Type> type;
        public Type Type => type.Value;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(Type);
            trapFile.Write(" ");
            trapFile.WriteSubId(ContainingType!);
            trapFile.Write('.');
            trapFile.Write(Symbol.Name);
            trapFile.Write(";field");
        }

        bool IExpressionParentEntity.IsTopLevelParent => true;

        private class FieldFactory : CachedEntityFactory<IFieldSymbol, Field>
        {
            public static FieldFactory Instance { get; } = new FieldFactory();

            public override Field Create(Context cx, IFieldSymbol init) => new Field(cx, init);
        }
        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.PushesLabel;
    }
}
