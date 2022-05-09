private import csharp
private import cil
private import dotnet
private import DataFlowPublic
private import DataFlowDispatch
private import DataFlowImplCommon
private import ControlFlowReachability
private import FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.csharp.dataflow.FlowSummary as FlowSummary
private import semmle.code.csharp.Conversion
private import semmle.code.csharp.dataflow.internal.SsaImpl as SsaImpl
private import semmle.code.csharp.ExprOrStmtParent
private import semmle.code.csharp.Unification
private import semmle.code.csharp.controlflow.Guards
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.frameworks.EntityFramework
private import semmle.code.csharp.frameworks.NHibernate
private import semmle.code.csharp.frameworks.system.Collections
private import semmle.code.csharp.frameworks.system.threading.Tasks

/** Gets the callable in which this node occurs. */
DataFlowCallable nodeGetEnclosingCallable(Node n) { result = n.getEnclosingCallable() }

/** Holds if `p` is a `ParameterNode` of `c` with position `pos`. */
predicate isParameterNode(ParameterNodeImpl p, DataFlowCallable c, ParameterPosition pos) {
  p.isParameterOf(c, pos)
}

/** Holds if `arg` is an `ArgumentNode` of `c` with position `pos`. */
predicate isArgumentNode(ArgumentNode arg, DataFlowCall c, ArgumentPosition pos) {
  arg.argumentOf(c, pos)
}

abstract class NodeImpl extends Node {
  /** Do not call: use `getEnclosingCallable()` instead. */
  abstract DataFlowCallable getEnclosingCallableImpl();

  /** Do not call: use `getType()` instead. */
  cached
  abstract DotNet::Type getTypeImpl();

  /** Gets the type of this node used for type pruning. */
  Gvn::GvnType getDataFlowType() {
    forceCachingInSameStage() and
    exists(Type t0 | result = Gvn::getGlobalValueNumber(t0) |
      t0 = getCSharpType(this.getType())
      or
      not exists(getCSharpType(this.getType())) and
      t0 instanceof ObjectType
    )
  }

  /** Do not call: use `getControlFlowNode()` instead. */
  cached
  abstract ControlFlow::Node getControlFlowNodeImpl();

  /** Do not call: use `getLocation()` instead. */
  cached
  abstract Location getLocationImpl();

  /** Do not call: use `toString()` instead. */
  cached
  abstract string toStringImpl();
}

private class ExprNodeImpl extends ExprNode, NodeImpl {
  override DataFlowCallable getEnclosingCallableImpl() {
    result = this.getExpr().(CIL::Expr).getEnclosingCallable()
    or
    result = this.getControlFlowNodeImpl().getEnclosingCallable()
  }

  override DotNet::Type getTypeImpl() {
    forceCachingInSameStage() and
    result = this.getExpr().getType()
  }

  override ControlFlow::Nodes::ElementNode getControlFlowNodeImpl() {
    forceCachingInSameStage() and this = TExprNode(result)
  }

  override Location getLocationImpl() {
    forceCachingInSameStage() and result = this.getExpr().getLocation()
  }

  override string toStringImpl() {
    forceCachingInSameStage() and
    result = this.getControlFlowNodeImpl().toString()
    or
    exists(CIL::Expr e |
      this = TCilExprNode(e) and
      result = e.toString()
    )
  }
}

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

/**
 * Holds if there is a control-flow path from `n1` to `n2`. `n2` is either an
 * expression node or an SSA definition node.
 */
pragma[nomagic]
predicate hasNodePath(ControlFlowReachabilityConfiguration conf, ExprNode n1, Node n2) {
  exists(Expr e1, ControlFlow::Node cfn1, Expr e2, ControlFlow::Node cfn2 |
    conf.hasExprPath(e1, cfn1, e2, cfn2)
  |
    cfn1 = n1.getControlFlowNode() and
    cfn2 = n2.(ExprNode).getControlFlowNode()
  )
  or
  exists(
    Expr e, ControlFlow::Node cfn, AssignableDefinition def, ControlFlow::Node cfnDef,
    Ssa::ExplicitDefinition ssaDef
  |
    conf.hasDefPath(e, cfn, def, cfnDef)
  |
    cfn = n1.getControlFlowNode() and
    ssaDef.getADefinition() = def and
    ssaDef.getControlFlowNode() = cfnDef and
    n2.(SsaDefinitionNode).getDefinition() = ssaDef
  )
}

/** Provides predicates related to local data flow. */
module LocalFlow {
  private class LocalExprStepConfiguration extends ControlFlowReachabilityConfiguration {
    LocalExprStepConfiguration() { this = "LocalExprStepConfiguration" }

