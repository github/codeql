namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// Describes the relationship between a comment and a program element.
    /// </summary>
    public enum CommentBinding
    {
        Parent,     // The parent element of a comment
        Best,       // The most likely element associated with a comment
        Before,     // The element before the comment
        After       // The element after the comment
    }
}
