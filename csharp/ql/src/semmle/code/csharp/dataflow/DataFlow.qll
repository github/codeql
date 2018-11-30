/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses.
 */

import csharp

module DataFlow {
  private import semmle.code.csharp.dataflow.CallContext
  private import semmle.code.csharp.dataflow.DelegateDataFlow
  private import semmle.code.csharp.dataflow.LibraryTypeDataFlow
  private import Internal::Cached
  private import dotnet
  private import cil

  /**
   * An element, viewed as a node in a data flow graph. Either an
   * expression (`ExprNode`) or a parameter (`ParameterNode`).
   */
  class Node extends TNode {
    /** Gets the expression corresponding to this node, if any. */
    DotNet::Expr asExpr() { result = this.(ExprNode).getExpr() }

    /** Gets the parameter corresponding to this node, if any. */
    DotNet::Parameter asParameter() { result = this.(ParameterNode).getParameter() }

    /** Gets the type of this node. */
    DotNet::Type getType() { none() }

    /** Gets the enclosing callable of this node. */
    DotNet::Callable getEnclosingCallable() { none() }

    /** Gets a textual representation of this node. */
    string toString() { none() }

    /** Gets the location of this node. */
    Location getLocation() { none() }
  }

  /**
   * An expression, viewed as a node in a data flow graph.
   */
  class ExprNode extends Node, TExprNode {
    DotNet::Expr expr;

    ExprNode() { this = TExprNode(expr) }

    /** Gets the expression corresponding to this node. */
    DotNet::Expr getExpr() { result = expr }

    override DotNet::Type getType() { result = expr.getType() }

    override DotNet::Callable getEnclosingCallable() { result = expr.getEnclosingCallable() }

    override string toString() { result = expr.toString() }

    override Location getLocation() { result = expr.getLocation() }
  }

  /**
   * The value of a parameter at function entry, viewed as a node in a data
   * flow graph.
   */
  class ParameterNode extends Node {
    ParameterNode() {
      Internal::explicitParameterNode(this, _) or
      Internal::implicitCapturedParameterNode(this, _) or
      this = TCilParameterNode(_)
    }

    /** Gets the parameter corresponding to this node, if any. */
    DotNet::Parameter getParameter() { none() }
  }

  /**
   * Gets the node corresponding to expression `e`.
   */
  ExprNode exprNode(DotNet::Expr e) { result.getExpr() = e }

  /**
   * Gets the node corresponding to the value of parameter `p` at function entry.
   */
  ParameterNode parameterNode(DotNet::Parameter p) { result.getParameter() = p }

  /**
   * Holds if data flows from `source` to `sink` in zero or more local
   * (intra-procedural) steps.
   */
  predicate localFlow(Node source, Node sink) {
    localFlowStep*(source, sink)
  }

  predicate localFlowStep = localFlowStepCached/2;

  /**
   * A data flow node augmented with a call context and a configuration. Only
   * nodes that are reachable from a source, and which can reach a sink, are
   * generated.
   */
  class PathNode extends Internal::TFlowGraphNode {
    Node node;
    Configuration config;

    PathNode() {
      this = Internal::TFlowGraphNode0(node, _, config) and
      config.isSink(this.(Internal::FlowGraphNode).getASuccessor*().getNode())
    }

    /** Gets a textual representation of this path node. */
    string toString() { result = getNode().toString() }

    /** Gets the location of this path node. */
    Location getLocation() { result = getNode().getLocation() }

    /** Gets the underlying data flow node. */
    Node getNode() { result = node }

    /** Gets the associated configuration. */
    Configuration getConfiguration() { result = config }

    /** Gets a successor path node, if any. */
    PathNode getASuccessor() {
      result = this.(Internal::FlowGraphNode).getASuccessor()
    }
  }

  /**
   * Provides the query predicates needed to include a graph in a path-problem query.
   */
  module PathGraph {
    /** Holds if `(a,b)` is an edge in the graph of data flow path explanations. */
    query predicate edges(PathNode a, PathNode b) { a.getASuccessor() = b }

    /** Holds if `node` is a node in the graph of data flow path explanations. */
    query predicate nodes(PathNode node) { any() }
  }

  /**
   * A global (inter-procedural) data flow configuration.
   *
   * Each use of the global data flow library must define its own unique extension
   * of this abstract class. A configuration defines a set of relevant sources
   * (`isSource`) and sinks (`isSink`), and may additionally prohibit intermediate
   * flow nodes (`isBarrier`) as well as add custom data flow steps
   * (`isAdditionalFlowStep()`).
   *
   * In addition to tracking flow through ordinary callables (for example methods
   * and accessors), the global data flow algorithm tracks flow through delegate
   * calls as well. However, for non-locally resolvable delegate calls the algorithm
   * takes only call contexts of height at most one into account. Example:
   *
   * ```
   * public int M(Func<string, int> f, string x) {
   *   return f(x);
   * }
   *
   * M(x => x.Length, ...);
   *
   * M(_ => 42, ...);
   * ```
   *
   * In the body of `M` on line 2, `f` can be resolved to the delegates
   * `x => x.Length` (line 5) and `_ => 42` (line 7), requiring different call
   * contexts. The algorithm is able to distinguish which of the two delegates
   * are applicable based on the current call context (that is, if `M` is called
   * via line 5, only the delegate `x => x.Length` is applicable, and vice versa
   * for line 7). However, if `M` is instead defined as:
   *
   * ```
   * public int M(Func<string, int> f, string x) {
   *   return M2(f, x);
   * }
   *
   * public int M2(Func<string, int> f, string x) {
   *   return f(x);
   * }
   *
   * M(x => x.Length, ...);
   *
   * M(_ => 42, ...);
   * ```
   *
   * then both delegates from lines 9 and 11 will (incorrectly) be considered valid,
   * as the last call required for resolving `f` on line 6 is in both cases the call
   * on line 2.
   */
  abstract class Configuration extends string {
    bindingset[this]
    Configuration() { any() }

    /**
     * Holds if `source` is a relevant data flow source.
     *
     * The smaller this predicate is, the faster `hasFlow()` will converge.
     */
    abstract predicate isSource(Node source);

    /**
     * Holds if `sink` is a relevant data flow sink.
     *
     * The smaller this predicate is, the faster `hasFlow()` will converge.
     */
    abstract predicate isSink(Node sink);

    /** Holds if the intermediate data flow node `node` is prohibited. */
    predicate isBarrier(Node node) { none() }

    /**
     * Holds if the additional flow step from `pred` to `succ` must be taken
     * into account in the analysis.
     */
    predicate isAdditionalFlowStep(Node pred, Node succ) { none() }

    /**
     * INTERNAL: Do not use.
     *
     * Holds if the additional flow step from argument `arg` to parameter
     * `p` via call `call` must be taken into account in the analysis, but
     * only in call context `cc`.
     */
    predicate isAdditionalFlowStepIntoCall(Node call, Node arg, DotNet::Parameter p, CallContext cc) { none() }

    /**
     * INTERNAL: Do not use.
     *
     * Holds if the additional flow step from `ret` to `out` out of the call
     * `call` must be taken into account in the analysis, but only in call
     * context `cc`.
     */
    predicate isAdditionalFlowStepOutOfCall(Node call, Node ret, Node out, CallContext cc) { none() }

    /**
     * Holds if data may flow from `source` to `sink` for this configuration.
     */
    predicate hasFlow(Node source, Node sink) {
      Internal::flowsTo(_, source, _, sink, this)
    }

