overlay[local?]
module;

private import codeql.util.Location
private import codeql.util.DualGraph
private import codeql.util.FileSystem
private import codeql.util.Boolean
private import codeql.util.Unit
private import codeql.util.Void
private import codeql.dataflow.internal.AccessPathSyntax as AccessPathSyntax
private import codeql.controlflow.BasicBlock as BB
private import codeql.ssa.Ssa as Ssa
private import codeql.dataflow.VariableCapture as VariableCapture
private import codeql.dataflow.DataFlow as DataFlow
private import codeql.dataflow.TaintTracking as TaintTracking

module MakeUnifiedDataFlow0<LocationSig Location, BB::CfgSig<Location> Cfg> {
  private class BasicBlock = Cfg::BasicBlock;

  private class ControlFlowNode = Cfg::ControlFlowNode;

  signature module UnifiedDataFlowSig1 {
    class AstNode {
      string toString();

      Location getLocation();

      AstNode getParent();
    }

    class Call {
      string toString();

      Location getLocation();
    }

    class NamespaceObject {
      string toString();

      Location getLocation();

      /**
       * Gets the enclosing callable, if this namespace object represents an allocation site with a concrete
       * value at runtime.
       */
      Callable getEnclosingCallable(); // TODO: maybe we should not require namespace to exist in a callable?
    }

    class ClassLikeObject extends NamespaceObject {
      NamespaceObject getInstancePrototype();
    }

    /**
     * Holds if `callable` should be treated as a method during call graph construction.
     *
     * For such callables, the receiver is assumed to refer to or inherit from the object on which the `callable` is stored.
     */
    predicate isMethod(Callable callable);

    /**
     * Holds if `callable` is called to initialize instances of a class.
     */
    predicate isInstanceInitializer(Callable callable, ClassLikeObject cls);

    class Callable extends AstNode;

    Callable getCallableFromBasicBlock(BasicBlock bb);

    Callable getCallableFromCfgNode(ControlFlowNode node);

    class LocalVariable {
      string toString();

      Location getLocation();

      Callable getDeclaringCallable();

      predicate isCaptured();
    }

    /** An abstract value that a `Guard` may evaluate to. */
    class GuardValue {
      /** Gets a textual representation of this value. */
      string toString();
    }

    /** A (potential) guard. */
    class Guard {
      /** Gets a textual representation of this guard. */
      string toString();

      /**
       * Holds if the evaluation of this guard to `val` corresponds to the edge
       * from `bb1` to `bb2`.
       */
      predicate hasValueBranchEdge(BasicBlock bb1, BasicBlock bb2, GuardValue val);

      /**
       * Holds if this guard evaluating to `val` controls the control-flow
       * branch edge from `bb1` to `bb2`. That is, following the edge from
       * `bb1` to `bb2` implies that this guard evaluated to `val`.
       *
       * This predicate differs from `hasValueBranchEdge` in that it also covers
       * indirect guards, such as:
       * ```
       * b = guard;
       * ...
       * if (b) { ... }
       * ```
       */
      predicate valueControlsBranchEdge(BasicBlock bb1, BasicBlock bb2, GuardValue val);
    }

    /** Holds if `guard` directly controls block `bb` upon evaluating to `val`. */
    predicate guardDirectlyControlsBlock(Guard guard, BasicBlock bb, GuardValue val);

    /**
     * Holds if `node` appears in a context where it receives an incoming value, such as
     * the target of an assignment.
     *
     * Typically this holds for:
     * - Parameters
     * - Variable names and binding patterns in a variable declaration or pattern-matching context
     * - The left-hand side of assignments
     * - The left-hand side of iterator for-loops (The `x` in `for (x in iterator) {...}`)
     *
     * This is not mutually exclusive with `hasCompletionValue`. For example, the target of a compound assignment (`x += y`)
     * will typically have both an incoming value and a completion value, with different associated CFG nodes.
     */
    predicate hasIncomingValue(AstNode node, ControlFlowNode when);

    /**
     * Holds if `node` completes with a value at the given CFG node.
     *
     * For a typical CFG construction where expressions are post-order, this is simply the CFG wrapper around `node`.
     *
     * If `node` has multiple exits with a value, this predicate should hold for each of the exits. Exceptional exits should not be included.
     */
    predicate hasCompletionValue(AstNode node, ControlFlowNode when);

    /**
     * Holds if `node` needs a post-update node that can be referenced with `node.isPostUpdatedValue()` in the step relation.
     *
     * This should generally hold when `node` appears in a context where its result is mutated by a store after `node` has completed.
     *
     * Typically this will hold for `obj` in `obj.f = E`, and `when` should refer to the point in time where the assignment
     * happens.
     */
    predicate hasPostUpdatedValue(AstNode node, ControlFlowNode when);

    /** Gets the control-flow node where the given call happens. */
    ControlFlowNode getCfgNodeFromCall(Call call);

    /**
     * Holds if exceptions thrown inside `tryBlock` should not automatically propagate out of that node.
     *
     * For a classic `try` statement, `try {S} catch ...`, this should hold for the `{S}` block.
     *
     * A data flow node will be generated for this case, to be accessed with `node.isInterceptedException(tryBlock)`.
     * Corresponding data flow steps should be added to propagate the caught value into the catch block(s) as appropriate.
     */
    predicate isInterceptingExceptions(AstNode tryBlock);

    default predicate definitelyInitialized(LocalVariable v) { none() }

    class Constant {
      int asArrayIndex();

      /** Gets the operand used when referencing this constant from a MaD token. */
      string getAsOperand();

      /** Gets a string-representation of the constant. Should generally equal `getAsOperand()` when that exists. */
      string toString();
    }

    /**
     * A type of container that associates values with a key or index, such as arrays, lists, tuples, maps, dictionaries, etc.
     *
     * In some languages, lists and maps may be difficult to distinguish at their use sites as they are interacted with using the same syntax or method names.
     * In such cases it can make sense to unify the relevant container kinds.
     *
     * Non-indexable containers such as sets, iterators, and streams should either be represented by a `LanguageContent`, or be treated interchangeably
     * with the contents of another container kind. For example: iterator contents could be represented by array contents, so the conversion between
     * arrays and iterators becomes a no-op. In other languages it may be better for it to have its own `LanguageContent`. The choice depends on how
     * difficult it is to recognise conversions between the container kinds, versus the value of pruning false flow based on more fine-grained contents.
     */
    class IndexedContainerKind {
      /** Holds if data flowing into the keys themselves should be tracked. For array-like containers this should be `none()`. */
      predicate trackFlowIntoKeys();

      /** Gets the MaD token to associate with keys in this map-like container. Should have no result for array-like containers. */
      string getKeyToken();

      /** Gets the MaD token to associate with values in this container (i.e. map values or array elements). */
      string getValueToken();

      /**
       * Holds if values that are associated with `key` should be tracked precisely.
       *
       * For array-like containers, this should hold for non-negative integers up to a certain size.
       *
       * For map-like containers, this should hold for all keys that are likely worth tracking.
       */
      predicate trackValuesAssociatedWithKey(Constant key);
    }

    /**
     * A language-specific content that is not handled by `IndexedContainerKind`.
     */
    class LanguageContent {
      /** Holds if models-as-data can refer to this content (as a singleton content set) as `head[operand]`. */
      predicate hasModelToken(string head, string operand);

      string toString();

      Location getLocation();

      /**
       * Holds if a store step using the this content (wrapped in a singleton content set)
       * should clear the previous value stored in that content.
       *
       * Specifically, when a store step targets a post-update node, and `supportsStrongUpdate()` holds for the content set,
       * all values from `getAStoreContent()` coming from the pre-update node are blocked.
       *
       * Should generally hold for contents representing a single storage location,
       * such as a field, and should not hold for abstract storage locations,
       * such as an "unknown field" content.
       *
       * For contents that aren't used for storing into post-update nodes, it does not matter whether
       * this predicate holds or not.
       */
      predicate supportsStrongUpdate();
    }
  }

  module MakeUnifiedDataFlow1<UnifiedDataFlowSig1 D1> {
    private import D1

    pragma[nomagic]
    predicate hasIncomingValue(AstNode node) { hasIncomingValue(node, _) }

    pragma[nomagic]
    predicate hasCompletionValue(AstNode node) { hasCompletionValue(node, _) }

    private newtype TBuiltinReturnPosition =
      TReturnValue() or
      TReturnException()

    class BuiltinReturnPosition extends TBuiltinReturnPosition {
      string toString() {
        this = TReturnValue() and result = "value"
        or
        this = TReturnException() and result = "exception"
      }
    }

    private newtype TContent =
      TCaptureContent(LocalVariable v) { v.isCaptured() } or
      TContainerSlot(IndexedContainerKind kind, Constant key) {
        kind.trackValuesAssociatedWithKey(key)
      } or
      TContainerUnknownSlot(IndexedContainerKind kind) or
      TContainerKey(IndexedContainerKind kind) { kind.trackFlowIntoKeys() } or
      TLanguageContent(LanguageContent kind)

    class Content extends TContent {
      predicate hasModelToken(string head, string operand) {
        exists(IndexedContainerKind kind, Constant key |
          key = this.asContainerSlot(kind) and
          head = kind.getValueToken() and
          operand = key.getAsOperand() + "!" // use "!" when referring to this without the unknown element
        )
        or
        exists(IndexedContainerKind kind |
          this.isUnknownContainerSlot(kind) and
          head = kind.getValueToken() and
          operand = "?"
          or
          this.isContainerKey(kind) and
          head = kind.getKeyToken() and
          operand = ""
        )
        or
        this.asLanguageContent().hasModelToken(head, operand)
      }

      LocalVariable asCapturedVariable() { this = TCaptureContent(result) }

      Constant asContainerSlot(IndexedContainerKind kind) { this = TContainerSlot(kind, result) }

      int asArrayIndex(IndexedContainerKind kind) {
        result = this.asContainerSlot(kind).asArrayIndex()
      }

      predicate isUnknownContainerSlot(IndexedContainerKind kind) {
        this = TContainerUnknownSlot(kind)
      }

      predicate isContainerKey(IndexedContainerKind kind) { this = TContainerKey(kind) }

      LanguageContent asLanguageContent() { this = TLanguageContent(result) }

      string toString() {
        // Note: these strings are visible to end-users in the generated data flow paths.
        result = this.asCapturedVariable().toString()
        or
        exists(IndexedContainerKind kind |
          result = kind.getValueToken() + "[" + this.asContainerSlot(kind).toString() + "]"
          or
          this.isUnknownContainerSlot(kind) and
          result = kind.getValueToken()
          or
          this.isContainerKey(kind) and
          result = kind.getKeyToken()
        )
        or
        result = this.asLanguageContent().toString()
      }

      Location getLocation() {
        result = this.asCapturedVariable().getLocation()
        or
        result = this.asLanguageContent().getLocation()
      }
    }

    signature module UnifiedDataFlowSig2 {
      predicate synthesizeNode(AstNode node, string tag, ControlFlowNode cfgNode);

      class LanguageContentSet {
        Content getAReadContent();

        Content getAStoreContent();

        /** Holds if models-as-data can refer to this content set as `head[operand]`. */
        predicate hasModelToken(string head, string operand);

        string toString();

        Location getLocation();

        /**
         * Holds if store steps using this content set should clear the previous value.
         *
         * Specifically, when a store step targets a post-update node, and `supportsStrongUpdate()` holds for the content set,
         * all values from `getAStoreContent()` coming from the pre-update node are blocked.
         *
         * Should generally hold for content sets representing a single storage location,
         * such as a field, and should not hold for abstract storage locations,
         * such as an "unknown field" content.
         */
        predicate supportsStrongUpdate();
      }
    }

    module MakeUnifiedDataFlow2<UnifiedDataFlowSig2 D2> {
      private import D2

      private newtype TContentSet =
        TSingleton(TContent content) or
        TContainerKnownSlot(IndexedContainerKind kind, Constant key) {
          kind.trackValuesAssociatedWithKey(key)
        } or
        TArrayElementLowerBound(IndexedContainerKind kind, int bound) {
          exists(Constant key |
            kind.trackValuesAssociatedWithKey(key) and
            bound = key.asArrayIndex()
          )
        } or
        TContainerAnySlot(IndexedContainerKind kind) or
        TLanguageContentSet(LanguageContentSet contents)

      class ContentSet extends TContentSet {
        predicate hasModelToken(string head, string operand) {
          this.asSingleton().hasModelToken(head, operand)
          or
          this.asLanguageContentSet().hasModelToken(head, operand)
          or
          exists(IndexedContainerKind kind, Constant key |
            key = this.asContainerSlot(kind) and
            head = kind.getValueToken() and
            operand = key.getAsOperand()
          )
          or
          exists(IndexedContainerKind kind, int n |
            n = this.asArrayElementLowerBound(kind) and
            head = kind.getValueToken() and
            operand = n + ".."
          )
          or
          exists(IndexedContainerKind kind |
            this.isAnyContainerSlot(kind) and
            head = kind.getValueToken() and
            operand = ""
          )
        }

        Content asSingleton() { this = TSingleton(result) }

        Constant asContainerSlot(IndexedContainerKind kind) {
          this = TContainerKnownSlot(kind, result)
        }

        predicate isAnyContainerSlot(IndexedContainerKind kind) { this = TContainerAnySlot(kind) }

        int asArrayElementLowerBound(IndexedContainerKind kind) {
          this = TArrayElementLowerBound(kind, result)
        }

        LanguageContentSet asLanguageContentSet() { this = TLanguageContentSet(result) }

        string toString() {
          result = this.asSingleton().toString()
          or
          exists(IndexedContainerKind kind |
            result = kind.getValueToken() + "[" + this.asArrayElementLowerBound(kind) + "..]"
            or
            result = kind.getValueToken() + "[" + this.asContainerSlot(kind) + "]"
            or
            this.isAnyContainerSlot(kind) and
            result = kind.getValueToken()
          )
          or
          result = this.asLanguageContentSet().toString()
        }

        Location getLocation() { result = this.asLanguageContentSet().getLocation() }

        cached
        Content getAReadContent() {
          result = this.asSingleton()
          or
          exists(IndexedContainerKind kind |
            this.asArrayElementLowerBound(kind) <= result.asArrayIndex(kind)
            or
            this.asContainerSlot(kind) = result.asContainerSlot(kind)
            or
            this.isAnyContainerSlot(kind) and
            exists(result.asContainerSlot(kind))
            or
            (
              exists(this.asArrayElementLowerBound(kind)) or
              exists(this.asContainerSlot(kind)) or
              this.isAnyContainerSlot(kind)
            ) and
            result.isUnknownContainerSlot(kind)
          )
          or
          result = this.asLanguageContentSet().getAReadContent()
        }

        cached
        Content getAStoreContent() {
          result = this.asSingleton()
          or
          exists(IndexedContainerKind kind |
            result.asContainerSlot(kind) = this.asContainerSlot(kind)
            or
            exists(this.asArrayElementLowerBound(kind)) and
            result.isUnknownContainerSlot(kind) // nothing better can be done at the moment, but this is usually not used for stores anyway
            or
            this.isAnyContainerSlot(kind) and
            result.isUnknownContainerSlot(kind)
          )
          or
          result = this.asLanguageContentSet().getAStoreContent()
        }
      }

      private predicate contentSetSupportsStrongUpdate(ContentSet contents) {
        contents.asSingleton().asLanguageContent().supportsStrongUpdate()
        or
        contents.asLanguageContentSet().supportsStrongUpdate()
        or
        contents instanceof TContainerKnownSlot
      }

      signature class IndexedContainerKindSig extends IndexedContainerKind;

      /** Generates a module with accessors for content sets related to the given array-like container kind. */
      module ArrayContentAccessor<IndexedContainerKindSig KindArg> {
        class Kind = KindArg;

        Kind kind() { any() }

        private Constant preciseKey() { kind().trackValuesAssociatedWithKey(result) }

        private int preciseIndex() { result = preciseKey().asArrayIndex() }

        pragma[nomagic]
        private int maxPreciseIndex() { result = max(preciseIndex()) }

        /** Read from a index or higher. Using this in a store will result in an unknown index. */
        pragma[nomagic]
        ContentSet lowerBound(int index) { result.asArrayElementLowerBound(kind()) = index }

        /** Any element of the array. */
        pragma[nomagic]
        ContentSet anyElement() { result = lowerBound(0) }

        pragma[nomagic]
        private ContentSet maxLowerBound() { result = lowerBound(maxPreciseIndex()) }

        pragma[nomagic]
        private ContentSet knownIndex(int index) {
          result.asContainerSlot(kind()).asArrayIndex() = index
        }

