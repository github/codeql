namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// The type of a single comment line.
    /// </summary>
    public enum CommentLineType
    {
        Singleline,             // Comment starting // ...
        XmlDoc,                 // Comment starting /// ...
        Multiline,              // Comment starting /* ..., even if the comment only spans one line.
        MultilineContinuation   // The second and subsequent lines of comment in a multiline comment.
    }
}
