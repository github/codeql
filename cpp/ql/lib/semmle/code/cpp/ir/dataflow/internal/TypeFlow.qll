private import cpp
private import semmle.code.cpp.ir.IR
private import codeql.typeflow.TypeFlow

private module Input implements TypeFlowInput<Location> {
  /** Holds if `alloc` dynamically allocates a single object. */
  private predicate isSingleObjectAllocation(AllocationExpr alloc) {
    // i.e., `new int`;
    alloc instanceof NewExpr
    or
    // i.e., `malloc(sizeof(int))`
    exists(SizeofTypeOperator sizeOf | sizeOf = alloc.getSizeExpr() |
      not sizeOf.getTypeOperand().getUnspecifiedType() instanceof ArrayType
    )
  }

  /**
   * Holds if `i` is the result of a dynamic allocation.
   *
   * `isObject` is `true` if the allocation allocated a single object,
   * and `false` otherwise.
   */
  private predicate isAllocation(Instruction i, boolean isObject) {
    exists(AllocationExpr alloc | alloc = i.getUnconvertedResultExpression() |
      if isSingleObjectAllocation(alloc) then isObject = true else isObject = false
    )
  }

  private predicate hasExactSingleType(Instruction i) {
    // The address of a variable is always a single object (unless it's an array)
    exists(VariableAddressInstruction vai |
      i = vai and
      not vai.getResultType() instanceof ArrayType
    )
    or
    // A reference always points to a single object
    i.getResultLanguageType().hasUnspecifiedType(any(ReferenceType rt), false)
    or
    // `this` is never an array
    i instanceof InitializeThisInstruction
    or
    // An allocation of a non-array object
    isAllocation(i, true)
  }

  private predicate hasExactBufferType(Instruction i) {
    // Anything with an array type is a buffer
    i.getResultLanguageType().hasUnspecifiedType(any(ArrayType at), false)
    or
    // An allocation expression that we couldn't conclude allocated a single
    // expression is assigned a buffer type.
    isAllocation(i, false)
  }

  private newtype TTypeFlowNode =
    TInstructionNode(Instruction i) or
    TFunctionNode(IRFunction func)

  abstract class TypeFlowNode extends TTypeFlowNode {
    /** Gets a textual representation of this node. */
    abstract string toString();

    /**
     * Gets the type of this node. This type may not be the most precise
     * possible type, but will be used as a starting point of the analysis.
     */
    abstract Type getType();

    /** Gets the location of this node. */
    abstract Location getLocation();

    /** Gets the underlying `Instruction` of this node, if any. */
    Instruction asInstruction() { none() }

    /** Gets the underlying `IRFunction` of this node, if any. */
    IRFunction asFunction() { none() }

    /** Holds if the value of this node is always null. */
    abstract predicate isNullValue();
  }

  private class InstructionNode extends TypeFlowNode, TInstructionNode {
    Instruction instr;

    InstructionNode() { this = TInstructionNode(instr) }

    override string toString() { result = instr.toString() }

    override Type getType() {
      if hasExactSingleType(instr) then result.isSingle() else result.isBuffer()
    }

    override Location getLocation() { result = instr.getLocation() }

    override Instruction asInstruction() { result = instr }

    override predicate isNullValue() {
      instr.(ConstantInstruction).getValue() = "0" and
      instr.getResultIRType() instanceof IRAddressType
    }
  }

  /** Gets the `TypeFlowNode` corresponding to `i`. */
  additional InstructionNode instructionNode(Instruction i) { result.asInstruction() = i }

  private class FunctionNode extends TypeFlowNode, TFunctionNode {
    IRFunction func;

    FunctionNode() { this = TFunctionNode(func) }

    override string toString() { result = func.toString() }

    Instruction getReturnValueInstruction() {
      result = func.getReturnInstruction().(ReturnValueInstruction).getReturnValue()
    }

    override Type getType() { result = instructionNode(this.getReturnValueInstruction()).getType() }

    override Location getLocation() { result = func.getLocation() }

    override IRFunction asFunction() { result = func }

    override predicate isNullValue() {
      instructionNode(this.getReturnValueInstruction()).isNullValue()
    }
  }

  /**
   * Gets an ultimiate definition of `phi`. That is, an input to `phi` that is
   * not itself a `PhiInstruction`.
   */
  private Instruction getAnUltimateLocalDefinition(PhiInstruction phi) {
    result = phi.getAnInput*() and not result instanceof PhiInstruction
  }

