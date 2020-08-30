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
        e1 = e2.(AwaitExpr).getExpr() and
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
    n instanceof LibraryCodeNode or
    n instanceof ImplicitCapturedArgumentNode or
    n instanceof ImplicitDelegateOutNode or
    n instanceof ImplicitDelegateArgumentNode
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
      exists(LibraryFlow::AdjustedAccessPath ap |
        LibraryFlow::libraryFlowSummary(_, _, ap, _, _, _) and
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
    exists(LibraryFlow::AdjustedAccessPath ap, Property target |
      LibraryFlow::libraryFlowSummary(_, _, _, _, ap, _) and
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
  private import LibraryFlow

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
    TImplicitDelegateOutNode(
      ControlFlow::Nodes::ElementNode cfn, ControlFlow::Nodes::ElementNode call
    ) {
      cfn.getElement() instanceof DelegateArgumentToLibraryCallable and
      any(DelegateArgumentConfiguration x).hasExprPath(_, cfn, _, call)
    } or
    TImplicitDelegateArgumentNode(ControlFlow::Nodes::ElementNode cfn, int i, int j) {
      exists(Call call, CallableFlowSinkDelegateArg sink |
        libraryFlowSummary(call, _, _, sink, _, _) and
        i = sink.getDelegateIndex() and
        j = sink.getDelegateParameterIndex() and
        call.getArgument(i).getAControlFlowNode() = cfn
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
    TLibraryCodeNode(
      ControlFlow::Node callCfn, CallableFlowSource source, AdjustedAccessPath sourceAp,
      CallableFlowSink sink, AdjustedAccessPath sinkAp, boolean preservesValue,
      LibraryCodeNodeState state
    ) {
      libraryFlowSummary(callCfn.getElement(), source, sourceAp, sink, sinkAp, preservesValue) and
      (
        state = TLibraryCodeNodeAfterReadState(sourceAp.drop(_)) and
        (sourceAp.length() > 1 or sinkAp.length() > 0 or preservesValue = false)
        or
        state = TLibraryCodeNodeBeforeStoreState(sinkAp.drop(_)) and
        (sinkAp.length() > 1 or sourceAp.length() > 0 or preservesValue = false)
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
    LibraryFlow::localStepLibrary(nodeFrom, nodeTo, true)
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
    LibraryFlow::localStepLibrary(nodeFrom, nodeTo, true) and
    not LocalFlow::excludeFromExposedRelations(nodeFrom) and
    not LocalFlow::excludeFromExposedRelations(nodeTo)
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
    storeStepLibrary(node1, c, node2)
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
    )
    or
    readStepLibrary(node1, c, node2)
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
    storeStepLibrary(n, c, _) and
    not c instanceof ElementContent
    or
    clearsContentLibrary(n, c)
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
    n instanceof ImplicitDelegateOutNode
    or
    n instanceof ImplicitDelegateArgumentNode
    or
    n instanceof MallocNode
    or
    n instanceof LibraryCodeNode
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
      explicitParameterNode(this, parameter) or
      this = TCilParameterNode(parameter)
    }

    override DotNet::Parameter getParameter() { result = parameter }

    override predicate isParameterOf(DataFlowCallable c, int i) { c.getParameter(i) = parameter }

    override DotNet::Callable getEnclosingCallableImpl() { result = parameter.getCallable() }

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
   * A data flow node that represents an implicit argument of an implicit delegate
   * call in library code. For example, in
   *
   * ```csharp
   * x.Select(Foo);
   * ```
   *
   * `x` is an implicit argument of the implicit call to `Foo`.
   */
  class ImplicitDelegateArgumentNode extends ArgumentNode, NodeImpl, TImplicitDelegateArgumentNode {
    private ControlFlow::Node cfn;
    private int delegateIndex;
    private int parameterIndex;

    ImplicitDelegateArgumentNode() {
      this = TImplicitDelegateArgumentNode(cfn, delegateIndex, parameterIndex)
    }

    private ImplicitDelegateDataFlowCall getDelegateCall() { result.getControlFlowNode() = cfn }

    override predicate argumentOf(DataFlowCall call, int pos) {
      call = this.getDelegateCall() and
      pos = parameterIndex
    }

    override Callable getEnclosingCallableImpl() { result = cfn.getEnclosingCallable() }

    override Type getTypeImpl() {
      result = this.getDelegateCall().getDelegateParameterType(parameterIndex)
    }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = cfn.getLocation() }

    override string toStringImpl() { result = "[implicit argument " + parameterIndex + "] " + cfn }
  }

  /**
   * A data flow node that represents the implicit array creation in a call to a
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
      kind.(ImplicitCapturedReturnKind).getVariable() =
        this.getDefinition().getSourceVariable().getAssignable()
    }
  }

  /**
   * A data flow node that reads a value returned by a callable using an
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
   * A data flow node that represents the output of an implicit delegate call,
   * in a call to a library method. For example, the output from the implicit
   * call to `M` in `new Lazy<int>(M)`.
   */
  class ImplicitDelegateOutNode extends OutNode, NodeImpl, TImplicitDelegateOutNode {
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

    override ControlFlow::Nodes::ElementNode getControlFlowNodeImpl() { result = cfn }

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

    override Callable getEnclosingCallableImpl() { result = cfn.getEnclosingCallable() }

    override Type getTypeImpl() {
      exists(ImplicitDelegateDataFlowCall c | c.getNode() = this |
        result = c.getDelegateReturnType()
      )
    }

    override Location getLocationImpl() { result = cfn.getLocation() }

    override string toStringImpl() { result = "[output] " + cfn }
  }
}

import OutNodes

/**
 * Provides predicates related to flow through library code, based on
 * the flow summaries in `LibraryTypeDataFlow.qll`.
 */
module LibraryFlow {
  pragma[nomagic]
  private ValueOrRefType getPreciseSourceProperty0(
    Call call, CallableFlowSource source, AccessPath sourceAp, Property p, AccessPath sourceApTail
  ) {
    exists(LibraryTypeDataFlow ltdf, Property p0 |
      ltdf.callableFlow(source, sourceAp, _, _, call.getTarget().getSourceDeclaration(), _) and
      sourceAp.getHead().(PropertyContent).getProperty() = p0 and
      sourceAp.getTail() = sourceApTail and
      overridesOrImplementsSourceDecl(p, p0) and
      result = source.getSourceType(call)
    )
  }

  /**
   * Gets a precise source property for source `source` and access path `sourceAp`,
   * in the context of `call`. For example, in
   *
   * ```csharp
   * var list = new List<string>();
   * var count = list.Count();
   * ```
   *
   * the step from `list` to `list.Count()`, which may be modeled as a read of
   * the `Count` property from `ICollection<T>`, can be strengthened to be a
   * read of the `Count` property from `List<T>`.
   */
  pragma[nomagic]
  private Property getPreciseSourceProperty(
    Call call, CallableFlowSource source, AccessPath sourceAp, AccessPath sourceApTail
  ) {
    getPreciseSourceProperty0(call, source, sourceAp, result, sourceApTail).hasMember(result)
  }

  pragma[nomagic]
  private ValueOrRefType getPreciseSinkProperty0(
    Call call, CallableFlowSink sink, AccessPath sinkAp, Property p, AccessPath sinkApTail
  ) {
    exists(LibraryTypeDataFlow ltdf, Property p0 |
      ltdf.callableFlow(_, _, sink, sinkAp, call.getTarget().getSourceDeclaration(), _) and
      sinkAp.getHead().(PropertyContent).getProperty() = p0 and
      sinkAp.getTail() = sinkApTail and
      overridesOrImplementsSourceDecl(p, p0) and
      result = sink.getSinkType(call)
    )
  }

  /**
   * Gets a precise sink property for sink `sink` and access path `sinkAp`,
   * in the context of `call`. For example, in
   *
   * ```csharp
   * var list = new List<string>();
   * list.Add("taint");
   * var enumerator = list.getEnumerator();
   * ```
   *
   * the step from `list` to `list.getEnumerator()`, which may be modeled as a
   * read of a collection element followed by a store into the `Current`
   * property, can be strengthened to be a store into the `Current` property
   * from `List<T>.Enumerator`, rather than the generic `Current` property
   * from `IEnumerator<T>`.
   */
  pragma[nomagic]
  private Property getPreciseSinkProperty(
    Call call, CallableFlowSink sink, AccessPath sinkAp, AccessPath sinkApTail
  ) {
    getPreciseSinkProperty0(call, sink, sinkAp, result, sinkApTail).hasMember(result)
  }

  predicate adjustSourceHead(
    Call call, CallableFlowSource source, AccessPath sourceAp0, AccessPath sourceApTail,
    PropertyContent p
  ) {
    overridesOrImplementsSourceDecl(p.getProperty(),
      getPreciseSourceProperty(call, source, sourceAp0, sourceApTail).getSourceDeclaration())
  }

  predicate adjustSinkHead(
    Call call, CallableFlowSink sink, AccessPath sinkAp0, AccessPath sinkApTail, PropertyContent p
  ) {
    p.getProperty() = getPreciseSinkProperty(call, sink, sinkAp0, sinkApTail).getSourceDeclaration()
  }

  private newtype TAdjustedAccessPath =
    TOriginalAccessPath(AccessPath ap) or
    THeadAdjustedAccessPath(PropertyContent head, AccessPath tail) {
      adjustSourceHead(_, _, _, tail, head)
      or
      adjustSinkHead(_, _, _, tail, head)
    }

  /**
   * An access path used in a library-code flow-summary, where the head of the path
   * may have been adjusted. For example, in
   *
   * ```csharp
   * var list = new List<string>();
   * list.Add("taint");
   * var enumerator = list.getEnumerator();
   * ```
   *
   * the step from `list` to `list.getEnumerator()`, which may be modeled as a
   * read of a collection element followed by a store into the `Current`
   * property, can be strengthened to be a store into the `Current` property
   * from `List<T>.Enumerator`, rather than the generic `Current` property
   * from `IEnumerator<T>`.
   */
  abstract class AdjustedAccessPath extends TAdjustedAccessPath {
    /** Gets the head of this access path, if any. */
    abstract Content getHead();

    /** Gets the tail of this access path, if any. */
    abstract AdjustedAccessPath getTail();

    /** Gets the length of this access path. */
    abstract int length();

    /** Gets the access path obtained by dropping the first `i` elements, if any. */
    abstract AdjustedAccessPath drop(int i);

    /** Holds if this access path contains content `c`. */
    predicate contains(Content c) { c = this.drop(_).getHead() }

    /** Gets a textual representation of this access path. */
    string toString() {
      exists(Content head, AdjustedAccessPath tail |
        head = this.getHead() and
        tail = this.getTail() and
        if tail.length() = 0 then result = head.toString() else result = head + ", " + tail
      )
      or
      this.length() = 0 and
      result = "<empty>"
    }
  }

  private class OriginalAccessPath extends AdjustedAccessPath, TOriginalAccessPath {
    private AccessPath ap;

    OriginalAccessPath() { this = TOriginalAccessPath(ap) }

    override Content getHead() { result = ap.getHead() }

    override AdjustedAccessPath getTail() { result = TOriginalAccessPath(ap.getTail()) }

    override int length() { result = ap.length() }

    override AdjustedAccessPath drop(int i) { result = TOriginalAccessPath(ap.drop(i)) }
  }

  private class HeadAdjustedAccessPath extends AdjustedAccessPath, THeadAdjustedAccessPath {
    private PropertyContent head;
    private AccessPath tail;

    HeadAdjustedAccessPath() { this = THeadAdjustedAccessPath(head, tail) }

    override Content getHead() { result = head }

    override AdjustedAccessPath getTail() { result = TOriginalAccessPath(tail) }

    override int length() { result = 1 + tail.length() }

    override AdjustedAccessPath drop(int i) {
      i = 0 and result = this
      or
      result = TOriginalAccessPath(tail.drop(i - 1))
    }
  }

  module AdjustedAccessPath {
    AdjustedAccessPath empty() { result.length() = 0 }

    AdjustedAccessPath singleton(Content c) { result.getHead() = c and result.length() = 1 }
  }

  pragma[nomagic]
  private predicate callableFlow(
    CallableFlowSource source, AccessPath sourceAp, boolean adjustSourceAp, CallableFlowSink sink,
    AccessPath sinkAp, boolean adjustSinkAp, SourceDeclarationCallable c, boolean preservesValue
  ) {
    any(LibraryTypeDataFlow ltdf).callableFlow(source, sourceAp, sink, sinkAp, c, preservesValue) and
    (
      if sourceAp.getHead() instanceof PropertyContent
      then adjustSourceAp = true
      else adjustSourceAp = false
    ) and
    if sinkAp.getHead() instanceof PropertyContent
    then adjustSinkAp = true
    else adjustSinkAp = false
  }

  /**
   * Holds if data can flow from a node of kind `source` to a node of kind `sink`,
   * using a call to a library callable.
   *
   * `sourceAp` describes the contents of the source node that flows to the sink
   * (if any), and `sinkAp` describes the contents of the sink that it flows to
   * (if any).
   */
  pragma[nomagic]
  predicate libraryFlowSummary(
    Call call, CallableFlowSource source, AdjustedAccessPath sourceAp, CallableFlowSink sink,
    AdjustedAccessPath sinkAp, boolean preservesValue
  ) {
    exists(SourceDeclarationCallable c | c = call.getTarget().getSourceDeclaration() |
      any(LibraryTypeDataFlow ltdf).callableFlow(source, sink, c, preservesValue) and
      sourceAp = TOriginalAccessPath(AccessPath::empty()) and
      sinkAp = TOriginalAccessPath(AccessPath::empty())
      or
      exists(
        AccessPath sourceAp0, boolean adjustSourceAp, AccessPath sinkAp0, boolean adjustSinkAp
      |
        callableFlow(source, sourceAp0, adjustSourceAp, sink, sinkAp0, adjustSinkAp, c,
          preservesValue) and
        (
          adjustSourceAp = false and
          sourceAp = TOriginalAccessPath(sourceAp0)
          or
          adjustSourceAp = true and
          exists(PropertyContent p, AccessPath sourceApTail |
            adjustSourceHead(call, source, sourceAp0, sourceApTail, p) and
            sourceAp = THeadAdjustedAccessPath(p, sourceApTail)
          )
        ) and
        (
          adjustSinkAp = false and
          sinkAp = TOriginalAccessPath(sinkAp0)
          or
          adjustSinkAp = true and
          exists(PropertyContent p, AccessPath sinkApTail |
            adjustSinkHead(call, sink, sinkAp0, sinkApTail, p) and
            sinkAp = THeadAdjustedAccessPath(p, sinkApTail)
          )
        )
      )
    )
  }

  private class LibrarySourceConfiguration extends ControlFlowReachabilityConfiguration {
    LibrarySourceConfiguration() { this = "LibrarySourceConfiguration" }

    override predicate candidate(
      Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
    ) {
      exists(CallableFlowSource source |
        libraryFlowSummary(e2, source, _, _, _, _) and
        e1 = source.getSource(e2) and
        scope = e2 and
        exactScope = false and
        isSuccessor = true
      )
    }
  }

  private class LibrarySinkConfiguration extends ControlFlowReachabilityConfiguration {
    LibrarySinkConfiguration() { this = "LibrarySinkConfiguration" }

    override predicate candidate(
      Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
    ) {
      exists(CallableFlowSink sink |
        libraryFlowSummary(e1, _, _, sink, _, _) and
        e2 = sink.getSink(e1) and
        exactScope = false and
        if e2 instanceof ObjectOrCollectionInitializer
        then scope = e2 and isSuccessor = true
        else (
          scope = e1 and isSuccessor = false
        )
      )
    }

    override predicate candidateDef(
      Expr e, AssignableDefinition def, ControlFlowElement scope, boolean exactScope,
      boolean isSuccessor
    ) {
      exists(CallableFlowSinkArg sink |
        libraryFlowSummary(e, _, _, sink, _, _) and
        scope = e and
        exactScope = false and
        isSuccessor = true and
        def.getTargetAccess() = sink.getArgument(e) and
        def instanceof AssignableDefinitions::OutRefDefinition
      )
    }
  }

  newtype TLibraryCodeNodeState =
    TLibraryCodeNodeAfterReadState(AdjustedAccessPath ap) { ap.length() > 0 } or
    TLibraryCodeNodeBeforeStoreState(AdjustedAccessPath ap) { ap.length() > 0 }

  /**
   * A state used to break up (complex) flow summaries for library code into atomic
   * flow steps. For a flow summary with source access path `sourceAp` and sink
   * access path `sinkAp`, the following states are used:
   *
   * - `TLibraryCodeNodeAfterReadState(AccessPath ap)`: this state represents
   *   that the head of `ap` has been read from, where `ap` is a suffix of
   *   `sourceAp`.
   * - `TLibraryCodeNodeBeforeStoreState(AccessPath ap)`: this state represents
   *   that the head of `ap` is to be stored into next, where `ap` is a suffix of
   *   `sinkAp`.
   *
   * The state machine for flow summaries has no branching, hence from the entry
   * state there is a unique path to the exit state.
   */
  class LibraryCodeNodeState extends TLibraryCodeNodeState {
    string toString() {
      exists(AdjustedAccessPath ap |
        this = TLibraryCodeNodeAfterReadState(ap) and
        result = "after read: " + ap
      )
      or
      exists(AdjustedAccessPath ap |
        this = TLibraryCodeNodeBeforeStoreState(ap) and
        result = "before store: " + ap
      )
    }

    /** Holds if this state represents the state after the last read. */
    predicate isLastReadState() {
      this = TLibraryCodeNodeAfterReadState(AdjustedAccessPath::singleton(_))
    }

    /** Holds if this state represents the state before the first store. */
    predicate isFirstStoreState() {
      this = TLibraryCodeNodeBeforeStoreState(AdjustedAccessPath::singleton(_))
    }
  }

  /**
   * Holds if `entry` is an entry node of kind `source` for the call `callCfn`, which
   * targets a library callable with a flow summary.
   */
  private predicate entry(Node entry, ControlFlow::Node callCfn, CallableFlowSource source) {
    // The source is either an argument or a qualifier, for example
    // `s` in `int.Parse(s)`
    exists(LibrarySourceConfiguration x, Call call |
      callCfn = call.getAControlFlowNode() and
      x.hasExprPath(source.getSource(call), entry.(ExprNode).getControlFlowNode(), _, callCfn)
    )
    or
    // The source is the output of a supplied delegate argument, for
    // example the output of `Foo` in `new Lazy(Foo)`
    exists(DataFlowCall call, int pos |
      pos = source.(CallableFlowSourceDelegateArg).getArgumentIndex() and
      entry.(ImplicitDelegateOutNode).isArgumentOf(call, pos) and
      callCfn = call.getControlFlowNode()
    )
  }

  /**
   * Holds if `exit` is an exit node of kind `sink` for the call `callCfn`, which
   * targets a library callable with a flow summary.
   */
  private predicate exit(Node exit, ControlFlow::Node callCfn, CallableFlowSink sink) {
    exists(LibrarySinkConfiguration x, Call call, ExprNode e |
      callCfn = call.getAControlFlowNode() and
      x.hasExprPath(_, callCfn, sink.getSink(call), e.getControlFlowNode())
    |
      // The sink is an ordinary return value, for example `int.Parse(s)`
      sink instanceof CallableFlowSinkReturn and
      exit = e
      or
      // The sink is a qualifier, for example `list` in `list.Add(x)`
      sink instanceof CallableFlowSinkQualifier and
      if e.getExpr() instanceof ObjectOrCollectionInitializer
      then exit = e
      else exit.(ExprPostUpdateNode).getPreUpdateNode() = e
    )
    or
    // The sink is an `out`/`ref` argument, for example `out i` in
    // `int.TryParse(s, out i)`
    exists(LibrarySinkConfiguration x, OutRefReturnKind k |
      exit =
        any(ParamOutNode out |
          out.getCall(k).getControlFlowNode() = callCfn and
          sink.(CallableFlowSinkArg).getArgumentIndex() = k.getPosition() and
          x.hasDefPath(_, callCfn, out.getDefinition(), _)
        )
    )
    or
    // The sink is a parameter of a supplied delegate argument, for example
    // the parameter of `Foo` in `list.Select(Foo)`.
    //
    // This is implemented using a node that represents the implicit argument
    // (`ImplicitDelegateArgumentNode`) of the implicit call
    // (`ImplicitDelegateDataFlowCall`) to `Foo`.
    exists(
      DataFlowCall call, ImplicitDelegateDataFlowCall dcall, int delegateIndex, int parameterIndex
    |
      sink =
        any(CallableFlowSinkDelegateArg s |
          delegateIndex = s.getDelegateIndex() and
          parameterIndex = s.getDelegateParameterIndex()
        ) and
      exit = TImplicitDelegateArgumentNode(dcall.getControlFlowNode(), _, parameterIndex) and
      dcall.isArgumentOf(call, delegateIndex) and
      callCfn = call.getControlFlowNode()
    )
  }

  /**
   * Holds if there is a local step from `pred` to `succ`, which is synthesized
   * from a library-code flow summary.
   */
  predicate localStepLibrary(Node pred, Node succ, boolean preservesValue) {
    exists(
      ControlFlow::Node callCfn, CallableFlowSource source, AdjustedAccessPath sourceAp,
      CallableFlowSink sink, AdjustedAccessPath sinkAp
    |
      libraryFlowSummary(callCfn.getElement(), source, sourceAp, sink, sinkAp, preservesValue)
    |
      // Simple flow summary without reads or stores
      sourceAp = AdjustedAccessPath::empty() and
      sinkAp = AdjustedAccessPath::empty() and
      entry(pred, callCfn, source) and
      exit(succ, callCfn, sink)
      or
      // Entry step for a complex summary with no reads and (1) multiple stores, or
      // (2) at least one store and non-value-preservation
      exists(LibraryCodeNodeState succState |
        sourceAp = AdjustedAccessPath::empty() and
        entry(pred, callCfn, source) and
        succState.isFirstStoreState() and
        succ = TLibraryCodeNode(callCfn, source, sourceAp, sink, sinkAp, preservesValue, succState)
      )
      or
      // Exit step for a complex summary with no stores and (1) multiple reads, or
      // (2) at least one read and non-value-preservation
      exists(LibraryCodeNodeState predState |
        sinkAp = AdjustedAccessPath::empty() and
        predState.isLastReadState() and
        pred = TLibraryCodeNode(callCfn, source, sourceAp, sink, sinkAp, preservesValue, predState) and
        exit(succ, callCfn, sink)
      )
    )
    or
    // Internal step for complex flow summaries with both reads and writes
    exists(
      ControlFlow::Node callCfn, CallableFlowSource source, AdjustedAccessPath sourceAp,
      CallableFlowSink sink, AdjustedAccessPath sinkAp, LibraryCodeNodeState predState,
      LibraryCodeNodeState succState
    |
      predState.isLastReadState() and
      pred = TLibraryCodeNode(callCfn, source, sourceAp, sink, sinkAp, preservesValue, predState) and
      succState.isFirstStoreState() and
      succ = TLibraryCodeNode(callCfn, source, sourceAp, sink, sinkAp, preservesValue, succState)
    )
  }

  /**
   * Holds if there is a store of `pred` into content `c` of `succ`, which happens
   * via library code.
   */
  predicate setterLibrary(Node pred, Content c, Node succ, boolean preservesValue) {
    exists(ControlFlow::Node callCfn, CallableFlowSource source, CallableFlowSink sink |
      libraryFlowSummary(callCfn.getElement(), source, AdjustedAccessPath::empty(), sink,
        AdjustedAccessPath::singleton(c), preservesValue)
    |
      entry(pred, callCfn, source) and
      exit(succ, callCfn, sink)
    )
  }

  /**
   * Holds if data can flow from `pred` to `succ` via an assignment to
   * content `c`, using library code.
   */
  predicate storeStepLibrary(Node pred, Content c, Node succ) {
    // Complex flow summary
    exists(
      ControlFlow::Node callCfn, CallableFlowSource source, AdjustedAccessPath sourceAp,
      CallableFlowSink sink, AdjustedAccessPath sinkAp, boolean preservesValue,
      LibraryCodeNodeState predState, AdjustedAccessPath ap
    |
      predState = TLibraryCodeNodeBeforeStoreState(ap) and
      pred = TLibraryCodeNode(callCfn, source, sourceAp, sink, sinkAp, preservesValue, predState) and
      c = ap.getHead()
    |
      // More stores needed
      exists(LibraryCodeNodeState succState |
        succState =
          TLibraryCodeNodeBeforeStoreState(any(AdjustedAccessPath succAp | succAp.getTail() = ap)) and
        succ = TLibraryCodeNode(callCfn, source, sourceAp, sink, sinkAp, preservesValue, succState)
      )
      or
      // Last store
      ap = sinkAp and
      exit(succ, callCfn, sink)
    )
    or
    // Value-preserving setter
    setterLibrary(pred, c, succ, true)
  }

  /**
   * Holds if there is a read of `c` from `pred` to `succ`, which happens via
   * library code.
   */
  predicate getterLibrary(Node pred, Content c, Node succ, boolean preservesValue) {
    exists(ControlFlow::Node callCfn, CallableFlowSource source, CallableFlowSink sink |
      libraryFlowSummary(callCfn.getElement(), source, AdjustedAccessPath::singleton(c), sink,
        AdjustedAccessPath::empty(), preservesValue) and
      entry(pred, callCfn, source) and
      exit(succ, callCfn, sink)
    )
  }

  /**
   * Holds if data can flow from `pred` to `succ` via a read of content `c`,
   * using library code.
   */
  predicate readStepLibrary(Node pred, Content c, Node succ) {
    // Complex flow summary
    exists(
      ControlFlow::Node callCfn, CallableFlowSource source, AdjustedAccessPath sourceAp,
      CallableFlowSink sink, AdjustedAccessPath sinkAp, boolean preservesValue,
      LibraryCodeNodeState succState, AdjustedAccessPath ap
    |
      succState = TLibraryCodeNodeAfterReadState(ap) and
      succ = TLibraryCodeNode(callCfn, source, sourceAp, sink, sinkAp, preservesValue, succState) and
      c = ap.getHead()
    |
      // First read
      ap = sourceAp and
      entry(pred, callCfn, source)
      or
      // Subsequent reads
      exists(LibraryCodeNodeState predState, AdjustedAccessPath predAp |
        predState = TLibraryCodeNodeAfterReadState(predAp) and
        predAp.getTail() = ap and
        pred = TLibraryCodeNode(callCfn, source, sourceAp, sink, sinkAp, preservesValue, predState)
      )
    )
    or
    // Value-preserving getter
    getterLibrary(pred, c, succ, true)
  }

  /**
   * Holds if values stored inside content `c` are cleared at node `n`, as a result
   * of calling a library method.
   */
  predicate clearsContentLibrary(Node n, Content c) {
    exists(LibraryTypeDataFlow ltdf, CallableFlowSource source, Call call |
      ltdf.clearsContent(source, c, call.getTarget().getSourceDeclaration()) and
      n.asExpr() = source.getSource(call)
    )
  }
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

/** A data-flow node used to model flow through library code. */
class LibraryCodeNode extends NodeImpl, TLibraryCodeNode {
  private ControlFlow::Node callCfn;
  private CallableFlowSource source;
  private LibraryFlow::AdjustedAccessPath sourceAp;
  private CallableFlowSink sink;
  private LibraryFlow::AdjustedAccessPath sinkAp;
  private boolean preservesValue;
  private LibraryFlow::LibraryCodeNodeState state;

  LibraryCodeNode() {
    this = TLibraryCodeNode(callCfn, source, sourceAp, sink, sinkAp, preservesValue, state)
  }

  override Callable getEnclosingCallableImpl() { result = callCfn.getEnclosingCallable() }

  override Gvn::GvnType getDataFlowType() {
    exists(LibraryFlow::AdjustedAccessPath ap |
      state = LibraryFlow::TLibraryCodeNodeAfterReadState(ap) and
      if sinkAp.length() = 0 and state.isLastReadState() and preservesValue = true
      then result = Gvn::getGlobalValueNumber(sink.getSinkType(callCfn.getElement()))
      else result = getContentType(ap.getHead())
      or
      state = LibraryFlow::TLibraryCodeNodeBeforeStoreState(ap) and
      if sourceAp.length() = 0 and state.isFirstStoreState() and preservesValue = true
      then result = Gvn::getGlobalValueNumber(source.getSourceType(callCfn.getElement()))
      else result = getContentType(ap.getHead())
    )
  }

  override DotNet::Type getTypeImpl() { none() }

  override ControlFlow::Node getControlFlowNodeImpl() { result = callCfn }

  override Location getLocationImpl() { result = callCfn.getLocation() }

  override string toStringImpl() { result = "[library code: " + state + "] " + callCfn }
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
