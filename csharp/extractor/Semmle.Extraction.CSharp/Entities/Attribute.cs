using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using Semmle.Extraction.Entities;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    class Attribute : FreshEntity, IExpressionParentEntity
    {
        bool IExpressionParentEntity.IsTopLevelParent => true;

        private readonly AttributeData attributeData;
        private readonly IEntity entity;

        public Attribute(Context cx, AttributeData attribute, IEntity entity)
            : base(cx)
        {
            attributeData = attribute;
            this.entity = entity;
            TryPopulate();
        }

        protected override void Populate(TextWriter trapFile)
        {
            if (attributeData.ApplicationSyntaxReference != null)
            {
                // !! Extract attributes from assemblies.
                // This is harder because the "expression" entities presume the
                // existence of a syntax tree. This is not the case for compiled
                // attributes.
                var syntax = attributeData.ApplicationSyntaxReference.GetSyntax() as AttributeSyntax;
                ExtractAttribute(Cx.TrapWriter.Writer, syntax, attributeData.AttributeClass, entity);
            }
        }

        public Attribute(Context cx, AttributeSyntax attribute, IEntity entity)
            : base(cx)
        {
            var info = cx.GetSymbolInfo(attribute);
            ExtractAttribute(cx.TrapWriter.Writer, attribute, info.Symbol.ContainingType, entity);
        }

        void ExtractAttribute(System.IO.TextWriter trapFile, AttributeSyntax syntax, ITypeSymbol attributeClass, IEntity entity)
        {
            var type = Type.Create(Cx, attributeClass);
            trapFile.attributes(this, type.TypeRef, entity);

            trapFile.attribute_location(this, Cx.Create(syntax.Name.GetLocation()));

            if (Cx.Extractor.OutputPath != null)
                trapFile.attribute_location(this, Assembly.CreateOutputAssembly(Cx));

            TypeMention.Create(Cx, syntax.Name, this, type);

            if (syntax.ArgumentList != null)
            {
                Cx.PopulateLater(() =>
                {
                    var child = 0;
                    foreach (var arg in syntax.ArgumentList.Arguments)
                    {
                        var expr = Expression.Create(Cx, arg.Expression, this, child++);
                        if (!(arg.NameEquals is null))
                        {
                            trapFile.expr_argument_name(expr, arg.NameEquals.Name.Identifier.Text);
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
