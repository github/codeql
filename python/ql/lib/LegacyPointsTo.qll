/**
 * DEPRECATED: Using the methods in this module may lead to a degradation of performance. Use at
 * your own peril.
 *
 * This module contains legacy points-to predicates and methods for various classes in the
 * points-to analysis.
 *
 * Existing code that depends on, say, points-to predicates on `ControlFlowNode` should be modified
 * to use `ControlFlowNodeWithPointsTo` instead. In particular, if inside a method call chain such
 * as
 *
 * `someCallNode.getFunction().pointsTo(...)`
 *
 *  an explicit cast should be added as follows
 *
 * `someCallNode.getFunction().(ControlFlowNodeWithPointsTo).pointsTo(...)`
 *
 * Similarly, if a bound variable has type `ControlFlowNode`, and a points-to method is called on
 * it, the type should be changed to `ControlFlowNodeWithPointsTo`.
 */

private import python
import semmle.python.pointsto.Base
import semmle.python.pointsto.Context
import semmle.python.pointsto.PointsTo
import semmle.python.pointsto.PointsToContext
import semmle.python.objects.ObjectAPI
import semmle.python.objects.ObjectInternal
import semmle.python.types.Object
import semmle.python.types.ClassObject
import semmle.python.types.FunctionObject
import semmle.python.types.ModuleObject
import semmle.python.types.Exceptions
import semmle.python.types.Properties
import semmle.python.types.Descriptors
import semmle.python.SelfAttribute
import semmle.python.Metrics

/**
 * An extension of `ControlFlowNode` that provides points-to predicates.
 */
class ControlFlowNodeWithPointsTo extends ControlFlowNode {
  /** Gets the value that this ControlFlowNode points-to. */
  predicate pointsTo(Value value) { this.pointsTo(_, value, _) }

  /** Gets the value that this ControlFlowNode points-to. */
  Value pointsTo() { this.pointsTo(_, result, _) }

  /** Gets a value that this ControlFlowNode may points-to. */
  Value inferredValue() { this.pointsTo(_, result, _) }

  /** Gets the value and origin that this ControlFlowNode points-to. */
  predicate pointsTo(Value value, ControlFlowNode origin) { this.pointsTo(_, value, origin) }

  /** Gets the value and origin that this ControlFlowNode points-to, given the context. */
  predicate pointsTo(Context context, Value value, ControlFlowNode origin) {
    PointsTo::pointsTo(this, context, value, origin)
  }

  /**
   * Gets what this flow node might "refer-to". Performs a combination of localized (intra-procedural) points-to
   * analysis and global module-level analysis. This points-to analysis favours precision over recall. It is highly
   * precise, but may not provide information for a significant number of flow-nodes.
   * If the class is unimportant then use `refersTo(value)` or `refersTo(value, origin)` instead.
   */
  pragma[nomagic]
  predicate refersTo(Object obj, ClassObject cls, ControlFlowNode origin) {
    this.refersTo(_, obj, cls, origin)
  }

  /** Gets what this expression might "refer-to" in the given `context`. */
  pragma[nomagic]
  predicate refersTo(Context context, Object obj, ClassObject cls, ControlFlowNode origin) {
    not obj = unknownValue() and
    not cls = theUnknownType() and
    PointsTo::points_to(this, context, obj, cls, origin)
  }

  /**
   * Whether this flow node might "refer-to" to `value` which is from `origin`
   * Unlike `this.refersTo(value, _, origin)` this predicate includes results
   * where the class cannot be inferred.
   */
  pragma[nomagic]
  predicate refersTo(Object obj, ControlFlowNode origin) {
    not obj = unknownValue() and
    PointsTo::points_to(this, _, obj, _, origin)
  }

  /** Equivalent to `this.refersTo(value, _)` */
  predicate refersTo(Object obj) { this.refersTo(obj, _) }

  /**
   * Check whether this control-flow node has complete points-to information.
   * This would mean that the analysis managed to infer an over approximation
   * of possible values at runtime.
   */
  predicate hasCompletePointsToSet() {
    // If the tracking failed, then `this` will be its own "origin". In that
    // case, we want to exclude nodes for which there is also a different
    // origin, as that would indicate that some paths failed and some did not.
    this.refersTo(_, _, this) and
    not exists(ControlFlowNode other | other != this and this.refersTo(_, _, other))
    or
    // If `this` is a use of a variable, then we must have complete points-to
    // for that variable.
    exists(SsaVariable v | v.getAUse() = this | varHasCompletePointsToSet(v))
  }