    /**
     * Holds if data may flow from `source` to `sink` for this configuration.
     *
     * The corresponding paths are generated from the end-points and the graph
     * included in the module `PathGraph`.
     */
    predicate hasFlowPath(PathNode source, PathNode sink) {
      Internal::flowsTo(source, _, sink, _, this)
    }
  }

  /**
   * INTERNAL: Do not use.
   */
  module Internal {
    private import semmle.code.csharp.dataflow.DelegateDataFlow
    private import semmle.code.csharp.dispatch.Dispatch

    /** An SSA definition, viewed as a node in a data flow graph. */
    class SsaDefinitionNode extends Node, TSsaDefinitionNode {
      Ssa::Definition def;

      SsaDefinitionNode() { this = TSsaDefinitionNode(def) }

      /** Gets the underlying SSA definition. */
      Ssa::Definition getDefinition() { result = def }

      override Type getType() { result = def.getSourceVariable().getType() }

      override Callable getEnclosingCallable() {
        result = def.getSourceVariable().getEnclosingCallable()
      }

      override string toString() {
        result = def.toString() and
        not this instanceof ExplicitParameterNode
      }

      override Location getLocation() { result = def.getLocation() }
    }

    /**
     * Holds if SSA definition node `node` is an entry definition for parameter `p`.
     */
    predicate explicitParameterNode(SsaDefinitionNode node, Parameter p) {
      exists(Ssa::ExplicitDefinition def, AssignableDefinitions::ImplicitParameterDefinition pdef |
        node = TSsaDefinitionNode(def) |
        pdef = def.getADefinition() and
        p = pdef.getParameter()
      )
    }

    /**
     * The value of an explicit parameter at function entry, viewed as a node in a data
     * flow graph.
     */
    class ExplicitParameterNode extends ParameterNode {
      DotNet::Parameter parameter;

      ExplicitParameterNode() {
        explicitParameterNode(this, parameter) or
        this = TCilParameterNode(parameter)
      }

      override DotNet::Parameter getParameter() { result = parameter }

      override DotNet::Type getType() { result = parameter.getType() }

      override DotNet::Callable getEnclosingCallable() { result = parameter.getCallable() }

      override string toString() { result = parameter.toString() }

      override Location getLocation() { result = parameter.getLocation() }
    }

    /**
     * Holds if SSA definition node `node` is an implicit entry definition for
     * captured local scope variable `v`.
     */
    predicate implicitCapturedParameterNode(SsaDefinitionNode node, LocalScopeVariable v) {
      exists(Ssa::ImplicitEntryDefinition def |
        node = TSsaDefinitionNode(def) |
        def.getSourceVariable().getAssignable() = v
      )
    }

    /**
     * The value of an implicit captured variable parameter at function entry,
     * viewed as a node in a data flow graph.
     *
     * An implicit parameter is added in order to be able to track flow into
     * capturing callables, as if an explicit `ref` parameter had been used:
     *
     * ```
     * void M() {             void M() {
     *   int i = 0;             int i = 0;
     *   void In() {    =>      void In(ref int i0) { // implicit i0 parameter
     *     Use(i);                Use(i0);
     *   }                      }
     *   In();                  In(ref i);
     * }                      }
     * ```
     */
    private class ImplicitCapturedParameterNode extends ParameterNode, SsaDefinitionNode {
      LocalScopeVariable v;

      ImplicitCapturedParameterNode() { implicitCapturedParameterNode(this, v) }

      /** Gets the captured variable that this implicit parameter models. */
      LocalScopeVariable getVariable() { result = v }
    }

    /** A data flow node that represents a call. */
    private abstract class CallNode extends Node {
      DotNet::Expr call;

      /** Gets the underlying call expression. */
      DotNet::Expr getCall() { result = call }

      /**
       * Gets the argument call context corresponding to the `i`th argument
       * of this call.
       */
      ArgumentCallContext getCallContext(int i) {
        result.isArgument(call, i)
      }

      /**
       * Gets the argument call context corresponding to the implicit parameter for
       * captured variable `v`, if any.
       */
      ImplicitCapturedArgumentNode getImplicitCapturedArgument(LocalScopeVariable v) {
        result = TImplicitCapturedArgumentNode(call, v)
      }
    }

    /** A data flow node that represents an explicit call. */
    private class ExplicitCallNode extends CallNode, ExprNode {
      ExplicitCallNode() {
        call = this.getExpr()
        and
        (call instanceof NonDelegateCall or call instanceof DelegateCall)
      }
    }

    /**
     * A data flow node that represents an implicit call to a delegate in a call
     * to a library callable. For example, the implicit call to `M` in
     * `new Lazy<int>(M)`.
     */
    class ImplicitDelegateCallNode extends CallNode, OutNode, TImplicitDelegateCallNode {
      DelegateArgumentToLibraryCallable arg;

      ImplicitDelegateCallNode() {
        this = TImplicitDelegateCallNode(arg) and
        call = arg
      }

      /** Gets the delegate argument that is called implicitly. */
      DelegateArgumentToLibraryCallable getArgument() { result = arg }

      override Type getType() { result = arg.getType() }

      override Callable getEnclosingCallable() { result = arg.getEnclosingCallable() }

      override string toString() { result = "[implicit call] " + arg.toString() }

      override Location getLocation() { result = arg.getLocation() }
    }

    /** A data flow node that represents the output of a call. */
    private abstract class OutNode extends Node { }

    /**
     * A data flow node that represents the explicit output of a call.
     *
     * Either a call or an SSA definition for an `out`/`ref` argument.
     */
    private class ExplicitOutNode extends OutNode {
      ExplicitOutNode() {
        exists(DotNet::Expr e |
          e = this.asExpr() and
          not e.getType() instanceof VoidType |
          e instanceof NonDelegateCall or
          e instanceof DelegateCall
        )
        or
        this.(SsaDefinitionNode).getDefinition() = any(Ssa::ExplicitDefinition def |
          def.getADefinition() instanceof AssignableDefinitions::OutRefDefinition
        )
      }
    }

    /**
     * The value of a captured variable after a call, viewed as a node in a data
     * flow graph.
     *
     * An implicit node is added in order to be able to track flow out of
     * capturing callables, as if an explicit `ref` parameter had been used:
     *
     * ```
     * void M() {                       void M() {
     *   int i = 0;                       int i = 0;
     *   void Out() { i = 1; }    =>      void Out(ref int i0) { i0 = 1; }
     *   Out();                           Out(ref i); // implicit out node
     *   Use(i);                          Use(i)
     * }                                }
     * ```
     */
    private class ImplicitCapturedOutNode extends OutNode, SsaDefinitionNode {
      Ssa::ImplicitCallDefinition cdef;

      ImplicitCapturedOutNode() {
        cdef = this.getDefinition() and
        cdef.getSourceVariable().getAssignable() instanceof LocalScopeVariable
      }

      /** Gets the call that this implicit definition belongs to. */
      Call getCall() { result = cdef.getCall() }
    }

    /** A data flow node that represents a call argument. */
    private abstract class ArgumentNode extends Node {
      /** Gets the context corresponding to this argument node. */
      bindingset [config]
      abstract ArgumentContext getContext(Configuration config);
    }

    /** A data flow node that represents an explicit call argument. */
    private class ExplicitArgumentNode extends ArgumentNode {
      ExplicitArgumentNode() {
        exists(DotNet::Expr e |
          e = this.asExpr() |
          e = any(NonDelegateCall ndc).getArgument(_) or
          e = any(DelegateCall dc).getAnArgument()
        )
        or
        this instanceof ImplicitDelegateCallNode
      }