    override predicate candidate(
      Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
    ) {
      exactScope = false and
      (
        e1 = e2.(ParenthesizedExpr).getExpr() and
        scope = e2 and
        isSuccessor = true
        or
        e1 = e2.(NullCoalescingExpr).getAnOperand() and
        scope = e2 and
        isSuccessor = true
        or
        e1 = e2.(SuppressNullableWarningExpr).getExpr() and
        scope = e2 and
        isSuccessor = true
        or
        e2 =
          any(ConditionalExpr ce |
            e1 = ce.getThen() or
            e1 = ce.getElse()
          ) and
        scope = e2 and
        isSuccessor = true
        or
        e1 = e2.(Cast).getExpr() and
        scope = e2 and
        isSuccessor = true
        or
        // An `=` expression, where the result of the expression is used
        e2 =
          any(AssignExpr ae |
            ae.getParent() = any(ControlFlowElement cfe | not cfe instanceof ExprStmt) and
            e1 = ae.getRValue()
          ) and
        scope = e2 and
        isSuccessor = true
        or
        e1 = e2.(ObjectCreation).getInitializer() and
        scope = e2 and
        isSuccessor = false
        or
        e1 = e2.(ArrayCreation).getInitializer() and
        scope = e2 and
        isSuccessor = false
        or
        e1 = e2.(SwitchExpr).getACase().getBody() and
        scope = e2 and
        isSuccessor = true
        or
        exists(WithExpr we |
          scope = we and
          isSuccessor = true
        |
          e1 = we.getExpr() and
          e2 = we.getInitializer()
          or
          e1 = we.getInitializer() and
          e2 = we
        )
        or
        scope = any(AssignExpr ae | ae.getLValue().(TupleExpr) = e2 and ae.getRValue() = e1) and
        isSuccessor = false
        or
        isSuccessor = true and
        exists(ControlFlowElement cfe | cfe = e2.(TupleExpr).(PatternExpr).getPatternMatch() |
          cfe.(IsExpr).getExpr() = e1 and scope = cfe
          or
          exists(Switch sw | sw.getACase() = cfe and sw.getExpr() = e1 and scope = sw)
        )
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

  private predicate localFlowStepCil(Node nodeFrom, Node nodeTo) {
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
      this =
        any(Ssa::ImplicitQualifierDefinition qdef |
          qdef.getQualifierDefinition() instanceof UncertainExplicitSsaDefinition
        )
    }
  }

  /**
   * Holds if `nodeFrom` is a last node referencing SSA definition `def`, which
   * can reach `next`.
   */
  private predicate localFlowSsaInput(Node nodeFrom, Ssa::Definition def, Ssa::Definition next) {
    exists(ControlFlow::BasicBlock bb, int i | SsaImpl::lastRefBeforeRedef(def, bb, i, next) |
      def.definesAt(_, bb, i) and
      def = getSsaDefinition(nodeFrom)
      or
      nodeFrom.asExprAtNode(bb.getNode(i)) instanceof AssignableRead
    )
  }

  private Ssa::Definition getSsaDefinition(Node n) {
    result = n.(SsaDefinitionNode).getDefinition()
    or
    result = n.(ExplicitParameterNode).getSsaDefinition()
  }

  /**
   * Holds if there is a local use-use flow step from `nodeFrom` to `nodeTo`
   * involving SSA definition `def`.
   */
  predicate localSsaFlowStepUseUse(Ssa::Definition def, Node nodeFrom, Node nodeTo) {
    exists(ControlFlow::Node cfnFrom, ControlFlow::Node cfnTo |
      SsaImpl::adjacentReadPairSameVar(def, cfnFrom, cfnTo) and
      nodeTo = TExprNode(cfnTo) and
      nodeFrom = TExprNode(cfnFrom)
    )
  }

  /**
   * Holds if there is a local flow step from `nodeFrom` to `nodeTo` involving
   * SSA definition `def.
   */
  predicate localSsaFlowStep(Ssa::Definition def, Node nodeFrom, Node nodeTo) {
    // Flow from SSA definition/parameter to first read
    exists(ControlFlow::Node cfn |
      def = getSsaDefinition(nodeFrom) and
      nodeTo.asExprAtNode(cfn) = def.getAFirstReadAtNode(cfn)
    )
    or
    // Flow from read to next read
    localSsaFlowStepUseUse(def, nodeFrom.(PostUpdateNode).getPreUpdateNode(), nodeTo)
    or
    // Flow into phi node
    exists(Ssa::PhiNode phi |
      localFlowSsaInput(nodeFrom, def, phi) and
      phi = nodeTo.(SsaDefinitionNode).getDefinition() and
      def = phi.getAnInput()
    )
    or
    // Flow into uncertain SSA definition
    exists(LocalFlow::UncertainExplicitSsaDefinition uncertain |
      localFlowSsaInput(nodeFrom, def, uncertain) and
      uncertain = nodeTo.(SsaDefinitionNode).getDefinition() and
      def = uncertain.getPriorDefinition()
    )
  }

  /**
   * Holds if the source variable of SSA definition `def` is an instance field.
   */
  predicate usesInstanceField(Ssa::Definition def) {
    exists(Ssa::SourceVariables::FieldOrPropSourceVariable fp | fp = def.getSourceVariable() |
      not fp.getAssignable().(Modifiable).isStatic()
    )
  }

  predicate localFlowCapturedVarStep(Node nodeFrom, ImplicitCapturedArgumentNode nodeTo) {
    // Flow from SSA definition to implicit captured variable argument
    exists(Ssa::ExplicitDefinition def, ControlFlow::Nodes::ElementNode call |
      def = getSsaDefinition(nodeFrom) and
      def.isCapturedVariableDefinitionFlowIn(_, call, _) and
      nodeTo = TImplicitCapturedArgumentNode(call, def.getSourceVariable().getAssignable())
    )
  }

  predicate localFlowStepCommon(Node nodeFrom, Node nodeTo) {
    exists(Ssa::Definition def |
      localSsaFlowStep(def, nodeFrom, nodeTo) and
      not usesInstanceField(def)
    )
    or
    hasNodePath(any(LocalExprStepConfiguration x), nodeFrom, nodeTo)
    or
    ThisFlow::adjacentThisRefs(nodeFrom, nodeTo)
    or
    ThisFlow::adjacentThisRefs(nodeFrom.(PostUpdateNode).getPreUpdateNode(), nodeTo)
    or
    localFlowStepCil(nodeFrom, nodeTo)
  }

  /**
   * Holds if node `n` should not be included in the exposed local data/taint
   * flow relations. This is the case for nodes that are only relevant for
   * inter-procedurality or field-sensitivity.
   */
  predicate excludeFromExposedRelations(Node n) {
    n instanceof SummaryNode or
    n instanceof ImplicitCapturedArgumentNode
  }
}

/**
 * This is the local flow predicate that is used as a building block in global
 * data flow. It excludes SSA flow through instance fields, as flow through fields
 * is handled by the global data-flow library, but includes various other steps
 * that are only relevant for global flow.
 */
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
  LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
  or
  exists(Ssa::Definition def |
    LocalFlow::localSsaFlowStepUseUse(def, nodeFrom, nodeTo) and
    not FlowSummaryImpl::Private::Steps::summaryClearsContentArg(nodeFrom, _) and
    not LocalFlow::usesInstanceField(def)
  )
  or
  LocalFlow::localFlowCapturedVarStep(nodeFrom, nodeTo)
  or
  FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom, nodeTo, true)
  or
  nodeTo.(ObjectCreationNode).getPreUpdateNode() = nodeFrom.(ObjectInitializerNode)
}

pragma[noinline]
private Expr getImplicitArgument(Call c, int pos) {
  result = c.getArgument(pos) and
  not exists(result.getExplicitArgumentName())
}

pragma[nomagic]
private Expr getExplicitArgument(Call c, string name) {
  result = c.getAnArgument() and
  result.getExplicitArgumentName() = name
}

/**
 * Holds if `arg` is a `params` argument of `c`, for parameter `p`, and `arg` will
 * be wrapped in an array by the C# compiler.
 */
private predicate isParamsArg(Call c, Expr arg, Parameter p) {
  exists(Callable target, int numArgs |
    target = c.getTarget() and
    p = target.getAParameter() and
    p.isParams() and
    numArgs = c.getNumberOfArguments() and
    arg =
      [
        getImplicitArgument(c, [p.getPosition() .. numArgs - 1]),
        getExplicitArgument(c, p.getName())
      ]
  |
    numArgs > target.getNumberOfParameters()
    or
    not arg.getType().isImplicitlyConvertibleTo(p.getType())
  )
}

/** An argument of a C# call (including qualifier arguments). */
private class Argument extends Expr {
  private Expr call;
  private ArgumentPosition arg;

  Argument() {
    call =
      any(DispatchCall dc |
        this = dc.getArgument(arg.getPosition()) and
        not isParamsArg(_, this, _)
        or
        this = dc.getQualifier() and
        arg.isQualifier() and
        not dc.getAStaticTarget().(Modifiable).isStatic()
      ).getCall()
    or
    this = call.(DelegateLikeCall).getArgument(arg.getPosition())
  }

  /**
   * Holds if this expression is the `i`th argument of `c`.
   *
   * Qualifier arguments have index `-1`.
   */
  predicate isArgumentOf(Expr c, ArgumentPosition pos) { c = call and pos = arg }
}

/**
 * Holds if `e` is an assignment of `src` to field or property `c` of `q`.
 *
 * `postUpdate` indicates whether the store targets a post-update node.
 */
private predicate fieldOrPropertyStore(Expr e, Content c, Expr src, Expr q, boolean postUpdate) {
  exists(FieldOrProperty f |
    c = f.getContent() and
    (
      f.isFieldLike() and
      f instanceof InstanceFieldOrProperty
      or
      exists(
        FlowSummary::SummarizedCallable callable,
        FlowSummaryImpl::Public::SummaryComponentStack input
      |
        callable.propagatesFlow(input, _, _) and
        input.contains(FlowSummary::SummaryComponent::content(f.getContent()))
      )
    )
  |
    // Direct assignment, `q.f = src`
    exists(FieldOrPropertyAccess fa, AssignableDefinition def |
      def.getTargetAccess() = fa and
      f = fa.getTarget() and
      src = def.getSource() and
      q = fa.getQualifier() and
      e = def.getExpr() and
      postUpdate = true
    )
    or
    // `with` expression initializer, `x with { f = src }`
    e =
      any(WithExpr we |
        exists(MemberInitializer mi |
          q = we and
          mi = we.getInitializer().getAMemberInitializer() and
          f = mi.getInitializedMember() and
          src = mi.getRValue() and
          postUpdate = false
        )
      )
    or
    // Object initializer, `new C() { f = src }`
    exists(MemberInitializer mi |
      e = q and
      mi = q.(ObjectInitializer).getAMemberInitializer() and
      q.getParent() instanceof ObjectCreation and
      f = mi.getInitializedMember() and
      src = mi.getRValue() and
      postUpdate = false
    )
    or
    // Tuple element, `(..., src, ...)` `f` is `ItemX` of tuple `q`
    e =
      any(TupleExpr te |
        exists(int i |
          e = q and
          src = te.getArgument(i) and
          te.isConstruction() and
          f = q.getType().(TupleType).getElement(i) and
          postUpdate = false
        )
      )
  )
}

