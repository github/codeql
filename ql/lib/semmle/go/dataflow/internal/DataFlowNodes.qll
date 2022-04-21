private import go
private import semmle.go.dataflow.FunctionInputsAndOutputs
private import semmle.go.dataflow.FlowSummary
private import DataFlowPrivate
private import FlowSummaryImpl as FlowSummaryImpl
private import semmle.go.dataflow.ExternalFlow

cached
private newtype TNode =
  MkInstructionNode(IR::Instruction insn) or
  MkSsaNode(SsaDefinition ssa) or
  MkGlobalFunctionNode(Function f) or
  MkSummarizedParameterNode(DataFlowCallable c, int i) {
    not exists(c.getFuncDef()) and
    c instanceof SummarizedCallable and
    (
      i in [0 .. c.getType().getNumParameter() - 1]
      or
      c.asFunction() instanceof Method and i = -1
    )
  } or
  MkSummaryInternalNode(SummarizedCallable c, FlowSummaryImpl::Private::SummaryNodeState state) {
    FlowSummaryImpl::Private::summaryNodeRange(c, state)
  }

/** Nodes intended for only use inside the data-flow libraries. */
module Private {
  /** Gets the callable in which this node occurs. */
  DataFlowCallable nodeGetEnclosingCallable(Node n) {
    result.asCallable() = n.getEnclosingCallable()
    or
    not exists(n.getEnclosingCallable()) and result.asFileScope() = n.getFile()
  }

  /** Holds if `p` is a `ParameterNode` of `c` with position `pos`. */
  predicate isParameterNode(ParameterNode p, DataFlowCallable c, int pos) {
    p.isParameterOf(c.asCallable(), pos)
  }

  /** A data flow node that represents returning a value from a function. */
  class ReturnNode extends Node {
    ReturnKind kind;

    ReturnNode() {
      this.(Public::ResultNode).getIndex() = kind.getIndex()
      or
      this.(SummaryNode).isReturn(kind)
    }

    /** Gets the kind of this returned value. */
    ReturnKind getKind() { result = kind }
  }

  /** A data flow node that represents the output of a call. */
  class OutNode extends Node {
    DataFlow::CallNode call;
    int i;

    OutNode() { this = call.getResult(i) }

    /** Gets the underlying call. */
    DataFlowCall getCall() { result = call.asExpr() }
  }

  /**
   * A data-flow node used to model flow summaries.
   */
  class SummaryNode extends Node, MkSummaryInternalNode {
    private SummarizedCallable c;
    private FlowSummaryImpl::Private::SummaryNodeState state;

    SummaryNode() { this = MkSummaryInternalNode(c, state) }

    override predicate hasLocationInfo(string fp, int sl, int sc, int el, int ec) {
      c.hasLocationInfo(fp, sl, sc, el, ec)
    }

    override string toString() { result = "[summary] " + state + " in " + c }

    /** Holds if this summary node is the `i`th argument of `call`. */
    predicate isArgumentOf(DataFlowCall call, int i) {
      FlowSummaryImpl::Private::summaryArgumentNode(call, this, i)
    }

    /** Holds if this summary node is a return node. */
    predicate isReturn(ReturnKind kind) { FlowSummaryImpl::Private::summaryReturnNode(this, kind) }

    /** Holds if this summary node is an out node for `call`. */
    predicate isOut(DataFlowCall call) { FlowSummaryImpl::Private::summaryOutNode(call, this, _) }
  }

  /** Gets the summary node corresponding to the callable `c` and state `state`. */
  SummaryNode getSummaryNode(SummarizedCallable c, FlowSummaryImpl::Private::SummaryNodeState state) {
    result = MkSummaryInternalNode(c, state)
  }
}

/** Nodes intended for use outside the data-flow libraries. */
module Public {
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
    Callable getEnclosingCallable() {
      result.getFuncDef() = this.getRoot()
      or
      exists(DataFlowCallable dfc | result = dfc.asCallable() |
        this = MkSummarizedParameterNode(dfc, _)
        or
        this = MkSummaryInternalNode(dfc, _)
      )
    }

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
    BasicBlock getBasicBlock() { result = this.asInstruction().getBasicBlock() }

    /** Gets a textual representation of this element. */
    string toString() { result = "data-flow node" } // overridden in subclasses

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
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
    File getFile() { this.hasLocationInfo(result.getAbsolutePath(), _, _, _, _) }