      /**
       * Holds if this argument occurs at position `pos` in call `call`.
       */
      predicate isArgumentOf(CallNode call, int pos, Configuration config) {
        exists(ExplicitParameterNode p |
          flowIntoCallableStep(call, this, p, _, config) |
          pos = p.getParameter().getPosition()
        )
      }

      /**
       * Gets the argument call context corresponding to this explicit argument.
       */
      ArgumentCallContext getArgumentCallContext(Configuration config) {
        exists(CallNode call, int pos |
           this.isArgumentOf(call, pos, config) |
           result = call.getCallContext(pos)
         )
      }

      bindingset [config]
      override ExplicitArgumentContext getContext(Configuration config) {
        result.getCallContext() = this.getArgumentCallContext(config)
      }
    }

    /**
     * The value of a captured variable as an implicit argument of a call, viewed
     * as a node in a data flow graph.
     *
     * An implicit node is added in order to be able to track flow into capturing
     * callables, as if an explicit parameter had been used:
     *
     * ```
     * void M() {                       void M() {
     *   int i = 0;                       int i = 0;
     *   void Out() { i = 1; }    =>      void Out(ref int i0) { i0 = 1; }
     *   Out();                           Out(ref i); // implicit argument
     *   Use(i);                          Use(i)
     * }                                }
     * ```
     */
    private class ImplicitCapturedArgumentNode extends ArgumentNode, TImplicitCapturedArgumentNode {
      Call c;
      LocalScopeVariable v;

      ImplicitCapturedArgumentNode() { this = TImplicitCapturedArgumentNode(c, v) }

      /** Gets the call that this implicit argument belongs to. */
      Call getCall() { result = c }

      /** Gets the captured variable that is passed by this implicit argument. */
      LocalScopeVariable getVariable() { result = v }

      /**
       * Holds if the value at this node may flow into the entry definition `def`,
       * using one or more calls.
       */
      predicate flowsIn(Ssa::ImplicitEntryDefinition def) {
        exists(Ssa::ExplicitDefinition edef |
          edef.isCapturedVariableDefinitionFlowIn(def, c) |
          v = def.getSourceVariable().getAssignable()
        )
      }

      bindingset [config]
      override ImplicitCapturedArgumentContext getContext(Configuration config) {
        result.getArgument() = this and
        exists(config) // eliminate warning
      }

      override Type getType() { result = v.getType() }

      override Callable getEnclosingCallable() { result = c.getEnclosingCallable() }

      override string toString() { result = v + " [implicit argument]" }

      override Location getLocation() { result = c.getLocation() }
    }

    /**
     * A data flow node that represents a value returned by a callable.
     */
    private abstract class ReturnNode extends Node { }

    /**
     * A data flow node that represents an expression returned explicitly by a callable.
     * Either an argument of `return`/`yield return` or an expression assigned to an
     * `out`/`ref` parameter.
     */
    private class ExplicitReturnNode extends ReturnNode, ExprNode {
      ExplicitReturnNode() {
        exists(DotNet::Callable c, DotNet::Expr e |
          e = this.getExpr() |
          c.canReturn(e) or
          c.(Callable).canYieldReturn(e) or
          callableReturnsOutOrRef(c, _, e)
        )
      }
    }

    /**
     * The value of a captured variable as an implicit return from a call, viewed
     * as a node in a data flow graph.
     *
     * An implicit node is added in order to be able to track flow out of capturing
     * callables, as if an explicit `ref` parameter had been used:
     *
     * ```
     * void M() {              void M() {
     *   int i = 0;              int i = 0;
     *   void Out() {            void Out(ref int i0) {
     *     i = 1;        =>         i0 = 1; // implicit return
     *   }                       }
     *   Out();                  Out(ref i);
     *   Use(i);                 Use(i)
     * }                       }
     * ```
     */
    private class ImplicitCapturedReturnNode extends ReturnNode, SsaDefinitionNode {
      Ssa::ExplicitDefinition edef;

      ImplicitCapturedReturnNode() {
        edef = this.getDefinition() and
        edef.isCapturedVariableDefinitionFlowOut(_)
      }

      /**
       * Holds if the value at this node may flow out to the implicit call definition
       * `cdef`, using one or more calls.
       */
      predicate flowsOut(Ssa::ImplicitCallDefinition cdef) {
        edef.isCapturedVariableDefinitionFlowOut(cdef)
      }
    }

   /**
    * Gets a source declaration of callable `c` that has a body.
    * If the callable has both CIL and source code, return only the source
    * code version.
    */
    private DotNet::Callable getCallableForDataFlow(DotNet::Callable c) {
      result.hasBody()
      and
      exists(DotNet::Callable sourceDecl |
        sourceDecl = c.getSourceDeclaration() |
        if sourceDecl.getFile().fromSource() then
          // C# callable with C# implementation in the database
          result = sourceDecl
        else if sourceDecl instanceof CIL::Callable then
          // CIL callable with C# implementation in the database
          sourceDecl.matchesHandle(result.(Callable))
          or
          // CIL callable without C# implementation in the database
          not sourceDecl.matchesHandle(any(Callable k)) and
          result = sourceDecl
        else
          // C# callable without C# implementation in the database
          sourceDecl.matchesHandle(result.(CIL::Callable))
      )
    }

    /**
     * A non-delegate call. Either a C# call or a CIL call.
     */
    private abstract class NonDelegateCall extends DotNet::Expr {
      /**
       * Gets a run-time target of this call. A target is always a source
       * declaration, and if the callable has both CIL and source code, only
       * the source code version is returned.
       */
      abstract DotNet::Callable getARuntimeTarget();

      /** Gets the `i`th argument of this call. */
      abstract DotNet::Expr getArgument(int i);
    }

    private class CSharpCall extends NonDelegateCall, Expr {
      DispatchCall dc;

      CSharpCall() {
        this = dc.getCall()
      }

      override DotNet::Callable getARuntimeTarget() {
        result = getCallableForDataFlow(dc.getADynamicTarget())
      }

      override Expr getArgument(int i) {
        result = dc.getArgument(i)
      }
    }

    private class CilCall extends NonDelegateCall {
      CIL::Call call;

      CilCall() {
        call = this and
        // No need to include calls that are compiled from source
        not call.getImplementation().getMethod().compiledFromSource()
      }

      override DotNet::Callable getARuntimeTarget() {
        result = getCallableForDataFlow(call.getTarget().getAnOverrider*())
      }

      override CIL::Expr getArgument(int i) {
        result = call.getArgument(i)
      }
    }

    /**
     * Provides predicates related to local data flow.
     */
    private module LocalFlow {
      /**
       * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
       * (intra-procedural) step.
       */
      predicate localFlowStepNonCached(Node nodeFrom, Node nodeTo) {
        localFlowStepExpr(nodeFrom.asExpr(), nodeTo.asExpr())
        or
        // Flow from source to SSA definition
        exists(Ssa::ExplicitDefinition def |
          def.getADefinition().getSource() = nodeFrom.asExpr() |
          nodeTo.(SsaDefinitionNode).getDefinition() = def
        )
        or
        // Flow from SSA definition to first read
        exists(Ssa::Definition def |
          def = nodeFrom.(SsaDefinitionNode).getDefinition() |
          nodeTo.asExpr() = def.getAFirstRead()
        )
        or
        // Flow into SSA pseudo definition
        exists(Ssa::Definition def, Ssa::PseudoDefinition pseudo |
          localFlowSsaInput(nodeFrom, def) |
          pseudo = nodeTo.(SsaDefinitionNode).getDefinition() and
          def = pseudo.getAnInput()
        )
        or
        // Flow into uncertain SSA definition
        exists(Ssa::Definition def, UncertainExplicitSsaDefinition uncertain |
          localFlowSsaInput(nodeFrom, def) |
          uncertain = nodeTo.(SsaDefinitionNode).getDefinition() and
          def = uncertain.getPriorDefinition()
        )
        or
        localFlowCapturedVarStep(nodeFrom, nodeTo)
        or
        Internal::flowOutOfDelegateLibraryCall(nodeFrom, nodeTo, true)
        or
        localFlowStepCil(nodeFrom, nodeTo)
      }

