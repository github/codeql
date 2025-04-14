using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class EndIfDirective : PreprocessorDirective<EndIfDirectiveTriviaSyntax>
    {
        private readonly IfDirective start;

        private EndIfDirective(Context cx, EndIfDirectiveTriviaSyntax trivia, IfDirective start)
            : base(cx, trivia)
        {
            this.start = start;
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(Context.CreateLocation(ReportingLocation));
            trapFile.WriteSubId(start);
            trapFile.Write(Symbol.IsActive);
            trapFile.Write(";trivia");
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_endifs(this, start);
        }

        public static EndIfDirective Create(Context cx, EndIfDirectiveTriviaSyntax endif, IfDirective start) =>
            EndIfDirectiveFactory.Instance.CreateEntity(cx, endif, (endif, start));

        private class EndIfDirectiveFactory : CachedEntityFactory<(EndIfDirectiveTriviaSyntax endif, IfDirective start), EndIfDirective>
        {
            public static EndIfDirectiveFactory Instance { get; } = new EndIfDirectiveFactory();

            public override EndIfDirective Create(Context cx, (EndIfDirectiveTriviaSyntax endif, IfDirective start) init) => new(cx, init.endif, init.start);
        }
    }
}
