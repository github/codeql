using Microsoft.CodeAnalysis;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    internal sealed class Nullability
    {
        public int Annotation { get; }

        private static readonly Nullability[] emptyArray = System.Array.Empty<Nullability>();
        public IEnumerable<Nullability> NullableParameters { get; }

        public static Nullability Create(AnnotatedTypeSymbol ts)
        {
            if (ts.HasConsistentNullability())
            {
                switch (ts.Nullability)
                {
                    case NullableAnnotation.Annotated:
                        return annotated;
                    case NullableAnnotation.NotAnnotated:
                        return notannotated;
                    default:
                        return oblivious;
                }
            }

            return new Nullability(ts);
        }

        public bool IsOblivious => Annotation == 0 && !NullableParameters.Any();

        private static readonly Nullability oblivious = new Nullability(NullableAnnotation.None);
        private static readonly Nullability annotated = new Nullability(NullableAnnotation.Annotated);
        private static readonly Nullability notannotated = new Nullability(NullableAnnotation.NotAnnotated);

        private Nullability(NullableAnnotation n)
        {
            switch (n)
            {
                case NullableAnnotation.NotAnnotated:
                    Annotation = 1;
                    break;
                case NullableAnnotation.Annotated:
                    Annotation = 2;
                    break;
                default:
                    Annotation = 0;
                    break;
            }
            NullableParameters = emptyArray;
        }

        private Nullability(AnnotatedTypeSymbol ts) : this(ts.Nullability)
        {
            NullableParameters = ts.HasConsistentNullability() ? emptyArray : ts.GetAnnotatedTypeArguments().Select(Create).ToArray();
        }

        public Nullability(IMethodSymbol method)
        {
            Annotation = 0;
            NullableParameters = method.GetAnnotatedTypeArguments().Select(a => new Nullability(a)).ToArray();
        }

        public override bool Equals(object? other)
        {
            return other is Nullability n && Annotation == n.Annotation && NullableParameters.SequenceEqual(n.NullableParameters);
        }

        public override int GetHashCode()
        {
            var h = Annotation;

            foreach (var t in NullableParameters)
                h = h * 5 + t.GetHashCode();

            return h;
        }

        public void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write(Annotation);
            trapFile.Write('(');
            foreach (var s in NullableParameters)
                s.WriteId(trapFile);
            trapFile.Write(')');
        }

        public override string ToString()
        {
            using var w = new EscapingTextWriter();
            WriteId(w);
            return w.ToString();
        }
    }

    internal class NullabilityEntity : CachedEntity<Nullability>
    {
        public NullabilityEntity(Context cx, Nullability init) : base(cx, init)
        {
        }

        public override Location ReportingLocation => throw new System.NotImplementedException();

        public override bool NeedsPopulation => true;

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;

        public override void Populate(TextWriter trapFile)
        {
            trapFile.nullability(this, Symbol.Annotation);

            var i = 0;
            foreach (var s in Symbol.NullableParameters)
            {
                trapFile.nullability_parent(Create(Context, s), i, this);
                i++;
            }
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            Symbol.WriteId(trapFile);
        }

        public static NullabilityEntity Create(Context cx, Nullability init) => NullabilityFactory.Instance.CreateEntity(cx, init, init);

        private class NullabilityFactory : CachedEntityFactory<Nullability, NullabilityEntity>
        {
            public static NullabilityFactory Instance { get; } = new NullabilityFactory();

            public override NullabilityEntity Create(Context cx, Nullability init) => new NullabilityEntity(cx, init);
        }
    }

    public static class NullabilityExtensions
    {
        /// <summary>
        /// Gets the annotated type of an ILocalSymbol.
        /// This has not yet been exposed on the public API.
        /// </summary>
        public static AnnotatedTypeSymbol GetAnnotatedType(this ILocalSymbol symbol) => new AnnotatedTypeSymbol(symbol.Type, symbol.NullableAnnotation);

        /// <summary>
        /// Gets the annotated type of an IParameterSymbol.
        /// This has not yet been exposed on the public API.
        /// </summary>
        public static AnnotatedTypeSymbol GetAnnotatedType(this IParameterSymbol symbol) => new AnnotatedTypeSymbol(symbol.Type, symbol.NullableAnnotation);

        /// <summary>
        /// Gets the annotated type of an IPropertySymbol.
        /// This has not yet been exposed on the public API.
        /// </summary>
        public static AnnotatedTypeSymbol GetAnnotatedType(this IPropertySymbol symbol) => new AnnotatedTypeSymbol(symbol.Type, symbol.NullableAnnotation);

        /// <summary>
        /// Gets the annotated type of an IEventSymbol.
        /// This has not yet been exposed on the public API.
        /// </summary>
        public static AnnotatedTypeSymbol GetAnnotatedType(this IEventSymbol symbol) => new AnnotatedTypeSymbol(symbol.Type, symbol.NullableAnnotation);

        /// <summary>
        /// Gets the annotated type of an IFieldSymbol.
        /// This has not yet been exposed on the public API.
        /// </summary>
        public static AnnotatedTypeSymbol GetAnnotatedType(this IFieldSymbol symbol) => new AnnotatedTypeSymbol(symbol.Type, symbol.NullableAnnotation);

        /// <summary>
        /// Gets the annotated return type of an IMethodSymbol.
        /// This has not yet been exposed on the public API.
        /// </summary>
        public static AnnotatedTypeSymbol GetAnnotatedReturnType(this IMethodSymbol symbol) => new AnnotatedTypeSymbol(symbol.ReturnType, symbol.ReturnNullableAnnotation);

        /// <summary>
        /// Gets the type annotation for a NullableAnnotation.
        /// </summary>
        public static Kinds.TypeAnnotation GetTypeAnnotation(this NullableAnnotation na)
        {
            switch (na)
            {
                case NullableAnnotation.Annotated:
                    return Kinds.TypeAnnotation.Annotated;
                case NullableAnnotation.NotAnnotated:
                    return Kinds.TypeAnnotation.NotAnnotated;
                default:
                    return Kinds.TypeAnnotation.None;
            }
        }

        public static IEnumerable<AnnotatedTypeSymbol> GetAnnotatedTypeArguments(this AnnotatedTypeSymbol at)
        {
            switch (at.Symbol)
            {
                case IArrayTypeSymbol array:
                    yield return array.GetAnnotatedElementType();
                    break;
                case INamedTypeSymbol named:
                    foreach (var n in named.GetAnnotatedTypeArguments())
                        yield return n;
                    break;
            }
        }

        /// <summary>
        /// Checks if this type has consistent nullability, which is the most common case.
        /// Either the code is oblivious to nullability, or is non-nullable.
        /// This is so that we can avoid populating nullability in most cases.
        /// For example,
        /// <code>
        /// IEnumerable&lt;string?&gt // false
        /// IEnumerable&lt;string?&gt? // true
        /// string? // true
        /// string[] // true
        /// string?[] // false
        /// string?[]? // true
        /// </code>
        /// </summary>
        /// <param name="at">The annotated type.</param>
        /// <returns>If the nullability is consistent in the type.</returns>
        public static bool HasConsistentNullability(this AnnotatedTypeSymbol at) =>
            at.GetAnnotatedTypeArguments().All(a => a.Nullability == at.Nullability && a.HasConsistentNullability());

        /// <summary>
        /// Holds if the type symbol is completely oblivious to nullability.
        /// </summary>
        /// <param name="at">The annotated type symbol.</param>
        /// <returns>If at is oblivious.</returns>
        public static bool HasObliviousNullability(this AnnotatedTypeSymbol at) =>
            at.Nullability.GetTypeAnnotation() == Kinds.TypeAnnotation.None && at.HasConsistentNullability();

        /// <summary>
        /// Gets the annotated element type of an IArrayTypeSymbol.
        /// This has not yet been exposed on the public API.
        /// </summary>
        public static AnnotatedTypeSymbol GetAnnotatedElementType(this IArrayTypeSymbol symbol) =>
            new AnnotatedTypeSymbol(symbol.ElementType, symbol.ElementNullableAnnotation);

        /// <summary>
        /// Gets the annotated type arguments of an INamedTypeSymbol.
        /// This has not yet been exposed on the public API.
        /// </summary>
        public static IEnumerable<AnnotatedTypeSymbol> GetAnnotatedTypeArguments(this INamedTypeSymbol symbol) =>
            symbol.TypeArguments.Zip(symbol.TypeArgumentNullableAnnotations, (t, a) => new AnnotatedTypeSymbol(t, a));

        /// <summary>
        /// Gets the annotated type arguments of an IMethodSymbol.
        /// This has not yet been exposed on the public API.
        /// </summary>
        public static IEnumerable<AnnotatedTypeSymbol> GetAnnotatedTypeArguments(this IMethodSymbol symbol) =>
            symbol.TypeArguments.Zip(symbol.TypeArgumentNullableAnnotations, (t, a) => new AnnotatedTypeSymbol(t, a));

        /// <summary>
        /// Gets the annotated type constraints of an ITypeParameterSymbol.
        /// This has not yet been exposed on the public API.
        /// </summary>
        public static IEnumerable<AnnotatedTypeSymbol> GetAnnotatedTypeConstraints(this ITypeParameterSymbol symbol) =>
            symbol.ConstraintTypes.Zip(symbol.ConstraintNullableAnnotations, (t, a) => new AnnotatedTypeSymbol(t, a));

        /// <summary>
        /// Creates an AnnotatedTypeSymbol from an ITypeSymbol.
        /// </summary>
        public static AnnotatedTypeSymbol WithAnnotation(this ITypeSymbol symbol, NullableAnnotation annotation) =>
            new AnnotatedTypeSymbol(symbol, annotation);
    }
}
