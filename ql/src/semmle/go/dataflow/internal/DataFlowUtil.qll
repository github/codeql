/**
 * Provides Go-specific definitions for use in the data flow library.
 */

import go
import semmle.go.dataflow.FunctionInputsAndOutputs
private import DataFlowPrivate

cached
private newtype TNode =
  MkInstructionNode(IR::Instruction insn) or
  MkSsaNode(SsaDefinition ssa) or
  MkGlobalFunctionNode(Function f)

/**
 * A node in a data flow graph.
 *
 * A node can be either an IR instruction or an SSA definition.
 * Such nodes are created with `DataFlow::instructionNode`
 * and `DataFlow::ssaNode` respectively.
 */
class Node extends TNode {
  /** Gets the function to which this node belongs. */
  ControlFlow::Root getRoot() { none() } // overridden in subclasses

  /** INTERNAL: Use `getRoot()` instead. */
  FuncDef getEnclosingCallable() { result = getRoot() }

  /** Gets the type of this node. */
  Type getType() { none() } // overridden in subclasses

  /** Gets the expression corresponding to this node, if any. */
  Expr asExpr() { none() } // overridden in subclasses

  /** Gets the parameter corresponding to this node, if any. */
  Parameter asParameter() { none() } // overridden in subclasses

  /** Gets the IR instruction corresponding to this node, if any. */
  IR::Instruction asInstruction() { none() } // overridden in subclasses

  /** Gets a textual representation of the kind of this data-flow node. */
  string getNodeKind() { none() } // overridden in subclasses

  /** Gets the basic block to which this data-flow node belongs, if any. */
  BasicBlock getBasicBlock() { result = asInstruction().getBasicBlock() }

  /** Gets a textual representation of this element. */
  string toString() { result = "data-flow node" } // overridden in subclasses

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
    filepath = "" and
    startline = 0 and
    startcolumn = 0 and
    endline = 0 and
    endcolumn = 0
  }

  /** Gets the file in which this node appears. */
  File getFile() { hasLocationInfo(result.getAbsolutePath(), _, _, _, _) }

  /** Gets the start line of the location of this node. */
  int getStartLine() { hasLocationInfo(_, result, _, _, _) }

  /** Gets the start column of the location of this node. */
  int getStartColumn() { hasLocationInfo(_, _, result, _, _) }

  /** Gets the end line of the location of this node. */
  int getEndLine() { hasLocationInfo(_, _, _, result, _) }

  /** Gets the end column of the location of this node. */
  int getEndColumn() { hasLocationInfo(_, _, _, _, result) }

  /**
   * Gets an upper bound on the type of this node.
   */
  Type getTypeBound() { result = getType() }

  /** Gets the floating-point value this data-flow node contains, if any. */
  float getFloatValue() { result = this.asExpr().getFloatValue() }

  /**
   * Gets the integer value this data-flow node contains, if any.
   *
   * Note that this does not have a result if the value is too large to fit in a
   * 32-bit signed integer type.
   */
  int getIntValue() { result = this.asInstruction().getIntValue() }

  /** Gets either `getFloatValue` or `getIntValue`. */
  float getNumericValue() { result = this.asInstruction().getNumericValue() }

  /**
   * Holds if the complex value this data-flow node contains has real part `real` and imaginary
   * part `imag`.
   */
  predicate hasComplexValue(float real, float imag) {
    this.asInstruction().hasComplexValue(real, imag)
  }

  /** Gets the string value this data-flow node contains, if any. */
  string getStringValue() { result = this.asInstruction().getStringValue() }

  /**
   * Gets the string representation of the exact value this data-flow node
   * contains, if any.
   *
   * For example, for the constant 3.141592653589793238462, this will
   * result in 1570796326794896619231/500000000000000000000
   */
  string getExactValue() { result = this.asInstruction().getExactValue() }

  /** Gets the Boolean value this data-flow node contains, if any. */
  boolean getBoolValue() { result = this.asInstruction().getBoolValue() }

  /** Holds if the value of this data-flow node is known at compile time. */
  predicate isConst() { this.asInstruction().isConst() }

  /**
   * Holds if the result of this instruction is known at compile time, and is guaranteed not to
   * depend on the platform where it is evaluated.
   */
  predicate isPlatformIndependentConstant() { this.asInstruction().isPlatformIndependentConstant() }

  /**
   * Gets a data-flow node to which data may flow from this node in one (intra-procedural) step.
   */
  Node getASuccessor() { localFlowStep(this, result) }

  /**
   * Gets a data-flow node from which data may flow to this node in one (intra-procedural) step.
   */
  Node getAPredecessor() { this = result.getASuccessor() }
}

