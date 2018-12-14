using System.Collections.Generic;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.Text;
using Semmle.Util;

namespace Semmle.Extraction.CommentProcessing
{
    // The lexical type of the comment.
    public enum CommentType
    {
        Singleline,             // Comment starting // ...
        XmlDoc,                 // Comment starting /// ...
        Multiline,              // Comment starting /* ..., even if the comment only spans one line.
        MultilineContinuation   // The second and subsequent lines of comment in a multiline comment.
    };

    // Relationship between a comment and a program element.
    public enum Binding
    {
        Parent,     // The parent element of a comment
        Best,       // The most likely element associated with a comment
        Before,     // The element before the comment
        After       // The element after the comment
    };

    /// <summary>
    ///     A single line of text in a comment.
    /// </summary>
    public interface ICommentLine
    {
        Location Location { get; }
        CommentType Type { get; }

        // Trimmed text of the comment.
        string Text { get; }

        // Complete text of the comment including leading/trailing whitespace and comment markers.
        string RawText { get; }
    }

    /// <summary>
    ///     A block of comment lines combined into one unit.
    /// </summary>
    public interface ICommentBlock
    {
        Location Location { get; }
        IList<ICommentLine> CommentLines { get; }
    }

    /// <summary>
    ///     Output for generated comment associations.
    /// </summary>
    /// <param name="elementLabel">The label of the element</param>
    /// <param name="duplicationGuardKey">The duplication guard key of the element, if any</param>
    /// <param name="commentBlock">The comment block associated with the element</param>
    /// <param name="binding">The relationship between the commentblock and the element</param>
    public delegate void CommentBinding(Label elementLabel, Key duplicationGuardKey, ICommentBlock commentBlock, Binding binding);

    /// <summary>
    ///     Used by the populator to generate binding information between comments and program elements.
    /// </summary>
    public interface ICommentGenerator
    {
        /// <summary>
        ///     Registers the location of a program element to associate comments with.
        ///     Can be called in any order.
        /// </summary>
        /// <param name="elementLabel">Label of the element.</param>
        /// <param name="duplicationGuardKey">The duplication guard key of the element, if any.</param>
        /// <param name="location">Location of the element.</param>
        void RegisterElementLocation(Label elementLabel, Key duplicationGuardKey, Location location);

        void AddComment(ICommentLine comment);

        /// <summary>
        ///     Generate all binding information.
        /// </summary>
        /// <param name="cb">Receiver of the binding information.</param>
        void GenerateBindings(CommentBinding cb);
    }

    static class LocationExtension
    {
        public static int StartLine(this Location loc) => loc.GetLineSpan().Span.Start.Line;

        public static int StartColumn(this Location loc) => loc.GetLineSpan().Span.Start.Character;


        public static int EndLine(this Location loc) => loc.GetLineSpan().Span.End.Line;

        /// <summary>
        ///     Whether one Location outer completely contains another Location inner.
        /// </summary>
        /// <param name="outer">The outer location.</param>
        /// <param name="inner">The inner location</param>
        /// <returns>Whether inner is completely container in outer.</returns>
        public static bool Contains(this Location outer, Location inner)
        {
            bool sameFile = outer.SourceTree == inner.SourceTree;
            bool startsBefore = outer.SourceSpan.Start <= inner.SourceSpan.Start;
            bool endsAfter = outer.SourceSpan.End >= inner.SourceSpan.End;
            return sameFile && startsBefore && endsAfter;
        }

        /// <summary>
        ///     Whether one Location ends before another starts.
        /// </summary>
        /// <param name="before">The Location coming before</param>
        /// <param name="after">The Location coming after</param>
        /// <returns>Whether 'before' comes before 'after'.</returns>
        public static bool Before(this Location before, Location after)
        {
            bool sameFile = before.SourceTree == after.SourceTree;
            bool endsBefore = before.SourceSpan.End <= after.SourceSpan.Start;
            return sameFile && endsBefore;
        }
    }

    /// <summary>
    ///     Implements the comment processor.
    ///     Registers locations of comments and program elements,
    ///     then generates binding information.
    /// </summary>
    class CommentProcessor : ICommentGenerator
    {
        public void AddComment(ICommentLine comment)
        {
            comments[comment.Location] = comment;
        }

