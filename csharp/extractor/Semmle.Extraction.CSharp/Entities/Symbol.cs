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
        public CachedSymbol(Context cx, T init)
            : base(cx, init) { }

        public virtual Type ContainingType => symbol.ContainingType != null ? Type.Create(Context, symbol.ContainingType) : null;

        public void ExtractModifiers()
        {
            Modifier.ExtractModifiers(Context, this, symbol);
        }

        protected void ExtractAttributes()
        {
            // Only extract attributes for source declarations
            if (ReferenceEquals(symbol, symbol.OriginalDefinition))
                Attribute.ExtractAttributes(Context, symbol, this);
        }

        protected void ExtractNullability(TextWriter trapFile, NullableAnnotation annotation)
        {
            var ta = annotation.GetTypeAnnotation();
            if (ta != Kinds.TypeAnnotation.None)
                trapFile.Emit(Tuples.type_annotation(this, ta));
        }

        protected void ExtractRefKind(TextWriter trapFile, RefKind kind)
        {
            switch (kind)
            {
                case RefKind.Out:
                    trapFile.Emit(Tuples.type_annotation(this, Kinds.TypeAnnotation.Out));
                    break;
                case RefKind.Ref:
                    trapFile.Emit(Tuples.type_annotation(this, Kinds.TypeAnnotation.Ref));
                    break;
                case RefKind.RefReadOnly:
                    trapFile.Emit(Tuples.type_annotation(this, Kinds.TypeAnnotation.ReadonlyRef));
                    break;
            }
        }

        protected void ExtractCompilerGenerated(TextWriter trapFile)
        {
            if (symbol.IsImplicitlyDeclared)
                trapFile.Emit(Tuples.compiler_generated(this));
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

        public BlockSyntax Block
        {
            get
            {
                return symbol.
                    DeclaringSyntaxReferences.
                    Select(r => r.GetSyntax()).
                    SelectMany(n => n.ChildNodes()).
                    OfType<BlockSyntax>().
                    FirstOrDefault();
            }
        }

        public ExpressionSyntax ExpressionBody
        {
            get
            {
                return symbol.
                    DeclaringSyntaxReferences.
                    SelectMany(r => r.GetSyntax().ChildNodes()).
                    OfType<ArrowExpressionClauseSyntax>().
                    Select(arrow => arrow.Expression).
                    FirstOrDefault();
            }
        }

        public virtual bool IsSourceDeclaration => symbol.IsSourceDeclaration();

        public override bool NeedsPopulation => Context.Defines(symbol);

        public Extraction.Entities.Location Location => Context.Create(ReportingLocation);

        protected void ExtractMetadataHandle(TextWriter trapFile)
        {
            var handle = MetadataHandle;

            if (handle.HasValue)
                trapFile.Emit(Tuples.metadata_handle(this, Location, MetadataTokens.GetToken(handle.Value)));
        }

        public Handle? MetadataHandle
        {
            get
            {
                var propertyInfo = symbol.GetType().GetProperty("Handle",
                    System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.GetProperty);

                if (propertyInfo != null)
                {
                    switch (propertyInfo.GetValue(symbol))
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
