using Microsoft.CodeAnalysis;
using Semmle.Extraction.CommentProcessing;
using Semmle.Extraction.Entities;
using Semmle.Util.Logging;
using System;
using System.Collections.Generic;
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
        public readonly IExtractor Extractor;

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

        private SemanticModel? cachedModel;

        /// <summary>
        /// Access to the trap file.
        /// </summary>
        public readonly TrapWriter TrapWriter;

        int GetNewId() => TrapWriter.IdCounter++;

        /// <summary>
        /// Creates a new entity using the factory.
        /// </summary>
        /// <param name="factory">The entity factory.</param>
        /// <param name="init">The initializer for the entity.</param>
        /// <returns>The new/existing entity.</returns>
        public Entity CreateEntity<Type, Entity>(ICachedEntityFactory<Type, Entity> factory, Type init) where Entity : ICachedEntity where Type:struct
        {
            return CreateNonNullEntity(factory, init);
        }

        /// <summary>
        /// Creates a new entity using the factory.
        /// </summary>
        /// <param name="factory">The entity factory.</param>
        /// <param name="init">The initializer for the entity.</param>
        /// <returns>The new/existing entity.</returns>
        public Entity CreateNullableEntity<Type, Entity>(ICachedEntityFactory<Type, Entity> factory, Type init) where Entity : ICachedEntity
        {
            return init == null ? CreateEntity2(factory, init) : CreateNonNullEntity(factory, init);
        }

        /// <summary>
        /// Creates a new entity using the factory.
        /// </summary>
        /// <param name="factory">The entity factory.</param>
        /// <param name="init">The initializer for the entity.</param>
        /// <returns>The new/existing entity.</returns>
        public Entity CreateEntityFromSymbol<Type, Entity>(ICachedEntityFactory<Type, Entity> factory, Type init)
            where Entity : ICachedEntity
            where Type: ISymbol
        {
            return init == null ? CreateEntity2(factory, init) : CreateNonNullEntity(factory, init);
        }

        // A recursion guard against writing to the trap file whilst writing an id to the trap file.
        bool WritingLabel = false;

        public void DefineLabel(IEntity entity, TextWriter trapFile, IExtractor extractor)
        {
            if (WritingLabel)
            {
                // Don't define a label whilst writing a label.
                PopulateLater(() => DefineLabel(entity, trapFile, extractor));
            }
            else
            {
                try
                {
                    WritingLabel = true;
                    entity.DefineLabel(trapFile, extractor);
                }
                finally
                {
                    WritingLabel = false;
                }
            }
        }

        /// <summary>
        /// Creates a new entity using the factory.
        /// Uses a different cache to <see cref="CreateEntity{Type, Entity}(ICachedEntityFactory{Type, Entity}, Type)"/>,
        /// and can store null values.
        /// </summary>
        /// <param name="factory">The entity factory.</param>
        /// <param name="init">The initializer for the entity.</param>
        /// <returns>The new/existing entity.</returns>
        public Entity CreateEntity2<Type, Entity>(ICachedEntityFactory<Type, Entity> factory, Type init) where Entity : ICachedEntity
        {
            using (StackGuard)
            {
                var entity = factory.Create(this, init);

                if (entityLabelCache.TryGetValue(entity, out var label))
                {
                    entity.Label = label;
                }
                else
                {
                    label = GetNewLabel();
                    entity.Label = label;
                    entityLabelCache[entity] = label;

                    DefineLabel(entity, TrapWriter.Writer, Extractor);

                    if (entity.NeedsPopulation)
                        Populate(init as ISymbol, entity);
#if DEBUG_LABELS
                    using (var id = new StringWriter())
                    {
                        entity.WriteId(id);
                        CheckEntityHasUniqueLabel(id.ToString(), entity);
                    }
#endif

                }
                return entity;
            }
        }

#if DEBUG_LABELS
        private void CheckEntityHasUniqueLabel(string id, ICachedEntity entity)
        {
            if (idLabelCache.TryGetValue(id, out var originalEntity))
            {
                ExtractionError("Label collision for " + id, entity.Label.ToString(), Entities.Location.Create(this, entity.ReportingLocation), "", Severity.Warning);
            }
            else
            {
                idLabelCache[id] = entity;
            }
        }
