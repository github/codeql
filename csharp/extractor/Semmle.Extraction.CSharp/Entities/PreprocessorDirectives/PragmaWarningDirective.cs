using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class PragmaWarningDirective : FreshEntity, IPreprocessorDirective
    {
        private readonly PragmaWarningDirectiveTriviaSyntax trivia;

        public PragmaWarningDirective(Context cx, PragmaWarningDirectiveTriviaSyntax trivia)
            : base(cx)
        {
            this.trivia = trivia;
            TryPopulate();
        }

        protected override void Populate(TextWriter trapFile)
        {
            trapFile.pragma_warnings(this, trivia.DisableOrRestoreKeyword.IsKind(SyntaxKind.DisableKeyword) ? 0 : 1);

            var childIndex = 0;
            foreach (var code in trivia.ErrorCodes)
            {
                trapFile.pragma_warning_error_codes(this, code.ToString(), childIndex++);
            }

            trapFile.preprocessor_directive_location(this, cx.Create(ReportingLocation));

            if (!cx.Extractor.Standalone)
            {
                var assembly = Assembly.CreateOutputAssembly(cx);
                trapFile.preprocessor_directive_assembly(this, assembly);
            }
        }

        public sealed override Microsoft.CodeAnalysis.Location ReportingLocation => trivia.GetLocation();

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}