/**
 * An IR instruction, viewed as a node in a data flow graph.
 */
class InstructionNode extends Node, MkInstructionNode {
  IR::Instruction insn;

  InstructionNode() { this = MkInstructionNode(insn) }

  override IR::Instruction asInstruction() { result = insn }

  override ControlFlow::Root getRoot() { result = insn.getRoot() }

  override Type getType() { result = insn.getResultType() }

  override string getNodeKind() { result = insn.getInsnKind() }

  override string toString() { result = insn.toString() }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    insn.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/**
 * An expression, viewed as a node in a data flow graph.
 */
class ExprNode extends InstructionNode {
  override IR::EvalInstruction insn;
  Expr expr;

  ExprNode() { expr = insn.getExpr() }

  override Expr asExpr() { result = expr }

  /** Gets the underlying expression this node corresponds to. */
  Expr getExpr() { result = expr }
}

/**
 * An SSA variable, viewed as a node in a data flow graph.
 */
class SsaNode extends Node, MkSsaNode {
  SsaDefinition ssa;

  SsaNode() { this = MkSsaNode(ssa) }

  /** Gets the node whose value is stored in this SSA variable, if any. */
  Node getInit() { result = instructionNode(ssa.(SsaExplicitDefinition).getRhs()) }

  /** Gets a use of this SSA variable. */
  InstructionNode getAUse() { result = instructionNode(ssa.getVariable().getAUse()) }

  /** Gets the program variable corresponding to this SSA variable. */
  SsaSourceVariable getSourceVariable() { result = ssa.getSourceVariable() }

  /** Gets the unique definition of this SSA variable. */
  SsaDefinition getDefinition() { result = ssa }

  override ControlFlow::Root getRoot() { result = ssa.getRoot() }

  override Type getType() { result = ssa.getSourceVariable().getType() }

  override string getNodeKind() { result = "SSA variable " + ssa.getSourceVariable().getName() }

  override string toString() { result = ssa.toString() }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    ssa.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/** A function, viewed as a node in a data flow graph. */
abstract class FunctionNode extends Node {
  /** Gets the `i`th parameter of this function. */
  abstract ParameterNode getParameter(int i);

  /** Gets a parameter of this function. */
  ParameterNode getAParameter() { result = this.getParameter(_) }

  /** Gets the number of parameters declared on this function. */
  int getNumParameter() { result = count(this.getAParameter()) }

  /** Gets the name of this function, if it has one. */
  abstract string getName();

  /**
   * Gets the dataflow node holding the value of the receiver, if any.
   */
  abstract ReceiverNode getReceiver();

  /**
   * Gets a value returned by the given function via a return statement or an assignment to a result variable.
   */
  abstract ResultNode getAResult();
}

/** A representation of a function that is declared in the module scope. */
class GlobalFunctionNode extends FunctionNode, MkGlobalFunctionNode {
  Function func;

  GlobalFunctionNode() { this = MkGlobalFunctionNode(func) }

  override ParameterNode getParameter(int i) { result = parameterNode(func.getParameter(i)) }

  override string getName() { result = func.getName() }

  /** Gets the function this node corresponds to. */
  Function getFunction() { result = func }

  override ReceiverNode getReceiver() { result = receiverNode(func.(Method).getReceiver()) }

  override string getNodeKind() { result = "function " + func.getName() }

  override string toString() { result = "function " + func.getName() }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    func.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  override ResultNode getAResult() {
    result.getRoot() = getFunction().(DeclaredFunction).getFuncDecl()
  }
}

/** A representation of the function that is defined by a function literal. */
class FuncLitNode extends FunctionNode, ExprNode {
  override FuncLit expr;

  override ParameterNode getParameter(int i) { result = parameterNode(expr.getParameter(i)) }

  override string getName() { none() }

  override ReceiverNode getReceiver() { none() }

  override string toString() { result = "function literal" }

  override ResultNode getAResult() { result.getRoot() = getExpr() }
}

/** A data flow node that represents a call. */
class CallNode extends ExprNode {
  override CallExpr expr;

