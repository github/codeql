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
}

/** An argument of a C# call (including qualifier arguments). */
private class Argument extends Expr {
  private Expr call;
  private int arg;

  Argument() {
    call =
      any(DispatchCall dc |
        this = dc.getArgument(arg)
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
 */
private predicate fieldOrPropertyAssign(Expr e, Content c, Expr src, Expr q) {
  exists(FieldOrPropertyAccess fa, FieldOrProperty f, AssignableDefinition def |
    def.getTargetAccess() = fa and
    f = fa.getTarget() and
    c = f.getContent() and
    src = def.getSource() and
    q = fa.getQualifier() and
    e = def.getExpr()
  |
    f.isFieldLike() and
    f instanceof InstanceFieldOrProperty
    or
    exists(AccessPath ap |
      LibraryFlow::libraryFlow(_, _, ap, _, _, _) and
      ap.contains(f.getContent())
    )
  )
}

/**
 * Holds if `oc` has an object initializer that assigns `src` to field or
 * property `c`.
 */
private predicate fieldOrPropertyInit(ObjectCreation oc, Content c, Expr src) {
  exists(MemberInitializer mi, FieldOrProperty f |
    mi = oc.getInitializer().(ObjectInitializer).getAMemberInitializer() and
    f = mi.getInitializedMember() and
    c = f.getContent() and
    src = mi.getRValue()
  |
    f.isFieldLike() and
    f instanceof InstanceFieldOrProperty
    or
    exists(AccessPath ap |
      LibraryFlow::libraryFlow(_, _, ap, _, _, _) and
      ap.contains(f.getContent())
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
      LibraryFlow::libraryFlow(_, _, _, _, ap, _) and
      ap.contains(ret.getContent()) and
      target.getGetter() = e2.(PropertyCall).getARuntimeTarget() and
      overridesOrImplementsSourceDecl(target, ret)
    )
  )
}

Type getCSharpType(DotNet::Type t) {
  result = t
  or
  result.matchesHandle(t)
}

pragma[noinline]
private TypeParameter getATypeParameterSubType(DataFlowType t) {
  not t instanceof Gvn::TypeParameterGvnType and
  exists(Type t0 | t = Gvn::getGlobalValueNumber(t0) | implicitConversionRestricted(result, t0))
}

pragma[noinline]
private DataFlowType getANonTypeParameterSubType(DataFlowType t) {
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
        LibraryFlow::libraryFlow(call, _, _, sink, _, _) and
        i = sink.getDelegateIndex() and
        j = sink.getDelegateParameterIndex() and
        call.getArgument(i).getAControlFlowNode() = cfn
      )
    } or
    TMallocNode(ControlFlow::Nodes::ElementNode cfn) { cfn.getElement() instanceof ObjectCreation } or
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
      fieldOrPropertyAssign(_, _, _, cfn.getElement())
      or
      exists(TExprPostUpdateNode upd, FieldOrPropertyAccess fla |
        upd = TExprPostUpdateNode(fla.getAControlFlowNode())
      |
        cfn.getElement() = fla.getQualifier()
      )
    } or
    TLibraryCodeNode(
      ControlFlow::Node callCfn, CallableFlowSource source, AccessPath sourceAp,
      CallableFlowSink sink, AccessPath sinkAp, boolean preservesValue
    ) {
      LibraryFlow::libraryFlow(callCfn.getElement(), source, sourceAp, sink, sinkAp, preservesValue)
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
    LocalFlow::localFlowStepCil(nodeFrom, nodeTo)
    or
    exists(LibraryCodeNode n | n.preservesValue() |
      n = nodeTo and
      nodeFrom = n.getPredecessor(AccessPath::empty())
      or
      n = nodeFrom and
      nodeTo = n.getSuccessor(AccessPath::empty())
    )
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
  newtype TContent =
    TFieldContent(Field f) { f = f.getSourceDeclaration() } or
    TPropertyContent(Property p) { p = p.getSourceDeclaration() }

  /**
   * Holds if data can flow from `node1` to `node2` via an assignment to
   * content `c`.
   */
  cached
  predicate storeStepImpl(Node node1, Content c, Node node2) {
    exists(StoreStepConfiguration x, ExprNode preNode2 |
      preNode2 = node2.(PostUpdateNode).getPreUpdateNode() and
      x.hasNodePath(node1, preNode2) and
      fieldOrPropertyAssign(_, c, node1.asExpr(), preNode2.getExpr())
    )
    or
    exists(StoreStepConfiguration x | x.hasNodePath(node1, node2) |
      fieldOrPropertyInit(node2.(ObjectCreationNode).getExpr(), c, node1.asExpr())
    )
    or
    node2 = node1.(LibraryCodeNode).getSuccessor(any(AccessPath ap | ap.getHead() = c))
  }

  /**
   * Holds if data can flow from `node1` to `node2` via a read of content `c`.
   */
  cached
  predicate readStepImpl(Node node1, Content c, Node node2) {
    exists(ReadStepConfiguration x |
      x.hasNodePath(node1, node2) and
      fieldOrPropertyRead(node1.asExpr(), c, node2.asExpr())
    )
    or
    node1 = node2.(LibraryCodeNode).getPredecessor(any(AccessPath ap | ap.getHead() = c))
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

  /**
   * Holds if GVNs `t1` and `t2` may have a common sub type. Neither `t1` nor
   * `t2` are allowed to be type parameters.
   */
  cached
  predicate commonSubType(DataFlowType t1, DataFlowType t2) {
    not t1 instanceof Gvn::TypeParameterGvnType and
    t1 = t2
    or
    getATypeParameterSubType(t1) = getATypeParameterSubType(t2)
    or
    getANonTypeParameterSubType(t1) = getANonTypeParameterSubType(t2)
  }

  cached
  predicate commonSubTypeUnifiableLeft(DataFlowType t1, DataFlowType t2) {
    exists(DataFlowType t |
      Gvn::unifiable(t1, t) and
      commonSubType(t, t2)
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
   * Holds if definition node `node` is an entry definition for parameter `p`.
   */
  predicate explicitParameterNode(AssignableDefinitionNode node, Parameter p) {
    p = node.getDefinition().(AssignableDefinitions::ImplicitParameterDefinition).getParameter()
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
  class ImplicitDelegateArgumentNode extends ArgumentNode, TImplicitDelegateArgumentNode {
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

    override Callable getEnclosingCallable() { result = cfn.getEnclosingCallable() }

    override Type getType() {
      result = this.getDelegateCall().getDelegateParameterType(parameterIndex)
    }

    override Location getLocation() { result = cfn.getLocation() }

    override string toString() { result = "[implicit argument " + parameterIndex + "] " + cfn }
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
   * A `yield return` node. A node is synthesized in order to be able to model
   * `yield return`s as stores into collections, i.e., there is flow from `e`
   * to `yield return e [e]`.
   */
  class YieldReturnNode extends ReturnNode, PostUpdateNode, TYieldReturnNode {
    private ControlFlow::Nodes::ElementNode cfn;
    private YieldReturnStmt yrs;

    YieldReturnNode() { this = TYieldReturnNode(cfn) and yrs.getExpr().getAControlFlowNode() = cfn }

    YieldReturnStmt getYieldReturnStmt() { result = yrs }

    override YieldReturnKind getKind() { any() }

    override ExprNode getPreUpdateNode() { result.getControlFlowNode() = cfn }

    override Callable getEnclosingCallable() { result = yrs.getEnclosingCallable() }

    override Type getType() { result = yrs.getEnclosingCallable().getReturnType() }

    override Location getLocation() { result = yrs.getLocation() }

    override string toString() { result = yrs.toString() }
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

    override Type getType() {
      exists(ImplicitDelegateDataFlowCall c | c.getNode() = this |
        result = c.getDelegateReturnType()
      )
    }

    override Location getLocation() { result = cfn.getLocation() }

    override string toString() { result = "[output] " + cfn }
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
    Call call, CallableFlowSource source, AccessPath sourceAp, Property p
  ) {
    exists(LibraryTypeDataFlow ltdf, Property p0 |
      ltdf.callableFlow(source, sourceAp, _, _, call.getTarget().getSourceDeclaration()) and
      sourceAp = AccessPath::property(p0) and
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
    Call call, CallableFlowSource source, AccessPath sourceAp
  ) {
    getPreciseSourceProperty0(call, source, sourceAp, result).hasMember(result)
  }

  pragma[nomagic]
  private ValueOrRefType getPreciseSinkProperty0(
    Call call, CallableFlowSink sink, AccessPath sinkAp, Property p
  ) {
    exists(LibraryTypeDataFlow ltdf, Property p0 |
      ltdf.callableFlow(_, _, sink, sinkAp, call.getTarget().getSourceDeclaration()) and
      sinkAp = AccessPath::property(p0) and
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
  private Property getPreciseSinkProperty(Call call, CallableFlowSink sink, AccessPath sinkAp) {
    getPreciseSinkProperty0(call, sink, sinkAp, result).hasMember(result)
  }

  /**
   * Holds if data can flow from a node of kind `source` to a node of kind `sink`,
   * using a call to a library callable.
   *
   * `sourceAp` describes the contents of the source node that flows to the sink
   * (if any), and `sinkAp` describes the contents of the sink that it flows to
   * (if any).
   *
   * `preservesValue = false` implies that both `sourceAp` and `sinkAp` are empty.
   */
  pragma[nomagic]
  predicate libraryFlow(
    Call call, CallableFlowSource source, AccessPath sourceAp, CallableFlowSink sink,
    AccessPath sinkAp, boolean preservesValue
  ) {
    exists(LibraryTypeDataFlow ltdf, SourceDeclarationCallable c |
      c = call.getTarget().getSourceDeclaration()
    |
      ltdf.callableFlow(source, sink, c, preservesValue) and
      sourceAp = AccessPath::empty() and
      sinkAp = AccessPath::empty()
      or
      preservesValue = true and
      exists(AccessPath sourceAp0, AccessPath sinkAp0 |
        ltdf.callableFlow(source, sourceAp0, sink, sinkAp0, c) and
        (
          not sourceAp0 = AccessPath::property(_) and
          sourceAp = sourceAp0
          or
          exists(Property p |
            overridesOrImplementsSourceDecl(p,
              getPreciseSourceProperty(call, source, sourceAp0).getSourceDeclaration()) and
            sourceAp = AccessPath::property(p)
          )
        ) and
        (
          not sinkAp0 = AccessPath::property(_) and
          sinkAp = sinkAp0
          or
          sinkAp = AccessPath::property(getPreciseSinkProperty(call, sink, sinkAp0))
        )
      )
    )
  }

  class LibrarySourceConfiguration extends ControlFlowReachabilityConfiguration {
    LibrarySourceConfiguration() { this = "LibrarySourceConfiguration" }

    override predicate candidate(
      Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
    ) {
      exists(CallableFlowSource source |
        libraryFlow(e2, source, _, _, _, _) and
        e1 = source.getSource(e2) and
        scope = e2 and
        exactScope = false and
        isSuccessor = true
      )
    }
  }

  class LibrarySinkConfiguration extends ControlFlowReachabilityConfiguration {
    LibrarySinkConfiguration() { this = "LibrarySinkConfiguration" }

    override predicate candidate(
      Expr e1, Expr e2, ControlFlowElement scope, boolean exactScope, boolean isSuccessor
    ) {
      exists(CallableFlowSink sink |
        libraryFlow(e1, _, _, sink, _, _) and
        e2 = sink.getSink(e1) and
        scope = e1 and
        exactScope = false and
        isSuccessor = false
      )
    }

    override predicate candidateDef(
      Expr e, AssignableDefinition def, ControlFlowElement scope, boolean exactScope,
      boolean isSuccessor
    ) {
      exists(CallableFlowSinkArg sink |
        libraryFlow(e, _, _, sink, _, _) and
        scope = e and
        exactScope = false and
        isSuccessor = true and
        def.getTargetAccess() = sink.getArgument(e) and
        def instanceof AssignableDefinitions::OutRefDefinition
      )
    }
  }
}

/** A data-flow node used to model flow through library code. */
class LibraryCodeNode extends Node, TLibraryCodeNode {
  private ControlFlow::Node callCfn;
  private CallableFlowSource source;
  private AccessPath sourceAp;
  private CallableFlowSink sink;
  private AccessPath sinkAp;
  private boolean preservesValue;

  LibraryCodeNode() {
    this = TLibraryCodeNode(callCfn, source, sourceAp, sink, sinkAp, preservesValue)
  }

  /** Holds if this node is part of a value-preserving library step. */
  predicate preservesValue() { preservesValue = true }

  /**
   * Gets the predecessor of this library-code node. The head of `ap` describes
   * the content that is read from when entering this node (if any).
   */
  Node getPredecessor(AccessPath ap) {
    ap = sourceAp and
    (
      // The source is either an argument or a qualifier, for example
      // `s` in `int.Parse(s)`
      exists(LibraryFlow::LibrarySourceConfiguration x, Call call |
        callCfn = call.getAControlFlowNode() and
        x.hasExprPath(source.getSource(call), result.(ExprNode).getControlFlowNode(), _, callCfn)
      )
      or
      // The source is the output of a supplied delegate argument, for
      // example the output of `Foo` in `new Lazy(Foo)`
      exists(DataFlowCall call, int pos |
        pos = source.(CallableFlowSourceDelegateArg).getArgumentIndex() and
        result.(ImplicitDelegateOutNode).isArgumentOf(call, pos) and
        callCfn = call.getControlFlowNode()
      )
    )
  }

  /**
   * Gets the successor of this library-code node. The head of `ap` describes
   * the content that is stored into when leaving this node (if any).
   */
  Node getSuccessor(AccessPath ap) {
    ap = sinkAp and
    (
      exists(LibraryFlow::LibrarySinkConfiguration x, Call call, ExprNode e |
        callCfn = call.getAControlFlowNode() and
        x.hasExprPath(_, callCfn, sink.getSink(call), e.getControlFlowNode())
      |
        // The sink is an ordinary return value, for example `int.Parse(s)`
        sink instanceof CallableFlowSinkReturn and
        result = e
        or
        // The sink is a qualifier, for example `list` in `list.Add(x)`
        sink instanceof CallableFlowSinkQualifier and
        if sinkAp = AccessPath::empty()
        then result = e
        else result.(ExprPostUpdateNode).getPreUpdateNode() = e
      )
      or
      // The sink is an `out`/`ref` argument, for example `out i` in
      // `int.TryParse(s, out i)`
      exists(LibraryFlow::LibrarySinkConfiguration x, OutRefReturnKind k |
        result =
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
        result = TImplicitDelegateArgumentNode(dcall.getControlFlowNode(), _, parameterIndex) and
        dcall.isArgumentOf(call, delegateIndex) and
        callCfn = call.getControlFlowNode()
      )
    )
  }

  override Callable getEnclosingCallable() { result = callCfn.getEnclosingCallable() }

  override DataFlowType getTypeBound() {
    preservesValue = true and
    sourceAp = AccessPath::empty() and
    result = this.getPredecessor(_).getTypeBound()
    or
    result = sourceAp.getHead().getType()
    or
    preservesValue = false and
    result = this.getSuccessor(_).getTypeBound()
  }

  override Location getLocation() { result = callCfn.getLocation() }

  override string toString() { result = "[library code] " + callCfn }
}

/** A field or a property. */
private class FieldOrProperty extends Assignable, Modifiable {
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
    isSuccessor = false and
    fieldOrPropertyAssign(scope, _, e1, e2)
    or
    exactScope = false and
    isSuccessor = false and
    fieldOrPropertyInit(e2, _, e1) and
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
  }
}

predicate readStep = readStepImpl/3;

/** Gets a string representation of a type returned by `getErasedRepr`. */
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
    ObjectCreationNode() { exists(ObjectCreation oc | this = TExprNode(oc.getAControlFlowNode())) }

    override MallocNode getPreUpdateNode() { this = TExprNode(result.getControlFlowNode()) }
  }

  class ExprPostUpdateNode extends PostUpdateNode, TExprPostUpdateNode {
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
class CastNode extends Node {
  CastNode() {
    this.asExpr() instanceof Cast
    or
    this.(AssignableDefinitionNode).getDefinition() instanceof
      AssignableDefinitions::PatternDefinition
    or
    readStep(_, _, this)
    or
    storeStep(this, _, _)
  }
}

class DataFlowExpr = DotNet::Expr;

class DataFlowType = Gvn::GvnType;

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

int accessPathLimit() { result = 3 }

/**
 * Holds if `n` does not require a `PostUpdateNode` as it either cannot be
 * modified or its modification cannot be observed, for example if it is a
 * freshly created object that is not saved in a variable.
 *
 * This predicate is only used for consistency checks.
 */
predicate isImmutableOrUnobservable(Node n) { none() }

pragma[inline]
DataFlowType getErasedRepr(DataFlowType t) { result = t }
