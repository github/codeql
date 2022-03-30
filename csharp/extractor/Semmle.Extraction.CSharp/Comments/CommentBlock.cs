using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.Text;
using Semmle.Extraction.CSharp.Entities;
using System.Collections.Generic;
using System.Linq;

namespace Semmle.Extraction.CSharp.Comments
{
    internal class CommentBlock
    {
        private readonly List<CommentLine> lines;

        public IEnumerable<CommentLine> CommentLines => lines;

        public Location Location { get; private set; }

        public CommentBlock(CommentLine firstLine)
        {
            lines = new List<CommentLine> { firstLine };
            Location = firstLine.Location;
        }

        /// <summary>
        ///     Determine whether commentlines should be merged.
        /// </summary>
        /// <param name="newLine">A comment line to be appended to this comment block.</param>
        /// <returns>Whether the new line should be appended to this block.</returns>
        public bool CombinesWith(CommentLine newLine)
        {
            if (!CommentLines.Any())
                return true;

            var sameFile = Location.SourceTree == newLine.Location.SourceTree;
            var sameRow = Location.EndLine() == newLine.Location.StartLine();
            var sameColumn = Location.EndLine() + 1 == newLine.Location.StartLine();
            var nextRow = Location.StartColumn() == newLine.Location.StartColumn();
            var adjacent = sameFile && (sameRow || (sameColumn && nextRow));

            return
                newLine.Type == CommentLineType.MultilineContinuation ||
                adjacent;
        }

        /// <summary>
        /// Adds a comment line to the this comment block.
        /// </summary>
        /// <param name="line">The line to add.</param>
        public void AddCommentLine(CommentLine line)
        {
            Location = !lines.Any()
                ? line.Location
                : Location.Create(
                    line.Location.SourceTree!,
                    new TextSpan(Location.SourceSpan.Start, line.Location.SourceSpan.End - Location.SourceSpan.Start));

            lines.Add(line);
        }
    }
}