/** Holds if property `p1` overrides or implements source declaration property `p2`. */
private predicate overridesOrImplementsSourceDecl(Property p1, Property p2) {
  p1.getOverridee*().getUnboundDeclaration() = p2
  or
  p1.getAnUltimateImplementee().getUnboundDeclaration() = p2
}

/**
 * Holds if `e2` is an expression that reads field or property `c` from
 * expression `e1`. This takes overriding into account for properties written
 * from library code.
 */
private predicate fieldOrPropertyRead(Expr e1, Content c, FieldOrPropertyRead e2) {
  e1 = e2.getQualifier() and
  exists(FieldOrProperty ret | c = ret.getContent() |
    ret = e2.getTarget()
    or
    exists(Property target |
      target.getGetter() = e2.(PropertyCall).getARuntimeTarget() and
      overridesOrImplementsSourceDecl(target, ret)
    )
  )
}

/**
 * Holds if `e` is an expression that adds `src` to array `a`.
 *
 * `postUpdate` indicates whether the store targets a post-update node.
 */
private predicate arrayStore(Expr e, Expr src, Expr a, boolean postUpdate) {
  // Direct assignment, `a[i] = src`
  exists(AssignableDefinition def |
    a = def.getTargetAccess().(ArrayWrite).getQualifier() and
    src = def.getSource() and
    e = def.getExpr() and
    postUpdate = true
  )
  or
  // Array initializer, `new [] { src }`
  src = a.(ArrayInitializer).getAnElement() and
  e = a and
  postUpdate = false
  or
  // Member initalizer, `new C { Array = { [i] = src } }`
  exists(MemberInitializer mi |
    mi = a.(ObjectInitializer).getAMemberInitializer() and
    mi.getLValue() instanceof ArrayAccess and
    mi.getRValue() = src and
    e = a and
    postUpdate = false
  )
}

/**
 * Holds if `e2` is an expression that reads an array element from
 * from expresion `e1`.
 */
private predicate arrayRead(Expr e1, ArrayRead e2) { e1 = e2.getQualifier() }

private Type getCSharpType(DotNet::Type t) {
  result = t
  or
  not t instanceof Type and
  result.matchesHandle(t)
}

private class RelevantDataFlowType extends DataFlowType {
  RelevantDataFlowType() { this = any(NodeImpl n).getDataFlowType() }
}

/** A GVN type that is either a `DataFlowType` or unifiable with a `DataFlowType`. */
private class DataFlowTypeOrUnifiable extends Gvn::GvnType {
  pragma[nomagic]
  DataFlowTypeOrUnifiable() {
    this instanceof RelevantDataFlowType or
    Gvn::unifiable(any(RelevantDataFlowType t), this)
  }
}

pragma[noinline]
private TypeParameter getATypeParameterSubType(DataFlowTypeOrUnifiable t) {
  not t instanceof Gvn::TypeParameterGvnType and
  exists(Type t0 | t = Gvn::getGlobalValueNumber(t0) | implicitConversionRestricted(result, t0))
}

pragma[noinline]
private TypeParameter getATypeParameterSubTypeRestricted(RelevantDataFlowType t) {
  result = getATypeParameterSubType(t)
}

pragma[noinline]
private Gvn::GvnType getANonTypeParameterSubType(DataFlowTypeOrUnifiable t) {
  not t instanceof Gvn::TypeParameterGvnType and
  not result instanceof Gvn::TypeParameterGvnType and
  exists(Type t1, Type t2 |
    implicitConversionRestricted(t1, t2) and
    result = Gvn::getGlobalValueNumber(t1) and
    t = Gvn::getGlobalValueNumber(t2)
  )
}

pragma[noinline]
private Gvn::GvnType getANonTypeParameterSubTypeRestricted(RelevantDataFlowType t) {
  result = getANonTypeParameterSubType(t)
}

/** A collection of cached types and predicates to be evaluated in the same stage. */
cached
private module Cached {
  private import TaintTrackingPrivate as TaintTrackingPrivate

  // Add artificial dependencies to enforce all cached predicates are evaluated
  // in the "DataFlowImplCommon stage"
  private predicate forceCaching() {
    TaintTrackingPrivate::forceCachingInSameStage() or
    exists(any(NodeImpl n).getTypeImpl()) or
    exists(any(NodeImpl n).getControlFlowNodeImpl()) or
    exists(any(NodeImpl n).getLocationImpl()) or
    exists(any(NodeImpl n).toStringImpl())
  }

  cached
  newtype TNode =
    TExprNode(ControlFlow::Nodes::ElementNode cfn) {
      forceCaching() and
      cfn.getElement() instanceof Expr
    } or
    TCilExprNode(CIL::Expr e) { e.getImplementation() instanceof CIL::BestImplementation } or
    TSsaDefinitionNode(Ssa::Definition def) {
      // Handled by `TExplicitParameterNode` below
      not def.(Ssa::ExplicitDefinition).getADefinition() instanceof
        AssignableDefinitions::ImplicitParameterDefinition
    } or
    TExplicitParameterNode(DotNet::Parameter p) { p = any(DataFlowCallable c).getAParameter() } or
    TInstanceParameterNode(Callable c) {
      c.isUnboundDeclaration() and not c.(Modifiable).isStatic()
    } or
    TYieldReturnNode(ControlFlow::Nodes::ElementNode cfn) {
      any(Callable c).canYieldReturn(cfn.getElement())
    } or
    TAsyncReturnNode(ControlFlow::Nodes::ElementNode cfn) {
      any(Callable c | c.(Modifiable).isAsync()).canReturn(cfn.getElement())
    } or
    TImplicitCapturedArgumentNode(ControlFlow::Nodes::ElementNode cfn, LocalScopeVariable v) {
      exists(Ssa::ExplicitDefinition def | def.isCapturedVariableDefinitionFlowIn(_, cfn, _) |
        v = def.getSourceVariable().getAssignable()
      )
    } or
    TMallocNode(ControlFlow::Nodes::ElementNode cfn) { cfn.getElement() instanceof ObjectCreation } or
    TObjectInitializerNode(ControlFlow::Nodes::ElementNode cfn) {
      cfn.getElement().(ObjectCreation).hasInitializer()
    } or
    TExprPostUpdateNode(ControlFlow::Nodes::ExprNode cfn) {
      exists(Expr e | e = cfn.getExpr() |
        exists(Type t | t = e.(Argument).stripCasts().getType() |
          t instanceof RefType and
          not t instanceof NullType
          or
          t = any(TypeParameter tp | not tp.isValueType())
        )
        or
        fieldOrPropertyStore(_, _, _, e, true)
        or
        arrayStore(_, _, e, true)
        or
        // needed for reverse stores; e.g. `x.f1.f2 = y` induces
        // a store step of `f1` into `x`
        exists(TExprPostUpdateNode upd, Expr read |
          upd = TExprPostUpdateNode(read.getAControlFlowNode())
        |
          fieldOrPropertyRead(e, _, read)
          or
          arrayRead(e, read)
        )
      )
    } or
    TSummaryNode(FlowSummary::SummarizedCallable c, FlowSummaryImpl::Private::SummaryNodeState state) {
      FlowSummaryImpl::Private::summaryNodeRange(c, state)
    } or
    TParamsArgumentNode(ControlFlow::Node callCfn) {
      callCfn = any(Call c | isParamsArg(c, _, _)).getAControlFlowNode()
    }

  /**
   * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
   * (intra-procedural) step.
   */
  cached
  predicate localFlowStepImpl(Node nodeFrom, Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    LocalFlow::localSsaFlowStepUseUse(_, nodeFrom, nodeTo)
    or
    exists(Ssa::Definition def |
      LocalFlow::localSsaFlowStep(def, nodeFrom, nodeTo) and
      LocalFlow::usesInstanceField(def)
    )
    or
    // Simple flow through library code is included in the exposed local
    // step relation, even though flow is technically inter-procedural
    FlowSummaryImpl::Private::Steps::summaryThroughStep(nodeFrom, nodeTo, true)
  }

