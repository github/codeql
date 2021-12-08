/**
 * Provides Go-specific definitions for use in the data flow library.
 */

import go
import semmle.go.dataflow.FunctionInputsAndOutputs
private import semmle.go.dataflow.ExternalFlow
private import DataFlowPrivate
private import FlowSummaryImpl as FlowSummaryImpl
import DataFlowNodes::Public

/**
 * Holds if `node` reads an element from `base`, either via an element-read (`base[y]`) expression
 * or via a range statement `_, node := range base`.
 */
predicate readsAnElement(DataFlow::Node node, DataFlow::Node base) {
  node.(ElementReadNode).readsElement(base, _) or
  node.(RangeElementNode).getBase() = base
}

/**
 * A model of a function specifying that the function copies input values from
 * a parameter or qualifier to a result.
 *
 * Note that this only models verbatim copying. Flow that does not preserve exact
 * values should be modeled by `TaintTracking::FunctionModel` instead.
 */
abstract class FunctionModel extends Function {
  /** Holds if data flows through this function from `input` to `output`. */
  abstract predicate hasDataFlow(FunctionInput input, FunctionOutput output);

  /** Gets an input node for this model for the call `c`. */
  DataFlow::Node getAnInputNode(DataFlow::CallNode c) { this.flowStepForCall(result, _, c) }

  /** Gets an output node for this model for the call `c`. */
  DataFlow::Node getAnOutputNode(DataFlow::CallNode c) { this.flowStepForCall(_, result, c) }

  /** Holds if this function model causes data to flow from `pred` to `succ` for the call `c`. */
  predicate flowStepForCall(DataFlow::Node pred, DataFlow::Node succ, DataFlow::CallNode c) {
    c = this.getACall() and
    exists(FunctionInput inp, FunctionOutput outp | this.hasDataFlow(inp, outp) |
      pred = inp.getNode(c) and
      succ = outp.getNode(c)
    )
  }

  /** Holds if this function model causes data to flow from `pred` to `succ`. */
  predicate flowStep(DataFlow::Node pred, DataFlow::Node succ) {
    this.flowStepForCall(pred, succ, _)
  }
}

/**
 * Gets the `Node` corresponding to `insn`.
 */
InstructionNode instructionNode(IR::Instruction insn) { result.asInstruction() = insn }

/**
 * Gets the `Node` corresponding to `e`.
 */
ExprNode exprNode(Expr e) { result.asExpr() = e.stripParens() }

/**
 * Gets the `Node` corresponding to the value of `p` at function entry.
 */
ParameterNode parameterNode(Parameter p) { result.asParameter() = p }

/**
 * Gets the `Node` corresponding to the value of `r` at function entry.
 */
ReceiverNode receiverNode(ReceiverVariable r) { result.asReceiverVariable() = r }

/**
 * Gets the data-flow node corresponding to SSA variable `v`.
 */
SsaNode ssaNode(SsaVariable v) { result.getDefinition() = v.getDefinition() }

/**
 * Gets the data-flow node corresponding to the `i`th element of tuple `t` (which is either a call
 * with multiple results, an iterator in a range loop, or the result of a type assertion).
 */
Node extractTupleElement(Node t, int i) {
  exists(IR::Instruction insn | t = instructionNode(insn) |
    result = instructionNode(IR::extractTupleElement(insn, i))
  )
}

/**
 * Holds if `node` refers to a value returned alongside a non-nil error value.
 *
 * For example, `0` in `func tryGetInt() (int, error) { return 0, errors.New("no good") }`
 */
predicate isReturnedWithError(Node node) {
  exists(ReturnStmt ret, int nodeArg, int errorArg |
    ret.getExpr(nodeArg) = node.asExpr() and
    nodeArg != errorArg and
    ret.getExpr(errorArg).getType() instanceof ErrorType
    // That last condition implies ret.getExpr(errorArg) is non-nil, since nil doesn't implement `error`
  )
}

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
predicate localFlowStep(Node nodeFrom, Node nodeTo) {
  simpleLocalFlowStep(nodeFrom, nodeTo)
  or
  // Simple flow through library code is included in the exposed local
  // step relation, even though flow is technically inter-procedural
  FlowSummaryImpl::Private::Steps::summaryThroughStep(nodeFrom, nodeTo, true)
}

