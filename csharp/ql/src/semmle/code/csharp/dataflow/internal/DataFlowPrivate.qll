private import csharp
private import cil
private import dotnet
private import DataFlowPublic
private import DataFlowDispatch
private import DataFlowImplCommon
private import ControlFlowReachability
private import DelegateDataFlow
private import semmle.code.csharp.dataflow.LibraryTypeDataFlow
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.frameworks.EntityFramework
private import semmle.code.csharp.frameworks.NHibernate

/** Provides predicates related to local data flow. */
module LocalFlow {
  class LocalExprStepConfiguration extends ControlFlowReachabilityConfiguration {
    LocalExprStepConfiguration() { this = "LocalExprStepConfiguration" }

    override predicate candidate(
      Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
    ) {
      exactScope = false and
      (
        // Flow using library code
        libraryFlow(e1, e2, scope, isSuccessor, true)
        or
        e1 = e2.(ParenthesizedExpr).getExpr() and
        scope = e2 and
        isSuccessor = true
        or
        e2 = any(ConditionalExpr ce |
            e1 = ce.getThen() or
            e1 = ce.getElse()
          ) and
        scope = e2 and
        isSuccessor = false
        or
        e1 = e2.(Cast).getExpr() and
        scope = e2 and
        isSuccessor = true
        or
        e1 = e2.(AwaitExpr).getExpr() and
        scope = e2 and
        isSuccessor = true
        or
        // An `=` expression, where the result of the expression is used
        e2 = any(AssignExpr ae |
            ae.getParent() instanceof Expr and
            e1 = ae.getRValue()
          ) and
        scope = e2 and
        isSuccessor = true
      )
    }

    override predicate candidateDef(
      Expr e, AssignableDefinition def, ControlFlowElement scope, boolean exactScope,
      boolean isSuccessor
    ) {
      // Flow from source to definition
      exactScope = false and
      def.getSource() = e and
      (
        scope = def.getExpr() and
        isSuccessor = true
        or
        scope = def.(AssignableDefinitions::IsPatternDefinition).getIsPatternExpr() and
        isSuccessor = false
        or
        exists(SwitchStmt ss |
          ss = def.(AssignableDefinitions::TypeCasePatternDefinition).getTypeCase().getSwitchStmt() and
          isSuccessor = true
        |
          scope = ss.getCondition()
          or
          scope = ss.getACase()
        )
      )
    }
  }

  private CIL::DataFlowNode asCilDataFlowNode(Node node) {
    result = node.asParameter() or
    result = node.asExpr()
  }

  predicate localFlowStepCil(Node nodeFrom, Node nodeTo) {
    asCilDataFlowNode(nodeFrom).getALocalFlowSucc(asCilDataFlowNode(nodeTo), any(CIL::Untainted t))
  }

  /**
   * An uncertain SSA definition. Either an uncertain explicit definition or an
   * uncertain qualifier definition.
   *
   * Restricts `Ssa::UncertainDefinition` by excluding implicit call definitions,
   * as we---conservatively---consider such definitions to be certain.
   */
  class UncertainExplicitSsaDefinition extends Ssa::UncertainDefinition {
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
  predicate localFlowSsaInput(Node nodeFrom, Ssa::Definition def) {
    def = nodeFrom.(SsaDefinitionNode).getDefinition() and
    not exists(def.getARead())
    or
    exists(AssignableRead read, ControlFlow::Node cfn | read = nodeFrom.asExprAtNode(cfn) |
      def.getALastReadAtNode(cfn) = read
    )
  }

  predicate localFlowCapturedVarStep(SsaDefinitionNode nodeFrom, ImplicitCapturedArgumentNode nodeTo) {
    // Flow from SSA definition to implicit captured variable argument
    exists(Ssa::ExplicitDefinition def, ControlFlow::Nodes::ElementNode call |
      def = nodeFrom.getDefinition()
    |
      def.isCapturedVariableDefinitionFlowIn(_, call, _) and
      nodeTo = TImplicitCapturedArgumentNode(call, def.getSourceVariable().getAssignable())
    )
  }

  private Expr getALibraryFlowParentFrom(Expr exprFrom, Expr exprTo, boolean preservesValue) {
    libraryFlow(exprFrom, exprTo, preservesValue) and
    result = exprFrom
    or
    result.getAChildExpr() = getALibraryFlowParentFrom(exprFrom, exprTo, preservesValue)
  }

