private import csharp
private import cil
private import dotnet
private import DataFlowPublic
private import DataFlowDispatch
private import DataFlowImplCommon::Public
private import ControlFlowReachability
private import DelegateDataFlow
private import semmle.code.csharp.Caching
private import semmle.code.csharp.ExprOrStmtParent
private import semmle.code.csharp.controlflow.Guards
private import semmle.code.csharp.dataflow.LibraryTypeDataFlow
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.frameworks.EntityFramework
private import semmle.code.csharp.frameworks.NHibernate

/** Calculation of the relative order in which `this` references are read. */
private module ThisFlow {
  private class BasicBlock = ControlFlow::BasicBlock;

  /** Holds if `n` is a `this` access at control flow node `cfn`. */
  private predicate thisAccess(Node n, ControlFlow::Node cfn) {
    n.(InstanceParameterNode).getCallable() = cfn.(ControlFlow::Nodes::EntryNode).getCallable()
    or
    n.asExprAtNode(cfn) = any(Expr e | e instanceof ThisAccess or e instanceof BaseAccess)
  }

  private predicate thisAccess(Node n, BasicBlock bb, int i) { thisAccess(n, bb.getNode(i)) }

  private predicate thisRank(Node n, BasicBlock bb, int rankix) {
    exists(int i |
      i = rank[rankix](int j | thisAccess(_, bb, j)) and
      thisAccess(n, bb, i)
    )
  }

  private int lastRank(BasicBlock bb) { result = max(int rankix | thisRank(_, bb, rankix)) }

  private predicate blockPrecedesThisAccess(BasicBlock bb) { thisAccess(_, bb.getASuccessor*(), _) }

  private predicate thisAccessBlockReaches(BasicBlock bb1, BasicBlock bb2) {
    thisAccess(_, bb1, _) and bb2 = bb1.getASuccessor()
    or
    exists(BasicBlock mid |
      thisAccessBlockReaches(bb1, mid) and
      bb2 = mid.getASuccessor() and
      not thisAccess(_, mid, _) and
      blockPrecedesThisAccess(bb2)
    )
  }

  private predicate thisAccessBlockStep(BasicBlock bb1, BasicBlock bb2) {
    thisAccessBlockReaches(bb1, bb2) and
    thisAccess(_, bb2, _)
  }