    /** Gets the start line of the location of this node. */
    int getStartLine() { this.hasLocationInfo(_, result, _, _, _) }

    /** Gets the start column of the location of this node. */
    int getStartColumn() { this.hasLocationInfo(_, _, result, _, _) }

    /** Gets the end line of the location of this node. */
    int getEndLine() { this.hasLocationInfo(_, _, _, result, _) }

    /** Gets the end column of the location of this node. */
    int getEndColumn() { this.hasLocationInfo(_, _, _, _, result) }

    /**
     * Gets an upper bound on the type of this node.
     */
    Type getTypeBound() { result = this.getType() }

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
    predicate isPlatformIndependentConstant() {
      this.asInstruction().isPlatformIndependentConstant()
    }

    /**
     * Gets a data-flow node to which data may flow from this node in one (intra-procedural) step.
     */
    Node getASuccessor() { DataFlow::localFlowStep(this, result) }

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
    Node getInit() { result = DataFlow::instructionNode(ssa.(SsaExplicitDefinition).getRhs()) }

    /** Gets a use of this SSA variable. */
    InstructionNode getAUse() { result = DataFlow::instructionNode(ssa.getVariable().getAUse()) }

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

  private module FunctionNode {
    /** A function, viewed as a node in a data flow graph. */
    abstract class Range extends Node {
      /** Gets the `i`th parameter of this function. */
      abstract ParameterNode getParameter(int i);

      /** Gets the name of this function, if it has one. */
      abstract string getName();

      /**
       * Gets the dataflow node holding the value of the receiver, if any.
       */
      abstract ReceiverNode getReceiver();

      /**
       * Gets a value returned by the given function via a return statement or an assignment to a
       * result variable.
       */
      abstract ResultNode getAResult();

      /**
       * Gets the function entity this node corresponds to.
       *
       * Note that this predicate has no result for function literals.
       */
      Function getFunction() { none() }
    }
  }

  /** A function, viewed as a node in a data flow graph. */
  class FunctionNode extends Node {
    FunctionNode::Range self;

    FunctionNode() { this = self }

    /** Gets the `i`th parameter of this function. */
    ParameterNode getParameter(int i) { result = self.getParameter(i) }

    /** Gets a parameter of this function. */
    ParameterNode getAParameter() { result = this.getParameter(_) }

    /** Gets the number of parameters declared on this function. */
    int getNumParameter() { result = count(this.getAParameter()) }

    /** Gets the name of this function, if it has one. */
    string getName() { result = self.getName() }

    /**
     * Gets the dataflow node holding the value of the receiver, if any.
     */
    ReceiverNode getReceiver() { result = self.getReceiver() }

    /**
     * Gets a value returned by the given function via a return statement or an assignment to a
     * result variable.
     */
    ResultNode getAResult() { result = self.getAResult() }

    /**
     * Gets the data-flow node corresponding to the `i`th result of this function.
     */
    ResultNode getResult(int i) { result = this.getAResult() and result.getIndex() = i }

    /**
     * Gets the function entity this node corresponds to.
     *
     * Note that this predicate has no result for function literals.
     */
    Function getFunction() { result = self.getFunction() }
  }

  /** A representation of a function that is declared in the module scope. */
  class GlobalFunctionNode extends FunctionNode::Range, MkGlobalFunctionNode {
    Function func;

    GlobalFunctionNode() { this = MkGlobalFunctionNode(func) }

    override ParameterNode getParameter(int i) {
      result = DataFlow::parameterNode(func.getParameter(i))
    }

    override string getName() { result = func.getName() }

    override Function getFunction() { result = func }

    override ReceiverNode getReceiver() {
      result = DataFlow::receiverNode(func.(Method).getReceiver())
    }

    override string getNodeKind() { result = "function " + func.getName() }

    override string toString() { result = "function " + func.getName() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      func.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override ResultNode getAResult() {
      result.getRoot() = this.getFunction().(DeclaredFunction).getFuncDecl()
    }
  }

  /** A representation of the function that is defined by a function literal. */
  class FuncLitNode extends FunctionNode::Range, ExprNode {
    override FuncLit expr;

    override ParameterNode getParameter(int i) {
      result = DataFlow::parameterNode(expr.getParameter(i))
    }