  private Expr getALibraryFlowParentTo(Expr exprFrom, Expr exprTo, boolean preservesValue) {
    libraryFlow(exprFrom, exprTo, preservesValue) and
    result = exprTo
    or
    exists(Expr mid | mid = getALibraryFlowParentTo(exprFrom, exprTo, preservesValue) |
      result.getAChildExpr() = mid and
      not mid = getALibraryFlowParentFrom(exprFrom, exprTo, preservesValue)
    )
  }

  pragma[noinline]
  predicate libraryFlow(
    Expr exprFrom, Expr exprTo, Expr scope, boolean isSuccessor, boolean preservesValue
  ) {
    // To not pollute the definitions in `LibraryTypeDataFlow.qll` with syntactic scope,
    // simply use the nearest common parent expression for `exprFrom` and `exprTo`
    scope = getALibraryFlowParentFrom(exprFrom, exprTo, preservesValue) and
    scope = getALibraryFlowParentTo(exprFrom, exprTo, preservesValue) and
    // Similarly, for simplicity allow following both forwards and backwards edges from
    // `exprFrom` to `exprTo`
    (isSuccessor = true or isSuccessor = false)
  }
}

/** A collection of cached types and predicates to be evaluated in the same stage. */
cached
module DataFlowPrivateCached {
  cached
  predicate forceCachingInSameStage() {
    exists(TAnyCallContext()) // force evaluation of cached predicates in `DataFlowImplCommon.qll`
    or
    DataFlowDispatchCached::forceCachingInSameStage()
    or
    TaintTracking::Internal::Cached::forceCachingInSameStage()
    or
    any(ArgumentNode n).argumentOf(_, _)
    or
    exists(any(Node n).toString())
    or
    exists(any(OutNode n).getCall())
  }

  cached
  newtype TNode =
    TExprNode(ControlFlow::Nodes::ElementNode cfn) { cfn.getElement() instanceof Expr } or
    TCilExprNode(CIL::Expr e) { e.getImplementation() instanceof CIL::BestImplementation } or
    TSsaDefinitionNode(Ssa::Definition def) or
    TCilParameterNode(CIL::Parameter p) { p.getMethod().hasBody() } or
    TTaintedParameterNode(Parameter p) { p.getCallable().hasBody() } or
    TTaintedReturnNode(ControlFlow::Nodes::ElementNode cfn) {
      any(Callable c).canYieldReturn(cfn.getElement())
    } or
    TImplicitCapturedArgumentNode(ControlFlow::Nodes::ElementNode cfn, LocalScopeVariable v) {
      exists(Ssa::ExplicitDefinition def | def.isCapturedVariableDefinitionFlowIn(_, cfn, _) |
        v = def.getSourceVariable().getAssignable()
      )
    } or
    TImplicitDelegateOutNode(
      ControlFlow::Nodes::ElementNode cfn, ControlFlow::Nodes::ElementNode call
    ) {
      cfn.getElement() instanceof DelegateArgumentToLibraryCallable and
      any(DelegateArgumentConfiguration x).hasExprPath(_, cfn, _, call)
    }

  cached
  DotNet::Callable getEnclosingCallable(Node node) {
    result = node.(ExprNode).getExpr().getEnclosingCallable()
    or
    result = node.(SsaDefinitionNode).getDefinition().getEnclosingCallable()
    or
    exists(CIL::Parameter p | node = TCilParameterNode(p) | result = p.getCallable())
    or
    result = getEnclosingCallable(node.(TaintedParameterNode).getUnderlyingNode())
    or
    result = getEnclosingCallable(node.(TaintedReturnNode).getUnderlyingNode())
    or
    exists(ControlFlow::Nodes::ElementNode cfn | node = TImplicitCapturedArgumentNode(cfn, _) |
      result = cfn.getEnclosingCallable()
    )
    or
    exists(ControlFlow::Nodes::ElementNode cfn | node = TImplicitDelegateOutNode(cfn, _) |
      result = cfn.getEnclosingCallable()
    )
  }