        /**
         * Read or store to a specific index.
         *
         * Reading from this content set will also observe values that were originally stored at an unknown index.
         *
         * Has no result for negative indices. Always has a result for non-negative indices,
         * but indices above a certain threshold will be associated with a less precise content set.
         */
        bindingset[index]
        ContentSet elementAt(int index) {
          result = knownIndex(index)
          or
          // If the index is larger than we can track, use the greatest lower bound instead.
          index > maxPreciseIndex() and
          result = maxLowerBound()
        }

        final private class FinalContentSet = ContentSet;

        /**
         * A singleton content for array elements at a known index, or unknown index.
         *
         * This can be used to generate a set of read and store edges that copy parts
         * of an array to another value. For such purposes, it is best to only rely on
         * singleton (exact) content sets to avoid precision loss.
         *
         * ```codeql
         * exists(Array::ExactContent content |
         *   node1 = ... and
         *   step.read() = content and
         *   node2 = ...
         *   or
         *   node1 = ... and
         *   step.store() = content.shiftUpBy(1) and
         *   node2 = ...
         * )
         * ```
         */
        class ExactContent extends FinalContentSet {
          ExactContent() {
            exists(this.asSingleton().asArrayIndex(kind())) or
            this.asSingleton().isUnknownContainerSlot(kind())
          }

          /** Increase the index by the given value, if it is a known index. */
          bindingset[index]
          ContentSet shiftUpBy(int index) {
            result = elementAt(this.asSingleton().asArrayIndex(kind()) + index)
            or
            this.asSingleton().isUnknownContainerSlot(kind()) and result = this
          }
        }
      }

      /** Generates a module with accessors for the content sets related to the given map-like kind. */
      module MapContentAccessor<IndexedContainerKindSig Kind> {
        private Kind kind() { any() }

        /** One of the keys in a key-value pair stored in a map. */
        pragma[nomagic]
        ContentSet key() { result.asSingleton().isContainerKey(kind()) }

        /** One of the values from a key-value pair stored in a map. */
        pragma[nomagic]
        ContentSet value() { result.isAnyContainerSlot(kind()) }

        pragma[nomagic]
        private ContentSet valueAtExact(Constant key) {
          result.asSingleton().asContainerSlot(kind()) = key
        }

        /**
         * The value associated with `key` in map.
         *
         * If `key` is not one of the keys that are tracked precisely, this will return
         * the same as `value()`.
         */
        bindingset[key]
        ContentSet valueAt(Constant key) {
          result = valueAtExact(key)
          or
          not exists(valueAtExact(key)) and
          result = value()
        }
      }

      signature module UnifiedDataFlowSig3 {
        class TransformBase;
      }

      module MakeUnifiedDataFlow3<UnifiedDataFlowSig3 D3> {
        final private class FinalTransformBase = TransformBase;

        class Transform extends FinalTransformBase {
          abstract string toString();

          abstract predicate step(string node1, DataFlowBuilder::Step step, string node2);
        }

        module StandardTransforms {
          module ShiftArrayContent<IndexedContainerKindSig Kind> {
            predicate step(int amount, string node1, DataFlowBuilder::Step step, string node2) {
              amount = 0 and
              node1 = "input" and
              (step.withContent(ArrayContentAccessor<Kind>::anyElement()) or step.taint()) and
              node2 = "output"
              or
              amount = [-10 .. 10] and
              amount != 0 and
              exists(ArrayContentAccessor<Kind>::ExactContent c |
                node1 = "input" and
                (
                  step.read(c)
                  or
                  c.asSingleton().isUnknownContainerSlot(any(Kind k)) and
                  step.taint()
                ) and
                node2 = "element " + c
                or
                node1 = "element " + c and
                step.store(c.shiftUpBy(amount)) and
                node2 = "output"
              )
            }
          }
        }

        private import D3

        private newtype TStep =
          TValueStep() or
          TCopyStep() or
          TTaintStep() or
          TReadStep(ContentSet contents) or
          TStoreStep(ContentSet contents) or
          TWithContentStep(ContentSet contents) or
          TWithoutContentStep(ContentSet contents) or
          TTransformStep(Transform transform) or
          TStoreBaseObject() or
          TInstantiateStep() or
          TStoreAsGetterStep(ContentSet contents) or
          TStoreAsSetterStep(ContentSet contents)

        cached
        private newtype TDataFlowNode =
          TUnknown() or
          TValueNode(AstNode node) { hasCompletionValue(node) } or
          TIncomingValueNode(AstNode node) { hasIncomingValue(node) } or
          TInterceptedExceptionNode(AstNode tryBlock) { isInterceptingExceptions(tryBlock) } or
          TCallTargetNode(Call call) or
          TOutNode(Call call) or
          TExceptionalOutNode(Call call) or
          TArgumentObjectNode(Call call) or
          TReceiverArgumentNode(Call call) or
          TPostUpdatedReceiverArgumentNode(Call call) or
          TPostUpdatedArgumentObjectNode(Call call) or
          TDynamicArgumentObjectNode(Call call) or
          TParameterObjectNode(Callable callable) or
          TReceiverParameterNode(Callable callable) or
          TDynamicParameterObjectNode(Callable callable) or
          TCallableNode(Callable callable) or
          TCallableSelfReferenceNode(Callable callable) or
          TReturnNode(Callable callable) or
          TInnerReturnNode(Callable callable) or
          TExceptionalReturnNode(Callable callable) or
          TInnerExceptionalReturnNode(Callable callable) or
          TSyntheticNode(AstNode node, string tag) { synthesizeNode(node, tag, _) } or
          TPostUpdatedValueNode(AstNode node) { hasPostUpdatedValue(node, _) } or
          TNamespaceNode(NamespaceObject ns) or
          TVariableNode(LocalVariable v, Boolean isRead) or // used in builder stage, replaced with more precise variants below
          TVariableReadNode(LocalVariable v, BasicBlock bb, int i) {
            hasVariableReadAt(v, bb, i, _)
          } or
          TVariablePostUpdateNode(LocalVariable v, BasicBlock bb, int i) {
            hasVariableReadAt(v, bb, i, true)
          } or
          TVariableWriteNode(LocalVariable v, BasicBlock bb, int i) { hasVariableWriteAt(v, bb, i) } or
          TDerivedPostUpdateNode(DataFlowNode1 pre) { needsDerivedPostUpdateNode(pre) } or
          TClosureExprNode(Callable callable, BasicBlock bb, int i) {
            dataflowNodeHasSuccessorCfgNode(TCallableNode(callable), bb, i)
          } or
          TLocalSsaNode(LocalSsaDataFlow::SsaNode node) or
          TTransformStepNode(TBuilderNode node, string nodeName) {
            exists(Transform t |
              dataflowStep1(_, TTransformStep(t), node) and
              t.step(_, _, nodeName) and
              not nodeName = ["input", "output"]
            )
          } or
          TWithContentHelper(TDataFlowNode3 node, ContentSet contents) {
            dataflowStep3(_, TWithContentStep(contents), node)
          } or
          TWithoutContentHelper(TDataFlowNode3 node, ContentSet contents) {
            dataflowStep3(_, TWithoutContentStep(contents), node)
          } or
          TCaptureSsaNode(CaptureSsa::SynthesizedCaptureNode node)

        predicate hasUniquePredecessor(Transform t, string nodeName) {
          nodeName != "output" and // the output node is merged with an existing node, which might have other predecessors
          strictcount(string n, TStep step | t.step(n, step, nodeName)) = 1
        }

        cached
        private predicate dataflowStep1(
          DataFlowBuilder::Node node1, DataFlowBuilder::Step step, DataFlowBuilder::Node node2
        ) {
          any(DataFlowBuilder::DataFlowSteps s).step(node1, step, node2)
        }

        cached // TODO: only cache while we rely on the expensive toString/getLocation predicates
        private class TBuilderNode =
          TUnknown or TValueNode or TIncomingValueNode or TInterceptedExceptionNode or
              TCallTargetNode or TOutNode or TExceptionalOutNode or TArgumentObjectNode or
              TReceiverArgumentNode or TPostUpdatedReceiverArgumentNode or TReceiverParameterNode or
              TPostUpdatedArgumentObjectNode or TParameterObjectNode or TCallableNode or
              TCallableSelfReferenceNode or TReturnNode or TInnerReturnNode or
              TExceptionalReturnNode or TInnerExceptionalReturnNode or TSyntheticNode or
              TPostUpdatedValueNode or TVariableNode or TNamespaceNode;

        private class BuilderNode extends TBuilderNode {
          pragma[nomagic]
          predicate isValueOf(AstNode node) { this = TValueNode(node) }

          pragma[nomagic]
          predicate isIncomingValue(AstNode node) { this = TIncomingValueNode(node) }

          /**
           * Holds if this is the post-update node for `node`, representing the new state of its returned value
           * after a mutation.
           *
           * This should generally be used when `node` appears in a context where its result is mutated by a store after `node` has completed.
           *
           * For example, for an assignment `obj.f = E`, there should be a store step from `E` to the post-update node of `obj`.
           */
          pragma[nomagic]
          predicate isPostUpdatedValue(AstNode node) { this = TPostUpdatedValueNode(node) }

          pragma[nomagic]
          predicate isNamespaceObject(NamespaceObject object) { this = TNamespaceNode(object) }

          /**
           * Holds if this represents the exception thrown inside `tryBlock`.
           *
           * Only has a result for AST nodes where `isInterceptingExceptions` holds.
           */
          pragma[nomagic]
          predicate isInterceptedException(AstNode tryBlock) {
            this = TInterceptedExceptionNode(tryBlock)
          }

          pragma[nomagic]
          predicate isArgumentObject(Call call) { this = TArgumentObjectNode(call) }

          pragma[nomagic]
          predicate isReceiverArgument(Call call) { this = TReceiverArgumentNode(call) }

          pragma[nomagic]
          predicate isPostUpdatedReceiverArgument(Call call) {
            this = TPostUpdatedReceiverArgumentNode(call)
          }

          pragma[nomagic]
          predicate isPostUpdatedArgumentObject(Call call) {
            this = TPostUpdatedArgumentObjectNode(call)
          }

          pragma[nomagic]
          predicate isParameterObject(Callable callable) { this = TParameterObjectNode(callable) }

          pragma[nomagic]
          predicate isReceiverParameter(Callable callable) {
            this = TReceiverParameterNode(callable)
          }

          pragma[nomagic]
          predicate isCallTarget(Call call) { this = TCallTargetNode(call) }

          pragma[nomagic]
          predicate isReturnValueFromCall(Call call) { this = TOutNode(call) }

          pragma[nomagic]
          predicate isExceptionThrownFromCall(Call call) { this = TExceptionalOutNode(call) }

          /**
           * Holds for the node representing values that callers of this callable will see being returned from the call.
           *
           * This is also known as the "outer" return node.
           *
           * The "inner" return node captures values that are explicitly returned within the body, whereas the "outer" return value captures
           * the value that callers will actually see. Usually they are the same, but not always.
           *
           * For callables that implicitly transform their return values, such as JS `async` functions, the transformation
           * should happen as a step from the inner to the outer return value. If no explicit step is added from the
           * inner return value, a default value step is added from the inner to the outer return node.
           */
          pragma[nomagic]
          predicate isReturnValue(Callable callable) { this = TReturnNode(callable) }

          /**
           * Holds for the node representing values that are explicitly returned from the body of the callable,
           * e.g via a return statement.
           *
           * The "inner" return node captures values that are explicitly returned within the body, whereas the "outer" return value captures
           * the value that callers will actually see. Usually they are the same, but not always.
           *
           * For callables that implicitly transform their return values, such as JS `async` functions, the transformation
           * should happen as a step from the inner to the outer return value. If no explicit step is added from the
           * inner return value, a default value step is added from the inner to the outer return node.
           */
          pragma[nomagic]
          predicate isInnerReturnValue(Callable callable) { this = TInnerReturnNode(callable) }

          /**
           * Holds for the node representing exceptions that callers of this callable will see being thrown from the call.
           *
           * This is also known as the "outer" exceptional return node.
           *
           * The "inner" exceptional return node captures values that are explicitly thrown or propagated by code within the body,
           * whereas the "outer" node captures the value that callers will actually see being thrown. Usually they are the same, but not always.
           *
           * For callables that implicitly catches and transforms thrown values, such as JS `async` functions, the transformation
           * should happen as a step from the inner exceptional return value to one of the other return nodes. If no explicit step is added from the
           * inner exceptional return value, a default value step is added from the inner to the outer exceptional return node.
           */
          pragma[nomagic]
          predicate isExceptionalReturnValue(Callable callable) {
            this = TExceptionalReturnNode(callable)
          }

          /**
           * Holds for the node representing exceptions that are thrown or propagated from the body of the callable,
           * for example, via a throw statement, or via a call not wrapped in a try/catch.
           *
           * The "inner" exceptional return node captures values that are explicitly thrown or propagated by calls within the body,
           * whereas the "outer" node captures the value that callers will actually see being thrown.  Usually they are the same, but not always.
           *
           * For callables that implicitly catches and transforms thrown values, such as JS `async` functions, the transformation
           * should happen as a step from the inner exceptional return value to one of the other return nodes. If no explicit step is added from the
           * inner exceptional return value, a default value step is added from the inner to the outer exceptional return node.
           */
          pragma[nomagic]
          predicate isInnerExceptionalReturnValue(Callable callable) {
            this = TInnerExceptionalReturnNode(callable)
          }

          /** Holds if this is the node representing the given callable. */
          pragma[nomagic]
          predicate isCallable(Callable callable) { this = TCallableNode(callable) }

          /** Holds if this is the special parameter by which a callable referes to itself. */
          pragma[nomagic]
          predicate isCallableSelfReferenceParameter(Callable callable) {
            this = TCallableSelfReferenceNode(callable)
          }

          /**
           * Holds if this node represents read of the variable `v`.
           *
           * If this node is used as the target of a store step, it means the current value of `v` is read and mutated by
           * the store. It should not be used as the target of other kinds of steps.
           *
           * To ensure the read can be placed properly in the CFG, this should be connected to nodes that have a known associated CFG node.
           * These are:
           * - Value nodes (`.isValueOf`)
           * - Incoming-value nodes (`.isIncomingValue`)
           * - Parameter objects (`.isParameterObject`)
           * - Return nodes (`.isReturNode` or `.isInnerReturnNode`)
           * - Exceptional return nodes (`.isExceptionalReturNode` or `.isInnerExceptionalReturnNode`)
           */
          pragma[nomagic]
          predicate isVariableRead(LocalVariable v) { this = TVariableNode(v, true) }

          /**
           * Holds if this node represents a value being assigned to the variable `v`.
           *
           * This should only be used as the target of a flow step, never as the source node.
           */
          pragma[nomagic]
          predicate isVariableWrite(LocalVariable v) { this = TVariableNode(v, false) }

          /** Holds if the incoming value is unknown or, if used as a destination node, indicate that the value is used somehow but we don't model precisely how. */
          pragma[nomagic]
          predicate isUnknown() { this = TUnknown() }

          predicate isSyntheticNode(AstNode node, string tag) { this = TSyntheticNode(node, tag) }

          string toString() {
            exists(AstNode node | this.isValueOf(node) | result = "[value] " + node.toString())
            or
            exists(AstNode node | this.isIncomingValue(node) | result = "[incoming] " + node)
            or
            exists(AstNode node | this.isPostUpdatedValue(node) | result = "[post-updated] " + node)
            or
            exists(NamespaceObject object | this.isNamespaceObject(object) |
              result = "[namespace] " + object.toString()
            )
            or
            exists(AstNode tryBlock | this.isInterceptedException(tryBlock) |
              result = "[intercepted exception] " + tryBlock
            )
            or
            exists(Call call | this.isArgumentObject(call) | result = "[argument object] " + call)
            or
            exists(Call call | this.isReceiverArgument(call) |
              result = "[receiver argument] " + call
            )
            or
            exists(Call call | this.isPostUpdatedReceiverArgument(call) |
              result = "[post receiver argument] " + call
            )
            or
            exists(Call call | this.isPostUpdatedArgumentObject(call) |
              result = "[post argument object] " + call
            )
            or
            exists(Callable callable | this.isParameterObject(callable) |
              result = "[parameter object] " + callable
            )
            or
            exists(Callable callable | this.isReceiverParameter(callable) |
              result = "[receiver parameter] " + callable
            )
            or
            exists(Call call | this.isCallTarget(call) | result = "[call target] " + call)
            or
            exists(Call call | this.isReturnValueFromCall(call) | result = "[out] " + call)
            or
            exists(Call call | this.isExceptionThrownFromCall(call) |
              result = "[exceptional out] " + call
            )
            or
            exists(Callable callable | this.isCallable(callable) |
              result = "[callable] " + callable
            )
            or
            exists(Callable callable | this.isCallableSelfReferenceParameter(callable) |
              result = "[self-reference] " + callable
            )
            or
            exists(Callable callable | this.isReturnValue(callable) |
              result = "[return] " + callable
            )
            or
            exists(Callable callable | this.isInnerReturnValue(callable) |
              result = "[inner return] " + callable
            )
            or
            exists(Callable callable | this.isExceptionalReturnValue(callable) |
              result = "[exceptional return] " + callable
            )
            or
            exists(Callable callable | this.isInnerExceptionalReturnValue(callable) |
              result = "[inner exceptional return] " + callable
            )
            or
            exists(AstNode node, string tag | this.isSyntheticNode(node, tag) |
              result = "[synthetic " + tag + "] " + node
            )
            or
            exists(LocalVariable v | this.isVariableRead(v) |
              result = "[variable-read-builder] " + v.toString()
            )
            or
            exists(LocalVariable v | this.isVariableWrite(v) |
              result = "[variable-write-builder] " + v.toString()
            )
            or
            this.isUnknown() and result = "[unknown]"
          }