  /**
   * Holds if this function is private (i.e., cannot be accessed outside its
   * compilation unit). This means we can use a closed-world assumption about
   * calls to this function.
   */
  private predicate isPrivate(Function func) {
    // static functions have internal linkage
    func.isStatic()
    or
    // anonymous namespaces have internal linkage
    func.getNamespace().getParentNamespace*().isAnonymous()
    or
    // private member functions are only called internally from inside the class
    func.(MemberFunction).isPrivate()
  }

  /**
   * Holds if `arg` is an argument for the parameter `p` in a private callable.
   */
  pragma[nomagic]
  private predicate privateParamArg(InitializeParameterInstruction p, Instruction arg) {
    exists(CallInstruction call, int i, Function func |
      call.getArgument(pragma[only_bind_into](i)) = arg and
      func = call.getStaticCallTarget() and
      func.getParameter(pragma[only_bind_into](i)) = p.getParameter() and
      isPrivate(func)
    )
  }

  predicate step(TypeFlowNode n1, TypeFlowNode n2) {
    // instruction -> phi
    getAnUltimateLocalDefinition(n2.asInstruction()) = n1.asInstruction()
    or
    // return value -> function
    n2.(FunctionNode).getReturnValueInstruction() = n1.asInstruction()
    or
    // function -> call
    exists(Function func | func = n1.asFunction().getFunction() |
      not func.isVirtual() and
      n2.asInstruction().(CallInstruction).getStaticCallTarget() = func
    )
    or
    // Argument -> parameter where the parameter's enclosing function
    // is "private".
    exists(Instruction arg, Instruction p |
      privateParamArg(p, arg) and
      n1.asInstruction() = arg and
      n2.asInstruction() = p
    )
    or
    instructionStep(n1.asInstruction(), n2.asInstruction())
  }

  /**
   * Holds if knowing whether `i1` points to a single object or buffer implies
   * knowing whether `i2` points to a single object or buffer.
   */
  private predicate instructionStep(Instruction i1, Instruction i2) {
    i2.(CopyInstruction).getSourceValue() = i1
    or
    i2.(CopyValueInstruction).getSourceValue() = i1
    or
    i2.(ConvertInstruction).getUnary() = i1
    or
    i2.(CheckedConvertOrNullInstruction).getUnary() = i1
    or
    i2.(InheritanceConversionInstruction).getUnary() = i1
    or
    i2.(PointerArithmeticInstruction).getLeft() = i1
  }

  predicate isNullValue(TypeFlowNode n) { n.isNullValue() }

  private newtype TType =
    TSingle() or
    TBuffer()

  class Type extends TType {
    string toString() {
      this.isSingle() and
      result = "Single"
      or
      this.isBuffer() and
      result = "Buffer"
    }

    /** Holds if this type is the type that represents a single object. */
    predicate isSingle() { this = TSingle() }

    /** Holds if this type is the type that represents a buffer. */
    predicate isBuffer() { this = TBuffer() }

    /**
     * Gets a super type of this type, if any.
     *
     * The type relation is `Single <: Buffer`.
     */
    Type getASupertype() {
      this.isSingle() and
      result.isBuffer()
    }
  }

  predicate exactTypeBase(TypeFlowNode n, Type t) {
    exists(Instruction instr | instr = n.asInstruction() |
      hasExactSingleType(instr) and t.isSingle()
      or
      hasExactBufferType(instr) and t.isBuffer()
    )
  }

  pragma[nomagic]
  private predicate upcastCand(TypeFlowNode n, Type t1, Type t2) {
    exists(TypeFlowNode next | step(n, next) |
      n.getType() = t1 and
      next.getType() = t2 and
      t1 != t2
    )
  }

  private predicate upcast(TypeFlowNode n, Type t1) {
    exists(Type t2 | upcastCand(n, t1, t2) |
      // No need for transitive closure since the subtyping relation is just `Single <: Buffer`
      t1.getASupertype() = t2
    )
  }

  predicate typeFlowBaseCand(TypeFlowNode n, Type t) { upcast(n, t) }
}

private module TypeFlow = Make<Location, Input>;

/**
 * Holds if `i` is an instruction that computes an address that points to a
 * single object (as opposed to pointing into a buffer).
 */
pragma[nomagic]
predicate isPointerToSingleObject(Instruction i) {
  TypeFlow::bestTypeFlow(Input::instructionNode(i), any(Input::Type t | t.isSingle()), _)
}
