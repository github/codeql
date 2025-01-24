private import csharp
private import DataFlowPublic
private import DataFlowDispatch
private import DataFlowImplCommon
private import ControlFlowReachability
private import FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.csharp.dataflow.FlowSummary as FlowSummary
private import semmle.code.csharp.dataflow.internal.ExternalFlow
private import semmle.code.csharp.Conversion
private import semmle.code.csharp.dataflow.internal.SsaImpl as SsaImpl
private import semmle.code.csharp.ExprOrStmtParent
private import semmle.code.csharp.Unification
private import semmle.code.csharp.controlflow.Guards
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.frameworks.EntityFramework
private import semmle.code.csharp.frameworks.system.linq.Expressions
private import semmle.code.csharp.frameworks.NHibernate
private import semmle.code.csharp.frameworks.Razor
private import semmle.code.csharp.frameworks.system.Collections
private import semmle.code.csharp.frameworks.system.threading.Tasks
private import semmle.code.csharp.internal.Location
private import codeql.util.Unit
private import codeql.util.Boolean

/** Gets the callable in which this node occurs. */
DataFlowCallable nodeGetEnclosingCallable(Node n) {
  result = n.(NodeImpl).getEnclosingCallableImpl()
}

/** Holds if `p` is a `ParameterNode` of `c` with position `pos`. */
predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
  p.(ParameterNodeImpl).isParameterOf(c, pos)
}

/** Holds if `arg` is an `ArgumentNode` of `c` with position `pos`. */
predicate isArgumentNode(ArgumentNode arg, DataFlowCall c, ArgumentPosition pos) {
  arg.argumentOf(c, pos)
}

/**
 * Gets a control flow node used for data flow purposes for the primary constructor
 * parameter access `pa`.
 */
private ControlFlow::Node getAPrimaryConstructorParameterCfn(ParameterAccess pa) {
  pa.getTarget().getCallable() instanceof PrimaryConstructor and
  (
    result = pa.(ParameterRead).getAControlFlowNode()
    or
    pa =
      any(AssignableDefinition def | result = def.getExpr().getAControlFlowNode()).getTargetAccess()
  )
}

abstract class NodeImpl extends Node {
  /** Do not call: use `getEnclosingCallable()` instead. */
  abstract DataFlowCallable getEnclosingCallableImpl();

  /** Do not call: use `getType()` instead. */
  cached
  abstract Type getTypeImpl();

