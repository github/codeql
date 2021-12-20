using Microsoft.CodeAnalysis;

namespace Semmle.Extraction
{
    /// <summary>
    /// A factory for creating cached entities.
    /// </summary>
    public abstract class CachedEntityFactory<TInit, TEntity> where TEntity : CachedEntity
    {
        /// <summary>
        /// Indicates whether the entity created from `init` should be persisted in the shared
        /// TRAP file.
        /// </summary>
        public virtual bool IsShared(TInit init) => false;

        /// <summary>
        /// Initializes the entity, but does not generate any trap code.
        /// </summary>
        public abstract TEntity Create(Context cx, TInit init);
    }
}
