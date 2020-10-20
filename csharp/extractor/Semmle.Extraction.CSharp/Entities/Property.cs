using System;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Entities.Expressions;
using Semmle.Extraction.Entities;
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
            type = new Lazy<Type>(() => Type.Create(Context, symbol.Type));
        }

        private readonly Lazy<Type> type;

        private Type Type => type.Value;

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.WriteSubId(Type);
            trapFile.Write(" ");
            trapFile.WriteSubId(ContainingType);
            trapFile.Write('.');
            Method.AddExplicitInterfaceQualifierToId(Context, trapFile, symbol.ExplicitInterfaceImplementations);
            trapFile.Write(symbol.Name);
            trapFile.Write(";property");
        }

        public override void Populate(TextWriter trapFile)
        {
            PopulateMetadataHandle(trapFile);
            PopulateAttributes();
            PopulateModifiers(trapFile);
            BindComments();
            PopulateNullability(trapFile, symbol.GetAnnotatedType());
            PopulateRefKind(trapFile, symbol.RefKind);

            var type = Type;
            trapFile.properties(this, symbol.GetName(), ContainingType, type.TypeRef, Create(Context, symbol.OriginalDefinition));

            var getter = symbol.GetMethod;
            var setter = symbol.SetMethod;

            if (!(getter is null))
                Method.Create(Context, getter);

            if (!(setter is null))
                Method.Create(Context, setter);

            var declSyntaxReferences = IsSourceDeclaration ?
                symbol.DeclaringSyntaxReferences.
                Select(d => d.GetSyntax()).OfType<PropertyDeclarationSyntax>().ToArray()
                : Enumerable.Empty<PropertyDeclarationSyntax>();

            foreach (var explicitInterface in symbol.ExplicitInterfaceImplementations.Select(impl => Type.Create(Context, impl.ContainingType)))
            {
                trapFile.explicitly_implements(this, explicitInterface.TypeRef);

                foreach (var syntax in declSyntaxReferences)
                    TypeMention.Create(Context, syntax.ExplicitInterfaceSpecifier.Name, this, explicitInterface);
            }

            foreach (var l in Locations)
                trapFile.property_location(this, l);

            if (IsSourceDeclaration && symbol.FromSource())
            {
                var expressionBody = ExpressionBody;
                if (expressionBody != null)
                {
                    Context.PopulateLater(() => Expression.Create(Context, expressionBody, this, 0));
                }

                var child = 1;
                foreach (var initializer in declSyntaxReferences
                    .Select(n => n.Initializer)
                    .Where(i => i != null))
                {
                    Context.PopulateLater(() =>
                    {
                        var loc = Context.Create(initializer.GetLocation());
                        var annotatedType = new AnnotatedType(type, NullableAnnotation.None);
                        var simpleAssignExpr = new Expression(new ExpressionInfo(Context, annotatedType, loc, ExprKind.SIMPLE_ASSIGN, this, child++, false, null));
                        Expression.CreateFromNode(new ExpressionNodeInfo(Context, initializer.Value, simpleAssignExpr, 0));
                        var access = new Expression(new ExpressionInfo(Context, annotatedType, Location, ExprKind.PROPERTY_ACCESS, simpleAssignExpr, 1, false, null));
                        trapFile.expr_access(access, this);
                        if (!symbol.IsStatic)
                        {
                            This.CreateImplicit(Context, Type.Create(Context, symbol.ContainingType), Location, access, -1);
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
                return symbol.DeclaringSyntaxReferences
                    .Select(r => r.GetSyntax())
                    .OfType<PropertyDeclarationSyntax>()
                    .Select(s => s.GetLocation())
                    .Concat(symbol.Locations)
                    .First();
            }
        }

        bool IExpressionParentEntity.IsTopLevelParent => true;

        public static Property Create(Context cx, IPropertySymbol prop)
        {
            var isIndexer = prop.IsIndexer || prop.Parameters.Any();

            return isIndexer ? Indexer.Create(cx, prop) : PropertyFactory.Instance.CreateEntityFromSymbol(cx, prop);
        }

        private class PropertyFactory : ICachedEntityFactory<IPropertySymbol, Property>
        {
            public static PropertyFactory Instance { get; } = new PropertyFactory();

            public Property Create(Context cx, IPropertySymbol init) => new Property(cx, init);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.PushesLabel;
    }
}
