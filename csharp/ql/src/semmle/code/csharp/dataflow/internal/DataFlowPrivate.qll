private import csharp
private import cil
private import dotnet
private import DataFlowPublic
private import DataFlowDispatch
private import DataFlowImplCommon
private import ControlFlowReachability
private import DelegateDataFlow
private import semmle.code.csharp.Caching
private import semmle.code.csharp.Conversion
private import semmle.code.csharp.ExprOrStmtParent
private import semmle.code.csharp.Unification
private import semmle.code.csharp.controlflow.Guards
private import semmle.code.csharp.dataflow.LibraryTypeDataFlow
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.frameworks.EntityFramework
private import semmle.code.csharp.frameworks.NHibernate
private import semmle.code.csharp.frameworks.system.Collections
private import semmle.code.csharp.frameworks.system.threading.Tasks
private import semmle.code.csharp.frameworks.system.linq.Expressions

abstract class NodeImpl extends Node {
  /** Do not call: use `getEnclosingCallable()` instead. */
  abstract DataFlowCallable getEnclosingCallableImpl();

  /** Do not call: use `getType()` instead. */
  abstract DotNet::Type getTypeImpl();

  /** Gets the type of this node used for type pruning. */
  cached
  Gvn::GvnType getDataFlowType() {
    Stages::DataFlowStage::forceCachingInSameStage() and
    exists(Type t0 | result = Gvn::getGlobalValueNumber(t0) |
      t0 = getCSharpType(this.getType())
      or
      not exists(getCSharpType(this.getType())) and
      t0 instanceof ObjectType
    )
  }

  /** Do not call: use `getControlFlowNode()` instead. */
  abstract ControlFlow::Node getControlFlowNodeImpl();

  /** Do not call: use `getLocation()` instead. */
  abstract Location getLocationImpl();

  /** Do not call: use `toString()` instead. */
  abstract string toStringImpl();
}

private class ExprNodeImpl extends ExprNode, NodeImpl {
  override DataFlowCallable getEnclosingCallableImpl() {
    result = this.getExpr().getEnclosingCallable()
  }

  override DotNet::Type getTypeImpl() { result = this.getExpr().getType() }

  override ControlFlow::Nodes::ElementNode getControlFlowNodeImpl() { this = TExprNode(result) }

  override Location getLocationImpl() { result = this.getExpr().getLocation() }

  override string toStringImpl() {
    result = this.getControlFlowNode().toString()
    or
    this = TCilExprNode(_) and
    result = "CIL expression"
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
        isSuccessor = false
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
        isSuccessor = false
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
        isSuccessor = false
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

  predicate localFlowStepCommon(Node nodeFrom, Node nodeTo) {
    exists(Ssa::Definition def |
      localSsaFlowStep(def, nodeFrom, nodeTo) and
      not usesInstanceField(def)
    )
    or
    any(LocalExprStepConfiguration x).hasNodePath(nodeFrom, nodeTo)
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
    n instanceof Summaries::SummaryNodeImpl or
    n instanceof ImplicitCapturedArgumentNode
  }
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
      [getImplicitArgument(c, [p.getPosition() .. numArgs - 1]), getExplicitArgument(c, p.getName())]
  |
    numArgs > target.getNumberOfParameters()
    or
    not arg.getType().isImplicitlyConvertibleTo(p.getType())
  )
}

/** An argument of a C# call (including qualifier arguments). */
private class Argument extends Expr {
  private Expr call;
  private int arg;

  Argument() {
    call =
      any(DispatchCall dc |
        this = dc.getArgument(arg) and
        not isParamsArg(_, this, _)
        or
        this = dc.getQualifier() and arg = -1 and not dc.getAStaticTarget().(Modifiable).isStatic()
      ).getCall()
    or
    this = call.(DelegateCall).getArgument(arg)
  }

  /**
   * Holds if this expression is the `i`th argument of `c`.
   *
   * Qualifier arguments have index `-1`.
   */
  predicate isArgumentOf(Expr c, int i) { c = call and i = arg }
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
      exists(AccessPath ap |
        Summaries::summary(_, _, ap, _, _, _) and
        ap.contains(f.getContent())
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
    // Object initializer, `new C() { f = src }`
    exists(MemberInitializer mi |
      e = q and
      mi = q.(ObjectInitializer).getAMemberInitializer() and
      f = mi.getInitializedMember() and
      src = mi.getRValue() and
      postUpdate = false
    )
  )
}

/** Holds if property `p1` overrides or implements source declaration property `p2`. */
private predicate overridesOrImplementsSourceDecl(Property p1, Property p2) {
  p1.getOverridee*().getSourceDeclaration() = p2
  or
  p1.getAnUltimateImplementee().getSourceDeclaration() = p2
}

/**
 * Holds if `e2` is an expression that reads field or property `c` from
 * expresion `e1`. This takes overriding into account for properties written
 * from library code.
 */
