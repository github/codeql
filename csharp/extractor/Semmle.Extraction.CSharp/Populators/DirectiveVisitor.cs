using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Populators
{
    internal class DirectiveVisitor : CSharpSyntaxWalker
    {
        private readonly Context cx;

        public DirectiveVisitor(Context cx) : base(SyntaxWalkerDepth.StructuredTrivia)
        {
            this.cx = cx;
        }

        public override void VisitPragmaWarningDirectiveTrivia(PragmaWarningDirectiveTriviaSyntax node)
        {
            new Entities.PragmaWarningDirective(cx, node);
        }

        public override void VisitPragmaChecksumDirectiveTrivia(PragmaChecksumDirectiveTriviaSyntax node)
        {
            new Entities.PragmaChecksumDirective(cx, node);
        }

        public override void VisitDefineDirectiveTrivia(DefineDirectiveTriviaSyntax node)
        {
            new Entities.DefineDirective(cx, node);
        }

        public override void VisitUndefDirectiveTrivia(UndefDirectiveTriviaSyntax node)
        {
            new Entities.UndefineDirective(cx, node);
        }

        public override void VisitWarningDirectiveTrivia(WarningDirectiveTriviaSyntax node)
        {
            new Entities.WarningDirective(cx, node);
        }

        public override void VisitErrorDirectiveTrivia(ErrorDirectiveTriviaSyntax node)
        {
            new Entities.ErrorDirective(cx, node);
        }
    }
}