  cached
  DotNet::Type getType(Node node) {
    result = node.(ExprNode).getExpr().getType()
    or
    result = node.(SsaDefinitionNode).getDefinition().getSourceVariable().getType()
    or
    exists(CIL::Parameter p | node = TCilParameterNode(p) | result = p.getType())
    or
    result = getType(node.(TaintedParameterNode).getUnderlyingNode())
    or
    result = getType(node.(TaintedReturnNode).getUnderlyingNode())
    or
    exists(LocalScopeVariable v | node = TImplicitCapturedArgumentNode(_, v) | result = v.getType())
    or
    exists(ControlFlow::Nodes::ElementNode cfn | node = TImplicitDelegateOutNode(cfn, _) |
      result = cfn.getElement().(Expr).getType()
    )
  }

  cached
  Location getLocation(Node node) {
    result = node.(ExprNode).getExpr().getLocation()
    or
    result = node.(SsaDefinitionNode).getDefinition().getLocation()
    or
    exists(CIL::Parameter p | node = TCilParameterNode(p) | result = p.getLocation())
    or
    result = getLocation(node.(TaintedParameterNode).getUnderlyingNode())
    or
    result = getLocation(node.(TaintedReturnNode).getUnderlyingNode())
    or
    exists(ControlFlow::Nodes::ElementNode cfn | node = TImplicitCapturedArgumentNode(cfn, _) |
      result = cfn.getLocation()
    )
    or
    exists(ControlFlow::Nodes::ElementNode cfn | node = TImplicitDelegateOutNode(cfn, _) |
      result = cfn.getLocation()
    )
  }

  cached
  string toString(Node node) {
    exists(ControlFlow::Nodes::ElementNode cfn | node = TExprNode(cfn) | result = cfn.toString())
    or
    node = TCilExprNode(_) and
    result = "CIL expression"
    or
    exists(Parameter p | explicitParameterNode(node, p) | result = p.toString())
    or
    exists(Ssa::Definition def | def = node.(SsaDefinitionNode).getDefinition() |
      not explicitParameterNode(node, _) and
      result = def.toString()
    )
    or
    exists(CIL::Parameter p | node = TCilParameterNode(p) | result = p.toString())
    or
    result = toString(node.(TaintedParameterNode).getUnderlyingNode())
    or
    result = toString(node.(TaintedReturnNode).getUnderlyingNode())
    or
    exists(LocalScopeVariable v | node = TImplicitCapturedArgumentNode(_, v) |
      result = "[implicit argument] " + v
    )
    or
    exists(ControlFlow::Nodes::ElementNode cfn | node = TImplicitDelegateOutNode(cfn, _) |
      result = "[output] " + cfn
    )
  }

  /**
   * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
   * (intra-procedural) step.
   */
  cached
  predicate localFlowStepImpl(Node nodeFrom, Node nodeTo) {
    any(LocalFlow::LocalExprStepConfiguration x).hasNodePath(nodeFrom, nodeTo)
    or
    // Flow from SSA definition to first read
    exists(Ssa::Definition def, ControlFlow::Node cfn |
      def = nodeFrom.(SsaDefinitionNode).getDefinition()
    |
      nodeTo.asExprAtNode(cfn) = def.getAFirstReadAtNode(cfn)
    )
    or
    // Flow from read to next read
    exists(ControlFlow::Node cfnFrom, ControlFlow::Node cfnTo |
      Ssa::Internal::adjacentReadPairSameVar(cfnFrom, cfnTo)
    |
      nodeFrom = TExprNode(cfnFrom) and
      nodeTo = TExprNode(cfnTo)
    )
    or
    // Flow into SSA pseudo definition
    exists(Ssa::Definition def, Ssa::PseudoDefinition pseudo |
      LocalFlow::localFlowSsaInput(nodeFrom, def)
    |
      pseudo = nodeTo.(SsaDefinitionNode).getDefinition() and
      def = pseudo.getAnInput()
    )
    or
    // Flow into uncertain SSA definition
    exists(Ssa::Definition def, LocalFlow::UncertainExplicitSsaDefinition uncertain |
      LocalFlow::localFlowSsaInput(nodeFrom, def)
    |
      uncertain = nodeTo.(SsaDefinitionNode).getDefinition() and
      def = uncertain.getPriorDefinition()
    )
    or
    LocalFlow::localFlowCapturedVarStep(nodeFrom, nodeTo)
    or
    flowOutOfDelegateLibraryCall(nodeFrom, nodeTo, true)
    or
    flowThroughLibraryCallableOutRef(_, nodeFrom, nodeTo, true)
    or
    LocalFlow::localFlowStepCil(nodeFrom, nodeTo)
  }