  /** Gets the type of this node used for type pruning. */
  DataFlowType getDataFlowType() {
    forceCachingInSameStage() and
    exists(Type t0 | result.asGvnType() = Gvn::getGlobalValueNumber(t0) |
      t0 = this.getType()
      or
      not exists(this.getType()) and
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

// TODO: Remove once static initializers are folded into the
// static constructors
private DataFlowCallable getEnclosingStaticFieldOrProperty(Expr e) {
  result.asFieldOrProperty() =
    any(FieldOrProperty f |
      f.isStatic() and
      e = f.getAChild+() and
      not exists(e.getEnclosingCallable())
    )
}

private class ExprNodeImpl extends ExprNode, NodeImpl {
  override DataFlowCallable getEnclosingCallableImpl() {
    result.getAControlFlowNode() = this.getControlFlowNodeImpl()
    or
    result = getEnclosingStaticFieldOrProperty(this.asExpr())
  }

  override Type getTypeImpl() {
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
  }
}

/**
 * A node that represents the creation of a local function.
 *
 * Needed for flow through captured variables, where we treat local functions
 * as if they were lambdas.
 */
abstract private class LocalFunctionCreationNode extends NodeImpl, TLocalFunctionCreationNode {
  ControlFlow::Nodes::ElementNode cfn;
  LocalFunction function;
  boolean isPostUpdate;

  LocalFunctionCreationNode() {
    this = TLocalFunctionCreationNode(cfn, isPostUpdate) and
    function = cfn.getAstNode().(LocalFunctionStmt).getLocalFunction()
  }

  LocalFunction getFunction() { result = function }

  ExprNode getAnAccess(boolean inSameCallable) {
    isLocalFunctionCallReceiver(_, result.getExpr(), this.getFunction()) and
    if result.getEnclosingCallable() = this.getEnclosingCallable()
    then inSameCallable = true
    else inSameCallable = false
  }

  override DataFlowCallable getEnclosingCallableImpl() { result.getAControlFlowNode() = cfn }

  override Type getTypeImpl() { none() }

  override DataFlowType getDataFlowType() { result.asDelegate() = function }

  override ControlFlow::Nodes::ElementNode getControlFlowNodeImpl() { none() }

  ControlFlow::Nodes::ElementNode getUnderlyingControlFlowNode() { result = cfn }

  override Location getLocationImpl() { result = cfn.getLocation() }
}

private class LocalFunctionCreationPreNode extends LocalFunctionCreationNode {
  LocalFunctionCreationPreNode() { isPostUpdate = false }

  override string toStringImpl() { result = cfn.toString() }
}

/** Calculation of the relative order in which `this` references are read. */
private module ThisFlow {
  private class BasicBlock = ControlFlow::BasicBlock;

  /** Holds if `e` is a `this` access. */
  predicate thisAccessExpr(Expr e) { e instanceof ThisAccess or e instanceof BaseAccess }

  /** Holds if `n` is a `this` access at control flow node `cfn`. */
  private predicate thisAccess(Node n, ControlFlow::Node cfn) {
    thisAccessExpr(n.asExprAtNode(cfn))
    or
    cfn = n.(InstanceParameterAccessPreNode).getUnderlyingControlFlowNode()
  }

  private predicate thisAccess(Node n, BasicBlock bb, int i) {
    thisAccess(n, bb.getNode(i))
    or
    exists(Parameter p | n.(PrimaryConstructorThisAccessPreNode).getParameter() = p |
      bb.getCallable() = p.getCallable() and
      i = p.getPosition() + 1
    )
    or
    exists(DataFlowCallable c, ControlFlow::BasicBlocks::EntryBlock entry |
      n.(InstanceParameterNode).isParameterOf(c, _) and
      exists(ControlFlow::Node succ |
        succ = c.getAControlFlowNode() and
        succ = entry.getFirstNode().getASuccessor() and
        // In case `c` has multiple bodies, we want each body to gets its own implicit
        // entry definition. In case `c` doesn't have multiple bodies, the line below
        // is simply the same as `bb = entry`, because `entry.getFirstNode().getASuccessor()`
        // will be in the entry block.
        bb = succ.getBasicBlock() and
        i = -1
      )
    )
  }

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
  exists(ControlFlow::Node cfn1, ControlFlow::Node cfn2 | conf.hasExprPath(_, cfn1, _, cfn2) |
    cfn1 = n1.getControlFlowNode() and
    cfn2 = n2.(ExprNode).getControlFlowNode()
  )
  or
  exists(ControlFlow::Node cfn, AssignableDefinition def, ControlFlow::Node cfnDef |
    conf.hasDefPath(_, cfn, def, cfnDef) and
    cfn = n1.getControlFlowNode() and
    n2 = TAssignableDefinitionNode(def, cfnDef)
  )
}

/** Provides logic related to captured variables. */
module VariableCapture {
  private import codeql.dataflow.VariableCapture as Shared

  private predicate closureFlowStep(ControlFlow::Nodes::ExprNode e1, ControlFlow::Nodes::ExprNode e2) {
    e1 = LocalFlow::getALastEvalNode(e2)
    or
    exists(Ssa::Definition def, AssignableDefinition adef |
      LocalFlow::defAssigns(adef, _, e1) and
      def.getAnUltimateDefinition().(Ssa::ExplicitDefinition).getADefinition() = adef and
      exists(def.getAReadAtNode(e2))
    )
  }

  private module CaptureInput implements Shared::InputSig<Location> {
    private import csharp as Cs
    private import semmle.code.csharp.controlflow.ControlFlowGraph as Cfg
    private import semmle.code.csharp.controlflow.BasicBlocks as BasicBlocks
    private import TaintTrackingPrivate as TaintTrackingPrivate

    class BasicBlock extends BasicBlocks::BasicBlock {
      Callable getEnclosingCallable() { result = super.getCallable() }
    }

    class ControlFlowNode = Cfg::ControlFlow::Node;

    BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) {
      result = bb.getImmediateDominator()
    }

    BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

    private predicate thisAccess(ControlFlow::Node cfn, InstanceCallable c) {
      ThisFlow::thisAccessExpr(cfn.getAstNode()) and
      cfn.getEnclosingCallable().getEnclosingCallable*() = c
    }

    private predicate capturedThisAccess(ControlFlow::Node cfn, InstanceCallable c) {
      thisAccess(cfn, c) and
      cfn.getEnclosingCallable() != c
    }

    private newtype TCapturedVariable =
      TCapturedLocalScopeVariable(LocalScopeVariable v) {
        v.isCaptured() and not v.(Parameter).getCallable() instanceof PrimaryConstructor
      } or
      TCapturedThis(Callable c) { capturedThisAccess(_, c) }

    /** A captured local scope variable. Includes captured `this` variables. */
    class CapturedVariable extends TCapturedVariable {
      LocalScopeVariable asLocalScopeVariable() { this = TCapturedLocalScopeVariable(result) }

      Callable asThis() { this = TCapturedThis(result) }

      Callable getCallable() {
        result = this.asLocalScopeVariable().getCallable()
        or
        result = this.asThis()
      }

      Type getType() {
        result = this.asLocalScopeVariable().getType()
        or
        result = this.asThis().getDeclaringType()
      }

      string toString() {
        result = this.asLocalScopeVariable().toString()
        or
        result = "this in " + this.asThis()
      }

      Location getLocation() {
        result = this.asLocalScopeVariable().getLocation()
        or
        result = this.asThis().getLocation()
      }
    }

    abstract class CapturedParameter extends CapturedVariable {
      abstract ParameterNodeImpl getParameterNode();
    }

    private class CapturedExplicitParameter extends CapturedParameter, TCapturedLocalScopeVariable {
      private Parameter p;

      CapturedExplicitParameter() { p = this.asLocalScopeVariable() }

      override ExplicitParameterNode getParameterNode() { result.asParameter() = p }
    }

    private class CapturedThisParameter extends CapturedParameter, TCapturedThis {
      override InstanceParameterNode getParameterNode() {
        result = TInstanceParameterNode(this.asThis(), _)
      }
    }

    class Expr extends ControlFlow::Node {
      predicate hasCfgNode(BasicBlock bb, int i) { this = bb.getNode(i) }
    }

    class VariableWrite extends Expr {
      CapturedVariable v;
      AssignableDefinition def;

      VariableWrite() {
        def.getTarget() = v.asLocalScopeVariable() and
        this = def.getExpr().getAControlFlowNode()
      }

      ControlFlow::Node getRhs() { LocalFlow::defAssigns(def, this, result) }

      CapturedVariable getVariable() { result = v }
    }

    class VariableRead extends Expr {
      CapturedVariable v;

      VariableRead() {
        this.getAstNode().(AssignableRead).getTarget() = v.asLocalScopeVariable()
        or
        thisAccess(this, v.asThis())
      }

      CapturedVariable getVariable() { result = v }
    }

    class ClosureExpr extends Expr {
      Callable c;

      ClosureExpr() { lambdaCreationExpr(this.getAstNode(), c) }

      predicate hasBody(Callable body) { body = c }

      predicate hasAliasedAccess(Expr f) {
        closureFlowStep+(this, f) and not closureFlowStep(f, _)
        or
        isLocalFunctionCallReceiver(_, f.getAstNode(), c)
      }
    }

    class Callable extends Cs::Callable {
      predicate isConstructor() { this instanceof Constructor }
    }
  }

  class CapturedVariable = CaptureInput::CapturedVariable;

  class ClosureExpr = CaptureInput::ClosureExpr;

  module Flow = Shared::Flow<Location, CaptureInput>;

  private Flow::ClosureNode asClosureNode(Node n) {
    result = n.(CaptureNode).getSynthesizedCaptureNode()
    or
    result.(Flow::ExprNode).getExpr() =
      [
        n.(ExprNode).getControlFlowNode(),
        n.(LocalFunctionCreationPreNode).getUnderlyingControlFlowNode()
      ]
    or
    result.(Flow::VariableWriteSourceNode).getVariableWrite().getRhs() =
      n.(ExprNode).getControlFlowNode()
    or
    result.(Flow::ExprPostUpdateNode).getExpr() =
      [
        n.(PostUpdateNode).getPreUpdateNode().(ExprNode).getControlFlowNode(),
        n.(LocalFunctionCreationPostUpdateNode).getUnderlyingControlFlowNode()
      ]
    or
    result.(Flow::ParameterNode).getParameter().getParameterNode() = n
    or
    result.(Flow::ThisParameterNode).getCallable() = n.(DelegateSelfReferenceNode).getCallable()
  }

  CapturedVariable getCapturedVariableContent(CapturedVariableContent c) {
    c = TCapturedVariableContent(result)
  }

  predicate storeStep(Node node1, CapturedVariableContent c, Node node2) {
    Flow::storeStep(asClosureNode(node1), getCapturedVariableContent(c), asClosureNode(node2))
  }

  predicate readStep(Node node1, CapturedVariableContent c, Node node2) {
    Flow::readStep(asClosureNode(node1), getCapturedVariableContent(c), asClosureNode(node2))
  }

  predicate valueStep(Node node1, Node node2) {
    Flow::localFlowStep(asClosureNode(node1), asClosureNode(node2))
  }

  predicate clearsContent(Node node, CapturedVariableContent c) {
    Flow::clearsContent(asClosureNode(node), getCapturedVariableContent(c))
  }

  class CapturedSsaDefinitionExt extends SsaImpl::DefinitionExt {
    CapturedSsaDefinitionExt() {
      this.getSourceVariable().getAssignable() = any(CapturedVariable v).asLocalScopeVariable()
    }
  }

  private predicate flowInsensitiveWriteStep(
    ExprNode node1, FlowInsensitiveCapturedVariableNode node2, LocalScopeVariable v
  ) {
    exists(AssignableDefinition def |
      def.getSource() = node1.getExpr() and
      def.getTarget() = v and
      node2.getVariable() = v
    )
  }

  private predicate flowInsensitiveReadStep(
    FlowInsensitiveCapturedVariableNode node1, ExprNode node2, LocalScopeVariable v
  ) {
    node1.getVariable() = v and
    node2.getExpr().(VariableRead).getTarget() = v
  }

  /**
   * Holds if there is control-flow insensitive data-flow from `node1` to `node2`
   * involving a captured variable. Only used in lambda flow.
   */
  predicate flowInsensitiveStep(Node node1, Node node2) {
    exists(LocalScopeVariable v |
      flowInsensitiveWriteStep(node1, node2, v) and
      flowInsensitiveReadStep(_, _, v)
      or
      flowInsensitiveReadStep(node1, node2, v) and
      flowInsensitiveWriteStep(_, _, v)
    )
  }
}

/** Provides logic related to SSA. */
module SsaFlow {
  private module Impl = SsaImpl::DataFlowIntegration;

  Impl::Node asNode(Node n) {
    n = TSsaNode(result)
    or
    result.(Impl::ExprNode).getExpr() = n.(ExprNode).getControlFlowNode()
    or
    result.(Impl::ExprPostUpdateNode).getExpr() =
      n.(PostUpdateNode).getPreUpdateNode().(ExprNode).getControlFlowNode()
    or
    result.(Impl::ParameterNode).getParameter() = n.(ExplicitParameterNode).getSsaDefinition()
  }

  predicate localFlowStep(SsaImpl::DefinitionExt def, Node nodeFrom, Node nodeTo, boolean isUseStep) {
    Impl::localFlowStep(def, asNode(nodeFrom), asNode(nodeTo), isUseStep)
  }

  predicate localMustFlowStep(SsaImpl::DefinitionExt def, Node nodeFrom, Node nodeTo) {
    Impl::localMustFlowStep(def, asNode(nodeFrom), asNode(nodeTo))
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
        e1 = e2.(CheckedExpr).getExpr() and
        scope = e2 and
        isSuccessor = true
        or
        e1 = e2.(UncheckedExpr).getExpr() and
        scope = e2 and
        isSuccessor = true
        or
        e1 = e2.(CollectionExpression).getAnElement() and
        e1 instanceof SpreadElementExpr and
        scope = e2 and
        isSuccessor = true
        or
        e1 = e2.(SpreadElementExpr).getExpr() and
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

  predicate defAssigns(AssignableDefinition def, ControlFlow::Node cfnDef, ControlFlow::Node value) {
    any(LocalExprStepConfiguration x).hasDefPath(_, value, def, cfnDef)
  }

  /**
   * Holds if the source variable of SSA definition `def` is an instance field.
   */
  predicate usesInstanceField(SsaImpl::DefinitionExt def) {
    exists(Ssa::SourceVariables::FieldOrPropSourceVariable fp | fp = def.getSourceVariable() |
      not fp.getAssignable().(Modifiable).isStatic()
    )
  }

  predicate localFlowStepCommon(Node nodeFrom, Node nodeTo) {
    hasNodePath(any(LocalExprStepConfiguration x), nodeFrom, nodeTo)
    or
    ThisFlow::adjacentThisRefs(nodeFrom, nodeTo) and
    nodeFrom != nodeTo
    or
    ThisFlow::adjacentThisRefs(nodeFrom.(PostUpdateNode).getPreUpdateNode(), nodeTo)
    or
    exists(AssignableDefinition def, ControlFlow::Node cfn, Ssa::ExplicitDefinition ssaDef |
      ssaDef.getADefinition() = def and
      ssaDef.getControlFlowNode() = cfn and
      nodeFrom = TAssignableDefinitionNode(def, cfn) and
      nodeTo.(SsaDefinitionExtNode).getDefinitionExt() = ssaDef
    )
  }

  /**
   * Holds if node `n` should not be included in the exposed local data/taint
   * flow relations. This is the case for nodes that are only relevant for
   * inter-procedurality or field-sensitivity.
   */
  predicate excludeFromExposedRelations(Node n) {
    n instanceof FlowSummaryNode or
    n instanceof CaptureNode
  }

  /**
   * Gets a node that may execute last in `n`, and which, when it executes last,
   * will be the value of `n`.
   */
  ControlFlow::Nodes::ExprNode getALastEvalNode(ControlFlow::Nodes::ExprNode cfn) {
    exists(Expr e | any(LocalExprStepConfiguration x).hasExprPath(_, result, e, cfn) |
      e instanceof ConditionalExpr or
      e instanceof Cast or
      e instanceof NullCoalescingExpr or
      e instanceof SwitchExpr or
      e instanceof SuppressNullableWarningExpr or
      e instanceof AssignExpr
    )
  }

  /** Gets a node for which to construct a post-update node for argument `arg`. */
  ControlFlow::Nodes::ExprNode getAPostUpdateNodeForArg(ControlFlow::Nodes::ExprNode arg) {
    arg.getExpr() instanceof Argument and
    result = getALastEvalNode*(arg) and
    exists(Expr e, Type t | result.getExpr() = e and t = e.stripCasts().getType() |
      t instanceof RefType and
      not t instanceof NullType
      or
      t = any(TypeParameter tp | not tp.isValueType())
      or
      t.isRefLikeType()
    ) and
    not exists(getALastEvalNode(result))
  }

  /**
   * Holds if the value of `node2` is given by `node1`.
   */
  predicate localMustFlowStep(Node node1, Node node2) {
    exists(DataFlowCallable c, Expr e |
      node1.(InstanceParameterNode).getEnclosingCallableImpl() = c and
      node2.getControlFlowNode() = c.getAControlFlowNode() and
      node2.asExpr() = e
    |
      e instanceof ThisAccess or e instanceof BaseAccess
    )
    or
    hasNodePath(any(LocalExprStepConfiguration x), node1, node2) and
    (
      node2 instanceof AssignableDefinitionNode or
      node2.asExpr() instanceof Cast or
      node2.asExpr() instanceof AssignExpr
    )
    or
    SsaFlow::localMustFlowStep(_, node1, node2)
    or
    node2 = node1.(LocalFunctionCreationNode).getAnAccess(true)
    or
    FlowSummaryImpl::Private::Steps::summaryLocalMustFlowStep(node1
          .(FlowSummaryNode)
          .getSummaryNode(), node2.(FlowSummaryNode).getSummaryNode())
  }
}

predicate localMustFlowStep = LocalFlow::localMustFlowStep/2;

/**
 * This is the local flow predicate that is used as a building block in global
 * data flow. It excludes SSA flow through instance fields, as flow through fields
 * is handled by the global data-flow library, but includes various other steps
 * that are only relevant for global flow.
 */
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo, string model) {
  (
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    exists(SsaImpl::DefinitionExt def, boolean isUseStep |
      SsaFlow::localFlowStep(def, nodeFrom, nodeTo, isUseStep) and
      not LocalFlow::usesInstanceField(def) and
      not def instanceof VariableCapture::CapturedSsaDefinitionExt
    |
      isUseStep = false
      or
      isUseStep = true and
      not FlowSummaryImpl::Private::Steps::prohibitsUseUseFlow(nodeFrom, _)
    )
    or
    nodeTo.(ObjectCreationNode).getPreUpdateNode() = nodeFrom.(ObjectInitializerNode)
    or
    VariableCapture::valueStep(nodeFrom, nodeTo)
    or
    nodeTo = nodeFrom.(LocalFunctionCreationNode).getAnAccess(true)
  ) and
  model = ""
  or
  FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom.(FlowSummaryNode).getSummaryNode(),
    nodeTo.(FlowSummaryNode).getSummaryNode(), true, model)
}

/**
 * Holds if `arg` is a `params` argument of `c`, for parameter `p`, and `arg` will
 * be wrapped in an collection by the C# compiler.
 */
private predicate isParamsArg(Call c, Expr arg, Parameter p) {
  exists(Callable target, int numArgs |
    target = c.getTarget() and
    p = target.getAParameter() and
    p.isParams() and
    numArgs = c.getNumberOfArguments() and
    arg = c.getArgumentForParameter(p)
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
private predicate fieldOrPropertyStore(Expr e, ContentSet c, Expr src, Expr q, boolean postUpdate) {
  exists(FieldOrProperty f |
    c = f.getContentSet() and
    (
      f.isFieldLike() and
      f instanceof InstanceFieldOrProperty
      or
      exists(
        FlowSummaryImpl::Private::SummarizedCallableImpl sc,
        FlowSummaryImpl::Private::SummaryComponentStack input, ContentSet readSet
      |
        sc.propagatesFlow(input, _, _, _) and
        input.contains(FlowSummaryImpl::Private::SummaryComponent::content(readSet)) and
        c.getAStoreContent() = readSet.getAReadContent()
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
  or
  // A write to a dynamic property
  exists(DynamicMemberAccess dma, AssignableDefinition def, DynamicProperty dp |
    def.getTargetAccess() = dma and
    dp.getAnAccess() = dma and
    c.isDynamicProperty(dp) and
    src = def.getSource() and
    q = dma.getQualifier() and
    e = def.getExpr() and
    postUpdate = true
  )
}

/**
 * Holds if `e2` is an expression that reads field or property `c` from
 * expression `e1`.
 */
private predicate fieldOrPropertyRead(Expr e1, ContentSet c, FieldOrPropertyRead e2) {
  e1 = e2.getQualifier() and
  c = e2.getTarget().(FieldOrProperty).getContentSet()
}

/**
 * Holds if `e2` is an expression that reads the dynamic property `c` from
 * expression `e1`.
 */
private predicate dynamicPropertyRead(Expr e1, ContentSet c, DynamicMemberRead e2) {
  exists(DynamicPropertyContent dpc |
    e1 = e2.getQualifier() and
    dpc.getAnAccess() = e2 and
    c.isDynamicProperty(dpc.getName())
  )
}

/**
 * Holds if `ce` is a collection expression that adds `src` to the collection `ce`.
 */
private predicate collectionStore(Expr src, CollectionExpression ce) {
  // Collection expression, `[1, src, 3]`
  src = ce.getAnElement() and
  not src instanceof SpreadElementExpr
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
  // Member initializer, `new C { Array = { [i] = src } }`
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

private class RelevantGvnType extends Gvn::GvnType {
  RelevantGvnType() { this = any(NodeImpl n).getDataFlowType().asGvnType() }
}

/** A GVN type that is either a `DataFlowType` or unifiable with a `DataFlowType`. */
private class DataFlowTypeOrUnifiable extends Gvn::GvnType {
  pragma[nomagic]
  DataFlowTypeOrUnifiable() {
    this instanceof RelevantGvnType or
    Gvn::unifiable(any(RelevantGvnType t), this)
  }
}

pragma[noinline]
private TypeParameter getATypeParameterSubType(DataFlowTypeOrUnifiable t) {
  not t instanceof Gvn::TypeParameterGvnType and
  exists(Type t0 | t = Gvn::getGlobalValueNumber(t0) | implicitConversionRestricted(result, t0))
}

pragma[noinline]
private TypeParameter getATypeParameterSubTypeRestricted(RelevantGvnType t) {
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
private Gvn::GvnType getANonTypeParameterSubTypeRestricted(RelevantGvnType t) {
  result = getANonTypeParameterSubType(t)
}

/** A callable with an implicit `this` parameter. */
private class InstanceCallable extends Callable {
  private Location l;

  InstanceCallable() {
    this = any(DataFlowCallable dfc).asCallable(l) and
    not this.(Modifiable).isStatic() and
    // local functions and delegate capture `this` and should therefore
    // not have a `this` parameter
    not this instanceof LocalFunction and
    not this instanceof AnonymousFunctionExpr
  }

  Location getARelevantLocation() { result = l }
}

/**
 * A callable which is either itself defined in source or which is the target
 * of some call in source, and therefore ought to have dataflow nodes created.
 *
 * Note that for library methods these are always unbound declarations, since
 * generic instantiations never have dataflow nodes constructed.
 */
private class CallableUsedInSource extends Callable {
  CallableUsedInSource() {
    // Should generate nodes even for abstract methods declared in source
    this.fromSource()
    or
    // Should generate nodes even for synthetic methods derived from source
    this.hasBody()
    or
    exists(Callable target |
      exists(Call c |
        // Note that getADynamicTarget does not always include getTarget.
        target = c.getTarget()
        or
        // Note that getARuntimeTarget cannot be used here, because the
        // DelegateLikeCall case depends on lambda-flow, which in turn
        // uses the dataflow library; hence this would introduce recursion
        // into the definition of data-flow nodes.
        exists(DispatchCall dc | c = dc.getCall() | target = dc.getADynamicTarget())
      )
      or
      target = any(CallableAccess ca).getTarget()
    |
      this = target.getUnboundDeclaration()
    )
  }
}

/**
 * A field or property which is either itself defined in source or which is the target
 * of some access in source, and therefore ought to have dataflow nodes created.
 */
private class FieldOrPropertyUsedInSource extends FieldOrProperty {
  FieldOrPropertyUsedInSource() {
    this.fromSource()
    or
    this.getAnAccess().fromSource()
  }
}

/** A collection of cached types and predicates to be evaluated in the same stage. */
cached
private module Cached {
  private import TaintTrackingPrivate as TaintTrackingPrivate

  // Add artificial dependencies to enforce all cached predicates are evaluated
  // in the "DataFlowImplCommon stage"
  cached
  predicate forceCaching() {
    TaintTrackingPrivate::forceCachingInSameStage() or
    exists(any(NodeImpl n).getTypeImpl()) or
    exists(any(NodeImpl n).getControlFlowNodeImpl()) or
    exists(any(NodeImpl n).getLocationImpl()) or
    exists(any(NodeImpl n).toStringImpl())
  }

  cached
  newtype TNode =
    TExprNode(ControlFlow::Nodes::ElementNode cfn) { cfn.getAstNode() instanceof Expr } or
    TSsaNode(SsaImpl::DataFlowIntegration::SsaNode node) or
    TAssignableDefinitionNode(AssignableDefinition def, ControlFlow::Node cfn) {
      cfn = def.getExpr().getAControlFlowNode()
    } or
    TExplicitParameterNode(Parameter p, DataFlowCallable c) {
      p = c.asCallable(_).(CallableUsedInSource).getAParameter()
    } or
    TInstanceParameterNode(InstanceCallable c, Location l) {
      c instanceof CallableUsedInSource and
      l = c.getARelevantLocation()
    } or
    TDelegateSelfReferenceNode(Callable c) { lambdaCreationExpr(_, c) } or
    TLocalFunctionCreationNode(ControlFlow::Nodes::ElementNode cfn, Boolean isPostUpdate) {
      cfn.getAstNode() instanceof LocalFunctionStmt
    } or
    TYieldReturnNode(ControlFlow::Nodes::ElementNode cfn) {
      any(Callable c).canYieldReturn(cfn.getAstNode())
    } or
    TAsyncReturnNode(ControlFlow::Nodes::ElementNode cfn) {
      any(Callable c | c.(Modifiable).isAsync()).canReturn(cfn.getAstNode())
    } or
    TMallocNode(ControlFlow::Nodes::ElementNode cfn) { cfn.getAstNode() instanceof ObjectCreation } or
    TObjectInitializerNode(ControlFlow::Nodes::ElementNode cfn) {
      cfn.getAstNode().(ObjectCreation).hasInitializer()
    } or
    TExprPostUpdateNode(ControlFlow::Nodes::ExprNode cfn) {
      cfn = LocalFlow::getAPostUpdateNodeForArg(_)
      or
      exists(Expr e | e = cfn.getExpr() |
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
          dynamicPropertyRead(e, _, read)
          or
          arrayRead(e, read)
        )
      )
      or
      lambdaCallExpr(_, cfn)
    } or
    TFlowSummaryNode(FlowSummaryImpl::Private::SummaryNode sn) {
      sn.getSummarizedCallable() instanceof CallableUsedInSource
    } or
    TParamsArgumentNode(ControlFlow::Node callCfn) {
      callCfn = any(Call c | isParamsArg(c, _, _)).getAControlFlowNode()
    } or
    TFlowInsensitiveFieldNode(FieldOrPropertyUsedInSource f) { f.isFieldLike() } or
    TFlowInsensitiveCapturedVariableNode(LocalScopeVariable v) { v.isCaptured() } or
    TInstanceParameterAccessNode(ControlFlow::Node cfn, Boolean isPostUpdate) {
      cfn = getAPrimaryConstructorParameterCfn(_)
    } or
    TPrimaryConstructorThisAccessNode(Parameter p, Boolean isPostUpdate, DataFlowCallable c) {
      p = c.asCallable(_).(PrimaryConstructor).getAParameter()
    } or
    TCaptureNode(VariableCapture::Flow::SynthesizedCaptureNode cn)

  /**
   * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
   * (intra-procedural) step.
   */
  cached
  predicate localFlowStepImpl(Node nodeFrom, Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    SsaFlow::localFlowStep(_, nodeFrom, nodeTo, _)
    or
    // Simple flow through library code is included in the exposed local
    // step relation, even though flow is technically inter-procedural
    FlowSummaryImpl::Private::Steps::summaryThroughStepValue(nodeFrom, nodeTo, _)
  }

  cached
  newtype TContent =
    TFieldContent(Field f) { f.isUnboundDeclaration() } or
    TPropertyContent(Property p) { p.isUnboundDeclaration() } or
    TDynamicPropertyContent(DynamicProperty dp) or
    TElementContent() or
    TSyntheticFieldContent(SyntheticField f) or
    TPrimaryConstructorParameterContent(Parameter p) {
      p.getCallable() instanceof PrimaryConstructor
    } or
    TCapturedVariableContent(VariableCapture::CapturedVariable v) or
    TDelegateCallArgumentContent(int i) {
      i = [0 .. max(any(DelegateLikeCall dc).getNumberOfArguments()) - 1]
    } or
    TDelegateCallReturnContent()

  cached
  newtype TContentSet =
    TSingletonContent(Content c) { not c instanceof PropertyContent } or
    TPropertyContentSet(Property p) { p.isUnboundDeclaration() } or
    TDynamicPropertyContentSet(DynamicProperty dp)

  cached
  newtype TContentApprox =
    TFieldApproxContent(string firstChar) { firstChar = approximateFieldContent(_) } or
    TPropertyApproxContent(string firstChar) { firstChar = approximatePropertyContent(_) } or
    TDynamicPropertyApproxContent(string firstChar) {
      firstChar = approximateDynamicPropertyContent(_)
    } or
    TElementApproxContent() or
    TSyntheticFieldApproxContent() or
    TPrimaryConstructorParameterApproxContent(string firstChar) {
      firstChar = approximatePrimaryConstructorParameterContent(_)
    } or
    TCapturedVariableContentApprox(VariableCapture::CapturedVariable v) or
    TDelegateCallArgumentApproxContent() or
    TDelegateCallReturnApproxContent()

  pragma[nomagic]
  private predicate commonSubTypeGeneral(DataFlowTypeOrUnifiable t1, RelevantGvnType t2) {
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
  predicate commonSubType(RelevantGvnType t1, RelevantGvnType t2) { commonSubTypeGeneral(t1, t2) }

  cached
  predicate commonSubTypeUnifiableLeft(RelevantGvnType t1, RelevantGvnType t2) {
    exists(Gvn::GvnType t |
      Gvn::unifiable(t1, t) and
      commonSubTypeGeneral(t, t2)
    )
  }

  cached
  newtype TDataFlowType =
    TGvnDataFlowType(Gvn::GvnType t) or
    TDelegateDataFlowType(Callable lambda) { lambdaCreationExpr(_, lambda) }
}

import Cached

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) {
  n instanceof SsaNode
  or
  exists(Parameter p | p = n.(ParameterNode).getParameter() | not p.fromSource())
  or
  n =
    TInstanceParameterNode(any(Callable c |
        not c.fromSource() or c instanceof FlowSummary::SummarizedCallable
      ), _)
  or
  n instanceof YieldReturnNode
  or
  n instanceof AsyncReturnNode
  or
  n instanceof MallocNode
  or
  n instanceof FlowSummaryNode
  or
  n instanceof ParamsArgumentNode
  or
  n.asExpr() = any(WithExpr we).getInitializer()
  or
  n instanceof FlowInsensitiveFieldNode
  or
  n instanceof InstanceParameterAccessNode
  or
  n instanceof PrimaryConstructorThisAccessNode
  or
  n = any(AssignableDefinitionNode def | not exists(def.getDefinition().getTargetAccess()))
  or
  n instanceof DelegateSelfReferenceNode
  or
  n instanceof CaptureNode
}

/** An SSA node. */
abstract class SsaNode extends NodeImpl, TSsaNode {
  SsaImpl::DataFlowIntegration::SsaNode node;
  SsaImpl::DefinitionExt def;

  SsaNode() {
    this = TSsaNode(node) and
    def = node.getDefinitionExt()
  }

  SsaImpl::DefinitionExt getDefinitionExt() { result = def }

  override DataFlowCallable getEnclosingCallableImpl() {
    result.getAControlFlowNode().getBasicBlock() = def.getBasicBlock()
  }

  override Type getTypeImpl() { result = def.getSourceVariable().getType() }

  override ControlFlow::Node getControlFlowNodeImpl() {
    result = def.(Ssa::Definition).getControlFlowNode()
  }

  override Location getLocationImpl() { result = node.getLocation() }

  override string toStringImpl() { result = node.toString() }
}

/** An (extended) SSA definition, viewed as a node in a data flow graph. */
class SsaDefinitionExtNode extends SsaNode {
  override SsaImpl::DataFlowIntegration::SsaDefinitionExtNode node;
}

/**
 * A node that represents an input to an SSA phi (read) definition.
 *
 * This allows for barrier guards to filter input to phi nodes. For example, in
 *
 * ```csharp
 * var x = taint;
 * if (x != "safe")
 * {
 *     x = "safe";
 * }
 * sink(x);
 * ```
 *
 * the `false` edge out of `x != "safe"` guards the input from `x = taint` into the
 * `phi` node after the condition.
 *
 * It is also relevant to filter input into phi read nodes:
 *
 * ```csharp
 * var x = taint;
 * if (b)
 * {
 *     if (x != "safe1")
 *     {
 *         return;
 *     }
 * } else {
 *     if (x != "safe2")
 *     {
 *         return;
 *     }
 * }
 *
 * sink(x);
 * ```
 *
 * both inputs into the phi read node after the outer condition are guarded.
 */
class SsaInputNode extends SsaNode {
  override SsaImpl::DataFlowIntegration::SsaInputNode node;
}

/** A definition, viewed as a node in a data flow graph. */
class AssignableDefinitionNodeImpl extends NodeImpl, TAssignableDefinitionNode {
  private AssignableDefinition def;
  private ControlFlow::Node cfn_;

  AssignableDefinitionNodeImpl() { this = TAssignableDefinitionNode(def, cfn_) }

  /** Gets the underlying definition. */
  AssignableDefinition getDefinition() { result = def }

  /** Gets the underlying definition, at control flow node `cfn`, if any. */
  AssignableDefinition getDefinitionAtNode(ControlFlow::Node cfn) {
    result = def and
    cfn = cfn_
  }

  override DataFlowCallable getEnclosingCallableImpl() { result.getAControlFlowNode() = cfn_ }

  override Type getTypeImpl() { result = def.getTarget().getType() }

  override ControlFlow::Node getControlFlowNodeImpl() { result = cfn_ }

  override Location getLocationImpl() {
    result = def.getTargetAccess().getLocation()
    or
    not exists(def.getTargetAccess()) and result = def.getLocation()
  }

  override string toStringImpl() {
    result = def.getTargetAccess().toString()
    or
    not exists(def.getTargetAccess()) and result = def.toString()
  }
}

abstract class ParameterNodeImpl extends NodeImpl {
  abstract predicate isParameterOf(DataFlowCallable c, ParameterPosition pos);
}

private module NearestLocationInputParamAfterCallable implements NearestLocationInputSig {
  class C = Parameter;

  predicate relevantLocations(Parameter p, Location l1, Location l2) {
    exists(DataFlowCallable c |
      c.asCallable(l1).getParameter(_) = p and
      l2 = [p.getLocation(), getASourceLocation(p)]
    )
  }
}

private module ParameterNodes {
  pragma[nomagic]
  private predicate ssaParamDef(Ssa::ImplicitParameterDefinition ssaDef, Parameter p, Location l) {
    p = ssaDef.getParameter() and
    l = ssaDef.getLocation()
  }

  private module NearestLocationInputParamBeforeCallable implements NearestLocationInputSig {
    class C = Parameter;

    predicate relevantLocations(Parameter p, Location l1, Location l2) {
      exists(DataFlowCallable c |
        c.asCallable(l2).getParameter(_) = p and
        l1 = [p.getLocation(), getASourceLocation(p)]
      )
    }
  }

  /**
   * The value of an explicit parameter at function entry, viewed as a node in a data
   * flow graph.
   */
  class ExplicitParameterNode extends ParameterNodeImpl, TExplicitParameterNode {
    private Parameter parameter;
    private DataFlowCallable callable;

    ExplicitParameterNode() { this = TExplicitParameterNode(parameter, callable) }

    Parameter getParameter() { result = parameter }

    pragma[nomagic]
    private Location getNearestParameterLocation() {
      exists(Location cloc | exists(callable.asCallable(cloc)) |
        // typical scenario: parameter is syntactically after the callable
        NearestLocation<NearestLocationInputParamAfterCallable>::nearestLocation(parameter, cloc,
          result)
        or
        // atypical scenario: parameter is syntactically before the callable, for example
        // `int this[int x] { get => x }`, where the parameter `x` is syntactically
        // before the the callable `get_Item`
        NearestLocation<NearestLocationInputParamBeforeCallable>::nearestLocation(parameter, result,
          cloc)
      )
    }

    pragma[nomagic]
    private Location getParameterLocation(Parameter p) {
      p = parameter and
      (
        result = this.getNearestParameterLocation()
        or
        not exists(this.getNearestParameterLocation()) and
        result = parameter.getLocation()
      )
    }

    /** Gets the SSA definition corresponding to this parameter, if any. */
    Ssa::ImplicitParameterDefinition getSsaDefinition() {
      exists(Parameter p, Location l |
        l = this.getParameterLocation(p) and
        ssaParamDef(result, p, l)
      )
    }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      c = callable and
      c.asCallable(_).getParameter(pos.getPosition()) = parameter
    }

    override DataFlowCallable getEnclosingCallableImpl() { this.isParameterOf(result, _) }

    override Type getTypeImpl() { result = parameter.getType() }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = this.getParameterLocation(_) }

    override string toStringImpl() { result = parameter.toString() }
  }

  /** An implicit instance (`this`) parameter. */
  class InstanceParameterNode extends ParameterNodeImpl, TInstanceParameterNode {
    private Callable callable;
    private Location location;

    InstanceParameterNode() { this = TInstanceParameterNode(callable, location) }

    /** Gets the callable containing this implicit instance parameter. */
    Callable getCallable(Location loc) { result = callable and location = loc }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      callable = c.asCallable(location) and pos.isThisParameter()
    }

    override DataFlowCallable getEnclosingCallableImpl() { result.asCallable(location) = callable }

    override Type getTypeImpl() { result = callable.getDeclaringType() }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = location }

    override string toStringImpl() { result = "this" }
  }

  /**
   * The value of a delegate itself at function entry, viewed as a node in a data
   * flow graph.
   *
   * This is used for improving lambda dispatch, and will eventually also be
   * used for tracking flow through captured variables.
   */
  class DelegateSelfReferenceNode extends ParameterNodeImpl, TDelegateSelfReferenceNode {
    private Callable callable;

    DelegateSelfReferenceNode() { this = TDelegateSelfReferenceNode(callable) }

    final Callable getCallable() { result = callable }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      callable = c.asCallable(_) and pos.isDelegateSelf()
    }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override DataFlowCallable getEnclosingCallableImpl() { result.asCallable(_) = callable }

    override Location getLocationImpl() { result = callable.getLocation() }

    override Type getTypeImpl() { none() }

    override DataFlowType getDataFlowType() { callable = result.asDelegate() }

    override string toStringImpl() { result = "delegate self in " + callable }
  }

  /** An implicit entry definition for a captured variable. */
  class SsaCapturedEntryDefinition extends Ssa::ImplicitEntryDefinition {
    private LocalScopeVariable v;

    SsaCapturedEntryDefinition() { this.getSourceVariable().getAssignable() = v }

    LocalScopeVariable getVariable() { result = v }
  }

  /** A parameter for a library callable with a flow summary. */
  class SummaryParameterNode extends ParameterNodeImpl, FlowSummaryNode {
    private ParameterPosition pos_;

    SummaryParameterNode() {
      FlowSummaryImpl::Private::summaryParameterNode(this.getSummaryNode(), pos_)
    }

    override predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
      this.getSummarizedCallable() = c.asSummarizedCallable() and pos = pos_
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
      isSuccessor = true and
      if e2 instanceof PropertyWrite
      then
        exists(AssignableDefinition def |
          def.getTargetAccess() = e2 and
          scope = def.getExpr()
        )
      else scope = e2
    }
  }

  /** A data-flow node that represents an explicit call argument. */
  class ExplicitArgumentNode extends ArgumentNodeImpl {
    ExplicitArgumentNode() { this.asExpr() instanceof Argument }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      exists(ArgumentConfiguration x, Expr c, Argument arg |
        arg = this.asExpr() and
        c = call.getExpr() and
        arg.isArgumentOf(c, pos) and
        x.hasExprPath(_, this.getControlFlowNode(), _, call.getControlFlowNode())
      )
    }
  }

