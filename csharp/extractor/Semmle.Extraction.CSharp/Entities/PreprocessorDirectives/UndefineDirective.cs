using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class UndefineDirective : PreprocessorDirective<UndefDirectiveTriviaSyntax>
    {
        private UndefineDirective(Context cx, UndefDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_undefines(this, Symbol.Name.ToString());
        }

        public static UndefineDirective Create(Context cx, UndefDirectiveTriviaSyntax undef) =>
            UndefineDirectiveFactory.Instance.CreateEntity(cx, undef, undef);

        private class UndefineDirectiveFactory : CachedEntityFactory<UndefDirectiveTriviaSyntax, UndefineDirective>
        {
            public static UndefineDirectiveFactory Instance { get; } = new UndefineDirectiveFactory();

            public override UndefineDirective Create(Context cx, UndefDirectiveTriviaSyntax init) => new(cx, init);
        }
    }
}