  /** Whether it is unlikely that this ControlFlowNode can be reached */
  predicate unlikelyReachable() {
    not start_bb_likely_reachable(this.getBasicBlock())
    or
    exists(BasicBlock b |
      start_bb_likely_reachable(b) and
      not end_bb_likely_reachable(b) and
      // If there is an unlikely successor edge earlier in the BB
      // than this node, then this node must be unreachable.
      exists(ControlFlowNode p, int i, int j |
        p.(RaisingNode).unlikelySuccessor(_) and
        p = b.getNode(i) and
        this = b.getNode(j) and
        i < j
      )
    )
  }
}

/**
 * Check whether a SSA variable has complete points-to information.
 * This would mean that the analysis managed to infer an overapproximation
 * of possible values at runtime.
 */
private predicate varHasCompletePointsToSet(SsaVariable var) {
  // Global variables may be modified non-locally or concurrently.
  not var.getVariable() instanceof GlobalVariable and
  (
    // If we have complete points-to information on the definition of
    // this variable, then the variable has complete information.
    var.getDefinition()
        .(DefinitionNode)
        .getValue()
        .(ControlFlowNodeWithPointsTo)
        .hasCompletePointsToSet()
    or
    // If this variable is a phi output, then we have complete
    // points-to information about it if all phi inputs had complete
    // information.
    forex(SsaVariable phiInput | phiInput = var.getAPhiInput() |
      varHasCompletePointsToSet(phiInput)
    )
  )
}

private predicate start_bb_likely_reachable(BasicBlock b) {
  exists(Scope s | s.getEntryNode() = b.getNode(_))
  or
  exists(BasicBlock pred |
    pred = b.getAPredecessor() and
    end_bb_likely_reachable(pred) and
    not pred.getLastNode().(RaisingNode).unlikelySuccessor(b)
  )
}

private predicate end_bb_likely_reachable(BasicBlock b) {
  start_bb_likely_reachable(b) and
  not exists(ControlFlowNode p, ControlFlowNode s |
    p.(RaisingNode).unlikelySuccessor(s) and
    p = b.getNode(_) and
    s = b.getNode(_) and
    not p = b.getLastNode()
  )
}

/**
 * An extension of `BasicBlock` that provides points-to related methods.
 */
class BasicBlockWithPointsTo extends BasicBlock {
  /**
   * Whether (as inferred by type inference) it is highly unlikely (or impossible) for control to flow from this to succ.
   */
  predicate unlikelySuccessor(BasicBlockWithPointsTo succ) {
    this.getLastNode().(RaisingNode).unlikelySuccessor(succ.firstNode())
    or
    not end_bb_likely_reachable(this) and succ = this.getASuccessor()
  }

  /**
   * Whether (as inferred by type inference) this basic block is likely to be reachable.
   */
  predicate likelyReachable() { start_bb_likely_reachable(this) }
}

/**
 * An extension of `Expr` that provides points-to predicates.
 */
class ExprWithPointsTo extends Expr {
  /**
   * NOTE: `refersTo` will be deprecated in 2019. Use `pointsTo` instead.
   * Gets what this expression might "refer-to". Performs a combination of localized (intra-procedural) points-to
   *  analysis and global module-level analysis. This points-to analysis favours precision over recall. It is highly
   *  precise, but may not provide information for a significant number of flow-nodes.
   *  If the class is unimportant then use `refersTo(value)` or `refersTo(value, origin)` instead.
   * NOTE: For complex dataflow, involving multiple stages of points-to analysis, it may be more precise to use
   * `ControlFlowNode.refersTo(...)` instead.
   */
  predicate refersTo(Object obj, ClassObject cls, AstNode origin) {
    this.refersTo(_, obj, cls, origin)
  }

  /**
   * NOTE: `refersTo` will be deprecated in 2019. Use `pointsTo` instead.
   * Gets what this expression might "refer-to" in the given `context`.
   */
  predicate refersTo(Context context, Object obj, ClassObject cls, AstNode origin) {
    this.getAFlowNode()
        .(ControlFlowNodeWithPointsTo)
        .refersTo(context, obj, cls, origin.getAFlowNode())
  }

