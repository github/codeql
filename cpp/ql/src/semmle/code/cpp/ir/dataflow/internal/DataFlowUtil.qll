/**
 * Provides C++-specific definitions for use in the data flow library.
 */

private import cpp
// The `ValueNumbering` library has to be imported right after `cpp` to ensure
// that the cached IR gets the same checksum here as it does in queries that use
// `ValueNumbering` without `DataFlow`.
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.controlflow.IRGuards
private import semmle.code.cpp.models.interfaces.DataFlow

private newtype TE = TVar(SsaDefinition def)

abstract private class E extends TE {
  abstract string toString();

  predicate asVar(SsaDefinition x) { none() }
}

private class Var extends E, TVar {
  SsaDefinition def;

  Var() { this = TVar(def) }

  override string toString() {
    result = def.getAVariable() + "." + def.getLocation().getStartLine()
  }

  override predicate asVar(SsaDefinition x) { x = def }
}

private newtype TF =
  TTrue() or
  TNot(TF f) { f = interpF(_) } or
  TAnd(TF f1, TF f2) {
    exists(LogicalAndExpr conj |
      f1 = interpF(conj.getLeftOperand()) and
      f2 = interpF(conj.getRightOperand())
    )
  } or
  TOr(TF f1, TF f2) {
    exists(LogicalOrExpr disj |
      f1 = interpF(disj.getLeftOperand()) and
      f2 = interpF(disj.getRightOperand())
    )
  } or
  TEq(TE e1, TE e2) {
    exists(EQExpr eq |
      e1 = interpE(eq.getLeftOperand()) and
      e2 = interpE(eq.getRightOperand())
    )
  } or
  TNEq(TE e1, TE e2) {
    exists(NEExpr neq |
      e1 = interpE(neq.getLeftOperand()) and
      e2 = interpE(neq.getRightOperand())
    )
  } or
  TTruthy(TE e)

abstract private class F extends TF {
  final string toString() { result = "F" }

  predicate asTrue() { none() }

  predicate asNot(F f) { none() }

  predicate asAnd(F f1, F f2) { none() }

  predicate asOr(F f1, F f2) { none() }

  predicate asEq(E e1, E e2) { none() }

  predicate asNEq(E e1, E e2) { none() }

  predicate asTruthy(E e) { none() }
}

class Formula = F;

class True extends TTrue, F {
  True() { this = TTrue() }

  override predicate asTrue() { any() }
}

private class Not extends TNot, F {
  Not() { this = TNot(_) }

  override predicate asNot(F f) { this = TNot(f) }
}

private class And extends TAnd, F {
  And() { this = TAnd(_, _) }

  override predicate asAnd(F f1, F f2) { this = TAnd(f1, f2) }
}

private class Or extends TOr, F {
  Or() { this = TOr(_, _) }

  override predicate asOr(F f1, F f2) { this = TOr(f1, f2) }
}

private class Eq extends TEq, F {
  Eq() { this = TEq(_, _) }

  override predicate asEq(E e1, E e2) { this = TEq(e1, e2) }
}

private class NEq extends TNEq, F {
  NEq() { this = TNEq(_, _) }

  override predicate asNEq(E e1, E e2) { this = TNEq(e1, e2) }
}

private class Truthy extends TTruthy, F {
  Truthy() { this = TTruthy(_) }

  override predicate asTruthy(E e) { this = TTruthy(e) }
}

private F interpretUnaryOperation(UnaryOperation unary) {
  unary instanceof NotExpr and
  result = TNot(interpF(unary.getOperand()))
}

private F interpretBinaryOperation(BinaryOperation binary) {
  binary instanceof LogicalAndExpr and
  result = TAnd(interpF(binary.getLeftOperand()), interpF(binary.getRightOperand()))
  or
  binary instanceof LogicalOrExpr and
  result = TOr(interpF(binary.getLeftOperand()), interpF(binary.getRightOperand()))
  or
  binary instanceof EQExpr and
  result = TEq(interpE(binary.getLeftOperand()), interpE(binary.getRightOperand()))
  or
  binary instanceof NEExpr and
  result = TNEq(interpE(binary.getLeftOperand()), interpE(binary.getRightOperand()))
}