  /** A data-flow node that represents a delegate passed into itself. */
  class DelegateSelfArgumentNode extends ArgumentNodeImpl, ExprNode {
    private DataFlowCall call_;

    DelegateSelfArgumentNode() { lambdaCallExpr(call_, this.getControlFlowNode()) }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      call = call_ and
      pos.isDelegateSelf()
    }
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

    override DataFlowCallable getEnclosingCallableImpl() {
      result.getAControlFlowNode() = cfn
      or
      result = getEnclosingStaticFieldOrProperty(cfn.getAstNode())
    }

    override Type getTypeImpl() { result = cfn.getAstNode().(Expr).getType() }

    override Location getLocationImpl() { result = cfn.getLocation() }

    override string toStringImpl() { result = "malloc" }
  }

  /**
   * A data-flow node that represents the implicit collection creation in a call to a
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

    override DataFlowCallable getEnclosingCallableImpl() {
      result.getAControlFlowNode() = callCfn
      or
      result = getEnclosingStaticFieldOrProperty(callCfn.getAstNode())
    }

    override Type getTypeImpl() { result = this.getParameter().getType() }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = callCfn.getLocation() }

    override string toStringImpl() { result = "[implicit collection creation] " + callCfn }
  }

  private class SummaryArgumentNode extends FlowSummaryNode, ArgumentNodeImpl {
    private SummaryCall call_;
    private ArgumentPosition pos_;

    SummaryArgumentNode() {
      FlowSummaryImpl::Private::summaryArgumentNode(call_.getReceiver(), this.getSummaryNode(), pos_)
    }

    override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
      call = call_ and pos = pos_
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
      exists(Callable c, Expr e | e = this.getExpr() |
        c.canReturn(e) and not c.(Modifiable).isAsync()
      )
    }

    override NormalReturnKind getKind() { exists(result) }
  }

  /**
   * A data-flow node that represents an assignment to an `out` or a `ref`
   * parameter.
   */
  class OutRefReturnNode extends ReturnNode, SsaDefinitionExtNode {
    OutRefReturnKind kind;

    OutRefReturnNode() {
      exists(Parameter p |
        this.getDefinitionExt().(Ssa::Definition).isLiveOutRefParameterDefinition(p) and
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

    override DataFlowCallable getEnclosingCallableImpl() { result.getAControlFlowNode() = cfn }

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

    AsyncReturnNode() { this = TAsyncReturnNode(cfn) and expr = cfn.getAstNode() }

    Expr getExpr() { result = expr }

    override NormalReturnKind getKind() { any() }

    override DataFlowCallable getEnclosingCallableImpl() { result.getAControlFlowNode() = cfn }

    override Type getTypeImpl() { result = expr.getEnclosingCallable().getReturnType() }

    override ControlFlow::Node getControlFlowNodeImpl() { result = cfn }

    override Location getLocationImpl() { result = expr.getLocation() }

    override string toStringImpl() { result = expr.toString() }
  }

  private class SummaryReturnNode extends FlowSummaryNode, ReturnNode {
    private ReturnKind rk;

    SummaryReturnNode() {
      FlowSummaryImpl::Private::summaryReturnNode(this.getSummaryNode(), rk)
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
private predicate summaryPostUpdateNodeIsOutOrRef(FlowSummaryNode n, Parameter p) {
  exists(SummaryParameterNode pn, DataFlowCallable c, ParameterPosition pos |
    FlowSummaryImpl::Private::summaryPostUpdateNode(n.getSummaryNode(), pn.getSummaryNode()) and
    pn.isParameterOf(c, pos) and
    p = c.asSummarizedCallable().getParameter(pos.getPosition()) and
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
   * A data-flow node that reads a value returned directly by a callable.
   */
  class ExprOutNode extends OutNode, ExprNode {
    private DataFlowCall call;

    ExprOutNode() {
      exists(Expr e | e = this.getExpr() | call = csharpCall(e, this.getControlFlowNode()))
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

  private class SummaryOutNode extends FlowSummaryNode, OutNode {
    private SummaryCall call;
    private ReturnKind kind_;

    SummaryOutNode() {
      FlowSummaryImpl::Private::summaryOutNode(call.getReceiver(), this.getSummaryNode(), kind_)
    }

    override DataFlowCall getCall(ReturnKind kind) { result = call and kind = kind_ }
  }
}

import OutNodes

/** A data-flow node used to model flow summaries. */
class FlowSummaryNode extends NodeImpl, TFlowSummaryNode {
  FlowSummaryImpl::Private::SummaryNode getSummaryNode() { this = TFlowSummaryNode(result) }

  FlowSummary::SummarizedCallable getSummarizedCallable() {
    result = this.getSummaryNode().getSummarizedCallable()
  }

  override DataFlowCallable getEnclosingCallableImpl() {
    result.asSummarizedCallable() = this.getSummarizedCallable()
  }

  override DataFlowType getDataFlowType() {
    result = FlowSummaryImpl::Private::summaryNodeType(this.getSummaryNode())
  }

  override Type getTypeImpl() { none() }

  override ControlFlow::Node getControlFlowNodeImpl() { none() }

  override Location getLocationImpl() { result = this.getSummarizedCallable().getLocation() }

  override string toStringImpl() { result = this.getSummaryNode().toString() }
}

/**
 * A data-flow node used to model reading and writing of primary constructor parameters.
 * For example, in
 * ```csharp
 * public class C(object o)
 * {
 *    public object GetParam() => o; // (1)
 *
 *    public void SetParam(object value) => o = value; // (2)
 * }
 * ```
 * the first access to `o` (1) is modeled as `this.o_backing_field` and
 * the second access to `o` (2) is modeled as `this.o_backing_field = value`.
 * Both models need a pre-update this node, and the latter need an additional post-update this access,
 * all of which are represented by an `InstanceParameterAccessNode` node.
 */
abstract private class InstanceParameterAccessNode extends NodeImpl, TInstanceParameterAccessNode {
  ControlFlow::Node cfn;
  boolean isPostUpdate;
  Parameter p;

  InstanceParameterAccessNode() {
    this = TInstanceParameterAccessNode(cfn, isPostUpdate) and
    exists(ParameterAccess pa | cfn = getAPrimaryConstructorParameterCfn(pa) and pa.getTarget() = p)
  }

  override DataFlowCallable getEnclosingCallableImpl() { result.getAControlFlowNode() = cfn }

  override Type getTypeImpl() { result = cfn.getEnclosingCallable().getDeclaringType() }

  override ControlFlow::Nodes::ElementNode getControlFlowNodeImpl() { none() }

  override Location getLocationImpl() { result = cfn.getLocation() }

  /**
   * Gets the underlying control flow node.
   */
  ControlFlow::Node getUnderlyingControlFlowNode() { result = cfn }

  /**
   * Gets the primary constructor parameter that this is a this access to.
   */
  Parameter getParameter() { result = p }
}

private class InstanceParameterAccessPreNode extends InstanceParameterAccessNode {
  InstanceParameterAccessPreNode() { isPostUpdate = false }

  override string toStringImpl() { result = "this" }
}

/**
 * A data-flow node used to synthesize the body of a primary constructor.
 *
 * For example, in
 * ```csharp
 * public class C(object o) { }
 * ```
 * we synthesize the primary constructor for `C` as
 * ```csharp
 * public C(object o) => this.o_backing_field = o;
 * ```
 * The synthesized (pre/post-update) this access is represented an `PrimaryConstructorThisAccessNode` node.
 */
abstract private class PrimaryConstructorThisAccessNode extends NodeImpl,
  TPrimaryConstructorThisAccessNode
{
  Parameter p;
  boolean isPostUpdate;
  DataFlowCallable callable;

  PrimaryConstructorThisAccessNode() {
    this = TPrimaryConstructorThisAccessNode(p, isPostUpdate, callable)
  }

  override DataFlowCallable getEnclosingCallableImpl() { result = callable }

  override Type getTypeImpl() { result = p.getCallable().getDeclaringType() }

  override ControlFlow::Nodes::ElementNode getControlFlowNodeImpl() { none() }

  override Location getLocationImpl() {
    NearestLocation<NearestLocationInputParamAfterCallable>::nearestLocation(p,
      pragma[only_bind_out](callable).getLocation(), result)
  }

  override string toStringImpl() { result = "this" }

  /**
   * Gets the primary constructor parameter that this is a this access to.
   */
  Parameter getParameter() { result = p }

  /**
   * Holds if this is a this access for a primary constructor parameter write.
   */
  predicate isPostUpdate() { isPostUpdate = true }
}

private class PrimaryConstructorThisAccessPreNode extends PrimaryConstructorThisAccessNode {
  PrimaryConstructorThisAccessPreNode() { isPostUpdate = false }

  override string toStringImpl() { result = "this" }
}

/**
 * A synthesized data flow node representing a closure object that tracks
 * captured variables.
 */
class CaptureNode extends NodeImpl, TCaptureNode {
  VariableCapture::Flow::SynthesizedCaptureNode cn;

  CaptureNode() { this = TCaptureNode(cn) }

  VariableCapture::Flow::SynthesizedCaptureNode getSynthesizedCaptureNode() { result = cn }

  override DataFlowCallable getEnclosingCallableImpl() {
    result.getAControlFlowNode().getBasicBlock() = cn.getBasicBlock()
  }

  override Type getTypeImpl() {
    exists(VariableCapture::CapturedVariable v | cn.isVariableAccess(v) and result = v.getType())
  }

  override DataFlowType getDataFlowType() {
    if cn.isInstanceAccess()
    then result.asDelegate() = cn.getEnclosingCallable()
    else result = super.getDataFlowType()
  }

  override ControlFlow::Node getControlFlowNodeImpl() { none() }

  override Location getLocationImpl() { result = cn.getLocation() }

  override string toStringImpl() { result = cn.toString() }
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
          p.isAutoImplementedReadOnly()
          or
          p.getDeclaringType() instanceof AnonymousClass
        )
        or
        p.fromLibrary()
      )
  }

  /** Gets the content that matches this field or property. */
  ContentSet getContentSet() {
    result.isField(this.getUnboundDeclaration())
    or
    result.isProperty(this.getUnboundDeclaration())
  }
}

/** A string that is a reference to a late-bound target of a dynamic member access. */
class DynamicProperty extends string {
  private DynamicMemberAccess dma;

  DynamicProperty() { this = dma.getLateBoundTargetName() }

  ContentSet getContentSet() { result.isDynamicProperty(this) }

  /** Gets an access of this dynamic property. */
  DynamicMemberAccess getAnAccess() { result = dma }
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
 * A data flow node used for control-flow insensitive flow through fields
 * and properties.
 *
 * In global data flow this is used to model flow through static fields and
 * properties, while for lambda flow we additionally use it to track assignments
 * in constructors to uses within the same class.
 */
class FlowInsensitiveFieldNode extends NodeImpl, TFlowInsensitiveFieldNode {
  private FieldOrProperty f;

  FlowInsensitiveFieldNode() { this = TFlowInsensitiveFieldNode(f) }

  override DataFlowCallable getEnclosingCallableImpl() { result.asFieldOrProperty() = f }

  override Type getTypeImpl() { result = f.getType() }

  override ControlFlow::Node getControlFlowNodeImpl() { none() }

  override Location getLocationImpl() { result = f.getLocation() }

  override string toStringImpl() { result = "[flow-insensitive] " + f }
}

/**
 * A data flow node used for control-flow insensitive flow through captured
 * variables.
 *
 * Only used in lambda flow.
 */
class FlowInsensitiveCapturedVariableNode extends NodeImpl, TFlowInsensitiveCapturedVariableNode {
  private LocalScopeVariable v;

  FlowInsensitiveCapturedVariableNode() { this = TFlowInsensitiveCapturedVariableNode(v) }

  LocalScopeVariable getVariable() { result = v }

  override DataFlowCallable getEnclosingCallableImpl() { result.asCapturedVariable() = v }

  override Type getTypeImpl() { result = v.getType() }

  override ControlFlow::Node getControlFlowNodeImpl() { none() }

  override Location getLocationImpl() { result = v.getLocation() }

  override string toStringImpl() { result = "[flow-insensitive] " + v }
}

/**
 * Holds if `pred` can flow to `succ`, by jumping from one callable to
 * another. Additional steps specified by the configuration are *not*
 * taken into account.
 */
predicate jumpStep(Node pred, Node succ) {
  pred.(NonLocalJumpNode).getAJumpSuccessor(true) = succ
  or
  exists(FieldOrProperty f | f.isStatic() |
    f.getAnAssignedValue() = pred.asExpr() and
    succ = TFlowInsensitiveFieldNode(f)
    or
    exists(FieldOrPropertyRead fr | f.getAnAccess() = fr |
      fr = pred.(PostUpdateNode).getPreUpdateNode().asExpr() and
      succ = TFlowInsensitiveFieldNode(f)
      or
      pred = TFlowInsensitiveFieldNode(f) and
      fr = succ.asExpr() and
      fr.hasNonlocalValue()
    )
  )
  or
  FlowSummaryImpl::Private::Steps::summaryJumpStep(pred.(FlowSummaryNode).getSummaryNode(),
    succ.(FlowSummaryNode).getSummaryNode())
  or
  succ = pred.(LocalFunctionCreationNode).getAnAccess(false)
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
    collectionStore(e1, e2) and
    scope = e2
    or
    exactScope = false and
    isSuccessor = true and
    isParamsArg(e2, e1, _) and
    scope = e2
  }
}

pragma[nomagic]
private ContentSet getResultContent() {
  result.isProperty(any(SystemThreadingTasksTaskTClass c_).getResultProperty())
}

private predicate primaryConstructorParameterStore(
  AssignableDefinitionNode node1, PrimaryConstructorParameterContent c, Node node2
) {
  exists(AssignableDefinition def, ControlFlow::Node cfn, Parameter p |
    node1 = TAssignableDefinitionNode(def, cfn) and
    p = def.getTarget() and
    node2 = TInstanceParameterAccessNode(cfn, true) and
    c.getParameter() = p
  )
}

pragma[nomagic]
private predicate recordParameter(RecordType t, Parameter p, string name) {
  p.getName() = name and p.getCallable().getDeclaringType() = t
}

private predicate storeContentStep(Node node1, Content c, Node node2) {
  exists(StoreStepConfiguration x, ExprNode node, boolean postUpdate |
    hasNodePath(x, node1, node) and
    if postUpdate = true then node = node2.(PostUpdateNode).getPreUpdateNode() else node = node2
  |
    arrayStore(_, node1.asExpr(), node.getExpr(), postUpdate) and c instanceof ElementContent
  )
  or
  exists(StoreStepConfiguration x | hasNodePath(x, node1, node2) |
    collectionStore(node1.asExpr(), node2.asExpr()) and c instanceof ElementContent
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
  primaryConstructorParameterStore(node1, c, node2)
  or
  exists(Parameter p, DataFlowCallable callable |
    node1 = TExplicitParameterNode(p, callable) and
    node2 = TPrimaryConstructorThisAccessNode(p, true, callable) and
    not recordParameter(_, p, _) and
    c.(PrimaryConstructorParameterContent).getParameter() = p
  )
  or
  VariableCapture::storeStep(node1, c, node2)
}

pragma[nomagic]
private predicate recordProperty(RecordType t, ContentSet c, string name) {
  exists(Property p |
    c.isProperty(p) and
    p.getName() = name and
    p.getDeclaringType() = t
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to
 * the content set `c` of a delegate call.
 *
 * If there is a delegate call f(x), then we store "x" on "f"
 * using a delegate argument content set.
 */
private predicate storeStepDelegateCall(ExplicitArgumentNode node1, ContentSet c, Node node2) {
  exists(ExplicitDelegateLikeDataFlowCall call, int i |
    node1.argumentOf(call, TPositionalArgumentPosition(i)) and
    lambdaCall(call, _, node2.(PostUpdateNode).getPreUpdateNode()) and
    c.isDelegateCallArgument(i)
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to
 * content `c`.
 */
predicate storeStep(Node node1, ContentSet c, Node node2) {
  exists(Content cont |
    storeContentStep(node1, cont, node2) and
    c.isSingleton(cont)
  )
  or
  exists(StoreStepConfiguration x, ExprNode node, boolean postUpdate |
    hasNodePath(x, node1, node) and
    if postUpdate = true then node = node2.(PostUpdateNode).getPreUpdateNode() else node = node2
  |
    fieldOrPropertyStore(_, c, node1.asExpr(), node.getExpr(), postUpdate)
  )
  or
  exists(Expr e |
    e = node1.asExpr() and
    node2.(AsyncReturnNode).getExpr() = e and
    c = getResultContent()
  )
  or
  exists(Parameter p, DataFlowCallable callable, RecordType t, string name |
    node1 = TExplicitParameterNode(p, callable) and
    node2 = TPrimaryConstructorThisAccessNode(p, true, callable) and
    recordParameter(t, p, name) and
    recordProperty(t, c, name)
  )
  or
  FlowSummaryImpl::Private::Steps::summaryStoreStep(node1.(FlowSummaryNode).getSummaryNode(), c,
    node2.(FlowSummaryNode).getSummaryNode())
  or
  storeStepDelegateCall(node1, c, node2)
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
    dynamicPropertyRead(e1, _, e2) and
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

private predicate readContentStep(Node node1, Content c, Node node2) {
  exists(ReadStepConfiguration x |
    hasNodePath(x, node1, node2) and
    arrayRead(node1.asExpr(), node2.asExpr()) and
    c instanceof ElementContent
    or
    exists(ForeachStmt fs, Ssa::ExplicitDefinition def |
      x.hasDefPath(fs.getIterableExpr(), node1.getControlFlowNode(), def.getADefinition(),
        def.getControlFlowNode()) and
      node2.(SsaDefinitionExtNode).getDefinitionExt() = def and
      c instanceof ElementContent
    )
    or
    node1 =
      any(InstanceParameterAccessPreNode n |
        n.getUnderlyingControlFlowNode() = node2.(ExprNode).getControlFlowNode() and
        n.getParameter() = c.(PrimaryConstructorParameterContent).getParameter()
      ) and
    node2.asExpr() instanceof ParameterRead
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
      exists(AssignableDefinitions::TupleAssignmentDefinition tad |
        node2.(AssignableDefinitionNode).getDefinition() = tad and
        tad.getLeaf() = item and
        hasNodePath(x, node1, node2)
      )
      or
      // item = variable in node1 = (..., variable, ...) in a case/is var (..., ...)
      te = any(PatternExpr pe).getAChildExpr*() and
      exists(AssignableDefinitions::LocalVariableDefinition lvd |
        node2.(AssignableDefinitionNode).getDefinition() = lvd and
        lvd.getDeclaration() = item and
        hasNodePath(x, node1, node2)
      )
    )
  )
  or
  VariableCapture::readStep(node1, c, node2)
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to
 * the content set `c` of a delegate call.
 *
 * If there is a delegate call f(x), then we read the return of the delegate
 * call.
 */
private predicate readStepDelegateCall(Node node1, ContentSet c, OutNode node2) {
  exists(ExplicitDelegateLikeDataFlowCall call |
    lambdaCall(call, _, node1) and
    node2.getCall(TNormalReturnKind()) = call and
    c.isDelegateCallReturn()
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of content `c`.
 */
predicate readStep(Node node1, ContentSet c, Node node2) {
  exists(Content cont |
    readContentStep(node1, cont, node2) and
    c.isSingleton(cont)
  )
  or
  exists(ReadStepConfiguration x | hasNodePath(x, node1, node2) |
    fieldOrPropertyRead(node1.asExpr(), c, node2.asExpr())
    or
    dynamicPropertyRead(node1.asExpr(), c, node2.asExpr())
    or
    node2.asExpr().(AwaitExpr).getExpr() = node1.asExpr() and
    c = getResultContent()
  )
  or
  FlowSummaryImpl::Private::Steps::summaryReadStep(node1.(FlowSummaryNode).getSummaryNode(), c,
    node2.(FlowSummaryNode).getSummaryNode())
  or
  readStepDelegateCall(node1, c, node2)
}

private predicate clearsCont(Node n, Content c) {
  exists(Argument a, Struct s, Field f |
    a = n.(PostUpdateNode).getPreUpdateNode().asExpr() and
    a.getType() = s and
    f = s.getAField() and
    c.(FieldContent).getField() = f.getUnboundDeclaration() and
    not f.isRef()
  )
  or
  n = any(PostUpdateNode n1 | primaryConstructorParameterStore(_, c, n1)).getPreUpdateNode()
  or
  VariableCapture::clearsContent(n, c)
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
predicate clearsContent(Node n, ContentSet c) {
  exists(Content cont |
    clearsCont(n, cont) and
    c.isSingleton(cont)
  )
  or
  fieldOrPropertyStore(_, c, _, n.asExpr(), true)
  or
  fieldOrPropertyStore(_, c, _, n.(ObjectInitializerNode).getInitializer(), false)
  or
  FlowSummaryImpl::Private::Steps::summaryClearsContent(n.(FlowSummaryNode).getSummaryNode(), c)
  or
  exists(WithExpr we, ObjectInitializer oi, FieldOrProperty f |
    oi = we.getInitializer() and
    n.asExpr() = oi and
    f = oi.getAMemberInitializer().getInitializedMember() and
    c = f.getContentSet()
  )
}

/**
 * Holds if the value that is being tracked is expected to be stored inside content `c`
 * at node `n`.
 */
predicate expectsContent(Node n, ContentSet c) {
  FlowSummaryImpl::Private::Steps::summaryExpectsContent(n.(FlowSummaryNode).getSummaryNode(), c)
  or
  n.asExpr() instanceof SpreadElementExpr and c.isElement()
}

class NodeRegion instanceof ControlFlow::BasicBlock {
  string toString() { result = "NodeRegion" }

  predicate contains(Node n) { this = n.getControlFlowNode().getBasicBlock() }
}

/**
 * Holds if the nodes in `nr` are unreachable when the call context is `call`.
 */
predicate isUnreachableInCall(NodeRegion nr, DataFlowCall call) {
  exists(
    ExplicitParameterNode paramNode, Guard guard, ControlFlow::SuccessorTypes::BooleanSuccessor bs
  |
    viableConstantBooleanParamArg(paramNode, bs.getValue().booleanNot(), call) and
    paramNode.getSsaDefinition().getARead() = guard and
    guard.controlsBlock(nr, bs, _)
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
 *
 * For delegates, we use the delegate itself instead of its type, in order to
 * improve dispatch.
 */
class DataFlowType extends TDataFlowType {
  Gvn::GvnType asGvnType() { this = TGvnDataFlowType(result) }

  Callable asDelegate() { this = TDelegateDataFlowType(result) }

  /**
   * Gets an expression that creates a delegate of this type.
   *
   * For methods used as method groups in calls there can be multiple
   * creations associated with the same type.
   */
  ControlFlowElement getADelegateCreation() {
    exists(Callable callable | this = TDelegateDataFlowType(callable) |
      lambdaCreationExpr(result, callable)
      or
      isLocalFunctionCallReceiver(_, result, callable)
    )
  }

  final string toString() {
    result = this.asGvnType().toString()
    or
    result = this.asDelegate().toString()
  }
}

/** Gets the type of `n` used for type pruning. */
DataFlowType getNodeType(Node n) {
  result = n.(NodeImpl).getDataFlowType() and
  not lambdaCreation(n, _, _) and
  not isLocalFunctionCallReceiver(_, n.asExpr(), _)
  or
  [
    n.asExpr().(ControlFlowElement),
    n.(LocalFunctionCreationPreNode).getUnderlyingControlFlowNode().getAstNode()
  ] = result.getADelegateCreation()
}

private class DataFlowNullType extends Gvn::GvnType {
  DataFlowNullType() { this = Gvn::getGlobalValueNumber(any(NullType nt)) }

  pragma[noinline]
  predicate isConvertibleTo(Gvn::GvnType t) {
    defaultNullConversion(_, any(Type t0 | t = Gvn::getGlobalValueNumber(t0)))
  }
}

private class GvnUnknownType extends Gvn::GvnType {
  GvnUnknownType() { this = Gvn::getGlobalValueNumber(any(UnknownType ut)) }
}

pragma[nomagic]
private predicate uselessTypebound(DataFlowType dt) {
  dt.asGvnType() =
    any(Gvn::GvnType t |
      t instanceof GvnUnknownType or
      t instanceof Gvn::TypeParameterGvnType
    )
}

pragma[nomagic]
private predicate compatibleTypesDelegateLeft(DataFlowType dt1, DataFlowType dt2) {
  exists(Gvn::GvnType t1, Gvn::GvnType t2 |
    t1 = exprNode(dt1.getADelegateCreation()).(NodeImpl).getDataFlowType().asGvnType() and
    t2 = dt2.asGvnType()
  |
    commonSubType(t1, t2)
    or
    commonSubTypeUnifiableLeft(t1, t2)
    or
    commonSubTypeUnifiableLeft(t2, t1)
    or
    t2.(DataFlowNullType).isConvertibleTo(t1)
    or
    t2 instanceof Gvn::TypeParameterGvnType
    or
    t2 instanceof GvnUnknownType
  )
}

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
pragma[nomagic]
predicate compatibleTypes(DataFlowType dt1, DataFlowType dt2) {
  exists(Gvn::GvnType t1, Gvn::GvnType t2 |
    t1 = dt1.asGvnType() and
    t2 = dt2.asGvnType()
  |
    commonSubType(t1, t2)
    or
    commonSubTypeUnifiableLeft(t1, t2)
    or
    commonSubTypeUnifiableLeft(t2, t1)
    or
    t1.(DataFlowNullType).isConvertibleTo(t2)
    or
    t2.(DataFlowNullType).isConvertibleTo(t1)
  )
  or
  exists(dt1.asGvnType()) and uselessTypebound(dt2)
  or
  uselessTypebound(dt1) and exists(dt2.asGvnType())
  or
  compatibleTypesDelegateLeft(dt1, dt2)
  or
  compatibleTypesDelegateLeft(dt2, dt1)
  or
  dt1.asDelegate() = dt2.asDelegate()
}

pragma[nomagic]
predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) {
  t1 != t2 and
  t1.asGvnType() = getANonTypeParameterSubTypeRestricted(t2.asGvnType())
  or
  t1.asGvnType() instanceof RelevantGvnType and
  not uselessTypebound(t1) and
  uselessTypebound(t2)
  or
  compatibleTypesDelegateLeft(t1, t2)
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

module PostUpdateNodes {
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
    TObjectInitializerNode
  {
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

    override DataFlowCallable getEnclosingCallableImpl() {
      result.getAControlFlowNode() = cfn
      or
      result = getEnclosingStaticFieldOrProperty(oc)
    }

    override Type getTypeImpl() { result = oc.getType() }

    override ControlFlow::Nodes::ElementNode getControlFlowNodeImpl() { result = cfn }

    override Location getLocationImpl() { result = cfn.getLocation() }

    override string toStringImpl() { result = "[pre-initializer] " + cfn }
  }

  class ExprPostUpdateNode extends PostUpdateNode, NodeImpl, TExprPostUpdateNode {
    private ControlFlow::Nodes::ElementNode cfn;

    ExprPostUpdateNode() { this = TExprPostUpdateNode(cfn) }

    override ExprNode getPreUpdateNode() {
      // For compound arguments, such as `m(b ? x : y)`, we want the leaf nodes
      // `[post] x` and `[post] y` to have two pre-update nodes: (1) the compound argument,
      // `if b then x else y`; and the (2) the underlying expressions; `x` and `y`,
      // respectively.
      //
      // This ensures that we get flow out of the call into both leafs (1), while still
      // maintaining the invariant that the underlying expression is a pre-update node (2).
      cfn = LocalFlow::getAPostUpdateNodeForArg(result.getControlFlowNode())
      or
      cfn = result.getControlFlowNode()
    }

    override DataFlowCallable getEnclosingCallableImpl() {
      result.getAControlFlowNode() = cfn
      or
      result = getEnclosingStaticFieldOrProperty(cfn.getAstNode())
    }

    override Type getTypeImpl() { result = cfn.getAstNode().(Expr).getType() }

    override ControlFlow::Node getControlFlowNodeImpl() { none() }

    override Location getLocationImpl() { result = cfn.getLocation() }

    override string toStringImpl() { result = "[post] " + cfn.toString() }
  }

  private class SummaryPostUpdateNode extends FlowSummaryNode, PostUpdateNode {
    private FlowSummaryImpl::Private::SummaryNode preUpdateNode;

    SummaryPostUpdateNode() {
      FlowSummaryImpl::Private::summaryPostUpdateNode(this.getSummaryNode(), preUpdateNode) and
      not summaryPostUpdateNodeIsOutOrRef(this, _)
    }

    override Node getPreUpdateNode() { result.(FlowSummaryNode).getSummaryNode() = preUpdateNode }
  }

  private class InstanceParameterAccessPostUpdateNode extends PostUpdateNode,
    InstanceParameterAccessNode
  {
    InstanceParameterAccessPostUpdateNode() { isPostUpdate = true }

    override InstanceParameterAccessPreNode getPreUpdateNode() {
      result = TInstanceParameterAccessNode(cfn, false)
    }

    override string toStringImpl() { result = "[post] this" }
  }

  private class PrimaryConstructorThisAccessPostUpdateNode extends PostUpdateNode,
    PrimaryConstructorThisAccessNode
  {
    PrimaryConstructorThisAccessPostUpdateNode() { isPostUpdate = true }

    override PrimaryConstructorThisAccessPreNode getPreUpdateNode() {
      result = TPrimaryConstructorThisAccessNode(p, false, callable)
    }

    override string toStringImpl() { result = "[post] this" }
  }

  class LocalFunctionCreationPostUpdateNode extends LocalFunctionCreationNode, PostUpdateNode {
    LocalFunctionCreationPostUpdateNode() { isPostUpdate = true }

    override LocalFunctionCreationPreNode getPreUpdateNode() {
      result = TLocalFunctionCreationNode(cfn, false)
    }

    override string toStringImpl() { result = "[post] " + cfn }
  }

  private class CapturePostUpdateNode extends PostUpdateNode, CaptureNode {
    private CaptureNode pre;

    CapturePostUpdateNode() {
      VariableCapture::Flow::capturePostUpdateNode(this.getSynthesizedCaptureNode(),
        pre.getSynthesizedCaptureNode())
    }

    override CaptureNode getPreUpdateNode() { result = pre }

    override string toStringImpl() { result = "[post] " + cn }
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

class DataFlowExpr = Expr;

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

private predicate lambdaCreationExpr(ControlFlowElement creation, Callable c) {
  c =
    [
      creation.(AnonymousFunctionExpr),
      creation.(DelegateCreation).getArgument().(CallableAccess).getTarget().getUnboundDeclaration(),
      creation.(AddressOfExpr).getOperand().(CallableAccess).getTarget().getUnboundDeclaration(),
      creation.(LocalFunctionStmt).getLocalFunction()
    ]
}

class LambdaCallKind = Unit;

/** Holds if `creation` is an expression that creates a delegate for `c`. */
predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) {
  lambdaCreationExpr(creation.asExpr(), c.asCallable(_)) and
  exists(kind)
}

private predicate isLocalFunctionCallReceiver(
  LocalFunctionCall call, LocalFunctionAccess receiver, LocalFunction f
) {
  receiver.getParent() = call and
  f = receiver.getTarget().getUnboundDeclaration()
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
    or
    isLocalFunctionCallReceiver(e2, e1, _) and
    exactScope = false and
    scope = e2 and
    isSuccessor = true
  }
}

private predicate lambdaCallExpr(DataFlowCall call, ControlFlow::Node receiver) {
  exists(LambdaConfiguration x, DelegateLikeCall dc |
    x.hasExprPath(dc.getExpr(), receiver, dc, call.getControlFlowNode())
  )
  or
  // In local function calls, `F()`, we use the local function access `F`
  // to represent the receiver. Only needed for flow through captured variables.
  exists(LambdaConfiguration x, LocalFunctionCall fc |
    x.hasExprPath(fc.getAChild(), receiver, fc, call.getControlFlowNode())
  )
}

/** Holds if `call` is a lambda call where `receiver` is the lambda expression. */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) {
  (
    lambdaCallExpr(call, receiver.(ExprNode).getControlFlowNode()) and
    // local function calls can be resolved directly without a flow analysis
    not call.getControlFlowNode().getAstNode() instanceof LocalFunctionCall
    or
    receiver.(FlowSummaryNode).getSummaryNode() = call.(SummaryCall).getReceiver()
  ) and
  exists(kind)
}

private predicate delegateCreationStep(Node nodeFrom, Node nodeTo) {
  exists(LambdaConfiguration x, DelegateCreation dc |
    x.hasExprPath(dc.getArgument(), nodeFrom.(ExprNode).getControlFlowNode(), dc,
      nodeTo.(ExprNode).getControlFlowNode())
  )
}

/** Extra data-flow steps needed for lambda flow analysis. */
predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) {
  exists(SsaImpl::DefinitionExt def |
    SsaFlow::localFlowStep(def, nodeFrom, nodeTo, _) and
    preservesValue = true
  |
    LocalFlow::usesInstanceField(def)
    or
    def instanceof VariableCapture::CapturedSsaDefinitionExt
  )
  or
  delegateCreationStep(nodeFrom, nodeTo) and
  preservesValue = true
  or
  exists(AddEventExpr aee |
    nodeFrom.asExpr() = aee.getRValue() and
    nodeTo.asExpr().(EventRead).getTarget() = aee.getTarget() and
    preservesValue = false
  )
  or
  preservesValue = true and
  exists(FieldOrProperty f, FieldOrPropertyAccess fa |
    fa = f.getAnAccess() and
    fa.targetIsLocalInstance()
  |
    exists(AssignableDefinition def |
      def.getTargetAccess() = fa and
      nodeFrom.asExpr() = def.getSource() and
      nodeTo = TFlowInsensitiveFieldNode(f) and
      nodeFrom.getEnclosingCallable() instanceof Constructor
    )
    or
    nodeFrom = TFlowInsensitiveFieldNode(f) and
    f.getAnAccess() = fa and
    fa = nodeTo.asExpr() and
    fa.(FieldOrPropertyRead).hasNonlocalValue()
  )
  or
  VariableCapture::flowInsensitiveStep(nodeFrom, nodeTo) and
  preservesValue = true
}

predicate knownSourceModel(Node source, string model) { sourceNode(source, _, model) }

predicate knownSinkModel(Node sink, string model) { sinkNode(sink, _, model) }

class DataFlowSecondLevelScope = Unit;

/**
 * Holds if flow is allowed to pass from parameter `p` and back to itself as a
 * side-effect, resulting in a summary from `p` to itself.
 *
 * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
 * by default as a heuristic.
 */
predicate allowParameterReturnInSelf(ParameterNode p) {
  exists(DataFlowCallable c, ParameterPosition pos |
    parameterNode(p, c, pos) and
    FlowSummaryImpl::Private::summaryAllowParameterReturnInSelf(c.asSummarizedCallable(), pos)
  )
  or
  VariableCapture::Flow::heuristicAllowInstanceParameterReturnInSelf(p.(DelegateSelfReferenceNode)
        .getCallable())
}

/** An approximated `Content`. */
class ContentApprox extends TContentApprox {
  /** Gets a textual representation of this approximated `Content`. */
  string toString() {
    exists(string firstChar |
      this = TFieldApproxContent(firstChar) and result = "approximated field " + firstChar
    )
    or
    exists(string firstChar |
      this = TPropertyApproxContent(firstChar) and result = "approximated property " + firstChar
    )
    or
    exists(string firstChar |
      this = TDynamicPropertyApproxContent(firstChar) and
      result = "approximated dynamic property " + firstChar
    )
    or
    this = TElementApproxContent() and result = "element"
    or
    this = TSyntheticFieldApproxContent() and result = "approximated synthetic field"
    or
    exists(string firstChar |
      this = TPrimaryConstructorParameterApproxContent(firstChar) and
      result = "approximated parameter field " + firstChar
    )
    or
    exists(VariableCapture::CapturedVariable v |
      this = TCapturedVariableContentApprox(v) and result = "captured " + v
    )
    or
    this = TDelegateCallArgumentApproxContent() and
    result = "approximated delegate call argument"
    or
    this = TDelegateCallReturnApproxContent() and
    result = "approximated delegate call return"
  }
}

/** Gets a string for approximating the name of a field. */
private string approximateFieldContent(FieldContent fc) {
  result = fc.getField().getName().prefix(1)
}

/** Gets a string for approximating the name of a property. */
private string approximatePropertyContent(PropertyContent pc) {
  result = pc.getProperty().getName().prefix(1)
}

/** Gets a string for approximating the name of a dynamic property. */
private string approximateDynamicPropertyContent(DynamicPropertyContent dpc) {
  result = dpc.getName().prefix(1)
}

/**
 * Gets a string for approximating the name of a synthetic field corresponding
 * to a primary constructor parameter.
 */
private string approximatePrimaryConstructorParameterContent(PrimaryConstructorParameterContent pc) {
  result = pc.getParameter().getName().prefix(1)
}

/** Gets an approximated value for content `c`. */
pragma[nomagic]
ContentApprox getContentApprox(Content c) {
  result = TFieldApproxContent(approximateFieldContent(c))
  or
  result = TPropertyApproxContent(approximatePropertyContent(c))
  or
  result = TDynamicPropertyApproxContent(approximateDynamicPropertyContent(c))
  or
  c instanceof ElementContent and result = TElementApproxContent()
  or
  c instanceof SyntheticFieldContent and result = TSyntheticFieldApproxContent()
  or
  result =
    TPrimaryConstructorParameterApproxContent(approximatePrimaryConstructorParameterContent(c))
  or
  result = TCapturedVariableContentApprox(VariableCapture::getCapturedVariableContent(c))
  or
  c instanceof DelegateCallArgumentContent and
  result = TDelegateCallArgumentApproxContent()
  or
  c instanceof DelegateCallReturnContent and
  result = TDelegateCallReturnApproxContent()
}

/**
 * A module importing the modules that provide synthetic field declarations,
 * ensuring that they are visible to the taint tracking / data flow library.
 */
private module SyntheticFields {
  private import semmle.code.csharp.dataflow.internal.ExternalFlow
  private import semmle.code.csharp.frameworks.system.threading.Tasks
  private import semmle.code.csharp.frameworks.system.runtime.CompilerServices
}

/** A synthetic field. */
abstract class SyntheticField extends string {
  bindingset[this]
  SyntheticField() { any() }

  /** Gets the type of this synthetic field. */
  Type getType() { result instanceof ObjectType }
}