      private CIL::DataFlowNode asCilDataFlowNode(Node node) {
        result = node.asParameter() or
        result = node.asExpr()
      }

      predicate localFlowStepCil(Node nodeFrom, Node nodeTo) {
        asCilDataFlowNode(nodeFrom).getALocalFlowSucc(asCilDataFlowNode(nodeTo), any(CIL::Untainted t))
      }

      /**
       * An uncertain SSA definition. Either an uncertain explicit definition, or an
       * uncertain qualifier definition.
       *
       * Restricts `Ssa::UncertainDefinition` by excluding implicit call definitions,
       * as we -- conservatively -- consider such definitions to be certain.
       */
      private class UncertainExplicitSsaDefinition extends Ssa::UncertainDefinition {
        UncertainExplicitSsaDefinition() {
          this instanceof Ssa::ExplicitDefinition
          or
          this = any(Ssa::ImplicitQualifierDefinition qdef |
            qdef.getQualifierDefinition() instanceof UncertainExplicitSsaDefinition
          )
        }
      }

      /**
       * Holds if `nodeFrom` is a last node referencing SSA definition `def`.
       * Either an SSA definition node for `def` when there is no read of `def`,
       * or a last read of `def`.
       */
      private predicate localFlowSsaInput(Node nodeFrom, Ssa::Definition def) {
        def = nodeFrom.(SsaDefinitionNode).getDefinition() and
        not exists(def.getARead())
        or
        exists(AssignableRead read |
          read = nodeFrom.asExpr() |
          def.getALastRead() = read
        )
      }

      private predicate localFlowCapturedVarStep(SsaDefinitionNode nodeFrom, ImplicitCapturedArgumentNode nodeTo) {
        // Flow from SSA definition to implicit captured variable argument
        exists(Ssa::ExplicitDefinition def, Call call |
          def = nodeFrom.getDefinition() |
          def.isCapturedVariableDefinitionFlowIn(_, call) and
          nodeTo = TImplicitCapturedArgumentNode(call, def.getSourceVariable().getAssignable())
        )
      }

      private predicate localFlowStepExpr(Expr exprFrom, Expr exprTo) {
        // Flow using library code
        libraryFlow(exprFrom, exprTo, true)
        or
        // Flow from read to next read
        exprTo = exprFrom.(AssignableRead).getANextRead()
        or
        exprFrom = exprTo.(ParenthesizedExpr).getExpr()
        or
        exprTo = any(ConditionalExpr ce |
          exprFrom = ce.getThen() or
          exprFrom = ce.getElse()
        )
        or
        exprFrom = exprTo.(Cast).getExpr()
        or
        exprFrom = exprTo.(AwaitExpr).getExpr()
        or
        // An `=` expression, where the result of the expression is used
        exprTo = any(AssignExpr ae |
          ae.getParent() instanceof Expr and
          exprFrom = ae.getRValue()
        )
      }

      predicate localFlowStepNoConfig(Node pred, Node succ) {
        localFlowStep(pred, succ) or
        flowThroughCallableLibraryOutRef(_, pred.asExpr(), succ, true)
      }

      /**
       * Holds if data may flow in one local step from `pred` to `succ`.
       */
      bindingset [config]
      predicate localFlowStep(Node pred, Node succ, Configuration config) {
        localFlowStepNoConfig(pred, succ) or
        config.isAdditionalFlowStep(pred, succ)
      }

      /**
       * Holds if `node` can be the first node in a maximal subsequence of local
       * flow steps in a data flow path.
       */
      private predicate localFlowEntry(Node node, Configuration config) {
        Pruning::nodeCand(node, config) and
        (
          config.isSource(node) or
          jumpStep(_, node) or
          node instanceof ParameterNode or
          node instanceof OutNode
        )
      }

      /**
       * Holds if `node` can be the last node in a maximal subsequence of local
       * flow steps in a data flow path.
       */
      predicate localFlowExit(Node node, Configuration config) {
        Pruning::nodeCand(node, config) and
        (
          jumpStep(node, _) or
          node instanceof ArgumentNode or
          node instanceof ReturnNode or
          config.isSink(node)
        )
      }

      pragma [noinline]
      private predicate localFlowStepCand(Node node1, Node node2, Configuration config) {
        localFlowStep(node1, node2, config) and
        Pruning::nodeCand(node2, config)
      }

      /**
       * Holds if the local path from `node1` to `node2` is a prefix of a maximal
       * subsequence of local flow steps in a data flow path.
       *
       * This is the transitive closure of `localFlowStep` beginning at
       * `localFlowEntry`.
       */
      private predicate localFlowStepPlus(Node node1, Node node2, Configuration config) {
        localFlowEntry(node1, config) and
        localFlowStepCand(node1, node2, config)
        or
        exists(Node mid |
          localFlowStepPlus(node1, mid, config) and
          localFlowStepCand(mid, node2, config)
        )
      }

      /**
       * Holds if `node1` can step to `node2` in one or more local steps and this
       * path can occur as a maximal subsequence of local steps in a data flow path.
       */
      pragma [noinline]
      predicate localFlowBigStep(Node node1, Node node2, Configuration config) {
        localFlowStepPlus(node1, node2, config) and
        localFlowExit(node2, config)
      }
    }

    /**
     * Provides predicates for pruning the data flow graph, by only including
     * nodes that may potentially be reached in flow from some source to some
     * sink.
     */
    private module Pruning {
      /**
       * Holds if `node` is reachable from a source in the configuration `config`,
       * ignoring call contexts.
       */
      private predicate nodeCandFwd1(Node node, Configuration config) {
        not config.isBarrier(node) and
        (
          config.isSource(node)
          or
          exists(Node mid |
            nodeCandFwd1(mid, config) |
            LocalFlow::localFlowStep(mid, node, config)
          )
          or
          exists(Node mid |
            nodeCandFwd1(mid, config) |
            jumpStep(mid, node)
          )
          or
          exists(ArgumentNode arg |
            nodeCandFwd1(arg, config) |
            flowIntoCallableStep(_, arg, node, _, config)
          )
          or
          exists(Node mid |
            nodeCandFwd1(mid, config) |
            flowOutOfCallableStep(_, mid, node, _, config)
          )
        )
      }

      /**
       * Holds if `node` is part of a path from a source to a sink in the
       * configuration `config`, ignoring call contexts.
       */
      private predicate nodeCand1(Node node, Configuration config) {
        nodeCandFwd1(node, config) and
        (
          config.isSink(node)
          or
          exists(Node mid |
            nodeCand1(mid, config) |
            LocalFlow::localFlowStep(node, mid, config)
          )
          or
          exists(Node mid |
            nodeCand1(mid, config) |
            jumpStep(node, mid)
          )
          or
          exists(ParameterNode p |
            nodeCand1(p, config) |
            flowIntoCallableStep(_, node, p, _, config)
          )
          or
          exists(Node mid |
            nodeCand1(mid, config) |
            flowOutOfCallableStep(_, node, mid, _, config)
          )
        )
      }