private F interpF(Expr e) {
  result = TTruthy(interpE(e))
  or
  result = interpretUnaryOperation(e)
  or
  result = interpretBinaryOperation(e)
}

private E interpE(Expr e) { result = TVar(any(SsaDefinition ssa | ssa.getAUse(_) = e)) }

private F interpretGuard(GuardCondition guard) { result = interpF(guard) }

private string stringOfExpr(E e) {
  exists(SsaDefinition x |
    e.asVar(x) and result = x.getAVariable() + "." + x.getLocation().getStartLine()
  )
}

F getACondition(Node node) {
  result = TTrue()
  or
  exists(GuardCondition guard |
    guard.isCondition() and
    guard.controls(node.asExpr().getBasicBlock(), true) and
    result = interpretGuard(guard)
  )
  or
  exists(GuardCondition guard |
    guard.isCondition() and
    guard.controls(node.asExpr().getBasicBlock(), false) and
    result = TNot(interpretGuard(guard))
  )
}

string stringOfFormula(F f) {
  f.asTrue() and result = "true"
  or
  exists(F f1 |
    f.asNot(f1) and
    result = "(not " + stringOfFormula(f1) + ")"
  )
  or
  exists(F f1, F f2 |
    f.asAnd(f1, f2) and
    result = "(and " + stringOfFormula(f1) + " " + stringOfFormula(f2) + ")"
  )
  or
  exists(F f1, F f2 |
    f.asOr(f1, f2) and
    result = "(or " + stringOfFormula(f1) + " " + stringOfFormula(f2) + ")"
  )
  or
  exists(E e1, E e2 |
    f.asEq(e1, e2) and
    result = "(= " + stringOfExpr(e1) + " " + stringOfExpr(e2) + ")"
  )
  or
  exists(E e1, E e2 |
    f.asNEq(e1, e2) and
    result = "(not (= " + stringOfExpr(e1) + " " + stringOfExpr(e2) + "))"
  )
  or
  exists(E e |
    f.asTruthy(e) and
    result = stringOfExpr(e)
  )
}

cached
private module Cached {
  cached
  newtype TIRDataFlowNode =
    TInstructionNode(Instruction i) or
    TOperandNode(Operand op) or
    TVariableNode(Variable var)

  cached
  predicate localFlowStepCached(Node nodeFrom, Node nodeTo) {
    simpleLocalFlowStep(nodeFrom, nodeTo)
  }
}

private import Cached

/**
 * A node in a data flow graph.
 *
 * A node can be either an expression, a parameter, or an uninitialized local
 * variable. Such nodes are created with `DataFlow::exprNode`,
 * `DataFlow::parameterNode`, and `DataFlow::uninitializedNode` respectively.
 */
class Node extends TIRDataFlowNode {
  /**
   * INTERNAL: Do not use.
   */
  Declaration getEnclosingCallable() { none() } // overridden in subclasses

  /** Gets the function to which this node belongs, if any. */
  Function getFunction() { none() } // overridden in subclasses

  /** Gets the type of this node. */
  IRType getType() { none() } // overridden in subclasses

  /** Gets the instruction corresponding to this node, if any. */
  Instruction asInstruction() { result = this.(InstructionNode).getInstruction() }

  /** Gets the operands corresponding to this node, if any. */
  Operand asOperand() { result = this.(OperandNode).getOperand() }

  /**
   * Gets the non-conversion expression corresponding to this node, if any.
   * This predicate only has a result on nodes that represent the value of
   * evaluating the expression. For data flowing _out of_ an expression, like
   * when an argument is passed by reference, use `asDefiningArgument` instead
   * of `asExpr`.
   *
   * If this node strictly (in the sense of `asConvertedExpr`) corresponds to
   * a `Conversion`, then the result is the underlying non-`Conversion` base
   * expression.
   */
  Expr asExpr() { result = this.(ExprNode).getExpr() }

  /**
   * Gets the expression corresponding to this node, if any. The returned
   * expression may be a `Conversion`.
   */
  Expr asConvertedExpr() { result = this.(ExprNode).getConvertedExpr() }

