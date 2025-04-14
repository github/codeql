using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp
{
    public static class CachedEntityFactoryExtensions
    {
        /// <summary>
        /// Creates and populates a new entity, or returns the existing one from the cache,
        /// based on the supplied cache key.
        /// </summary>
        /// <typeparam name="TInit">The type used to construct the entity.</typeparam>
        /// <typeparam name="TEntity">The type of the entity to create.</typeparam>
        /// <param name="factory">The factory used to construct the entity.</param>
        /// <param name="cx">The extractor context.</param>
        /// <param name="cacheKey">The key used for caching.</param>
        /// <param name="init">The initializer for the entity.</param>
        /// <returns>The entity.</returns>
        public static TEntity CreateEntity<TInit, TEntity>(this CachedEntityFactory<TInit, TEntity> factory, Context cx, object cacheKey, TInit init)
            where TEntity : Entities.CachedEntity => cx.CreateEntity(factory, cacheKey, init);

        /// <summary>
        /// Creates and populates a new entity from an `ISymbol`, or returns the existing one
        /// from the cache.
        /// </summary>
        /// <typeparam name="TSymbol">The type used to construct the entity.</typeparam>
        /// <typeparam name="TEntity">The type of the entity to create.</typeparam>
        /// <param name="factory">The factory used to construct the entity.</param>
        /// <param name="cx">The extractor context.</param>
        /// <param name="init">The initializer for the entity.</param>
        /// <returns>The entity.</returns>
        public static TEntity CreateEntityFromSymbol<TSymbol, TEntity>(this CachedEntityFactory<TSymbol, TEntity> factory, Context cx, TSymbol init)
            where TSymbol : ISymbol
            where TEntity : Entities.CachedEntity => cx.CreateEntityFromSymbol(factory, init);
    }
}