    override string getName() { none() }

    override ReceiverNode getReceiver() { none() }

    override string toString() { result = "function literal" }

    override ResultNode getAResult() { result.getRoot() = this.getExpr() }
  }

  /**
   * Gets a possible target of call `cn`.class
   *
   * This is written explicitly like this instead of using `getCalleeNode().getAPredecessor*()`
   * or `result.getASuccessor*() = cn.getCalleeNode()` because the explicit form inhibits the
   * optimizer from combining this with other uses of `getASuccessor*()`, which can lead to
   * recursion through a magic side-condition if those other users call `getACallee()` and thus
   * pointless recomputation of `getACallee()` each recursive iteration.
   */
  private DataFlow::Node getACalleeSource(DataFlow::CallNode cn) {
    result = cn.getCalleeNode() or
    basicLocalFlowStep(result, getACalleeSource(cn))
  }

  /** A data flow node that represents a call. */
  class CallNode extends ExprNode {
    override CallExpr expr;

    /** Gets the declared target of this call */
    Function getTarget() { result = expr.getTarget() }

    private DataFlow::Node getACalleeSource() { result = getACalleeSource(this) }

    /**
     * Gets the definition of a possible target of this call.
     *
     * For non-virtual calls, there is at most one possible call target (but there may be none if the
     * target has no declaration).
     *
     * For virtual calls, we look up possible targets in all types that implement the receiver
     * interface type.
     */
    Callable getACalleeIncludingExternals() {
      result.asFunction() = this.getTarget()
      or
      exists(DataFlow::Node calleeSource | calleeSource = this.getACalleeSource() |
        result.asFuncLit() = calleeSource.asExpr()
        or
        calleeSource = result.asFunction().getARead()
        or
        exists(Method declared, Method actual |
          calleeSource = declared.getARead() and
          actual.implements(declared) and
          result.asFunction() = actual
        )
      )
    }

    /**
     * As `getACalleeIncludingExternals`, except excluding external functions (those for which
     * we lack a definition, such as standard library functions).
     */
    FuncDef getACallee() { result = this.getACalleeIncludingExternals().getFuncDef() }

    /**
     * Gets the name of the function, method or variable that is being called.
     *
     * Note that if we are calling a variable then this gets the variable name.
     * It does not attempt to get the name of the function or method that is
     * assigned to the variable. To do that, use
     * `getACalleeIncludingExternals().asFunction().getName()`.
     */
    string getCalleeName() { result = expr.getCalleeName() }

    /** Gets the data flow node specifying the function to be called. */
    Node getCalleeNode() { result = DataFlow::exprNode(expr.getCalleeExpr()) }

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
      then result = DataFlow::extractTupleElement(DataFlow::exprNode(expr.getArgument(0)), i)
      else
        result =
          rank[i + 1](Expr arg, int j |
            arg = expr.getArgument(j)
          |
            DataFlow::exprNode(arg) order by j
          )
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
      i = 0 and result = this.getResult()
      or
      result = DataFlow::extractTupleElement(this, i)
    }

    /**
     * Gets the data-flow node corresponding to the result of this call.
     *
     * Note that this predicate is not defined for calls with multiple results; use the one-argument
     * variant `getResult(i)` for such calls.
     */
    Node getResult() { not this.getType() instanceof TupleType and result = this }

    /** Gets a result of this call. */
    Node getAResult() { result = this.getResult(_) }

    /** Gets the data flow node corresponding to the receiver of this call, if any. */
    Node getReceiver() { result = this.getACalleeSource().(MethodReadNode).getReceiver() }

    /** Holds if this call has an ellipsis after its last argument. */
    predicate hasEllipsis() { expr.hasEllipsis() }
  }

  /** A data flow node that represents a call to a method. */
  class MethodCallNode extends CallNode {
    MethodCallNode() { expr.getTarget() instanceof Method }

    override Method getTarget() { result = expr.getTarget() }

    override MethodDecl getACallee() { result = super.getACallee() }
  }

  /** A representation of a parameter initialization. */
  abstract class ParameterNode extends DataFlow::Node {
    /** Holds if this node initializes the `i`th parameter of `c`. */
    abstract predicate isParameterOf(Callable c, int i);
  }

