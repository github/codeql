using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Util.Logging;
using Semmle.Extraction.CSharp.Entities;

namespace Semmle.Extraction.CSharp.Populators
{
    internal class CompilationUnitVisitor : TypeOrNamespaceVisitor
    {
#nullable disable warnings
        public CompilationUnitVisitor(Context cx)
            : base(cx, cx.TrapWriter.Writer, null) { }
#nullable restore warnings

        public override void VisitExternAliasDirective(ExternAliasDirectiveSyntax node)
        {
            // This information is not yet extracted.
            Cx.ExtractionError("Not implemented extern alias directive", node.ToFullString(), Cx.CreateLocation(node.GetLocation()), "", Severity.Info);
        }

        public override void VisitCompilationUnit(CompilationUnitSyntax compilationUnit)
        {
            foreach (var m in compilationUnit.ChildNodes())
            {
                Cx.Try(m, null, () => ((CSharpSyntaxNode)m).Accept(this));
            }

            ExtractGlobalStatements(compilationUnit);

            // Gather comments:
            foreach (var trivia in compilationUnit.DescendantTrivia(compilationUnit.Span, descendIntoTrivia: true))
            {
                CommentPopulator.ExtractComment(Cx, trivia);
            }

            foreach (var trivia in compilationUnit.GetLeadingTrivia())
            {
                CommentPopulator.ExtractComment(Cx, trivia);
            }

            foreach (var trivia in compilationUnit.GetTrailingTrivia())
            {
                CommentPopulator.ExtractComment(Cx, trivia);
            }
        }

        private void ExtractGlobalStatements(CompilationUnitSyntax compilationUnit)
        {
            var globalStatements = compilationUnit
                .ChildNodes()
                .OfType<GlobalStatementSyntax>()
                .ToList();

            if (!globalStatements.Any())
            {
                return;
            }

            var entryPoint = Cx.Compilation.GetEntryPoint(System.Threading.CancellationToken.None);
            if (entryPoint is null)
            {
                Cx.ExtractionError("No entry method found. Skipping the extraction of global statements.",
                    null, Cx.CreateLocation(globalStatements[0].GetLocation()), null, Severity.Info);
                return;
            }

            ImplicitMainMethod.Create(Cx, entryPoint, globalStatements);
        }
    }
}