      /**
       * Holds if there is a path from `p` to `node` in the same callable that is
       * part of a path from a source to a sink, taking simple call contexts into
       * consideration.
       */
      private predicate simpleParameterFlow(ParameterNode p, Node node, Configuration config) {
        nodeCand1(node, config) and
        p = node
        or
        exists(Node mid |
          simpleParameterFlow(p, mid, config) |
          nodeCand1(mid, config) and
          LocalFlow::localFlowStep(mid, node, config)
        )
        or
        exists(ArgumentNode arg |
          simpleParameterFlow(p, arg, config) |
          nodeCand1(arg, config) and
          simpleArgumentFlowsThrough(arg, node, config)
        )
      }

      /**
       * Holds if there is a path from `arg` through a call to `out` that is
       * part of a path from a source to a sink, taking simple call contexts into
       * consideration.
       */
      private predicate simpleArgumentFlowsThrough(ArgumentNode arg, OutNode out, Configuration config) {
        exists(CallNode call, ParameterNode p, ReturnNode ret |
          simpleParameterFlow(p, ret, config) |
          flowIntoCallableStepCand1(call, arg, p, config) and
          flowOutOfCallableStepCand1(call, ret, out, config)
        )
      }

      pragma [noinline]
      private predicate localFlowStepCand1(Node pred, Node succ, Configuration config) {
        nodeCand1(succ, config) and
        LocalFlow::localFlowStep(pred, succ, config)
      }

      pragma [noinline]
      predicate flowIntoCallableStepCand1(CallNode call, ArgumentNode arg, ParameterNode p, Configuration config) {
        nodeCand1(p, config) and
        flowIntoCallableStep(call, arg, p, _, config)
      }

      pragma [noinline]
      private predicate flowOutOfCallableStepCand1(CallNode call, ReturnNode ret, OutNode out, Configuration config) {
        nodeCand1(out, config) and
        flowOutOfCallableStep(call, ret, out, _, config)
      }

      /**
       * Holds if `node` is part of a path from a source to a sink in the
       * configuration `config`, taking simple call contexts into consideration.
       */
      private predicate nodeCandFwd2(Node node, boolean fromArg, Configuration config) {
        nodeCand1(node, config) and
        config.isSource(node) and
        fromArg = false
        or
        exists(Node mid |
          nodeCandFwd2(mid, fromArg, config) |
          localFlowStepCand1(mid, node, config)
        )
        or
        nodeCand1(node, config) and
        exists(Node mid |
          nodeCandFwd2(mid, _, config) |
          jumpStep(mid, node) and
          fromArg = false
        )
        or
        exists(ArgumentNode arg |
          nodeCandFwd2(arg, _, config) |
          flowIntoCallableStepCand1(_, arg, node, config) and
          fromArg = true
        )
        or
        exists(ReturnNode ret |
          nodeCandFwd2(ret, false, config) |
          flowOutOfCallableStepCand1(_, ret, node, config) and
          fromArg = false
        )
        or
        exists(ArgumentNode arg |
          nodeCandFwd2(arg, fromArg, config) |
          simpleArgumentFlowsThrough(arg, node, config)
        )
      }

      pragma [noinline]
      private predicate localFlowStepCandFwd2(Node pred, Node succ, Configuration config) {
        nodeCandFwd2(pred, _, config) and
        LocalFlow::localFlowStep(pred, succ, config)
      }

      pragma [noinline]
      private predicate flowIntoCallableStepCandFwd2(ArgumentNode arg, ParameterNode p, Configuration config) {
        nodeCandFwd2(arg, _, config) and
        flowIntoCallableStep(_, arg, p, _, config)
      }

      pragma [noinline]
      private predicate flowOutOfCallableStepCandFwd2(CallNode call, ReturnNode ret, OutNode out, CallContext cc, Configuration config) {
        nodeCandFwd2(ret, _, config) and
        flowOutOfCallableStep(call, ret, out, cc, config)
      }

      /**
       * Holds if `node` is part of a path from a source to a sink in the
       * configuration `config`, taking simple call contexts into consideration.
       */
      private predicate nodeCand2(Node node, boolean isReturned, Configuration config) {
        nodeCandFwd2(node, _, config) and
        config.isSink(node) and
        isReturned = false
        or
        exists(Node mid |
          nodeCand2(mid, isReturned, config) |
          localFlowStepCandFwd2(node, mid, config)
        )
        or
        nodeCandFwd2(node, _, config) and
        exists(Node mid |
          nodeCand2(mid, _, config) |
          jumpStep(node, mid) and
          isReturned = false
        )
        or
        exists(ParameterNode param |
          nodeCand2(param, false, config) |
          flowIntoCallableStepCandFwd2(node, param, config) and
          isReturned = false
        )
        or
        exists(OutNode out |
          nodeCand2(out, _, config) |
          flowOutOfCallableStepCandFwd2(_, node, out, _, config) and
          isReturned = true
        )
        or
        nodeCandFwd2(node, _, config) and
        exists(OutNode out |
          nodeCand2(out, isReturned, config) |
          simpleArgumentFlowsThrough(node, out, config)
        )
      }

      /**
       * Holds if `node` is part of a path from a source to a sink in the
       * configuration `config`, taking simple call contexts into consideration.
       */
      predicate nodeCand(Node node, Configuration config) {
        nodeCand2(node, _, config)
      }
    }

    // A workaround to avoid eager joining on configurations
    private bindingset[config, result] Configuration unbind(Configuration config) {
      result >= config and result <= config
    }

