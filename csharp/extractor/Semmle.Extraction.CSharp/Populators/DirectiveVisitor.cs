using System.Collections.Generic;
using System.Linq;
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

        public override void VisitNullableDirectiveTrivia(NullableDirectiveTriviaSyntax node)
        {
            new Entities.NullableDirective(cx, node);
        }

        public override void VisitLineDirectiveTrivia(LineDirectiveTriviaSyntax node)
        {
            new Entities.LineDirective(cx, node);
        }

        private readonly Stack<Entities.RegionDirective> regionStarts = new Stack<Entities.RegionDirective>();

        public override void VisitRegionDirectiveTrivia(RegionDirectiveTriviaSyntax node)
        {
            var region = new Entities.RegionDirective(cx, node);
            regionStarts.Push(region);
        }

        public override void VisitEndRegionDirectiveTrivia(EndRegionDirectiveTriviaSyntax node)
        {
            var endregion = new Entities.EndRegionDirective(cx, node);
            if (regionStarts.Count == 0)
            {
                cx.ExtractionError("Couldn't find start region", null,
                    Extraction.Entities.Location.Create(cx, node.GetLocation()), null, Util.Logging.Severity.Warning);
                return;
            }
            var start = regionStarts.Pop();
            Entities.EndRegionDirective.WriteRegionBlock(cx, start, endregion);
        }

        private readonly Stack<Entities.IfDirective> ifStarts = new Stack<Entities.IfDirective>();

        public override void VisitIfDirectiveTrivia(IfDirectiveTriviaSyntax node)
        {
            var ifStart = new Entities.IfDirective(cx, node);
            ifStarts.Push(ifStart);
        }

        public override void VisitEndIfDirectiveTrivia(EndIfDirectiveTriviaSyntax node)
        {
            var endif = new Entities.EndIfDirective(cx, node);
            if (ifStarts.Count == 0)
            {
                cx.ExtractionError("Couldn't find start if", null,
                    Extraction.Entities.Location.Create(cx, node.GetLocation()), null, Util.Logging.Severity.Warning);
                return;
            }
            var start = ifStarts.Pop();
            start.WriteBranches(endif);
        }

        public override void VisitElifDirectiveTrivia(ElifDirectiveTriviaSyntax node)
        {
            var elif = new Entities.ElifDirective(cx, node);
            if (ifStarts.Count == 0)
            {
                cx.ExtractionError("Couldn't find start if", null,
                    Extraction.Entities.Location.Create(cx, node.GetLocation()), null, Util.Logging.Severity.Warning);
                return;
            }
            var start = ifStarts.Peek();
            start.Add(elif);
        }

        public override void VisitElseDirectiveTrivia(ElseDirectiveTriviaSyntax node)
        {
            var elseDirective = new Entities.ElseDirective(cx, node);
            if (ifStarts.Count == 0)
            {
                cx.ExtractionError("Couldn't find start if", null,
                    Extraction.Entities.Location.Create(cx, node.GetLocation()), null, Util.Logging.Severity.Warning);
                return;
            }
            var start = ifStarts.Peek();
            start.Add(elseDirective);
        }
    }
}