  cached
  newtype TContent =
    TFieldContent(Field f) { f.isUnboundDeclaration() } or
    TPropertyContent(Property p) { p.isUnboundDeclaration() } or
    TElementContent() or
    TSyntheticFieldContent(SyntheticField f)

  pragma[nomagic]
  private predicate commonSubTypeGeneral(DataFlowTypeOrUnifiable t1, RelevantDataFlowType t2) {
    not t1 instanceof Gvn::TypeParameterGvnType and
    t1 = t2
    or
    getATypeParameterSubType(t1) = getATypeParameterSubTypeRestricted(t2)
    or
    getANonTypeParameterSubType(t1) = getANonTypeParameterSubTypeRestricted(t2)
  }

  /**
   * Holds if GVNs `t1` and `t2` may have a common sub type. Neither `t1` nor
   * `t2` are allowed to be type parameters.
   */
  cached
  predicate commonSubType(RelevantDataFlowType t1, RelevantDataFlowType t2) {
    commonSubTypeGeneral(t1, t2)
  }

  cached
  predicate commonSubTypeUnifiableLeft(RelevantDataFlowType t1, RelevantDataFlowType t2) {
    exists(Gvn::GvnType t |
      Gvn::unifiable(t1, t) and
      commonSubTypeGeneral(t, t2)
    )
  }
}

import Cached

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) {
  exists(Ssa::Definition def | def = n.(SsaDefinitionNode).getDefinition() |
    def instanceof Ssa::PhiNode
    or
    def instanceof Ssa::ImplicitEntryDefinition
    or
    def instanceof Ssa::ImplicitCallDefinition
  )
  or
  exists(Parameter p | p = n.(ParameterNode).getParameter() |
    not p.fromSource()
    or
    p.getCallable() instanceof FlowSummary::SummarizedCallable
  )
  or
  n =
    TInstanceParameterNode(any(Callable c |
        not c.fromSource() or c instanceof FlowSummary::SummarizedCallable
      ))
  or
  n instanceof YieldReturnNode
  or
  n instanceof AsyncReturnNode
  or
  n instanceof ImplicitCapturedArgumentNode
  or
  n instanceof MallocNode
  or
  n instanceof SummaryNode
  or
  n instanceof ParamsArgumentNode
  or
  n.asExpr() = any(WithExpr we).getInitializer()
}

/** An SSA definition, viewed as a node in a data flow graph. */
class SsaDefinitionNode extends NodeImpl, TSsaDefinitionNode {
  Ssa::Definition def;

  SsaDefinitionNode() { this = TSsaDefinitionNode(def) }

  /** Gets the underlying SSA definition. */
  Ssa::Definition getDefinition() { result = def }

  override DataFlowCallable getEnclosingCallableImpl() { result = def.getEnclosingCallable() }

  override Type getTypeImpl() { result = def.getSourceVariable().getType() }

  override ControlFlow::Node getControlFlowNodeImpl() { result = def.getControlFlowNode() }

  override Location getLocationImpl() { result = def.getLocation() }

  override string toStringImpl() { result = def.toString() }
}

abstract class ParameterNodeImpl extends NodeImpl {
  abstract predicate isParameterOf(DataFlowCallable c, ParameterPosition pos);
}

private module ParameterNodes {
  /**
   * The value of an explicit parameter at function entry, viewed as a node in a data
   * flow graph.
   */
  class ExplicitParameterNode extends ParameterNodeImpl, TExplicitParameterNode {
    private DotNet::Parameter parameter;

    ExplicitParameterNode() { this = TExplicitParameterNode(parameter) }

    /** Gets the SSA definition corresponding to this parameter, if any. */
    Ssa::ExplicitDefinition getSsaDefinition() {
      result.getADefinition().(AssignableDefinitions::ImplicitParameterDefinition).getParameter() =
        parameter
    }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      c.getParameter(pos.getPosition()) = parameter
    }

    override DataFlowCallable getEnclosingCallableImpl() { result = parameter.getCallable() }

    override DotNet::Type getTypeImpl() { result = parameter.getType() }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = parameter.getLocation() }

    override string toStringImpl() { result = parameter.toString() }
  }

  /** An implicit instance (`this`) parameter. */
  class InstanceParameterNode extends ParameterNodeImpl, TInstanceParameterNode {
    private Callable callable;

    InstanceParameterNode() { this = TInstanceParameterNode(callable) }

    /** Gets the callable containing this implicit instance parameter. */
    Callable getCallable() { result = callable }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      callable = c and pos.isThisParameter()
    }

    override DataFlowCallable getEnclosingCallableImpl() { result = callable }

    override Type getTypeImpl() { result = callable.getDeclaringType() }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = callable.getLocation() }

    override string toStringImpl() { result = "this" }
  }

  /** An implicit entry definition for a captured variable. */
  class SsaCapturedEntryDefinition extends Ssa::ImplicitEntryDefinition {
    private LocalScopeVariable v;

    SsaCapturedEntryDefinition() { this.getSourceVariable().getAssignable() = v }

    LocalScopeVariable getVariable() { result = v }
  }

  /**
   * The value of an implicit captured variable parameter at function entry,
   * viewed as a node in a data flow graph.
   *
   * An implicit parameter is added in order to be able to track flow into
   * capturing callables, as if an explicit `ref` parameter had been used:
   *
   * ```csharp
   * void M() {             void M() {
   *   int i = 0;             int i = 0;
   *   void In() {    =>      void In(ref int i0) { // implicit i0 parameter
   *     Use(i);                Use(i0);
   *   }                      }
   *   In();                  In(ref i);
   * }                      }
   * ```
   */
  class ImplicitCapturedParameterNode extends ParameterNodeImpl, SsaDefinitionNode {
    override SsaCapturedEntryDefinition def;

    ImplicitCapturedParameterNode() { def = this.getDefinition() }

    /** Gets the captured variable that this implicit parameter models. */
    LocalScopeVariable getVariable() { result = def.getVariable() }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      pos.isImplicitCapturedParameterPosition(def.getSourceVariable().getAssignable()) and
      c = this.getEnclosingCallable()
    }
  }
}

import ParameterNodes

/** A data-flow node that represents a call argument. */
class ArgumentNode extends Node instanceof ArgumentNodeImpl {
  /** Holds if this argument occurs at the given position in the given call. */
  final predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
    super.argumentOf(call, pos)
  }

  /** Gets the call in which this node is an argument. */
  DataFlowCall getCall() { this.argumentOf(result, _) }
}

abstract private class ArgumentNodeImpl extends Node {
  abstract predicate argumentOf(DataFlowCall call, ArgumentPosition pos);
}

private module ArgumentNodes {
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

