namespace Semmle.Extraction
{
    /// <summary>
    /// A factory for creating cached entities.
    /// </summary>
    /// <typeparam name="TInit">The type of the initializer.</typeparam>
    public interface ICachedEntityFactory<in TInit, out TEntity> where TEntity : CachedEntity
    {
        /// <summary>
        /// Initializes the entity, but does not generate any trap code.
        /// </summary>
        TEntity Create(Context cx, TInit init);
    }
}
