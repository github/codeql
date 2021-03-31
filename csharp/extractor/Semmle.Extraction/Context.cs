using Microsoft.CodeAnalysis;
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

        private readonly Queue<IEntity> labelQueue = new();

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
                    entity.DefineLabel(TrapWriter.Writer, Extractor);
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
            where TEntity : CachedEntity =>
                cacheKey is ISymbol s ? CreateEntity(factory, s, init, symbolEntityCache) : CreateEntity(factory, cacheKey, init, objectEntityCache);

        internal TEntity CreateEntityFromSymbol<TSymbol, TEntity>(CachedEntityFactory<TSymbol, TEntity> factory, TSymbol init)
            where TSymbol : ISymbol
            where TEntity : CachedEntity => CreateEntity(factory, init, init, symbolEntityCache);

        /// <summary>
        /// Creates and populates a new entity, or returns the existing one from the cache.
        /// </summary>
        /// <param name="factory">The entity factory.</param>
        /// <param name="cacheKey">The key used for caching.</param>
        /// <param name="init">The initializer for the entity.</param>
        /// <param name="dictionary">The dictionary to use for caching.</param>
        /// <returns>The new/existing entity.</returns>
        private TEntity CreateEntity<TInit, TCacheKey, TEntity>(CachedEntityFactory<TInit, TEntity> factory, TCacheKey cacheKey, TInit init, IDictionary<TCacheKey, CachedEntity> dictionary)
            where TCacheKey : notnull
            where TEntity : CachedEntity
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

        private readonly IDictionary<object, CachedEntity> objectEntityCache = new Dictionary<object, CachedEntity>();
        private readonly IDictionary<ISymbol, CachedEntity> symbolEntityCache = new Dictionary<ISymbol, CachedEntity>(10000, SymbolEqualityComparer.Default);

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
        public void PopulateLater(Action toRun)
        {
            populateQueue.Enqueue(toRun);
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

        protected Context(Extractor extractor, TrapWriter trapWriter, bool shouldAddAssemblyTrapPrefix = false)
        {
            Extractor = extractor;
            TrapWriter = trapWriter;
            ShouldAddAssemblyTrapPrefix = shouldAddAssemblyTrapPrefix;
        }

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

        /// <summary>
        /// Populates an entity, handling the tag stack appropriately
        /// </summary>
        /// <param name="optionalSymbol">Symbol for reporting errors.</param>
        /// <param name="entity">The entity to populate.</param>
        /// <exception cref="InternalError">Thrown on invalid trap stack behaviour.</exception>
        private void Populate(ISymbol? optionalSymbol, CachedEntity entity)
        {
            if (writingLabel)
            {
                // Don't write tuples etc if we're currently defining a label
                PopulateLater(() => Populate(optionalSymbol, entity));
                return;
            }

            this.Try(null, optionalSymbol, () => entity.Populate(TrapWriter.Writer));
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
        private void ExtractionError(string message, ISymbol? optionalSymbol, Entity optionalEntity)
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
                ExtractionError(message, null, CreateLocation());
            }
        }

        /// <summary>
        /// Log an extraction message.
        /// </summary>
        /// <param name="msg">The message to log.</param>
        private void ExtractionError(Message msg)
        {
            new ExtractionMessage(this, msg);
            Extractor.Message(msg);
        }

        private void ExtractionError(InternalError error)
        {
            ExtractionError(new Message(error.Message, error.EntityText, CreateLocation(error.Location), error.StackTrace, Severity.Error));
        }

        private void ReportError(InternalError error)
        {
            if (!Extractor.Standalone)
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

        public virtual Entities.Location CreateLocation() =>
            GeneratedLocation.Create(this);

        public virtual Entities.Location CreateLocation(Microsoft.CodeAnalysis.Location? location) =>
            CreateLocation();
    }
}