  /** A data-flow node that represents an explicit call argument. */
  class ExplicitArgumentNode extends ArgumentNodeImpl {
    ExplicitArgumentNode() {
      this.asExpr() instanceof Argument
      or
      this.asExpr() = any(CIL::Call call).getAnArgument()
    }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
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
        arg = c.getArgument(pos.getPosition())
      )
    }
  }

  /**
   * The value of a captured variable as an implicit argument of a call, viewed
   * as a node in a data flow graph.
   *
   * An implicit node is added in order to be able to track flow into capturing
   * callables, as if an explicit parameter had been used:
   *
   * ```csharp
   * void M() {                       void M() {
   *   int i = 0;                       int i = 0;
   *   void Out() { i = 1; }    =>      void Out(ref int i0) { i0 = 1; }
   *   Out();                           Out(ref i); // implicit argument
   *   Use(i);                          Use(i)
   * }                                }
   * ```
   */
  class ImplicitCapturedArgumentNode extends ArgumentNodeImpl, NodeImpl,
    TImplicitCapturedArgumentNode {
    private LocalScopeVariable v;
    private ControlFlow::Nodes::ElementNode cfn;

    ImplicitCapturedArgumentNode() { this = TImplicitCapturedArgumentNode(cfn, v) }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      pos.isImplicitCapturedArgumentPosition(v) and
      call.getControlFlowNode() = cfn
    }

    override DataFlowCallable getEnclosingCallableImpl() { result = cfn.getEnclosingCallable() }

    override Type getTypeImpl() { result = v.getType() }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = cfn.getLocation() }

    override string toStringImpl() { result = "[implicit argument] " + v }
  }

  /**
   * A node that corresponds to the value of an object creation (`new C()`) before
   * the constructor has run.
   */
  class MallocNode extends ArgumentNodeImpl, NodeImpl, TMallocNode {
    private ControlFlow::Nodes::ElementNode cfn;

    MallocNode() { this = TMallocNode(cfn) }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      call = TNonDelegateCall(cfn, _) and
      pos.isQualifier()
    }

    override ControlFlow::Node getControlFlowNodeImpl() { result = cfn }

    override DataFlowCallable getEnclosingCallableImpl() { result = cfn.getEnclosingCallable() }

    override Type getTypeImpl() { result = cfn.getElement().(Expr).getType() }

    override Location getLocationImpl() { result = cfn.getLocation() }

    override string toStringImpl() { result = "malloc" }
  }

  /**
   * A data-flow node that represents the implicit array creation in a call to a
   * callable with a `params` parameter. For example, there is an implicit array
   * creation `new [] { "a", "b", "c" }` in
   *
   * ```csharp
   * void Foo(params string[] args) { ... }
   * Foo("a", "b", "c");
   * ```
   *
   * Note that array creations are not inserted when there is only one argument,
   * and that argument is itself a compatible array, for example
   * `Foo(new[] { "a", "b", "c" })`.
   */
  class ParamsArgumentNode extends ArgumentNodeImpl, NodeImpl, TParamsArgumentNode {
    private ControlFlow::Node callCfn;

    ParamsArgumentNode() { this = TParamsArgumentNode(callCfn) }

    private Parameter getParameter() {
      callCfn = any(Call c | isParamsArg(c, _, result)).getAControlFlowNode()
    }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      callCfn = call.getControlFlowNode() and
      pos.getPosition() = this.getParameter().getPosition()
    }

    override DataFlowCallable getEnclosingCallableImpl() { result = callCfn.getEnclosingCallable() }

    override Type getTypeImpl() { result = this.getParameter().getType() }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = callCfn.getLocation() }

    override string toStringImpl() { result = "[implicit array creation] " + callCfn }
  }

  private class SummaryArgumentNode extends SummaryNode, ArgumentNodeImpl {
    SummaryArgumentNode() { FlowSummaryImpl::Private::summaryArgumentNode(_, this, _) }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      FlowSummaryImpl::Private::summaryArgumentNode(call, this, pos)
    }
  }
}

import ArgumentNodes

/** A data-flow node that represents a value returned by a callable. */
abstract class ReturnNode extends Node {
  /** Gets the kind of this return node. */
  abstract ReturnKind getKind();
}

private module ReturnNodes {
  /**
   * A data-flow node that represents an expression returned by a callable,
   * either using a `return` statement or an expression body (`=>`).
   */
  class ExprReturnNode extends ReturnNode, ExprNode {
    ExprReturnNode() {
      exists(DotNet::Callable c, DotNet::Expr e | e = this.getExpr() |
        c.canReturn(e) and not c.(Modifiable).isAsync()
      )
    }

    override NormalReturnKind getKind() { exists(result) }
  }

  /**
   * A data-flow node that represents an assignment to an `out` or a `ref`
   * parameter.
   */
  class OutRefReturnNode extends ReturnNode, SsaDefinitionNode {
    OutRefReturnKind kind;