#endif

        public Label GetNewLabel() => new Label(GetNewId());

        public Entity CreateNonNullEntity<Type, Entity>(ICachedEntityFactory<Type, Entity> factory, Type init)
            where Entity : ICachedEntity
        {
            if (init is null) throw new ArgumentException("Unexpected null value", nameof(init));

            if (objectEntityCache.TryGetValue(init, out var cached))
                return (Entity)cached;

            using (StackGuard)
            {
                var label = GetNewLabel();
                var entity = factory.Create(this, init);
                entity.Label = label;

                objectEntityCache[init] = entity;

                DefineLabel(entity, TrapWriter.Writer, Extractor);
                if (entity.NeedsPopulation)
                    Populate(init as ISymbol, entity);

#if DEBUG_LABELS
                using (var id = new StringWriter())
                {
                    entity.WriteQuotedId(id);
                    CheckEntityHasUniqueLabel(id.ToString(), entity);
                }
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
            else
            {
                extractedGenerics.Add(entity.Label);
                return true;
            }
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
        readonly Dictionary<string, ICachedEntity> idLabelCache = new Dictionary<string, ICachedEntity>();
#endif
        readonly Dictionary<object, ICachedEntity> objectEntityCache = new Dictionary<object, ICachedEntity>();
        readonly Dictionary<ICachedEntity, Label> entityLabelCache = new Dictionary<ICachedEntity, Label>();
        readonly HashSet<Label> extractedGenerics = new HashSet<Label>();

        /// <summary>
        /// Queue of items to populate later.
        /// The only reason for this is so that the call stack does not
        /// grow indefinitely, causing a potential stack overflow.
        /// </summary>
        readonly Queue<Action> populateQueue = new Queue<Action>();

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
                populateQueue.Enqueue(a);
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
                    ExtractionError(new Message(ex.Text, ex.EntityText, Entities.Location.Create(this, ex.Location), ex.StackTrace));
                }
                catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
                {
                    ExtractionError("Uncaught exception", ex.Message, GeneratedLocation.Create(this), ex.StackTrace);
                }
            }
        }

        /// <summary>
        /// The current compilation unit.
        /// </summary>
        public readonly Compilation Compilation;

        /// <summary>
        /// Create a new context, one per source file/assembly.
        /// </summary>
        /// <param name="e">The extractor.</param>
        /// <param name="c">The Roslyn compilation.</param>
        /// <param name="extractedEntity">Name of the source/dll file.</param>
        /// <param name="scope">Defines which symbols are included in the trap file (e.g. AssemblyScope or SourceScope)</param>
        public Context(IExtractor e, Compilation c, TrapWriter trapWriter, IExtractionScope scope)
        {
            Extractor = e;
            Compilation = c;
            Scope = scope;
            TrapWriter = trapWriter;
        }

        public bool FromSource => Scope.FromSource;

        public bool IsGlobalContext => Scope.IsGlobalScope;

        public readonly ICommentGenerator CommentGenerator = new CommentProcessor();

        readonly IExtractionScope Scope;

        /// <summary>
        ///     Whether the given symbol needs to be defined in this context.
        ///     This is the case if the symbol is contained in the source/assembly, or
        ///     of the symbol is a constructed generic.
        /// </summary>
        /// <param name="symbol">The symbol to populate.</param>
        public bool Defines(ISymbol symbol) =>
            !SymbolEqualityComparer.Default.Equals(symbol, symbol.OriginalDefinition) ||
            Scope.InScope(symbol);

        /// <summary>
        /// Whether the current extraction context defines a given file.
        /// </summary>
        /// <param name="path">The path to query.</param>
        public bool DefinesFile(string path) => Scope.InFileScope(path);

        int currentRecursiveDepth = 0;
        const int maxRecursiveDepth = 150;

        void EnterScope()
        {
            if (currentRecursiveDepth >= maxRecursiveDepth)
                throw new StackOverflowException(string.Format("Maximum nesting depth of {0} exceeded", maxRecursiveDepth));
            ++currentRecursiveDepth;
        }

        void ExitScope()
        {
            --currentRecursiveDepth;
        }

        public IDisposable StackGuard => new ScopeGuard(this);

        private class ScopeGuard : IDisposable
        {
            readonly Context cx;

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

        class PushEmitter : ITrapEmitter
        {
            readonly Key Key;

            public PushEmitter(Key key)
            {
                Key = key;
            }

            public void EmitTrap(TextWriter trapFile)
            {
                trapFile.Write(".push ");
                Key.AppendTo(trapFile);
                trapFile.WriteLine();
            }
        }

        class PopEmitter : ITrapEmitter
        {
            public void EmitTrap(TextWriter trapFile)
            {
                trapFile.WriteLine(".pop");
            }
        }

        readonly Stack<Key> tagStack = new Stack<Key>();

        /// <summary>
        /// Populates an entity, handling the tag stack appropriately
        /// </summary>
        /// <param name="optionalSymbol">Symbol for reporting errors.</param>
        /// <param name="entity">The entity to populate.</param>
        /// <exception cref="InternalError">Thrown on invalid trap stack behaviour.</exception>
        public void Populate(ISymbol? optionalSymbol, ICachedEntity entity)
        {
            if (WritingLabel)
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

            var a = duplicationGuard ?
                (Action)(() => WithDuplicationGuard(new Key(entity, this.Create(entity.ReportingLocation)), () => entity.Populate(TrapWriter.Writer))) :
                (Action)(() => this.Try(null, optionalSymbol, () => entity.Populate(TrapWriter.Writer)));

            if (deferred)
                populateQueue.Enqueue(a);
            else
                a();
        }

        /// <summary>
        /// Runs the given action <paramref name="a"/>, guarding for trap duplication
        /// based on key <paramref name="key"/>.
        /// </summary>
        public void WithDuplicationGuard(Key key, Action a)
        {
            if (Scope is AssemblyScope)
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
        public void ExtractionError(string message, string entityText, Entities.Location location, string? stackTrace = null, Severity severity = Severity.Error)
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
                ExtractionError(message, optionalSymbol.ToDisplayString(), Entities.Location.Create(this, optionalSymbol.Locations.FirstOrDefault()));
            }
            else if(!(optionalEntity is null))
            {
                ExtractionError(message, optionalEntity.Label.ToString(), Entities.Location.Create(this, optionalEntity.ReportingLocation));
            }
            else
            {
                ExtractionError(message, "", GeneratedLocation.Create(this));
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
    }

    static public class ContextExtensions
    {
        /// <summary>
        /// Signal an error in the program model.
        /// </summary>
        /// <param name="cx">The context.</param>
        /// <param name="node">The syntax node causing the failure.</param>
        /// <param name="msg">The error message.</param>
        static public void ModelError(this Context cx, SyntaxNode node, string msg)
        {
            if (!cx.Extractor.Standalone)
                throw new InternalError(node, msg);
        }

        /// <summary>
        /// Signal an error in the program model.
        /// </summary>
        /// <param name="context">The context.</param>
        /// <param name="node">Symbol causing the error.</param>
        /// <param name="msg">The error message.</param>
        static public void ModelError(this Context cx, ISymbol symbol, string msg)
        {
            if (!cx.Extractor.Standalone)
                throw new InternalError(symbol, msg);
        }

        /// <summary>
        /// Signal an error in the program model.
        /// </summary>
        /// <param name="context">The context.</param>
        /// <param name="msg">The error message.</param>
        static public void ModelError(this Context cx, string msg)
        {
            if (!cx.Extractor.Standalone)
                throw new InternalError(msg);
        }

        /// <summary>
        /// Tries the supplied action <paramref name="a"/>, and logs an uncaught
        /// exception error if the action fails.
        /// </summary>
        /// <param name="context">The context.</param>
        /// <param name="node">Optional syntax node for error reporting.</param>
        /// <param name="symbol">Optional symbol for error reporting.</param>
        /// <param name="a">The action to perform.</param>
        static public void Try(this Context context, SyntaxNode? node, ISymbol? symbol, Action a)
        {
            try
            {
                a();
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                Message message;

                if (node != null)
                    message = Message.Create(context, ex.Message, node, ex.StackTrace);
                else if (symbol != null)
                    message = Message.Create(context, ex.Message, symbol, ex.StackTrace);
                else if (ex is InternalError ie)
                    message = new Message(ie.Text, ie.EntityText, Entities.Location.Create(context, ie.Location), ex.StackTrace);
                else
                    message = new Message("Uncaught exception", ex.Message, GeneratedLocation.Create(context), ex.StackTrace);

                context.ExtractionError(message);
            }
        }

        /// <summary>
        /// Write the given tuple to the trap file.
        /// </summary>
        /// <param name="cx">Extractor context.</param>
        /// <param name="tuple">Tuple to write.</param>
        static public void Emit(this Context cx, Tuple tuple)
        {
            cx.TrapWriter.Emit(tuple);
        }
    }
}