          Location getLocation() {
            exists(AstNode node | this.isValueOf(node) | result = node.getLocation())
            or
            exists(AstNode node | this.isIncomingValue(node) | result = node.getLocation())
            or
            exists(AstNode node | this.isPostUpdatedValue(node) | result = node.getLocation())
            or
            exists(NamespaceObject object | this.isNamespaceObject(object) |
              result = object.getLocation()
            )
            or
            exists(AstNode tryBlock | this.isInterceptedException(tryBlock) |
              result = tryBlock.getLocation()
            )
            or
            exists(Call call | this.isArgumentObject(call) | result = call.getLocation())
            or
            exists(Call call | this.isReceiverArgument(call) | result = call.getLocation())
            or
            exists(Call call | this.isPostUpdatedReceiverArgument(call) |
              result = call.getLocation()
            )
            or
            exists(Call call | this.isPostUpdatedArgumentObject(call) | result = call.getLocation())
            or
            exists(Callable callable | this.isParameterObject(callable) |
              result = callable.getLocation()
            )
            or
            exists(Callable callable | this.isReceiverParameter(callable) |
              result = callable.getLocation()
            )
            or
            exists(Callable callable | this.isCallableSelfReferenceParameter(callable) |
              result = callable.getLocation()
            )
            or
            exists(Call call | this.isCallTarget(call) | result = call.getLocation())
            or
            exists(Call call | this.isReturnValueFromCall(call) | result = call.getLocation())
            or
            exists(Call call | this.isExceptionThrownFromCall(call) | result = call.getLocation())
            or
            exists(Callable callable | this.isCallable(callable) | result = callable.getLocation())
            or
            exists(Callable callable | this.isReturnValue(callable) |
              result = callable.getLocation()
            )
            or
            exists(Callable callable | this.isExceptionalReturnValue(callable) |
              result = callable.getLocation()
            )
            or
            exists(Callable callable | this.isInnerReturnValue(callable) |
              result = callable.getLocation()
            )
            or
            exists(Callable callable | this.isInnerExceptionalReturnValue(callable) |
              result = callable.getLocation()
            )
            or
            exists(AstNode node, string tag | this.isSyntheticNode(node, tag) |
              result = node.getLocation()
            )
            or
            exists(LocalVariable v | this.isVariableRead(v) or this.isVariableWrite(v) |
              result = v.getLocation()
            )
          }
        }

        /** A type of data flow step. */
        class StepBase extends TStep {
          predicate receiverHint() { none() }

          pragma[nomagic]
          predicate value() { this = TValueStep() }

          /**
           * A step that acts as a value step, except it does not establish aliasing, so side-effects on the resulting
           * object will not affect the input object.
           */
          pragma[nomagic]
          predicate copy() { this = TCopyStep() }

          pragma[nomagic]
          predicate taint() { this = TTaintStep() }

          pragma[nomagic]
          predicate read(ContentSet contents) { this = TReadStep(contents) }

          pragma[nomagic]
          predicate store(ContentSet contents) { this = TStoreStep(contents) }

          pragma[nomagic]
          predicate withContent(ContentSet contents) { this = TWithContentStep(contents) }

          pragma[nomagic]
          predicate withoutContent(ContentSet contents) { this = TWithoutContentStep(contents) }

          pragma[nomagic]
          predicate storeAsGetter(ContentSet contents) { this = TStoreAsGetterStep(contents) }

          pragma[nomagic]
          predicate storeAsSetter(ContentSet contents) { this = TStoreAsSetterStep(contents) }

          pragma[nomagic]
          predicate transform(Transform t) { this = TTransformStep(t) }

          /**
           * Stores an object as the base object of another object.
           *
           * That is, for a step `node1 -> node2`, the value of `node1` becomes the base object of
           * the value in `node2`. In other words, `node2` will inherit the contents of `node1`.
           *
           * Currently this does not affect `ConfigSig`-style data flow, but can affect the call graph.
           */
          pragma[nomagic]
          predicate storeBaseObject() { this = TStoreBaseObject() }

          pragma[nomagic]
          predicate instantiate() { this = TInstantiateStep() }

          string toString() {
            this.value() and result = "value"
            or
            this.copy() and result = "copy"
            or
            this.taint() and result = "taint"
            or
            exists(ContentSet contents |
              this.read(contents) and result = "read(" + contents.toString() + ")"
              or
              this.store(contents) and result = "store(" + contents.toString() + ")"
              or
              this.withContent(contents) and result = "withContent(" + contents.toString() + ")"
              or
              this.withoutContent(contents) and
              result = "withoutContent(" + contents.toString() + ")"
              or
              this.storeAsGetter(contents) and result = "storeAsGetter(" + contents.toString() + ")"
              or
              this.storeAsSetter(contents) and result = "storeAsSetter(" + contents.toString() + ")"
            )
            or
            exists(Transform t | this.transform(t) and result = "transform(" + t + ")")
            or
            this.storeBaseObject() and result = "storeBaseObject"
            or
            this.instantiate() and result = "instantiate"
          }
        }

        //
        // Additional data flow nodes are materialised based on the step relation.
        //
        private class TDataFlowNode1 =
          TBuilderNode or TVariableReadNode or TVariablePostUpdateNode or TVariableWriteNode or
              TDynamicArgumentObjectNode or TDynamicParameterObjectNode or TClosureExprNode;

        private class TDataFlowNode2 = TDataFlowNode1 or TLocalSsaNode or TDerivedPostUpdateNode;

        private class TDataFlowNode3 = TDataFlowNode2 or TTransformStepNode;

        private class TDataFlowNode4 =
          TDataFlowNode3 or TWithContentHelper or TWithoutContentHelper;

        private class TDataFlowNode5 = TDataFlowNode4 or TCaptureSsaNode;

        /**
         * Data flow nodes materialised for stage 1.
         *
         * The `toString` and `getLocation` in this class are for supporting quick-eval only, and should
         * not be materialised at runtime.
         */
        private class DataFlowNode1 extends TDataFlowNode1 {
          string toString() {
            result = this.(BuilderNode).toString()
            or
            exists(LocalVariable v |
              this = TVariableReadNode(v, _, _) and
              result = "[variable read] " + v
              or
              this = TVariableWriteNode(v, _, _) and
              result = "[variable write] " + v
              or
              this = TVariablePostUpdateNode(v, _, _) and
              result = "[variable post-update] " + v
            )
            or
            exists(Call call |
              this = TDynamicArgumentObjectNode(call) and
              result = "[dynamic argument object] " + call
            )
            or
            exists(Callable callable |
              this = TDynamicParameterObjectNode(callable) and
              result = "[dynamic parameter object] " + callable
            )
            or
            exists(Callable callable, BasicBlock bb, int i |
              this = TClosureExprNode(callable, bb, i) and
              result = "[closure] " + callable.toString()
            )
          }

          Location getLocation() {
            result = this.(BuilderNode).getLocation()
            or
            exists(LocalVariable v, BasicBlock bb, int i |
              this = TVariableReadNode(v, bb, i) or
              this = TVariableWriteNode(v, bb, i) or
              this = TVariablePostUpdateNode(v, bb, i)
            |
              result = bb.getNode(i).getLocation()
              or
              not exists(bb.getNode(i)) and result = v.getLocation()
            )
            or
            exists(Call call |
              this = TDynamicArgumentObjectNode(call) and
              result = call.getLocation()
            )
            or
            exists(Callable callable |
              this = TDynamicParameterObjectNode(callable) and
              result = callable.getLocation()
            )
            or
            exists(Callable callable, BasicBlock bb, int i |
              this = TClosureExprNode(callable, bb, i)
            |
              result = bb.getNode(i).getLocation()
              or
              not exists(bb.getNode(i)) and
              result = callable.getLocation()
            )
          }
        }

        /**
         * Data flow nodes materialised for stage 2.
         *
         * The `toString` and `getLocation` in this class are for supporting quick-eval only, and should
         * not be materialised at runtime.
         */
        private class DataFlowNode2 extends TDataFlowNode2 {
          string toString() {
            result = this.(DataFlowNode1).toString()
            or
            exists(LocalSsaDataFlow::Node ssaNode |
              this = TLocalSsaNode(ssaNode) and
              result = "[ssa] " + ssaNode.toString()
            )
            or
            exists(DataFlowNode1 pre |
              this = TDerivedPostUpdateNode(pre) and
              result = "[post] " + pre.toString()
            )
          }

          Location getLocation() {
            result = this.(DataFlowNode1).getLocation()
            or
            exists(LocalSsaDataFlow::Node ssaNode |
              this = TLocalSsaNode(ssaNode) and
              result = ssaNode.getLocation()
            )
            or
            exists(DataFlowNode1 pre |
              this = TDerivedPostUpdateNode(pre) and
              result = pre.getLocation()
            )
          }
        }

        /**
         * Data flow nodes materialised for stage 3.
         *
         * The `toString` and `getLocation` in this class are for supporting quick-eval only, and should
         * not be materialised at runtime.
         */
        private class DataFlowNode3 extends TDataFlowNode3 {
          string toString() {
            result = this.(DataFlowNode2).toString()
            or
            exists(BuilderNode node, string nodeName |
              this = TTransformStepNode(node, nodeName) and
              result = "[transform " + nodeName + "] " + node.toString()
            )
          }

          Location getLocation() {
            result = this.(DataFlowNode2).getLocation()
            or
            exists(BuilderNode node, string nodeName |
              this = TTransformStepNode(node, nodeName) and
              result = node.getLocation()
            )
          }
        }

        /**
         * Data flow nodes materialised for stage 4.
         *
         * The `toString` and `getLocation` in this class are for supporting quick-eval only, and should
         * not be materialised at runtime.
         */
        private class DataFlowNode4 extends TDataFlowNode4 {
          string toString() {
            result = this.(DataFlowNode3).toString()
            or
            exists(DataFlowNode3 node, ContentSet contents |
              this = TWithContentHelper(node, contents) and
              result = "[with-content] " + node.toString()
              or
              this = TWithoutContentHelper(node, contents) and
              result = "[without-content] " + node.toString()
            )
          }

          Location getLocation() {
            result = this.(DataFlowNode3).getLocation()
            or
            exists(DataFlowNode3 node, ContentSet contents |
              this = TWithContentHelper(node, contents) and
              result = node.getLocation()
              or
              this = TWithoutContentHelper(node, contents) and
              result = node.getLocation()
            )
          }
        }

        /**
         * Data flow nodes materialised for stage 5.
         *
         * The `toString` and `getLocation` in this class are for supporting quick-eval only, and should
         * not be materialised at runtime.
         */
        private class DataFlowNode5 extends TDataFlowNode5 {
          string toString() {
            result = this.(DataFlowNode4).toString()
            or
            exists(CaptureSsa::SynthesizedCaptureNode node |
              this = TCaptureSsaNode(node) and
              result = "[capture] " + node.toString()
            )
          }

          Location getLocation() {
            result = this.(DataFlowNode4).getLocation()
            or
            exists(CaptureSsa::SynthesizedCaptureNode node |
              this = TCaptureSsaNode(node) and
              result = node.getLocation()
            )
          }
        }

        /** Provides classes for constructing data flow steps. */
        module DataFlowBuilder {
          class Step extends StepBase {
            // Step() { any() } // Help catch some bugs in pracitce
          }

          private Node getExceptionTargetFromContext(AstNode node) {
            isInterceptingExceptions(node) and
            result.isInterceptedException(node)
            or
            node instanceof Callable and
            result.isInnerExceptionalReturnValue(node)
            or
            not node instanceof Callable and
            not isInterceptingExceptions(node) and
            result = getExceptionTargetFromContext(node.getParent())
          }

          class Node extends BuilderNode {
            // // Use a binding set to quickly catch bugs in the step relation
            // bindingset[this]
            // Node() { any() }
            /**
             * Holds if this node is where exceptions thrown at `node` should propagate.
             *
             * This looks for the nearest enclosing AST which for which `isInterceptingExceptions` holds
             * and gets the data flow node representing the intercepted exception. If no such node exists,
             * this gets the inner exceptional return node of the enclosing callable.
             */
            predicate isExceptionTargetFromContext(AstNode node) {
              this = getExceptionTargetFromContext(node)
            }
          }

          // Note: the 'step' predicate cannot be provided via a module parameter, since its
          // signature depends on 'Node' and the underlying newtype for 'Node' must reference the 'step' predicate.
          class DataFlowSteps extends Unit {
            pragma[inline]
            abstract predicate step(Node node1, Step step, Node node2);
          }
        }

        final private class FinalLocalVariable = LocalVariable;

        pragma[nomagic]
        private Cfg::EntryBasicBlock getEntryBlock(Callable scope) {
          getCallableFromBasicBlock(result) = scope
        }

        cached
        private predicate dataflowNodeHasOwnCfgNode(BuilderNode node, BasicBlock bb, int i) {
          exists(AstNode astNode |
            node.isValueOf(astNode) and hasCompletionValue(astNode, bb.getNode(i))
            or
            node.isIncomingValue(astNode) and hasIncomingValue(astNode, bb.getNode(i))
            or
            node.isPostUpdatedValue(astNode) and hasPostUpdatedValue(astNode, bb.getNode(i))
          )
          or
          exists(Callable callable |
            node.isParameterObject(callable)
            or
            node.isReceiverParameter(callable)
            or
            node.isCallableSelfReferenceParameter(callable)
            or
            exists(NamespaceObject ns |
              node.isNamespaceObject(ns) and
              callable = ns.getEnclosingCallable()
            )
          |
            bb = getEntryBlock(callable) and
            i = -1
            // TODO: do we need return nodes be associated with the exit block?
          )
          or
          exists(Call call |
            node.isArgumentObject(call)
            or
            node.isPostUpdatedArgumentObject(call)
            or
            node.isReceiverArgument(call)
            or
            node.isPostUpdatedReceiverArgument(call)
            or
            node.isCallTarget(call)
            or
            node.isReturnValueFromCall(call)
            or
            node.isExceptionThrownFromCall(call)
          |
            bb.getNode(i) = getCfgNodeFromCall(call)
          )
          or
          exists(AstNode astNode, string tag |
            synthesizeNode(astNode, tag, bb.getNode(i)) and
            node.isSyntheticNode(astNode, tag)
          )
        }

        private predicate dataflowNodeHasAmbiguousCfg(BuilderNode node) {
          node instanceof TVariableNode
          or
          node instanceof TInterceptedExceptionNode
          or
          node instanceof TExceptionalReturnNode
          or
          node instanceof TInnerExceptionalReturnNode
          or
          node instanceof TReturnNode // TODO: return nodes should use the exit node
          or
          node instanceof TInnerReturnNode
        }

        private predicate dataflowNodeHasPredecessorCfgNode(BuilderNode node, BasicBlock bb, int i) {
          dataflowNodeHasOwnCfgNode(node, bb, i)
          or
          not dataflowNodeHasOwnCfgNode(node, _, _) and
          not dataflowNodeHasAmbiguousCfg(node) and
          exists(BuilderNode pred |
            dataflowStep1(pred, _, node) and
            dataflowNodeHasPredecessorCfgNode(pred, bb, i)
          )
        }

        private predicate dataflowNodeHasSuccessorCfgNode(BuilderNode node, BasicBlock bb, int i) {
          dataflowNodeHasOwnCfgNode(node, bb, i)
          or
          not dataflowNodeHasOwnCfgNode(node, _, _) and
          not dataflowNodeHasAmbiguousCfg(node) and
          exists(BuilderNode succ |
            dataflowStep1(node, _, succ) and
            dataflowNodeHasSuccessorCfgNode(succ, bb, i)
          )
        }