  /**
   * Gets the argument that defines this `DefinitionByReferenceNode`, if any.
   * This predicate should be used instead of `asExpr` when referring to the
   * value of a reference argument _after_ the call has returned. For example,
   * in `f(&x)`, this predicate will have `&x` as its result for the `Node`
   * that represents the new value of `x`.
   */
  Expr asDefiningArgument() { result = this.(DefinitionByReferenceNode).getArgument() }

  /** Gets the positional parameter corresponding to this node, if any. */
  Parameter asParameter() { result = this.(ExplicitParameterNode).getParameter() }

  /**
   * Gets the variable corresponding to this node, if any. This can be used for
   * modeling flow in and out of global variables.
   */
  Variable asVariable() { result = this.(VariableNode).getVariable() }

  /**
   * Gets the expression that is partially defined by this node, if any.
   *
   * Partial definitions are created for field stores (`x.y = taint();` is a partial
   * definition of `x`), and for calls that may change the value of an object (so
   * `x.set(taint())` is a partial definition of `x`, and `transfer(&x, taint())` is
   * a partial definition of `&x`).
   */
  Expr asPartialDefinition() { result = this.(PartialDefinitionNode).getDefinedExpr() }

  /**
   * DEPRECATED: See UninitializedNode.
   *
   * Gets the uninitialized local variable corresponding to this node, if
   * any.
   */
  deprecated LocalVariable asUninitialized() { none() }

  /**
   * Gets an upper bound on the type of this node.
   */
  IRType getTypeBound() { result = getType() }

  /** Gets the location of this element. */
  Location getLocation() { none() } // overridden by subclasses

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets a textual representation of this element. */
  string toString() { none() } // overridden by subclasses
}

/**
 * An instruction, viewed as a node in a data flow graph.
 */
class InstructionNode extends Node, TInstructionNode {
  Instruction instr;

  InstructionNode() { this = TInstructionNode(instr) }

  /** Gets the instruction corresponding to this node. */
  Instruction getInstruction() { result = instr }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Function getFunction() { result = instr.getEnclosingFunction() }

  override IRType getType() { result = instr.getResultIRType() }

  override Location getLocation() { result = instr.getLocation() }

  override string toString() {
    // This predicate is overridden in subclasses. This default implementation
    // does not use `Instruction.toString` because that's expensive to compute.
    result = this.getInstruction().getOpcode().toString()
  }
}

/**
 * An operand, viewed as a node in a data flow graph.
 */
class OperandNode extends Node, TOperandNode {
  Operand op;

  OperandNode() { this = TOperandNode(op) }

  /** Gets the operand corresponding to this node. */
  Operand getOperand() { result = op }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Function getFunction() { result = op.getUse().getEnclosingFunction() }

  override IRType getType() { result = op.getIRType() }

  override Location getLocation() { result = op.getLocation() }

  override string toString() { result = this.getOperand().toString() }
}

/**
 * An expression, viewed as a node in a data flow graph.
 */
class ExprNode extends InstructionNode {
  ExprNode() { exists(instr.getConvertedResultExpression()) }

  /**
   * Gets the non-conversion expression corresponding to this node, if any. If
   * this node strictly (in the sense of `getConvertedExpr`) corresponds to a
   * `Conversion`, then the result is that `Conversion`'s non-`Conversion` base
   * expression.
   */
  Expr getExpr() { result = instr.getUnconvertedResultExpression() }

  /**
   * Gets the expression corresponding to this node, if any. The returned
   * expression may be a `Conversion`.
   */
  Expr getConvertedExpr() { result = instr.getConvertedResultExpression() }

  override string toString() { result = this.asConvertedExpr().toString() }
}

/**
 * INTERNAL: do not use. Translates a parameter/argument index into a negative
 * number that denotes the index of its side effect (pointer indirection).
 */