        // Comments sorted by location.
        readonly SortedDictionary<Location, ICommentLine> comments = new SortedDictionary<Location, ICommentLine>(new LocationComparer());

        // Program elements sorted by location.
        readonly SortedDictionary<Location, Label> elements = new SortedDictionary<Location, Label>(new LocationComparer());

        readonly Dictionary<Label, Key> duplicationGuardKeys = new Dictionary<Label, Key>();

        Key GetDuplicationGuardKey(Label label)
        {
            Key duplicationGuardKey;
            if (duplicationGuardKeys.TryGetValue(label, out duplicationGuardKey))
                return duplicationGuardKey;
            return null;
        }

        class LocationComparer : IComparer<Location>
        {
            public int Compare(Location l1, Location l2) => CommentProcessor.Compare(l1, l2);
        }

        /// <summary>
        ///     Comparer for two locations, allowing them to be inserted into a sorted list.
        /// </summary>
        /// <param name="l1">First location</param>
        /// <param name="l2">Second location</param>
        /// <returns>&lt;0 if l1 before l2, &gt;0 if l1 after l2, else 0.</returns>
        static int Compare(Location l1, Location l2)
        {
            int diff = l1.SourceTree == l2.SourceTree ? 0 : l1.SourceTree.FilePath.CompareTo(l2.SourceTree.FilePath);
            if (diff != 0) return diff;
            diff = l1.SourceSpan.Start - l2.SourceSpan.Start;
            if (diff != 0) return diff;
            return l1.SourceSpan.End - l2.SourceSpan.End;
        }

        /// <summary>
        ///     Called by the populator when there is a program element which can have comments.
        /// </summary>
        /// <param name="elementLabel">The label of the element in the trap file.</param>
        /// <param name="duplicationGuardKey">The duplication guard key of the element, if any.</param>
        /// <param name="loc">The location of the element.</param>
        public void RegisterElementLocation(Label elementLabel, Key duplicationGuardKey, Location loc)
        {
            if (loc != null && loc.IsInSource)
                elements[loc] = elementLabel;
            if (duplicationGuardKey != null)
                duplicationGuardKeys[elementLabel] = duplicationGuardKey;
        }

        // Ensure that commentBlock and element refer to the same file
        // which can happen when processing multiple files.
        void EnsureSameFile(ICommentBlock commentBlock, ref KeyValuePair<Location, Label>? element)
        {
            if (element != null && element.Value.Key.SourceTree != commentBlock.Location.SourceTree)
                element = null;
        }

        /// <summary>
        ///     Generate the bindings between a comment and program elements.
        ///     Called once for each commentBlock.
        /// </summary>
        ///
        /// <param name="commentBlock">The comment block.</param>
        /// <param name="previousElement">The element before the comment block.</param>
        /// <param name="nextElement">The element after the comment block.</param>
        /// <param name="parentElement">The parent element of the comment block.</param>
        /// <param name="cb">Output binding information.</param>
        void GenerateBindings(
            ICommentBlock commentBlock,
            KeyValuePair<Location, Label>? previousElement,
            KeyValuePair<Location, Label>? nextElement,
            KeyValuePair<Location, Label>? parentElement,
            CommentBinding cb
            )
        {
            EnsureSameFile(commentBlock, ref previousElement);
            EnsureSameFile(commentBlock, ref nextElement);
            EnsureSameFile(commentBlock, ref parentElement);

            if (previousElement != null)
            {
                var key = previousElement.Value.Value;
                cb(key, GetDuplicationGuardKey(key), commentBlock, Binding.Before);
            }

            if (nextElement != null)
            {
                var key = nextElement.Value.Value;
                cb(key, GetDuplicationGuardKey(key), commentBlock, Binding.After);
            }

            if (parentElement != null)
            {
                var key = parentElement.Value.Value;
                cb(key, GetDuplicationGuardKey(key), commentBlock, Binding.Parent);
            }

            // Heuristic to decide which is the "best" element associated with the comment.
            KeyValuePair<Location, Label>? bestElement;

            if (previousElement != null && previousElement.Value.Key.EndLine() == commentBlock.Location.StartLine())
            {
                // 1. If the comment is on the same line as the previous element, use that
                bestElement = previousElement;
            }
            else if (nextElement != null && nextElement.Value.Key.StartLine() == commentBlock.Location.EndLine())
            {
                // 2. If the comment is on the same line as the next element, use that
                bestElement = nextElement;
            }
            else if (nextElement != null && previousElement != null &&
                previousElement.Value.Key.EndLine() + 1 == commentBlock.Location.StartLine() &&
                commentBlock.Location.EndLine() + 1 == nextElement.Value.Key.StartLine())
            {
                // 3. If comment is equally between two elements, use the parentElement
                // because it's ambiguous whether the comment refers to the next or previous element
                bestElement = parentElement;
            }
            else if (nextElement != null && nextElement.Value.Key.StartLine() == commentBlock.Location.EndLine() + 1)
            {
                // 4. If there is no gap after the comment, use "nextElement"
                bestElement = nextElement;
            }
            else if (previousElement != null && previousElement.Value.Key.EndLine() + 1 == commentBlock.Location.StartLine())
            {
                // 5. If there is no gap before the comment, use previousElement
                bestElement = previousElement;
            }
            else
            {
                // 6. Otherwise, bind the comment to the parent block.
                bestElement = parentElement;

                /* if parentElement==null, then there is no best element. The comment is effectively orphaned.
                 *
                 * This can be caused by comments that are not in a type declaration.
                 * Due to restrictions in the dbscheme, the comment cannot be associated with the "file"
                 * which is not an element, and the "using" declarations are not emitted by the extractor.
                 */
            }

            if (bestElement != null)
            {
                var label = bestElement.Value.Value;
                cb(label, GetDuplicationGuardKey(label), commentBlock, Binding.Best);
            }
        }