        private predicate hasVariableReadAt(
          LocalVariable v, BasicBlock bb, int i, boolean needsPostUpdate
        ) {
          exists(BuilderNode node |
            dataflowStep1(TVariableNode(v, true), _, node) and
            dataflowNodeHasSuccessorCfgNode(node, bb, i) and
            needsPostUpdate = false
            or
            dataflowStep1(node, _, TVariableNode(v, true)) and
            dataflowNodeHasPredecessorCfgNode(node, bb, i) and
            needsPostUpdate = true
          )
        }

        private predicate hasVariableWriteAt(LocalVariable v, BasicBlock bb, int i) {
          exists(BuilderNode node |
            dataflowStep1(node, _, TVariableNode(v, false)) and
            dataflowNodeHasPredecessorCfgNode(node, bb, i)
          )
          or
          not definitelyInitialized(v) and
          bb = getEntryBlock(v.getDeclaringCallable()) and
          i = -2 // put implicit initialization at index -2, before parameters are assigned
        }

        /** Gets the data flow node representing the value of `v` before its initialization. */
        private DataFlowNode1 getVariablePreInitializer(LocalVariable v) {
          result = TVariableWriteNode(v, getEntryBlock(v.getDeclaringCallable()), -2)
        }

        bindingset[node]
        pragma[inline_late]
        private predicate isVariableNode(BuilderNode node) { node instanceof TVariableNode }

        private predicate dataflowStep1A(DataFlowNode1 node1, StepBase step, DataFlowNode1 node2) {
          dataflowStep1(node1, step, node2) and
          not isVariableNode(node1) and
          not isVariableNode(node2)
          or
          exists(LocalVariable v, BasicBlock bb, int i |
            dataflowStep1(TVariableNode(v, true), step, node2) and
            dataflowNodeHasSuccessorCfgNode(node2, bb, i) and
            node1 = TVariableReadNode(v, bb, i)
            or
            dataflowStep1(node1, step, TVariableNode(v, false)) and
            dataflowNodeHasPredecessorCfgNode(node1, bb, i) and
            node2 = TVariableWriteNode(v, bb, i)
            or
            dataflowStep1(node1, step, TVariableNode(v, true)) and
            dataflowNodeHasPredecessorCfgNode(node1, bb, i) and
            node2 = TVariablePostUpdateNode(v, bb, i)
          )
          or
          exists(Callable callable, BasicBlock bb, int i |
            dataflowStep1(TCallableNode(callable), step, node2) and
            dataflowNodeHasSuccessorCfgNode(node2, bb, i) and
            node1 = TClosureExprNode(callable, bb, i)
          )
        }

        private StepBase valueOrReadStep() {
          result instanceof TValueStep or result instanceof TReadStep
        }

        pragma[nomagic]
        private DataFlowNode1 getPostUpdateNode0(DataFlowNode1 pre) {
          exists(AstNode astNode |
            pre = TValueNode(astNode) and
            result = TPostUpdatedValueNode(astNode)
          )
          or
          exists(Call call |
            pre = TReceiverArgumentNode(call) and
            result = TPostUpdatedReceiverArgumentNode(call)
          )
        }

        private predicate needsDerivedPostUpdateNode1(DataFlowNode1 node) {
          exists(DataFlowNode1 target |
            dataflowStep1A(node, valueOrReadStep(), target) and
            exists(getPostUpdateNode0(target))
            // example: TVariableReadNode flows to the `x` in `x.f = E`. `x` has a post update, we need a derived post-update for TVariableReadNode as well.
          )
          or
          dataflowStep1A(node, any(TStoreStep s), any(TArgumentObjectNode arg))
          or
          node instanceof TCallTargetNode // for captured variables, we need to post-update the call target
          or
          exists(DataFlowNode1 prev |
            needsDerivedPostUpdateNode(prev) and
            dataflowStep1A(node, valueOrReadStep(), prev)
            // Example: `x` in `x.f.g = E` where `x` has a read step to `x.f` which has a post-updated value.
          )
        }

        private predicate needsDerivedPostUpdateNode(DataFlowNode1 node) {
          needsDerivedPostUpdateNode1(node) and
          not exists(getPostUpdateNode0(node))
        }

        pragma[nomagic]
        private DataFlowNode2 getPostUpdateNode1(DataFlowNode2 pre) {
          result = getPostUpdateNode0(pre)
          or
          exists(LocalVariable v, BasicBlock bb, int i |
            pre = TVariableReadNode(v, bb, i) and
            result = TVariablePostUpdateNode(v, bb, i)
          )
          or
          result = TDerivedPostUpdateNode(pre)
        }

        /**
         * Instantiation of SSA for non-captured variables.
         */
        private module LocalSsaConfig implements Ssa::InputSig<Location, BasicBlock> {
          class SourceVariable extends FinalLocalVariable {
            SourceVariable() { not this.isCaptured() }
          }

          predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
            certain = true and
            hasVariableWriteAt(v, bb, i)
          }

          predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
            certain = true and
            hasVariableReadAt(v, bb, i, _)
          }
        }

        private module LocalSsa = Ssa::Make<Location, Cfg, LocalSsaConfig>;

        private module LocalSsaDataFlowConfig implements LocalSsa::DataFlowIntegrationInputSig {
          class Expr extends DataFlowNode1, TVariableReadNode {
            predicate hasCfgNode(BasicBlock bb, int i) { this = TVariableReadNode(_, bb, i) }
          }

          class GuardValue = D1::GuardValue;

          class Guard = D1::Guard;

          predicate guardDirectlyControlsBlock = D1::guardDirectlyControlsBlock/3;

          predicate includeWriteDefsInFlowStep() { none() } // not needed as we have lvalue nodes already
        }

        private module LocalSsaDataFlow = LocalSsa::DataFlowIntegration<LocalSsaDataFlowConfig>;

        pragma[nomagic]
        private DataFlowNode2 getNodeFromLocalSsa(LocalSsaDataFlow::Node node) {
          result = TLocalSsaNode(node) // note: only holds for the SsaNode subclass
          or
          result = node.(LocalSsaDataFlow::ExprNode).getExpr()
          or
          result = getPostUpdateNode1(node.(LocalSsaDataFlow::ExprPostUpdateNode).getExpr())
          or
          exists(LocalVariable v, BasicBlock bb, int i |
            node.(LocalSsaDataFlow::WriteDefSourceNode).getDefinition().definesAt(v, bb, i) and
            result = TVariableWriteNode(v, bb, i)
          )
        }

        /**
         * Holds if `pre`/`post` is a post-update pair, for which the pre-existing value of `contents`
         * coming from `pre` should be blocked, so we only propagate the value coming from `post`.
         */
        private predicate clearContentAfterPostUpdate(
          DataFlowNode2 pre, DataFlowNode2 post, ContentSet contents
        ) {
          contentSetSupportsStrongUpdate(contents) and
          dataflowStep1A(_, TStoreStep(contents), post) and
          post = getPostUpdateNode1(pre)
          or
          exists(DataFlowNode2 pre1, DataFlowNode2 post1 |
            clearContentAfterPostUpdate(pre1, post1, contents) and
            dataflowStep1A(pre, TValueStep(), pre1) and
            post = getPostUpdateNode1(pre)
          )
        }

        pragma[nomagic]
        private predicate dataflowStep2(
          DataFlowNode2 node1, DataFlowBuilder::Step step, DataFlowNode2 node2
        ) {
          dataflowStep1A(node1, step, node2)
          or
          exists(
            LocalSsaDataFlow::Node ssaNode1, LocalSsaDataFlow::Node ssaNode2, boolean isUseStep
          |
            LocalSsaDataFlow::localFlowStep(_, ssaNode1, ssaNode2, isUseStep) and
            node1 = getNodeFromLocalSsa(ssaNode1) and
            node2 = getNodeFromLocalSsa(ssaNode2) and
            (
              if isUseStep = true and clearContentAfterPostUpdate(node1, _, _)
              then
                step.withoutContent(any(ContentSet contents |
                    clearContentAfterPostUpdate(node1, _, contents)
                  ))
              else step.value()
            )
          )
          or
          exists(DataFlowNode1 value1, DataFlowNode1 value2 |
            // Add reverse value steps between post-update nodes.
            // For a value step v1 -> v2, add post(v2) -> post(v1).
            // Note that DataFlowImplCommon will handle this for read steps, so only handle value steps here.
            dataflowStep1A(value1, step, value2) and
            node1 = getPostUpdateNode1(value2) and
            node2 = getPostUpdateNode1(value1) and
            step.value()
          )
          or
          // Add default flow from inner return to actual return
          exists(Callable callable |
            node1 = TInnerReturnNode(callable) and
            step.value() and
            node2 = TReturnNode(callable)
            or
            node1 = TInnerExceptionalReturnNode(callable) and
            step.value() and
            node2 = TExceptionalReturnNode(callable)
          |
            not dataflowStep1(node1, _, _) // Suppress default flow if explicit flow is given
          )
        }

        private DataFlowNode3 getTransformNode(
          DataFlowNode2 node1, DataFlowNode2 node2, Transform transform, string nodeName
        ) {
          dataflowStep2(node1, TTransformStep(transform), node2) and
          (
            nodeName = "input" and result = node1
            or
            nodeName = "output" and result = node2
            or
            result = TTransformStepNode(node2, nodeName)
          )
        }

        private predicate dataflowStep3(DataFlowNode3 node1, StepBase step, DataFlowNode3 node2) {
          dataflowStep2(node1, step, node2) and
          not step instanceof TTransformStep
          or
          exists(BuilderNode input, Transform transform, BuilderNode output |
            dataflowStep2(input, TTransformStep(transform), output)
          |
            exists(string tmp1, string tmp2 |
              transform.step(tmp1, step, tmp2) and
              node1 = getTransformNode(input, output, transform, tmp1) and
              node2 = getTransformNode(input, output, transform, tmp2)
            )
          )
        }

        private predicate dataflowStep4(DataFlowNode4 node1, StepBase step, DataFlowNode4 node2) {
          dataflowStep3(node1, step, node2) and
          not step instanceof TWithContentStep and
          not step instanceof TWithoutContentStep
          or
          step.copy() and
          exists(ContentSet contents, DataFlowNode3 orig1, DataFlowNode3 orig2 |
            dataflowStep3(orig1, TWithContentStep(contents), orig2) and
            (
              node1 = orig1 and
              node2 = TWithContentHelper(orig2, contents)
              or
              node1 = TWithContentHelper(orig2, contents) and
              node2 = orig2
            )
            or
            dataflowStep3(orig1, TWithoutContentStep(contents), orig2) and
            (
              node1 = orig1 and
              node2 = TWithoutContentHelper(orig2, contents)
              or
              node1 = TWithoutContentHelper(orig2, contents) and
              node2 = orig2
            )
          )
        }

        final private class FinalCallable = Callable;

        private predicate approxCaptureStep(DataFlowNode4 node1, DataFlowNode4 node2) {
          // For captured variables, step from any write to any read. For non-captured variables we instead rely on local SSA flow paths.
          // To avoid N^2 edges we use the TVariableNode from the builder stage as a pivot connecting any write to any read.
          exists(VariableCaptureConfig::CapturedVariable v |
            node1 = TVariableWriteNode(v, _, _) and
            node2.(BuilderNode).isVariableRead(v)
            or
            node1.(BuilderNode).isVariableRead(v) and
            node2 = TVariableReadNode(v, _, _)
          )
        }

        cached
        private predicate valueStepApprox(DataFlowNode4 node1, DataFlowNode4 node2) {
          dataflowStep4(node1, TValueStep(), node2)
          or
          approxCaptureStep(node1, node2)
        }

        cached
        private DataFlowNode4 callableInitialNode(Callable callable) {
          result = TClosureExprNode(callable, _, _)
          or
          result = TCallableSelfReferenceNode(callable)
        }

        module VariableCaptureConfig implements VariableCapture::InputSig<Location, BasicBlock> {
          Callable basicBlockGetEnclosingCallable(BasicBlock bb) {
            result = getCallableFromBasicBlock(bb)
          }

          class CapturedVariable extends FinalLocalVariable {
            CapturedVariable() { this.isCaptured() }

            /** Gets the callable that defines this variable. */
            Callable getCallable() { result = this.getDeclaringCallable() }
          }

          class CapturedParameter extends CapturedVariable {
            CapturedParameter() { none() } // Not needed here, as parameters and local variable writes (lvalues) are separate nodes
          }

          class Expr extends DataFlowNode4 {
            predicate hasCfgNode(BasicBlock bb, int i) {
              this = TVariableReadNode(_, bb, i)
              or
              this = TClosureExprNode(_, bb, i)
            }
          }

          class VariableWrite extends DataFlowNode4, TVariableWriteNode {
            VariableWrite() { this = TVariableWriteNode(any(CapturedVariable v), _, _) }

            CapturedVariable getVariable() { this = TVariableWriteNode(result, _, _) }

            predicate hasCfgNode(BasicBlock bb, int i) { this = TVariableWriteNode(_, bb, i) }
          }

          class VariableRead extends Expr, TVariableReadNode {
            VariableRead() { this = TVariableReadNode(any(CapturedVariable v), _, _) }

            CapturedVariable getVariable() { this = TVariableReadNode(result, _, _) }
          }

          additional predicate callableHasAlias(Callable callable, DataFlowNode4 node) {
            valueStepApprox*(callableInitialNode(callable), node)
          }

          class ClosureExpr extends Expr, TClosureExprNode {
            predicate hasAliasedAccess(Expr f) {
              exists(Callable callable |
                this.hasBody(callable) and
                callableHasAlias(callable, f)
              )
              // TODO: check that `f` has a post-update node?
            }

            predicate hasBody(Callable callable) { this = TClosureExprNode(callable, _, _) }
          }

          class Callable extends FinalCallable {
            predicate isConstructor() {
              none() // TODO - not needed for JS
            }
          }
        }

        private module CaptureSsa = VariableCapture::Flow<Location, Cfg, VariableCaptureConfig>;

        private DataFlowNode5 getNodeFromCaptureSsa(CaptureSsa::ClosureNode node) {
          result = TCaptureSsaNode(node) // note: only holds for SynthesizedClosureNode subclass
          or
          result = node.(CaptureSsa::ExprNode).getExpr()
          or
          result = getPostUpdateNode1(node.(CaptureSsa::ExprPostUpdateNode).getExpr())
          or
          result = node.(CaptureSsa::VariableWriteSourceNode).getVariableWrite()
          or
          result = TCallableSelfReferenceNode(node.(CaptureSsa::ThisParameterNode).getCallable())
        }

        private predicate dataflowStep5(DataFlowNode5 node1, StepBase step, DataFlowNode5 node2) {
          dataflowStep4(node1, step, node2)
          or
          exists(CaptureSsa::ClosureNode closureNode1, CaptureSsa::ClosureNode closureNode2 |
            node1 = getNodeFromCaptureSsa(closureNode1) and
            node2 = getNodeFromCaptureSsa(closureNode2)
          |
            CaptureSsa::localFlowStep(closureNode1, closureNode2) and step = TValueStep()
            or
            exists(LocalVariable v |
              CaptureSsa::readStep(closureNode1, v, closureNode2) and
              step = TReadStep(TSingleton(TCaptureContent(v)))
              or
              CaptureSsa::storeStep(closureNode1, v, closureNode2) and
              step = TStoreStep(TSingleton(TCaptureContent(v)))
            )
          )
        }

        private DataFlowNode5 getPostUpdateNode2(DataFlowNode5 pre) {
          result = getPostUpdateNode1(pre)
          or
          exists(CaptureSsa::ClosureNode closurePost, CaptureSsa::ClosureNode closurePre |
            CaptureSsa::capturePostUpdateNode(closurePost, closurePre) and
            result = getNodeFromCaptureSsa(closurePost) and
            pre = getNodeFromCaptureSsa(closurePre)
          )
        }

        private class DataFlowNodeLastStage = DataFlowNode5; // Alias for the final stage, but with internal toString method

        final private class DataFlowNode extends DataFlowNodeLastStage {
          predicate isValueOf(AstNode node) { this = TValueNode(node) }

          predicate isIncomingValue(AstNode node) { this = TIncomingValueNode(node) }

          predicate isPostUpdatedValue(AstNode node) { this = TPostUpdatedValueNode(node) }

          predicate isNamespaceObject(NamespaceObject ns) { this = TNamespaceNode(ns) }

          /**
           * Holds if this represents the value of `v` before it has been assigned in the code.
           * Depending on the language, this may refer to the uninitialised state of the variable (garbage memory),
           * or its predefined value coming from the language prelude.
           *
           * When working with parameters, note that the pre-initializer node does _not_ refer to the incoming parameter value.
           * "Pre-initialization" occurs before the parameters are assigned their incoming values.
           */
          predicate isVariablePreInitializer(LocalVariable v) {
            this = getVariablePreInitializer(v)
          }