    /**
     * A collection of cached types and predicates to be evaluated in the
     * same stage.
     */
    cached module Cached {
      cached newtype TNode =
        TExprNode(DotNet::Expr e)
        or
        TSsaDefinitionNode(Ssa::Definition def)
        or
        TCilParameterNode(CIL::Parameter p) {
          p.getMethod().hasBody()
        }
        or
        TImplicitDelegateCallNode(DelegateArgumentToLibraryCallable arg)
        or
        TImplicitCapturedArgumentNode(Call c, LocalScopeVariable v) {
          exists(Ssa::ExplicitDefinition def |
            def.isCapturedVariableDefinitionFlowIn(_, c) |
            v = def.getSourceVariable().getAssignable()
          )
        }

      /**
       * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
       * (intra-procedural) step.
       */
      cached predicate localFlowStepCached(Node nodeFrom, Node nodeTo) {
        LocalFlow::localFlowStepNonCached(nodeFrom, nodeTo)
      }

      /**
       * Holds if `pred` can flow to `succ`, by jumping from one callable to
       * another.
       */
      cached predicate jumpStep(ExprNode pred, ExprNode succ) {
        exists(FieldLike fl, FieldLikeRead flr |
          fl.isStatic() |
          fl.getAnAssignedValue() = pred.getExpr() and
          fl.getAnAccess() = flr and
          flr = succ.getExpr() and
          hasNonlocalValue(flr)
        )
      }

      /**
       * Holds if `arg` is an argument of the call `call`, which resolves
       * to a callable with corresponding parameter `p`. The call context
       * `cc` stipulates the call required to resolve the callable, if any.
       *
       * Additional steps specified by the configuration are *not* taken into
       * account.
       */
      cached predicate flowIntoCallableStepNoConfig(CallNode call, ArgumentNode arg, ParameterNode p, CallContext cc) {
        flowIntoCallableExplicitStep(call, arg, p.getParameter(), cc)
        or
        flowIntoCallableCapturedVarStep(call, arg, p) and
        cc instanceof EmptyCallContext
      }

      private predicate flowIntoCallableExplicitStep(CallNode call, ArgumentNode arg, DotNet::Parameter p, CallContext cc) {
        flowIntoCallableNonDelegateCall(call.asExpr(), arg.asExpr(), p) and
        cc instanceof EmptyCallContext
        or
        flowIntoCallableDelegateCall(call.asExpr(), arg.asExpr(), p, cc)
        or
        flowIntoCallableLibraryCall(_, arg, call, p, true, cc)
      }

      /**
       * Holds if `arg` is an implicit captured variable argument of the call
       * `call`, which can reach implicit captured variable parameter `p`, using
       * zero or more additional calls.
       */
      private predicate flowIntoCallableCapturedVarStep(CallNode call, ImplicitCapturedArgumentNode arg, ImplicitCapturedParameterNode p) {
        arg.flowsIn(p.getDefinition()) and
        call.asExpr() = arg.getCall()
      }

      /**
       * Holds if `ret` is an expression returned by a callable to which the call
       * `call` resolves, and `out` is the corresponding output (either `call`
       * itself or an `out`/`ref` argument).
       *
       * Additional steps specified by the configuration are *not* taken into
       * account.
       */
      cached predicate flowOutOfCallableStepNoConfig(CallNode call, ReturnNode ret, OutNode out, CallContext cc) {
        flowOutOfCallableExplicitStep(call, ret, out, cc)
        or
        flowOutOfCallableCapturedVarStep(call, ret, out) and
        cc instanceof EmptyCallContext
      }

      private predicate flowOutOfCallableExplicitStep(CallNode call, ReturnNode ret, OutNode out, CallContext cc) {
        flowOutOfCallableNonDelegateCall(call.asExpr(), ret.asExpr(), out) and
        cc instanceof EmptyCallContext
        or
        flowOutOfCallableDelegateCall(call, ret.asExpr(), cc) and
        out = call
      }

      /**
       * Holds if `ret` is an expression returned implicitly by a callable, from
       * `call` using zero or more additional calls, and `out` is the corresponding
       * implicit output.
       */
      private predicate flowOutOfCallableCapturedVarStep(CallNode call, ImplicitCapturedReturnNode ret, ImplicitCapturedOutNode out) {
        ret.flowsOut(out.getDefinition()) and
        call.asExpr() = out.getCall()
      }
    }

    private newtype TContext =
      TNoContext()
      or
      TExplicitArgumentContext(ArgumentCallContext acc) {
        exists(ExplicitArgumentNode arg, Configuration config |
          Pruning::nodeCand(arg, config) |
          acc = arg.getArgumentCallContext(config)
        )
      }
      or
      TImplicitCapturedArgumentContext(ImplicitCapturedArgumentNode arg) {
        Pruning::nodeCand(arg, _)
      }
      or
      TReturnContext(CallNode call, DotNet::Callable callable) {
        exists(ReturnNode ret, Configuration config |
          Pruning::nodeCand(ret, config) |
          callable = ret.getEnclosingCallable() and
          flowOutOfCallableStep(call, ret, _, _, config)
        )
      }

    /**
     * A data flow context describing the origin of flow. Either no context
     * (`NoContext`), a context describing flow into a callable via a call
     * argument (`ArgumentContext`), or a context describing flow out of a
     * callable via a returned expression (`ReturnContext`).
     */
    private abstract class Context extends TContext {
      /** Gets a textual representation of this context. */
      abstract string toString();

      /**
       * Holds if flow out of a callable is allowed to go via the call
       * `call` in this context.
       */
      bindingset [call, config]
      predicate flowOutAllowedToCall(DotNet::Expr call, Configuration config) {
        // This context poses no restriction
        this instanceof NoContext
        or
        // Data in this context is from a call, so flow back out must be through
        // the same call
        this.(ExplicitArgumentContext).getCallContext().isArgument(call, _) or
        this.(ImplicitCapturedArgumentContext).getArgument().getCall() = call
        or
        // Data in this context is itself the result of a call, and the callable
        // from which data was returned may only be a valid target in a certain
        // call context, in which case flow further out must respect that call
        // context
        this = any(ReturnContext rc |
          not exists(rc.getARequiredContext(config)) or
          rc.getARequiredContext(config).(ArgumentCallContext).isArgument(call, _)
        )
      }
    }

    /**
     * A data flow context with no information.
     */
    private class NoContext extends Context, TNoContext {
      override string toString() {
        result = "<none>"
      }
    }

    /**
     * A data flow context describing flow into a callable via a call argument.
     */
    private abstract class ArgumentContext extends Context {
      abstract DotNet::Expr getCall();
    }

    /**
     * A data flow context describing flow into a callable via an explicit call argument.
     */
    private class ExplicitArgumentContext extends ArgumentContext, TExplicitArgumentContext {
      ArgumentCallContext acc;

      ExplicitArgumentContext() {
        this = TExplicitArgumentContext(acc)
      }

      ArgumentCallContext getCallContext() {
        result = acc
      }

      override DotNet::Expr getCall() {
        acc.isArgument(result, _)
      }

      override string toString() {
        result = acc.toString()
      }
    }

    /**
     * A data flow context describing flow into a callable via an implicit captured variable call argument.
     */
    private class ImplicitCapturedArgumentContext extends ArgumentContext, TImplicitCapturedArgumentContext {
      ImplicitCapturedArgumentNode arg;

      ImplicitCapturedArgumentContext() {
        this = TImplicitCapturedArgumentContext(arg)
      }

      ImplicitCapturedArgumentNode getArgument() {
        result = arg
      }

      override Expr getCall() {
        result = arg.getCall()
      }

      override string toString() {
        result = arg.toString()
      }
    }

    /**
     * A data flow context describing flow out of a callable via a returned
     * expression.
     */
    private class ReturnContext extends Context, TReturnContext {
      CallNode call;
      DotNet::Callable callable;

      ReturnContext() {
        this = TReturnContext(call, callable)
      }

      /**
       * Gets a call context required for the flow out to the data described by this
       * context to be possible.
       */
      ArgumentCallContext getARequiredContext(Configuration config) {
        result = getARequiredContext0(call, callable, config)
      }

      override string toString() {
        result = call.toString()
      }
    }

    pragma [noinline]
    private ArgumentCallContext getARequiredContext0(CallNode call, DotNet::Callable callable, Configuration config) {
      exists(ReturnNode ret |
        flowOutOfCallableStep(call, ret, _, result, config) |
        callable = ret.getEnclosingCallable()
      )
    }

    newtype TFlowGraphNode =
      TFlowGraphNode0(Node node, Context ctx, Configuration config) {
        // A source
        Pruning::nodeCand(node, config) and
        config.isSource(node) and
        ctx instanceof NoContext
        or
        // A step from an existing flow graph node
        exists(FlowGraphNode mid |
          flowStep(mid, node, ctx) |
          config = mid.getConfiguration() and
          Pruning::nodeCand(node, unbind(config))
        )
      }

    /**
     * A data flow node augmented with a context and a configuration. Only pruned
     * nodes are generated.
     */
    class FlowGraphNode extends TFlowGraphNode0 {
      Node node;
      Context ctx;
      Configuration config;

