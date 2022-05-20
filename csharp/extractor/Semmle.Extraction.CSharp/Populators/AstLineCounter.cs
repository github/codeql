using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.Populators
{
    internal class AstLineCounter : CSharpSyntaxVisitor<LineCounts>
    {
        public override LineCounts DefaultVisit(SyntaxNode node)
        {
            var text = node.SyntaxTree.GetText().GetSubText(node.GetLocation().SourceSpan).ToString();
            return LineCounter.ComputeLineCounts(text);
        }

        public override LineCounts VisitMethodDeclaration(MethodDeclarationSyntax method)
        {
            return Visit(method.Identifier, GetBody(method));
        }

        public static LineCounts Visit(SyntaxToken identifier, SyntaxNode body)
        {
            var start = identifier.GetLocation().SourceSpan.Start;
            var end = body.GetLocation().SourceSpan.End - 1;

            var textSpan = new Microsoft.CodeAnalysis.Text.TextSpan(start, end - start);

            var text = body.SyntaxTree.GetText().GetSubText(textSpan) + "\r\n";
            return LineCounter.ComputeLineCounts(text);
        }

        public override LineCounts VisitConstructorDeclaration(ConstructorDeclarationSyntax method)
        {
            return Visit(method.Identifier, GetBody(method));
        }

        public override LineCounts VisitDestructorDeclaration(DestructorDeclarationSyntax method)
        {
            return Visit(method.Identifier, GetBody(method));
        }

        public override LineCounts VisitOperatorDeclaration(OperatorDeclarationSyntax node)
        {
            return Visit(node.OperatorToken, GetBody(node));
        }

        private static SyntaxNode GetBody(BaseMethodDeclarationSyntax node)
        {
            return node.Body ?? (SyntaxNode)node.ExpressionBody!;
        }
    }

}
