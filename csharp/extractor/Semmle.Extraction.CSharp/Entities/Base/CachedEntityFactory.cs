namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// A factory for creating cached entities.
    /// </summary>
    public abstract class CachedEntityFactory<TInit, TEntity> where TEntity : Entities.CachedEntity
    {
        public abstract TEntity Create(Context cx, TInit init);
    }
}
