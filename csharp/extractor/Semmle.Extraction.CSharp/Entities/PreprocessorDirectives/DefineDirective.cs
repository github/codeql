using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class DefineDirective : PreprocessorDirective<DefineDirectiveTriviaSyntax>
    {
        private DefineDirective(Context cx, DefineDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_defines(this, Symbol.Name.ToString());
        }

        public static DefineDirective Create(Context cx, DefineDirectiveTriviaSyntax def) =>
            DefineDirectiveFactory.Instance.CreateEntity(cx, def, def);

        private class DefineDirectiveFactory : CachedEntityFactory<DefineDirectiveTriviaSyntax, DefineDirective>
        {
            public static DefineDirectiveFactory Instance { get; } = new DefineDirectiveFactory();

            public override DefineDirective Create(Context cx, DefineDirectiveTriviaSyntax init) => new(cx, init);
        }
    }
}