bindingset[index]
int getArgumentPosOfSideEffect(int index) {
  // -1 -> -2
  //  0 -> -3
  //  1 -> -4
  // ...
  result = -3 - index
}

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph. This includes both explicit parameters such as `x` in `f(x)`
 * and implicit parameters such as `this` in `x.f()`.
 *
 * To match a specific kind of parameter, consider using one of the subclasses
 * `ExplicitParameterNode`, `ThisParameterNode`, or
 * `ParameterIndirectionNode`.
 */
class ParameterNode extends InstructionNode {
  ParameterNode() {
    // To avoid making this class abstract, we enumerate its values here
    instr instanceof InitializeParameterInstruction
    or
    instr instanceof InitializeIndirectionInstruction
  }

  /**
   * Holds if this node is the parameter of `f` at the specified position. The
   * implicit `this` parameter is considered to have position `-1`, and
   * pointer-indirection parameters are at further negative positions.
   */
  predicate isParameterOf(Function f, int pos) { none() } // overridden by subclasses
}

/** An explicit positional parameter, not including `this` or `...`. */
private class ExplicitParameterNode extends ParameterNode {
  override InitializeParameterInstruction instr;

  ExplicitParameterNode() { exists(instr.getParameter()) }

  override predicate isParameterOf(Function f, int pos) {
    f.getParameter(pos) = instr.getParameter()
  }

  /** Gets the `Parameter` associated with this node. */
  Parameter getParameter() { result = instr.getParameter() }

  override string toString() { result = instr.getParameter().toString() }
}

/** An implicit `this` parameter. */
class ThisParameterNode extends ParameterNode {
  override InitializeParameterInstruction instr;

  ThisParameterNode() { instr.getIRVariable() instanceof IRThisVariable }

  override predicate isParameterOf(Function f, int pos) {
    pos = -1 and instr.getEnclosingFunction() = f
  }

  override string toString() { result = "this" }
}

/** A synthetic parameter to model the pointed-to object of a pointer parameter. */
class ParameterIndirectionNode extends ParameterNode {
  override InitializeIndirectionInstruction instr;

  override predicate isParameterOf(Function f, int pos) {
    exists(int index |
      instr.getEnclosingFunction() = f and
      instr.hasIndex(index)
    |
      pos = getArgumentPosOfSideEffect(index)
    )
  }

  override string toString() { result = "*" + instr.getIRVariable().toString() }
}

/**
 * DEPRECATED: Data flow was never an accurate way to determine what
 * expressions might be uninitialized. It errs on the side of saying that
 * everything is uninitialized, and this is even worse in the IR because the IR
 * doesn't use syntactic hints to rule out variables that are definitely
 * initialized.
 *
 * The value of an uninitialized local variable, viewed as a node in a data
 * flow graph.
 */