/**
 * INTERNAL: do not use.
 *
 * This is the local flow predicate that's used as a building block in global
 * data flow. It may have less flow than the `localFlowStep` predicate.
 */
cached
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
  basicLocalFlowStep(nodeFrom, nodeTo)
  or
  // step through function model
  any(FunctionModel m).flowStep(nodeFrom, nodeTo)
  or
  FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom, nodeTo, true)
}

/**
 * Holds if data flows from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

private newtype TContent =
  TFieldContent(Field f) or
  TCollectionContent() or
  TArrayContent() or
  TPointerContent(PointerType p) or
  TMapKeyContent() or
  TMapValueContent() or
  TSyntheticFieldContent(SyntheticField s)

/**
 * A reference contained in an object. Examples include instance fields, the
 * contents of a collection object, the contents of an array or pointer.
 */
class Content extends TContent {
  /** Gets the type of the contained data for the purpose of type pruning. */
  DataFlowType getType() { result instanceof EmptyInterfaceType }

  /** Gets a textual representation of this element. */
  abstract string toString();

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = "" and sl = 0 and sc = 0 and el = 0 and ec = 0
  }
}

/** A reference through a field. */
class FieldContent extends Content, TFieldContent {
  Field f;

  FieldContent() { this = TFieldContent(f) }

  /** Gets the field associated with this `FieldContent`. */
  Field getField() { result = f }

  override DataFlowType getType() { result = f.getType() }

  override string toString() { result = f.toString() }

  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    f.getDeclaration().hasLocationInfo(path, sl, sc, el, ec)
  }
}

/** A reference through the contents of some collection-like container. */
class CollectionContent extends Content, TCollectionContent {
  override string toString() { result = "collection" }
}

/** A reference through an array. */
class ArrayContent extends Content, TArrayContent {
  override string toString() { result = "array" }
}

/** A reference through a pointer. */
class PointerContent extends Content, TPointerContent {
  PointerType t;

  PointerContent() { this = TPointerContent(t) }

  /** Gets the pointer type that containers with this content must have. */
  PointerType getPointerType() { result = t }

  override DataFlowType getType() { result = t.getBaseType() }

  override string toString() { result = "pointer" }
}

/** A reference through a map key. */
class MapKeyContent extends Content, TMapKeyContent {
  override string toString() { result = "map.key" }
}

/** A reference through a map value. */
class MapValueContent extends Content, TMapValueContent {
  override string toString() { result = "map.value" }
}

class SyntheticFieldContent extends Content, TSyntheticFieldContent {
  SyntheticField s;

  SyntheticFieldContent() { this = TSyntheticFieldContent(s) }

  /** Gets the field associated with this `SyntheticFieldContent`. */
  SyntheticField getField() { result = s }

  override DataFlowType getType() { result = s.getType() }

  override string toString() { result = s.toString() }
}

/**
 * A guard that validates some expression.
 *
 * To use this in a configuration, extend the class and provide a
 * characteristic predicate precisely specifying the guard, and override
 * `checks` to specify what is being validated and in which branch.
 *
 * When using a data-flow or taint-flow configuration `cfg`, it is important
 * that any classes extending BarrierGuard in scope which are not used in `cfg`
 * are disjoint from any classes extending BarrierGuard in scope which are used
 * in `cfg`.
 */
abstract class BarrierGuard extends Node {
  /** Holds if this guard validates `e` upon evaluating to `branch`. */
  abstract predicate checks(Expr e, boolean branch);

  /** Gets a node guarded by this guard. */
  final Node getAGuardedNode() {
    exists(ControlFlow::ConditionGuardNode guard, Node nd, SsaWithFields var |
      result = var.getAUse()
    |
      this.guards(guard, nd, var) and
      guard.dominates(result.getBasicBlock())
    )
  }

