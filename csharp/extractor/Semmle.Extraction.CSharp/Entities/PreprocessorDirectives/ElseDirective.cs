using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class ElseDirective : PreprocessorDirective<ElseDirectiveTriviaSyntax>, IIfSiblingDirective
    {
        private readonly IfDirective start;
        private readonly int index;

        private ElseDirective(Context cx, ElseDirectiveTriviaSyntax trivia, IfDirective start, int index)
            : base(cx, trivia)
        {
            this.start = start;
            this.index = index;
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(Context.CreateLocation(ReportingLocation));
            trapFile.WriteSubId(start);
            trapFile.Write(Symbol.IsActive);
            trapFile.Write(',');
            trapFile.Write(Symbol.BranchTaken);
            trapFile.Write(";trivia");
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_elses(this, Symbol.BranchTaken, start, index);
        }

        public static ElseDirective Create(Context cx, ElseDirectiveTriviaSyntax @else, IfDirective start, int index) =>
            ElseDirectiveFactory.Instance.CreateEntity(cx, @else, (@else, start, index));

        private class ElseDirectiveFactory : CachedEntityFactory<(ElseDirectiveTriviaSyntax @else, IfDirective start, int index), ElseDirective>
        {
            public static ElseDirectiveFactory Instance { get; } = new ElseDirectiveFactory();

            public override ElseDirective Create(Context cx, (ElseDirectiveTriviaSyntax @else, IfDirective start, int index) init) => new(cx, init.@else, init.start, init.index);
        }
    }
}