deprecated class UninitializedNode extends Node {
  UninitializedNode() { none() }

  LocalVariable getLocalVariable() { none() }
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
 * to the value before the update with the exception of `ClassInstanceExpr`,
 * which represents the value after the constructor has run.
 *
 * This class exists to match the interface used by Java. There are currently no non-abstract
 * classes that extend it. When we implement field flow, we can revisit this.
 */
abstract class PostUpdateNode extends InstructionNode {
  /**
   * Gets the node before the state update.
   */
  abstract Node getPreUpdateNode();
}

/**
 * The base class for nodes that perform "partial definitions".
 *
 * In contrast to a normal "definition", which provides a new value for
 * something, a partial definition is an expression that may affect a
 * value, but does not necessarily replace it entirely. For example:
 * ```
 * x.y = 1; // a partial definition of the object `x`.
 * x.y.z = 1; // a partial definition of the object `x.y`.
 * x.setY(1); // a partial definition of the object `x`.
 * setY(&x); // a partial definition of the object `x`.
 * ```
 */
abstract private class PartialDefinitionNode extends PostUpdateNode {
  abstract Expr getDefinedExpr();
}

private class ExplicitFieldStoreQualifierNode extends PartialDefinitionNode {
  override ChiInstruction instr;
  StoreInstruction store;

  ExplicitFieldStoreQualifierNode() {
    not instr.isResultConflated() and
    instr.getPartial() = store and
    (
      instr.getUpdatedInterval(_, _) or
      store.getDestinationAddress() instanceof FieldAddressInstruction
    )
  }

  // By using an operand as the result of this predicate we avoid the dataflow inconsistency errors
  // caused by having multiple nodes sharing the same pre update node. This inconsistency error can cause
  // a tuple explosion in the big step dataflow relation since it can make many nodes be the entry node
  // into a big step.
  override Node getPreUpdateNode() { result.asOperand() = instr.getTotalOperand() }

  override Expr getDefinedExpr() {
    result =
      store
          .getDestinationAddress()
          .(FieldAddressInstruction)
          .getObjectAddress()
          .getUnconvertedResultExpression()
  }
}

/**
 * Not every store instruction generates a chi instruction that we can attach a PostUpdateNode to.
 * For instance, an update to a field of a struct containing only one field. Even if the store does
 * have a chi instruction, a subsequent use of the result of the store may be linked directly to the
 * result of the store as an inexact definition if the store totally overlaps the use. For these
 * cases we attach the PostUpdateNode to the store instruction. There's no obvious pre update node
 * for this case (as the entire memory is updated), so `getPreUpdateNode` is implemented as
 * `none()`.
 */
private class ExplicitSingleFieldStoreQualifierNode extends PartialDefinitionNode {
  override StoreInstruction instr;

  ExplicitSingleFieldStoreQualifierNode() {
    (
      instr.getAUse().isDefinitionInexact()
      or
      not exists(ChiInstruction chi | chi.getPartial() = instr)
    ) and
    // Without this condition any store would create a `PostUpdateNode`.
    instr.getDestinationAddress() instanceof FieldAddressInstruction
  }

  override Node getPreUpdateNode() { none() }

  override Expr getDefinedExpr() {
    result =
      instr
          .getDestinationAddress()
          .(FieldAddressInstruction)
          .getObjectAddress()
          .getUnconvertedResultExpression()
  }
}

private FieldAddressInstruction getFieldInstruction(Instruction instr) {
  result = instr or
  result = instr.(CopyValueInstruction).getUnary()
}

/**
 * The target of a `fieldStoreStepAfterArraySuppression` store step, which is used to convert
 * an `ArrayContent` to a `FieldContent` when the `WriteSideEffect` instruction stores
 * into a field. See the QLDoc for `suppressArrayRead` for an example of where such a conversion
 * is inserted.
 */
private class WriteSideEffectFieldStoreQualifierNode extends PartialDefinitionNode {
  override ChiInstruction instr;
  WriteSideEffectInstruction write;
  FieldAddressInstruction field;

  WriteSideEffectFieldStoreQualifierNode() {
    not instr.isResultConflated() and
    instr.getPartial() = write and
    field = getFieldInstruction(write.getDestinationAddress())
  }

  override Node getPreUpdateNode() { result.asOperand() = instr.getTotalOperand() }

  override Expr getDefinedExpr() {
    result = field.getObjectAddress().getUnconvertedResultExpression()
  }
}

/**
 * The `PostUpdateNode` that is the target of a `arrayStoreStepChi` store step. The overriden
 * `ChiInstruction` corresponds to the instruction represented by `node2` in `arrayStoreStepChi`.
 */
private class ArrayStoreNode extends PartialDefinitionNode {
  override ChiInstruction instr;
  PointerAddInstruction add;

  ArrayStoreNode() {
    not instr.isResultConflated() and
    exists(StoreInstruction store |
      instr.getPartial() = store and
      add = store.getDestinationAddress()
    )
  }

  override Node getPreUpdateNode() { result.asOperand() = instr.getTotalOperand() }

  override Expr getDefinedExpr() { result = add.getLeft().getUnconvertedResultExpression() }
}

/**
 * The `PostUpdateNode` that is the target of a `arrayStoreStepChi` store step. The overriden
 * `ChiInstruction` corresponds to the instruction represented by `node2` in `arrayStoreStepChi`.
 */
private class PointerStoreNode extends PostUpdateNode {
  override ChiInstruction instr;

  PointerStoreNode() {
    not instr.isResultConflated() and
    exists(StoreInstruction store |
      instr.getPartial() = store and
      store.getDestinationAddress().(CopyValueInstruction).getUnary() instanceof LoadInstruction
    )
  }

  override Node getPreUpdateNode() { result.asOperand() = instr.getTotalOperand() }
}

/**
 * A node that represents the value of a variable after a function call that
 * may have changed the variable because it's passed by reference.
 *
 * A typical example would be a call `f(&x)`. Firstly, there will be flow into
 * `x` from previous definitions of `x`. Secondly, there will be a
 * `DefinitionByReferenceNode` to represent the value of `x` after the call has
 * returned. This node will have its `getArgument()` equal to `&x` and its
 * `getVariableAccess()` equal to `x`.
 */
class DefinitionByReferenceNode extends InstructionNode {
  override WriteSideEffectInstruction instr;

  /** Gets the unconverted argument corresponding to this node. */
  Expr getArgument() {
    result =
      instr
          .getPrimaryInstruction()
          .(CallInstruction)
          .getArgument(instr.getIndex())
          .getUnconvertedResultExpression()
  }

  /** Gets the parameter through which this value is assigned. */
  Parameter getParameter() {
    exists(CallInstruction ci | result = ci.getStaticCallTarget().getParameter(instr.getIndex()))
  }

  override string toString() {
    // This string should be unique enough to be helpful but common enough to
    // avoid storing too many different strings.
    result =
      instr.getPrimaryInstruction().(CallInstruction).getStaticCallTarget().getName() +
        " output argument"
    or
    not exists(instr.getPrimaryInstruction().(CallInstruction).getStaticCallTarget()) and
    result = "output argument"
  }
}

/**
 * A `Node` corresponding to a variable in the program, as opposed to the
 * value of that variable at some particular point. This can be used for
 * modeling flow in and out of global variables.
 */
class VariableNode extends Node, TVariableNode {
  Variable v;

  VariableNode() { this = TVariableNode(v) }

  /** Gets the variable corresponding to this node. */
  Variable getVariable() { result = v }

  override Function getFunction() { none() }

  override Declaration getEnclosingCallable() {
    // When flow crosses from one _enclosing callable_ to another, the
    // interprocedural data-flow library discards call contexts and inserts a
    // node in the big-step relation used for human-readable path explanations.
    // Therefore we want a distinct enclosing callable for each `VariableNode`,
    // and that can be the `Variable` itself.
    result = v
  }

  override IRType getType() { result.getCanonicalLanguageType().hasUnspecifiedType(v.getType(), _) }

  override Location getLocation() { result = v.getLocation() }

  override string toString() { result = v.toString() }
}

/**
 * Gets the node corresponding to `instr`.
 */
InstructionNode instructionNode(Instruction instr) { result.getInstruction() = instr }

/**
 * DEPRECATED: use `definitionByReferenceNodeFromArgument` instead.
 *
 * Gets the `Node` corresponding to a definition by reference of the variable
 * that is passed as `argument` of a call.
 */
deprecated DefinitionByReferenceNode definitionByReferenceNode(Expr e) { result.getArgument() = e }

/**
 * Gets the `Node` corresponding to the value of evaluating `e` or any of its
 * conversions. There is no result if `e` is a `Conversion`. For data flowing
 * _out of_ an expression, like when an argument is passed by reference, use
 * `definitionByReferenceNodeFromArgument` instead.
 */
ExprNode exprNode(Expr e) { result.getExpr() = e }

/**
 * Gets the `Node` corresponding to the value of evaluating `e`. Here, `e` may
 * be a `Conversion`. For data flowing _out of_ an expression, like when an
 * argument is passed by reference, use
 * `definitionByReferenceNodeFromArgument` instead.
 */
ExprNode convertedExprNode(Expr e) { result.getConvertedExpr() = e }

/**
 * Gets the `Node` corresponding to the value of `p` at function entry.
 */
ExplicitParameterNode parameterNode(Parameter p) { result.getParameter() = p }

/**
 * Gets the `Node` corresponding to a definition by reference of the variable
 * that is passed as unconverted `argument` of a call.
 */
DefinitionByReferenceNode definitionByReferenceNodeFromArgument(Expr argument) {
  result.getArgument() = argument
}

/** Gets the `VariableNode` corresponding to the variable `v`. */
VariableNode variableNode(Variable v) { result.getVariable() = v }

/**
 * DEPRECATED: See UninitializedNode.
 *
 * Gets the `Node` corresponding to the value of an uninitialized local
 * variable `v`.
 */
Node uninitializedNode(LocalVariable v) { none() }

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
predicate localFlowStep = localFlowStepCached/2;

/**
 * INTERNAL: do not use.
 *
 * This is the local flow predicate that's used as a building block in global
 * data flow. It may have less flow than the `localFlowStep` predicate.
 */
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
  // Operand -> Instruction flow
  simpleInstructionLocalFlowStep(nodeFrom.asOperand(), nodeTo.asInstruction())
  or
  // Instruction -> Operand flow
  simpleOperandLocalFlowStep(nodeFrom.asInstruction(), nodeTo.asOperand())
}