      FlowGraphNode() { this = TFlowGraphNode0(node, ctx, config) }

      /** Gets the underlying data flow node. */
      Node getNode() { result = node }

      /** Gets the context of this intermediate node. */
      Context getContext() { result = ctx }

      /** Gets the associated configuration. */
      Configuration getConfiguration() { result = config }

      /** Gets a successor node, if any. */
      FlowGraphNode getASuccessor() {
        flowStep(this, result.getNode(), result.getContext()) and
        result.getConfiguration() = unbind(this.getConfiguration())
      }

      /** Gets the enclosing callable of this node. */
      DotNet::Callable getEnclosingCallable() {
        result = this.getNode().getEnclosingCallable()
      }

      /** Gets a textual representation of this node. */
      string toString() { result = this.getNode().toString() }

      /** Gets the location of this node. */
      Location getLocation() { result = this.getNode().getLocation() }
    }

    /**
     * A flow graph node corresponding to a source.
     */
    private class FlowGraphNodeSource extends FlowGraphNode {
      FlowGraphNodeSource() {
        this.getConfiguration().isSource(this.getNode()) and
        this.getContext() instanceof NoContext
      }
    }

    /**
     * A flow graph node corresponding to a sink.
     */
    private class FlowGraphNodeSink extends FlowGraphNode {
      FlowGraphNodeSink() {
        this.getConfiguration().isSink(this.getNode())
      }
    }

    /**
     * Holds if data may flow from `mid` to `node`. The last step in or out of
     * a callable is recorded by `ctx`.
     */
    private predicate flowStep(FlowGraphNode mid, Node node, Context ctx) {
      ctx = mid.getContext() and
      LocalFlow::localFlowBigStep(mid.getNode(), node, mid.getConfiguration())
      or
      jumpStep(mid.getNode(), node) and
      ctx instanceof NoContext
      or
      flowIntoCallable(mid, node, ctx)
      or
      flowOutOfCallable(mid, node, ctx)
      or
      flowThroughCallable(mid, node, ctx)
    }

    pragma [noinline]
    private predicate flowIntoCallable0(FlowGraphNode mid, ArgumentNode arg, ParameterNode p) {
      exists(Context outerctx, CallContext cc, Configuration config |
        config = mid.getConfiguration() and
        flowIntoCallableStep(_, arg, p, cc, config) and
        arg = mid.getNode() and
        outerctx = mid.getContext() |
        cc instanceof EmptyCallContext
        or
        exists(DotNet::Expr call |
          cc.(ArgumentCallContext).isArgument(call, _) |
          outerctx.flowOutAllowedToCall(call, config)
        )
      )
    }

    /**
     * Holds if data may flow from `mid` into parameter `p`. The context
     * after entering the callable is `innerctx`.
     */
    private predicate flowIntoCallable(FlowGraphNode mid, ParameterNode p, ArgumentContext innerctx) {
      exists(ArgumentNode arg |
        flowIntoCallable0(mid, arg, p) |
        innerctx = arg.getContext(mid.getConfiguration())
      )
    }

    pragma [noinline]
    private predicate flowOutOfCallable0(FlowGraphNode mid, CallNode call, OutNode out, DotNet::Callable callable, Context innerctx) {
      flowOutOfCallableStep(call, mid.getNode(), out, _, mid.getConfiguration()) and
      innerctx = mid.getContext() and
      not innerctx instanceof ArgumentContext and
      callable = mid.getEnclosingCallable()
    }

    /**
     * Holds if data may flow from `mid` out of a callable to `out`. The context
     * after leaving the callable is `outerctx`.
     */
    pragma [noinline]
    private predicate flowOutOfCallable(FlowGraphNode mid, OutNode out, ReturnContext outerctx) {
      exists(CallNode call, DotNet::Callable callable, Context innerctx |
        flowOutOfCallable0(mid, call, out, callable, innerctx) and
        outerctx = TReturnContext(call, callable) |
        innerctx.flowOutAllowedToCall(call.getCall(), mid.getConfiguration())
      )
    }

    private predicate paramFlowsThroughExplicit(CallNode call, ExplicitParameterNode p, ExplicitArgumentContext innerctx, FlowGraphNode mid, ReturnNode ret) {
      exists(int i |
        innerctx.getCallContext() = call.getCallContext(i) |
        mid.getNode() = ret and
        mid.getContext() = innerctx and
        mid.getEnclosingCallable().getParameter(i) = p.getParameter()
      )
    }

    private predicate paramFlowsThroughImplicit(CallNode call, ImplicitCapturedParameterNode p, ImplicitCapturedArgumentContext innerctx, FlowGraphNode mid, ReturnNode ret) {
      innerctx.getArgument() = call.getImplicitCapturedArgument(p.getVariable()) and
      mid.getNode() = ret and
      mid.getContext() = innerctx and
      mid.getEnclosingCallable() = p.getEnclosingCallable()
    }

    /** Holds if data may flow from `p` to a a node `out` returned by the callable. */
    private predicate paramFlowsThrough(CallNode call, ParameterNode p, OutNode out, ArgumentContext innerctx, CallContext cc) {
      exists(FlowGraphNode mid, ReturnNode ret |
        paramFlowsThroughExplicit(call, p, innerctx, mid, ret) or
        paramFlowsThroughImplicit(call, p, innerctx, mid, ret)
        |
        flowOutOfCallableStep(call, ret, out, cc, mid.getConfiguration())
      )
    }

    /**
     * Holds if data may flow from argument `mid` of a call, back out from the
     * call to `out`. The context after the call is `ctx`.
     */
    pragma [noinline]
    private predicate flowThroughCallable(FlowGraphNode mid, OutNode out, Context ctx) {
      exists(CallNode call, ParameterNode p, ArgumentContext innerctx, CallContext cc |
        flowIntoCallable(mid, p, innerctx) and
        paramFlowsThrough(call, p, out, innerctx, cc) |
        // Data in `mid` is from a call, so that call must match the required call (if any),
        // and the context after flow through `call` must be recovered
        exists(ArgumentContext ac |
          ac = mid.getContext() and
          ctx = ac |
          cc instanceof EmptyCallContext
          or
          exists(DotNet::Expr e |
            cc.(ArgumentCallContext).isArgument(e, _) |
            ac.getCall() = e
          )
        )
        or
        // Data in `mid` is *not* from a call, so the context after flow through `call`
        // is simply a return out of `call`
        mid.getContext() = any(Context c | not c instanceof ArgumentContext) and
        ctx = TReturnContext(call, p.getEnclosingCallable())
      )
    }

    /**
     * Holds if data can flow (inter-procedurally) from `source` to `sink`.
     *
     * Will only have results if `config` has non-empty sources and sinks.
     */
    pragma [nomagic]
    predicate flowsTo(FlowGraphNodeSource flowsource, Node source, FlowGraphNodeSink flowsink, Node sink, Configuration config) {
      flowsource.getConfiguration() = config and
      flowsource.getNode() = source and
      flowsource.getASuccessor*() = flowsink and
      flowsink.getNode() = sink
    }

    /**
     * Holds if `arg` is an argument of the method call `mc`, where the target
     * of `mc` is a library callable that forwards `arg` to an `out`/`ref` argument
     * `node`. Example:
     *
     * ```
     * int i;
     * Int32.TryParse("42", out i);
     * ```
     *
     * `mc = Int32.TryParse("42", out i)`, `arg = "42"`, and `node` is the access
     * to `i` in `out i`.
     */
    predicate flowThroughCallableLibraryOutRef(MethodCall mc, Expr arg, SsaDefinitionNode node, boolean preservesValue) {
      exists(Parameter outRef, AssignableDefinitions::OutRefDefinition def |
        libraryFlowOutRef(mc, arg, outRef, preservesValue) |
        def = node.getDefinition().(Ssa::ExplicitDefinition).getADefinition() and
        def.getTargetAccess() = mc.getArgumentForParameter(outRef)
      )
    }