        // Stores element nesting information in a stack.
        // Top of stack = most nested element, based on Location.
        class ElementStack
        {
            // Invariant: the top of the stack must be contained by items below it.
            readonly Stack<KeyValuePair<Location, Label>> elementStack = new Stack<KeyValuePair<Location, Label>>();

            /// <summary>
            ///     Add a new element to the stack.
            /// </summary>
            /// The stack is maintained.
            /// <param name="value">The new element to push.</param>
            public void Push(KeyValuePair<Location, Label> value)
            {
                // Maintain the invariant by popping existing elements
                while (elementStack.Count > 0 && !elementStack.Peek().Key.Contains(value.Key))
                    elementStack.Pop();

                elementStack.Push(value);
            }

            /// <summary>
            ///     Locate the parent of a comment with location l.
            /// </summary>
            /// <param name="l">The location of the comment.</param>
            /// <returns>An element completely containing l, or null if none found.</returns>
            public KeyValuePair<Location, Label>? FindParent(Location l) =>
                elementStack.Where(v => v.Key.Contains(l)).FirstOrNull();

            /// <summary>
            ///     Finds the element on the stack immediately preceding the comment at l.
            /// </summary>
            /// <param name="l">The location of the comment.</param>
            /// <returns>The element before l, or null.</returns>
            public KeyValuePair<Location, Label>? FindBefore(Location l)
            {
                return elementStack.
                    Where(v => v.Key.SourceSpan.End < l.SourceSpan.Start).
                    LastOrNull();
            }

            /// <summary>
            ///     Finds the element after the comment.
            /// </summary>
            /// <param name="comment">The location of the comment.</param>
            /// <param name="next">The next element.</param>
            /// <returns>The next element.</returns>
            public KeyValuePair<Location, Label>? FindAfter(Location comment, KeyValuePair<Location, Label>? next)
            {
                var p = FindParent(comment);
                return next.HasValue && p.HasValue && p.Value.Key.Before(next.Value.Key) ? null : next;
            }
        }

        // Generate binding information for one CommentBlock.
        void GenerateBindings(
            ICommentBlock block,
            ElementStack elementStack,
            KeyValuePair<Location, Label>? nextElement,
            CommentBinding cb
            )
        {
            if (block.CommentLines.Count > 0)
            {
                GenerateBindings(
                    block,
                    elementStack.FindBefore(block.Location),
                    elementStack.FindAfter(block.Location, nextElement),
                    elementStack.FindParent(block.Location),
                    cb);
            }
        }