          predicate isSyntheticNode(AstNode node, string tag) { this = TSyntheticNode(node, tag) }

          AstNode asAstNode() { this.isValueOf(result) or this.isIncomingValue(result) }

          Callable getEnclosingSourceCallable() {
            result = nodeGetEnclosingCallable(this).asSourceCallable()
          }
          // TODO: For now we reuse the expensive toString and getLocation predicates.
          // Eventually we want to shadow them here with more efficient implementations to ensure they don't get evaluated at runtime.
        }

        private class Node = DataFlowNode;

        private newtype TDataFlowCallable = MkSourceCallable(Callable c)

        class DataFlowCallable extends TDataFlowCallable {
          Callable asSourceCallable() { this = MkSourceCallable(result) }

          string toString() { result = this.asSourceCallable().toString() }

          Location getLocation() { result = this.asSourceCallable().getLocation() }
        }

        DataFlowCallable nodeGetEnclosingCallable(Node node) {
          exists(BasicBlock bb |
            dataflowNodeHasOwnCfgNode(node, bb, _) and
            result.asSourceCallable() = getCallableFromBasicBlock(bb)
          )
          or
          exists(Call call |
            node = TDynamicArgumentObjectNode(call) and
            result.asSourceCallable() = getCallableFromCfgNode(getCfgNodeFromCall(call))
          )
          or
          exists(Callable callable |
            node = TReturnNode(callable)
            or
            node = TInnerReturnNode(callable)
            or
            node = TExceptionalReturnNode(callable)
            or
            node = TInnerExceptionalReturnNode(callable)
            or
            node = TParameterObjectNode(callable)
            or
            node = TDynamicParameterObjectNode(callable)
          |
            result.asSourceCallable() = callable
          )
          or
          exists(LocalSsaDataFlow::SsaNode n |
            node = TLocalSsaNode(n) and
            result.asSourceCallable() = getCallableFromBasicBlock(n.getBasicBlock())
          )
          or
          exists(CaptureSsa::SynthesizedCaptureNode n |
            node = TCaptureSsaNode(n) and
            result.asSourceCallable() = n.getEnclosingCallable()
          )
          or
          exists(BasicBlock bb |
            (
              node = TVariableReadNode(_, bb, _) or
              node = TVariableWriteNode(_, bb, _) or
              node = TVariablePostUpdateNode(_, bb, _) or
              node = TClosureExprNode(_, bb, _)
            ) and
            result.asSourceCallable() = getCallableFromBasicBlock(bb)
          )
          or
          exists(DataFlowNode1 pre |
            node = TDerivedPostUpdateNode(pre) and
            result = nodeGetEnclosingCallable(pre)
          )
          or
          exists(BuilderNode inner, string nodeName |
            node = TTransformStepNode(inner, nodeName) and
            result = nodeGetEnclosingCallable(inner)
          )
          or
          exists(DataFlowNode3 inner, ContentSet contents |
            node = TWithContentHelper(inner, contents) and
            result = nodeGetEnclosingCallable(inner)
            or
            node = TWithoutContentHelper(inner, contents) and
            result = nodeGetEnclosingCallable(inner)
          )
        }

        signature module UnifiedDataFlowSig4 {
          predicate isTrackedAllocationSite(Node node);

          predicate modelEntryPoint(string head, string operand, Node node);

          predicate argumentParameterContent(string operand, Content content);

          /** Gets the content of a parameter object that contains the argument to a setter. */
          Content setterParameter();

          /*
           * Stages of steps
           * - Builder nodes
           * - CONTRIBUTE builder steps overlay[local]
           * - Materialise all nodes
           * - Evaluate local alias models
           * - Import resolution
           * - CONTRIBUTE pre-call graph local steps
           * - CONTRIBUTE pre-call graph global steps
           * - Build call graph
           * - CONTRIBUTE post-call graph steps
           * - Global data flow
           */

          /**
           * A data flow step generated in the "late stage", i.e. after all data-flow nodes have been materialised.
           */
          predicate lateStageStep(Node node1, StepBase step, Node node2);
        }

        module MakeUnifiedDataFlow4<UnifiedDataFlowSig4 D4> {
          predicate parameterReadStep(Callable callable, ContentSet contents, Node node2) {
            dataflowStep5(TParameterObjectNode(callable), TReadStep(contents), node2)
          }

          predicate argumentStoreStep(Node node1, ContentSet contents, Call call) {
            dataflowStep5(node1, TStoreStep(contents), TArgumentObjectNode(call))
          }

          predicate argumentPostUpdateReadStep(Call call, ContentSet contents, Node node2) {
            dataflowStep5(TPostUpdatedArgumentObjectNode(call), TReadStep(contents), node2)
          }

          private newtype TParameterPosition =
            MkParameterPosition(ContentSet contents) { parameterReadStep(_, contents, _) } or
            /**
             * Parameter position corresponding to the "full" parameter node with all its original outgoing flow steps.
             */
            MkStaticParameterObjectPosition() or
            /**
             * Parameter position corresponding to the dynamic parameter node, which only has the non-read outgoing flow steps.
             * These are the parameters that can't be translated to a statically-known `MkParameterPosition`.
             */
            MkDynamicParameterObjectPosition() or
            MkFunctionSelfReferenceParameterPosition() or
            MkReceiverParameterPosition()

          class ParameterPosition extends TParameterPosition {
            ContentSet asContentSet() { this = MkParameterPosition(result) }

            string toString() {
              result = this.asContentSet().toString()
              or
              this = MkStaticParameterObjectPosition() and result = "static parameter object"
              or
              this = MkDynamicParameterObjectPosition() and result = "dynamic parameter object"
              or
              this = MkFunctionSelfReferenceParameterPosition() and
              result = "function self-reference"
              or
              this = MkReceiverParameterPosition() and result = "receiver parameter"
            }

            Location getLocation() { result = this.asContentSet().getLocation() }
          }

          private newtype TArgumentPosition =
            MkArgumentPosition(ContentSet contents) { argumentStoreStep(_, contents, _) } or
            /**
             * Argument position corresponding to the "full" argument node with all its original ingoing flow steps.
             */
            MkStaticArgumentObjectPosition() or
            /**
             * Argument position corresponding to the dynamic argument node, which only has the non-store ingoing flow steps.
             * These are the arguments that can't be translated to a statically-known `MkArgumentPosition`.
             */
            MkDynamicArgumentObjectPosition() or
            MkFunctionSelfReferenceArgumentPosition() or
            MkReceiverArgumentPosition() or
            MkSetterArgumentPosition()

          class ArgumentPosition extends TArgumentPosition {
            ContentSet asContentSet() { this = MkArgumentPosition(result) }

            string toString() {
              result = this.asContentSet().toString()
              or
              this = MkStaticArgumentObjectPosition() and result = "static argument object"
              or
              this = MkDynamicArgumentObjectPosition() and result = "dynamic argument object"
              or
              this = MkFunctionSelfReferenceArgumentPosition() and
              result = "function self-reference"
              or
              this = MkReceiverArgumentPosition() and result = "receiver argument"
              or
              this = MkSetterArgumentPosition() and result = "setter argument"
            }

            Location getLocation() { result = this.asContentSet().getLocation() }
          }

          predicate dataflowStep6(Node node1, DataFlowBuilder::Step step, Node node2) {
            dataflowStep5(node1, step, node2) and
            not node2 instanceof TPostUpdatedArgumentObjectNode
            or
            // For non-store steps into the argument object, also flow to the dynamic argument object.
            exists(Call call |
              dataflowStep5(node1, step, TArgumentObjectNode(call)) and
              not step instanceof TStoreStep and
              node2 = TDynamicArgumentObjectNode(call)
            )
            or
            // For non-read steps from the parameter object, also flow from the dynamic parameter object.
            exists(Callable callable |
              dataflowStep5(TParameterObjectNode(callable), step, node2) and
              not step instanceof TReadStep and
              node1 = TDynamicParameterObjectNode(callable)
            )
            or
            exists(ContentSet contents, Call call, DataFlowNode5 arg |
              argumentStoreStep(arg, contents, call) and
              argumentPostUpdateReadStep(call, contents, node2) and
              node1 = getPostUpdateNode2(arg) and
              step.value()
            )
          }

          predicate dataflowStep7(Node node1, DataFlowBuilder::Step step, Node node2) {
            dataflowStep6(node1, step, node2)
            or
            lateStageStep(node1, step, node2)
          }

          private predicate dataflowStepFinal = dataflowStep7/3;

          private predicate getPostUpdateNodeFinal = getPostUpdateNode2/1;

          private Node getPreUpdateNodeFinal(Node node) { getPostUpdateNodeFinal(result) = node }

          predicate parameterNodeImpl(Callable callable, ParameterPosition pos, Node node) {
            parameterReadStep(callable, pos.asContentSet(), node)
            or
            pos = MkStaticParameterObjectPosition() and
            node = TParameterObjectNode(callable)
            or
            pos = MkDynamicParameterObjectPosition() and
            node = TDynamicParameterObjectNode(callable)
            or
            pos = MkFunctionSelfReferenceParameterPosition() and
            node = TCallableSelfReferenceNode(callable)
            or
            pos = MkReceiverParameterPosition() and
            node = TReceiverParameterNode(callable)
          }

          predicate argumentNodeImpl(Call call, ArgumentPosition pos, Node node) {
            argumentStoreStep(node, pos.asContentSet(), call)
            or
            pos = MkStaticArgumentObjectPosition() and
            node = TArgumentObjectNode(call)
            or
            pos = MkDynamicArgumentObjectPosition() and
            node = TDynamicArgumentObjectNode(call)
            or
            pos = MkFunctionSelfReferenceArgumentPosition() and
            node = TCallTargetNode(call)
            or
            pos = MkReceiverArgumentPosition() and
            node = TReceiverArgumentNode(call)
          }

          private int getAstNodeDepth(AstNode node) {
            not exists(node.getParent()) and result = 0
            or
            result = 1 + getAstNodeDepth(node.getParent())
          }

          private string getDisambiguatingTag1(Node node) {
            exists(AstNode astNode |
              (
                node.isValueOf(astNode) or
                node.isIncomingValue(astNode) or
                node.isPostUpdatedValue(astNode)
              ) and
              result = getAstNodeDepth(astNode).toString()
            )
          }

          private string getDisambiguatingTag(Node node) {
            result = getDisambiguatingTag1(node)
            or
            not exists(getDisambiguatingTag1(node)) and
            result = ""
          }

          /** A node to be included in the output of `TestOutput`. */
          signature class RelevantNodeSig extends Node;

          private module TestTestOutput = TestOutput<Node>;

          bindingset[s]
          signature string escapeSig(string s);

          signature string lineBreakSig();

          /**
           * Renders a node label, either for a Mermaid diagram, or a `graph` output relation.
           * Escaping works differently in these contexts.
           */
          module MakeLabeler<escapeSig/1 escape, lineBreakSig/0 lineBreak> {
            private string getAnAnnotationFor(Node node) {
              exists(ContentSet contents |
                DataFlowInput::clearsContent(node, contents) and
                result = lineBreak() + "[clears " + escape(contents.toString()) + "]"
                or
                DataFlowInput::expectsContent(node, contents) and
                result = lineBreak() + "[expects " + escape(contents.toString()) + "]"
              )
            }

            string getLabel(Node node) {
              result = escape(node.toString()) + concat(getAnAnnotationFor(node))
            }
          }

          /**
           * Import this module into a `.ql` file to output a Mermaid graph. The
           * graph is restricted to nodes from `RelevantNode`.
           */
          module TestOutput<RelevantNodeSig RelevantNode> {
            /** Holds if `pred -> succ` is an edge in the relevant part of the data flow graph. */
            query predicate edges(RelevantNode node1, RelevantNode node2, string label) {
              label =
                strictconcat(string s |
                  exists(StepBase step |
                    dataflowStepFinal(node1, step, node2) and
                    s = step.toString()
                  )
                  or
                  s = "post-update" and
                  node2 = getPostUpdateNodeFinal(node1)
                |
                  s, ", " order by s
                )
            }

            /**
             * Provides logic for representing a relevant part of the data flow graph as a [Mermaid diagram](https://mermaid.js.org/).
             */
            module Mermaid {
              private string nodeId(RelevantNode n) {
                result =
                  any(int i |
                    n =
                      rank[i](RelevantNode p, string filePath, int startLine, int startColumn,
                        int endLine, int endColumn |
                        p.getLocation()
                            .hasLocationInfo(filePath, startLine, startColumn, endLine, endColumn)
                      |
                        p
                        order by
                          filePath, startLine, startColumn, endLine, endColumn, p.(Node).toString(),
                          getDisambiguatingTag(p)
                      )
                  ).toString()
              }

              predicate ambiguousId(RelevantNode n, string id, TDataFlowNode raw) {
                id = nodeId(n) and
                not exists(unique(RelevantNode m | id = nodeId(m))) and
                raw = n
              }

              bindingset[s]
              private string escapeMermaidLabel(string s) {
                result =
                  s.replaceAll("\\", "&bsol;")
                      .replaceAll("\"", "&quot;")
                      .replaceAll("\n", 9226.toUnicode()) // replace line breaks with 'LF' symbol
              }

              private string lineBreak() { result = "\\n" } // becomes an actual line break inside the label

              private module Labeler = MakeLabeler<escapeMermaidLabel/1, lineBreak/0>;

              private string nodes() {
                result =
                  concat(RelevantNode n, string id |
                    id = nodeId(n)
                  |
                    id + "[\"" + Labeler::getLabel(n) + "\"]", "\n" order by id
                  )
              }

              private string edge(RelevantNode pred, RelevantNode succ) {
                edges(pred, succ, _) and
                exists(string label |
                  edges(pred, succ, label) and
                  if label = ""
                  then result = nodeId(pred) + " --> " + nodeId(succ)
                  else
                    result =
                      nodeId(pred) + " -- " + escapeMermaidLabel(label) + " --> " + nodeId(succ)
                )
              }

              private string edges() {
                result =
                  concat(RelevantNode pred, RelevantNode succ, string edge, string filePath,
                    int startLine, int startColumn, int endLine, int endColumn |
                    edge = edge(pred, succ) and
                    pred.getLocation()
                        .hasLocationInfo(filePath, startLine, startColumn, endLine, endColumn)
                  |
                    edge, "\n"
                    order by
                      filePath, startLine, startColumn, endLine, endColumn, pred.(Node).toString()
                  )
              }

              /** Holds if the Mermaid representation is `s`. */
              query predicate mermaid(string s) {
                s = "flowchart TD\n" + nodes() + "\n\n" + edges()
              }
            }
          }

          /** Provides the input to `ViewCfgQuery`. */
          signature module ViewDfgQueryInputSig<FileSig File> {
            /** The source file selected in the IDE. Should be an `external` predicate. */
            string selectedSourceFile();

            /** The source line selected in the IDE. Should be an `external` predicate. */
            int selectedSourceLine();

            /** The source column selected in the IDE. Should be an `external` predicate. */
            int selectedSourceColumn();

            File getFileFromLocation(Location loc);
          }

          /**
           * Provides an implementation for a `View DFG` query (which currently has to happen by hijacking the `View CFG` query).
           *
           * Import this module into a `.ql` that looks like
           *
           * ```ql
           * @name Print DFG
           * @description Produces a representation of a file's Data Flow Graph
           *              This query is used by the VS Code extension.
           * @id <lang>/print-dfg
           * @kind graph
           * @tags ide-contextual-queries/print-cfg
           * ```
           *
           * Note that the tag name is `print-cfg` because `print-dfg` is not currently recognised by vscode.
           */
          module ViewDfgQuery<FileSig File, ViewDfgQueryInputSig<File> ViewCfgQueryInput> {
            private import ViewCfgQueryInput

            predicate callableSpan(
              Callable callable, File file, int startLine, int startColumn, int endLine,
              int endColumn
            ) {
              exists(Location loc |
                loc = callable.getLocation() and
                file = getFileFromLocation(callable.getLocation()) and
                loc.hasLocationInfo(_, startLine, startColumn, endLine, endColumn)
              )
            }

            bindingset[file, line, column]
            private Callable smallestEnclosingScope(File file, int line, int column) {
              result =
                min(Callable scope, int startLine, int startColumn, int endLine, int endColumn |
                  callableSpan(scope, file, startLine, startColumn, endLine, endColumn) and
                  (
                    startLine < line
                    or
                    startLine = line and startColumn <= column
                  ) and
                  (
                    endLine > line
                    or
                    endLine = line and endColumn >= column
                  )
                |
                  scope order by startLine desc, startColumn desc, endLine, endColumn
                )
            }

            private import IdeContextual<File>

            final private class FinalDataFlowNode = Node;