  /**
   * NOTE: `refersTo` will be deprecated in 2019. Use `pointsTo` instead.
   * Holds if this expression might "refer-to" to `value` which is from `origin`
   * Unlike `this.refersTo(value, _, origin)`, this predicate includes results
   * where the class cannot be inferred.
   */
  pragma[nomagic]
  predicate refersTo(Object obj, AstNode origin) {
    this.getAFlowNode().(ControlFlowNodeWithPointsTo).refersTo(obj, origin.getAFlowNode())
  }

  /**
   * NOTE: `refersTo` will be deprecated in 2019. Use `pointsTo` instead.
   * Equivalent to `this.refersTo(value, _)`
   */
  predicate refersTo(Object obj) { this.refersTo(obj, _) }

  /**
   * Holds if this expression might "point-to" to `value` which is from `origin`
   * in the given `context`.
   */
  predicate pointsTo(Context context, Value value, AstNode origin) {
    this.getAFlowNode()
        .(ControlFlowNodeWithPointsTo)
        .pointsTo(context, value, origin.getAFlowNode())
  }

  /**
   * Holds if this expression might "point-to" to `value` which is from `origin`.
   */
  predicate pointsTo(Value value, AstNode origin) {
    this.getAFlowNode().(ControlFlowNodeWithPointsTo).pointsTo(value, origin.getAFlowNode())
  }

  /**
   * Holds if this expression might "point-to" to `value`.
   */
  predicate pointsTo(Value value) { this.pointsTo(value, _) }

  /** Gets a value that this expression might "point-to". */
  Value pointsTo() { this.pointsTo(result) }

  override string getAQlClass() { none() }
}

/**
 * An extension of `Module` that provides points-to related methods.
 */
class ModuleWithPointsTo extends Module {
  /** Gets a name exported by this module, that is the names that will be added to a namespace by 'from this-module import *' */
  string getAnExport() {
    py_exports(this, result)
    or
    exists(ModuleObjectInternal mod | mod.getSource() = this.getEntryNode() |
      mod.(ModuleValue).exports(result)
    )
  }

  override string getAQlClass() { none() }
}

/**
 * An extension of `Function` that provides points-to related methods.
 */
class FunctionWithPointsTo extends Function {
  /** Gets the FunctionObject corresponding to this function */
  FunctionObject getFunctionObject() { result.getOrigin() = this.getDefinition() }

  override string getAQlClass() { none() }
}

/**
 * An extension of `Class` that provides points-to related methods.
 */
class ClassWithPointsTo extends Class {
  /** Gets the ClassObject corresponding to this class */
  ClassObject getClassObject() { result.getOrigin() = this.getParent() }

  override string getAQlClass() { none() }
}

/** Gets the `Object` corresponding to the immutable literal `l`. */
Object getLiteralObject(ImmutableLiteral l) {
  l instanceof IntegerLiteral and
  (
    py_cobjecttypes(result, theIntType()) and py_cobjectnames(result, l.(Num).getN())
    or
    py_cobjecttypes(result, theLongType()) and py_cobjectnames(result, l.(Num).getN())
  )
  or
  l instanceof FloatLiteral and
  py_cobjecttypes(result, theFloatType()) and
  py_cobjectnames(result, l.(Num).getN())
  or
  l instanceof ImaginaryLiteral and
  py_cobjecttypes(result, theComplexType()) and
  py_cobjectnames(result, l.(Num).getN())
  or
  l instanceof NegativeIntegerLiteral and
  (
    (py_cobjecttypes(result, theIntType()) or py_cobjecttypes(result, theLongType())) and
    py_cobjectnames(result, "-" + l.(UnaryExpr).getOperand().(IntegerLiteral).getN())
  )
  or
  l instanceof Bytes and
  py_cobjecttypes(result, theBytesType()) and
  py_cobjectnames(result, l.(Bytes).quotedString())
  or
  l instanceof Unicode and
  py_cobjecttypes(result, theUnicodeType()) and
  py_cobjectnames(result, l.(Unicode).quotedString())
  or
  l instanceof True and
  name_consts(l, "True") and
  result = theTrueObject()
  or
  l instanceof False and
  name_consts(l, "False") and
  result = theFalseObject()
  or
  l instanceof None and
  name_consts(l, "None") and
  result = theNoneObject()
}

private predicate gettext_installed() {
  // Good enough (and fast) approximation
  exists(Module m | m.getName() = "gettext")
}

