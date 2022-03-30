namespace Semmle.Extraction.CSharp.Entities
{
    /// <summary>
    /// Whether this entity is the parent of a top-level statement.
    /// </summary>
    public interface IStatementParentEntity : IEntity
    {
        bool IsTopLevelParent { get; }
    }
}