  /** Gets the declared target of this call */
  Function getTarget() { result = expr.getTarget() }

  private DataFlow::Node getACalleeSource() { result.getASuccessor*() = getCalleeNode() }

  /**
   * Gets the definition of a possible target of this call.
   *
   * For non-virtual calls, there is at most one possible call target (but there may be none if the
   * target has no declaration).
   *
   * For virtual calls, we look up possible targets in all types that implement the receiver
   * interface type.
   */
  FuncDef getACallee() {
    result = getTarget().(DeclaredFunction).getFuncDecl()
    or
    exists(DataFlow::Node calleeSource | calleeSource = getACalleeSource() |
      result = calleeSource.asExpr()
      or
      exists(Method declared, Method actual |
        calleeSource = declared.getARead() and
        actual.implements(declared) and
        result = actual.(DeclaredFunction).getFuncDecl()
      )
    )
  }

  /** Gets the name of the function or method being called, if it can be determined. */
  string getCalleeName() { result = expr.getTarget().getName() or result = expr.getCalleeName() }

  /** Gets the data flow node specifying the function to be called. */
  Node getCalleeNode() { result = exprNode(expr.getCalleeExpr()) }

  /** Gets the underlying call. */
  CallExpr getCall() { result = this.getExpr() }

  /**
   * Gets the data flow node corresponding to the `i`th argument of this call.
   *
   * Note that the first argument in calls to the built-in function `make` is a type, which is
   * not a data-flow node. It is skipped for the purposes of this predicate, so the (syntactically)
   * second argument becomes the first argument in terms of data flow.
   *
   * For calls of the form `f(g())` where `g` has multiple results, the arguments of the call to
   * `i` are the (implicit) element extraction nodes for the call to `g`.
   */
  Node getArgument(int i) {
    if expr.getArgument(0).getType() instanceof TupleType
    then result = extractTupleElement(exprNode(expr.getArgument(0)), i)
    else
      result = rank[i + 1](Expr arg, int j | arg = expr.getArgument(j) | exprNode(arg) order by j)
  }

  /** Gets the data flow node corresponding to an argument of this call. */
  Node getAnArgument() { result = this.getArgument(_) }

  /** Gets the number of arguments of this call, if it can be determined. */
  int getNumArgument() { result = count(this.getAnArgument()) }

  /** Gets a function passed as the `i`th argument of this call. */
  FunctionNode getCallback(int i) { result.getASuccessor*() = this.getArgument(i) }

  /**
   * Gets the data-flow node corresponding to the `i`th result of this call.
   *
   * If there is a single result then it is considered to be the 0th result.
   */
  Node getResult(int i) {
    i = 0 and result = getResult()
    or
    result = extractTupleElement(this, i)
  }

  /**
   * Gets the data-flow node corresponding to the result of this call.
   *
   * Note that this predicate is not defined for calls with multiple results; use the one-argument
   * variant `getResult(i)` for such calls.
   */
  Node getResult() { not getType() instanceof TupleType and result = this }

  /** Gets a result of this call. */
  Node getAResult() { result = this.getResult(_) }

  /** Gets the data flow node corresponding to the receiver of this call, if any. */
  Node getReceiver() { result = getACalleeSource().(MethodReadNode).getReceiver() }
}

/** A data flow node that represents a call to a method. */
class MethodCallNode extends CallNode {
  MethodCallNode() { expr.getTarget() instanceof Method }

  override Method getTarget() { result = expr.getTarget() }

  override MethodDecl getACallee() { result = super.getACallee() }
}

/** A representation of a parameter initialization. */
class ParameterNode extends SsaNode {
  override SsaExplicitDefinition ssa;
  Parameter parm;

  ParameterNode() { ssa.getInstruction() = IR::initParamInstruction(parm) }

  /** Gets the parameter this node initializes. */
  override Parameter asParameter() { result = parm }

  /** Holds if this node initializes the `i`th parameter of `fd`. */
  predicate isParameterOf(FuncDef fd, int i) { parm.isParameterOf(fd, i) }
}

/** A representation of a receiver initialization. */
class ReceiverNode extends ParameterNode {
  override ReceiverVariable parm;

  /** Gets the receiver variable this node initializes. */
  ReceiverVariable asReceiverVariable() { result = parm }

