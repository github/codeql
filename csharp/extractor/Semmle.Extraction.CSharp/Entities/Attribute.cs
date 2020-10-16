using System;
using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Entities.Expressions;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Attribute : FreshEntity, IExpressionParentEntity
    {
        bool IExpressionParentEntity.IsTopLevelParent => true;

        private readonly AttributeData attributeData;
        private readonly AttributeSyntax attributeSyntax;
        private readonly IEntity entity;

        public Attribute(Context cx, AttributeData attributeData, IEntity entity)
            : base(cx)
        {
            this.attributeData = attributeData;
            this.attributeSyntax = attributeData.ApplicationSyntaxReference?.GetSyntax() as AttributeSyntax;
            this.entity = entity;

            TryPopulate();
        }

        protected override void Populate(TextWriter trapFile)
        {
            var type = Type.Create(cx, attributeData.AttributeClass);
            trapFile.attributes(this, type.TypeRef, entity);

            if (attributeSyntax is object)
            {
                trapFile.attribute_location(this, cx.Create(attributeSyntax.Name.GetLocation()));

                if (cx.Extractor.OutputPath != null)
                {
                    trapFile.attribute_location(this, Assembly.CreateOutputAssembly(cx));
                }

                TypeMention.Create(cx, attributeSyntax.Name, this, type);
            }

            ExtractArguments(trapFile);
        }

        private void ExtractArguments(TextWriter trapFile)
        {
            var childIndex = 0;
            foreach (var constructorArgument in attributeData.ConstructorArguments)
            {
                CreateExpressionFromArgument(
                    constructorArgument,
                    attributeSyntax?.ArgumentList.Arguments[childIndex].Expression,
                    this,
                    childIndex);

                childIndex++;
            }

            foreach (var namedArgument in attributeData.NamedArguments)
            {
                var expr = CreateExpressionFromArgument(
                    namedArgument.Value,
                    attributeSyntax?.ArgumentList.Arguments.Single(a => a.NameEquals?.Name?.Identifier.Text == namedArgument.Key).Expression,
                    this,
                    childIndex++);

                if (expr is object)
                {
                    trapFile.expr_argument_name(expr, namedArgument.Key);
                }
            }
        }

        private Expression CreateExpressionFromArgument(TypedConstant constant, ExpressionSyntax syntax, IExpressionParentEntity parent,
            int childIndex)
        {
            if (syntax is object)
            {
                return Expression.Create(cx, syntax, parent, childIndex);
            }

            return CreateGeneratedExpressionFromArgument(constant, parent, childIndex);
        }

        private Expression CreateGeneratedExpressionFromArgument(TypedConstant constant, IExpressionParentEntity parent,
            int childIndex)
        {
            if (constant.IsNull)
            {
                return Literal.CreateGeneratedNullLiteral(cx, parent, childIndex);
            }

            switch (constant.Kind)
            {
                case TypedConstantKind.Primitive:
                    return Literal.CreateGenerated(cx, parent, childIndex, constant.Type, constant.Value);
                case TypedConstantKind.Enum:
                    // Enum value is generated in the following format: (Enum)value

                    var cast = Cast.CreateGenerated(cx, parent, childIndex, constant.Type, constant.Value);
                    Literal.CreateGenerated(cx, cast, Cast.ExpressionIndex, ((INamedTypeSymbol)constant.Type).EnumUnderlyingType, constant.Value);
                    TypeAccess.CreateGenerated(cx, cast, Cast.TypeAccessIndex, constant.Type);

                    return cast;
                case TypedConstantKind.Type:
                    var type = ((ITypeSymbol)constant.Value).OriginalDefinition;
                    var t = TypeOf.CreateGenerated(cx, parent, childIndex, type);
                    TypeAccess.CreateGenerated(cx, t, TypeOf.TypeAccessIndex, type);
                    return t;
                case TypedConstantKind.Array:
                    {
                        // Single dimensional arrays are in the following format:
                        // * new Type[N] { item1, item2, ..., itemN }
                        // * new Type[0]
                        //
                        // itemI is generated recursively.

                        var arrayCreation = NormalArrayCreation.CreateGenerated(cx, parent, childIndex, constant.Type, constant.Values.Length);

                        if (constant.Values.Length > 0)
                        {
                            var arrayInit = ArrayInitializer.CreateGenerated(cx, arrayCreation);

                            constant.Values
                                .Select((constantItem, itemIndex) => CreateGeneratedExpressionFromArgument(constantItem, arrayInit, itemIndex))
                                .Where(e => e is object)
                                .ToList();
                        }

                        return arrayCreation;
                    }
                default:
                    cx.ExtractionError("Couldn't extract constant in attribute", entity.ToString(), cx.Create(entity.ReportingLocation));
                    return null;
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