  /**
   * Holds if `guard` markes a point in the control-flow graph where this node
   * is known to validate `nd`, which is represented by `ap`.
   *
   * This predicate exists to enforce a good join order in `getAGuardedNode`.
   */
  pragma[noinline]
  private predicate guards(ControlFlow::ConditionGuardNode guard, Node nd, SsaWithFields ap) {
    this.guards(guard, nd) and nd = ap.getAUse()
  }

  /**
   * Holds if `guard` markes a point in the control-flow graph where this node
   * is known to validate `nd`.
   */
  private predicate guards(ControlFlow::ConditionGuardNode guard, Node nd) {
    exists(boolean branch |
      this.checks(nd.asExpr(), branch) and
      guard.ensures(this, branch)
    )
    or
    exists(
      Function f, FunctionInput inp, FunctionOutput outp, DataFlow::Property p, CallNode c,
      Node resNode, Node check, boolean outcome
    |
      this.guardingCall(f, inp, outp, p, c, nd, resNode) and
      p.checkOn(check, outcome, resNode) and
      guard.ensures(pragma[only_bind_into](check), outcome)
    )
  }

  pragma[noinline]
  private predicate guardingCall(
    Function f, FunctionInput inp, FunctionOutput outp, DataFlow::Property p, CallNode c, Node nd,
    Node resNode
  ) {
    this.guardingFunction(f, inp, outp, p) and
    c = f.getACall() and
    nd = inp.getNode(c) and
    localFlow(pragma[only_bind_out](outp.getNode(c)), resNode)
  }

  /**
   * Holds if whenever `p` holds of output `outp` of function `f`, this node
   * is known to validate the input `inp` of `f`.
   *
   * We check this by looking for guards on `inp` that dominate a `return` statement that
   * is the only `return` in `f` that can return `true`. This means that if `f` returns `true`,
   * the guard must have been satisfied. (Similar reasoning is applied for statements returning
   * `false`, `nil` or a non-`nil` value.)
   */
  private predicate guardingFunction(
    Function f, FunctionInput inp, FunctionOutput outp, DataFlow::Property p
  ) {
    exists(FuncDecl fd, Node arg, Node ret |
      fd.getFunction() = f and
      localFlow(inp.getExitNode(fd), arg) and
      ret = outp.getEntryNode(fd) and
      (
        // Case: a function like "if someBarrierGuard(arg) { return true } else { return false }"
        exists(ControlFlow::ConditionGuardNode guard |
          this.guards(guard, arg) and
          guard.dominates(ret.getBasicBlock())
        |
          exists(boolean b |
            onlyPossibleReturnOfBool(fd, outp, ret, b) and
            p.isBoolean(b)
          )
          or
          onlyPossibleReturnOfNonNil(fd, outp, ret) and
          p.isNonNil()
          or
          onlyPossibleReturnOfNil(fd, outp, ret) and
          p.isNil()
        )
        or
        // Case: a function like "return someBarrierGuard(arg)"
        // or "return !someBarrierGuard(arg) && otherCond(...)"
        exists(boolean outcome |
          ret = getUniqueOutputNode(fd, outp) and
          this.checks(arg.asExpr(), outcome) and
          // This predicate's contract is (p holds of ret ==> arg is checked),
          // (and we have (this has outcome ==> arg is checked))
          // but p.checkOn(ret, outcome, this) gives us (ret has outcome ==> p holds of this),
          // so we need to swap outcome and (specifically boolean) p:
          DataFlow::booleanProperty(outcome).checkOn(ret, p.asBoolean(), this)
        )
        or
        // Case: a function like "return guardProxy(arg)"
        // or "return !guardProxy(arg) || otherCond(...)"
        exists(
          Function f2, FunctionInput inp2, FunctionOutput outp2, CallNode c,
          DataFlow::Property outpProp
        |
          ret = getUniqueOutputNode(fd, outp) and
          this.guardingFunction(f2, inp2, outp2, outpProp) and
          c = f2.getACall() and
          arg = inp2.getNode(c) and
          (
            // See comment above ("This method's contract...") for rationale re: the inversion of
            // `p` and `outpProp` here:
            outpProp.checkOn(ret, p.asBoolean(), outp2.getNode(c))
            or
            // The particular case where p is non-boolean (i.e., nil or non-nil), and we directly return `c`:
            outpProp = p and ret = outp2.getNode(c)
          )
        )
      )
    )
  }
}