pragma[noinline]
private predicate getFieldSizeOfClass(Class c, Type type, int size) {
  exists(Field f |
    f.getDeclaringType() = c and
    f.getUnderlyingType() = type and
    type.getSize() = size
  )
}

private predicate isSingleFieldClass(Type type, Operand op) {
  exists(int size, Class c |
    c = op.getType().getUnderlyingType() and
    c.getSize() = size and
    getFieldSizeOfClass(c, type, size)
  )
}

private predicate simpleOperandLocalFlowStep(Instruction iFrom, Operand opTo) {
  // Propagate flow from an instruction to its exact uses.
  opTo.getDef() = iFrom
  or
  opTo = any(ReadSideEffectInstruction read).getSideEffectOperand() and
  not iFrom.isResultConflated() and
  iFrom = opTo.getAnyDef()
  or
  // Loading a single `int` from an `int *` parameter is not an exact load since
  // the parameter may point to an entire array rather than a single `int`. The
  // following rule ensures that any flow going into the
  // `InitializeIndirectionInstruction`, even if it's for a different array
  // element, will propagate to a load of the first element.
  //
  // Since we're linking `InitializeIndirectionInstruction` and
  // `LoadInstruction` together directly, this rule will break if there's any
  // reassignment of the parameter indirection, including a conditional one that
  // leads to a phi node.
  exists(InitializeIndirectionInstruction init |
    iFrom = init and
    opTo.(LoadOperand).getAnyDef() = init and
    // Check that the types match. Otherwise we can get flow from an object to
    // its fields, which leads to field conflation when there's flow from other
    // fields to the object elsewhere.
    init.getParameter().getType().getUnspecifiedType().(DerivedType).getBaseType() =
      opTo.getType().getUnspecifiedType()
  )
  or
  // Flow from stores to structs with a single field to a load of that field.
  exists(LoadInstruction load |
    load.getSourceValueOperand() = opTo and
    opTo.getAnyDef() = iFrom and
    isSingleFieldClass(iFrom.getResultType(), opTo)
  )
}

