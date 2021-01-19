using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.Populators
{
    internal class CompilationUnitVisitor : TypeOrNamespaceVisitor
    {
        private CompilationUnitVisitor(Context cx)
            : base(cx, cx.TrapWriter.Writer, null) { }

        public override void VisitExternAliasDirective(ExternAliasDirectiveSyntax node)
        {
            // This information is not yet extracted.
            cx.ExtractionError("Not implemented extern alias directive", node.ToFullString(), Extraction.Entities.Location.Create(cx, node.GetLocation()), "", Severity.Info);
        }

        public override void VisitCompilationUnit(CompilationUnitSyntax compilationUnit)
        {
            foreach (var m in compilationUnit.ChildNodes())
            {
                cx.Try(m, null, () => ((CSharpSyntaxNode)m).Accept(this));
            }

            // Gather comments:
            foreach (var trivia in compilationUnit.DescendantTrivia(compilationUnit.Span))
            {
                TriviaPopulator.ExtractTrivia(cx, trivia);
            }

            foreach (var trivia in compilationUnit.GetLeadingTrivia())
            {
                TriviaPopulator.ExtractTrivia(cx, trivia);
            }

            foreach (var trivia in compilationUnit.GetTrailingTrivia())
            {
                TriviaPopulator.ExtractTrivia(cx, trivia);
            }
        }

        public static void Extract(Context cx, SyntaxNode unit)
        {
            // Ensure that the file itself is populated in case the source file is totally empty
            Extraction.Entities.File.Create(cx, unit.SyntaxTree.FilePath);

            ((CSharpSyntaxNode)unit).Accept(new CompilationUnitVisitor(cx));
        }
    }
}