DataFlow::Node getUniqueOutputNode(FuncDecl fd, FunctionOutput outp) {
  result = unique(DataFlow::Node n | n = outp.getEntryNode(fd) | n)
}

/**
 * Holds if `ret` is a data-flow node whose value contributes to the output `res` of `fd`,
 * and that node may have Boolean value `b`.
 */
predicate possiblyReturnsBool(FuncDecl fd, FunctionOutput res, Node ret, Boolean b) {
  ret = res.getEntryNode(fd) and
  ret.getType().getUnderlyingType() instanceof BoolType and
  not ret.getBoolValue() != b
}

/**
 * Holds if `ret` is the only data-flow node whose value contributes to the output `res` of `fd`
 * that may have Boolean value `b`, since all the other output nodes have a Boolean value
 * other than `b`.
 */
private predicate onlyPossibleReturnOfBool(FuncDecl fd, FunctionOutput res, Node ret, boolean b) {
  possiblyReturnsBool(fd, res, ret, b) and
  forall(Node otherRet | otherRet = res.getEntryNode(fd) and otherRet != ret |
    otherRet.getBoolValue() != b
  )
}

/**
 * Holds if `ret` is a data-flow node whose value contributes to the output `res` of `fd`,
 * and that node may evaluate to a value other than `nil`.
 */
predicate possiblyReturnsNonNil(FuncDecl fd, FunctionOutput res, Node ret) {
  ret = res.getEntryNode(fd) and
  not ret.asExpr() = Builtin::nil().getAReference()
}

/**
 * Holds if `ret` is the only data-flow node whose value contributes to the output `res` of `fd`
 * that may have a value other than `nil`, since all the other output nodes evaluate to `nil`.
 */
private predicate onlyPossibleReturnOfNonNil(FuncDecl fd, FunctionOutput res, Node ret) {
  possiblyReturnsNonNil(fd, res, ret) and
  forall(Node otherRet | otherRet = res.getEntryNode(fd) and otherRet != ret |
    otherRet.asExpr() = Builtin::nil().getAReference()
  )
}

/**
 * Holds if function `f`'s result `output`, which must be a return value, cannot be nil.
 */
private predicate certainlyReturnsNonNil(Function f, FunctionOutput output) {
  output.isResult(_) and
  (
    f.hasQualifiedName("errors", "New")
    or
    f.hasQualifiedName("fmt", "Errorf")
    or
    f in [Builtin::new(), Builtin::make()]
    or
    exists(FuncDecl fd | fd = f.getFuncDecl() |
      forex(DataFlow::Node ret | ret = output.getEntryNode(fd) | isCertainlyNotNil(ret))
    )
  )
}

/**
 * Holds if `node` cannot be `nil`.
 */
private predicate isCertainlyNotNil(DataFlow::Node node) {
  node instanceof DataFlow::AddressOperationNode
  or
  exists(DataFlow::CallNode c, FunctionOutput output | output.getExitNode(c) = node |
    certainlyReturnsNonNil(c.getTarget(), output)
  )
}

/**
 * Holds if `ret` is the only data-flow node whose value contributes to the output `res` of `fd`
 * that returns `nil`, since all the other output nodes are known to be non-nil.
 */
private predicate onlyPossibleReturnOfNil(FuncDecl fd, FunctionOutput res, DataFlow::Node ret) {
  ret = res.getEntryNode(fd) and
  ret.asExpr() = Builtin::nil().getAReference() and
  forall(DataFlow::Node otherRet | otherRet = res.getEntryNode(fd) and otherRet != ret |
    isCertainlyNotNil(otherRet)
  )
}
