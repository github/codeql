using Microsoft.CodeAnalysis;
using System;

namespace Semmle.Extraction.CSharp
{
    public class Context : Extraction.Context
    {
        /// <summary>
        /// The current compilation unit.
        /// </summary>
        public Compilation Compilation { get; }

        private readonly IExtractionScope scope;

        /// <summary>
        /// The program database provided by Roslyn.
        /// There's one per syntax tree, which makes things awkward.
        /// </summary>
        public SemanticModel GetModel(SyntaxNode node)
        {
            if (cachedModel == null || node.SyntaxTree != cachedModel.SyntaxTree)
            {
                cachedModel = Compilation.GetSemanticModel(node.SyntaxTree);
            }

            return cachedModel;
        }

        private SemanticModel cachedModel;

        public bool FromSource => !IsAssemblyScope;

        public bool IsAssemblyScope => scope is AssemblyScope;

        public SyntaxTree SourceTree => scope is SourceScope sc ? sc.SourceTree : null;

        /// <summary>
        /// Create a new context, one per source file/assembly.
        /// </summary>
        /// <param name="e">The extractor.</param>
        /// <param name="c">The Roslyn compilation.</param>
        /// <param name="extractedEntity">Name of the source/dll file.</param>
        /// <param name="scope">Defines which symbols are included in the trap file (e.g. AssemblyScope or SourceScope)</param>
        /// <param name="addAssemblyTrapPrefix">Whether to add assembly prefixes to TRAP labels.</param>
        public Context(Extraction.Extractor e, Compilation c, TrapWriter trapWriter, IExtractionScope scope, bool addAssemblyTrapPrefix)
            : base(e, trapWriter, addAssemblyTrapPrefix)
        {
            Compilation = c;
            this.scope = scope;
        }

        /// <summary>
        ///     Whether the given symbol needs to be defined in this context.
        ///     This is the case if the symbol is contained in the source/assembly, or
        ///     of the symbol is a constructed generic.
        /// </summary>
        /// <param name="symbol">The symbol to populate.</param>
        public bool Defines(ISymbol symbol) =>
            !SymbolEqualityComparer.Default.Equals(symbol, symbol.OriginalDefinition) ||
            scope.InScope(symbol);

        /// <summary>
        /// Runs the given action <paramref name="a"/>, guarding for trap duplication
        /// based on key <paramref name="key"/>.
        /// </summary>
        public override void WithDuplicationGuard(Key key, Action a)
        {
            if (IsAssemblyScope)
            {
                // No need for a duplication guard when extracting assemblies,
                // and the duplication guard could lead to method bodies being missed
                // depending on trap import order.
                a();
            }
            else
            {
                base.WithDuplicationGuard(key, a);
            }
        }

        public override Extraction.Entities.Location CreateLocation()
        {
            return SourceTree is null
                ? Extraction.Entities.GeneratedLocation.Create(this)
                : CreateLocation(Location.Create(SourceTree, Microsoft.CodeAnalysis.Text.TextSpan.FromBounds(0, 0)));
        }

        public override Extraction.Entities.Location CreateLocation(Location location)
        {
            return (location == null || location.Kind == LocationKind.None)
                ? Extraction.Entities.GeneratedLocation.Create(this)
                : location.IsInSource
                    ? Entities.NonGeneratedSourceLocation.Create(this, location)
                    : Entities.Assembly.Create(this, location);
        }

        protected override bool IsEntityDuplicationGuarded(ICachedEntity entity, out Extraction.Entities.Location loc)
        {
            if (CreateLocation(entity.ReportingLocation) is Entities.NonGeneratedSourceLocation l)
            {
                loc = l;
                return true;
            }

            loc = null;
            return false;
        }
    }
}