  /** Holds if this node initializes the receiver variable of `m`. */
  predicate isReceiverOf(MethodDecl m) { parm.isReceiverOf(m) }
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
 */
class PostUpdateNode extends Node {
  Node preupd;

  PostUpdateNode() {
    (
      preupd instanceof AddressOperationNode
      or
      preupd = any(AddressOperationNode addr).getOperand()
      or
      preupd = any(PointerDereferenceNode deref).getOperand()
      or
      exists(Write w, DataFlow::Node base |
        w.writesField(base, _, _) or w.writesElement(base, _, _)
      |
        preupd = base
        or
        preupd = base.(PointerDereferenceNode).getOperand()
      )
      or
      preupd instanceof ArgumentNode and
      mutableType(preupd.getType())
    ) and
    (
      preupd = this.(SsaNode).getAUse()
      or
      preupd = this and
      not basicLocalFlowStep(_, this)
    )
  }

  /**
   * Gets the node before the state update.
   */
  Node getPreUpdateNode() { result = preupd }
}

/**
 * A data-flow node that occurs as an argument in a call, including receiver arguments.
 */
class ArgumentNode extends Node {
  CallNode c;
  int i;

  ArgumentNode() { this = getArgument(c, i) }

  /**
   * Holds if this argument occurs at the given position in the given call.
   *
   * The receiver argument is considered to have index `-1`.
   *
   * Note that we currently do not track receiver arguments into calls to interface methods.
   */
  predicate argumentOf(CallExpr call, int pos) {
    call = c.asExpr() and
    pos = i and
    (
      i != -1
      or
      exists(c.(MethodCallNode).getTarget().getBody())
    )
  }

  /**
   * Gets the `CallNode` this is an argument to.
   */
  CallNode getCall() { result = c }
}

/**
 * Holds if `tp` is a type that may (directly or indirectly) reference a memory location.
 *
 * If a value with a mutable type is passed to a function, the function could potentially
 * mutate it or something it points to.
 */
predicate mutableType(Type tp) {
  exists(Type underlying | underlying = tp.getUnderlyingType() |
    not underlying instanceof BoolType and
    not underlying instanceof NumericType and
    not underlying instanceof StringType and
    not underlying instanceof LiteralType
  )
}

/**
 * A node whose value is returned as a result from a function.
 *
 * This can either be a node corresponding to an expression in a return statement,
 * or a node representing the current value of a named result variable at the exit
 * of the function.
 */
class ResultNode extends InstructionNode {
  FuncDef fd;
  int i;

  ResultNode() {
    exists(IR::ReturnInstruction ret | ret.getRoot() = fd | insn = ret.getResult(i))
    or
    insn.(IR::ReadResultInstruction).reads(fd.getResultVar(i))
  }
}

/**
 * A data-flow node that reads the value of a variable, constant, field or array element,
 * or refers to a function.
 */
class ReadNode extends InstructionNode {
  override IR::ReadInstruction insn;

  /**
   * Holds if this data-flow node evaluates to value of `v`, which is a value entity, that is, a
   * constant, variable, field, function, or method.
   */
  predicate reads(ValueEntity v) { insn.reads(v) }

  /**
   * Holds if this data-flow node reads the value of SSA variable `v`.
   */
  predicate readsSsaVariable(SsaVariable v) { insn = v.getAUse() }

  /**
   * Holds if this data-flow node reads the value of field `f` on the value of `base` or its
   * implicit dereference.
   *
   * For example, for the field read `x.width`, `base` is either the data-flow node corresponding
   * to `x` or (if `x` is a pointer) the data-flow node corresponding to the implicit dereference
   * `*x`, and `f` is the field referenced by `width`.
   */
  predicate readsField(Node base, Field f) {
    insn.readsField(base.asInstruction(), f)
    or
    insn.readsField(IR::implicitDerefInstruction(base.asExpr()), f)
  }

  /**
   * Holds if this data-flow node looks up method `m` on the value of `receiver` or its implicit
   * dereference.
   *
   * For example, for the method read `x.area`, `base` is either the data-flow node corresponding
   * to `x` or (if `x` is a pointer) the data-flow node corresponding to the implicit dereference
   * `*x`, and `m` is the method referenced by `area`.
   */
  predicate readsMethod(Node receiver, Method m) {
    insn.readsMethod(receiver.asInstruction(), m)
    or
    insn.readsMethod(IR::implicitDerefInstruction(receiver.asExpr()), m)
  }