  /**
   * Holds if `pred` can flow to `succ`, by jumping from one callable to
   * another. Additional steps specified by the configuration are *not*
   * taken into account.
   */
  cached
  predicate jumpStepImpl(ExprNode pred, ExprNode succ) {
    pred.(NonLocalJumpNode).getAJumpSuccessor(true) = succ
  }
}
private import DataFlowPrivateCached

/** An SSA definition, viewed as a node in a data flow graph. */
class SsaDefinitionNode extends Node, TSsaDefinitionNode {
  Ssa::Definition def;

  SsaDefinitionNode() { this = TSsaDefinitionNode(def) }

  /** Gets the underlying SSA definition. */
  Ssa::Definition getDefinition() { result = def }
}

private module ParameterNodes {
  /**
   * Holds if SSA definition node `node` is an entry definition for parameter `p`.
   */
  predicate explicitParameterNode(SsaDefinitionNode node, Parameter p) {
    exists(Ssa::ExplicitDefinition def, AssignableDefinitions::ImplicitParameterDefinition pdef |
      node = TSsaDefinitionNode(def)
    |
      pdef = def.getADefinition() and
      p = pdef.getParameter()
    )
  }

  /**
   * The value of an explicit parameter at function entry, viewed as a node in a data
   * flow graph.
   */
  class ExplicitParameterNode extends ParameterNode {
    private DotNet::Parameter parameter;

    ExplicitParameterNode() {
      explicitParameterNode(this, parameter) or
      this = TCilParameterNode(parameter)
    }

    override DotNet::Parameter getParameter() { result = parameter }

    override predicate isParameterOf(DotNet::Callable c, int i) { c.getParameter(i) = parameter }
  }

  /**
   * A tainted parameter. Tainted parameters are a mere implementation detail, used
   * to restrict tainted flow into callables to just taint tracking (just like flow
   * out of `TaintedReturnNode`s is restricted to taint tracking).
   */
  class TaintedParameterNode extends ParameterNode {
    private Parameter parameter;

    TaintedParameterNode() { this = TTaintedParameterNode(parameter) }

    /** Gets the underlying parameter node. */
    ExplicitParameterNode getUnderlyingNode() { explicitParameterNode(result, parameter) }

    // `getParameter()` is explicitly *not* overriden to return `parameter`,
    // as that would otherwise enable tainted parameters to accidentally be
    // used by users of the library
    override predicate isParameterOf(DotNet::Callable c, int i) {
      c = parameter.getCallable() and
      // we model tainted parameters as if they had been extra parameters after
      // the actual parameters
      i = parameter.getPosition() + c.getNumberOfParameters()
    }
  }

  module ImplicitCapturedParameterNodeImpl {
    /** An implicit entry definition for a captured variable. */
    class SsaCapturedEntryDefinition extends Ssa::ImplicitEntryDefinition {
      private LocalScopeVariable v;

      SsaCapturedEntryDefinition() { this.getSourceVariable().getAssignable() = v }

      LocalScopeVariable getVariable() { result = v }
    }

    private class CapturedVariable extends LocalScopeVariable {
      CapturedVariable() { this = any(SsaCapturedEntryDefinition d).getVariable() }
    }

    private predicate id(CapturedVariable x, CapturedVariable y) { x = y }

    private predicate idOf(CapturedVariable x, int y) = equivalenceRelation(id/2)(x, y)

    int getId(CapturedVariable v) { idOf(v, result) }

    // we model implicit parameters for captured variables starting from index `-2`,
    // the order is irrelevant
    int getParameterPosition(SsaCapturedEntryDefinition def) {
      exists(Callable c | c = def.getCallable() |
        def = rank[-result - 1](SsaCapturedEntryDefinition def0 |
            def0.getCallable() = c
          |
            def0 order by getId(def0.getSourceVariable().getAssignable())
          )
      )
    }
  }
  private import ImplicitCapturedParameterNodeImpl

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
  class ImplicitCapturedParameterNode extends ParameterNode, SsaDefinitionNode {
    override SsaCapturedEntryDefinition def;