private predicate fieldOrPropertyRead(Expr e1, Content c, FieldOrPropertyRead e2) {
  e1 = e2.getQualifier() and
  exists(FieldOrProperty ret | c = ret.getContent() |
    ret.isFieldLike() and
    ret = e2.getTarget()
    or
    exists(AccessPath ap, Property target |
      Summaries::summary(_, _, _, _, ap, _) and
      ap.contains(ret.getContent()) and
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
  result.matchesHandle(t)
}

/** A GVN type that is either a `DataFlowType` or unifiable with a `DataFlowType`. */
private class DataFlowTypeOrUnifiable extends Gvn::GvnType {
  pragma[nomagic]
  DataFlowTypeOrUnifiable() {
    this instanceof DataFlowType or
    Gvn::unifiable(any(DataFlowType t), this)
  }
}

pragma[noinline]
private TypeParameter getATypeParameterSubType(DataFlowTypeOrUnifiable t) {
  not t instanceof Gvn::TypeParameterGvnType and
  exists(Type t0 | t = Gvn::getGlobalValueNumber(t0) | implicitConversionRestricted(result, t0))
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

/** A collection of cached types and predicates to be evaluated in the same stage. */
cached
private module Cached {
  private import Summaries

  cached
  newtype TNode =
    TExprNode(ControlFlow::Nodes::ElementNode cfn) {
      Stages::DataFlowStage::forceCachingInSameStage() and cfn.getElement() instanceof Expr
    } or
    TCilExprNode(CIL::Expr e) { e.getImplementation() instanceof CIL::BestImplementation } or
    TSsaDefinitionNode(Ssa::Definition def) or
    TInstanceParameterNode(Callable c) { c.hasBody() and not c.(Modifiable).isStatic() } or
    TCilParameterNode(CIL::Parameter p) { p.getMethod().hasBody() } or
    TYieldReturnNode(ControlFlow::Nodes::ElementNode cfn) {
      any(Callable c).canYieldReturn(cfn.getElement())
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
    TExprPostUpdateNode(ControlFlow::Nodes::ElementNode cfn) {
      exists(Argument a, Type t |
        a = cfn.getElement() and
        t = a.stripCasts().getType()
      |
        t instanceof RefType and
        not t instanceof NullType
        or
        t = any(TypeParameter tp | not tp.isValueType())
      )
      or
      fieldOrPropertyStore(_, _, _, cfn.getElement(), true)
      or
      arrayStore(_, _, cfn.getElement(), true)
      or
      exists(TExprPostUpdateNode upd, FieldOrPropertyAccess fla |
        upd = TExprPostUpdateNode(fla.getAControlFlowNode())
      |
        cfn.getElement() = fla.getQualifier()
      )
    } or
    TSummaryParameterNode(SourceDeclarationCallable c, int i) {
      exists(CallableFlowSource source | Summaries::summary(c, source, _, _, _, _) |
        source instanceof CallableFlowSourceQualifier and i = -1
        or
        i = source.(CallableFlowSourceArg).getArgumentIndex()
        or
        i = source.(CallableFlowSourceDelegateArg).getArgumentIndex()
      )
      or
      exists(CallableFlowSink sink | Summaries::summary(c, _, _, sink, _, _) |
        i = sink.(CallableFlowSinkDelegateArg).getDelegateIndex()
      )
    } or
    TSummaryInternalNode(
      SourceDeclarationCallable c, CallableFlowSource source, AccessPath sourceAp,
      CallableFlowSink sink, AccessPath sinkAp, boolean preservesValue,
      SummaryInternalNodeState state
    ) {
      Summaries::summary(c, source, sourceAp, sink, sinkAp, preservesValue) and
      (
        state = TSummaryInternalNodeAfterReadState(sourceAp.drop(_))
        or
        state = TSummaryInternalNodeBeforeStoreState(sinkAp.drop(_))
      )
    } or
    TSummaryReturnNode(SourceDeclarationCallable c, ReturnKind rk) {
      exists(CallableFlowSink sink |
        Summaries::summary(c, _, _, sink, _, _) and
        rk = Summaries::toReturnKind(sink)
      )
    } or
    TSummaryDelegateOutNode(SourceDeclarationCallable c, int pos) {
      exists(CallableFlowSourceDelegateArg source |
        Summaries::summary(c, source, _, _, _, _) and
        pos = source.getArgumentIndex()
      )
    } or
    TSummaryDelegateArgumentNode(SourceDeclarationCallable c, int delegateIndex, int parameterIndex) {
      exists(CallableFlowSinkDelegateArg sink |
        Summaries::summary(c, _, _, sink, _, _) and
        delegateIndex = sink.getDelegateIndex() and
        parameterIndex = sink.getDelegateParameterIndex()
      )
    } or
    TParamsArgumentNode(ControlFlow::Node callCfn) {
      callCfn = any(Call c | isParamsArg(c, _, _)).getAControlFlowNode()
    }

  /**
   * This is the local flow predicate that is used as a building block in global
   * data flow. It excludes SSA flow through instance fields, as flow through fields
   * is handled by the global data-flow library, but includes various other steps
   * that are only relevant for global flow.
   */
  cached
  predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    LocalFlow::localFlowCapturedVarStep(nodeFrom, nodeTo)
    or
    Summaries::summaryLocalStep(nodeFrom, nodeTo, true)
    or
    nodeTo.(ObjectCreationNode).getPreUpdateNode() = nodeFrom.(ObjectInitializerNode)
  }

  /**
   * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
   * (intra-procedural) step.
   */
  cached
  predicate localFlowStepImpl(Node nodeFrom, Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    exists(Ssa::Definition def |
      LocalFlow::localSsaFlowStep(def, nodeFrom, nodeTo) and
      LocalFlow::usesInstanceField(def)
    )
    or
    // Simple flow through library code is included in the exposed local
    // step relation, even though flow is technically inter-procedural
    Summaries::summaryThroughStep(nodeFrom, nodeTo, true)
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
  newtype TContent =
    TFieldContent(Field f) { f = f.getSourceDeclaration() } or
    TPropertyContent(Property p) { p = p.getSourceDeclaration() } or
    TElementContent()

  /**
   * Holds if data can flow from `node1` to `node2` via an assignment to
   * content `c`.
   */
  cached
  predicate storeStepImpl(Node node1, Content c, Node node2) {
    exists(StoreStepConfiguration x, ExprNode node, boolean postUpdate |
      x.hasNodePath(node1, node) and
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
    summaryStoreStep(node1, c, node2)
  }

  pragma[nomagic]
  private PropertyContent getResultContent() {
    result.getProperty() = any(SystemThreadingTasksTaskTClass c_).getResultProperty()
  }

  /**
   * Holds if data can flow from `node1` to `node2` via a read of content `c`.
   */
  cached
  predicate readStepImpl(Node node1, Content c, Node node2) {
    exists(ReadStepConfiguration x |
      x.hasNodePath(node1, node2) and
      fieldOrPropertyRead(node1.asExpr(), c, node2.asExpr())
      or
      x.hasNodePath(node1, node2) and
      arrayRead(node1.asExpr(), node2.asExpr()) and
      c instanceof ElementContent
      or
      exists(ForeachStmt fs, Ssa::ExplicitDefinition def |
        x
            .hasDefPath(fs.getIterableExpr(), node1.getControlFlowNode(), def.getADefinition(),
              def.getControlFlowNode()) and
        node2.(SsaDefinitionNode).getDefinition() = def and
        c instanceof ElementContent
      )
      or
      x.hasNodePath(node1, node2) and
      node2.asExpr().(AwaitExpr).getExpr() = node1.asExpr() and
      c = getResultContent()
    )
    or
    summaryReadStep(node1, c, node2)
  }

  /**
   * Holds if values stored inside content `c` are cleared at node `n`. For example,
   * any value stored inside `f` is cleared at the pre-update node associated with `x`
   * in `x.f = newValue`.
   */
  cached
  predicate clearsContent(Node n, Content c) {
    fieldOrPropertyStore(_, c, _, n.asExpr(), true)
    or
    fieldOrPropertyStore(_, c, _, n.(ObjectInitializerNode).getInitializer(), false)
    or
    summaryStoreStep(n, c, _) and
    not c instanceof ElementContent
    or
    summaryClearsContent(n, c)
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
      guard.controlsBlock(n.getControlFlowNode().getBasicBlock(), bs, _)
    )
  }

  pragma[nomagic]
  private predicate commonSubTypeGeneral(DataFlowTypeOrUnifiable t1, DataFlowType t2) {
    not t1 instanceof Gvn::TypeParameterGvnType and
    t1 = t2
    or
    getATypeParameterSubType(t1) = getATypeParameterSubType(t2)
    or
    getANonTypeParameterSubType(t1) = getANonTypeParameterSubType(t2)
  }

  /**
   * Holds if GVNs `t1` and `t2` may have a common sub type. Neither `t1` nor
   * `t2` are allowed to be type parameters.
   */
  cached
  predicate commonSubType(DataFlowType t1, DataFlowType t2) { commonSubTypeGeneral(t1, t2) }

  cached
  predicate commonSubTypeUnifiableLeft(DataFlowType t1, DataFlowType t2) {
    exists(Gvn::GvnType t |
      Gvn::unifiable(t1, t) and
      commonSubTypeGeneral(t, t2)
    )
  }

  cached
  predicate outRefReturnNode(Ssa::ExplicitDefinition def, OutRefReturnKind kind) {
    exists(Parameter p |
      def.isLiveOutRefParameterDefinition(p) and
      kind.getPosition() = p.getPosition()
    |
      p.isOut() and kind instanceof OutReturnKind
      or
      p.isRef() and kind instanceof RefReturnKind
    )
  }

  cached
  predicate qualifierOutNode(DataFlowCall call, Node n) {
    n.(ExprPostUpdateNode).getPreUpdateNode().(ExplicitArgumentNode).argumentOf(call, -1)
    or
    any(ObjectOrCollectionInitializerConfiguration x)
        .hasExprPath(_, n.(ExprNode).getControlFlowNode(), _, call.getControlFlowNode())
  }

  cached
  predicate castNode(Node n) {
    n.asExpr() instanceof Cast
    or
    n.(AssignableDefinitionNode).getDefinition() instanceof AssignableDefinitions::PatternDefinition
  }

  /** Holds if `n` should be hidden from path explanations. */
  cached
  predicate nodeIsHidden(Node n) {
    exists(Ssa::Definition def | def = n.(SsaDefinitionNode).getDefinition() |
      def instanceof Ssa::PseudoDefinition
      or
      def instanceof Ssa::ImplicitEntryDefinition
      or
      def instanceof Ssa::ImplicitCallDefinition
    )
    or
    n instanceof YieldReturnNode
    or
    n instanceof ImplicitCapturedArgumentNode
    or
    n instanceof MallocNode
    or
    n instanceof Summaries::SummaryNodeImpl
    or
    n instanceof ParamsArgumentNode
  }
}

import Cached

/** An SSA definition, viewed as a node in a data flow graph. */
class SsaDefinitionNode extends NodeImpl, TSsaDefinitionNode {
  Ssa::Definition def;

  SsaDefinitionNode() { this = TSsaDefinitionNode(def) }

  /** Gets the underlying SSA definition. */
  Ssa::Definition getDefinition() { result = def }

  override Callable getEnclosingCallableImpl() { result = def.getEnclosingCallable() }

  override Type getTypeImpl() { result = def.getSourceVariable().getType() }

  override ControlFlow::Node getControlFlowNodeImpl() { result = def.getControlFlowNode() }

  override Location getLocationImpl() { result = def.getLocation() }

  override string toStringImpl() {
    not explicitParameterNode(this, _) and
    result = def.toString()
  }
}

private module ParameterNodes {
  abstract private class ParameterNodeImpl extends ParameterNode, NodeImpl { }

  /**
   * Holds if definition node `node` is an entry definition for parameter `p`.
   */
  predicate explicitParameterNode(AssignableDefinitionNode node, Parameter p) {
    p = node.getDefinition().(AssignableDefinitions::ImplicitParameterDefinition).getParameter()
  }

  /**
   * The value of an explicit parameter at function entry, viewed as a node in a data
   * flow graph.
   */
  class ExplicitParameterNode extends ParameterNodeImpl {
    private DotNet::Parameter parameter;

    ExplicitParameterNode() {
      explicitParameterNode(this, parameter)
      or
      this = TCilParameterNode(parameter)
    }

    override DotNet::Parameter getParameter() { result = parameter }

    override predicate isParameterOf(DataFlowCallable c, int i) { c.getParameter(i) = parameter }

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

    override predicate isParameterOf(DataFlowCallable c, int pos) { callable = c and pos = -1 }

    override Callable getEnclosingCallableImpl() { result = callable }

    override Type getTypeImpl() { result = callable.getDeclaringType() }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = callable.getLocation() }

    override string toStringImpl() { result = "this" }
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
        def =
          rank[-result - 1](SsaCapturedEntryDefinition def0 |
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

  /** A parameter node for a callable with a flow summary. */
  class SummaryParameterNode extends ParameterNodeImpl, Summaries::SummaryNodeImpl,
    TSummaryParameterNode {
    private SourceDeclarationCallable sdc;
    private int i;

    SummaryParameterNode() { this = TSummaryParameterNode(sdc, i) }

    override Parameter getParameter() { result = sdc.getParameter(i) }

    override predicate isParameterOf(DataFlowCallable c, int pos) {
      c = sdc and
      pos = i
    }

    override Callable getEnclosingCallableImpl() { result = sdc }

    override Type getTypeImpl() {
      result = sdc.getParameter(i).getType()
      or
      i = -1 and
      result = sdc.getDeclaringType()
    }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() {
      result = sdc.getParameter(i).getLocation()
      or
      i = -1 and
      result = sdc.getLocation()
    }

    override string toStringImpl() {
      result = "[summary] " + sdc.getParameter(i)
      or
      i = -1 and
      result = "[summary] this"
    }
  }
}

import ParameterNodes

/** A data-flow node that represents a call argument. */
abstract class ArgumentNode extends Node {
  /** Holds if this argument occurs at the given position in the given call. */
  cached
  abstract predicate argumentOf(DataFlowCall call, int pos);

  /** Gets the call in which this node is an argument. */
  final DataFlowCall getCall() { this.argumentOf(result, _) }
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
  class ExplicitArgumentNode extends ArgumentNode {
    ExplicitArgumentNode() {
      this.asExpr() instanceof Argument
      or
      this.asExpr() = any(CIL::Call call).getAnArgument()
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
  class ImplicitCapturedArgumentNode extends ArgumentNode, NodeImpl, TImplicitCapturedArgumentNode {
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
        p.isParameterOf(call.getARuntimeTarget(), pos) and
        call.getControlFlowNode() = cfn and
        if call instanceof TransitiveCapturedDataFlowCall
        then additionalCalls = true
        else additionalCalls = false
      )
    }

    override Callable getEnclosingCallableImpl() { result = cfn.getEnclosingCallable() }

    override Type getTypeImpl() { result = v.getType() }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = cfn.getLocation() }

    override string toStringImpl() { result = "[implicit argument] " + v }
  }

  /**
   * A node that corresponds to the value of an object creation (`new C()`) before
   * the constructor has run.
   */
  class MallocNode extends ArgumentNode, NodeImpl, TMallocNode {
    private ControlFlow::Nodes::ElementNode cfn;

    MallocNode() { this = TMallocNode(cfn) }

    override predicate argumentOf(DataFlowCall call, int pos) {
      call = TNonDelegateCall(cfn, _) and
      pos = -1
    }

    override ControlFlow::Node getControlFlowNodeImpl() { result = cfn }

    override Callable getEnclosingCallableImpl() { result = cfn.getEnclosingCallable() }

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
  class ParamsArgumentNode extends ArgumentNode, NodeImpl, TParamsArgumentNode {
    private ControlFlow::Node callCfn;

    ParamsArgumentNode() { this = TParamsArgumentNode(callCfn) }

    private Parameter getParameter() {
      callCfn = any(Call c | isParamsArg(c, _, result)).getAControlFlowNode()
    }

    override predicate argumentOf(DataFlowCall call, int pos) {
      callCfn = call.getControlFlowNode() and
      pos = this.getParameter().getPosition()
    }

    override Callable getEnclosingCallableImpl() { result = callCfn.getEnclosingCallable() }

    override Type getTypeImpl() { result = this.getParameter().getType() }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = callCfn.getLocation() }

    override string toStringImpl() { result = "[implicit array creation] " + callCfn }
  }

  /**
   * An argument node inside a callable with a flow summary, where the argument is
   * passed to a supplied delegate. For example, in `ints.Select(Foo)` there is a
   * node that represents the argument of the call to `Foo` inside `Select`.
   */
  class SummaryDelegateArgumentNode extends ArgumentNode, Summaries::SummaryNodeImpl,
    TSummaryDelegateArgumentNode {
    private SourceDeclarationCallable c;
    private int delegateIndex;
    private int parameterIndex;

    SummaryDelegateArgumentNode() {
      this = TSummaryDelegateArgumentNode(c, delegateIndex, parameterIndex)
    }

    override DataFlowCallable getEnclosingCallableImpl() { result = c }

    override DotNet::Type getTypeImpl() {
      result =
        c
            .getParameter(delegateIndex)
            .getType()
            .(SystemLinqExpressions::DelegateExtType)
            .getDelegateType()
            .getParameter(parameterIndex)
            .getType()
    }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = c.getLocation() }

    override string toStringImpl() {
      result =
        "[summary] argument " + parameterIndex + " of delegate call, parameter " + parameterIndex +
          " of " + c
    }

    override predicate argumentOf(DataFlowCall call, int pos) {
      call = TSummaryDelegateCall(c, delegateIndex) and
      pos = parameterIndex
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
   * A data-flow node that represents an assignment to an `out` or a `ref`
   * parameter.
   */
  class OutRefReturnNode extends ReturnNode, SsaDefinitionNode {
    OutRefReturnKind kind;

    OutRefReturnNode() { outRefReturnNode(this.getDefinition(), kind) }

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

    override YieldReturnKind getKind() { any() }

    override Callable getEnclosingCallableImpl() { result = yrs.getEnclosingCallable() }

    override Type getTypeImpl() { result = yrs.getEnclosingCallable().getReturnType() }

    override ControlFlow::Node getControlFlowNodeImpl() { result = cfn }

    override Location getLocationImpl() { result = yrs.getLocation() }

    override string toStringImpl() { result = yrs.toString() }
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

  /** A return node for a callable with a flow summary. */
  class SummaryReturnNode extends ReturnNode, Summaries::SummaryNodeImpl, TSummaryReturnNode {
    private SourceDeclarationCallable sdc;
    private ReturnKind rk;

    SummaryReturnNode() { this = TSummaryReturnNode(sdc, rk) }

    override Callable getEnclosingCallableImpl() { result = sdc }

    override DotNet::Type getTypeImpl() {
      rk instanceof NormalReturnKind and
      result in [sdc.getReturnType(), sdc.(Constructor).getDeclaringType()]
      or
      rk instanceof QualifierReturnKind and
      result = sdc.getDeclaringType()
      or
      result = sdc.getParameter(rk.(OutRefReturnKind).getPosition()).getType()
    }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = sdc.getLocation() }

    override string toStringImpl() { result = "[summary] return of kind " + rk + " inside " + sdc }

    override ReturnKind getKind() { result = rk }
  }
}

import ReturnNodes

/** A data-flow node that represents the output of a call. */
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

  class ObjectOrCollectionInitializerConfiguration extends ControlFlowReachabilityConfiguration {
    ObjectOrCollectionInitializerConfiguration() {
      this = "ObjectOrCollectionInitializerConfiguration"
    }

    override predicate candidate(
      Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
    ) {
      exactScope = false and
      scope = e1 and
      isSuccessor = false and
      (
        // E.g. `new Dictionary<int, string>{ {0, "a"}, {1, "b"} }`
        e1.(CollectionInitializer).getAnElementInitializer() = e2
        or
        // E.g. `new Dictionary<int, string>() { [0] = "a", [1] = "b" }`
        e1.(ObjectInitializer).getAMemberInitializer().getLValue() = e2
      )
    }
  }

  /**
   * A data-flow node that contains a value returned by a callable, by writing
   * to the qualifier of the call.
   */
  private class QualifierOutNode extends OutNode, Node {
    private DataFlowCall call;

    QualifierOutNode() { qualifierOutNode(call, this) }

    override DataFlowCall getCall(ReturnKind kind) {
      result = call and
      kind instanceof QualifierReturnKind
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
        p.getSourceDeclaration().getPosition() = kind.(OutRefReturnKind).getPosition() and
        outRefDef.getTargetAccess() = result.getExpr().(Call).getArgumentForParameter(p)
      )
    }
  }

  /**
   * An output node inside a callable with a flow summary, where the output is the
   * result of calling a supplied delegate. For example, in `ints.Select(Foo)` there
   * is a node that represents the output of calling `Foo` inside `Select`.
   */
  private class SummaryDelegateOutNode extends OutNode, Summaries::SummaryNodeImpl,
    TSummaryDelegateOutNode {
    private SourceDeclarationCallable c;
    private int pos;

    SummaryDelegateOutNode() { this = TSummaryDelegateOutNode(c, pos) }

    override Callable getEnclosingCallableImpl() { result = c }

    override DotNet::Type getTypeImpl() {
      result =
        c
            .getParameter(pos)
            .getType()
            .(SystemLinqExpressions::DelegateExtType)
            .getDelegateType()
            .getReturnType()
    }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = c.getLocation() }

    override string toStringImpl() {
      result = "[summary] output from delegate call, parameter " + pos + " of " + c + "]"
    }

    override SummaryDelegateCall getCall(ReturnKind kind) {
      result = TSummaryDelegateCall(c, pos) and
      kind instanceof NormalReturnKind
    }
  }
}

import OutNodes

/**
 * Provides predicates for interpreting flow summaries defined in
 * `LibraryTypeDataFlow.qll`.
 */
module Summaries {
  /** A data-flow node used to interpret a flow summary. */
  abstract class SummaryNodeImpl extends NodeImpl { }

  /**
   * Holds if data can flow from a node of kind `source` to a node of kind `sink`,
   * using a call to a callable with a flow summary.
   *
   * `sourceAp` describes the contents of the source node that flows to the sink
   * (if any), and `sinkAp` describes the contents of the sink that it flows to
   * (if any).
   */
  pragma[nomagic]
  predicate summary(
    SourceDeclarationCallable c, CallableFlowSource source, AccessPath sourceAp,
    CallableFlowSink sink, AccessPath sinkAp, boolean preservesValue
  ) {
    any(LibraryTypeDataFlow ltdf).callableFlow(source, sink, c, preservesValue) and
    sourceAp = AccessPath::empty() and
    sinkAp = AccessPath::empty()
    or
    any(LibraryTypeDataFlow ltdf).callableFlow(source, sourceAp, sink, sinkAp, c, preservesValue)
  }

  /** Gets the return kind that matches `sink`, if any. */
  ReturnKind toReturnKind(CallableFlowSink sink) {
    sink instanceof CallableFlowSinkQualifier and result instanceof QualifierReturnKind
    or
    sink instanceof CallableFlowSinkReturn and result instanceof NormalReturnKind
    or
    sink.(CallableFlowSinkArg).getArgumentIndex() = result.(OutRefReturnKind).getPosition()
  }

  newtype TSummaryInternalNodeState =
    TSummaryInternalNodeAfterReadState(AccessPath ap) { ap.length() > 0 } or
    TSummaryInternalNodeBeforeStoreState(AccessPath ap) { ap.length() > 0 }

  /**
   * A state used to break up (complex) flow summaries for library code into atomic
   * flow steps. For a flow summary with source access path `sourceAp` and sink
   * access path `sinkAp`, the following states are used:
   *
   * - `TSummaryInternalNodeAfterReadState(AccessPath ap)`: this state represents
   *   that the head of `ap` has been read from, where `ap` is a suffix of
   *   `sourceAp`.
   * - `TSummaryInternalNodeBeforeStoreState(AccessPath ap)`: this state represents
   *   that the head of `ap` is to be stored into next, where `ap` is a suffix of
   *   `sinkAp`.
   *
   * The state machine for flow summaries has no branching, hence from the entry
   * state there is a unique path to the exit state.
   */
  class SummaryInternalNodeState extends TSummaryInternalNodeState {
    string toString() {
      exists(AccessPath ap |
        this = TSummaryInternalNodeAfterReadState(ap) and
        result = "after read: " + ap
      )
      or
      exists(AccessPath ap |
        this = TSummaryInternalNodeBeforeStoreState(ap) and
        result = "before store: " + ap
      )
    }

    /** Holds if this state represents the state after the last read. */
    predicate isLastReadState() {
      this = TSummaryInternalNodeAfterReadState(AccessPath::singleton(_))
    }

    /** Holds if this state represents the state before the first store. */
    predicate isFirstStoreState() {
      this = TSummaryInternalNodeBeforeStoreState(AccessPath::singleton(_))
    }
  }

  private NodeImpl getSourceNode(SourceDeclarationCallable c, CallableFlowSource source) {
    exists(int i | result = TSummaryParameterNode(c, i) |
      source instanceof CallableFlowSourceQualifier and i = -1
      or
      i = source.(CallableFlowSourceArg).getArgumentIndex()
    )
    or
    result = TSummaryDelegateOutNode(c, source.(CallableFlowSourceDelegateArg).getArgumentIndex())
  }

  private NodeImpl getSinkNode(SourceDeclarationCallable c, CallableFlowSink sink) {
    result = TSummaryReturnNode(c, toReturnKind(sink))
    or
    sink =
      any(CallableFlowSinkDelegateArg s |
        result =
          TSummaryDelegateArgumentNode(c, s.getDelegateIndex(), s.getDelegateParameterIndex())
      )
  }

  /**
   * Holds if there is a local step from `pred` to `succ`, which is synthesized
   * from a flow summary.
   */
  predicate summaryLocalStep(Node pred, Node succ, boolean preservesValue) {
    exists(
      SourceDeclarationCallable c, CallableFlowSource source, AccessPath sourceAp,
      CallableFlowSink sink, AccessPath sinkAp
    |
      pred = getSourceNode(c, source)
    |
      // Simple flow summary without reads or stores
      sourceAp = AccessPath::empty() and
      sinkAp = AccessPath::empty() and
      summary(c, source, sourceAp, sink, sinkAp, preservesValue) and
      succ = getSinkNode(c, sink)
      or
      // Flow summary with stores but no reads
      exists(SummaryInternalNodeState succState |
        sourceAp = AccessPath::empty() and
        succState.isFirstStoreState() and
        succ = TSummaryInternalNode(c, source, sourceAp, sink, sinkAp, preservesValue, succState)
      )
    )
    or
    // Exit step after last read (no stores)
    exists(
      SourceDeclarationCallable c, SummaryInternalNodeState predState, CallableFlowSink sink,
      AccessPath sinkAp
    |
      sinkAp = AccessPath::empty() and
      predState.isLastReadState() and
      pred = TSummaryInternalNode(c, _, _, sink, sinkAp, preservesValue, predState) and
      succ = getSinkNode(c, sink)
    )
    or
    // Internal step for complex flow summaries with both reads and writes
    exists(
      SourceDeclarationCallable c, CallableFlowSource source, AccessPath sourceAp,
      CallableFlowSink sink, AccessPath sinkAp, SummaryInternalNodeState predState,
      SummaryInternalNodeState succState
    |
      predState.isLastReadState() and
      pred = TSummaryInternalNode(c, source, sourceAp, sink, sinkAp, preservesValue, predState) and
      succState.isFirstStoreState() and
      succ = TSummaryInternalNode(c, source, sourceAp, sink, sinkAp, preservesValue, succState)
    )
  }

  /**
   * Holds if data can flow from `pred` to `succ` via an assignment to
   * content `c`, using a flow summary.
   */
  predicate summaryStoreStep(Node pred, Content c, Node succ) {
    exists(
      SourceDeclarationCallable sdc, CallableFlowSource source, AccessPath sourceAp,
      CallableFlowSink sink, AccessPath sinkAp, boolean preservesValue,
      SummaryInternalNodeState predState, AccessPath predAp
    |
      predState = TSummaryInternalNodeBeforeStoreState(predAp) and
      pred = TSummaryInternalNode(sdc, source, sourceAp, sink, sinkAp, preservesValue, predState) and
      c = predAp.getHead()
    |
      // More stores needed
      exists(SummaryInternalNodeState succState |
        succState =
          TSummaryInternalNodeBeforeStoreState(any(AccessPath succAp | succAp.getTail() = predAp)) and
        succ = TSummaryInternalNode(sdc, source, sourceAp, sink, sinkAp, preservesValue, succState)
      )
      or
      // Last store
      predAp = sinkAp and
      succ = getSinkNode(sdc, sink)
    )
  }

  /**
   * Holds if data can flow from `pred` to `succ` via a read of content `c`,
   * using library code.
   */
  predicate summaryReadStep(Node pred, Content c, Node succ) {
    exists(
      SourceDeclarationCallable sdc, CallableFlowSource source, AccessPath sourceAp,
      CallableFlowSink sink, AccessPath sinkAp, boolean preservesValue,
      SummaryInternalNodeState succState, AccessPath succAp
    |
      succState = TSummaryInternalNodeAfterReadState(succAp) and
      succ = TSummaryInternalNode(sdc, source, sourceAp, sink, sinkAp, preservesValue, succState) and
      c = succAp.getHead()
    |
      // First read
      succAp = sourceAp and
      pred = getSourceNode(sdc, source)
      or
      // Subsequent reads
      exists(SummaryInternalNodeState predState, AccessPath predAp |
        predState = TSummaryInternalNodeAfterReadState(predAp) and
        predAp.getTail() = succAp and
        pred = TSummaryInternalNode(sdc, source, sourceAp, sink, sinkAp, preservesValue, predState)
      )
    )
  }

  pragma[nomagic]
  private SummaryParameterNode summaryArgParam(ArgumentNode arg, ReturnKind rk, OutNode out) {
    exists(DataFlowCall call, int pos, SourceDeclarationCallable sdc |
      arg.argumentOf(call, pos) and
      call.getARuntimeTarget() = sdc and
      result = TSummaryParameterNode(sdc, pos) and
      call = out.getCall(rk)
    )
  }

  /**
   * Holds if `arg` flows to `out` using a simple flow summary, that is, a flow
   * summary without delegates, reads, and stores.
   */
  predicate summaryThroughStep(ArgumentNode arg, OutNode out, boolean preservesValue) {
    exists(ReturnKind rk |
      summaryLocalStep(summaryArgParam(arg, rk, out), TSummaryReturnNode(_, rk), preservesValue)
    )
  }

  /**
   * Holds if there is a (taint+)store of `arg` into content `c` of `out` using a
   * flow summary.
   */
  predicate summarySetterStep(ArgumentNode arg, Content c, OutNode out) {
    exists(ReturnKind rk, Node mid |
      summaryLocalStep(summaryArgParam(arg, rk, out), mid, _) and
      summaryStoreStep(mid, c, TSummaryReturnNode(_, rk))
    )
  }

  /**
   * Holds if there is a read(+taint) of `c` from `arg` to `out` using a
   * flow summary.
   */
  predicate summaryGetterStep(ArgumentNode arg, Content c, OutNode out) {
    exists(ReturnKind rk, Node mid |
      summaryReadStep(summaryArgParam(arg, rk, out), c, mid) and
      summaryLocalStep(mid, TSummaryReturnNode(_, rk), _)
    )
  }

  /**
   * Holds if values stored inside content `c` are cleared at node `n`, as a result
   * of calling a library method.
   */
  predicate summaryClearsContent(Node n, Content c) {
    exists(LibraryTypeDataFlow ltdf, CallableFlowSource source, Call call |
      ltdf.clearsContent(source, c, call.getTarget().getSourceDeclaration()) and
      n.asExpr() = source.getSource(call)
    )
  }

  /** Gets the type of content `c`. */
  pragma[noinline]
  private Gvn::GvnType getContentType(Content c) {
    exists(Type t | result = Gvn::getGlobalValueNumber(t) |
      t = c.(FieldContent).getField().getType()
      or
      t = c.(PropertyContent).getProperty().getType()
      or
      c instanceof ElementContent and
      t instanceof ObjectType // we don't know what the actual element type is
    )
  }

  /** A data-flow node used to model flow summaries. */
  private class SummaryInternalNode extends SummaryNodeImpl, TSummaryInternalNode {
    private SourceDeclarationCallable c;
    private CallableFlowSource source;
    private AccessPath sourceAp;
    private CallableFlowSink sink;
    private AccessPath sinkAp;
    private boolean preservesValue;
    private SummaryInternalNodeState state;

    SummaryInternalNode() {
      this = TSummaryInternalNode(c, source, sourceAp, sink, sinkAp, preservesValue, state)
    }

    override DataFlowCallable getEnclosingCallableImpl() { result = c }

    override Gvn::GvnType getDataFlowType() {
      exists(AccessPath ap |
        state = TSummaryInternalNodeAfterReadState(ap) and
        if sinkAp.length() = 0 and state.isLastReadState() and preservesValue = true
        then result = getSinkNode(c, sink).getDataFlowType()
        else result = getContentType(ap.getHead())
        or
        state = TSummaryInternalNodeBeforeStoreState(ap) and
        if sourceAp.length() = 0 and state.isFirstStoreState() and preservesValue = true
        then result = getSourceNode(c, source).getDataFlowType()
        else result = getContentType(ap.getHead())
      )
    }

    override DotNet::Type getTypeImpl() { none() }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = c.getLocation() }

    override string toStringImpl() { result = "[summary] " + state + " in " + c }
  }
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
        )
      )
  }

  /** Gets the content that matches this field or property. */
  Content getContent() {
    result.(FieldContent).getField() = this.getSourceDeclaration()
    or
    result.(PropertyContent).getProperty() = this.getSourceDeclaration()
  }
}