    OutRefReturnNode() {
      exists(Parameter p |
        this.getDefinition().isLiveOutRefParameterDefinition(p) and
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
   * A `yield return` node. A node is synthesized in order to be able to model
   * `yield return`s as stores into collections, i.e., there is flow from `e`
   * to `yield return e [e]`.
   */
  class YieldReturnNode extends ReturnNode, NodeImpl, TYieldReturnNode {
    private ControlFlow::Nodes::ElementNode cfn;
    private YieldReturnStmt yrs;

    YieldReturnNode() { this = TYieldReturnNode(cfn) and yrs.getExpr().getAControlFlowNode() = cfn }

    YieldReturnStmt getYieldReturnStmt() { result = yrs }

    override NormalReturnKind getKind() { any() }

    override DataFlowCallable getEnclosingCallableImpl() { result = yrs.getEnclosingCallable() }

    override Type getTypeImpl() { result = yrs.getEnclosingCallable().getReturnType() }

    override ControlFlow::Node getControlFlowNodeImpl() { result = cfn }

    override Location getLocationImpl() { result = yrs.getLocation() }

    override string toStringImpl() { result = yrs.toString() }
  }

  /**
   * A synthesized `return` node for returned expressions inside `async` methods.
   */
  class AsyncReturnNode extends ReturnNode, NodeImpl, TAsyncReturnNode {
    private ControlFlow::Nodes::ElementNode cfn;
    private Expr expr;

    AsyncReturnNode() { this = TAsyncReturnNode(cfn) and expr = cfn.getElement() }

    Expr getExpr() { result = expr }

    override NormalReturnKind getKind() { any() }

    override DataFlowCallable getEnclosingCallableImpl() { result = expr.getEnclosingCallable() }

    override Type getTypeImpl() { result = expr.getEnclosingCallable().getReturnType() }

    override ControlFlow::Node getControlFlowNodeImpl() { result = cfn }

    override Location getLocationImpl() { result = expr.getLocation() }

    override string toStringImpl() { result = expr.toString() }
  }

  /**
   * The value of a captured variable as an implicit return from a call, viewed
   * as a node in a data flow graph.
   *
   * An implicit node is added in order to be able to track flow out of capturing
   * callables, as if an explicit `ref` parameter had been used:
   *
   * ```csharp
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

  private class SummaryReturnNode extends SummaryNode, ReturnNode {
    private ReturnKind rk;

    SummaryReturnNode() {
      FlowSummaryImpl::Private::summaryReturnNode(this, rk) and
      not rk instanceof JumpReturnKind
      or
      exists(Parameter p, int pos |
        summaryPostUpdateNodeIsOutOrRef(this, p) and
        pos = p.getPosition()
      |
        p.isOut() and rk.(OutReturnKind).getPosition() = pos
        or
        p.isRef() and rk.(RefReturnKind).getPosition() = pos
      )
    }

    override ReturnKind getKind() { result = rk }
  }
}

/**
 * Holds if summary node `n` is a post-update node for `out`/`ref` parameter `p`.
 * In this case we adjust it to instead be a return node.
 */
private predicate summaryPostUpdateNodeIsOutOrRef(SummaryNode n, Parameter p) {
  exists(ParameterNode pn |
    FlowSummaryImpl::Private::summaryPostUpdateNode(n, pn) and
    pn.getParameter() = p and
    p.isOutOrRef()
  )
}

import ReturnNodes

/** A data-flow node that represents the output of a call. */
abstract class OutNode extends Node {
  /** Gets the underlying call, where this node is a corresponding output of kind `kind`. */
  abstract DataFlowCall getCall(ReturnKind kind);
}

private module OutNodes {
  private import semmle.code.csharp.frameworks.system.Collections
  private import semmle.code.csharp.frameworks.system.collections.Generic

  private DataFlowCall csharpCall(Expr e, ControlFlow::Node cfn) {
    e = any(DispatchCall dc | result = TNonDelegateCall(cfn, dc)).getCall() or
    result = TExplicitDelegateLikeCall(cfn, e)
  }

  /**
   * A data-flow node that reads a value returned directly by a callable,
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
      result = call and
      (
        kind instanceof NormalReturnKind and
        not call.getExpr().getType() instanceof VoidType
      )
    }
  }

  class ObjectOrCollectionInitializerConfiguration extends ControlFlowReachabilityConfiguration {
    ObjectOrCollectionInitializerConfiguration() {
      this = "ObjectOrCollectionInitializerConfiguration"
    }

    override predicate candidate(
      Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
    ) {
      exactScope = false and
      scope = e1 and
      isSuccessor = true and
      exists(ObjectOrCollectionInitializer init | init = e1.(ObjectCreation).getInitializer() |
        // E.g. `new Dictionary<int, string>{ {0, "a"}, {1, "b"} }`
        e2 = init.(CollectionInitializer).getAnElementInitializer()
        or
        // E.g. `new Dictionary<int, string>() { [0] = "a", [1] = "b" }`
        e2 = init.(ObjectInitializer).getAMemberInitializer().getLValue()
      )
    }
  }

  /**
   * A data-flow node that reads a value returned implicitly by a callable
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
        additionalCalls = true and
        call = TTransitiveCapturedCall(cfn, n.getEnclosingCallable())
      )
    }

    override DataFlowCall getCall(ReturnKind kind) {
      result = call and
      kind.(ImplicitCapturedReturnKind).getVariable() =
        this.getDefinition().getSourceVariable().getAssignable()
    }
  }

  /**
   * A data-flow node that reads a value returned by a callable using an
   * `out` or `ref` parameter.
   */
  class ParamOutNode extends OutNode, AssignableDefinitionNode {
    private AssignableDefinitions::OutRefDefinition outRefDef;
    private ControlFlow::Node cfn;

    ParamOutNode() { outRefDef = this.getDefinitionAtNode(cfn) }

    override DataFlowCall getCall(ReturnKind kind) {
      result = csharpCall(_, cfn) and
      exists(Parameter p |
        p.getUnboundDeclaration().getPosition() = kind.(OutRefReturnKind).getPosition() and
        outRefDef.getTargetAccess() = result.getExpr().(Call).getArgumentForParameter(p)
      )
    }
  }

  private class SummaryOutNode extends SummaryNode, OutNode {
    SummaryOutNode() { FlowSummaryImpl::Private::summaryOutNode(_, this, _) }

    override DataFlowCall getCall(ReturnKind kind) {
      FlowSummaryImpl::Private::summaryOutNode(result, this, kind)
    }
  }
}

import OutNodes

/** A data-flow node used to model flow summaries. */
class SummaryNode extends NodeImpl, TSummaryNode {
  private FlowSummary::SummarizedCallable c;
  private FlowSummaryImpl::Private::SummaryNodeState state;

  SummaryNode() { this = TSummaryNode(c, state) }

  override DataFlowCallable getEnclosingCallableImpl() { result = c }

  override DataFlowType getDataFlowType() {
    result = FlowSummaryImpl::Private::summaryNodeType(this)
  }

  override DotNet::Type getTypeImpl() { none() }

  override ControlFlow::Node getControlFlowNodeImpl() { none() }

  override Location getLocationImpl() { result = c.getLocation() }

  override string toStringImpl() { result = "[summary] " + state + " in " + c }
}

/** A field or a property. */
class FieldOrProperty extends Assignable, Modifiable {
  FieldOrProperty() {
    this instanceof Field
    or
    this instanceof Property
  }

  /** Holds if this is either a field or a field-like property. */
  predicate isFieldLike() {
    this instanceof Field or
    this =
      any(Property p |
        not p.isOverridableOrImplementable() and
        (
          p.isAutoImplemented()
          or
          p.matchesHandle(any(CIL::TrivialProperty tp))
          or
          p.getDeclaringType() instanceof AnonymousClass
        )
      )
  }

  /** Gets the content that matches this field or property. */
  Content getContent() {
    result.(FieldContent).getField() = this.getUnboundDeclaration()
    or
    result.(PropertyContent).getProperty() = this.getUnboundDeclaration()
  }
}

private class InstanceFieldOrProperty extends FieldOrProperty {
  InstanceFieldOrProperty() { not this.isStatic() }
}

/**
 * An access to a field or a property.
 */
class FieldOrPropertyAccess extends AssignableAccess, QualifiableExpr {
  FieldOrPropertyAccess() { this.getTarget() instanceof FieldOrProperty }
}

private class FieldOrPropertyRead extends FieldOrPropertyAccess, AssignableRead {
  /**
   * Holds if this field-like read is not completely determined by explicit
   * SSA updates.
   */
  predicate hasNonlocalValue() {
    exists(Ssa::Definition def, Ssa::ImplicitDefinition idef |
      def.getARead() = this and
      idef = def.getAnUltimateDefinition()
    |
      idef instanceof Ssa::ImplicitEntryDefinition or
      idef instanceof Ssa::ImplicitCallDefinition
    )
  }
}

/**
 * Holds if `pred` can flow to `succ`, by jumping from one callable to
 * another. Additional steps specified by the configuration are *not*
 * taken into account.
 */
predicate jumpStep(Node pred, Node succ) {
  pred.(NonLocalJumpNode).getAJumpSuccessor(true) = succ
  or
  exists(FieldOrProperty fl, FieldOrPropertyRead flr |
    fl.isStatic() and
    fl.isFieldLike() and
    fl.getAnAssignedValue() = pred.asExpr() and
    fl.getAnAccess() = flr and
    flr = succ.asExpr() and
    flr.hasNonlocalValue()
  )
  or
  exists(JumpReturnKind jrk, DataFlowCall call |
    FlowSummaryImpl::Private::summaryReturnNode(pred, jrk) and
    viableCallable(call) = jrk.getTarget() and
    succ = getAnOutNode(call, jrk.getTargetReturnKind())
  )
}

private class StoreStepConfiguration extends ControlFlowReachabilityConfiguration {
  StoreStepConfiguration() { this = "StoreStepConfiguration" }

  override predicate candidate(
    Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
  ) {
    exactScope = false and
    fieldOrPropertyStore(scope, _, e1, e2, isSuccessor.booleanNot())
    or
    exactScope = false and
    arrayStore(scope, e1, e2, isSuccessor.booleanNot())
    or
    exactScope = false and
    isSuccessor = true and
    isParamsArg(e2, e1, _) and
    scope = e2
  }
}

pragma[nomagic]
private PropertyContent getResultContent() {
  result.getProperty() = any(SystemThreadingTasksTaskTClass c_).getResultProperty()
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to
 * content `c`.
 */
predicate storeStep(Node node1, Content c, Node node2) {
  exists(StoreStepConfiguration x, ExprNode node, boolean postUpdate |
    hasNodePath(x, node1, node) and
    if postUpdate = true then node = node2.(PostUpdateNode).getPreUpdateNode() else node = node2
  |
    fieldOrPropertyStore(_, c, node1.asExpr(), node.getExpr(), postUpdate)
    or
    arrayStore(_, node1.asExpr(), node.getExpr(), postUpdate) and c instanceof ElementContent
  )
  or
  exists(StoreStepConfiguration x, Expr arg, ControlFlow::Node callCfn |
    x.hasExprPath(arg, node1.(ExprNode).getControlFlowNode(), _, callCfn) and
    node2 = TParamsArgumentNode(callCfn) and
    isParamsArg(_, arg, _) and
    c instanceof ElementContent
  )
  or
  exists(Expr e |
    e = node1.asExpr() and
    node2.(YieldReturnNode).getYieldReturnStmt().getExpr() = e and
    c instanceof ElementContent
  )
  or
  exists(Expr e |
    e = node1.asExpr() and
    node2.(AsyncReturnNode).getExpr() = e and
    c = getResultContent()
  )
  or
  FlowSummaryImpl::Private::Steps::summaryStoreStep(node1, c, node2)
}

private class ReadStepConfiguration extends ControlFlowReachabilityConfiguration {
  ReadStepConfiguration() { this = "ReadStepConfiguration" }

  override predicate candidate(
    Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
  ) {
    exactScope = false and
    isSuccessor = true and
    fieldOrPropertyRead(e1, _, e2) and
    scope = e2
    or
    exactScope = false and
    isSuccessor = true and
    arrayRead(e1, e2) and
    scope = e2
    or
    exactScope = false and
    e1 = e2.(AwaitExpr).getExpr() and
    scope = e2 and
    isSuccessor = true
    or
    exactScope = false and
    e2 = e1.(TupleExpr).getAnArgument() and
    scope = e1 and
    isSuccessor = false
  }

  override predicate candidateDef(
    Expr e, AssignableDefinition defTo, ControlFlowElement scope, boolean exactScope,
    boolean isSuccessor
  ) {
    exists(ForeachStmt fs |
      e = fs.getIterableExpr() and
      defTo.(AssignableDefinitions::LocalVariableDefinition).getDeclaration() =
        fs.getVariableDeclExpr() and
      isSuccessor = true
    |
      scope = fs and
      exactScope = true
      or
      scope = fs.getIterableExpr() and
      exactScope = false
      or
      scope = fs.getVariableDeclExpr() and
      exactScope = false
    )
    or
    scope =
      any(AssignExpr ae |
        ae = defTo.(AssignableDefinitions::TupleAssignmentDefinition).getAssignment() and
        e = ae.getLValue().getAChildExpr*().(TupleExpr) and
        exactScope = false and
        isSuccessor = true
      )
    or
    scope =
      any(TupleExpr te |
        te.getAnArgument() = defTo.(AssignableDefinitions::LocalVariableDefinition).getDeclaration() and
        e = te and
        exactScope = false and
        isSuccessor = false
      )
  }
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of content `c`.
 */
predicate readStep(Node node1, Content c, Node node2) {
  exists(ReadStepConfiguration x |
    hasNodePath(x, node1, node2) and
    fieldOrPropertyRead(node1.asExpr(), c, node2.asExpr())
    or
    hasNodePath(x, node1, node2) and
    arrayRead(node1.asExpr(), node2.asExpr()) and
    c instanceof ElementContent
    or
    exists(ForeachStmt fs, Ssa::ExplicitDefinition def |
      x.hasDefPath(fs.getIterableExpr(), node1.getControlFlowNode(), def.getADefinition(),
        def.getControlFlowNode()) and
      node2.(SsaDefinitionNode).getDefinition() = def and
      c instanceof ElementContent
    )
    or
    hasNodePath(x, node1, node2) and
    node2.asExpr().(AwaitExpr).getExpr() = node1.asExpr() and
    c = getResultContent()
    or
    // node1 = (..., node2, ...)
    // node1.ItemX flows to node2
    exists(TupleExpr te, int i, Expr item |
      te = node1.asExpr() and
      not te.isConstruction() and
      c.(FieldContent).getField() = te.getType().(TupleType).getElement(i).getUnboundDeclaration() and
      // node1 = (..., item, ...)
      te.getArgument(i) = item
    |
      // item = (..., ..., ...) in node1 = (..., (..., ..., ...), ...)
      node2.asExpr().(TupleExpr) = item and
      hasNodePath(x, node1, node2)
      or
      // item = variable in node1 = (..., variable, ...)
      exists(AssignableDefinitions::TupleAssignmentDefinition tad, Ssa::ExplicitDefinition def |
        node2.(SsaDefinitionNode).getDefinition() = def and
        def.getADefinition() = tad and
        tad.getLeaf() = item and
        hasNodePath(x, node1, node2)
      )
      or
      // item = variable in node1 = (..., variable, ...) in a case/is var (..., ...)
      te = any(PatternExpr pe).getAChildExpr*() and
      exists(AssignableDefinitions::LocalVariableDefinition lvd, Ssa::ExplicitDefinition def |
        node2.(SsaDefinitionNode).getDefinition() = def and
        def.getADefinition() = lvd and
        lvd.getDeclaration() = item and
        hasNodePath(x, node1, node2)
      )
    )
  )
  or
  FlowSummaryImpl::Private::Steps::summaryReadStep(node1, c, node2)
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
predicate clearsContent(Node n, Content c) {
  fieldOrPropertyStore(_, c, _, n.asExpr(), true)
  or
  fieldOrPropertyStore(_, c, _, n.(ObjectInitializerNode).getInitializer(), false)
  or
  FlowSummaryImpl::Private::Steps::summaryClearsContent(n, c)
  or
  exists(WithExpr we, ObjectInitializer oi, FieldOrProperty f |
    oi = we.getInitializer() and
    n.asExpr() = oi and
    f = oi.getAMemberInitializer().getInitializedMember() and
    c = f.getContent()
  )
}

/**
 * Holds if the node `n` is unreachable when the call context is `call`.
 */
predicate isUnreachableInCall(Node n, DataFlowCall call) {
  exists(
    ExplicitParameterNode paramNode, Guard guard, ControlFlow::SuccessorTypes::BooleanSuccessor bs
  |
    viableConstantBooleanParamArg(paramNode, bs.getValue().booleanNot(), call) and
    paramNode.getSsaDefinition().getARead() = guard and
    guard.controlsBlock(n.getControlFlowNode().getBasicBlock(), bs, _)
  )
}

/**
 * An entity used to represent the type of data-flow node. Two nodes will have
 * the same `DataFlowType` when the underlying `Type`s are structurally equal
 * modulo type parameters and identity conversions.
 *
 * For example, `Func<T, int>` and `Func<S, int>` are mapped to the same
 * `DataFlowType`, while `Func<T, int>` and `Func<string, int>` are not, because
 * `string` is not a type parameter.
 */
class DataFlowType = Gvn::GvnType;

/** Gets the type of `n` used for type pruning. */
pragma[inline]
Gvn::GvnType getNodeType(NodeImpl n) {
  pragma[only_bind_into](result) = pragma[only_bind_out](n).getDataFlowType()
}

/** Gets a string representation of a `DataFlowType`. */
string ppReprType(DataFlowType t) { result = t.toString() }

private class DataFlowNullType extends DataFlowType {
  DataFlowNullType() { this = Gvn::getGlobalValueNumber(any(NullType nt)) }

  pragma[noinline]
  predicate isConvertibleTo(DataFlowType t) {
    defaultNullConversion(_, any(Type t0 | t = Gvn::getGlobalValueNumber(t0)))
  }
}

private class DataFlowUnknownType extends DataFlowType {
  DataFlowUnknownType() { this = Gvn::getGlobalValueNumber(any(UnknownType ut)) }
}

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
pragma[inline]
predicate compatibleTypes(DataFlowType t1, DataFlowType t2) {
  commonSubType(t1, t2)
  or
  commonSubTypeUnifiableLeft(t1, t2)
  or
  commonSubTypeUnifiableLeft(t2, t1)
  or
  t1.(DataFlowNullType).isConvertibleTo(t2)
  or
  t2.(DataFlowNullType).isConvertibleTo(t1)
  or
  t1 instanceof Gvn::TypeParameterGvnType
  or
  t2 instanceof Gvn::TypeParameterGvnType
  or
  t1 instanceof DataFlowUnknownType
  or
  t2 instanceof DataFlowUnknownType
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
    private ObjectCreation oc;

    ObjectCreationNode() { this = TExprNode(oc.getAControlFlowNode()) }

    override Node getPreUpdateNode() {
      exists(ControlFlow::Nodes::ElementNode cfn | this = TExprNode(cfn) |
        result.(ObjectInitializerNode).getControlFlowNode() = cfn
        or
        not oc.hasInitializer() and
        result.(MallocNode).getControlFlowNode() = cfn
      )
    }
  }

  /**
   * A node that represents the value of a newly created object after the object
   * has been created, but before the object initializer has been executed.
   *
   * Such a node acts as both a post-update node for the `MallocNode`, as well as
   * a pre-update node for the `ObjectCreationNode`.
   */
  class ObjectInitializerNode extends PostUpdateNode, NodeImpl, ArgumentNodeImpl,
    TObjectInitializerNode {
    private ObjectCreation oc;
    private ControlFlow::Nodes::ElementNode cfn;

    ObjectInitializerNode() {
      this = TObjectInitializerNode(cfn) and
      cfn = oc.getAControlFlowNode()
    }

    /** Gets the initializer to which this initializer node belongs. */
    ObjectOrCollectionInitializer getInitializer() { result = oc.getInitializer() }

    override MallocNode getPreUpdateNode() { result.getControlFlowNode() = cfn }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      pos.isQualifier() and
      any(ObjectOrCollectionInitializerConfiguration x)
          .hasExprPath(_, cfn, _, call.getControlFlowNode())
    }

    override DataFlowCallable getEnclosingCallableImpl() { result = cfn.getEnclosingCallable() }

    override DotNet::Type getTypeImpl() { result = oc.getType() }

    override ControlFlow::Nodes::ElementNode getControlFlowNodeImpl() { result = cfn }

    override Location getLocationImpl() { result = cfn.getLocation() }

    override string toStringImpl() { result = "[pre-initializer] " + cfn }
  }

  class ExprPostUpdateNode extends PostUpdateNode, NodeImpl, TExprPostUpdateNode {
    private ControlFlow::Nodes::ElementNode cfn;

    ExprPostUpdateNode() { this = TExprPostUpdateNode(cfn) }

    override ExprNode getPreUpdateNode() { cfn = result.getControlFlowNode() }

    override DataFlowCallable getEnclosingCallableImpl() { result = cfn.getEnclosingCallable() }

    override Type getTypeImpl() { result = cfn.getElement().(Expr).getType() }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = cfn.getLocation() }

    override string toStringImpl() { result = "[post] " + cfn.toString() }
  }

  private class SummaryPostUpdateNode extends SummaryNode, PostUpdateNode {
    SummaryPostUpdateNode() {
      FlowSummaryImpl::Private::summaryPostUpdateNode(this, _) and
      not summaryPostUpdateNodeIsOutOrRef(this, _)
    }

    override Node getPreUpdateNode() {
      FlowSummaryImpl::Private::summaryPostUpdateNode(this, result)
    }
  }
}

private import PostUpdateNodes

/** A node that performs a type cast. */
class CastNode extends Node {
  CastNode() {
    this.asExpr() instanceof Cast
    or
    this.(AssignableDefinitionNode).getDefinition() instanceof
      AssignableDefinitions::PatternDefinition
  }
}

class DataFlowExpr = DotNet::Expr;

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
  ParameterNode paramNode, boolean b, DataFlowCall call
) {
  exists(ConstantBooleanArgumentNode arg |
    viableParamArg(call, paramNode, arg) and
    b = arg.getBooleanValue()
  )
}

int accessPathLimit() { result = 5 }

/**
 * Holds if access paths with `c` at their head always should be tracked at high
 * precision. This disables adaptive access path precision for such access paths.
 */
predicate forceHighPrecision(Content c) { c instanceof ElementContent }

/** The unit type. */
private newtype TUnit = TMkUnit()

/** The trivial type with a single element. */
class Unit extends TUnit {
  /** Gets a textual representation of this element. */
  string toString() { result = "unit" }
}

class LambdaCallKind = Unit;

/** Holds if `creation` is an expression that creates a delegate for `c`. */
predicate lambdaCreation(ExprNode creation, LambdaCallKind kind, DataFlowCallable c) {
  exists(Expr e | e = creation.getExpr() |
    c = e.(AnonymousFunctionExpr)
    or
    c = e.(CallableAccess).getTarget().getUnboundDeclaration()
    or
    c = e.(AddressOfExpr).getOperand().(CallableAccess).getTarget().getUnboundDeclaration()
  ) and
  kind = TMkUnit()
}

private class LambdaConfiguration extends ControlFlowReachabilityConfiguration {
  LambdaConfiguration() { this = "LambdaConfiguration" }

  override predicate candidate(
    Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
  ) {
    e1 = e2.(DelegateLikeCall).getExpr() and
    exactScope = false and
    scope = e2 and
    isSuccessor = true
    or
    e1 = e2.(DelegateCreation).getArgument() and
    exactScope = false and
    scope = e2 and
    isSuccessor = true
  }
}

/** Holds if `call` is a lambda call where `receiver` is the lambda expression. */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) {
  (
    exists(LambdaConfiguration x, DelegateLikeCall dc |
      x.hasExprPath(dc.getExpr(), receiver.(ExprNode).getControlFlowNode(), dc,
        call.getControlFlowNode())
    )
    or
    receiver = call.(SummaryCall).getReceiver()
  ) and
  kind = TMkUnit()
}

/** Extra data-flow steps needed for lambda flow analysis. */
predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) {
  exists(Ssa::Definition def |
    LocalFlow::localSsaFlowStep(def, nodeFrom, nodeTo) and
    LocalFlow::usesInstanceField(def) and
    preservesValue = true
  )
  or
  exists(LambdaConfiguration x, DelegateCreation dc |
    x.hasExprPath(dc.getArgument(), nodeFrom.(ExprNode).getControlFlowNode(), dc,
      nodeTo.(ExprNode).getControlFlowNode()) and
    preservesValue = false
  )
  or
  exists(AddEventExpr aee |
    nodeFrom.asExpr() = aee.getRValue() and
    nodeTo.asExpr().(EventRead).getTarget() = aee.getTarget() and
    preservesValue = false
  )
}

/**
 * Holds if flow is allowed to pass from parameter `p` and back to itself as a
 * side-effect, resulting in a summary from `p` to itself.
 *
 * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
 * by default as a heuristic.
 */
predicate allowParameterReturnInSelf(ParameterNode p) {
  FlowSummaryImpl::Private::summaryAllowParameterReturnInSelf(p)
}

/** A synthetic field. */
abstract class SyntheticField extends string {
  bindingset[this]
  SyntheticField() { any() }