  /**
   * Holds if this data-flow node reads the value of element `index` on the value of `base` or its
   * implicit dereference.
   *
   * For example, for the element read `xs[i]`, `base` is either the data-flow node corresponding
   * to `xs` or (if `xs` is a pointer) the data-flow node corresponding to the implicit dereference
   * `*xs`, and `index` is the data-flow node corresponding to `i`.
   */
  predicate readsElement(Node base, Node index) {
    insn.readsElement(base.asInstruction(), index.asInstruction())
    or
    insn.readsElement(IR::implicitDerefInstruction(base.asExpr()), index.asInstruction())
  }
}

/**
 * A data-flow node that reads an element of an array, map, slice or string.
 */
class ElementReadNode extends ReadNode {
  override IR::ElementReadInstruction insn;

  /** Gets the data-flow node representing the base from which the element is read. */
  Node getBase() { result = instructionNode(insn.getBase()) }

  /** Gets the data-flow node representing the index of the element being read. */
  Node getIndex() { result = instructionNode(insn.getIndex()) }

  /** Holds if this data-flow node reads element `index` of `base`. */
  predicate reads(Node base, Node index) { readsElement(base, index) }
}

/**
 * A data-flow node that extracts a substring or slice from a string, array, pointer to array,
 * or slice.
 */
class SliceNode extends InstructionNode {
  override IR::SliceInstruction insn;

  /** Gets the base of this slice node. */
  Node getBase() { result = instructionNode(insn.getBase()) }

  /** Gets the lower bound of this slice node. */
  Node getLow() { result = instructionNode(insn.getLow()) }

  /** Gets the upper bound of this slice node. */
  Node getHigh() { result = instructionNode(insn.getHigh()) }

  /** Gets the maximum of this slice node. */
  Node getMax() { result = instructionNode(insn.getMax()) }
}

/**
 * A data-flow node corresponding to an expression with a binary operator.
 */
class BinaryOperationNode extends Node {
  Node left;
  Node right;
  string op;

  BinaryOperationNode() {
    exists(BinaryExpr bin | bin = asExpr() |
      left = exprNode(bin.getLeftOperand()) and
      right = exprNode(bin.getRightOperand()) and
      op = bin.getOperator()
    )
    or
    exists(IR::EvalCompoundAssignRhsInstruction rhs, CompoundAssignStmt assgn, string o |
      rhs = asInstruction() and assgn = rhs.getAssignment() and o = assgn.getOperator()
    |
      left = exprNode(assgn.getLhs()) and
      right = exprNode(assgn.getRhs()) and
      op = o.substring(0, o.length() - 1)
    )
    or
    exists(IR::EvalIncDecRhsInstruction rhs, IncDecStmt ids |
      rhs = asInstruction() and ids = rhs.getStmt()
    |
      left = exprNode(ids.getOperand()) and
      right = instructionNode(any(IR::EvalImplicitOneInstruction one | one.getStmt() = ids)) and
      op = ids.getOperator().charAt(0)
    )
  }

  /** Holds if this operation may have observable side effects. */
  predicate mayHaveSideEffects() { asExpr().mayHaveOwnSideEffects() }

  /** Gets the left operand of this operation. */
  Node getLeftOperand() { result = left }

  /** Gets the right operand of this operation. */
  Node getRightOperand() { result = right }

  /** Gets an operand of this operation. */
  Node getAnOperand() { result = left or result = right }

  /** Gets the operator of this operation. */
  string getOperator() { result = op }
}

/**
 * A data-flow node corresponding to an expression with a unary operator.
 */
class UnaryOperationNode extends InstructionNode {
  UnaryOperationNode() {
    asExpr() instanceof UnaryExpr
    or
    asExpr() instanceof StarExpr
    or
    insn instanceof IR::EvalImplicitDerefInstruction
  }

  /** Holds if this operation may have observable side effects. */
  predicate mayHaveSideEffects() {
    asExpr().mayHaveOwnSideEffects()
    or
    insn instanceof IR::EvalImplicitDerefInstruction
  }

  /** Gets the operand of this operation. */
  Node getOperand() {
    result = exprNode(asExpr().(UnaryExpr).getOperand())
    or
    result = exprNode(asExpr().(StarExpr).getBase())
    or
    result = exprNode(insn.(IR::EvalImplicitDerefInstruction).getOperand())
  }