private class InstanceFieldOrProperty extends FieldOrProperty {
  InstanceFieldOrProperty() { not this.isStatic() }
}

private class FieldOrPropertyAccess extends AssignableAccess, QualifiableExpr {
  FieldOrPropertyAccess() { this.getTarget() instanceof FieldOrProperty }
}

private class FieldOrPropertyRead extends FieldOrPropertyAccess, AssignableRead {
  /**
   * Holds if this field-like read is not completely determined by explicit
   * SSA updates.
   */
  predicate hasNonlocalValue() {
    this = any(Ssa::ImplicitUntrackedDefinition udef).getARead()
    or
    exists(Ssa::Definition def, Ssa::ImplicitDefinition idef |
      def.getARead() = this and
      idef = def.getAnUltimateDefinition()
    |
      idef instanceof Ssa::ImplicitEntryDefinition or
      idef instanceof Ssa::ImplicitCallDefinition
    )
  }
}

/** A write to a static field/property. */
private class StaticFieldLikeJumpNode extends NonLocalJumpNode, ExprNode {
  FieldOrProperty fl;
  FieldOrPropertyRead flr;
  ExprNode succ;

  StaticFieldLikeJumpNode() {
    fl.isStatic() and
    fl.isFieldLike() and
    fl.getAnAssignedValue() = this.getExpr() and
    fl.getAnAccess() = flr and
    flr = succ.getExpr() and
    flr.hasNonlocalValue()
  }

