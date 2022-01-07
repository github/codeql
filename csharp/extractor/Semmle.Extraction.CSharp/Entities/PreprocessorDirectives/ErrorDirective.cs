using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class ErrorDirective : PreprocessorDirective<ErrorDirectiveTriviaSyntax>
    {
        private ErrorDirective(Context cx, ErrorDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_errors(this, Symbol.EndOfDirectiveToken.LeadingTrivia.ToString());
        }

        public static ErrorDirective Create(Context cx, ErrorDirectiveTriviaSyntax error) =>
            ErrorDirectiveFactory.Instance.CreateEntity(cx, error, error);

        private class ErrorDirectiveFactory : CachedEntityFactory<ErrorDirectiveTriviaSyntax, ErrorDirective>
        {
            public static ErrorDirectiveFactory Instance { get; } = new ErrorDirectiveFactory();

            public override ErrorDirective Create(Context cx, ErrorDirectiveTriviaSyntax init) => new(cx, init);
        }
    }
}
