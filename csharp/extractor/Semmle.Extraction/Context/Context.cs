using Microsoft.CodeAnalysis;
using Semmle.Extraction.CommentProcessing;
using Semmle.Extraction.Entities;
using Semmle.Util.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using System.Linq;

namespace Semmle.Extraction
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
        public Extractor Extractor { get; }

        /// <summary>
        /// Access to the trap file.
        /// </summary>
        public TrapWriter TrapWriter { get; }

        /// <summary>
        /// Holds if assembly information should be prefixed to TRAP labels.
        /// </summary>
        public bool ShouldAddAssemblyTrapPrefix { get; }

        private int GetNewId() => TrapWriter.IdCounter++;

        // A recursion guard against writing to the trap file whilst writing an id to the trap file.
        private bool writingLabel = false;

        public void DefineLabel(IEntity entity, TextWriter trapFile, Extractor extractor)
        {
            if (writingLabel)
            {
                // Don't define a label whilst writing a label.
                PopulateLater(() => DefineLabel(entity, trapFile, extractor));
            }
            else
            {
                try
                {
                    writingLabel = true;
                    entity.DefineLabel(trapFile, extractor);
                }
                finally
                {
                    writingLabel = false;
                }
            }
        }

#if DEBUG_LABELS
        private void CheckEntityHasUniqueLabel(string id, ICachedEntity entity)
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

        public Label GetNewLabel() => new Label(GetNewId());

        public TEntity CreateEntity<TInit, TEntity>(ICachedEntityFactory<TInit, TEntity> factory, object cacheKey, TInit init)
            where TEntity : ICachedEntity =>
            cacheKey is ISymbol s ? CreateEntity(factory, s, init, symbolEntityCache) : CreateEntity(factory, cacheKey, init, objectEntityCache);

        public TEntity CreateEntityFromSymbol<TSymbol, TEntity>(ICachedEntityFactory<TSymbol, TEntity> factory, TSymbol init)
            where TSymbol : ISymbol
            where TEntity : ICachedEntity => CreateEntity(factory, init, init, symbolEntityCache);

        /// <summary>
        /// Creates and populates a new entity, or returns the existing one from the cache.
        /// </summary>
        /// <param name="factory">The entity factory.</param>
        /// <param name="cacheKey">The key used for caching.</param>
        /// <param name="init">The initializer for the entity.</param>
        /// <param name="dictionary">The dictionary to use for caching.</param>
        /// <returns>The new/existing entity.</returns>
        private TEntity CreateEntity<TInit, TCacheKey, TEntity>(ICachedEntityFactory<TInit, TEntity> factory, TCacheKey cacheKey, TInit init, IDictionary<TCacheKey, ICachedEntity> dictionary)
            where TCacheKey : notnull
            where TEntity : ICachedEntity
        {
            if (dictionary.TryGetValue(cacheKey, out var cached))
                return (TEntity)cached;

            using (StackGuard)
            {
                var label = GetNewLabel();
                var entity = factory.Create(this, init);
                entity.Label = label;

                dictionary[cacheKey] = entity;

                DefineLabel(entity, TrapWriter.Writer, Extractor);
                if (entity.NeedsPopulation)
                    Populate(init as ISymbol, entity);

#if DEBUG_LABELS
                using var id = new StringWriter();
                entity.WriteQuotedId(id);
                CheckEntityHasUniqueLabel(id.ToString(), entity);
#endif

                return entity;
            }
        }

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
        public bool ExtractGenerics(ICachedEntity entity)
        {
            if (extractedGenerics.Contains(entity.Label))
            {
                return false;
            }

            extractedGenerics.Add(entity.Label);
            return true;
        }

        /// <summary>
        /// Creates a fresh label with ID "*", and set it on the
        /// supplied <paramref name="entity"/> object.
        /// </summary>
        public void AddFreshLabel(IEntity entity)
        {
            entity.Label = GetNewLabel();
            entity.DefineFreshLabel(TrapWriter.Writer);
        }

#if DEBUG_LABELS
        private readonly Dictionary<string, ICachedEntity> idLabelCache = new Dictionary<string, ICachedEntity>();