  /** Gets the operator of this operation. */
  string getOperator() {
    result = asExpr().(UnaryExpr).getOperator()
    or
    asExpr() instanceof StarExpr and
    result = "*"
    or
    insn instanceof IR::EvalImplicitDerefInstruction and
    result = "*"
  }
}

/**
 * A data-flow node that dereferences a pointer.
 */
class PointerDereferenceNode extends UnaryOperationNode {
  PointerDereferenceNode() {
    asExpr() instanceof StarExpr
    or
    asExpr() instanceof DerefExpr
    or
    insn instanceof IR::EvalImplicitDerefInstruction
  }
}

/**
 * A data-flow node that takes the address of a memory location.
 */
class AddressOperationNode extends UnaryOperationNode, ExprNode {
  override AddressExpr expr;
}

/**
 * A data-flow node that reads the value of a field.
 */
class FieldReadNode extends ReadNode {
  override IR::FieldReadInstruction insn;

  /** Gets the base node from which the field is read. */
  Node getBase() { result = instructionNode(insn.getBase()) }

  /** Gets the field this node reads. */
  Field getField() { result = insn.getField() }

  /** Gets the name of the field this node reads. */
  string getFieldName() { result = this.getField().getName() }
}

/**
 * A data-flow node that refers to a method.
 */
class MethodReadNode extends ReadNode {
  override IR::MethodReadInstruction insn;

  /** Gets the receiver node on which the method is referenced. */
  Node getReceiver() { result = instructionNode(insn.getReceiver()) }

  /** Gets the method this node refers to. */
  Method getMethod() { result = insn.getMethod() }

  /** Gets the name of the method this node refers to. */
  string getMethodName() { result = this.getMethod().getName() }
}

/**
 * A data-flow node performing a relational comparison using `<`, `<=`, `>` or `>=`.
 */
class RelationalComparisonNode extends BinaryOperationNode, ExprNode {
  override RelationalComparisonExpr expr;

  /** Holds if this comparison evaluates to `outcome` iff `lesser <= greater + bias`. */
  predicate leq(boolean outcome, Node lesser, Node greater, int bias) {
    outcome = true and
    lesser = exprNode(expr.getLesserOperand()) and
    greater = exprNode(expr.getGreaterOperand()) and
    (if expr.isStrict() then bias = -1 else bias = 0)
    or
    outcome = false and
    lesser = exprNode(expr.getGreaterOperand()) and
    greater = exprNode(expr.getLesserOperand()) and
    (if expr.isStrict() then bias = 0 else bias = -1)
  }
}

/**
 * A data-flow node performing an equality test using `==` or `!=`.
 */
class EqualityTestNode extends BinaryOperationNode, ExprNode {
  override EqualityTestExpr expr;

  /** Holds if this comparison evaluates to `outcome` iff `lhs == rhs`. */
  predicate eq(boolean outcome, Node lhs, Node rhs) {
    outcome = expr.getPolarity() and
    expr.hasOperands(lhs.asExpr(), rhs.asExpr())
  }

  /** Gets the polarity of this equality test, that is, `true` for `==` and `false` for `!=`. */
  boolean getPolarity() { result = expr.getPolarity() }
}

/**
 * A data-flow node performing a type cast using either a type conversion
 * or an assertion.
 */
class TypeCastNode extends ExprNode {
  TypeCastNode() {
    expr instanceof TypeAssertExpr
    or
    expr instanceof ConversionExpr
  }

