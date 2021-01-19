using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal abstract class PreprocessorDirective<TDirective> : FreshEntity where TDirective : DirectiveTriviaSyntax
    {
        protected readonly TDirective trivia;

        protected PreprocessorDirective(Context cx, TDirective trivia)
            : base(cx)
        {
            this.trivia = trivia;
            TryPopulate();
        }

        protected sealed override void Populate(TextWriter trapFile)
        {
            PopulatePreprocessor(trapFile);

            trapFile.preprocessor_directive_location(this, cx.Create(ReportingLocation));

            if (!cx.Extractor.Standalone)
            {
                var assembly = Assembly.CreateOutputAssembly(cx);
                trapFile.preprocessor_directive_assembly(this, assembly);
            }
        }

        protected abstract void PopulatePreprocessor(TextWriter trapFile);

        public sealed override Microsoft.CodeAnalysis.Location ReportingLocation => trivia.GetLocation();

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}