private predicate builtin_constant(string name) {
  exists(Object::builtin(name))
  or
  name = "WindowsError"
  or
  name = "_" and gettext_installed()
}

/** Whether this name is (almost) always defined, ie. it is a builtin or VM defined name */
predicate globallyDefinedName(string name) { builtin_constant(name) or auto_name(name) }

private predicate auto_name(string name) {
  name = "__file__" or name = "__builtins__" or name = "__name__"
}

/** An extension of `SsaVariable` that provides points-to related methods. */
class SsaVariableWithPointsTo extends SsaVariable {
  /** Gets an argument of the phi function defining this variable, pruned of unlikely edges. */
  SsaVariable getAPrunedPhiInput() {
    result = this.getAPhiInput() and
    exists(BasicBlock incoming | incoming = this.getPredecessorBlockForPhiArgument(result) |
      not incoming.getLastNode().(RaisingNode).unlikelySuccessor(this.getDefinition())
    )
  }

  /** Gets the incoming edges for a Phi node, pruned of unlikely edges. */
  private BasicBlockWithPointsTo getAPrunedPredecessorBlockForPhi() {
    result = this.getAPredecessorBlockForPhi() and
    not result.unlikelySuccessor(this.getDefinition().getBasicBlock())
  }

  private predicate implicitlyDefined() {
    not exists(this.getDefinition()) and
    not py_ssa_phi(this, _) and
    exists(GlobalVariable var | this.getVariable() = var |
      globallyDefinedName(var.getId())
      or
      var.getId() = "__path__" and var.getScope().(Module).isPackageInit()
    )
  }

  /** Whether this variable may be undefined */
  predicate maybeUndefined() {
    not exists(this.getDefinition()) and not py_ssa_phi(this, _) and not this.implicitlyDefined()
    or
    this.getDefinition().isDelete()
    or
    exists(SsaVariableWithPointsTo var | var = this.getAPrunedPhiInput() | var.maybeUndefined())
    or
    /*
     * For phi-nodes, there must be a corresponding phi-input for each control-flow
     * predecessor. Otherwise, the variable will be undefined on that incoming edge.
     * WARNING: the same phi-input may cover multiple predecessors, so this check
     *          cannot be done by counting.
     */

    exists(BasicBlock incoming |
      reaches_end(incoming) and
      incoming = this.getAPrunedPredecessorBlockForPhi() and
      not this.getAPhiInput().getDefinition().getBasicBlock().dominates(incoming)
    )
  }

  override string getAQlClass() { none() }
}

private predicate reaches_end(BasicBlock b) {
  not exits_early(b) and
  (
    /* Entry point */
    not exists(BasicBlock prev | prev.getASuccessor() = b)
    or
    exists(BasicBlock prev | prev.getASuccessor() = b | reaches_end(prev))
  )
}

private predicate exits_early(BasicBlock b) {
  exists(FunctionObject f |
    f.neverReturns() and
    f.getACall().getBasicBlock() = b
  )
}

/** The metrics for a function that require points-to analysis */
class FunctionMetricsWithPointsTo extends FunctionMetrics {
  /**
   * Gets the cyclomatic complexity of the function:
   * The number of linearly independent paths through the source code.
   * Computed as     E - N + 2P,
   * where
   *  E = the number of edges of the graph.
   *  N = the number of nodes of the graph.
   *  P = the number of connected components, which for a single function is 1.
   */
  int getCyclomaticComplexity() {
    exists(int e, int n |
      n = count(BasicBlockWithPointsTo b | b = this.getABasicBlock() and b.likelyReachable()) and
      e =
        count(BasicBlockWithPointsTo b1, BasicBlockWithPointsTo b2 |
          b1 = this.getABasicBlock() and
          b1.likelyReachable() and
          b2 = this.getABasicBlock() and
          b2.likelyReachable() and
          b2 = b1.getASuccessor() and
          not b1.unlikelySuccessor(b2)
        )
    |
      result = e - n + 2
    )
  }

  private BasicBlock getABasicBlock() {
    result = this.getEntryNode().getBasicBlock()
    or
    exists(BasicBlock mid | mid = this.getABasicBlock() and result = mid.getASuccessor())
  }

