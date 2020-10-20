using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Entities.Expressions;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Attribute : CachedEntity<(AttributeData, IEntity)>, IExpressionParentEntity
    {
        bool IExpressionParentEntity.IsTopLevelParent => true;

        private readonly AttributeData attributeData;
        private readonly AttributeSyntax attributeSyntax;
        private readonly IEntity entity;

        private Attribute(Context cx, AttributeData attributeData, IEntity entity)
            : base(cx, (attributeData, entity))
        {
            this.attributeData = attributeData;
            this.attributeSyntax = attributeData.ApplicationSyntaxReference?.GetSyntax() as AttributeSyntax;
            this.entity = entity;
        }

        public override void WriteId(TextWriter trapFile)
        {
            if (ReportingLocation?.IsInSource == true)
            {
                trapFile.WriteSubId(Context.Create(ReportingLocation));
                trapFile.Write(";attribute");
            }
            else
            {
                trapFile.Write('*');
            }
        }

        public override void WriteQuotedId(TextWriter trapFile)
        {
            if (ReportingLocation?.IsInSource == true)
            {
                base.WriteQuotedId(trapFile);
            }
            else
            {
                trapFile.Write('*');
            }
        }

        public override void Populate(TextWriter trapFile)
        {
            var type = Type.Create(Context, attributeData.AttributeClass);
            trapFile.attributes(this, type.TypeRef, entity);

            if (attributeSyntax is object)
            {
                trapFile.attribute_location(this, Context.Create(attributeSyntax.Name.GetLocation()));

                if (Context.Extractor.OutputPath != null)
                {
                    trapFile.attribute_location(this, Assembly.CreateOutputAssembly(Context));
                }

                TypeMention.Create(Context, attributeSyntax.Name, this, type);
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
                return Expression.Create(Context, syntax, parent, childIndex);
            }

            return CreateGeneratedExpressionFromArgument(constant, parent, childIndex);
        }

        private Expression CreateGeneratedExpressionFromArgument(TypedConstant constant, IExpressionParentEntity parent,
            int childIndex)
        {
            if (constant.IsNull)
            {
                return Literal.CreateGeneratedNullLiteral(Context, parent, childIndex);
            }

            switch (constant.Kind)
            {
                case TypedConstantKind.Primitive:
                    return Literal.CreateGenerated(Context, parent, childIndex, constant.Type, constant.Value);
                case TypedConstantKind.Enum:
                    // Enum value is generated in the following format: (Enum)value

                    var cast = Cast.CreateGenerated(Context, parent, childIndex, constant.Type, constant.Value);
                    Literal.CreateGenerated(Context, cast, Cast.ExpressionIndex, ((INamedTypeSymbol)constant.Type).EnumUnderlyingType, constant.Value);
                    TypeAccess.CreateGenerated(Context, cast, Cast.TypeAccessIndex, constant.Type);

                    return cast;
                case TypedConstantKind.Type:
                    var type = ((ITypeSymbol)constant.Value).OriginalDefinition;
                    var t = TypeOf.CreateGenerated(Context, parent, childIndex, type);
                    TypeAccess.CreateGenerated(Context, t, TypeOf.TypeAccessIndex, type);
                    return t;
                case TypedConstantKind.Array:
                    {
                        // Single dimensional arrays are in the following format:
                        // * new Type[N] { item1, item2, ..., itemN }
                        // * new Type[0]
                        //
                        // itemI is generated recursively.

                        var arrayCreation = NormalArrayCreation.CreateGenerated(Context, parent, childIndex, constant.Type, constant.Values.Length);

                        if (constant.Values.Length > 0)
                        {
                            var arrayInit = ArrayInitializer.CreateGenerated(Context, arrayCreation);

                            constant.Values
                                .Select((constantItem, itemIndex) => CreateGeneratedExpressionFromArgument(constantItem, arrayInit, itemIndex))
                                .Where(e => e is object)
                                .ToList();
                        }

                        return arrayCreation;
                    }
                default:
                    Context.ExtractionError("Couldn't extract constant in attribute", entity.ToString(), Context.Create(entity.ReportingLocation));
                    return null;
            }
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;

        public override Microsoft.CodeAnalysis.Location ReportingLocation => attributeSyntax?.Name.GetLocation();

        public override bool NeedsPopulation => true;

        public static void ExtractAttributes(Context cx, ISymbol symbol, IEntity entity)
        {
            foreach (var attribute in symbol.GetAttributes())
            {
                Create(cx, attribute, entity);
            }
        }

        public static Attribute Create(Context cx, AttributeData attributeData, IEntity entity)
        {
            var init = (attributeData, entity);
            return AttributeFactory.Instance.CreateEntity(cx, init, init);
        }

        private class AttributeFactory : ICachedEntityFactory<(AttributeData attributeData, IEntity receiver), Attribute>
        {
            public static readonly AttributeFactory Instance = new AttributeFactory();

            public Attribute Create(Context cx, (AttributeData attributeData, IEntity receiver) init) =>
                new Attribute(cx, init.attributeData, init.receiver);
        }
    }
}