  /** Gets the operand of the type cast. */
  DataFlow::Node getOperand() {
    result.asExpr() = expr.(TypeAssertExpr).getExpr()
    or
    result.asExpr() = expr.(ConversionExpr).getOperand()
  }
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
}

/**
 * Gets the `Node` corresponding to `insn`.
 */
InstructionNode instructionNode(IR::Instruction insn) { result = MkInstructionNode(insn) }

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
 * with multiple results or an iterator in a range loop).
 */
Node extractTupleElement(Node t, int i) {
  exists(IR::Instruction insn | t = instructionNode(insn) |
    result = instructionNode(IR::extractTupleElement(insn, i))
  )
}

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
predicate localFlowStep(Node nodeFrom, Node nodeTo) { simpleLocalFlowStep(nodeFrom, nodeTo) }

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step, not taking function models into account.
 */
private predicate basicLocalFlowStep(Node nodeFrom, Node nodeTo) {
  // Instruction -> Instruction
  exists(Expr pred, Expr succ |
    succ.(LogicalBinaryExpr).getAnOperand() = pred or
    succ.(ConversionExpr).getOperand() = pred or
    succ.(TypeAssertExpr).getExpr() = pred
  |
    nodeFrom = exprNode(pred) and
    nodeTo = exprNode(succ)
  )
  or
  // Instruction -> SSA
  exists(IR::Instruction pred, SsaExplicitDefinition succ |
    succ.getRhs() = pred and
    nodeFrom = MkInstructionNode(pred) and
    nodeTo = MkSsaNode(succ)
  )
  or
  // SSA -> SSA
  exists(SsaDefinition pred, SsaDefinition succ |
    succ.(SsaVariableCapture).getSourceVariable() = pred.(SsaExplicitDefinition).getSourceVariable() or
    succ.(SsaPseudoDefinition).getAnInput() = pred
  |
    nodeFrom = MkSsaNode(pred) and
    nodeTo = MkSsaNode(succ)
  )
  or
  // SSA -> Instruction
  exists(SsaDefinition pred, IR::Instruction succ |
    succ = pred.getVariable().getAUse() and
    nodeFrom = MkSsaNode(pred) and
    nodeTo = MkInstructionNode(succ)
  )
  or
  // GlobalFunctionNode -> use
  nodeFrom = MkGlobalFunctionNode(nodeTo.asExpr().(FunctionName).getTarget())
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
  exists(FunctionModel m, CallNode c, FunctionInput inp, FunctionOutput outp |
    c = m.getACall() and
    m.hasDataFlow(inp, outp) and
    nodeFrom = inp.getNode(c) and
    nodeTo = outp.getNode(c)
  )
}

/**
 * Holds if data flows from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

/**
 * A guard that validates some expression.
 *
 * To use this in a configuration, extend the class and provide a
 * characteristic predicate precisely specifying the guard, and override
 * `checks` to specify what is being validated and in which branch.
 *
 * It is important that all extending classes in scope are disjoint.
 */
abstract class BarrierGuard extends Node {
  /** Holds if this guard validates `e` upon evaluating to `branch`. */
  abstract predicate checks(Expr e, boolean branch);

  /** Gets a node guarded by this guard. */
  final Node getAGuardedNode() {
    exists(ControlFlow::ConditionGuardNode guard, Node nd, SsaWithFields var |
      result = var.getAUse()
    |
      guards(guard, nd, var) and
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
    guards(guard, nd) and nd = ap.getAUse()
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
      guardingFunction(f, inp, outp, p) and
      c = f.getACall() and
      nd = inp.getNode(c) and
      localFlow(outp.getNode(c), resNode) and
      p.checkOn(check, outcome, resNode) and
      guard.ensures(check, outcome)
    )
  }

  /**
   * Holds if whenever `p` holds of output `outp` of function `f`, this node
   * is known to validate the input `inp` of `f`.
   *
   * We check this by looking for guards on `inp` that dominate a `return` statement that
   * is the only `return` in `f` that can return `true`. This means that if `f` returns `true`,
   * the guard must have been satisfied. (Similar reasoning is applied for statements returning
   * `false` or a non-`nil` value.)
   */
  private predicate guardingFunction(
    Function f, FunctionInput inp, FunctionOutput outp, DataFlow::Property p
  ) {
    exists(ControlFlow::ConditionGuardNode guard, Node arg, FuncDecl fd, Node ret |
      fd.getFunction() = f and
      guards(guard, arg) and
      localFlow(inp.getExitNode(fd), arg) and
      ret = outp.getEntryNode(fd) and
      guard.dominates(ret.getBasicBlock())
    |
      exists(boolean b |
        onlyPossibleReturnOfBool(fd, outp, ret, b) and
        p.isBoolean(b)
      )
      or
      onlyPossibleReturnOfNonNil(fd, outp, ret) and
      p.isNonNil()
    )
  }
}

/**
 * Holds if `ret` is a data-flow node whose value contributes to the output `res` of `fd`,
 * and that node may have Boolean value `b`.
 */
private predicate possiblyReturnsBool(FuncDecl fd, FunctionOutput res, Node ret, Boolean b) {
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
private predicate possiblyReturnsNonNil(FuncDecl fd, FunctionOutput res, Node ret) {
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