  /**
   * Dependency of Callables
   * One callable "this" depends on another callable "result"
   * if "this" makes some call to a method that may end up being "result".
   */
  FunctionMetricsWithPointsTo getADependency() {
    result != this and
    not non_coupling_method(result) and
    exists(Call call | call.getScope() = this |
      exists(FunctionObject callee | callee.getFunction() = result |
        call.getAFlowNode().getFunction().(ControlFlowNodeWithPointsTo).refersTo(callee)
      )
      or
      exists(Attribute a | call.getFunc() = a |
        unique_root_method(result, a.getName())
        or
        exists(Name n | a.getObject() = n and n.getId() = "self" |
          result.getScope() = this.getScope() and
          result.getName() = a.getName()
        )
      )
    )
  }

  /**
   * Afferent Coupling
   * the number of callables that depend on this method.
   * This is sometimes called the "fan-in" of a method.
   */
  int getAfferentCoupling() {
    result = count(FunctionMetricsWithPointsTo m | m.getADependency() = this)
  }

  /**
   * Efferent Coupling
   * the number of methods that this method depends on
   * This is sometimes called the "fan-out" of a method.
   */
  int getEfferentCoupling() {
    result = count(FunctionMetricsWithPointsTo m | this.getADependency() = m)
  }

  override string getAQlClass() { result = "FunctionMetrics" }
}

/** The metrics for a class that require points-to analysis */
class ClassMetricsWithPointsTo extends ClassMetrics {
  private predicate dependsOn(Class other) {
    other != this and
    (
      exists(FunctionMetricsWithPointsTo f1, FunctionMetricsWithPointsTo f2 |
        f1.getADependency() = f2
      |
        f1.getScope() = this and f2.getScope() = other
      )
      or
      exists(Function f, Call c, ClassObject cls | c.getScope() = f and f.getScope() = this |
        c.getFunc().(ExprWithPointsTo).refersTo(cls) and
        cls.getPyClass() = other
      )
    )
  }

  /**
   * Gets the afferent coupling of a class -- the number of classes that
   * directly depend on it.
   */
  int getAfferentCoupling() { result = count(ClassMetricsWithPointsTo t | t.dependsOn(this)) }

  /**
   * Gets the efferent coupling of a class -- the number of classes that
   * it directly depends on.
   */
  int getEfferentCoupling() { result = count(ClassMetricsWithPointsTo t | this.dependsOn(t)) }

  /** Gets the depth of inheritance of the class. */
  int getInheritanceDepth() {
    exists(ClassObject cls | cls.getPyClass() = this | result = max(classInheritanceDepth(cls)))
  }

  override string getAQlClass() { result = "ClassMetrics" }
}

private int classInheritanceDepth(ClassObject cls) {
  /* Prevent run-away recursion in case of circular inheritance */
  not cls.getASuperType() = cls and
  (
    exists(ClassObject sup | cls.getABaseType() = sup | result = classInheritanceDepth(sup) + 1)
    or
    not exists(cls.getABaseType()) and
    (
      major_version() = 2 and result = 0
      or
      major_version() > 2 and result = 1
    )
  )
}

/** The metrics for a module that require points-to analysis */
class ModuleMetricsWithPointsTo extends ModuleMetrics {
  /**
   * Gets the afferent coupling of a module -- the number of modules that
   *  directly depend on it.
   */
  int getAfferentCoupling() { result = count(ModuleMetricsWithPointsTo t | t.dependsOn(this)) }

  /**
   * Gets the efferent coupling of a module -- the number of modules that
   *  it directly depends on.
   */
  int getEfferentCoupling() { result = count(ModuleMetricsWithPointsTo t | this.dependsOn(t)) }

  private predicate dependsOn(Module other) {
    other != this and
    (
      exists(FunctionMetricsWithPointsTo f1, FunctionMetricsWithPointsTo f2 |
        f1.getADependency() = f2
      |
        f1.getEnclosingModule() = this and f2.getEnclosingModule() = other
      )
      or
      exists(Function f, Call c, ClassObject cls | c.getScope() = f and f.getScope() = this |
        c.getFunc().(ExprWithPointsTo).refersTo(cls) and
        cls.getPyClass().getEnclosingModule() = other
      )
    )
  }

  override string getAQlClass() { result = "ModuleMetrics" }
}

/** Helpers for coupling */
predicate unique_root_method(Function func, string name) {
  name = func.getName() and
  not exists(FunctionObject f, FunctionObject other |
    f.getFunction() = func and
    other.getName() = name
  |
    not other.overrides(f)
  )
}