    ImplicitCapturedParameterNode() { def = this.getDefinition() }

    /** Gets the captured variable that this implicit parameter models. */
    LocalScopeVariable getVariable() { result = def.getVariable() }

    override predicate isParameterOf(DotNet::Callable c, int i) {
      i = getParameterPosition(def) and
      c = this.getEnclosingCallable()
    }
  }
}
import ParameterNodes

private module ArgumentNodes {
  class DelegateArgumentConfiguration extends ControlFlowReachabilityConfiguration {
    DelegateArgumentConfiguration() { this = "DelegateArgumentConfiguration" }

    override predicate candidate(
      Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
    ) {
      exists(DelegateArgumentToLibraryCallable arg | e1 = arg.getCall().getAnArgument() |
        e2 = arg.getCall() and
        scope = e2 and
        exactScope = false and
        isSuccessor = true
      )
    }
  }

  /**
   * Holds if `arg` is an argument of the call `call`, which resolves to a
   * library callable that is known to forward `arg` into the `i`th parameter
   * of a supplied delegate `delegate`.
   *
   * For example, in
   *
   * ```
   * x.Select(Foo);
   * ```
   *
   * `arg = x`, `i = 0`, `call = x.Select(Foo)`, and `delegate = Foo`.
   */
  private predicate flowIntoCallableLibraryCall(
    DataFlowCall call, Node arg, ImplicitDelegateDataFlowCall delegate, int i
  ) {
    exists(int j, boolean preservesValue |
      preservesValue = true and i = j
      or
      preservesValue = false and i = j + delegate.getNumberOfDelegateParameters()
    |
      exists(DelegateArgumentConfiguration x, Call callExpr, ExprNode argExpr |
        x
            .hasExprPath(argExpr.getExpr(), argExpr.getControlFlowNode(), callExpr,
              call.getControlFlowNode())
      |
        exists(int k |
          libraryFlowDelegateCallIn(callExpr, _, argExpr.getExpr(), preservesValue, j, k) and
          arg = argExpr and
          delegate.isArgumentOf(call, k)
        )
        or
        exists(int k, int l | libraryFlowDelegateCallOutIn(callExpr, _, preservesValue, k, j, l) |
          delegate.isArgumentOf(call, l) and
          arg.(ImplicitDelegateOutNode).isArgumentOf(call, k) and
          arg = TImplicitDelegateOutNode(argExpr.getControlFlowNode(), _)
        )
      )
    )
  }

  private DotNet::Expr getArgument(DotNet::Expr call, int i) {
    call = any(DispatchCall dc | result = dc.getArgument(i)).getCall()
    or
    result = call.(DelegateCall).getArgument(i)
    or
    result = call.(CIL::Call).getArgument(i)
  }

  private class ArgumentConfiguration extends ControlFlowReachabilityConfiguration {
    ArgumentConfiguration() { this = "ArgumentConfiguration" }

    override predicate candidate(
      Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
    ) {
      e1 = getArgument(e2, _) and
      exactScope = false and
      scope = e2 and
      isSuccessor = true
    }
  }

  /** A data flow node that represents a call argument. */
  abstract class ArgumentNode extends Node {
    /** Holds if this argument occurs at the given position in the given call. */
    cached
    abstract predicate argumentOf(DataFlowCall call, int pos);

    /** Gets the call in which this node is an argument. */
    final DataFlowCall getCall() { this.argumentOf(result, _) }
  }

  /** A data flow node that represents an explicit call argument. */
  private class ExplicitArgumentNode extends ArgumentNode {
    private DataFlowCall c;

    private int i;

    ExplicitArgumentNode() {
      exists(DotNet::Expr e, DotNet::Expr arg |
        arg = this.asExpr() and
        e = c.getExpr() and
        arg = getArgument(e, i)
      |
        any(ArgumentConfiguration x)
            .hasExprPath(_, this.getControlFlowNode(), _, c.getControlFlowNode())
        or
        // No CFG splitting in CIL
        e instanceof CIL::Expr and
        arg instanceof CIL::Expr
      )
      or
      flowIntoCallableLibraryCall(_, this, c, i)
    }

    override predicate argumentOf(DataFlowCall call, int pos) { call = c and pos = i }
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
  class ImplicitCapturedArgumentNode extends ArgumentNode, TImplicitCapturedArgumentNode {
    private LocalScopeVariable v;

