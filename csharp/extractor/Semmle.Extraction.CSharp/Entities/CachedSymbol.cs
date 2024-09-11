using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection.Metadata;
using System.Reflection.Metadata.Ecma335;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Entities
{
    internal abstract class CachedSymbol<T> : CachedEntity<T> where T : class, ISymbol
    {
        protected CachedSymbol(Context cx, T init)
            : base(cx, init)
        {
        }

        public virtual Type? ContainingType => Symbol.ContainingType is not null
            ? Symbol.ContainingType.IsTupleType
                ? NamedType.CreateNamedTypeFromTupleType(Context, Symbol.ContainingType)
                : Type.Create(Context, Symbol.ContainingType)
            : null;

        public void PopulateModifiers(TextWriter trapFile)
        {
            Modifier.ExtractModifiers(Context, trapFile, this, Symbol);
        }

        protected void PopulateAttributes()
        {
            // Only extract attributes for source declarations
            if (ReferenceEquals(Symbol, Symbol.OriginalDefinition))
                Attribute.ExtractAttributes(Context, Symbol, this);
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
                case RefKind.RefReadOnlyParameter:
                    trapFile.type_annotation(this, Kinds.TypeAnnotation.ReadonlyRef);
                    break;
            }
        }

        protected void PopulateScopedKind(TextWriter trapFile, ScopedKind kind)
        {
            switch (kind)
            {
                case ScopedKind.ScopedRef:
                    trapFile.scoped_annotation(this, Kinds.ScopedAnnotation.ScopedRef);
                    break;
                case ScopedKind.ScopedValue:
                    trapFile.scoped_annotation(this, Kinds.ScopedAnnotation.ScopedValue);
                    break;
            }
        }

        protected void ExtractCompilerGenerated(TextWriter trapFile)
        {
            if (Symbol.IsImplicitlyDeclared)
                trapFile.compiler_generated(this);
        }

        /// <summary>
        /// The location which is stored in the database and is used when highlighting source code.
        /// It's generally short, e.g. a method name.
        /// </summary>
        public override Microsoft.CodeAnalysis.Location? ReportingLocation => Symbol.Locations.BestOrDefault();

        /// <summary>
        /// The full text span of the entity, e.g. for binding comments.
        /// </summary>
        public virtual Microsoft.CodeAnalysis.Location? FullLocation => Symbol.Locations.BestOrDefault();

        public virtual IEnumerable<Extraction.Entities.Location> Locations
        {
            get
            {
                var loc = ReportingLocation;
                if (loc is not null)
                {
                    // Some built in operators lack locations, so loc is null.
                    yield return Context.CreateLocation(ReportingLocation);
                    if (loc.Kind == LocationKind.SourceFile)
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
            if (!Symbol.IsImplicitlyDeclared && IsSourceDeclaration && Symbol.FromSource())
                Context.BindComments(this, FullLocation);
        }

        protected virtual T BodyDeclaringSymbol => Symbol;

        public BlockSyntax? Block
        {
            get
            {
                return BodyDeclaringSymbol.DeclaringSyntaxReferences
                    .SelectMany(r => r.GetSyntax().ChildNodes())
                    .OfType<BlockSyntax>()
                    .FirstOrDefault();
            }
        }

        public ExpressionSyntax? ExpressionBody
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

        public virtual bool IsSourceDeclaration => Symbol.IsSourceDeclaration();

        public override bool NeedsPopulation => Context.Defines(Symbol);

        public Extraction.Entities.Location Location => Context.CreateLocation(ReportingLocation);

        protected void PopulateMetadataHandle(TextWriter trapFile)
        {
            var handle = MetadataHandle;

            if (handle.HasValue)
                trapFile.metadata_handle(this, Location, MetadataTokens.GetToken(handle.Value));
        }

        private static System.Reflection.PropertyInfo? GetPropertyInfo(object o, string name)
        {
            return o.GetType().GetProperty(name, System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.GetProperty);
        }

        public Handle? MetadataHandle
        {
            get
            {
                var handleProp = GetPropertyInfo(Symbol, "Handle");
                object handleObj = Symbol;

                if (handleProp is null)
                {
                    var underlyingSymbolProp = GetPropertyInfo(Symbol, "UnderlyingSymbol");
                    if (underlyingSymbolProp?.GetValue(Symbol) is object underlying)
                    {
                        handleProp = GetPropertyInfo(underlying, "Handle");
                        handleObj = underlying;
                    }
                }

                if (handleProp is not null)
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
