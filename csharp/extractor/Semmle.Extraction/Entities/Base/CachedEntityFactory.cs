using Microsoft.CodeAnalysis;

namespace Semmle.Extraction
{
    /// <summary>
    /// A factory for creating cached entities.
    /// </summary>
    public abstract class CachedEntityFactory<TInit, TEntity> where TEntity : CachedEntity
    {
        /// <summary>
        /// Initializes the entity, but does not generate any trap code.
        /// </summary>
        public abstract TEntity Create(Context cx, TInit init);
    }
}
