using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Util;
using System.IO;

namespace Semmle.Extraction.CSharp.Populators
{
    public static class LineCounter
    {
        class AstLineCounter : CSharpSyntaxVisitor<LineCounts>
        {
            public override LineCounts DefaultVisit(SyntaxNode node)
            {
                string text = node.SyntaxTree.GetText().GetSubText(node.GetLocation().SourceSpan).ToString();
                return Semmle.Util.LineCounter.ComputeLineCounts(text);
            }

            public override LineCounts VisitMethodDeclaration(MethodDeclarationSyntax method)
            {
                return Visit(method.Identifier, method.Body ?? (SyntaxNode)method.ExpressionBody);
            }

            public LineCounts Visit(SyntaxToken identifier, SyntaxNode body)
            {
                int start = identifier.GetLocation().SourceSpan.Start;
                int end = body.GetLocation().SourceSpan.End - 1;

                var textSpan = new Microsoft.CodeAnalysis.Text.TextSpan(start, end - start);

                string text = body.SyntaxTree.GetText().GetSubText(textSpan) + "\r\n";
                return Semmle.Util.LineCounter.ComputeLineCounts(text);
            }

            public override LineCounts VisitConstructorDeclaration(ConstructorDeclarationSyntax method)
            {
                return Visit(method.Identifier, (SyntaxNode)method.Body ?? method.ExpressionBody);
            }

            public override LineCounts VisitDestructorDeclaration(DestructorDeclarationSyntax method)
            {
                return Visit(method.Identifier, (SyntaxNode)method.Body ?? method.ExpressionBody);
            }

            public override LineCounts VisitOperatorDeclaration(OperatorDeclarationSyntax node)
            {
                return Visit(node.OperatorToken, node.Body ?? (SyntaxNode)node.ExpressionBody);
            }
        }

        public static void NumberOfLines(TextWriter trapFile, ISymbol symbol, IEntity callable)
        {
            foreach (var decl in symbol.DeclaringSyntaxReferences)
            {
                NumberOfLines(trapFile, (CSharpSyntaxNode)decl.GetSyntax(), callable);
            }
        }

        private static void NumberOfLines(TextWriter trapFile, CSharpSyntaxNode node, IEntity callable)
        {
            var lineCounts = node.Accept(new AstLineCounter());
            trapFile.numlines(callable, lineCounts);
        }
    }
}
