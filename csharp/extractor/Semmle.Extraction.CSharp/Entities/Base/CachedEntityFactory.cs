namespace Semmle.Extraction
{
    /// <summary>
    /// A factory for creating cached entities.
    /// </summary>
    public abstract class CachedEntityFactory<TInit, TEntity> where TEntity : Semmle.Extraction.CachedEntity
    {
        /// <summary>
        /// Initializes the entity, but does not generate any trap code.
        /// </summary>
        public abstract TEntity Create(Semmle.Extraction.Context cx, TInit init);
    }
}
