using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal abstract class PreprocessorDirective<TDirective> : CachedEntity<TDirective> where TDirective : DirectiveTriviaSyntax
    {
        protected PreprocessorDirective(Context cx, TDirective trivia)
            : base(cx, trivia) { }

        public sealed override void Populate(TextWriter trapFile)
        {
            PopulatePreprocessor(trapFile);

            trapFile.preprocessor_directive_active(this, Symbol.IsActive);
            trapFile.preprocessor_directive_location(this, Context.CreateLocation(ReportingLocation));

            if (!Context.Extractor.Standalone)
            {
                var compilation = Compilation.Create(Context);
                trapFile.preprocessor_directive_compilation(this, compilation);
            }
        }

        protected abstract void PopulatePreprocessor(TextWriter trapFile);

        public sealed override Microsoft.CodeAnalysis.Location ReportingLocation => Symbol.GetLocation();

        public override bool NeedsPopulation => true;

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(Context.CreateLocation(ReportingLocation));
            trapFile.Write(Symbol.IsActive);
            trapFile.Write(";trivia");
        }
    }
}
