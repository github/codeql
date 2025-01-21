using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// State that needs to be available throughout the extraction process.
    /// There is one Context object per trap output file.
    /// </summary>
    public class Context
    {
        /// <summary>
        /// Access various extraction functions, e.g. logger, trap writer.
        /// </summary>
        public ExtractionContext ExtractionContext { get; }

        /// <summary>
        /// Access to the trap file.
        /// </summary>
        public TrapWriter TrapWriter { get; }

        /// <summary>
        /// Holds if assembly information should be prefixed to TRAP labels.
        /// </summary>
        public bool ShouldAddAssemblyTrapPrefix { get; }

        public IList<object> TrapStackSuffix { get; } = new List<object>();

        private int GetNewId() => TrapWriter.IdCounter++;

        // A recursion guard against writing to the trap file whilst writing an id to the trap file.
        private bool writingLabel = false;

        private readonly Queue<IEntity> labelQueue = [];

        protected void DefineLabel(IEntity entity)
        {
            if (writingLabel)
            {
                // Don't define a label whilst writing a label.
                labelQueue.Enqueue(entity);
            }
            else
            {
                try
                {
                    writingLabel = true;
                    entity.DefineLabel(TrapWriter.Writer);
                }
                finally
                {
                    writingLabel = false;
                    if (labelQueue.Any())
                    {
                        DefineLabel(labelQueue.Dequeue());
                    }
                }
            }
        }

#if DEBUG_LABELS
        private void CheckEntityHasUniqueLabel(string id, CachedEntity entity)
        {
            if (idLabelCache.ContainsKey(id))
            {
                this.Extractor.Message(new Message("Label collision for " + id, entity.Label.ToString(), CreateLocation(entity.ReportingLocation), "", Severity.Warning));
            }
            else
            {
                idLabelCache[id] = entity;
            }
        }
#endif

        protected Label GetNewLabel() => new Label(GetNewId());

        internal TEntity CreateEntity<TInit, TEntity>(CachedEntityFactory<TInit, TEntity> factory, object cacheKey, TInit init)
            where TEntity : Entities.CachedEntity =>
                cacheKey is ISymbol s ? CreateEntity(factory, s, init, symbolEntityCache) : CreateEntity(factory, cacheKey, init, objectEntityCache);

        internal TEntity CreateEntityFromSymbol<TSymbol, TEntity>(CachedEntityFactory<TSymbol, TEntity> factory, TSymbol init)
            where TSymbol : ISymbol
            where TEntity : Entities.CachedEntity => CreateEntity(factory, init, init, symbolEntityCache);


        /// <summary>
        /// Creates and populates a new entity, or returns the existing one from the cache.
        /// </summary>
        /// <param name="factory">The entity factory.</param>
        /// <param name="cacheKey">The key used for caching.</param>
        /// <param name="init">The initializer for the entity.</param>
        /// <param name="dictionary">The dictionary to use for caching.</param>
        /// <returns>The new/existing entity.</returns>
        private TEntity CreateEntity<TInit, TCacheKey, TEntity>(CachedEntityFactory<TInit, TEntity> factory, TCacheKey cacheKey, TInit init, IDictionary<TCacheKey, Entities.CachedEntity> dictionary)
            where TCacheKey : notnull
            where TEntity : Entities.CachedEntity
        {
            if (dictionary.TryGetValue(cacheKey, out var cached))
                return (TEntity)cached;

            using (StackGuard)
            {
                var label = GetNewLabel();
                var entity = factory.Create(this, init);
                entity.Label = label;

                dictionary[cacheKey] = entity;

                DefineLabel(entity);
                if (entity.NeedsPopulation)
                    Populate(init as ISymbol, entity);

#if DEBUG_LABELS
                using var id = new EscapingTextWriter();
                entity.WriteQuotedId(id);
                CheckEntityHasUniqueLabel(id.ToString(), entity);
#endif

                return entity;
            }
        }

        /// <summary>
        /// Creates a fresh label with ID "*", and set it on the
        /// supplied <paramref name="entity"/> object.
        /// </summary>
        internal void AddFreshLabel(Entity entity)
        {
            entity.Label = GetNewLabel();
            entity.DefineFreshLabel(TrapWriter.Writer);
        }

#if DEBUG_LABELS
        private readonly Dictionary<string, CachedEntity> idLabelCache = new Dictionary<string, CachedEntity>();
#endif

        private readonly IDictionary<object, Entities.CachedEntity> objectEntityCache = new Dictionary<object, Entities.CachedEntity>();
        private readonly IDictionary<ISymbol, Entities.CachedEntity> symbolEntityCache = new Dictionary<ISymbol, Entities.CachedEntity>(10000, SymbolEqualityComparer.Default);

        /// <summary>
        /// Queue of items to populate later.
        /// The only reason for this is so that the call stack does not
        /// grow indefinitely, causing a potential stack overflow.
        /// </summary>
        private readonly Queue<Action> populateQueue = new Queue<Action>();

        /// <summary>
        /// Enqueue the given action to be performed later.
        /// </summary>
        /// <param name="a">The action to run.</param>
        public void PopulateLater(Action a, bool preserveDuplicationKey = true)
        {
            var key = preserveDuplicationKey ? GetCurrentTagStackKey() : null;
            if (key is not null)
            {
                // If we are currently executing with a duplication guard, then the same
                // guard must be used for the deferred action
                populateQueue.Enqueue(() => WithDuplicationGuard(key, a));
            }
            else
            {
                populateQueue.Enqueue(a);
            }
        }

        /// <summary>
        /// Runs the main populate loop until there's nothing left to populate.
        /// </summary>
        public void PopulateAll()
        {
            while (populateQueue.Any())
            {
                try
                {
                    populateQueue.Dequeue()();
                }
                catch (InternalError ex)
                {
                    ExtractionError(new Message(ex.Text, ex.EntityText, CreateLocation(ex.Location), ex.StackTrace));
                }
                catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
                {
                    ExtractionError($"Uncaught exception. {ex.Message}", null, CreateLocation(), ex.StackTrace);
                }
            }
        }

        private int currentRecursiveDepth = 0;
        private const int maxRecursiveDepth = 150;

        private void EnterScope()
        {
            if (currentRecursiveDepth >= maxRecursiveDepth)
                throw new StackOverflowException($"Maximum nesting depth of {maxRecursiveDepth} exceeded");
            ++currentRecursiveDepth;
        }

        private void ExitScope()
        {
            --currentRecursiveDepth;
        }

        public IDisposable StackGuard => new ScopeGuard(this);

        private sealed class ScopeGuard : IDisposable
        {
            private readonly Context cx;

            public ScopeGuard(Context c)
            {
                cx = c;
                cx.EnterScope();
            }

            public void Dispose()
            {
                cx.ExitScope();
            }
        }

        private class PushEmitter : ITrapEmitter
        {
            private readonly Key key;

            public PushEmitter(Key key)
            {
                this.key = key;
            }

            public void EmitTrap(TextWriter trapFile)
            {
                trapFile.Write(".push ");
                key.AppendTo(trapFile);
                trapFile.WriteLine();
            }
        }

        private class PopEmitter : ITrapEmitter
        {
            public void EmitTrap(TextWriter trapFile)
            {
                trapFile.WriteLine(".pop");
            }
        }

        private readonly Stack<Key> tagStack = new Stack<Key>();

        /// <summary>
        /// Populates an entity, handling the tag stack appropriately
        /// </summary>
        /// <param name="optionalSymbol">Symbol for reporting errors.</param>
        /// <param name="entity">The entity to populate.</param>
        /// <exception cref="InternalError">Thrown on invalid trap stack behaviour.</exception>
        private void Populate(ISymbol? optionalSymbol, Entities.CachedEntity entity)
        {
            if (writingLabel)
            {
                // Don't write tuples etc if we're currently defining a label
                PopulateLater(() => Populate(optionalSymbol, entity));
                return;
            }

            bool duplicationGuard, deferred;

            if (ExtractionContext.Mode is ExtractorMode.Standalone)
            {
                duplicationGuard = false;
                deferred = false;
            }
            else
            {
                switch (entity.TrapStackBehaviour)
                {
                    case TrapStackBehaviour.NeedsLabel:
                        if (!tagStack.Any())
                            ExtractionError("TagStack unexpectedly empty", optionalSymbol, entity);
                        duplicationGuard = false;
                        deferred = false;
                        break;
                    case TrapStackBehaviour.NoLabel:
                        duplicationGuard = false;
                        deferred = tagStack.Any();
                        break;
                    case TrapStackBehaviour.OptionalLabel:
                        duplicationGuard = false;
                        deferred = false;
                        break;
                    case TrapStackBehaviour.PushesLabel:
                        duplicationGuard = true;
                        deferred = tagStack.Any();
                        break;
                    default:
                        throw new InternalError("Unexpected TrapStackBehaviour");
                }
            }

            var a = duplicationGuard && IsEntityDuplicationGuarded(entity, out var loc)
                ? (() =>
                {
                    var args = new object[TrapStackSuffix.Count + 2];
                    args[0] = entity;
                    args[1] = loc;
                    for (var i = 0; i < TrapStackSuffix.Count; i++)
                    {
                        args[i + 2] = TrapStackSuffix[i];
                    }
                    WithDuplicationGuard(new Key(args), () => entity.Populate(TrapWriter.Writer));
                })
                : (Action)(() => this.Try(null, optionalSymbol, () => entity.Populate(TrapWriter.Writer)));

            if (deferred)
                populateQueue.Enqueue(a);
            else
                a();
        }

        protected Key? GetCurrentTagStackKey() => tagStack.Count > 0
            ? tagStack.Peek()
            : null;

        /// <summary>
        /// Log an extraction error.
        /// </summary>
        /// <param name="message">The error message.</param>
        /// <param name="entityText">A textual representation of the failed entity.</param>
        /// <param name="location">The location of the error.</param>
        /// <param name="stackTrace">An optional stack trace of the error, or null.</param>
        /// <param name="severity">The severity of the error.</param>
        public void ExtractionError(string message, string? entityText, Entities.Location? location, string? stackTrace = null, Severity severity = Severity.Error)
        {
            var msg = new Message(message, entityText, location, stackTrace, severity);
            ExtractionError(msg);
        }

        /// <summary>
        /// Log an extraction error.
        /// </summary>
        /// <param name="message">The text of the message.</param>
        /// <param name="optionalSymbol">The symbol of the error, or null.</param>
        /// <param name="optionalEntity">The entity of the error, or null.</param>
        private void ExtractionError(string message, ISymbol? optionalSymbol, Entity optionalEntity)
        {
            if (!(optionalSymbol is null))
            {
                ExtractionError(message, optionalSymbol.ToDisplayString(), CreateLocation(optionalSymbol.Locations.BestOrDefault()));
            }
            else if (!(optionalEntity is null))
            {
                ExtractionError(message, optionalEntity.Label.ToString(), CreateLocation(optionalEntity.ReportingLocation));
            }
            else
            {
                ExtractionError(message, null, CreateLocation());
            }
        }

        /// <summary>
        /// Log an extraction message.
        /// </summary>
        /// <param name="msg">The message to log.</param>
        private void ExtractionError(Message msg)
        {
            _ = new Entities.ExtractionMessage(this, msg);
            ExtractionContext.Message(msg);
        }

        private void ExtractionError(InternalError error)
        {
            ExtractionError(new Message(error.Message, error.EntityText, CreateLocation(error.Location), error.StackTrace, Severity.Error));
        }

        private void ReportError(InternalError error)
        {
            if (!ExtractionContext.Mode.HasFlag(ExtractorMode.Standalone))
                throw error;

            ExtractionError(error);
        }

        /// <summary>
        /// Signal an error in the program model.
        /// </summary>
        /// <param name="node">The syntax node causing the failure.</param>
        /// <param name="msg">The error message.</param>
        public void ModelError(SyntaxNode node, string msg)
        {
            ReportError(new InternalError(node, msg));
        }

        /// <summary>
        /// Signal an error in the program model.
        /// </summary>
        /// <param name="symbol">Symbol causing the error.</param>
        /// <param name="msg">The error message.</param>
        public void ModelError(ISymbol symbol, string msg)
        {
            ReportError(new InternalError(symbol, msg));
        }

        /// <summary>
        /// Signal an error in the program model.
        /// </summary>
        /// <param name="loc">The location of the error.</param>
        /// <param name="msg">The error message.</param>
        public void ModelError(CSharp.Entities.Location loc, string msg)
        {
            ReportError(new InternalError(loc.ReportingLocation, msg));
        }

        /// <summary>
        /// Signal an error in the program model.
        /// </summary>
        /// <param name="msg">The error message.</param>
        public void ModelError(string msg)
        {
            ReportError(new InternalError(msg));
        }

        /// <summary>
        /// Tries the supplied action <paramref name="a"/>, and logs an uncaught
        /// exception error if the action fails.
        /// </summary>
        /// <param name="node">Optional syntax node for error reporting.</param>
        /// <param name="symbol">Optional symbol for error reporting.</param>
        /// <param name="a">The action to perform.</param>
        public void Try(SyntaxNode? node, ISymbol? symbol, Action a)
        {
            try
            {
                a();
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                Message message;

                if (node is not null)
                {
                    message = Message.Create(this, ex.Message, node, ex.StackTrace);
                }
                else if (symbol is not null)
                {
                    message = Message.Create(this, ex.Message, symbol, ex.StackTrace);
                }
                else if (ex is InternalError ie)
                {
                    message = new Message(ie.Text, ie.EntityText, CreateLocation(ie.Location), ex.StackTrace);
                }
                else
                {
                    message = new Message($"Uncaught exception. {ex.Message}", null, CreateLocation(), ex.StackTrace);
                }

                ExtractionError(message);
            }
        }

        /// <summary>
        /// The program database provided by Roslyn.
        /// There's one per syntax tree, which makes things awkward.
        /// </summary>
        public SemanticModel GetModel(SyntaxNode node)
        {
            if (node.SyntaxTree == SourceTree)
            {
                if (cachedModelForTree is null)
                {
                    cachedModelForTree = Compilation.GetSemanticModel(node.SyntaxTree);
                }

                return cachedModelForTree;
            }

            if (cachedModelForOtherTrees is null || node.SyntaxTree != cachedModelForOtherTrees.SyntaxTree)
            {
                cachedModelForOtherTrees = Compilation.GetSemanticModel(node.SyntaxTree);
            }

            return cachedModelForOtherTrees;
        }

        private SemanticModel? cachedModelForTree;
        private SemanticModel? cachedModelForOtherTrees;

        // The below is a workaround to the bug reported in https://github.com/dotnet/roslyn/issues/58226
        // Lambda parameters that are equal according to `SymbolEqualityComparer.Default`, might have different
        // hash-codes, and as a result might not be found in `symbolEntityCache` by hash-code lookup.
        internal IParameterSymbol GetPossiblyCachedParameterSymbol(IParameterSymbol param)
        {
            if ((param.ContainingSymbol as IMethodSymbol)?.MethodKind != MethodKind.AnonymousFunction)
            {
                return param;
            }

            foreach (var sr in param.DeclaringSyntaxReferences)
            {
                var syntax = sr.GetSyntax();
                if (lambdaParameterCache.TryGetValue(syntax, out var cached) &&
                    SymbolEqualityComparer.Default.Equals(param, cached))
                {
                    return cached;
                }
            }

            return param;
        }

        internal void CacheLambdaParameterSymbol(IParameterSymbol param, SyntaxNode syntax)
        {
            lambdaParameterCache[syntax] = param;
        }

        private readonly Dictionary<SyntaxNode, IParameterSymbol> lambdaParameterCache = [];

        /// <summary>
        /// The current compilation unit.
        /// </summary>
        public Compilation Compilation { get; }

        internal CommentProcessor CommentGenerator { get; } = new CommentProcessor();

        public Context(ExtractionContext extractionContext, Compilation c, TrapWriter trapWriter, IExtractionScope scope, bool shouldAddAssemblyTrapPrefix = false)
        {
            ExtractionContext = extractionContext;
            TrapWriter = trapWriter;
            ShouldAddAssemblyTrapPrefix = shouldAddAssemblyTrapPrefix;
            Compilation = c;
            this.scope = scope;
        }

        public bool FromSource => scope is SourceScope;

        private readonly IExtractionScope scope;

        public bool IsAssemblyScope => scope is AssemblyScope;

        private SyntaxTree? SourceTree => scope is SourceScope sc ? sc.SourceTree : null;

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
        public void WithDuplicationGuard(Key key, Action a)
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
                tagStack.Push(key);
                TrapWriter.Emit(new PushEmitter(key));
                try
                {
                    a();
                }
                finally
                {
                    TrapWriter.Emit(new PopEmitter());
                    tagStack.Pop();
                }
            }
        }

        public Entities.Location CreateLocation()
        {
            return SourceTree is null
                ? Entities.GeneratedLocation.Create(this)
                : CreateLocation(Microsoft.CodeAnalysis.Location.Create(SourceTree, Microsoft.CodeAnalysis.Text.TextSpan.FromBounds(0, 0)));
        }

        public Entities.Location CreateLocation(Microsoft.CodeAnalysis.Location? location)
        {
            return (location is null || location.Kind == LocationKind.None)
                ? Entities.GeneratedLocation.Create(this)
                : location.IsInSource
                    ? Entities.NonGeneratedSourceLocation.Create(this, location)
                    : Entities.Assembly.Create(this, location);
        }

        /// <summary>
        /// Register a program entity which can be bound to comments.
        /// </summary>
        /// <param name="entity">Program entity.</param>
        /// <param name="l">Location of the entity.</param>
        public void BindComments(Entity entity, Microsoft.CodeAnalysis.Location? l)
        {
            var duplicationGuardKey = GetCurrentTagStackKey();
            CommentGenerator.AddElement(entity.Label, duplicationGuardKey, l);
        }

        private bool IsEntityDuplicationGuarded(IEntity entity, [NotNullWhen(true)] out Entities.Location? loc)
        {
            if (CreateLocation(entity.ReportingLocation) is Entities.NonGeneratedSourceLocation l)
            {
                loc = l;
                return true;
            }

            loc = null;
            return false;
        }

        private readonly HashSet<Label> extractedGenerics = new HashSet<Label>();

        /// <summary>
        /// Should the given entity be extracted?
        /// A second call to this method will always return false,
        /// on the assumption that it would have been extracted on the first call.
        ///
        /// This is used to track the extraction of generics, which cannot be extracted
        /// in a top-down manner.
        /// </summary>
        /// <param name="entity">The entity to extract.</param>
        /// <returns>True only on the first call for a particular entity.</returns>
        internal bool ExtractGenerics(CSharp.Entities.CachedEntity entity)
        {
            if (extractedGenerics.Contains(entity.Label))
            {
                return false;
            }

            extractedGenerics.Add(entity.Label);
            return true;
        }

        public string TryAdjustRelativeMappedFilePath(string mappedToPath, string mappedFromPath)
        {
            if (!Path.IsPathRooted(mappedToPath))
            {
                try
                {
                    var fullPath = Path.GetFullPath(Path.Combine(Path.GetDirectoryName(mappedFromPath)!, mappedToPath));
                    ExtractionContext.Logger.LogDebug($"Found relative path in line mapping: '{mappedToPath}', interpreting it as '{fullPath}'");

                    mappedToPath = fullPath;
                }
                catch (Exception e)
                {
                    ExtractionContext.Logger.LogDebug($"Failed to compute absolute path for relative path in line mapping: '{mappedToPath}': {e}");
                }
            }

            return mappedToPath;
        }
    }
}