        /// <summary>
        ///     Process comments up until nextElement.
        ///     Group comments into blocks, and associate blocks with elements.
        /// </summary>
        /// <param name="commentEnumerator">Enumerator for all comments in the program.</param>
        /// <param name="nextElement">The next element in the list.</param>
        /// <param name="elementStack">A stack of nested program elements.</param>
        /// <param name="cb">Where to send the results.</param>
        /// <returns>true if there are more comments to process, false otherwise.</returns>
        bool GenerateBindings(
            IEnumerator<KeyValuePair<Location, ICommentLine>> commentEnumerator,
            KeyValuePair<Location, Label>? nextElement,
            ElementStack elementStack,
            CommentBinding cb
            )
        {
            CommentBlock block = new CommentBlock();

            // Iterate comments until the commentEnumerator has gone past nextElement
            while (nextElement == null || Compare(commentEnumerator.Current.Value.Location, nextElement.Value.Key) < 0)
            {
                if (!block.CombinesWith(commentEnumerator.Current.Value))
                {
                    // Start of a new block, so generate the bindings for the old block first.
                    GenerateBindings(block, elementStack, nextElement, cb);
                    block = new CommentBlock();
                }

                block.AddCommentLine(commentEnumerator.Current.Value);

                // Get the next comment.
                if (!commentEnumerator.MoveNext())
                {
                    // If there are no more comments, generate the remaining bindings and return false.
                    GenerateBindings(block, elementStack, nextElement, cb);
                    return false;
                }
            }

            GenerateBindings(block, elementStack, nextElement, cb);
            return true;
        }

        /// <summary>
        ///     Merge comments into blocks and associate comment blocks with program elements.
        /// </summary>
        /// <param name="cb">Callback for the binding information</param>
        public void GenerateBindings(CommentBinding cb)
        {
            /* Algorithm:
             * Do a merge of elements and comments, which are both sorted in location order.
             *
             * Iterate through all elements, and iterate all comment lines between adjacent pairs of elements.
             * Maintain a stack of elements, such that the top of the stack must be fully nested in the
             * element below it. This enables comments to be associated with the "parent" element, as well as
             * elements before, after and "best" element match for a comment.
             *
             * This is an O(n) algorithm because the list of elements and comments are traversed once.
             * (Note that comment processing is O(n.log n) overall due to dictionary of elements and comments.)
            */

            ElementStack elementStack = new ElementStack();

            using (IEnumerator<KeyValuePair<Location, Label>> elementEnumerator = elements.GetEnumerator())
            using (IEnumerator<KeyValuePair<Location, ICommentLine>> commentEnumerator = comments.GetEnumerator())
            {
                if (!commentEnumerator.MoveNext())
                {
                    // There are no comments to process.
                    return;
                }

                while (elementEnumerator.MoveNext())
                {
                    if (!GenerateBindings(commentEnumerator, elementEnumerator.Current, elementStack, cb))
                    {
                        // No more comments to process.
                        return;
                    }

                    elementStack.Push(elementEnumerator.Current);
                }

                // Generate remaining comments at end of file
                GenerateBindings(commentEnumerator, null, elementStack, cb);
            }
        }
    }

    class CommentBlock : ICommentBlock
    {
        public IList<ICommentLine> CommentLines { get; } = new List<ICommentLine>();

        public Location Location { get; private set; }

        /// <summary>
        ///     Determine whether commentlines should be merged.
        /// </summary>
        /// <param name="newLine">A comment line to be appended to this comment block.</param>
        /// <returns>Whether the new line should be appended to this block.</returns>
        public bool CombinesWith(ICommentLine newLine)
        {
            if (CommentLines.Count == 0) return true;

            bool sameFile = Location.SourceTree == newLine.Location.SourceTree;
            bool sameRow = Location.EndLine() == newLine.Location.StartLine();
            bool sameColumn = Location.EndLine() + 1 == newLine.Location.StartLine();
            bool nextRow = Location.StartColumn() == newLine.Location.StartColumn();
            bool adjacent = sameFile && (sameRow || (sameColumn && nextRow));

            return
                newLine.Type == CommentType.MultilineContinuation ||
                adjacent;
        }

        /// <summary>
        ///     Adds a comment line to the this comment block.
        /// </summary>
        /// <param name="line">The line to add.</param>
        public void AddCommentLine(ICommentLine line)
        {
            Location = CommentLines.Count == 0 ?
                line.Location :
                Location.Create(line.Location.SourceTree, new TextSpan(Location.SourceSpan.Start, line.Location.SourceSpan.End - Location.SourceSpan.Start));
            CommentLines.Add(line);
        }
    }
}