            private class RelevantNode extends FinalDataFlowNode {
              RelevantNode() {
                nodeGetEnclosingCallable(this).asSourceCallable() =
                  smallestEnclosingScope(getFileBySourceArchiveName(selectedSourceFile()),
                    selectedSourceLine(), selectedSourceColumn())
              }

              string getOrderDisambiguation() { result = "" }
            }

            private module Output = TestOutput<RelevantNode>;

            import Output::Mermaid

            bindingset[s]
            private string escape(string s) { result = s }

            private string lineBreak() { result = " " } // It seems there is no way to make line breaks here

            private module Labeler = MakeLabeler<escape/1, lineBreak/0>;

            query predicate nodes(RelevantNode node, string attr, string val) {
              attr = "semmle.label" and
              val = Labeler::getLabel(node)
            }

            /** Holds if `pred` -> `succ` is an edge in the CFG. */
            query predicate edges(RelevantNode pred, RelevantNode succ, string attr, string val) {
              attr = "semmle.label" and
              Output::edges(pred, succ, val)
            }
          }

          final private class FinalContent = Content;

          final private class FinalContentSet = ContentSet;

          final private class FinalParameterPosition = ParameterPosition;

          final private class FinalArgumentPosition = ArgumentPosition;

          private import D4

          private signature predicate aliasModelSig(string aliasName, string accessPath);

          private signature predicate dataflowStepSig(
            Node node1, DataFlowBuilder::Step step, Node node2
          );

          module MakeModelsAsData<aliasModelSig/2 aliasModel> {
            private predicate aliasAccessPath(string accessPath) { aliasModel(_, accessPath) }

            private module AliasAccessPaths = AccessPathSyntax::AccessPath<aliasAccessPath/1>;

            private import AliasAccessPaths

            signature predicate relevantAliasNamesSig(string name);

            /** Makes a MaD evaluator using the given set of data flow steps. */
            private module MakeStage<
              dataflowStepSig/3 step, relevantAliasNamesSig/1 relevantAliasNames>
            {
              private predicate relevantAliasNamesEx(string name) {
                relevantAliasNames(name)
                or
                exists(string otherAlias, AccessPath accessPath |
                  // We need to evaluate 'X' and there is a model `X -> Alias[Y].Blah`, so we need to evaluate 'Y'
                  aliasModel(otherAlias, accessPath) and
                  unfoldToken(accessPath.getToken(0), "Alias", name)
                )
              }

              private module Steps {
                predicate readStep(Node node1, ContentSet contents, Node node2) {
                  step(node1, TReadStep(contents), node2)
                }

                predicate storeStep(Node node1, ContentSet contents, Node node2) {
                  step(node1, TStoreStep(contents), node2)
                }
              }

              private predicate unfoldToken(AccessPathToken tok, string head, string operand) {
                head = tok.getName() and
                (
                  operand = tok.getAnArgument()
                  or
                  not exists(tok.getArgumentList()) and
                  operand = ""
                )
              }

              pragma[nomagic]
              private Content contentFromToken(AccessPathToken tok) {
                exists(string head, string operand |
                  unfoldToken(tok, head, operand) and
                  result.hasModelToken(head, operand)
                )
              }

              Node getAnAliasSource(string aliasName) {
                exists(AccessPath path, int n |
                  result = getAnAliasSource(aliasName, path, n) and
                  n = path.getNumToken()
                )
              }

              Node getAnAliasSource(string aliasName, AccessPath accessPath, int n) {
                aliasModel(aliasName, accessPath) and
                relevantAliasNamesEx(aliasName) and
                n = 1 and
                exists(string head, string operand |
                  unfoldToken(accessPath.getToken(0), head, operand)
                |
                  modelEntryPoint(head, operand, result)
                  or
                  head = "Alias" and
                  result = getAnAliasSource(operand)
                )
                or
                valueStepApprox(getAnAliasSource(aliasName, accessPath, n), result)
                or
                exists(Node prev, AccessPathToken token |
                  prev = getAnAliasSource(aliasName, accessPath, n - 1) and
                  token = accessPath.getToken(n - 1)
                |
                  exists(ContentSet contents |
                    Steps::readStep(prev, contents, result) and
                    contents.getAReadContent() = contentFromToken(token)
                  )
                )
                or
                exists(ContentSet contents |
                  Steps::readStep(getAnAliasSourceParameterObject(aliasName, accessPath, n - 1),
                    contents, result) and
                  argumentParameterContent(accessPath.getToken(n - 1).getAnArgument(),
                    contents.getAReadContent())
                )
              }

              Node getAnAliasSinkArgumentObject(string aliasName, AccessPath accessPath, int n) {
                exists(Call call |
                  getAnAliasSource(aliasName, accessPath, n) = TCallTargetNode(call) and
                  accessPath.getToken(n).getName() = "Argument" and
                  result = TArgumentObjectNode(call)
                )
                or
                valueStepApprox(result, getAnAliasSinkArgumentObject(aliasName, accessPath, n))
              }

              Node getAnAliasSink(string aliasName, AccessPath accessPath, int n) {
                exists(ContentSet contents |
                  Steps::storeStep(result, contents,
                    getAnAliasSinkArgumentObject(aliasName, accessPath, n - 1)) and
                  argumentParameterContent(accessPath.getToken(n - 1).getAnArgument(),
                    contents.getAStoreContent())
                )
              }

              Node getAnAliasSourceParameterObject(string aliasName, AccessPath accessPath, int n) {
                exists(Callable callable |
                  getAnAliasSink(aliasName, accessPath, n) = TClosureExprNode(callable, _, _) and
                  accessPath.getToken(n).getName() = "Parameter" and
                  result = TParameterObjectNode(callable)
                )
                or
                valueStepApprox(getAnAliasSourceParameterObject(aliasName, accessPath, n), result)
              }
            }

            module EvaluatePreCallGraph<relevantAliasNamesSig/1 relevantAliasNames> {
              import MakeStage<dataflowStep6/3, relevantAliasNames/1>
            }
          }

          /** Holds if `(node, step)` is the only flow step targeting `node2`. */
          private predicate uniqueIncomingStep(Node node1, StepBase step, Node node2) {
            node1 = unique(Node pred, StepBase s | dataflowStep6(pred, s, node2) | pred) and
            dataflowStep6(node1, step, node2) // bind 'step' again because 'unique' can only report back 1 column
          }

          private predicate uniqueIncomingValueStep(Node node1, Node node2) {
            uniqueIncomingStep(node1, TValueStep(), node2)
          }

          private predicate localMustFlowStep(Node node1, Node node2) {
            exists(LocalSsaDataFlow::Node ssaNode1, LocalSsaDataFlow::Node ssaNode2 |
              LocalSsaDataFlow::localMustFlowStep(_, ssaNode1, ssaNode2) and
              node1 = getNodeFromLocalSsa(ssaNode1) and
              node2 = getNodeFromLocalSsa(ssaNode2)
            )
            or
            uniqueIncomingValueStep(node1, node2)
          }

          signature module ValuePropagationInputSig {
            bindingset[this]
            class Value;

            predicate shouldComputeValue(Node node);

            /** Holds if may-flow steps are allowed. */
            predicate allowMayFlow();

            /**
             * Holds if captured variables that only have a single explicit assignment should be assumed to
             * have the constant-value from that assignment, even if it cannot be proven that the variable
             * has been initialized before the read.
             */
            default predicate assumeInitializedCapturedVariables() { any() }

            /**
             * Holds if the given variable `v` should be treated as having a constant value.
             *
             * This is in addition to the captured variable covered by `assumeInitializedCapturedVariables()`.
             */
            default predicate treatAsConstant(LocalVariable v) { none() }
          }

          module MakeValuePropagation<ValuePropagationInputSig Input> {
            private import Input

            pragma[nomagic]
            private predicate shouldComputeValueEx(Node node) {
              shouldComputeValue(node)
              or
              exists(Node other |
                shouldComputeValueEx(other) and
                node = any(ValuePropagationRule r).getADependency(other)
              )
            }

            pragma[nomagic]
            Value getValue(Node node) {
              shouldComputeValueEx(node) and
              result = any(ValuePropagationRule r).computeValue(node)
            }

            pragma[nomagic]
            Value getValueOfExpr(AstNode node) { result = getValue(TValueNode(node)) }

            pragma[nomagic]
            Value getIncomingValue(AstNode node) { result = getValue(TIncomingValueNode(node)) }

            pragma[nomagic]
            private predicate hasConstantValue(Node node) { exists(getValue(node)) }

            class ValuePropagationRule extends Unit {
              /**
               * Gets the data flow nodes whose constant-value should be computed, in order to compute the constant-value of `node`.
               *
               * The caller will restrict `node` to nodes whose constant-value is already known to be needed.
               *
               * For example, a binary expression would typically depend on its operands.
               *
               * Note that the framework assumes that calls whose call target is a constant have a dependency on the arguments
               * of that call (i.e. the nodes that are directly stored on its argument object).
               */
              bindingset[node]
              abstract Node getADependency(Node node);

              /**
               * Computes the constant value of `node`, if any. The implementation should use `getValue` to access
               * already-computed constants.
               */
              bindingset[node]
              abstract Value computeValue(Node node);
            }

            private predicate treatAsConstantEx(LocalVariable v) {
              Input::treatAsConstant(v)
              or
              Input::assumeInitializedCapturedVariables() and
              v.isCaptured() and
              exists(
                unique(BuilderNode node1, StepBase step |
                  dataflowStep1(node1, step, TVariableNode(v, false))
                |
                  node1
                )
              )
            }

            pragma[nomagic]
            private predicate constantStep(Node node1, Node node2) {
              localMustFlowStep(node1, node2)
              or
              exists(LocalVariable v | treatAsConstantEx(v) |
                node1 = TVariableWriteNode(v, _, _) and
                node2 = TVariableNode(v, true)
                or
                node1 = TVariableNode(v, true) and
                node2 = TVariableReadNode(v, _, _)
              )
            }

            private class MustFlow extends ValuePropagationRule {
              bindingset[node]
              override Node getADependency(Node node) { constantStep(result, node) }

              override Value computeValue(Node node) {
                exists(Node pred |
                  constantStep(pred, node) and
                  result = getValue(pred)
                )
              }
            }

            private class CallHelper extends ValuePropagationRule {
              bindingset[node]
              override Node getADependency(Node node) {
                exists(Call call |
                  hasConstantValue(TCallTargetNode(call)) and
                  node = TOutNode(call) and
                  argumentStoreStep(result, _, call)
                )
              }

              override Value computeValue(Node node) { none() }
            }
          }

          private predicate nodeGetEnclosingCallableAlias = nodeGetEnclosingCallable/1;

          final private class DataFlowCallableAlias = DataFlowCallable;

          private module Steps {
            pragma[nomagic]
            predicate readStep(Node node1, ContentSet contents, Node node2) {
              dataflowStepFinal(node1, TReadStep(contents), node2)
            }

            pragma[nomagic]
            predicate storeStep(Node node1, ContentSet contents, Node node2) {
              dataflowStepFinal(node1, TStoreStep(contents), node2)
            }

            pragma[nomagic]
            predicate copyStep(Node node1, Node node2) {
              dataflowStepFinal(node1, TCopyStep(), node2)
            }

            pragma[nomagic]
            predicate simpleValueStep(Node node1, Node node2) {
              dataflowStepFinal(node1, TValueStep(), node2)
            }

            pragma[nomagic]
            predicate storeContentNoCapture(Node node1, Content content, Node node2) {
              exists(ContentSet contents |
                dataflowStepFinal(node1, TStoreStep(contents), node2) and
                content = contents.getAStoreContent() and
                not content instanceof TCaptureContent
              )
            }

            pragma[nomagic]
            predicate storeGetter(Node node1, Content content, Node node2) {
              exists(ContentSet contents |
                dataflowStepFinal(node1, TStoreAsGetterStep(contents), node2) and
                content = contents.getAStoreContent()
              )
            }

            pragma[nomagic]
            predicate storeSetter(Node node1, Content content, Node node2) {
              exists(ContentSet contents |
                dataflowStepFinal(node1, TStoreAsSetterStep(contents), node2) and
                content = contents.getAStoreContent()
              )
            }
          }

          private import Steps

          module DataFlowInput implements DataFlow::InputSig<Location> {
            final class Node = DataFlowNode;

            DataFlowCallable nodeGetEnclosingCallable(Node n) {
              result = nodeGetEnclosingCallableAlias(n)
            }

            class DataFlowCallable = DataFlowCallableAlias;

            class ArgumentPosition = FinalArgumentPosition;

            class ParameterPosition = FinalParameterPosition;

            class ParameterNode extends Node {
              ParameterNode() { parameterNodeImpl(_, _, this) }
            }

            predicate isParameterNode(
              ParameterNode node, DataFlowCallable callable, ParameterPosition pos
            ) {
              parameterNodeImpl(callable.asSourceCallable(), pos, node)
            }

            private predicate argumentNodeImplEx(DataFlowCall call, ArgumentPosition pos, Node node) {
              argumentNodeImpl(call.asSourceCall(), pos, node)
              or
              exists(Node receiver, ContentSet contents, Node value, boolean isSetter |
                call.isAccessorCall(receiver, contents, value, isSetter)
              |
                pos = MkReceiverArgumentPosition() and
                node = receiver
                or
                isSetter = true and
                pos = MkSetterArgumentPosition() and
                node = value
              )
            }

            class ArgumentNode extends Node {
              ArgumentNode() { argumentNodeImplEx(_, _, this) }
            }

            predicate isArgumentNode(ArgumentNode node, DataFlowCall call, ArgumentPosition pos) {
              argumentNodeImplEx(call, pos, node)
            }

            private newtype TReturnKind =
              TValueReturn() or
              TExceptionalReturn()

            class ReturnKind extends TReturnKind {
              string toString() {
                this = TValueReturn() and result = "value"
                or
                this = TExceptionalReturn() and result = "exception"
              }
            }

            additional Node getReturnNodeOfKind(Callable c, ReturnKind kind) {
              result = TReturnNode(c) and kind = TValueReturn()
              or
              result = TExceptionalReturnNode(c) and kind = TExceptionalReturn()
            }

            additional Node getOutNodeOfKind(DataFlowCall c, ReturnKind kind) {
              result = TOutNode(c.asSourceCall()) and kind = TValueReturn()
              or
              result = TExceptionalOutNode(c.asSourceCall()) and kind = TExceptionalReturn()
              or
              c.isGetterCall(_, _, result) and kind = TValueReturn()
            }

            class ReturnNode extends Node {
              ReturnNode() { this = getReturnNodeOfKind(_, _) }

              ReturnKind getKind() { this = getReturnNodeOfKind(_, result) }
            }

            class OutNode extends Node {
              OutNode() { this = getOutNodeOfKind(_, _) }

              ReturnKind getKind() { this = getOutNodeOfKind(_, result) }
            }

            OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
              result = getOutNodeOfKind(call, kind)
            }

            class PostUpdateNode extends Node {
              PostUpdateNode() { this = getPostUpdateNodeFinal(_) }

              Node getPreUpdateNode() { this = getPostUpdateNodeFinal(result) }
            }

            private newtype TDataFlowCall =
              MkSourceCall(Call c) or
              MkAccessorCall(Node receiver, ContentSet contents, Node value, boolean isSetter) {
                // TODO: restrict based on which contents are viable getter/setter to avoid too many calls
                // TODO: add means for bypassing getter/setter calls for "raw" reads and writes
                isSetter = false and
                readStep(receiver, contents, value) and
                (receiver instanceof TValueNode or receiver instanceof TVariableReadNode)
                or
                isSetter = true and
                storeStep(value, contents, receiver) and
                (
                  receiver instanceof TPostUpdatedValueNode or
                  receiver instanceof TVariablePostUpdateNode
                )
              }

            class DataFlowCall extends TDataFlowCall {
              Call asSourceCall() { this = MkSourceCall(result) }

              predicate isAccessorCall(
                Node receiver, ContentSet contents, Node value, boolean isSetter
              ) {
                this = MkAccessorCall(receiver, contents, value, isSetter)
              }

              predicate isGetterCall(Node receiver, ContentSet contents, Node value) {
                this = MkAccessorCall(receiver, contents, value, false)
              }

              predicate isSetterCall(Node receiver, ContentSet contents, Node value) {
                this = MkAccessorCall(receiver, contents, value, true)
              }

              string toString() {
                result = this.asSourceCall().toString()
                or
                exists(ContentSet contents |
                  this.isGetterCall(_, contents, _) and
                  result = "getter call (" + contents + ")"
                  or
                  this.isSetterCall(_, contents, _) and
                  result = "setter call (" + contents + ")"
                )
              }

              Location getLocation() {
                result = this.asSourceCall().getLocation()
                or
                exists(Node value |
                  this.isAccessorCall(_, _, value, _) and
                  result = value.getLocation()
                )
              }