private predicate simpleInstructionLocalFlowStep(Operand opFrom, Instruction iTo) {
  iTo.(CopyInstruction).getSourceValueOperand() = opFrom
  or
  iTo.(PhiInstruction).getAnInputOperand() = opFrom
  or
  // Treat all conversions as flow, even conversions between different numeric types.
  iTo.(ConvertInstruction).getUnaryOperand() = opFrom
  or
  iTo.(CheckedConvertOrNullInstruction).getUnaryOperand() = opFrom
  or
  iTo.(InheritanceConversionInstruction).getUnaryOperand() = opFrom
  or
  // A chi instruction represents a point where a new value (the _partial_
  // operand) may overwrite an old value (the _total_ operand), but the alias
  // analysis couldn't determine that it surely will overwrite every bit of it or
  // that it surely will overwrite no bit of it.
  //
  // By allowing flow through the total operand, we ensure that flow is not lost
  // due to shortcomings of the alias analysis. We may get false flow in cases
  // where the data is indeed overwritten.
  //
  // Flow through the partial operand belongs in the taint-tracking libraries
  // for now.
  iTo.getAnOperand().(ChiTotalOperand) = opFrom
  or
  // Add flow from write side-effects to non-conflated chi instructions through their
  // partial operands. From there, a `readStep` will find subsequent reads of that field.
  // Consider the following example:
  // ```
  // void setX(Point* p, int new_x) {
  //   p->x = new_x;
  // }
  // ...
  // setX(&p, taint());
  // ```
  // Here, a `WriteSideEffectInstruction` will provide a new definition for `p->x` after the call to
  // `setX`, which will be melded into `p` through a chi instruction.
  exists(ChiInstruction chi | chi = iTo |
    opFrom.getAnyDef() instanceof WriteSideEffectInstruction and
    chi.getPartialOperand() = opFrom and
    not chi.isResultConflated() and
    // In a call such as `set_value(&x->val);` we don't want the memory representing `x` to receive
    // dataflow by a simple step. Instead, this is handled by field flow. If we add a simple step here
    // we can get field-to-object flow.
    not chi.isPartialUpdate()
  )
  or
  // Flow through modeled functions
  modelFlow(opFrom, iTo)
}