  /**
   * A summary node which represents a parameter in a function which doesn't
   * already have a parameter nodes.
   */
  class SummarizedParameterNode extends ParameterNode, MkSummarizedParameterNode {
    Callable c;
    int i;

    SummarizedParameterNode() {
      this = MkSummarizedParameterNode(any(DataFlowCallable dfc | c = dfc.asCallable()), i)
    }

    // There are no AST representations of summarized parameter nodes
    override ControlFlow::Root getRoot() { none() }

    override string getNodeKind() { result = "external parameter node" }

    override Type getType() {
      result = c.getType().getParameterType(i)
      or
      i = -1 and result = c.asFunction().(Method).getReceiverType()
    }

    override predicate isParameterOf(Callable call, int idx) { c = call and i = idx }

    override string toString() { result = "parameter " + i + " of " + c.toString() }

    override predicate hasLocationInfo(string fp, int sl, int sc, int el, int ec) {
      c.hasLocationInfo(fp, sl, sc, el, ec)
    }
  }

  /** A representation of a parameter initialization, defined in source via an SSA node. */
  class SsaParameterNode extends ParameterNode, SsaNode {
    override SsaExplicitDefinition ssa;
    Parameter parm;

    SsaParameterNode() { ssa.getInstruction() = IR::initParamInstruction(parm) }

    /** Gets the parameter this node initializes. */
    override Parameter asParameter() { result = parm }

    override predicate isParameterOf(Callable c, int i) { parm.isParameterOf(c.getFuncDef(), i) }
  }

  /** A representation of a receiver initialization. */
  class ReceiverNode extends SsaParameterNode {
    override ReceiverVariable parm;

    /** Gets the receiver variable this node initializes. */
    ReceiverVariable asReceiverVariable() { result = parm }

    /** Holds if this node initializes the receiver variable of `m`. */
    predicate isReceiverOf(MethodDecl m) { parm.isReceiverOf(m) }
  }

  private Node getADirectlyWrittenNode() {
    exists(Write w | w.writesField(result, _, _) or w.writesElement(result, _, _))
  }

  private DataFlow::Node getAccessPathPredecessor(DataFlow::Node node) {
    result = node.(PointerDereferenceNode).getOperand()
    or
    result = node.(ComponentReadNode).getBase()
  }

  private Node getAWrittenNode() { result = getAccessPathPredecessor*(getADirectlyWrittenNode()) }

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
  abstract class PostUpdateNode extends Node {
    /**
     * Gets the node before the state update.
     */
    abstract Node getPreUpdateNode();
  }

  private class DefaultPostUpdateNode extends PostUpdateNode {
    Node preupd;

    DefaultPostUpdateNode() {
      (
        preupd instanceof AddressOperationNode
        or
        preupd = any(AddressOperationNode addr).getOperand()
        or
        preupd = any(PointerDereferenceNode deref).getOperand()
        or
        preupd = getAWrittenNode()
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

    override Node getPreUpdateNode() { result = preupd }
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
        or
        hasExternalSpecification(c.(DataFlow::MethodCallNode).getTarget())
      )
    }

    /**
     * Gets the `CallNode` this is an argument to.
     */
    CallNode getCall() { result = c }
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

    /** Gets the index of this result among all results of the function. */
    int getIndex() { result = i }
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
     * Holds if this data-flow node reads the value of field `package.type.field` on the value of `base` or its
     * implicit dereference.
     *
     * For example, for the field read `x.width`, `base` is either the data-flow node corresponding
     * to `x` or (if `x` is a pointer) the data-flow node corresponding to the implicit dereference
     * `*x`, and `x` has the type `package.type`.
     */
    predicate readsField(Node base, string package, string type, string field) {
      exists(Field f | f.hasQualifiedName(package, type, field) | this.readsField(base, f))
    }

    /**
     * Holds if this data-flow node looks up method `m` on the value of `receiver` or its implicit
     * dereference.
     *
     * For example, for the method read `x.area`, `receiver` is either the data-flow node corresponding
     * to `x` or (if `x` is a pointer) the data-flow node corresponding to the implicit dereference
     * `*x`, and `m` is the method referenced by `area`.
     */
    predicate readsMethod(Node receiver, Method m) {
      insn.readsMethod(receiver.asInstruction(), m)
      or
      insn.readsMethod(IR::implicitDerefInstruction(receiver.asExpr()), m)
    }

