namespace Semmle.Extraction.CSharp.Entities
{
    public interface IExpressionParentEntity : IEntity
    {
        /// <summary>
        /// Whether this entity is the parent of a top-level expression.
        /// </summary>
        bool IsTopLevelParent { get; }
    }
}
