using Microsoft.CodeAnalysis;
using System.Collections.Generic;

namespace Semmle.Extraction.CommentProcessing
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
    };

    /// <summary>
    /// Describes the relationship between a comment and a program element.
    /// </summary>
    public enum CommentBinding
    {
        Parent,     // The parent element of a comment
        Best,       // The most likely element associated with a comment
        Before,     // The element before the comment
        After       // The element after the comment
    };

    /// <summary>
    /// A single line in a comment.
    /// </summary>
    public interface ICommentLine
    {
        /// <summary>
        /// The location of this comment line.
        /// </summary>
        Location Location { get; }

        /// <summary>
        /// The type of this comment line.
        /// </summary>
        CommentLineType Type { get; }

        /// <summary>
        /// The text body of this comment line, excluding comment delimiter and leading and trailing whitespace.
        /// </summary>
        string Text { get; }

        /// <summary>
        /// Full text of the comment including leading/trailing whitespace and comment delimiters.
        /// </summary>
        string RawText { get; }
    }

    /// <summary>
    /// A block of comment lines combined into one unit.
    /// </summary>
    public interface ICommentBlock
    {
        /// <summary>
        /// The full span of this comment block.
        /// </summary>
        Location Location { get; }

        /// <summary>
        /// The individual lines in the comment.
        /// </summary>
        IEnumerable<ICommentLine> CommentLines { get; }
    }

    /// <summary>
    /// Callback for generated comment associations.
    /// </summary>
    /// <param name="elementLabel">The label of the element</param>
    /// <param name="duplicationGuardKey">The duplication guard key of the element, if any</param>
    /// <param name="commentBlock">The comment block associated with the element</param>
    /// <param name="binding">The relationship between the commentblock and the element</param>
    public delegate void CommentBindingCallback(Label elementLabel, Key? duplicationGuardKey, ICommentBlock commentBlock, CommentBinding binding);

    /// <summary>
    /// Computes the binding information between comments and program elements.
    /// </summary>
    public interface ICommentGenerator
    {
        /// <summary>
        /// Registers the location of a program element to associate comments with.
        /// This can be called in any order.
        /// </summary>
        /// <param name="elementLabel">Label of the element.</param>
        /// <param name="duplicationGuardKey">The duplication guard key of the element, if any.</param>
        /// <param name="location">Location of the element.</param>
        void AddElement(Label elementLabel, Key? duplicationGuardKey, Location location);

        /// <summary>
        /// Registers a line of comment.
        /// </summary>
        /// <param name="comment">The comment to register.</param>
        void AddComment(ICommentLine comment);

        /// <summary>
        /// Computes the binding information and calls `cb` with all of the comment binding information.
        /// </summary>
        /// <param name="cb">Receiver of the binding information.</param>
        void GenerateBindings(CommentBindingCallback cb);
    }
}