    /**
     * Holds if the output from the delegate `delegate` flows to `out`. The delegate
     * is passed as an argument to a library callable, which invokes the delegate.
     * Example:
     *
     * ```
     * x.Select(y => { ... });
     * ```
     *
     * `delegate = y => { ... }`, `out = x.Select(y => { ... })`, and
     * `preservesValue = false`.
     */
    predicate flowOutOfDelegateLibraryCall(ImplicitDelegateCallNode delegate, OutNode out, boolean preservesValue) {
      exists(Call call, int i |
        libraryFlowDelegateCallOut(call, _, out.asExpr(), preservesValue, i) and
        delegate.getCall() = call.getArgument(i)
      )
    }

    private class FieldLike extends Assignable, Modifiable {
      FieldLike() {
        this instanceof Field or
        this = any(TrivialProperty p | not p.isOverridableOrImplementable())
      }
    }

    private class FieldLikeRead extends AssignableRead {
      FieldLikeRead() {
        this.getTarget() instanceof FieldLike
      }
    }

    /**
     * Holds if the field-like read `flr` is not completely determined
     * by explicit SSA updates.
     */
    private predicate hasNonlocalValue(FieldLikeRead flr) {
      flr = any(Ssa::ImplicitUntrackedDefinition udef).getARead()
      or
      exists(Ssa::Definition def, Ssa::ImplicitDefinition idef |
        def.getARead() = flr and
        idef = def.getAnUltimateDefinition()
        |
        idef instanceof Ssa::ImplicitEntryDefinition or
        idef instanceof Ssa::ImplicitCallDefinition
      )
    }

    /**
     * Holds if `arg` is an argument of the call `call`, which resolves
     * to a callable with corresponding parameter `p`. The call context
     * `cc` stipulates the call required to resolve the callable, if any.
     *
     * Additional steps specified by the configuration are taken into account.
     */
    bindingset [config]
    predicate flowIntoCallableStep(CallNode call, ArgumentNode arg, ParameterNode p, CallContext cc, Configuration config) {
      flowIntoCallableStepNoConfig(call, arg, p, cc) or
      config.isAdditionalFlowStepIntoCall(call, arg, p.getParameter(), cc)
    }

    /**
     * Holds if `ret` is an expression returned by a callable to which the call
     * `call` resolves, and `out` is the corresponding output (either `call`
     * itself or an `out`/`ref` argument).
     *
     * Additional steps specified by the configuration are taken into account.
     */
    bindingset [config]
    predicate flowOutOfCallableStep(CallNode call, ReturnNode ret, OutNode out, CallContext cc, Configuration config) {
      flowOutOfCallableStepNoConfig(call, ret, out, cc) or
      config.isAdditionalFlowStepOutOfCall(call, ret, out, cc)
    }

    /**
     * Holds if `arg` is an argument of the non-delegate call `call`,
     * which resolves to a callable with corresponding parameter `p`.
     */
    predicate flowIntoCallableNonDelegateCall(NonDelegateCall call, DotNet::Expr arg, DotNet::Parameter p) {
      exists(DotNet::Callable callable |
        callable = call.getARuntimeTarget() and
        p = callable.getAParameter() and
        arg = call.getArgument(p.getPosition())
      )
    }

    /**
     * Holds if `arg` is an argument of the delegate call `call`,
     * which resolves to a callable in call context `cc`, with
     * corresponding parameter `p`.
     */
    private predicate flowIntoCallableDelegateCall(DelegateCall call, Expr arg, Parameter p, CallContext cc) {
      exists(Callable callable |
        callable = call.getARuntimeTarget(cc) and
        arg = call.getRuntimeArgumentForParameter(p) and
        p = callable.getAParameter()
      )
    }

    /**
     * Holds if `arg` is an argument of the call `call`, which resolves
     * to a library callable that is known to forward `arg` into a supplied
     * delegate `delegate`. `p` is a corresponding delegate parameter.
     * Example:
     *
     * ```
     * x.Select(y => { ... });
     * ```
     *
     * `arg = x`, `p = y`, `call = x.Select(y => { ... })`.
     */
    predicate flowIntoCallableLibraryCall(Call call, ArgumentNode arg, ImplicitDelegateCallNode delegate, Parameter p, boolean preservesValue, CallContext cc) {
      exists(Callable callable, int i, int j |
        libraryFlowDelegateCallIn(call, _, arg.asExpr(), preservesValue, i, j) and
        delegate.getCall() = call.getArgument(j) and
        callable = flowIntoCallableLibraryCall0(delegate, i, p, cc)
      )
      or
      exists(Callable callable, int i, int j, int k |
        libraryFlowDelegateCallOutIn(call, _, preservesValue, i, j, k) |
        callable = flowIntoCallableLibraryCall0(delegate, j, p, cc) and
        delegate.getCall() = call.getArgument(k) and
        arg.(ImplicitDelegateCallNode).getCall() = call.getArgument(i)
      )
    }

    pragma [noinline]
    private Callable flowIntoCallableLibraryCall0(ImplicitDelegateCallNode arg, int i, Parameter p, CallContext cc) {
      result = arg.getArgument().getARuntimeTarget(cc) and
      p = result.getParameter(i)
    }

    /**
     * Holds if `ret` is an expression returned by a callable to
     * which the non-delegate call `call` resolves, and `out` is the
     * corresponding output (either `call` itself or first uses of
     * a relevant `out`/`ref` argument).
     */
    predicate flowOutOfCallableNonDelegateCall(NonDelegateCall call, DotNet::Expr ret, OutNode out) {
      exists(DotNet::Callable callable |
        callable = call.getARuntimeTarget() |
        // ordinary return value
        callable.canReturn(ret) and
        call = out.asExpr()
        or
        // return via out/ref parameter
        exists(Parameter outRef, AssignableDefinitions::OutRefDefinition def |
          callableReturnsOutOrRef(callable.getSourceDeclaration(), outRef.getSourceDeclaration(), ret) and
          def = out.(SsaDefinitionNode).getDefinition().(Ssa::ExplicitDefinition).getADefinition() and
          def.getTargetAccess() = call.(Call).getArgumentForParameter(outRef)
        )
      )
    }

    /**
     * Holds if `ret` is an expression returned by a callable to
     * which the delegate call `call` resolves.
     */
    private predicate flowOutOfCallableDelegateCall(CallNode call, Expr ret, CallContext cc) {
      exists(Callable target |
        target.getSourceDeclaration().canReturn(ret) |
        target = call.asExpr().(DelegateCall).getARuntimeTarget(cc) or
        target = call.(ImplicitDelegateCallNode).getArgument().getARuntimeTarget(cc)
      )
    }

    /**
     * Holds if callable `c` can return `e` as an `out`/`ref` value
     * for parameter `outRef`.
     */
    predicate callableReturnsOutOrRef(Callable c, Parameter outRef, Expr e) {
      exists(Ssa::ExplicitDefinition def |
        def.getADefinition().getSource() = e and
        def.isLiveOutRefParameterDefinition(outRef) and
        outRef = c.getAParameter()
      )
    }
  }
}
