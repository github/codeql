using Microsoft.CodeAnalysis;
using System.Linq;
using Semmle.Extraction.CommentProcessing;
using System.Collections.Generic;
using System;
using Semmle.Util.Logging;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction
{
    /// <summary>
    /// State which needs needs to be available throughout the extraction process.
    ///     There is one Context object per trap output file.
    /// </summary>
    public class Context
    {
        /// <summary>
        /// Interface to various extraction functions, e.g. logger, trap writer.
        /// </summary>
        public readonly IExtractor Extractor;

        /// <summary>
        /// The program database provided by Roslyn.
        /// There's one per syntax tree, which makes things awkward.
        /// </summary>
        public SemanticModel Model(SyntaxNode node)
        {
            if (cachedModel == null || node.SyntaxTree != cachedModel.SyntaxTree)
            {
                cachedModel = Compilation.GetSemanticModel(node.SyntaxTree);
            }

            return cachedModel;
        }

        SemanticModel cachedModel;

        /// <summary>
        ///     Access to the trap file.
        /// </summary>
        public readonly TrapWriter TrapWriter;

        int NewId() => TrapWriter.IdCounter++;

        /// <summary>
        /// Gets the cached label for the given entity, or creates a new
        /// (cached) label if it hasn't already been created. The label
        /// is set on the supplied <paramref name="entity"/> object.
        /// </summary>
        /// <returns><code>true</code> iff the label already existed.</returns>
        public bool GetOrAddCachedLabel(ICachedEntity entity)
        {
            var id = GetId(entity);
            if (id == null)
                throw new InternalError("Attempt to create a null entity for {0}", entity.GetType());

            Label existingLabel;
            if (labelCache.TryGetValue(id, out existingLabel))
            {
                entity.Label = existingLabel;
                return true;
            }

            entity.Label = new Label(NewId());
            DefineLabel(entity.Label, id);
            labelCache[id] = entity.Label;
            return false;
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
        /// Gets the ID belonging to cached entity <paramref name="entity"/>.
        ///
        /// The ID itself is also cached, but unlike the label cache (which is used
        /// to prevent reextraction/infinite loops), this is a pure performance
        /// optimization. Moreover, the label cache is injective, which the ID cache
        /// need not be.
        /// </summary>
        IId GetId(ICachedEntity entity)
        {
            IId id;
            if (!idCache.TryGetValue(entity, out id))
            {
                id = entity.Id;
                idCache[entity] = id;
            }
            return id;
        }

        /// <summary>
        /// Creates a fresh label with ID "*", and set it on the
        /// supplied <paramref name="entity"/> object.
        /// </summary>
        public void AddFreshLabel(IEntity entity)
        {
            var label = new Label(NewId());
            TrapWriter.Emit(new DefineFreshLabelEmitter(label));
            entity.Label = label;
        }

        readonly Dictionary<IId, Label> labelCache = new Dictionary<IId, Label>();
        readonly HashSet<Label> extractedGenerics = new HashSet<Label>();

        public void DefineLabel(IEntity entity)
        {
            entity.Label = new Label(NewId());
            DefineLabel(entity.Label, entity.Id);
        }

        void DefineLabel(Label label, IId id)
        {
            TrapWriter.Emit(new DefineLabelEmitter(label, id));
        }

        readonly Dictionary<object, IId> idCache = new Dictionary<object, IId>();

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
                catch (InternalError e)
                {
                    Extractor.Message(e.ExtractionMessage);
                }
                catch (Exception e)
                {
                    Extractor.Message(new Message { severity = Severity.Error, exception = e, message = "Uncaught exception" });
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

        public readonly ICommentGenerator CommentGenerator = new CommentProcessor();

        readonly IExtractionScope Scope;

        /// <summary>
        ///     Whether the given symbol needs to be defined in this context.
        ///     This is the case if the symbol is contained in the source/assembly, or
        ///     of the symbol is a constructed generic.
        /// </summary>
        /// <param name="symbol">The symbol to populate.</param>
        public bool Defines(ISymbol symbol) => !Equals(symbol, symbol.OriginalDefinition) || Scope.InScope(symbol);

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

        class DefineLabelEmitter : ITrapEmitter
        {
            readonly Label label;
            readonly IId id;

            public DefineLabelEmitter(Label label, IId id)
            {
                this.label = label;
                this.id = id;
            }

            public void EmitToTrapBuilder(ITrapBuilder tb)
            {
                label.AppendTo(tb);
                tb.Append("=");
                id.AppendTo(tb);
                tb.AppendLine();
            }
        }

        class DefineFreshLabelEmitter : ITrapEmitter
        {
            readonly Label Label;

            public DefineFreshLabelEmitter(Label label)
            {
                Label = label;
            }

            public void EmitToTrapBuilder(ITrapBuilder tb)
            {
                Label.AppendTo(tb);
                tb.Append("=*");
                tb.AppendLine();
            }
        }

        class PushEmitter : ITrapEmitter
        {
            readonly Key Key;

            public PushEmitter(Key key)
            {
                Key = key;
            }

            public void EmitToTrapBuilder(ITrapBuilder tb)
            {
                tb.Append(".push ");
                Key.AppendTo(tb);
                tb.AppendLine();
            }
        }

        class PopEmitter : ITrapEmitter
        {
            public void EmitToTrapBuilder(ITrapBuilder tb)
            {
                tb.Append(".pop");
                tb.AppendLine();
            }
        }

        readonly Stack<Key> tagStack = new Stack<Key>();

        /// <summary>
        /// Populates an entity, handling the tag stack appropriately
        /// </summary>
        /// <param name="optionalSymbol">Symbol for reporting errors.</param>
        /// <param name="entity">The entity to populate.</param>
        /// <exception cref="InternalError">Thrown on invalid trap stack behaviour.</exception>
        public void Populate(ISymbol optionalSymbol, ICachedEntity entity)
        {
            bool duplicationGuard;
            bool deferred;

            switch (entity.TrapStackBehaviour)
            {
                case TrapStackBehaviour.NeedsLabel:
                    if (!tagStack.Any())
                        Extractor.Message(new Message { message = "Tagstack unexpectedly empty", symbol = optionalSymbol, severity = Severity.Error });
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
                (Action)(() => WithDuplicationGuard(new Key(entity, this.Create(entity.ReportingLocation)), entity.Populate)) :
                (Action)(() => this.Try(null, optionalSymbol, entity.Populate));

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
            CommentGenerator.RegisterElementLocation(entity.Label, duplicationGuardKey, l);
        }
    }

    static public class ContextExtensions
    {
        /// <summary>
        /// Signal an error in the program model.
        /// </summary>
        /// <param name="cx">The context.</param>
        /// <param name="node">The syntax node causing the failure.</param>
        /// <param name="format">A string format.</param>
        /// <param name="args">Arguments for the format.</param>
        static public void ModelError(this Context cx, SyntaxNode node, string format, params object[] args)
        {
            if (!cx.Extractor.Standalone)
                throw new InternalError(node, format, args);
        }

        /// <summary>
        /// Signal an error in the program model.
        /// </summary>
        /// <param name="context">The context.</param>
        /// <param name="node">Symbol causing the error.</param>
        /// <param name="format">Format of message string.</param>
        /// <param name="args">Arguments to message string.</param>
        static public void ModelError(this Context cx, ISymbol symbol, string format, params object[] args)
        {
            if (!cx.Extractor.Standalone)
                throw new InternalError(symbol, format, args);
        }

        /// <summary>
        /// Signal an error in the program model.
        /// </summary>
        /// <param name="context">The context.</param>
        /// <param name="format">Format of message string.</param>
        /// <param name="args">Arguments to message string.</param>
        static public void ModelError(this Context cx, string format, params object[] args)
        {
            if (!cx.Extractor.Standalone)
                throw new InternalError(format, args);
        }

        /// <summary>
        /// Tries the supplied action <paramref name="a"/>, and logs an uncaught
        /// exception error if the action fails.
        /// </summary>
        /// <param name="context">The context.</param>
        /// <param name="node">Optional syntax node for error reporting.</param>
        /// <param name="symbol">Optional symbol for error reporting.</param>
        /// <param name="a">The action to perform.</param>
        static public void Try(this Context context, SyntaxNode node, ISymbol symbol, Action a)
        {
            try
            {
                a();
            }
            catch (Exception ex)
            {
                var internalError = ex as InternalError;
                var message = internalError != null
                    ? internalError.ExtractionMessage
                    : new Message { severity = Severity.Error, exception = ex, message = ex.ToString() };

                if (node != null)
                    message.node = node;

                if (symbol != null)
                    message.symbol = symbol;

                context.Extractor.Message(message);
            }
        }

        /// <summary>
        /// Logs the given string.
        /// </summary>
        /// <param name="cx">The extractor context.</param>
        /// <param name="format">The format string.</param>
        /// <param name="args">The inserts to the format string.</param>
        static public void Log(this Context cx, string format, params object[] args)
        {
            cx.Extractor.Message(new Message { severity = Severity.Info, message = string.Format(format, args) });
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