  /** Gets the type of this synthetic field. */
  Type getType() { result instanceof ObjectType }
}

/**
 * Holds if the the content `c` is a container.
 */
predicate containerContent(DataFlow::Content c) { c instanceof DataFlow::ElementContent }

/** Gets the string representation of the parameters of `c`. */
string parameterQualifiedTypeNamesToString(DataFlowCallable c) {
  result =
    concat(Parameter p, int i |
      p = c.getParameter(i)
    |
      p.getType().getQualifiedName(), "," order by i
    )
}

/**
 * A module containing predicates related to generating models as data.
 */
module Csv {
  /** Holds if the summary should apply for all overrides of `c`. */
  predicate isBaseCallableOrPrototype(DataFlowCallable c) {
    c.getDeclaringType() instanceof Interface
    or
    exists(Modifiable m | m = [c.(Modifiable), c.(Accessor).getDeclaration()] |
      m.isAbstract()
      or
      c.getDeclaringType().(Modifiable).isAbstract() and m.(Virtualizable).isVirtual()
    )
  }

  /** Gets a string representing whether the summary should apply for all overrides of `c`. */
  private string getCallableOverride(DataFlowCallable c) {
    if isBaseCallableOrPrototype(c) then result = "true" else result = "false"
  }

  /** Computes the first 6 columns for CSV rows of `c`. */
  string asPartialModel(DataFlowCallable c) {
    exists(string namespace, string type, string name |
      c.getDeclaringType().hasQualifiedName(namespace, type) and
      c.hasQualifiedName(_, name) and
      result =
        namespace + ";" //
          + type + ";" //
          + getCallableOverride(c) + ";" //
          + name + ";" //
          + "(" + parameterQualifiedTypeNamesToString(c) + ")" + ";" //
          + /* ext + */ ";" //
    )
  }
}
