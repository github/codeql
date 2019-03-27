using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using Semmle.Extraction.Entities;
using System.Collections.Generic;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    class Attribute : FreshEntity, IExpressionParentEntity
    {
        bool IExpressionParentEntity.IsTopLevelParent => true;

        public Attribute(Context cx, AttributeData attribute, IEntity entity)
            : base(cx)
        {
            if (attribute.ApplicationSyntaxReference != null)
            {
                // !! Extract attributes from assemblies.
                // This is harder because the "expression" entities presume the
                // existence of a syntax tree. This is not the case for compiled
                // attributes.
                var syntax = attribute.ApplicationSyntaxReference.GetSyntax() as AttributeSyntax;
                ExtractAttribute(syntax, attribute.AttributeClass, entity);
            }
        }

        public Attribute(Context cx, AttributeSyntax attribute, IEntity entity)
            : base(cx)
        {
            var info = cx.GetSymbolInfo(attribute);
            ExtractAttribute(attribute, info.Symbol.ContainingType, entity);
        }

        void ExtractAttribute(AttributeSyntax syntax, ITypeSymbol attributeClass, IEntity entity)
        {
            var type = Type.Create(cx, attributeClass);
            cx.Emit(Tuples.attributes(this, type.TypeRef, entity));

            cx.Emit(Tuples.attribute_location(this, cx.Create(syntax.Name.GetLocation())));

            if (cx.Extractor.OutputPath != null)
                cx.Emit(Tuples.attribute_location(this, Assembly.CreateOutputAssembly(cx)));

            TypeMention.Create(cx, syntax.Name, this, type);

            if (syntax.ArgumentList != null)
            {
                cx.PopulateLater(() =>
                {
                    int child = 0;
                    foreach (var arg in syntax.ArgumentList.Arguments)
                    {
                        var expr = Expression.Create(cx, arg.Expression, this, child++);
                        if (!(arg.NameEquals is null))
                        {
                            cx.Emit(Tuples.expr_argument_name(expr, arg.NameEquals.Name.Identifier.Text));
                        }
                    }
                });
            }
        }

        public static void ExtractAttributes(Context cx, ISymbol symbol, IEntity entity)
        {
            foreach (var attribute in symbol.GetAttributes())
            {
                new Attribute(cx, attribute, entity);
            }
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}
