using System;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.CSharp.Entities;

namespace Semmle.Extraction.CSharp.Populators
{
    /// <summary>
    /// Populators for comments.
    /// </summary>
    internal static class CommentPopulator
    {
        public static void ExtractCommentBlocks(Context cx, CommentProcessor gen)
        {
            cx.Try(null, null, () =>
            {
                gen.GenerateBindings((entity, duplicationGuardKey, block, binding) =>
                {
                    var commentBlock = Entities.CommentBlock.Create(cx, block);
                    Action a = () =>
                    {
                        commentBlock.BindTo(entity, binding);
                    };
                    // When the duplication guard key exists, it means that the entity is guarded against
                    // trap duplication (<see cref = "Context.BindComments(IEntity, Location)" />).
                    // We must therefore also guard comment construction.
                    if (duplicationGuardKey is not null)
                        cx.WithDuplicationGuard(duplicationGuardKey, a);
                    else
                        a();
                });
            });
        }

        public static void ExtractComment(Context cx, SyntaxTrivia trivia)
        {
            switch (trivia.Kind())
            {
                case SyntaxKind.SingleLineDocumentationCommentTrivia:
                    /*
                        This is actually a multi-line comment consisting of /// lines.
                        So split it up.
                    */

                    var text = trivia.ToFullString();

                    var split = text.Split('\n');
                    var currentLocation = trivia.GetLocation().SourceSpan.Start - 3;

                    for (var line = 0; line < split.Length - 1; ++line)
                    {
                        var fullLine = split[line];
                        var nextLineLocation = currentLocation + fullLine.Length + 1;
                        fullLine = fullLine.TrimEnd('\r');
                        var trimmedLine = fullLine;

                        var leadingSpaces = trimmedLine.IndexOf('/');
                        if (leadingSpaces != -1)
                        {
                            fullLine = fullLine.Substring(leadingSpaces);
                            currentLocation += leadingSpaces;
                            trimmedLine = trimmedLine.Substring(leadingSpaces + 3); // Remove leading spaces and the "///"
                            trimmedLine = trimmedLine.Trim();

                            var span = Microsoft.CodeAnalysis.Text.TextSpan.FromBounds(currentLocation, currentLocation + fullLine.Length);
                            var location = Microsoft.CodeAnalysis.Location.Create(trivia.SyntaxTree!, span);
                            var commentType = CommentLineType.XmlDoc;
                            cx.CommentGenerator.AddComment(CommentLine.Create(cx, location, commentType, trimmedLine, fullLine));
                        }
                        else
                        {
                            cx.ModelError("Unexpected comment format");
                        }
                        currentLocation = nextLineLocation;
                    }
                    break;

                case SyntaxKind.SingleLineCommentTrivia:
                    {
                        var contents = trivia.ToString().Substring(2);
                        var commentType = CommentLineType.Singleline;
                        if (contents.Length > 0 && contents[0] == '/')
                        {
                            commentType = CommentLineType.XmlDoc;
                            contents = contents.Substring(1);       // An XML comment.
                        }
                        cx.CommentGenerator.AddComment(CommentLine.Create(cx, trivia.GetLocation(), commentType, contents.Trim(), trivia.ToFullString()));
                    }
                    break;
                case SyntaxKind.MultiLineDocumentationCommentTrivia:
                case SyntaxKind.MultiLineCommentTrivia:
                    /*  We receive a single SyntaxTrivia for a multiline block spanning several lines.
                        So we split it into separate lines
                    */
                    text = trivia.ToFullString();

                    split = text.Split('\n');
                    currentLocation = trivia.GetLocation().SourceSpan.Start;

                    for (var line = 0; line < split.Length; ++line)
                    {
                        var fullLine = split[line];
                        var nextLineLocation = currentLocation + fullLine.Length + 1;
                        fullLine = fullLine.TrimEnd('\r');
                        var trimmedLine = fullLine;
                        if (line == 0)
                            trimmedLine = trimmedLine.Substring(2);
                        if (line == split.Length - 1)
                            trimmedLine = trimmedLine.Substring(0, trimmedLine.Length - 2);
                        trimmedLine = trimmedLine.Trim();

                        var span = Microsoft.CodeAnalysis.Text.TextSpan.FromBounds(currentLocation, currentLocation + fullLine.Length);
                        var location = Microsoft.CodeAnalysis.Location.Create(trivia.SyntaxTree!, span);
                        var commentType = line == 0 ? CommentLineType.Multiline : CommentLineType.MultilineContinuation;
                        cx.CommentGenerator.AddComment(CommentLine.Create(cx, location, commentType, trimmedLine, fullLine));
                        currentLocation = nextLineLocation;
                    }
                    break;
            }
        }
    }
}