  /** Holds if `n1` and `n2` are control-flow adjacent references to `this`. */
  predicate adjacentThisRefs(Node n1, Node n2) {
    exists(int rankix, BasicBlock bb |
      thisRank(n1, bb, rankix) and
      thisRank(n2, bb, rankix + 1)
    )
    or
    exists(BasicBlock bb1, BasicBlock bb2 |
      thisRank(n1, bb1, lastRank(bb1)) and
      thisAccessBlockStep(bb1, bb2) and
      thisRank(n2, bb2, 1)
    )
  }
}

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
        e1 = e2.(NullCoalescingExpr).getAnOperand() and
        scope = e2 and
        isSuccessor = false
        or
        e1 = e2.(SuppressNullableWarningExpr).getExpr() and
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
        scope = def.(AssignableDefinitions::PatternDefinition).getMatch().(IsExpr) and
        isSuccessor = false
        or
        exists(Switch s |
          s.getACase() = def.(AssignableDefinitions::PatternDefinition).getMatch() and
          isSuccessor = true
        |
          scope = s.getExpr()
          or
          scope = s.getACase()
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
  private predicate localFlowSsaInput(Node nodeFrom, Ssa::Definition def) {
    def = nodeFrom.(SsaDefinitionNode).getDefinition() and
    not exists(def.getARead())
    or
    exists(AssignableRead read, ControlFlow::Node cfn | read = nodeFrom.asExprAtNode(cfn) |
      def.getALastReadAtNode(cfn) = read
    )
  }

  /**
   * Holds if there is a local flow step from `nodeFrom` to `nodeTo` involving
   * SSA definition `def.
   */
  predicate localSsaFlowStep(Ssa::Definition def, Node nodeFrom, Node nodeTo) {
    // Flow from SSA definition to first read
    exists(ControlFlow::Node cfn |
      def = nodeFrom.(SsaDefinitionNode).getDefinition() and
      nodeTo.asExprAtNode(cfn) = def.getAFirstReadAtNode(cfn)
    )
    or
    // Flow from read to next read
    exists(ControlFlow::Node cfnFrom, ControlFlow::Node cfnTo |
      Ssa::Internal::adjacentReadPairSameVar(def, cfnFrom, cfnTo) and
      nodeTo = TExprNode(cfnTo)
    |
      nodeFrom = TExprNode(cfnFrom)
      or
      cfnFrom = nodeFrom.(PostUpdateNode).getPreUpdateNode().getControlFlowNode()
    )
    or
    // Flow into SSA pseudo definition
    exists(Ssa::PseudoDefinition pseudo |
      localFlowSsaInput(nodeFrom, def) and
      pseudo = nodeTo.(SsaDefinitionNode).getDefinition() and
      def = pseudo.getAnInput()
    )
    or
    // Flow into uncertain SSA definition
    exists(LocalFlow::UncertainExplicitSsaDefinition uncertain |
      localFlowSsaInput(nodeFrom, def) and
      uncertain = nodeTo.(SsaDefinitionNode).getDefinition() and
      def = uncertain.getPriorDefinition()
    )
  }

  /**
   * Holds if the source variable of SSA definition `def` is an instance field.
   */
  predicate usesInstanceField(Ssa::Definition def) {
    exists(Ssa::SourceVariables::FieldOrPropSourceVariable fp | fp = def.getSourceVariable() |
      not fp.getAssignable().isStatic()
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

/** An argument of a C# call. */
private class Argument extends Expr {
  private Expr call;
  private int arg;

  Argument() {
    call = any(DispatchCall dc |
        this = dc.getArgument(arg)
        or
        this = dc.getQualifier() and arg = -1 and not dc.getAStaticTarget().(Modifiable).isStatic()
      ).getCall()
    or
    this = call.(DelegateCall).getArgument(arg)
  }

  /** Holds if this expression is the `i`th argument of `c`. */
  predicate isArgumentOf(Expr c, int i) { c = call and i = arg }
}

/**
 * Holds if `e` is an assignment of `src` to a non-static field or field-like
 * property `f` of `q`.
 */
private predicate instanceFieldLikeAssign(Expr e, FieldLike f, Expr src, Expr q) {
  exists(FieldLikeAccess fa, AssignableDefinition def |
    def.getTargetAccess() = fa and
    f = fa.getTarget() and
    not f.isStatic() and
    src = def.getSource() and
    q = fa.getQualifier() and
    e = def.getExpr()
  )
}

/**
 * Holds if `oc` has an object initializer that assigns `src` to non-static field or
 * field-like property `f`.
 */
private predicate instanceFieldLikeInit(ObjectCreation oc, FieldLike f, Expr src) {
  exists(MemberInitializer mi |
    mi = oc.getInitializer().(ObjectInitializer).getAMemberInitializer() and
    f = mi.getInitializedMember() and
    not f.isStatic() and
    src = mi.getRValue()
  )
}

/** A collection of cached types and predicates to be evaluated in the same stage. */
cached
private module Cached {
  cached
  newtype TNode =
    TExprNode(ControlFlow::Nodes::ElementNode cfn) {
      Stages::DataFlowStage::forceCachingInSameStage() and cfn.getElement() instanceof Expr
    } or
    TCilExprNode(CIL::Expr e) { e.getImplementation() instanceof CIL::BestImplementation } or
    TSsaDefinitionNode(Ssa::Definition def) or
    TInstanceParameterNode(Callable c) { c.hasBody() and not c.(Modifiable).isStatic() } or
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
    } or
    TMallocNode(ControlFlow::Nodes::ElementNode cfn) { cfn.getElement() instanceof ObjectCreation } or
    TExprPostUpdateNode(ControlFlow::Nodes::ElementNode cfn) {
      exists(Argument a, Type t |
        a = cfn.getElement() and
        t = a.stripCasts().getType()
      |
        t instanceof RefType or
        t = any(TypeParameter tp | not tp.isValueType())
      )
      or
      instanceFieldLikeAssign(_, _, _, cfn.getElement())
      or
      exists(TExprPostUpdateNode upd, FieldLikeAccess fla |
        upd = TExprPostUpdateNode(fla.getAControlFlowNode())
      |
        cfn.getElement() = fla.getQualifier()
      )
    }

  /**
   * This is the local flow predicate that is used as a building block in global
   * data flow. It is a strict subset of the `localFlowStep` predicate, as it
   * excludes SSA flow through instance fields.
   */
  cached
  predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
    exists(Ssa::Definition def |
      LocalFlow::localSsaFlowStep(def, nodeFrom, nodeTo) and
      not LocalFlow::usesInstanceField(def)
    )
    or
    any(LocalFlow::LocalExprStepConfiguration x).hasNodePath(nodeFrom, nodeTo)
    or
    ThisFlow::adjacentThisRefs(nodeFrom, nodeTo)
    or
    ThisFlow::adjacentThisRefs(nodeFrom.(PostUpdateNode).getPreUpdateNode(), nodeTo)
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
   * This is the extension of the predicate `simpleLocalFlowStep` that is exposed
   * as the `localFlowStep` predicate. It includes SSA flow through instance fields.
   */
  cached
  predicate extendedLocalFlowStep(Node nodeFrom, Node nodeTo) {
    exists(Ssa::Definition def |
      LocalFlow::localSsaFlowStep(def, nodeFrom, nodeTo) and
      LocalFlow::usesInstanceField(def)
    )
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

  cached
  newtype TContent = TFieldLikeContent(FieldLike f) { not f.isStatic() }

  /**
   * Holds if data can flow from `node1` to `node2` via an assignment to
   * content `c`.
   */
  cached
  predicate storeStepImpl(ExprNode node1, Content c, PostUpdateNode node2) {
    exists(StoreStepConfiguration x, Node preNode2 |
      preNode2 = node2.getPreUpdateNode() and
      x.hasNodePath(node1, preNode2) and
      instanceFieldLikeAssign(_, c.(FieldLikeContent).getField(), node1.asExpr(), preNode2.asExpr())
    )
    or
    exists(StoreStepConfiguration x |
      x.hasNodePath(node1, node2) and
      instanceFieldLikeInit(node2.(ObjectCreationNode).getExpr(), c.(FieldLikeContent).getField(),
        node1.asExpr())
    )
  }

  /**
   * Holds if data can flow from `node1` to `node2` via a read of content `c`.
   */
  cached
  predicate readStepImpl(Node node1, Content c, Node node2) {
    exists(ReadStepConfiguration x |
      x.hasNodePath(node1, node2) and
      c.(FieldLikeContent).getField() = node2.asExpr().(FieldLikeRead).getTarget()
    )
  }

  /**
   * Holds if the node `n` is unreachable when the call context is `call`.
   */
  cached
  predicate isUnreachableInCall(Node n, DataFlowCall call) {
    exists(
      SsaDefinitionNode paramNode, Ssa::ExplicitDefinition param, Guard guard,
      ControlFlow::SuccessorTypes::BooleanSuccessor bs
    |
      viableConstantBooleanParamArg(paramNode, bs.getValue().booleanNot(), call) and
      paramNode.getDefinition() = param and
      param.getARead() = guard and
      guard.controlsBlock(n.getControlFlowNode().getBasicBlock(), bs)
    )
  }
}

import Cached

/** An SSA definition, viewed as a node in a data flow graph. */
class SsaDefinitionNode extends Node, TSsaDefinitionNode {
  Ssa::Definition def;

  SsaDefinitionNode() { this = TSsaDefinitionNode(def) }

  /** Gets the underlying SSA definition. */
  Ssa::Definition getDefinition() { result = def }

  override Callable getEnclosingCallable() { result = def.getEnclosingCallable() }

  override Type getType() { result = def.getSourceVariable().getType() }

  override Location getLocation() { result = def.getLocation() }

  override string toString() {
    not explicitParameterNode(this, _) and
    result = def.toString()
  }
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

    override predicate isParameterOf(DataFlowCallable c, int i) { c.getParameter(i) = parameter }

    override DotNet::Callable getEnclosingCallable() { result = parameter.getCallable() }

    override DotNet::Type getType() { result = parameter.getType() }

    override Location getLocation() { result = parameter.getLocation() }

    override string toString() { result = parameter.toString() }
  }

  /** An implicit instance (`this`) parameter. */
  class InstanceParameterNode extends ParameterNode, TInstanceParameterNode {
    private Callable callable;

    InstanceParameterNode() { this = TInstanceParameterNode(callable) }

    /** Gets the callable containing this implicit instance parameter. */
    Callable getCallable() { result = callable }

    override predicate isParameterOf(DataFlowCallable c, int pos) { callable = c and pos = -1 }

    override Callable getEnclosingCallable() { result = callable }

    override Type getType() { result = callable.getDeclaringType() }

    override Location getLocation() { result = callable.getLocation() }

    override string toString() { result = "this" }
  }

  /**
   * A tainted parameter. Tainted parameters are a mere implementation detail, used
   * to restrict tainted flow into callables to just taint tracking (just like flow
   * out of `TaintedReturnNode`s is restricted to taint tracking).
   */
  class TaintedParameterNode extends ParameterNode, TTaintedParameterNode {
    private Parameter parameter;

    TaintedParameterNode() { this = TTaintedParameterNode(parameter) }

    /** Gets the underlying parameter node. */
    ExplicitParameterNode getUnderlyingNode() { explicitParameterNode(result, parameter) }

    // `getParameter()` is explicitly *not* overriden to return `parameter`,
    // as that would otherwise enable tainted parameters to accidentally be
    // used by users of the library
    override predicate isParameterOf(DataFlowCallable c, int i) {
      c = parameter.getCallable() and
      // we model tainted parameters as if they had been extra parameters after
      // the actual parameters
      i = parameter.getPosition() + c.getNumberOfParameters()
    }

    override Callable getEnclosingCallable() {
      result = this.getUnderlyingNode().getEnclosingCallable()
    }

    override Type getType() { result = this.getUnderlyingNode().getType() }

    override Location getLocation() { result = this.getUnderlyingNode().getLocation() }

    override string toString() { result = this.getUnderlyingNode().toString() }
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

    override predicate isParameterOf(DataFlowCallable c, int i) {
      i = getParameterPosition(def) and
      c = this.getEnclosingCallable()
    }
  }
}

import ParameterNodes

/** A data flow node that represents a call argument. */
abstract class ArgumentNode extends Node {
  /** Holds if this argument occurs at the given position in the given call. */
  cached
  abstract predicate argumentOf(DataFlowCall call, int pos);

  /** Gets the call in which this node is an argument. */
  final DataFlowCall getCall() { this.argumentOf(result, _) }
}

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
   * Holds if `arg` is an argument of a call, which resolves to a library callable
   * that is known to forward `arg` into the `i`th parameter of a supplied
   * delegate `delegate`.
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
    ExplicitArgumentNode arg, ImplicitDelegateDataFlowCall delegate, int i
  ) {
    exists(DataFlowCall call, int j, boolean preservesValue |
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

  private class ArgumentConfiguration extends ControlFlowReachabilityConfiguration {
    ArgumentConfiguration() { this = "ArgumentConfiguration" }

    override predicate candidate(
      Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
    ) {
      e1.(Argument).isArgumentOf(e2, _) and
      exactScope = false and
      scope = e2 and
      isSuccessor = true
    }
  }

  /** A data flow node that represents an explicit call argument. */
  private class ExplicitArgumentNode extends ArgumentNode {
    ExplicitArgumentNode() {
      this.asExpr() instanceof Argument
      or
      this.asExpr() = any(CIL::Call call).getAnArgument()
      or
      libraryFlowDelegateCallIn(_, _, this.asExpr(), _, _, _)
      or
      this.(ImplicitDelegateOutNode).isArgumentOf(_, _)
    }

    override predicate argumentOf(DataFlowCall call, int pos) {
      Stages::DataFlowStage::forceCachingInSameStage() and
      exists(ArgumentConfiguration x, Expr c, Argument arg |
        arg = this.asExpr() and
        c = call.getExpr() and
        arg.isArgumentOf(c, pos) and
        x.hasExprPath(_, this.getControlFlowNode(), _, call.getControlFlowNode())
      )
      or
      exists(CIL::Call c, CIL::Expr arg |
        arg = this.asExpr() and
        c = call.getExpr() and
        arg = c.getArgument(pos)
      )
      or
      flowIntoCallableLibraryCall(this, call, pos)
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

    override Callable getEnclosingCallable() { result = cfn.getEnclosingCallable() }

    override Type getType() { result = v.getType() }

    override Location getLocation() { result = cfn.getLocation() }

    override string toString() { result = "[implicit argument] " + v }
  }

  /**
   * A node that corresponds to the value of an object creation (`new C()`) before
   * the constructor has run.
   */
  class MallocNode extends ArgumentNode, TMallocNode {
    private ControlFlow::Nodes::ElementNode cfn;

    MallocNode() { this = TMallocNode(cfn) }

    override predicate argumentOf(DataFlowCall call, int pos) {
      call = TNonDelegateCall(cfn, _) and
      pos = -1
    }

    override ControlFlow::Node getControlFlowNode() { result = cfn }

    override Callable getEnclosingCallable() { result = cfn.getEnclosingCallable() }

    override Type getType() { result = cfn.getElement().(Expr).getType() }

    override Location getLocation() { result = cfn.getLocation() }

    override string toString() { result = "malloc" }
  }
}

import ArgumentNodes

/** A data flow node that represents a value returned by a callable. */
abstract class ReturnNode extends Node {
  /** Gets the kind of this return node. */
  abstract ReturnKind getKind();
}

private module ReturnNodes {
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
        this.getDefinition().(Ssa::ExplicitDefinition).isLiveOutRefParameterDefinition(p) and
        kind.getPosition() = p.getPosition()
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

    override Callable getEnclosingCallable() {
      result = this.getUnderlyingNode().getEnclosingCallable()
    }

    override Type getType() { result = this.getUnderlyingNode().getType() }

    override Location getLocation() { result = this.getUnderlyingNode().getLocation() }

    override string toString() { result = this.getUnderlyingNode().toString() }
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

/** A data flow node that represents the output of a call. */
abstract class OutNode extends Node {
  /** Gets the underlying call, where this node is a corresponding output of kind `kind`. */
  cached
  abstract DataFlowCall getCall(ReturnKind kind);
}

private module OutNodes {
  private import semmle.code.csharp.frameworks.system.Collections
  private import semmle.code.csharp.frameworks.system.collections.Generic

  private DataFlowCall csharpCall(Expr e, ControlFlow::Node cfn) {
    e = any(DispatchCall dc | result = TNonDelegateCall(cfn, dc)).getCall() or
    result = TExplicitDelegateCall(cfn, e)
  }

  /** A valid return type for a method that uses `yield return`. */
  private class YieldReturnType extends Type {
    YieldReturnType() {
      exists(Type t | t = this.getSourceDeclaration() |
        t instanceof SystemCollectionsIEnumerableInterface
        or
        t instanceof SystemCollectionsIEnumeratorInterface
        or
        t instanceof SystemCollectionsGenericIEnumerableTInterface
        or
        t instanceof SystemCollectionsGenericIEnumeratorInterface
      )
    }
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

    override DataFlowCall getCall(ReturnKind kind) {
      Stages::DataFlowStage::forceCachingInSameStage() and
      result = call and
      (
        kind instanceof NormalReturnKind and
        not call.getExpr().getType() instanceof VoidType
        or
        kind instanceof YieldReturnKind and
        call.getExpr().getType() instanceof YieldReturnType
      )
    }
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
        additionalCalls = true and call = TTransitiveCapturedCall(cfn, n.getEnclosingCallable())
      )
    }

    override DataFlowCall getCall(ReturnKind kind) {
      result = call and
      kind.(ImplicitCapturedReturnKind).getVariable() = this
            .getDefinition()
            .getSourceVariable()
            .getAssignable()
    }
  }

  /**
   * A data flow node that reads a value returned by a callable using an
   * `out` or `ref` parameter.
   */
  class ParamOutNode extends OutNode, SsaDefinitionNode {
    private AssignableDefinitions::OutRefDefinition outRefDef;

    ParamOutNode() { outRefDef = this.getDefinition().(Ssa::ExplicitDefinition).getADefinition() }

    override DataFlowCall getCall(ReturnKind kind) {
      result = csharpCall(_, this.getDefinition().getControlFlowNode()) and
      exists(Parameter p |
        p.getSourceDeclaration().getPosition() = kind.(OutRefReturnKind).getPosition() and
        outRefDef.getTargetAccess() = result.getExpr().(Call).getArgumentForParameter(p)
      )
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

    override ImplicitDelegateDataFlowCall getCall(ReturnKind kind) {
      result.getNode() = this and
      (
        kind instanceof NormalReturnKind and
        not result.getDelegateReturnType() instanceof VoidType
        or
        kind instanceof YieldReturnKind and
        result.getDelegateReturnType() instanceof YieldReturnType
      )
    }

    override Callable getEnclosingCallable() { result = cfn.getEnclosingCallable() }

    override Type getType() { result = cfn.getElement().(Expr).getType() }

    override Location getLocation() { result = cfn.getLocation() }

    override string toString() { result = "[output] " + cfn }
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
    this = any(Property p |
        not p.isOverridableOrImplementable() and
        (
          p.isAutoImplemented()
          or
          p.matchesHandle(any(CIL::TrivialProperty tp))
        )
      )
  }
}

private class FieldLikeAccess extends AssignableAccess, QualifiableExpr {
  FieldLikeAccess() { this.getTarget() instanceof FieldLike }
}

private class FieldLikeRead extends FieldLikeAccess, AssignableRead { }

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

/**
 * A reference contained in an object. Currently limited to instance fields
 * and field-like instance properties.
 */
class Content extends TContent {
  /** Gets a textual representation of this content. */
  abstract string toString();

  abstract Location getLocation();

  /** Gets the type of the object containing this content. */
  abstract Type getContainerType();

  /** Gets the type of this content. */
  abstract Type getType();
}

private class FieldLikeContent extends Content, TFieldLikeContent {
  private FieldLike f;

  FieldLikeContent() { this = TFieldLikeContent(f) }

  FieldLike getField() { result = f }

  override string toString() { result = f.toString() }

  override Location getLocation() { result = f.getLocation() }

  override Type getContainerType() { result = f.getDeclaringType() }

  override Type getType() { result = f.getType() }
}

private class StoreStepConfiguration extends ControlFlowReachabilityConfiguration {
  StoreStepConfiguration() { this = "StoreStepConfiguration" }

  override predicate candidate(
    Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
  ) {
    exactScope = false and
    isSuccessor = false and
    instanceFieldLikeAssign(scope, _, e1, e2)
    or
    exactScope = false and
    isSuccessor = false and
    instanceFieldLikeInit(e2, _, e1) and
    scope = e2
  }
}

predicate storeStep = storeStepImpl/3;

private class ReadStepConfiguration extends ControlFlowReachabilityConfiguration {
  ReadStepConfiguration() { this = "ReadStepConfiguration" }

  override predicate candidate(
    Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
  ) {
    exactScope = false and
    isSuccessor = true and
    e1 = e2.(FieldLikeRead).getQualifier() and
    scope = e2
  }
}

predicate readStep = readStepImpl/3;

private predicate suppressUnusedType(DotNet::Type t) { any() }

/**
 * Gets a representative type for `t` for the purpose of pruning possible flow.
 *
 * Type-based pruning is disabled for now, so this is a stub implementation.
 */
bindingset[t]
DotNet::Type getErasedRepr(DotNet::Type t) {
  // stub implementation
  suppressUnusedType(t) and result instanceof ObjectType
}

/** Gets a string representation of a type returned by `getErasedRepr`. */
string ppReprType(DotNet::Type t) { none() } // stub implementation

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
 *
 * Nodes corresponding to AST elements, for example `ExprNode`, usually refer
 * to the value before the update with the exception of `ObjectCreation`,
 * which represents the value after the constructor has run.
 */
abstract class PostUpdateNode extends Node {
  /** Gets the node before the state update. */
  abstract Node getPreUpdateNode();
}

private module PostUpdateNodes {
  class ObjectCreationNode extends PostUpdateNode, ExprNode, TExprNode {
    ObjectCreationNode() { exists(ObjectCreation oc | this = TExprNode(oc.getAControlFlowNode())) }

    override MallocNode getPreUpdateNode() { this = TExprNode(result.getControlFlowNode()) }
  }

  private class ExprPostUpdateNode extends PostUpdateNode, TExprPostUpdateNode {
    private ControlFlow::Nodes::ElementNode cfn;

    ExprPostUpdateNode() { this = TExprPostUpdateNode(cfn) }

    override ExprNode getPreUpdateNode() { cfn = result.getControlFlowNode() }

    override Callable getEnclosingCallable() { result = cfn.getEnclosingCallable() }

    override Type getType() { result = cfn.getElement().(Expr).getType() }

    override Location getLocation() { result = cfn.getLocation() }

    override string toString() { result = "[post] " + cfn.toString() }
  }
}

private import PostUpdateNodes

/** A node that performs a type cast. */
class CastNode extends ExprNode {
  CastNode() { this.getExpr() instanceof CastExpr }
}

class DataFlowExpr = DotNet::Expr;

class DataFlowType = DotNet::Type;

class DataFlowLocation = Location;

/** Holds if `e` is an expression that always has the same Boolean value `val`. */
private predicate constantBooleanExpr(Expr e, boolean val) {
  e = any(AbstractValues::BooleanValue bv | val = bv.getValue()).getAnExpr()
  or
  exists(Ssa::ExplicitDefinition def, Expr src |
    e = def.getARead() and
    src = def.getADefinition().getSource() and
    constantBooleanExpr(src, val)
  )
}

/** An argument that always has the same Boolean value. */
private class ConstantBooleanArgumentNode extends ExprNode {
  ConstantBooleanArgumentNode() { constantBooleanExpr(this.(ArgumentNode).asExpr(), _) }

  /** Gets the Boolean value of this expression. */
  boolean getBooleanValue() { constantBooleanExpr(this.getExpr(), result) }
}

pragma[noinline]
private predicate viableConstantBooleanParamArg(
  SsaDefinitionNode paramNode, boolean b, DataFlowCall call
) {
  exists(ConstantBooleanArgumentNode arg |
    viableParamArg(call, paramNode, arg) and
    b = arg.getBooleanValue()
  )
}