    private ControlFlow::Nodes::ElementNode cfn;

    ImplicitCapturedArgumentNode() { this = TImplicitCapturedArgumentNode(cfn, v) }

    /** Holds if the value at this node may flow into the implicit parameter `p`. */
    private predicate flowsInto(ImplicitCapturedParameterNode p, boolean additionalCalls) {
      exists(Ssa::ImplicitEntryDefinition def, Ssa::ExplicitDefinition edef |
        def = p.getDefinition()
      |
        edef.isCapturedVariableDefinitionFlowIn(def, cfn, additionalCalls) and
        v = def.getSourceVariable().getAssignable()
      )
    }

    override predicate argumentOf(DataFlowCall call, int pos) {
      exists(ImplicitCapturedParameterNode p, boolean additionalCalls |
        this.flowsInto(p, additionalCalls) and
        p.isParameterOf(call.getARuntimeTarget(), pos)
      |
        if call instanceof TransitiveCapturedDataFlowCall
        then additionalCalls = true and call.getControlFlowNode() = cfn
        else (
          additionalCalls = false and
          (
            call.getControlFlowNode() = cfn
            or
            exists(DataFlowCall parent |
              call.(ImplicitDelegateDataFlowCall).isArgumentOf(parent, _)
            |
              parent.getControlFlowNode() = cfn
            )
          )
        )
      )
    }
  }
}
import ArgumentNodes

private module ReturnNodes {
  /** A data flow node that represents a value returned by a callable. */
  abstract class ReturnNode extends Node {
    /** Gets the kind of this return node. */
    abstract ReturnKind getKind();
  }

  /**
   * A data flow node that represents an expression returned by a callable,
   * either using a (`yield`) `return` statement or an expression body (`=>`).
   */
  class ExprReturnNode extends ReturnNode, ExprNode {
    ExprReturnNode() {
      exists(DotNet::Callable c, DotNet::Expr e | e = this.getExpr() |
        c.canReturn(e)
        or
        c.(Callable).canYieldReturn(e)
      )
    }

    override ReturnKind getKind() {
      any(DotNet::Callable c).canReturn(this.getExpr()) and result instanceof NormalReturnKind
    }
  }

  /**
   * A data flow node that represents an assignment to an `out` or a `ref`
   * parameter.
   */
  class OutRefReturnNode extends ReturnNode, SsaDefinitionNode {
    OutRefReturnKind kind;

    OutRefReturnNode() {
      exists(Parameter p |
        this.getDefinition().(Ssa::ExplicitDefinition).isLiveOutRefParameterDefinition(p)
      |
        p.isOut() and kind instanceof OutReturnKind
        or
        p.isRef() and kind instanceof RefReturnKind
      )
    }

    override ReturnKind getKind() { result = kind }
  }

  /**
   * A tainted return node. Tainted return nodes are a mere implementation detail,
   * used to restrict tainted flow out of callables to just taint tracking (just
   * like flow in to `TaintedReturnParameter`s is restricted to taint tracking).
   */
  class TaintedReturnNode extends ReturnNode, TTaintedReturnNode {
    private ControlFlow::Nodes::ElementNode cfn;

    TaintedReturnNode() { this = TTaintedReturnNode(cfn) }

    /** Gets the underlying return node. */
    ExprReturnNode getUnderlyingNode() { result.getControlFlowNode() = cfn }

    override YieldReturnKind getKind() { any() }
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
  class ImplicitCapturedReturnNode extends ReturnNode, SsaDefinitionNode {
    private Ssa::ExplicitDefinition edef;

    ImplicitCapturedReturnNode() {
      edef = this.getDefinition() and
      edef.isCapturedVariableDefinitionFlowOut(_, _)
    }

    /**
     * Holds if the value at this node may flow out to the implicit call definition
     * at `node`, using one or more calls.
     */
    predicate flowsOutTo(SsaDefinitionNode node, boolean additionalCalls) {
      edef.isCapturedVariableDefinitionFlowOut(node.getDefinition(), additionalCalls)
    }