  override ExprNode getAJumpSuccessor(boolean preservesValue) {
    result = succ and preservesValue = true
  }
}

predicate jumpStep = jumpStepImpl/2;

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

predicate storeStep = storeStepImpl/3;

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
  }
}

predicate readStep = readStepImpl/3;

/**
 * An entity used to represent the type of data-flow node. Two nodes will have
 * the same `DataFlowType` when the underlying `Type`s are structurally equal
 * modulo type parameters and identity conversions.
 *
 * For example, `Func<T, int>` and `Func<S, int>` are mapped to the same
 * `DataFlowType`, while `Func<T, int>` and `Func<string, int>` are not, because
 * `string` is not a type parameter.
 */
class DataFlowType extends Gvn::GvnType {
  pragma[nomagic]
  DataFlowType() { this = any(NodeImpl n).getDataFlowType() }
}

/** Gets the type of `n` used for type pruning. */
DataFlowType getNodeType(NodeImpl n) { result = n.getDataFlowType() }

/** Gets a string representation of a `DataFlowType`. */
string ppReprType(DataFlowType t) { result = t.toString() }

private class DataFlowNullType extends DataFlowType {
  DataFlowNullType() { this = Gvn::getGlobalValueNumber(any(NullType nt)) }

  pragma[noinline]
  predicate isConvertibleTo(DataFlowType t) {
    defaultNullConversion(_, any(Type t0 | t = Gvn::getGlobalValueNumber(t0)))
  }
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
  class ObjectInitializerNode extends PostUpdateNode, NodeImpl, TObjectInitializerNode {
    private ObjectCreation oc;
    private ControlFlow::Nodes::ElementNode cfn;