              DataFlowCallable getEnclosingCallable() {
                result.asSourceCallable() =
                  getCallableFromCfgNode(getCfgNodeFromCall(this.asSourceCall()))
                or
                exists(Node receiver |
                  this.isAccessorCall(receiver, _, _, _) and
                  result = nodeGetEnclosingCallable(receiver)
                )
              }
            }

            // TODO: Instantiating DataFlowType is tricky since Callables and NamespaceObjects overlap, but we can't detect this
            private newtype TDataFlowType =
              TNamespaceType(NamespaceObject obj) or
              TAnyType()

            class DataFlowType extends TDataFlowType {
              NamespaceObject asNamespace() { this = TNamespaceType(result) }

              predicate isAny() { this = TAnyType() }

              string toString() {
                result = this.asNamespace().toString()
                or
                this.isAny() and result = "any"
              }

              Location getLocation() { result = this.asNamespace().getLocation() }
            }

            predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) {
              NamespaceTracking::namespaceHasBaseObject+(t1.asNamespace(), t2.asNamespace())
              or
              exists(t1) and t2.isAny()
            }

            overlay[global]
            pragma[inline]
            private predicate compatibleTypesWithAny(DataFlowType t1, DataFlowType t2) {
              t1 != TAnyType() and
              t2 = TAnyType()
            }

            private module DataFlowTypeDualInput implements DualGraphInputSig<Location> {
              class Node = DataFlowType;

              predicate edge(Node node1, Node node2) {
                NamespaceTracking::namespaceHasBaseObject(node1.asNamespace(), node2.asNamespace())
              }
            }

            private module DataFlowTypeDual = MakeDualGraph<Location, DataFlowTypeDualInput>;

            overlay[global]
            pragma[inline]
            predicate compatibleTypes(DataFlowType t1, DataFlowType t2) {
              DataFlowTypeDual::hasCommonAncestor(t1, t2) // relation is symmetric, only check one direction
              or
              compatibleTypesWithAny(t1, t2)
              or
              compatibleTypesWithAny(t2, t1)
              or
              t1 = t2
            }

            private DataFlowType getNodeType1(Node node) {
              node = CallGraph::trackNamespaceEx(result.asNamespace(), false)
              or
              node = NamespaceTracking::trackNamespace(result.asNamespace())
            }

            private DataFlowType getNodeType2(Node node) {
              result = unique( | | getNodeType1(node))
            }

            DataFlowType getNodeType(Node node) {
              result = getNodeType2(node)
              or
              not exists(getNodeType2(node)) and
              result.isAny()
            }

            class CastNode extends Node {
              CastNode() { none() } // TODO
            }

            predicate nodeIsHidden(Node node) {
              not (node instanceof TValueNode or node instanceof TIncomingValueNode)
            }

            class DataFlowExpr = AstNode;

            Node exprNode(DataFlowExpr e) { result = TValueNode(e) }

            private newtype TStoreKind =
              TNormalStoreKind() or
              TGetterStoreKind() or
              TSetterStoreKind()

            private class StoreKind extends TStoreKind {
              predicate isNormalStoreKind() { this = TNormalStoreKind() }

              predicate isGetterStoreKind() { this = TGetterStoreKind() }

              predicate isSetterStoreKind() { this = TSetterStoreKind() }

              string toString() {
                this = TNormalStoreKind() and result = "normal"
                or
                this = TGetterStoreKind() and result = "getter"
                or
                this = TSetterStoreKind() and result = "setter"
              }
            }

            private module NamespaceTracking {
              pragma[nomagic]
              Node trackNamespace(NamespaceObject ns) {
                result.isNamespaceObject(ns)
                or
                valueStepEx(trackNamespace(ns), result)
              }

              private Node trackCallableSimple(Callable method) {
                isMethod(method) and
                result = TClosureExprNode(method, _, _)
                or
                simpleValueStep(trackCallableSimple(method), result)
              }

              private predicate storeLikeStep(Node node1, Node node2) {
                exists(StepBase step | dataflowStepFinal(node1, step, node2) |
                  step instanceof TStoreStep or
                  step instanceof TStoreAsGetterStep or
                  step instanceof TStoreAsSetterStep
                )
              }

              private Node methodAssumedReceiver(Callable method) {
                exists(Node target |
                  isMethod(method) and
                  storeLikeStep(trackCallableSimple(method), target) and
                  result = [target, getPreUpdateNodeFinal(target)]
                )
              }

              predicate assumedReceiverStep(Node node1, Node node2) {
                exists(Callable method |
                  node1 = methodAssumedReceiver(method) and
                  node2 = TReceiverParameterNode(method)
                  or
                  exists(ClassLikeObject cls |
                    isInstanceInitializer(method, cls) and
                    node1.isNamespaceObject(cls.getInstancePrototype()) and
                    node2 = TReceiverParameterNode(method)
                  )
                )
              }

              pragma[nomagic]
              private predicate valueStep(Node node1, Node node2) {
                simpleValueStep(node1, node2)
                or
                // Like in the variable-capture stage, use an over-approximation of capture flow
                approxCaptureStep(node1, node2)
                or
                assumedReceiverStep(node1, node2)
                or
                node2 = getPostUpdateNodeFinal(node1)
              }

              pragma[nomagic]
              private predicate storeIntoNamespace(
                Node node1, Content content, NamespaceObject node2
              ) {
                storeContentNoCapture(node1, content, trackNamespace(node2))
              }

              pragma[nomagic]
              predicate storeGetterIntoNamespace(
                Callable getter, Content content, NamespaceObject node2
              ) {
                storeGetter(trackCallableSimple(getter), content, trackNamespace(node2))
              }

              pragma[nomagic]
              predicate storeSetterIntoNamespace(
                Callable setter, Content content, NamespaceObject node2
              ) {
                storeSetter(trackCallableSimple(setter), content, trackNamespace(node2))
              }

              pragma[nomagic]
              Content getSimpleContentFromContentSet(ContentSet contents) {
                result = contents.asSingleton()
                or
                exists(IndexedContainerKind kind |
                  result.asContainerSlot(kind) = contents.asContainerSlot(kind)
                )
              }

              pragma[nomagic]
              predicate readContentStep(Node node1, Content content, Node node2) {
                exists(ContentSet contents | DataFlowInput::readStep(node1, contents, node2) |
                  content = getSimpleContentFromContentSet(contents)
                )
              }

              pragma[nomagic]
              Node getSetterParameter(Callable setter) {
                readContentStep(TParameterObjectNode(setter), setterParameter(), result)
              }

              pragma[nomagic]
              private predicate readFromNamespace(NamespaceObject node1, Content content, Node node2) {
                readContentStep(trackNamespace(node1), content, node2)
              }

              pragma[nomagic]
              predicate derivedStep(Node node1, Node node2) {
                exists(NamespaceObject ns, Content content |
                  namespaceHasOwnContent(ns, content, node1) and
                  readFromNamespace(ns, content, node2)
                  or
                  exists(Callable accessor |
                    readFromNamespace(ns, content, node2) and
                    namespaceHasOwnGetter(ns, content, accessor) and
                    node1 = TReturnNode(accessor)
                    or
                    storeIntoNamespace(node1, content, ns) and
                    namespaceHasOwnSetter(ns, content, accessor) and
                    node2 = getSetterParameter(accessor)
                  )
                )
              }

              pragma[inline]
              predicate valueStepEx(Node node1, Node node2) {
                valueStep(node1, node2)
                or
                derivedStep(node1, node2)
              }

              pragma[nomagic]
              predicate hasOwnContent(NamespaceObject ns, Content content) {
                storeIntoNamespace(_, content, ns)
              }

              pragma[nomagic]
              predicate storeBaseStep(Node parentObj, Node childObj) {
                dataflowStepFinal(parentObj, TStoreBaseObject(), childObj)
              }

              pragma[nomagic]
              predicate namespaceHasBaseValue(NamespaceObject namespace, Node baseObj) {
                storeBaseStep(baseObj, trackNamespace(namespace))
              }

              pragma[nomagic]
              predicate namespaceHasBaseObject(NamespaceObject namespace, NamespaceObject baseObj) {
                namespaceHasBaseValue(namespace, trackNamespace(baseObj))
              }

              pragma[nomagic]
              predicate withoutContentStepToNamespace(
                Node node, ContentSet contents, NamespaceObject target
              ) {
                dataflowStep3(node, TWithoutContentStep(contents), TNamespaceNode(target))
              }

              pragma[nomagic]
              predicate withoutContentStepToNamespace2(
                NamespaceObject ns, ContentSet contents, NamespaceObject target
              ) {
                withoutContentStepToNamespace(trackNamespace(ns), contents, target)
              }

              pragma[nomagic]
              predicate withContentStepToNamespace(
                Node node, ContentSet contents, NamespaceObject target
              ) {
                dataflowStep3(node, TWithContentStep(contents), TNamespaceNode(target))
              }

              pragma[nomagic]
              predicate withContentStepToNamespace2(
                NamespaceObject ns, ContentSet contents, NamespaceObject target
              ) {
                withContentStepToNamespace(trackNamespace(ns), contents, target)
              }

              predicate namespaceHasOwnContentOrAccessor(NamespaceObject ns, Content content) {
                namespaceHasOwnContent(ns, content, _)
                or
                namespaceHasOwnGetter(ns, content, _)
                or
                namespaceHasOwnSetter(ns, content, _)
              }

              predicate namespaceHasOwnContent(NamespaceObject ns, Content content, Node value) {
                storeIntoNamespace(value, content, ns)
                or
                exists(NamespaceObject other, ContentSet contents |
                  withoutContentStepToNamespace2(other, contents, ns) and
                  namespaceHasOwnContent(other, content, value) and
                  not contents.getAReadContent() = content
                )
                or
                exists(NamespaceObject other, ContentSet contents |
                  withContentStepToNamespace2(other, contents, ns) and
                  namespaceHasOwnContent(other, content, value) and
                  contents.getAReadContent() = content
                )
              }

              predicate namespaceHasContent(NamespaceObject ns, Content content, Node value) {
                namespaceHasOwnContent(ns, content, value)
                or
                not namespaceHasOwnContentOrAccessor(ns, content) and
                exists(NamespaceObject base |
                  namespaceHasBaseObject(ns, base) and
                  namespaceHasContent(base, content, value)
                )
              }

              predicate namespaceHasOwnGetter(NamespaceObject ns, Content content, Callable getter) {
                storeGetterIntoNamespace(getter, content, ns)
              }

              predicate namespaceHasGetter(NamespaceObject ns, Content content, Callable getter) {
                namespaceHasOwnGetter(ns, content, getter)
                or
                not namespaceHasOwnContentOrAccessor(ns, content) and
                exists(NamespaceObject base |
                  namespaceHasBaseObject(ns, base) and
                  namespaceHasGetter(base, content, getter)
                )
              }

              predicate namespaceHasOwnSetter(NamespaceObject ns, Content content, Callable setter) {
                storeSetterIntoNamespace(setter, content, ns)
              }

              predicate namespaceHasSetter(NamespaceObject ns, Content content, Callable setter) {
                namespaceHasOwnSetter(ns, content, setter)
                or
                not namespaceHasOwnContentOrAccessor(ns, content) and
                exists(NamespaceObject base |
                  namespaceHasBaseObject(ns, base) and
                  namespaceHasSetter(base, content, setter)
                )
              }

              /**
               * Holds if `node1 -> node2` is a value step propagating a value (usually a method)
               * from a base class to a subclass.
               *
               * For example, the method `bar` is propagated downwards from `Base` to the `this.bar` expression.
               * ```js
               * class Base {
               *   bar() { ... }
               * }
               * class Sub extends Base {
               *   foo() { this.bar() }
               * }
               * ```
               */
              predicate downwardsInheritedContentStep(Node node1, Node node2) {
                exists(NamespaceObject ns, Content content |
                  // simplify debugging by not overlapping with valueStepEx
                  not namespaceHasOwnContentOrAccessor(ns, content)
                |
                  namespaceHasContent(ns, content, node1) and
                  readFromNamespace(ns, content, node2)
                  or
                  exists(Callable accessor |
                    namespaceHasGetter(ns, content, accessor) and
                    readFromNamespace(ns, content, node2) and
                    node1 = TReturnNode(accessor)
                    or
                    namespaceHasSetter(ns, content, accessor) and
                    storeIntoNamespace(node1, content, ns) and
                    node2 = getSetterParameter(accessor)
                  )
                )
              }

              /**
               * Gets a node that refers to a receiver in a method of `ns`, meaning it
               * may also refer to an object that inherits from `ns`.
               */
              Node trackNamespaceAsAssumedReceiver(NamespaceObject ns) {
                assumedReceiverStep(NamespaceTracking::trackNamespace(ns), result)
                or
                // note: do not use 'valueStepEx' here as we don't want to follow store/read steps
                valueStep(trackNamespaceAsAssumedReceiver(ns), result)
              }

              predicate localReceiverReadStep(NamespaceObject ns, Content content, Node value) {
                readContentStep(trackNamespaceAsAssumedReceiver(ns), content, value)
              }

              predicate localReceiverStoreStep(NamespaceObject ns, Content content, Node value) {
                storeContentNoCapture(value, content, trackNamespaceAsAssumedReceiver(ns))
              }

              /**
               * Holds if `node1 -> node2` is a value step propagating a value (usually a method)
               * from a subclass to a base class.
               *
               * For example, the method `bar` is propagated upwards from `Sub` to the `this.bar` expression.
               * ```js
               * class Base {
               *   foo() { this.bar() }
               * }
               * class Sub extends Base {
               *   bar() { ... }
               * }
               * ```
               */
              predicate upwardsInheritedContentStep(Node node1, Node node2) {
                exists(NamespaceObject child, NamespaceObject ns, Content content |
                  localReceiverReadStep(ns, content, node2) and
                  namespaceHasBaseObject+(child, ns)
                |
                  namespaceHasOwnContent(child, content, node1)
                  or
                  exists(Callable getter |
                    namespaceHasOwnGetter(child, content, getter) and
                    node1 = TReturnNode(getter)
                  )
                )
              }

              predicate localContentStep(Node node1, Node node2) {
                exists(NamespaceObject ns, Content content |
                  localReceiverStoreStep(ns, content, node1) and
                  localReceiverReadStep(ns, content, node2)
                )
              }
            }

            private module CallGraph {
              private newtype TCallableTrackingState =
                TNeutral() or
                TOut() or
                TSimpleCall() or
                TNonSimpleCall()

              class CallableTrackingState extends TCallableTrackingState {
                /** Holds if the value has not been tracked into or out of any calls. */
                predicate isNeutral() { this = TNeutral() }

                /** Holds if the value has been tracked out of a call, but not into a call. */
                predicate isOut() { this = TOut() }

                /**
                 * Holds if the value has been tracked into a call, not followed by any namespace reads,
                 * and not preceeded by any out steps.
                 *
                 * If a call site is reached in this state, we'll assume it acts as a callback-style call.
                 * To avoid spurious flows, we treat suchs callbacks as form of return edge.
                 */
                predicate isSimpleCall() { this = TSimpleCall() }

                /**
                 * Holds if the value has been tracked into a call, followed by a namespace reads and/or
                 * preceeded by out steps.
                 *
                 * If a call site is reached in this state, we'll generate an ordinary call edge for it.
                 */
                predicate isNonSimpleCall() { this = TNonSimpleCall() }

                pragma[nomagic]
                CallableTrackingState appendCall() {
                  this.isNeutral() and result.isSimpleCall()
                  or
                  this.isOut() and result.isNonSimpleCall()
                  or
                  this.isSimpleCall() and result = this
                  or
                  this.isNonSimpleCall() and result = this
                }

                pragma[nomagic]
                CallableTrackingState appendNamespaceRead() {
                  this.isNeutral() and result = this
                  or
                  this.isOut() and result = this
                  or
                  this.isSimpleCall() and result.isNonSimpleCall()
                  or
                  this.isNonSimpleCall() and result = this
                }

                pragma[nomagic]
                CallableTrackingState appendOut() {
                  this.isNeutral() and result.isOut()
                  or
                  this.isOut() and result = this
                }

                string toString() {
                  this.isNeutral() and result = "neutral"
                  or
                  this.isSimpleCall() and result = "simple call"
                  or
                  this.isNonSimpleCall() and result = "non-simple call"
                  or
                  this.isOut() and result = "out"
                }
              }

