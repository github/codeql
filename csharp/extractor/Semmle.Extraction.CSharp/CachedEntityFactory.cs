using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// A factory for creating cached entities.
    /// </summary>
    internal abstract class CachedEntityFactory<TInit, TEntity>
        : Extraction.CachedEntityFactory<TInit, TEntity> where TEntity : CachedEntity
    {
        /// <summary>
        /// Initializes the entity, but does not generate any trap code.
        /// </summary>
        public sealed override TEntity Create(Extraction.Context cx, TInit init)
        {
            return Create((Context)cx, init);
        }

        public override bool IsShared(TInit init)
        {
            return
                base.IsShared(init) &&
                !(init is ITypeSymbol type && type.ContainsAnonymousType()) &&
                !(init is IMethodSymbol method && method.ContainsAnonymousType()) &&
                !(init is ISymbol symbol && symbol.ContainingType?.ContainsAnonymousType() == true);
        }

        public abstract TEntity Create(Context cx, TInit init);
    }
}
