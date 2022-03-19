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
        private readonly List<IEntity> branchesTaken = new();

        /// <summary>
        /// Gets a list of `#if`, `#elif`, and `#else` entities where the branch
        /// is taken.
        /// </summary>
        public IEnumerable<IEntity> BranchesTaken => branchesTaken;

        public DirectiveVisitor(Context cx) : base(SyntaxWalkerDepth.StructuredTrivia) =>
            this.cx = cx;

        public override void VisitPragmaWarningDirectiveTrivia(PragmaWarningDirectiveTriviaSyntax node) =>
            Entities.PragmaWarningDirective.Create(cx, node);

        public override void VisitPragmaChecksumDirectiveTrivia(PragmaChecksumDirectiveTriviaSyntax node) =>
            Entities.PragmaChecksumDirective.Create(cx, node);

        public override void VisitDefineDirectiveTrivia(DefineDirectiveTriviaSyntax node) =>
            Entities.DefineDirective.Create(cx, node);

        public override void VisitUndefDirectiveTrivia(UndefDirectiveTriviaSyntax node) =>
            Entities.UndefineDirective.Create(cx, node);

        public override void VisitWarningDirectiveTrivia(WarningDirectiveTriviaSyntax node) =>
            Entities.WarningDirective.Create(cx, node);

        public override void VisitErrorDirectiveTrivia(ErrorDirectiveTriviaSyntax node) =>
            Entities.ErrorDirective.Create(cx, node);

        public override void VisitNullableDirectiveTrivia(NullableDirectiveTriviaSyntax node) =>
            Entities.NullableDirective.Create(cx, node);

        public override void VisitLineDirectiveTrivia(LineDirectiveTriviaSyntax node) =>
            Entities.LineDirective.Create(cx, node);

        public override void VisitLineSpanDirectiveTrivia(LineSpanDirectiveTriviaSyntax node) =>
            Entities.LineSpanDirective.Create(cx, node);

        private readonly Stack<Entities.RegionDirective> regionStarts = new Stack<Entities.RegionDirective>();

        public override void VisitRegionDirectiveTrivia(RegionDirectiveTriviaSyntax node)
        {
            var region = Entities.RegionDirective.Create(cx, node);
            regionStarts.Push(region);
        }

        public override void VisitEndRegionDirectiveTrivia(EndRegionDirectiveTriviaSyntax node)
        {
            if (regionStarts.Count == 0)
            {
                cx.ExtractionError("Couldn't find start region", null,
                    cx.CreateLocation(node.GetLocation()), null, Util.Logging.Severity.Warning);
                return;
            }

            var start = regionStarts.Pop();
            Entities.EndRegionDirective.Create(cx, node, start);
        }

        private class IfDirectiveStackElement
        {
            public Entities.IfDirective Entity { get; }
            public int SiblingCount { get; set; }


            public IfDirectiveStackElement(Entities.IfDirective entity)
            {
                Entity = entity;
            }
        }

        private readonly Stack<IfDirectiveStackElement> ifStarts = new Stack<IfDirectiveStackElement>();

        public override void VisitIfDirectiveTrivia(IfDirectiveTriviaSyntax node)
        {
            var ifStart = Entities.IfDirective.Create(cx, node);
            ifStarts.Push(new IfDirectiveStackElement(ifStart));
            if (node.BranchTaken)
                branchesTaken.Add(ifStart);
        }

        public override void VisitEndIfDirectiveTrivia(EndIfDirectiveTriviaSyntax node)
        {
            if (ifStarts.Count == 0)
            {
                cx.ExtractionError("Couldn't find start if", null,
                    cx.CreateLocation(node.GetLocation()), null, Util.Logging.Severity.Warning);
                return;
            }

            var start = ifStarts.Pop();
            Entities.EndIfDirective.Create(cx, node, start.Entity);
        }

        public override void VisitElifDirectiveTrivia(ElifDirectiveTriviaSyntax node)
        {
            if (ifStarts.Count == 0)
            {
                cx.ExtractionError("Couldn't find start if", null,
                    cx.CreateLocation(node.GetLocation()), null, Util.Logging.Severity.Warning);
                return;
            }

            var start = ifStarts.Peek();
            var elIf = Entities.ElifDirective.Create(cx, node, start.Entity, start.SiblingCount++);
            if (node.BranchTaken)
                branchesTaken.Add(elIf);
        }

        public override void VisitElseDirectiveTrivia(ElseDirectiveTriviaSyntax node)
        {
            if (ifStarts.Count == 0)
            {
                cx.ExtractionError("Couldn't find start if", null,
                    cx.CreateLocation(node.GetLocation()), null, Util.Logging.Severity.Warning);
                return;
            }

            var start = ifStarts.Peek();
            var @else = Entities.ElseDirective.Create(cx, node, start.Entity, start.SiblingCount++);
            if (node.BranchTaken)
                branchesTaken.Add(@else);
        }
    }
}