              private Node trackCallable(DataFlowCallable callable, CallableTrackingState state) {
                state.isNeutral() and
                result = callableInitialNode(callable.asSourceCallable())
                or
                valueStepEx(trackCallable(callable, state), result)
                or
                instanceMemberContentStepIn(trackCallable(callable, _), result) and
                state.isNonSimpleCall()
                or
                exists(CallableTrackingState prev |
                  valueStepIn(trackCallable(callable, prev), result) and
                  state = prev.appendCall()
                  or
                  instanceMemberContentStep(trackCallable(callable, prev), result) and
                  state = prev.appendNamespaceRead()
                  or
                  valueStepOut(trackCallable(callable, prev), result) and
                  state = prev.appendOut()
                )
              }

              pragma[nomagic]
              private predicate instantiateStep(Node node1, Node node2) {
                dataflowStepFinal(node1, TInstantiateStep(), node2)
              }

              Node trackNamespaceEx(NamespaceObject ns, boolean hasCall) {
                hasCall = false and
                result.isNamespaceObject(ns)
                or
                hasCall = false and
                exists(ClassLikeObject cls |
                  ns = cls.getInstancePrototype() and
                  instantiateStep(trackNamespaceEx(cls, hasCall), result)
                )
                or
                valueStepEx(trackNamespaceEx(ns, hasCall), result)
                or
                valueStepIn(trackNamespaceEx(ns, _), result) and
                hasCall = true
                or
                valueStepOut(trackNamespaceEx(ns, false), result) and
                hasCall = false
                or
                instanceMemberContentStep(trackNamespaceEx(ns, hasCall), result)
              }

              /**
               * Holds if `origin` is a store target whose aliases won't be found by namespace-tracking,
               * since no namespace flows there, e.g. because its allocation site is outside the database.
               */
              private predicate shouldTrackAdHocStoreTarget(Node origin) {
                storeContentNoCapture(trackCallable(_, _), _, origin) and
                not origin instanceof TArgumentObjectNode and
                not origin = NamespaceTracking::trackNamespace(_)
              }

              Node trackAdHocStoreTarget(Node origin, boolean hasCall) {
                shouldTrackAdHocStoreTarget(origin) and
                result = origin and
                hasCall = false
                or
                valueStepEx(trackAdHocStoreTarget(origin, hasCall), result)
                or
                instanceMemberContentStep(trackAdHocStoreTarget(origin, hasCall), result)
                or
                valueStepIn(trackAdHocStoreTarget(origin, _), result) and
                hasCall = true
                or
                valueStepOut(trackAdHocStoreTarget(origin, false), result) and
                hasCall = false
              }

              pragma[nomagic]
              private predicate adHocDerivedStep(Node node1, Node node2, boolean call) {
                exists(Content content, Node object |
                  storeContentNoCapture(node1, content, object) and
                  NamespaceTracking::readContentStep(trackAdHocStoreTarget(object, call), content,
                    node2)
                )
              }

              pragma[inline]
              private predicate valueStepEx(Node node1, Node node2) {
                NamespaceTracking::valueStepEx(node1, node2)
                or
                callSiteFlowThrough(node1, node2)
                or
                NamespaceTracking::downwardsInheritedContentStep(node1, node2)
                or
                NamespaceTracking::upwardsInheritedContentStep(node1, node2)
                or
                NamespaceTracking::localContentStep(node1, node2)
                or
                copyStep(node1, node2) and
                // With/without content steps targeting a namespace node have already been
                // handled precisely in the previous stage.
                // Propagating through the resulting copy steps without respecting clears/expects contents
                // would negate the precise handling they received in the previous stage.
                not node2 instanceof TNamespaceNode
                or
                adHocDerivedStep(node1, node2, false)
              }

              private predicate isMethodReceiverRef(Node n) {
                exists(Callable callable |
                  isMethod(callable) and
                  n = TParameterObjectNode(callable)
                )
                or
                exists(Node prev |
                  isMethodReceiverRef(prev) and
                  dataflowStepFinal(prev, TValueStep(), n)
                )
              }

              /**
               * Holds if `node1 -> node2` is a step from an instance member definition
               * to one of its uses. The instance object has not been passed into a call before the read.
               */
              predicate instanceMemberContentStep(Node node1, Node node2) {
                exists(NamespaceObject ns, Content content |
                  NamespaceTracking::namespaceHasContent(ns, content, node1) and
                  NamespaceTracking::readContentStep(trackNamespaceEx(ns, false), content, node2)
                )
              }

              /**
               * Holds if `node1 -> node2` is a step from an instance member definition
               * to one of its uses. The instance object has been passed into a call before the read.
               */
              predicate instanceMemberContentStepIn(Node node1, Node node2) {
                exists(NamespaceObject ns, Content content |
                  NamespaceTracking::namespaceHasContent(ns, content, node1) and
                  NamespaceTracking::readContentStep(trackNamespaceEx(ns, true), content, node2)
                )
                or
                adHocDerivedStep(node1, node2, true)
              }

              private Node trackParameter(DataFlowCallable callable, ParameterPosition pos) {
                parameterNodeImpl(callable.asSourceCallable(), pos, result)
                or
                exists(Node prev |
                  prev = trackParameter(callable, pos) and
                  simpleLocalFlowStep(prev, result, _)
                )
              }

              private predicate parameterFlowsToReturn(
                DataFlowCallable callable, ParameterPosition pos, ReturnKind kind
              ) {
                getReturnNodeOfKind(callable.asSourceCallable(), kind) =
                  trackParameter(callable, pos)
              }

              private predicate argumentFlowsToReturn(
                DataFlowCallable callable, ArgumentPosition apos, ReturnKind kind
              ) {
                exists(ParameterPosition ppos |
                  parameterFlowsToReturn(callable, ppos, kind) and
                  parameterMatch(ppos, apos)
                )
              }

              predicate callSiteFlowThrough(Node node1, Node node2) {
                exists(
                  DataFlowCall call, DataFlowCallable callable, ArgumentPosition apos,
                  ReturnKind kind
                |
                  callable = viableCallable(call) and
                  isArgumentNode(node1, call, apos) and
                  argumentFlowsToReturn(callable, apos, kind) and
                  node2 = getOutNodeOfKind(call, kind)
                )
                or
                exists(
                  DataFlowCall call, DataFlowCallable callable, DataFlowCallable callback,
                  ArgumentPosition callbackPos, ArgumentPosition valuePos1,
                  ParameterPosition valuePos2
                |
                  callable = viableCallable(call) and
                  callbackFlowsToArgument(call, callback, callbackPos) and
                  parameterFlowsToCallbackArgEx(callable, callbackPos, valuePos1, valuePos2) and
                  isArgumentNode(node1, call, valuePos1) and
                  isParameterNode(node2, callback, valuePos2)
                )
              }

              private predicate callbackFlowsToArgument(
                DataFlowCall call, DataFlowCallable callback, ArgumentPosition pos
              ) {
                exists(CallableTrackingState state |
                  isArgumentNode(trackCallable(callback, state), call, pos) and
                  (state.isNeutral() or state.isSimpleCall())
                )
              }

              pragma[nomagic]
              private predicate parameterFlowsToCallTarget(
                DataFlowCallable callable, ParameterPosition pos, Call call
              ) {
                trackParameter(callable, pos) = TCallTargetNode(call)
              }

              /**
               * Holds if `callable` invokes the given `callback`, passing its own parameter at `valuePos1`
               * into the callback at `valuePos2`.
               */
              pragma[nomagic]
              private predicate parameterFlowsToCallbackArg(
                DataFlowCallable callable, ParameterPosition callback, ParameterPosition valuePos1,
                ArgumentPosition valuePos2
              ) {
                exists(Call call |
                  parameterFlowsToCallTarget(callable, callback, call) and
                  argumentNodeImpl(call, valuePos2, trackParameter(callable, valuePos1)) and
                  not valuePos2 = MkFunctionSelfReferenceArgumentPosition()
                )
              }

              /**
               * Like `parameterFlowsToCallbackArg` but all arg/param positions have been flipped by `parameterMatch`.
               */
              pragma[nomagic]
              private predicate parameterFlowsToCallbackArgEx(
                DataFlowCallable callable, ArgumentPosition callback, ArgumentPosition valuePos1,
                ParameterPosition valuePos2
              ) {
                parameterFlowsToCallbackArg(callable, argToParamPos(callback),
                  argToParamPos(valuePos1), paramToArgPos(valuePos2))
              }

              pragma[nomagic]
              private predicate parameterNodeRestricted(
                Node node, DataFlowCallable callable, ParameterPosition pos
              ) {
                isParameterNode(node, callable, pos) and
                not (
                  (
                    isMethod(callable.asSourceCallable()) or
                    isInstanceInitializer(callable.asSourceCallable(), _)
                  ) and
                  pos = MkReceiverParameterPosition()
                  or
                  pos = MkFunctionSelfReferenceParameterPosition()
                )
              }

              /**
               * Holds if `node1 -> node2` is a step into a call. Flow into method receivers is blocked.
               */
              pragma[inline]
              private predicate valueStepIn(Node node1, Node node2) {
                exists(
                  DataFlowCall call, DataFlowCallable callable, ArgumentPosition apos,
                  ParameterPosition ppos
                |
                  callable = viableCallableNotCallback(call) and
                  isArgumentNode(node1, call, apos) and
                  parameterNodeRestricted(node2, callable, ppos) and
                  parameterMatch(ppos, apos)
                )
                or
                instanceMemberContentStepIn(node1, node2)
              }

              /**
               * Holds if `node1 -> node2` is a step out of a call.
               */
              pragma[inline]
              private predicate valueStepOut(Node node1, Node node2) {
                exists(DataFlowCall call, DataFlowCallable callable, ReturnKind kind |
                  callable = viableCallable(call) and
                  node1 = getReturnNodeOfKind(callable.asSourceCallable(), kind) and
                  node2 = getOutNodeOfKind(call, kind)
                )
                or
                exists(
                  DataFlowCall call, DataFlowCallable callable, ArgumentPosition apos,
                  ParameterPosition ppos
                |
                  // Parameter-passing into a callback is treated as an out-step
                  callable = viableCallableAsCallback(call) and
                  isArgumentNode(node1, call, apos) and
                  parameterNodeRestricted(node2, callable, ppos) and
                  parameterMatch(ppos, apos)
                )
              }

              private predicate accessorContentCall(
                DataFlowCall call, Node receiver, Content content, boolean isSetterCall
              ) {
                exists(ContentSet contents |
                  call.isAccessorCall(receiver, contents, _, isSetterCall) and
                  content = NamespaceTracking::getSimpleContentFromContentSet(contents)
                )
              }

              DataFlowCallable viableCallableNotCallback(DataFlowCall c) {
                exists(CallableTrackingState state |
                  trackCallable(result, state) = TCallTargetNode(c.asSourceCall()) and
                  not state.isSimpleCall()
                )
                or
                exists(Content content, NamespaceObject ns, boolean isSetterCall |
                  accessorContentCall(c, trackNamespaceEx(ns, _), content, isSetterCall)
                |
                  isSetterCall = false and
                  NamespaceTracking::namespaceHasGetter(ns, content, result.asSourceCallable())
                  or
                  isSetterCall = true and
                  NamespaceTracking::namespaceHasSetter(ns, content, result.asSourceCallable())
                )
              }

              DataFlowCallable viableCallableAsCallback(DataFlowCall c) {
                exists(CallableTrackingState state |
                  trackCallable(result, state) = TCallTargetNode(c.asSourceCall()) and
                  state.isSimpleCall()
                )
              }

              DataFlowCallable viableCallable(DataFlowCall c) {
                result = viableCallableAsCallback(c)
                or
                result = viableCallableNotCallback(c)
              }

              DataFlowCallable getCallTargetFromSourceCall(Call c) {
                result = viableCallable(MkSourceCall(c))
              }
            }

            predicate viableCallable = CallGraph::viableCallable/1;

            class Content = FinalContent;

            predicate forceHighPrecision(Content c) { none() }

            class ContentSet = FinalContentSet;

            class ContentApprox = Unit; // TODO: approx

            ContentApprox getContentApprox(Content c) { exists(c) and exists(result) }

            predicate parameterMatch(ParameterPosition param, ArgumentPosition arg) {
              arg.asContentSet().getAStoreContent() = param.asContentSet().getAReadContent()
              or
              // Pass static->dynamic and dynamic->static argument/parameter object
              arg = MkStaticArgumentObjectPosition() and
              param = MkDynamicParameterObjectPosition()
              or
              arg = MkDynamicArgumentObjectPosition() and
              param = MkStaticParameterObjectPosition()
              or
              arg = MkFunctionSelfReferenceArgumentPosition() and
              param = MkFunctionSelfReferenceParameterPosition()
              or
              arg = MkReceiverArgumentPosition() and param = MkReceiverParameterPosition()
              or
              arg = MkSetterArgumentPosition() and
              param.asContentSet().getAReadContent() = setterParameter()
            }

            private ArgumentPosition paramToArgPos(ParameterPosition pos) {
              parameterMatch(pos, result)
            }

            private ParameterPosition argToParamPos(ArgumentPosition pos) {
              parameterMatch(result, pos)
            }

            additional predicate localFlowStep(Node node1, Node node2) {
              simpleValueStep(node1, node2)
              or
              copyStep(node1, node2)
            }

            predicate simpleLocalFlowStep(Node node1, Node node2, string model) {
              localFlowStep(node1, node2) and
              sameContainer(node1, node2) and
              model = ""
            }

            predicate readStep = Steps::readStep/3;

            predicate storeStep = Steps::storeStep/3;

            predicate clearsContent(Node node, ContentSet contents) {
              node = TWithoutContentHelper(_, contents)
              or
              exists(CaptureSsa::ClosureNode closureNode, LocalVariable v |
                CaptureSsa::clearsContent(closureNode, v) and
                node = getNodeFromCaptureSsa(closureNode) and
                contents.asSingleton().asCapturedVariable() = v
              )
            }

            predicate expectsContent(Node node, ContentSet contents) {
              node = TWithContentHelper(_, contents)
            }

            bindingset[node1, node2]
            pragma[inline_late]
            additional predicate sameContainer(Node node1, Node node2) {
              nodeGetEnclosingCallable(node1) = nodeGetEnclosingCallable(node2)
            }

            predicate jumpStep(Node node1, Node node2) {
              localFlowStep(node1, node2) and
              not sameContainer(node1, node2)
            }

            class NodeRegion extends Void {
              predicate contains(Node n) { none() }
            }

            predicate isUnreachableInCall(NodeRegion nr, DataFlowCall call) { none() }

            predicate allowParameterReturnInSelf(ParameterNode p) {
              exists(Callable callable |
                p = TCallableSelfReferenceNode(callable) and
                CaptureSsa::heuristicAllowInstanceParameterReturnInSelf(callable)
              )
            }

            predicate localMustFlowStep(Node node1, Node node2) {
              none() // TODO
            }

            class LambdaCallKind = Void;

            /** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
            predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) {
              none() // TODO
            }

            /** Holds if `call` is a lambda call of kind `kind` where `receiver` is the lambda expression. */
            predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) {
              none() // TODO
            }

            /** Extra data-flow steps needed for lambda flow analysis. */
            predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) {
              none() // TODO
            }

            predicate knownSourceModel(Node source, string model) {
              none() // TODO
            }

            predicate knownSinkModel(Node sink, string model) {
              none() // TODO
            }

            class DataFlowSecondLevelScope = Void;

            additional module CallGraphOutput {
              predicate viableCallable = CallGraph::viableCallable/1;
            }
          }

          private module DataFlowMake = DataFlow::DataFlowMake<Location, DataFlowInput>;

          module DataFlowPublic {
            import DataFlowMake

            class Node = DataFlowNode;
          }

          module TaintTrackingInput implements TaintTracking::InputSig<Location, DataFlowInput> {
            predicate defaultTaintSanitizer(Node node) { none() }

            predicate defaultAdditionalTaintStep(Node src, Node sink, string model) {
              dataflowStepFinal(src, TTaintStep(), sink) and model = ""
            }

            bindingset[node]
            predicate defaultImplicitTaintRead(Node node, ContentSet c) { none() }

            predicate speculativeTaintStep(Node src, Node sink) { none() }
          }

          module TaintTrackingPublic =
            TaintTracking::TaintFlowMake<Location, DataFlowInput, TaintTrackingInput>;

          private import codeql.dataflow.internal.DataFlowImplConsistency as DataFlowImplConsistency

          private module ConsistencyConfig implements
            DataFlowImplConsistency::InputSig<Location, DataFlowInput>
          {
            predicate argHasPostUpdateExclude(DataFlowInput::ArgumentNode n) {
              n instanceof TArgumentObjectNode or
              n instanceof TDynamicArgumentObjectNode or
              n instanceof TTransformStepNode
            }
          }

          module Consistency =
            DataFlowImplConsistency::MakeConsistency<Location, DataFlowInput, TaintTrackingInput,
              ConsistencyConfig>;
        }
      }
    }
  }
}