#endif

        private readonly IDictionary<object, ICachedEntity> objectEntityCache = new Dictionary<object, ICachedEntity>();
        private readonly IDictionary<ISymbol, ICachedEntity> symbolEntityCache = new Dictionary<ISymbol, ICachedEntity>(10000, SymbolEqualityComparer.Default);
        private readonly HashSet<Label> extractedGenerics = new HashSet<Label>();

        /// <summary>
        /// Queue of items to populate later.
        /// The only reason for this is so that the call stack does not
        /// grow indefinitely, causing a potential stack overflow.
        /// </summary>
        private readonly Queue<Action> populateQueue = new Queue<Action>();

        /// <summary>
        /// Enqueue the given action to be performed later.
        /// </summary>
        /// <param name="toRun">The action to run.</param>
        public void PopulateLater(Action a)
        {
            if (tagStack.Count > 0)
            {
                // If we are currently executing with a duplication guard, then the same
                // guard must be used for the deferred action
                var key = tagStack.Peek();
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
                    ExtractionError($"Uncaught exception. {ex.Message}", null, this.CreateLocation(), ex.StackTrace);
                }
            }
        }

        public Context(Extractor e, TrapWriter trapWriter, bool addAssemblyTrapPrefix)
        {
            Extractor = e;
            TrapWriter = trapWriter;
            ShouldAddAssemblyTrapPrefix = addAssemblyTrapPrefix;
        }


        public ICommentGenerator CommentGenerator { get; } = new CommentProcessor();


        private int currentRecursiveDepth = 0;
        private const int maxRecursiveDepth = 150;

        private void EnterScope()
        {
            if (currentRecursiveDepth >= maxRecursiveDepth)
                throw new StackOverflowException(string.Format("Maximum nesting depth of {0} exceeded", maxRecursiveDepth));
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
        public void Populate(ISymbol? optionalSymbol, ICachedEntity entity)
        {
            if (writingLabel)
            {
                // Don't write tuples etc if we're currently defining a label
                PopulateLater(() => Populate(optionalSymbol, entity));
                return;
            }

            bool duplicationGuard;
            bool deferred;

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

            var a = duplicationGuard && IsEntityDuplicationGuarded(entity, out var loc)
                ? (Action)(() => WithDuplicationGuard(new Key(entity, loc), () => entity.Populate(TrapWriter.Writer)))
                : (Action)(() => this.Try(null, optionalSymbol, () => entity.Populate(TrapWriter.Writer)));

            if (deferred)
                populateQueue.Enqueue(a);
            else
                a();
        }

        protected virtual bool IsEntityDuplicationGuarded(ICachedEntity entity, [NotNullWhen(returnValue: true)] out Entities.Location? loc)
        {
            loc = null;
            return false;
        }

        /// <summary>
        /// Runs the given action <paramref name="a"/>, guarding for trap duplication
        /// based on key <paramref name="key"/>.
        /// </summary>
        public virtual void WithDuplicationGuard(Key key, Action a)
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

        /// <summary>
        /// Register a program entity which can be bound to comments.
        /// </summary>
        /// <param name="cx">Extractor context.</param>
        /// <param name="entity">Program entity.</param>
        /// <param name="l">Location of the entity.</param>
        public void BindComments(IEntity entity, Microsoft.CodeAnalysis.Location l)
        {
            var duplicationGuardKey = tagStack.Count > 0 ? tagStack.Peek() : null;
            CommentGenerator.AddElement(entity.Label, duplicationGuardKey, l);
        }

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
        public void ExtractionError(string message, ISymbol? optionalSymbol, IEntity optionalEntity)
        {
            if (!(optionalSymbol is null))
            {
                ExtractionError(message, optionalSymbol.ToDisplayString(), CreateLocation(optionalSymbol.Locations.FirstOrDefault()));
            }
            else if (!(optionalEntity is null))
            {
                ExtractionError(message, optionalEntity.Label.ToString(), CreateLocation(optionalEntity.ReportingLocation));
            }
            else
            {
                ExtractionError(message, null, this.CreateLocation());
            }
        }

        /// <summary>
        /// Log an extraction message.
        /// </summary>
        /// <param name="msg">The message to log.</param>
        public void ExtractionError(Message msg)
        {
            new Entities.ExtractionMessage(this, msg);
            Extractor.Message(msg);
        }

        public virtual Entities.Location CreateLocation() =>
            GeneratedLocation.Create(this);

        public virtual Entities.Location CreateLocation(Microsoft.CodeAnalysis.Location? location) =>
            CreateLocation();

        /// <summary>
        /// Signal an error in the program model.
        /// </summary>
        public void ModelError(SyntaxNode node, string msg)
        {
            if (!Extractor.Standalone)
                throw new InternalError(node, msg);
        }

        /// <summary>
        /// Signal an error in the program model.
        /// </summary>
        public void ModelError(ISymbol symbol, string msg)
        {
            if (!Extractor.Standalone)
                throw new InternalError(symbol, msg);
        }

        /// <summary>
        /// Signal an error in the program model.
        /// </summary>
        public void ModelError(string msg)
        {
            if (!Extractor.Standalone)
                throw new InternalError(msg);
        }

        /// <summary>
        /// Tries the supplied action <paramref name="a"/>, and logs an uncaught
        /// exception error if the action fails.
        /// </summary>
        public void Try(SyntaxNode? node, ISymbol? symbol, Action a)
        {
            try
            {
                a();
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                Message message;

                if (node != null)
                {
                    message = Message.Create(this, ex.Message, node, ex.StackTrace);
                }
                else if (symbol != null)
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
        /// Write the given tuple to the trap file.
        /// </summary>
        public void Emit(Tuple tuple)
        {
            TrapWriter.Emit(tuple);
        }
    }
}
