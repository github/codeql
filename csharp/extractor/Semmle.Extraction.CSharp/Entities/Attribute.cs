using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Attribute : CachedEntity<AttributeData>, IExpressionParentEntity
    {
        bool IExpressionParentEntity.IsTopLevelParent => true;

        private readonly AttributeSyntax? attributeSyntax;
        private readonly IEntity entity;

        private Attribute(Context cx, AttributeData attributeData, IEntity entity)
            : base(cx, attributeData)
        {
            this.attributeSyntax = attributeData.ApplicationSyntaxReference?.GetSyntax() as AttributeSyntax;
            this.entity = entity;
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            if (ReportingLocation?.IsInSource == true)
            {
                trapFile.WriteSubId(Location);
                trapFile.Write(";attribute");
            }
            else
            {
                trapFile.Write('*');
            }
        }

        public sealed override void WriteQuotedId(EscapingTextWriter trapFile)
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
            var type = Type.Create(Context, Symbol.AttributeClass);
            trapFile.attributes(this, type.TypeRef, entity);
            trapFile.attribute_location(this, Location);

            if (attributeSyntax is not null)
            {
                if (!Context.Extractor.Standalone)
                {
                    trapFile.attribute_location(this, Assembly.CreateOutputAssembly(Context));
                }

                TypeMention.Create(Context, attributeSyntax.Name, this, type);
            }

            ExtractArguments(trapFile);
        }

        private void ExtractArguments(TextWriter trapFile)
        {
            var ctorArguments = attributeSyntax?.ArgumentList?.Arguments.Where(a => a.NameEquals is null).ToList();

            var childIndex = 0;
            for (var i = 0; i < Symbol.ConstructorArguments.Length; i++)
            {
                var constructorArgument = Symbol.ConstructorArguments[i];
                var paramName = Symbol.AttributeConstructor?.Parameters[i].Name;
                var argSyntax = ctorArguments?.SingleOrDefault(a => a.NameColon is not null && a.NameColon.Name.Identifier.Text == paramName);

                if (argSyntax is null &&                            // couldn't find named argument
                    ctorArguments?.Count > childIndex &&            // there're more arguments
                    ctorArguments[childIndex].NameColon is null)    // the argument is positional
                {
                    argSyntax = ctorArguments[childIndex];
                }

                CreateExpressionFromArgument(
                    constructorArgument,
                    argSyntax?.Expression,
                    this,
                    childIndex++);
            }

            foreach (var namedArgument in Symbol.NamedArguments)
            {
                var expr = CreateExpressionFromArgument(
                    namedArgument.Value,
                    attributeSyntax?.ArgumentList?.Arguments.Single(a => a.NameEquals?.Name?.Identifier.Text == namedArgument.Key).Expression,
                    this,
                    childIndex++);

                if (expr is not null)
                {
                    trapFile.expr_argument_name(expr, namedArgument.Key);
                }
            }
        }

        private Expression? CreateExpressionFromArgument(TypedConstant constant, ExpressionSyntax? syntax, IExpressionParentEntity parent,
            int childIndex)
        {
            return syntax is null
                ? Expression.CreateGenerated(Context, constant, parent, childIndex, Location)
                : Expression.Create(Context, syntax, parent, childIndex);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;

        public override Microsoft.CodeAnalysis.Location? ReportingLocation => attributeSyntax?.Name.GetLocation();

        private Semmle.Extraction.Entities.Location? location;

        private Semmle.Extraction.Entities.Location Location =>
            location ??= Context.CreateLocation(attributeSyntax is null
                ? entity.ReportingLocation
                : attributeSyntax.Name.GetLocation());

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
            return AttributeFactory.Instance.CreateEntity(cx, attributeData, init);
        }

        private class AttributeFactory : CachedEntityFactory<(AttributeData attributeData, IEntity receiver), Attribute>
        {
            public static readonly AttributeFactory Instance = new AttributeFactory();

            public override Attribute Create(Context cx, (AttributeData attributeData, IEntity receiver) init) =>
                new Attribute(cx, init.attributeData, init.receiver);
        }
    }
}