    override ImplicitCapturedReturnKind getKind() {
      result.getVariable() = edef.getSourceVariable().getAssignable()
    }
  }
}
import ReturnNodes

private module OutNodes {
  /** A data flow node that represents the output of a call. */
  abstract class OutNode extends Node {
    /** Gets the underlying call. */
    cached
    abstract DataFlowCall getCall();
  }

  private DataFlowCall csharpCall(Expr e, ControlFlow::Node cfn) {
    e = any(DispatchCall dc | result = TNonDelegateCall(cfn, dc)).getCall() or
    result = TExplicitDelegateCall(cfn, e)
  }

  /**
   * A data flow node that reads a value returned directly by a callable,
   * either via a C# call or a CIL call.
   */
  class ExprOutNode extends OutNode, ExprNode {
    private DataFlowCall call;

    ExprOutNode() {
      exists(DotNet::Expr e | e = this.getExpr() |
        call = csharpCall(e, this.getControlFlowNode()) or
        call = TCilCall(e)
      )
    }

    override DataFlowCall getCall() { result = call }
  }

  /**
   * A data flow node that reads a value returned implicitly by a callable
   * using a captured variable.
   */
  class CapturedOutNode extends OutNode, SsaDefinitionNode {
    private DataFlowCall call;

    CapturedOutNode() {
      exists(ImplicitCapturedReturnNode n, boolean additionalCalls, ControlFlow::Node cfn |
        n.flowsOutTo(this, additionalCalls) and
        cfn = this.getDefinition().getControlFlowNode()
      |
        additionalCalls = false and call = csharpCall(_, cfn)
        or
        additionalCalls = false and
        call.(ImplicitDelegateDataFlowCall).isArgumentOf(csharpCall(_, cfn), _)
        or
        additionalCalls = true and call = TTransitiveCapturedCall(cfn)
      )
    }

    override DataFlowCall getCall() { result = call }
  }

  /**
   * A data flow node that reads a value returned by a callable using an
   * `out` or `ref` parameter.
   */
  class ParamOutNode extends OutNode, SsaDefinitionNode {
    ParamOutNode() {
      this.getDefinition().(Ssa::ExplicitDefinition).getADefinition() instanceof
        AssignableDefinitions::OutRefDefinition
    }

    override DataFlowCall getCall() {
      result = csharpCall(_, this.getDefinition().getControlFlowNode())
    }
  }

  /**
   * A data flow node that represents the output of an implicit delegate call,
   * in a call to a library method. For example, the output from the implicit
   * call to `M` in `new Lazy<int>(M)`.
   */
  class ImplicitDelegateOutNode extends OutNode, TImplicitDelegateOutNode {
    private ControlFlow::Nodes::ElementNode cfn;

    private ControlFlow::Nodes::ElementNode call;

    ImplicitDelegateOutNode() { this = TImplicitDelegateOutNode(cfn, call) }

    /**
     * Holds if the underlying delegate argument is the `i`th argument of the
     * call `c` targeting a library callable. For example, `M` is the `0`th
     * argument of `new Lazy<int>(M)`.
     */
    predicate isArgumentOf(DataFlowCall c, int i) {
      c.getControlFlowNode() = call and
      call.getElement().(Call).getArgument(i) = cfn.getElement()
    }

    override ControlFlow::Nodes::ElementNode getControlFlowNode() { result = cfn }

    override ImplicitDelegateDataFlowCall getCall() { result.getNode() = this }
  }
}
import OutNodes

private class FlowThroughLibraryCallableOutRefConfiguration extends ControlFlowReachabilityConfiguration {
  FlowThroughLibraryCallableOutRefConfiguration() {
    this = "FlowThroughLibraryCallableOutRefConfiguration"
  }

