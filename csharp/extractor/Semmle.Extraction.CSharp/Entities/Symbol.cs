using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection.Metadata;
using System.Reflection.Metadata.Ecma335;

namespace Semmle.Extraction.CSharp.Entities
{
    public abstract class CachedSymbol<T> : CachedEntity<T> where T : ISymbol
    {
        protected CachedSymbol(Context cx, T init)
            : base(cx, init) { }

        public virtual Type ContainingType => symbol.ContainingType != null ? Type.Create(Context, symbol.ContainingType) : null;

        public void PopulateModifiers(TextWriter trapFile)
        {
            Modifier.ExtractModifiers(Context, trapFile, this, symbol);
        }

        protected void PopulateAttributes()
        {
            // Only extract attributes for source declarations
            if (ReferenceEquals(symbol, symbol.OriginalDefinition))
                Attribute.ExtractAttributes(Context, symbol, this);
        }

        protected void PopulateNullability(TextWriter trapFile, AnnotatedTypeSymbol type)
        {
            var n = NullabilityEntity.Create(Context, Nullability.Create(type));
            if (!type.HasObliviousNullability())
            {
                trapFile.type_nullability(this, n);
            }
        }

        protected void PopulateRefKind(TextWriter trapFile, RefKind kind)
        {
            switch (kind)
            {
                case RefKind.Out:
                    trapFile.type_annotation(this, Kinds.TypeAnnotation.Out);
                    break;
                case RefKind.Ref:
                    trapFile.type_annotation(this, Kinds.TypeAnnotation.Ref);
                    break;
                case RefKind.RefReadOnly:
                    trapFile.type_annotation(this, Kinds.TypeAnnotation.ReadonlyRef);
                    break;
            }
        }

        protected void ExtractCompilerGenerated(TextWriter trapFile)
        {
            if (symbol.IsImplicitlyDeclared)
                trapFile.compiler_generated(this);
        }

        /// <summary>
        /// The location which is stored in the database and is used when highlighing source code.
        /// It's generally short, e.g. a method name.
        /// </summary>
        public override Microsoft.CodeAnalysis.Location ReportingLocation => symbol.Locations.FirstOrDefault();

        /// <summary>
        /// The full text span of the entity, e.g. for binding comments.
        /// </summary>
        public virtual Microsoft.CodeAnalysis.Location FullLocation => symbol.Locations.FirstOrDefault();

        public virtual IEnumerable<Extraction.Entities.Location> Locations
        {
            get
            {
                var loc = ReportingLocation;
                if (loc != null)
                {
                    // Some built in operators lack locations, so loc is null.
                    yield return Context.Create(ReportingLocation);
                    if (Context.Extractor.OutputPath != null && loc.Kind == LocationKind.SourceFile)
                        yield return Assembly.CreateOutputAssembly(Context);
                }
            }
        }

        /// <summary>
        /// Bind comments to this symbol.
        /// Comments are only bound to source declarations.
        /// </summary>
        protected void BindComments()
        {
            if (!symbol.IsImplicitlyDeclared && IsSourceDeclaration && symbol.FromSource())
                Context.BindComments(this, FullLocation);
        }

        protected virtual T BodyDeclaringSymbol => symbol;

        public BlockSyntax Block
        {
            get
            {
                return BodyDeclaringSymbol.DeclaringSyntaxReferences
                    .SelectMany(r => r.GetSyntax().ChildNodes())
                    .OfType<BlockSyntax>()
                    .FirstOrDefault();
            }
        }

        public ExpressionSyntax ExpressionBody
        {
            get
            {
                return BodyDeclaringSymbol.DeclaringSyntaxReferences
                    .SelectMany(r => r.GetSyntax().ChildNodes())
                    .OfType<ArrowExpressionClauseSyntax>()
                    .Select(arrow => arrow.Expression)
                    .FirstOrDefault();
            }
        }

        public virtual bool IsSourceDeclaration => symbol.IsSourceDeclaration();

        public override bool NeedsPopulation => Context.Defines(symbol);

        public Extraction.Entities.Location Location => Context.Create(ReportingLocation);

        protected void PopulateMetadataHandle(TextWriter trapFile)
        {
            var handle = MetadataHandle;

            if (handle.HasValue)
                trapFile.metadata_handle(this, Location, MetadataTokens.GetToken(handle.Value));
        }

        private static System.Reflection.PropertyInfo GetPropertyInfo(object o, string name)
        {
            return o.GetType().GetProperty(name, System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.GetProperty);
        }

        public Handle? MetadataHandle
        {
            get
            {
                var handleProp = GetPropertyInfo(symbol, "Handle");
                object handleObj = symbol;

                if (handleProp is null)
                {
                    var underlyingSymbolProp = GetPropertyInfo(symbol, "UnderlyingSymbol");
                    if (underlyingSymbolProp is object)
                    {
                        if (underlyingSymbolProp.GetValue(symbol) is object underlying)
                        {
                            handleProp = GetPropertyInfo(underlying, "Handle");
                            handleObj = underlying;
                        }
                    }
                }

                if (handleProp is object)
                {
                    switch (handleProp.GetValue(handleObj))
                    {
                        case MethodDefinitionHandle md: return md;
                        case TypeDefinitionHandle td: return td;
                        case PropertyDefinitionHandle pd: return pd;
                        case FieldDefinitionHandle fd: return fd;
                    }
                }

                return null;
            }
        }
    }
}
