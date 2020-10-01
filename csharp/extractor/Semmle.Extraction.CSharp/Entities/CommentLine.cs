using Semmle.Extraction.CommentProcessing;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    class CommentLine : CachedEntity<(Microsoft.CodeAnalysis.Location, string)>, ICommentLine
    {
        CommentLine(Context cx, Microsoft.CodeAnalysis.Location loc, CommentLineType type, string text, string raw)
            : base(cx, (loc, text))
        {
            Type = type;
            RawText = raw;
        }

        public Microsoft.CodeAnalysis.Location Location => symbol.Item1;
        public CommentLineType Type { get; private set; }

        public string Text { get { return symbol.Item2; } }
        public string RawText { get; private set; }

        public static void Extract(Context cx, SyntaxTrivia trivia)
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

                    for (int line = 0; line < split.Length - 1; ++line)
                    {
                        string fullLine = split[line];
                        var nextLineLocation = currentLocation + fullLine.Length + 1;
                        fullLine = fullLine.TrimEnd('\r');
                        string trimmedLine = fullLine;

                        int leadingSpaces = trimmedLine.IndexOf('/');
                        if (leadingSpaces != -1)
                        {
                            fullLine = fullLine.Substring(leadingSpaces);
                            currentLocation += leadingSpaces;
                            trimmedLine = trimmedLine.Substring(leadingSpaces + 3); // Remove leading spaces and the "///"
                            trimmedLine = trimmedLine.Trim();

                            var span = Microsoft.CodeAnalysis.Text.TextSpan.FromBounds(currentLocation, currentLocation + fullLine.Length);
                            var location = Microsoft.CodeAnalysis.Location.Create(trivia.SyntaxTree, span);
                            var commentType = CommentLineType.XmlDoc;
                            cx.CommentGenerator.AddComment(Create(cx, location, commentType, trimmedLine, fullLine));
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
                        string contents = trivia.ToString().Substring(2);
                        var commentType = CommentLineType.Singleline;
                        if (contents.Length > 0 && contents[0] == '/')
                        {
                            commentType = CommentLineType.XmlDoc;
                            contents = contents.Substring(1);       // An XML comment.
                        }
                        cx.CommentGenerator.AddComment(Create(cx, trivia.GetLocation(), commentType, contents.Trim(), trivia.ToFullString()));
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

                    for (int line = 0; line < split.Length; ++line)
                    {
                        string fullLine = split[line];
                        var nextLineLocation = currentLocation + fullLine.Length + 1;
                        fullLine = fullLine.TrimEnd('\r');
                        string trimmedLine = fullLine;
                        if (line == 0) trimmedLine = trimmedLine.Substring(2);
                        if (line == split.Length - 1) trimmedLine = trimmedLine.Substring(0, trimmedLine.Length - 2);
                        trimmedLine = trimmedLine.Trim();

                        var span = Microsoft.CodeAnalysis.Text.TextSpan.FromBounds(currentLocation, currentLocation + fullLine.Length);
                        var location = Microsoft.CodeAnalysis.Location.Create(trivia.SyntaxTree, span);
                        var commentType = line == 0 ? CommentLineType.Multiline : CommentLineType.MultilineContinuation;
                        cx.CommentGenerator.AddComment(Create(cx, location, commentType, trimmedLine, fullLine));
                        currentLocation = nextLineLocation;
                    }
                    break;
                // Strangely, these are reported as SingleLineCommentTrivia.
                case SyntaxKind.DocumentationCommentExteriorTrivia:
                    cx.ModelError($"Unhandled comment type {trivia.Kind()} for {trivia}");
                    break;
            }
        }

        Extraction.Entities.Location location;

        public override void Populate(TextWriter trapFile)
        {
            location = Context.Create(Location);
            trapFile.commentline(this, Type == CommentLineType.MultilineContinuation ? CommentLineType.Multiline : Type, Text, RawText);
            trapFile.commentline_location(this, location);
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => location.symbol;

        public override bool NeedsPopulation => true;

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.WriteSubId(Context.Create(Location));
            trapFile.Write(";commentline");
        }

        static CommentLine Create(Context cx, Microsoft.CodeAnalysis.Location loc, CommentLineType type, string text, string raw)
        {
            var init = (loc, type, text, raw);
            return CommentLineFactory.Instance.CreateEntity(cx, init, init);
        }

        class CommentLineFactory : ICachedEntityFactory<(Microsoft.CodeAnalysis.Location, CommentLineType, string, string), CommentLine>
        {
            public static readonly CommentLineFactory Instance = new CommentLineFactory();

            public CommentLine Create(Context cx, (Microsoft.CodeAnalysis.Location, CommentLineType, string, string) init) =>
                new CommentLine(cx, init.Item1, init.Item2, init.Item3, init.Item4);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}