  override predicate candidateDef(
    Expr e, AssignableDefinition def, ControlFlowElement scope, boolean exactScope,
    boolean isSuccessor
  ) {
    exists(MethodCall mc, Parameter outRef | libraryFlowOutRef(mc, e, outRef, _) |
      def.getTargetAccess() = mc.getArgumentForParameter(outRef) and
      def instanceof AssignableDefinitions::OutRefDefinition and
      scope = mc and
      isSuccessor = true and
      exactScope = false
    )
  }
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
predicate flowThroughLibraryCallableOutRef(
  MethodCall mc, ExprNode arg, SsaDefinitionNode node, boolean preservesValue
) {
  libraryFlowOutRef(mc, arg.getExpr(), _, preservesValue) and
  any(FlowThroughLibraryCallableOutRefConfiguration x).hasNodePath(arg, node)
}

/**
 * Holds if the output from the delegate `delegate` flows to `out`. The delegate
 * is passed as an argument to a library callable, which invokes the delegate.
 * Example:
 *
 * ```
 * x.Select(Foo);
 * ```
 *
 * `delegate = Foo`, `out = x.Select(Foo)`, and `preservesValue = false`.
 */
predicate flowOutOfDelegateLibraryCall(
  ImplicitDelegateOutNode delegate, ExprOutNode out, boolean preservesValue
) {
  exists(DataFlowCall call, int i |
    libraryFlowDelegateCallOut(call.getExpr(), _, out.getExpr(), preservesValue, i) and
    delegate.isArgumentOf(call, i) and
    out.getControlFlowNode() = call.getControlFlowNode()
  )
}

private class FieldLike extends Assignable, Modifiable {
  FieldLike() {
    this instanceof Field or
    this = any(TrivialProperty p | not p.isOverridableOrImplementable())
  }
}

private class FieldLikeRead extends AssignableRead {
  FieldLikeRead() { this.getTarget() instanceof FieldLike }
}

/**
 * Holds if the field-like read `flr` is not completely determined by explicit
 * SSA updates.
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

/** A write to a static field/property. */
private class StaticFieldLikeJumpNode extends NonLocalJumpNode, ExprNode {
  FieldLike fl;

  FieldLikeRead flr;

  ExprNode succ;

  StaticFieldLikeJumpNode() {
    fl.isStatic() and
    fl.getAnAssignedValue() = this.getExpr() and
    fl.getAnAccess() = flr and
    flr = succ.getExpr() and
    hasNonlocalValue(flr)
  }

  override ExprNode getAJumpSuccessor(boolean preservesValue) {
    result = succ and preservesValue = true
  }
}

predicate jumpStep = jumpStepImpl/2;

private newtype TContent = TContentStub()

/** A reference contained in an object. A stub implementation, for now. */
// stub implementation
class Content extends TContent {
  /** Gets a textual representation of this element. */
  string toString() { result = "stub" }

  Location getLocation() { result instanceof EmptyLocation }

  /** Gets the type of the object containing this content. */
  RefType getContainerType() { none() }

  /** Gets the type of this content. */
  Type getType() { none() }
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to `f`.
 * Thus, `node2` references an object with a field `f` that contains the
 * value of `node1`.
 */
predicate storeStep(Node node1, Content f, PostUpdateNode node2) {
  none() // stub implementation
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of `f`.
 * Thus, `node1` references an object with a field `f` whose value ends up in
 * `node2`.
 */
predicate readStep(Node node1, Content f, Node node2) {
  none() // stub implementation
}

private predicate suppressUnusedType(DotNet::Type t) { any() }

/**
 * Gets a representative type for `t` for the purpose of pruning possible flow.
 *
 * Type-based pruning is disabled for now, so this is a stub implementation.
 */
bindingset[t]
Type getErasedRepr(DotNet::Type t) { suppressUnusedType(t) and result instanceof ObjectType } // stub implementation

/** Gets a string representation of a type returned by `getErasedRepr`. */
bindingset[t]
string ppReprType(DotNet::Type t) { suppressUnusedType(t) and result = "" } // stub implementation

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 *
 * Type-based pruning is disabled for now, so this is a stub implementation.
 */
bindingset[t1, t2]
predicate compatibleTypes(DotNet::Type t1, DotNet::Type t2) {
  any() // stub implementation
}

/**
 * A node associated with an object after an operation that might have
 * changed its state.
 *
 * This can be either the argument to a callable after the callable returns
 * (which might have mutated the argument), or the qualifier of a field after
 * an update to the field.
 */
class PostUpdateNode extends Node {
  PostUpdateNode() { none() } // stub implementation

  /** Gets the node before the state update. */
  Node getPreUpdateNode() { none() } // stub implementation
}

/** A node that performs a type cast. */
class CastNode extends ExprNode {
  CastNode() { this.getExpr() instanceof CastExpr }
}

class DataFlowCallable = DotNet::Callable;

class DataFlowExpr = DotNet::Expr;

class DataFlowType = DotNet::Type;

class DataFlowLocation = Location;