    /**
     * Holds if this data-flow node looks up method `package.type.name` on the value of `receiver`
     * or its implicit dereference.
     *
     * For example, for the method read `x.name`, `receiver` is either the data-flow node corresponding
     * to `x` or (if `x` is a pointer) the data-flow node corresponding to the implicit dereference
     * `*x`, and `package.type` is a type of `x` that defines a method named `name`.
     */
    predicate readsMethod(Node receiver, string package, string type, string name) {
      exists(Method m | m.hasQualifiedName(package, type, name) | this.readsMethod(receiver, m))
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
   * A data-flow node that reads the value of a field from a struct, or an element from an array, slice, map or string.
   */
  class ComponentReadNode extends ReadNode {
    override IR::ComponentReadInstruction insn;

    /** Gets the data-flow node representing the base from which the field or element is read. */
    Node getBase() { result = DataFlow::instructionNode(insn.getBase()) }
  }

  /**
   * A data-flow node that reads an element of an array, map, slice or string.
   */
  class ElementReadNode extends ComponentReadNode {
    override IR::ElementReadInstruction insn;

    /** Gets the data-flow node representing the index of the element being read. */
    Node getIndex() { result = DataFlow::instructionNode(insn.getIndex()) }

    /** Holds if this data-flow node reads element `index` of `base`. */
    predicate reads(Node base, Node index) { this.readsElement(base, index) }
  }

  /**
   * A data-flow node that extracts a substring or slice from a string, array, pointer to array,
   * or slice.
   */
  class SliceNode extends InstructionNode {
    override IR::SliceInstruction insn;

    /** Gets the base of this slice node. */
    Node getBase() { result = DataFlow::instructionNode(insn.getBase()) }

    /** Gets the lower bound of this slice node. */
    Node getLow() { result = DataFlow::instructionNode(insn.getLow()) }

    /** Gets the upper bound of this slice node. */
    Node getHigh() { result = DataFlow::instructionNode(insn.getHigh()) }

    /** Gets the maximum of this slice node. */
    Node getMax() { result = DataFlow::instructionNode(insn.getMax()) }
  }

  /**
   * A data-flow node corresponding to an expression with a binary operator.
   */
  class BinaryOperationNode extends Node {
    Node left;
    Node right;
    string op;

    BinaryOperationNode() {
      exists(BinaryExpr bin | bin = this.asExpr() |
        left = DataFlow::exprNode(bin.getLeftOperand()) and
        right = DataFlow::exprNode(bin.getRightOperand()) and
        op = bin.getOperator()
      )
      or
      exists(IR::EvalCompoundAssignRhsInstruction rhs, CompoundAssignStmt assgn, string o |
        rhs = this.asInstruction() and assgn = rhs.getAssignment() and o = assgn.getOperator()
      |
        left = DataFlow::exprNode(assgn.getLhs()) and
        right = DataFlow::exprNode(assgn.getRhs()) and
        op = o.substring(0, o.length() - 1)
      )
      or
      exists(IR::EvalIncDecRhsInstruction rhs, IncDecStmt ids |
        rhs = this.asInstruction() and ids = rhs.getStmt()
      |
        left = DataFlow::exprNode(ids.getOperand()) and
        right =
          DataFlow::instructionNode(any(IR::EvalImplicitOneInstruction one | one.getStmt() = ids)) and
        op = ids.getOperator().charAt(0)
      )
    }

    /** Holds if this operation may have observable side effects. */
    predicate mayHaveSideEffects() { this.asExpr().mayHaveOwnSideEffects() }

    /** Gets the left operand of this operation. */
    Node getLeftOperand() { result = left }

    /** Gets the right operand of this operation. */
    Node getRightOperand() { result = right }

    /** Gets an operand of this operation. */
    Node getAnOperand() { result = left or result = right }

    /** Gets the operator of this operation. */
    string getOperator() { result = op }

    /** Holds if `x` and `y` are the operands of this operation, in either order. */
    predicate hasOperands(Node x, Node y) {
      x = this.getAnOperand() and
      y = this.getAnOperand() and
      x != y
    }
  }

  /**
   * A data-flow node corresponding to an expression with a unary operator.
   */
  class UnaryOperationNode extends InstructionNode {
    UnaryOperationNode() {
      this.asExpr() instanceof UnaryExpr
      or
      this.asExpr() instanceof StarExpr
      or
      insn instanceof IR::EvalImplicitDerefInstruction
    }

    /** Holds if this operation may have observable side effects. */
    predicate mayHaveSideEffects() {
      this.asExpr().mayHaveOwnSideEffects()
      or
      insn instanceof IR::EvalImplicitDerefInstruction
    }

    /** Gets the operand of this operation. */
    Node getOperand() {
      result = DataFlow::exprNode(this.asExpr().(UnaryExpr).getOperand())
      or
      result = DataFlow::exprNode(this.asExpr().(StarExpr).getBase())
      or
      result = DataFlow::exprNode(insn.(IR::EvalImplicitDerefInstruction).getOperand())
    }

    /** Gets the operator of this operation. */
    string getOperator() {
      result = this.asExpr().(UnaryExpr).getOperator()
      or
      this.asExpr() instanceof StarExpr and
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
      this.asExpr() instanceof StarExpr
      or
      this.asExpr() instanceof DerefExpr
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
  class FieldReadNode extends ComponentReadNode {
    override IR::FieldReadInstruction insn;

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
    Node getReceiver() { result = DataFlow::instructionNode(insn.getReceiver()) }

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
      lesser = DataFlow::exprNode(expr.getLesserOperand()) and
      greater = DataFlow::exprNode(expr.getGreaterOperand()) and
      (if expr.isStrict() then bias = -1 else bias = 0)
      or
      outcome = false and
      lesser = DataFlow::exprNode(expr.getGreaterOperand()) and
      greater = DataFlow::exprNode(expr.getLesserOperand()) and
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

    /**
     * Gets the type being converted to. Note this differs from `this.getType()` for
     * `TypeAssertExpr`s that return a (result, ok) tuple.
     */
    Type getResultType() {
      if this.getType() instanceof TupleType
      then result = this.getType().(TupleType).getComponentType(0)
      else result = this.getType()
    }

    /** Gets the operand of the type cast. */
    DataFlow::Node getOperand() {
      result.asExpr() = expr.(TypeAssertExpr).getExpr()
      or
      result.asExpr() = expr.(ConversionExpr).getOperand()
    }
  }

  /**
   * A data-flow node representing an element of an array, map, slice or string defined from `range` statement.
   *
   * Example: in `_, x := range y { ... }`, this represents the `Node` that extracts the element from the
   * range statement, which will flow to `x`.
   */
  class RangeElementNode extends Node {
    DataFlow::Node base;
    IR::ExtractTupleElementInstruction extract;

    RangeElementNode() {
      this.asInstruction() = extract and
      extract.extractsElement(_, 1) and
      extract.getBase().(IR::GetNextEntryInstruction).getDomain() = base.asInstruction()
    }

    /** Gets the data-flow node representing the base from which the element is read. */
    DataFlow::Node getBase() { result = base }
  }

  /**
   * A data-flow node representing an index of an array, map, slice or string defined from `range` statement.
   *
   * Example: in `i, _ := range y { ... }`, this represents the `Node` that extracts the index from the
   * range statement, which will flow to `i`.
   */
  class RangeIndexNode extends Node {
    DataFlow::Node base;

    RangeIndexNode() {
      // when there is a comma, as in `i, x := range y { ... }`
      exists(IR::ExtractTupleElementInstruction extract |
        this.asInstruction() = extract and
        extract.extractsElement(_, 0) and
        extract.getBase().(IR::GetNextEntryInstruction).getDomain() = base.asInstruction()
      )
      or
      // when there is no comma, as in `i := range y { ... }`
      not exists(IR::ExtractTupleElementInstruction extract |
        extract.getBase() = this.asInstruction()
      ) and
      base.asInstruction() = this.asInstruction().(IR::GetNextEntryInstruction).getDomain()
    }

    /** Gets the data-flow node representing the base from which the element is read. */
    DataFlow::Node getBase() { result = base }
  }
}

private import Private
private import Public

class SummaryPostUpdateNode extends SummaryNode, PostUpdateNode {
  private Node pre;

  SummaryPostUpdateNode() { FlowSummaryImpl::Private::summaryPostUpdateNode(this, pre) }

  override Node getPreUpdateNode() { result = pre }
}
