using System;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Entities.Expressions;
using Semmle.Extraction.Kinds;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Property : CachedSymbol<IPropertySymbol>, IExpressionParentEntity
    {
        protected Property(Context cx, IPropertySymbol init)
            : base(cx, init)
        {
            type = new Lazy<Type>(() => Type.Create(base.Context, Symbol.Type));
        }

        private readonly Lazy<Type> type;

        private Type Type => type.Value;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(Type);
            trapFile.Write(" ");
            trapFile.WriteSubId(ContainingType!);
            trapFile.Write('.');
            Method.AddExplicitInterfaceQualifierToId(Context, trapFile, Symbol.ExplicitInterfaceImplementations);
            trapFile.Write(Symbol.Name);
            trapFile.Write(";property");
        }

        public override void Populate(TextWriter trapFile)
        {
            PopulateMetadataHandle(trapFile);
            PopulateAttributes();
            PopulateModifiers(trapFile);
            BindComments();
            PopulateNullability(trapFile, Symbol.GetAnnotatedType());
            PopulateRefKind(trapFile, Symbol.RefKind);

            var type = Type;
            trapFile.properties(this, Symbol.GetName(), ContainingType!, type.TypeRef, Create(Context, Symbol.OriginalDefinition));

            var getter = Symbol.GetMethod;
            var setter = Symbol.SetMethod;

            if (!(getter is null))
                Method.Create(Context, getter);

            if (!(setter is null))
                Method.Create(Context, setter);

            var declSyntaxReferences = IsSourceDeclaration ?
                Symbol.DeclaringSyntaxReferences.
                Select(d => d.GetSyntax()).OfType<PropertyDeclarationSyntax>().ToArray()
                : Enumerable.Empty<PropertyDeclarationSyntax>();

            foreach (var explicitInterface in Symbol.ExplicitInterfaceImplementations.Select(impl => Type.Create(Context, impl.ContainingType)))
            {
                trapFile.explicitly_implements(this, explicitInterface.TypeRef);

                foreach (var syntax in declSyntaxReferences)
                    TypeMention.Create(Context, syntax.ExplicitInterfaceSpecifier!.Name, this, explicitInterface);
            }

            foreach (var l in Locations)
                trapFile.property_location(this, l);

            if (IsSourceDeclaration && Symbol.FromSource())
            {
                var expressionBody = ExpressionBody;
                if (expressionBody is not null)
                {
                    Context.PopulateLater(() => Expression.Create(Context, expressionBody, this, 0));
                }

                var child = 1;
                foreach (var initializer in declSyntaxReferences
                    .Select(n => n.Initializer)
                    .Where(i => i is not null))
                {
                    Context.PopulateLater(() =>
                    {
                        var loc = Context.CreateLocation(initializer!.GetLocation());
                        var annotatedType = AnnotatedTypeSymbol.CreateNotAnnotated(Symbol.Type);
                        var simpleAssignExpr = new Expression(new ExpressionInfo(Context, annotatedType, loc, ExprKind.SIMPLE_ASSIGN, this, child++, false, null));
                        Expression.CreateFromNode(new ExpressionNodeInfo(Context, initializer.Value, simpleAssignExpr, 0));
                        var access = new Expression(new ExpressionInfo(Context, annotatedType, Location, ExprKind.PROPERTY_ACCESS, simpleAssignExpr, 1, false, null));
                        trapFile.expr_access(access, this);
                        if (!Symbol.IsStatic)
                        {
                            This.CreateImplicit(Context, Symbol.ContainingType, Location, access, -1);
                        }
                    });
                }

                foreach (var syntax in declSyntaxReferences)
                    TypeMention.Create(Context, syntax.Type, this, type);
            }
        }

        public override Microsoft.CodeAnalysis.Location FullLocation
        {
            get
            {
                return Symbol.DeclaringSyntaxReferences
                    .Select(r => r.GetSyntax())
                    .OfType<PropertyDeclarationSyntax>()
                    .Select(s => s.GetLocation())
                    .Concat(Symbol.Locations)
                    .First();
            }
        }

        bool IExpressionParentEntity.IsTopLevelParent => true;

        public static Property Create(Context cx, IPropertySymbol prop)
        {
            var isIndexer = prop.IsIndexer || prop.Parameters.Any();

            return isIndexer ? Indexer.Create(cx, prop) : PropertyFactory.Instance.CreateEntityFromSymbol(cx, prop);
        }

        private class PropertyFactory : CachedEntityFactory<IPropertySymbol, Property>
        {
            public static PropertyFactory Instance { get; } = new PropertyFactory();

            public override Property Create(Context cx, IPropertySymbol init) => new Property(cx, init);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.PushesLabel;
    }
}