    ObjectInitializerNode() {
      this = TObjectInitializerNode(cfn) and
      cfn = oc.getAControlFlowNode()
    }

    /** Gets the initializer to which this initializer node belongs. */
    ObjectOrCollectionInitializer getInitializer() { result = oc.getInitializer() }

    override MallocNode getPreUpdateNode() { result.getControlFlowNode() = cfn }

    override Callable getEnclosingCallableImpl() { result = cfn.getEnclosingCallable() }

    override DotNet::Type getTypeImpl() { result = oc.getType() }

    override ControlFlow::Nodes::ElementNode getControlFlowNodeImpl() { result = cfn }

    override Location getLocationImpl() { result = cfn.getLocation() }

    override string toStringImpl() { result = "[pre-initializer] " + cfn }
  }

  class ExprPostUpdateNode extends PostUpdateNode, NodeImpl, TExprPostUpdateNode {
    private ControlFlow::Nodes::ElementNode cfn;

    ExprPostUpdateNode() { this = TExprPostUpdateNode(cfn) }

    override ExprNode getPreUpdateNode() { cfn = result.getControlFlowNode() }

    override Callable getEnclosingCallableImpl() { result = cfn.getEnclosingCallable() }

    override Type getTypeImpl() { result = cfn.getElement().(Expr).getType() }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = cfn.getLocation() }

    override string toStringImpl() { result = "[post] " + cfn.toString() }
  }
}

private import PostUpdateNodes

/** A node that performs a type cast. */
class CastNode extends Node {
  CastNode() { castNode(this) }
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
  SsaDefinitionNode paramNode, boolean b, DataFlowCall call
) {
  exists(ConstantBooleanArgumentNode arg |
    viableParamArg(call, paramNode, arg) and
    b = arg.getBooleanValue()
  )
}

int accessPathLimit() { result = 5 }

/**
 * Holds if `n` does not require a `PostUpdateNode` as it either cannot be
 * modified or its modification cannot be observed, for example if it is a
 * freshly created object that is not saved in a variable.
 *
 * This predicate is only used for consistency checks.
 */
predicate isImmutableOrUnobservable(Node n) { none() }