private predicate modelFlow(Operand opFrom, Instruction iTo) {
  exists(
    CallInstruction call, DataFlowFunction func, FunctionInput modelIn, FunctionOutput modelOut
  |
    call.getStaticCallTarget() = func and
    func.hasDataFlow(modelIn, modelOut)
  |
    (
      modelOut.isReturnValue() and
      iTo = call
      or
      // TODO: Add write side effects for return values
      modelOut.isReturnValueDeref() and
      iTo = call
      or
      exists(int index, WriteSideEffectInstruction outNode |
        modelOut.isParameterDerefOrQualifierObject(index) and
        iTo = outNode and
        outNode = getSideEffectFor(call, index)
      )
    ) and
    (
      exists(int index |
        modelIn.isParameterOrQualifierAddress(index) and
        opFrom = call.getArgumentOperand(index)
      )
      or
      exists(int index, ReadSideEffectInstruction read |
        modelIn.isParameterDerefOrQualifierObject(index) and
        read = getSideEffectFor(call, index) and
        opFrom = read.getSideEffectOperand()
      )
    )
  )
}

/**
 * Holds if the result is a side effect for instruction `call` on argument
 * index `argument`. This helper predicate makes it easy to join on both of
 * these columns at once, avoiding pathological join orders in case the
 * argument index should get joined first.
 */
pragma[noinline]
SideEffectInstruction getSideEffectFor(CallInstruction call, int argument) {
  call = result.getPrimaryInstruction() and
  argument = result.(IndexedInstruction).getIndex()
}

/**
 * Holds if data flows from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

/**
 * Holds if data can flow from `i1` to `i2` in zero or more
 * local (intra-procedural) steps.
 */
predicate localInstructionFlow(Instruction e1, Instruction e2) {
  localFlow(instructionNode(e1), instructionNode(e2))
}

/**
 * Holds if data can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
predicate localExprFlow(Expr e1, Expr e2) { localFlow(exprNode(e1), exprNode(e2)) }

/**
 * A guard that validates some instruction.
 *
 * To use this in a configuration, extend the class and provide a
 * characteristic predicate precisely specifying the guard, and override
 * `checks` to specify what is being validated and in which branch.
 *
 * It is important that all extending classes in scope are disjoint.
 */
class BarrierGuard extends IRGuardCondition {
  /** Override this predicate to hold if this guard validates `instr` upon evaluating to `b`. */
  predicate checksInstr(Instruction instr, boolean b) { none() }

  /** Override this predicate to hold if this guard validates `expr` upon evaluating to `b`. */
  predicate checks(Expr e, boolean b) { none() }

  /** Gets a node guarded by this guard. */
  final Node getAGuardedNode() {
    exists(ValueNumber value, boolean edge |
      (
        this.checksInstr(value.getAnInstruction(), edge)
        or
        this.checks(value.getAnInstruction().getConvertedResultExpression(), edge)
      ) and
      result.asInstruction() = value.getAnInstruction() and
      this.controls(result.asInstruction().getBlock(), edge)
    )
  }
}
