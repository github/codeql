/**
 * Provides classes that represent the individual instructions in the IR for a function.
 */

private import internal.IRInternal
import IRFunction
import IRBlock
import IRVariable
import Operand
private import internal.InstructionImports as Imports
import Imports::EdgeKind
import Imports::IRType
import Imports::MemoryAccessKind
import Imports::Opcode
private import Imports::OperandTag

/**
 * Gets an `Instruction` that is contained in `IRFunction`, and has a location with the specified
 * `File` and line number. Used for assigning register names when printing IR.
 */
private Instruction getAnInstructionAtLine(IRFunction irFunc, Language::File file, int line) {
  exists(IRConfiguration::IRConfiguration config |
    config.shouldEvaluateDebugStringsForFunction(irFunc.getFunction())
  ) and
  exists(Language::Location location |
    irFunc = result.getEnclosingIRFunction() and
    location = result.getLocation() and
    file = location.getFile() and
    line = location.getStartLine()
  )
}

/**
 * A single instruction in the IR.
 */
class Instruction extends Construction::TStageInstruction {
  Instruction() {
    // The base `TStageInstruction` type is a superset of the actual instructions appearing in this
    // stage. This call lets the stage filter out the ones that are not reused from raw IR.
    Construction::hasInstruction(this)
  }

  /** Gets a textual representation of this element. */
  final string toString() { result = this.getOpcode().toString() + ": " + this.getAst().toString() }

  /**
   * Gets a string showing the result, opcode, and operands of the instruction, equivalent to what
   * would be printed by PrintIR.ql. For example:
   *
   * `mu0_28(int) = Store r0_26, r0_27`
   */
  final string getDumpString() {
    result =
      this.getResultString() + " = " + this.getOperationString() + " " + this.getOperandsString()
  }

  private predicate shouldGenerateDumpStrings() {
    exists(IRConfiguration::IRConfiguration config |
      config.shouldEvaluateDebugStringsForFunction(this.getEnclosingFunction())
    )
  }

  /**
   * Gets a string describing the operation of this instruction. This includes
   * the opcode and the immediate value, if any. For example:
   *
   * VariableAddress[x]
   */
  final string getOperationString() {
    this.shouldGenerateDumpStrings() and
    if exists(this.getImmediateString())
    then
      result =
        this.getOperationPrefix() + this.getOpcode().toString() + "[" + this.getImmediateString() +
          "]"
    else result = this.getOperationPrefix() + this.getOpcode().toString()
  }

  /**
   * Gets a string describing the immediate value of this instruction, if any.
   */
  string getImmediateString() { none() }

  private string getOperationPrefix() {
    this.shouldGenerateDumpStrings() and
    if this instanceof SideEffectInstruction then result = "^" else result = ""
  }

  private string getResultPrefix() {
    this.shouldGenerateDumpStrings() and
    if this.getResultIRType() instanceof IRVoidType
    then result = "v"
    else
      if this.hasMemoryResult()
      then if this.isResultModeled() then result = "m" else result = "mu"
      else result = "r"
  }

  /**
   * Gets the zero-based index of this instruction within its block. This is
   * used by debugging and printing code only.
   */
  int getDisplayIndexInBlock() {
    this.shouldGenerateDumpStrings() and
    exists(IRBlock block |
      this = block.getInstruction(result)
      or
      this =
        rank[-result - 1](PhiInstruction phiInstr |
          phiInstr = block.getAPhiInstruction()
        |
          phiInstr order by phiInstr.getUniqueId()
        )
    )
  }

  private int getLineRank() {
    this.shouldGenerateDumpStrings() and
    exists(IRFunction enclosing, Language::File file, int line |
      this =
        rank[result](Instruction instr |
          instr = getAnInstructionAtLine(enclosing, file, line)
        |
          instr order by instr.getBlock().getDisplayIndex(), instr.getDisplayIndexInBlock()
        )
    )
  }

  /**
   * Gets a human-readable string that uniquely identifies this instruction
   * within the function. This string is used to refer to this instruction when
   * printing IR dumps.
   *
   * Example: `r1_1`
   */
  string getResultId() {
    this.shouldGenerateDumpStrings() and
    result =
      this.getResultPrefix() + this.getAst().getLocation().getStartLine() + "_" + this.getLineRank()
  }

  /**
   * Gets a string describing the result of this instruction, suitable for
   * display in IR dumps. This consists of the result ID plus the type of the
   * result.
   *
   * Example: `r1_1(int*)`
   */
  final string getResultString() {
    this.shouldGenerateDumpStrings() and
    result = this.getResultId() + "(" + this.getResultLanguageType().getDumpString() + ")"
  }

  /**
   * Gets a string describing the operands of this instruction, suitable for
   * display in IR dumps.
   *
   * Example: `func:r3_4, this:r3_5`
   */
  string getOperandsString() {
    this.shouldGenerateDumpStrings() and
    result =
      concat(Operand operand |
        operand = this.getAnOperand()
      |
        operand.getDumpString(), ", " order by operand.getDumpSortOrder()
      )
  }

  /**
   * Gets a string identifier for this function that is unique among all
   * instructions in the same function.
   *
   * This is used for sorting IR output for tests, and is likely to be
   * inefficient for any other use.
   */
  final string getUniqueId() { result = Construction::getInstructionUniqueId(this) }

  /**
   * INTERNAL: Do not use.
   *
   * Gets two sort keys for this instruction - used to order instructions for printing
   * in test outputs.
   */
  final predicate hasSortKeys(int key1, int key2) {
    Construction::instructionHasSortKeys(this, key1, key2)
  }

  /**
   * Gets the basic block that contains this instruction.
   */
  final IRBlock getBlock() { result.getAnInstruction() = this }

  /**
   * Gets the function that contains this instruction.
   */
  final Language::Declaration getEnclosingFunction() {
    result = this.getEnclosingIRFunction().getFunction()
  }

  /**
   * Gets the IRFunction object that contains the IR for this instruction.
   */
  final IRFunction getEnclosingIRFunction() {
    result = Construction::getInstructionEnclosingIRFunction(this)
  }

  /**
   * Gets the AST that caused this instruction to be generated.
   */
  final Language::AST getAst() { result = Construction::getInstructionAst(this) }

  /**
   * Gets the location of the source code for this instruction.
   */
  final Language::Location getLocation() { result = this.getAst().getLocation() }

  /**
   * Gets the  `Expr` whose result is computed by this instruction, if any. The `Expr` may be a
   * conversion.
   */
  final Language::Expr getConvertedResultExpression() {
    result = Raw::getInstructionConvertedResultExpression(this)
  }

  /**
   * Gets the unconverted form of the `Expr` whose result is computed by this instruction, if any.
   */
  final Language::Expr getUnconvertedResultExpression() {
    result = Raw::getInstructionUnconvertedResultExpression(this)
  }

  /**
   * Gets the language-specific type of the result produced by this instruction.
   *
   * Most consumers of the IR should use `getResultIRType()` instead. `getResultIRType()` uses a
   * less complex, language-neutral type system in which all semantically equivalent types share the
   * same `IRType` instance. For example, in C++, four different `Instruction`s might have three
   * different values for `getResultLanguageType()`: `unsigned int`, `char32_t`, and `wchar_t`,
   * whereas all four instructions would have the same value for `getResultIRType()`, `uint4`.
   */
  final Language::LanguageType getResultLanguageType() {
    result = Construction::getInstructionResultType(this)
  }

  /**
   * Gets the type of the result produced by this instruction. If the instruction does not produce
   * a result, its result type will be `IRVoidType`.
   */
  final IRType getResultIRType() { result = Construction::getInstructionResultIRType(this) }

  /**
   * Gets the type of the result produced by this instruction. If the
   * instruction does not produce a result, its result type will be `VoidType`.
   *
   * If `isGLValue()` holds, then the result type of this instruction should be
   * thought of as "pointer to `getResultType()`".
   */
  final Language::Type getResultType() {
    exists(Language::LanguageType resultType |
      resultType = this.getResultLanguageType() and
      (
        resultType.hasUnspecifiedType(result, _)
        or
        not resultType.hasUnspecifiedType(_, _) and result instanceof Language::UnknownType
      )
    )
  }

  /**
   * Holds if the result produced by this instruction is a glvalue. If this
   * holds, the result of the instruction represents the address of a location,
   * and the type of the location is given by `getResultType()`. If this does
   * not hold, the result of the instruction represents a value whose type is
   * given by `getResultType()`.
   *
   * For example, the statement `y = x;` generates the following IR:
   * ```
   * r1_0(glval: int) = VariableAddress[x]
   * r1_1(int)        = Load r1_0, mu0_1
   * r1_2(glval: int) = VariableAddress[y]
   * mu1_3(int)       = Store r1_2, r1_1
   * ```
   *
   * The result of each `VariableAddress` instruction is a glvalue of type
   * `int`, representing the address of the corresponding integer variable. The
   * result of the `Load` instruction is a prvalue of type `int`, representing
   * the integer value loaded from variable `x`.
   */
  final predicate isGLValue() { this.getResultLanguageType().hasType(_, true) }

  /**
   * Gets the size of the result produced by this instruction, in bytes. If the
   * result does not have a known constant size, this predicate does not hold.
   *
   * If `this.isGLValue()` holds for this instruction, the value of
   * `getResultSize()` will always be the size of a pointer.
   */
  final int getResultSize() { result = this.getResultLanguageType().getByteSize() }

  /**
   * Gets the opcode that specifies the operation performed by this instruction.
   */
  pragma[inline]
  final Opcode getOpcode() { Construction::getInstructionOpcode(result, this) }

  /**
   * Gets all direct uses of the result of this instruction. The result can be
   * an `Operand` for which `isDefinitionInexact` holds.
   */
  final Operand getAUse() { result.getAnyDef() = this }

  /**
   * Gets all of this instruction's operands.
   */
  final Operand getAnOperand() { result.getUse() = this }

  /**
   * Holds if this instruction produces a memory result.
   */
  final predicate hasMemoryResult() { exists(this.getResultMemoryAccess()) }

  /**
   * Gets the kind of memory access performed by this instruction's result.
   * Holds only for instructions with a memory result.
   */
  pragma[inline]
  final MemoryAccessKind getResultMemoryAccess() {
    result = this.getOpcode().getWriteMemoryAccess()
  }

  /**
   * Holds if the memory access performed by this instruction's result will not always write to
   * every bit in the memory location. This is most commonly used for memory accesses that may or
   * may not actually occur depending on runtime state (for example, the write side effect of an
   * output parameter that is not written to on all paths), or for accesses where the memory
   * location is a conservative estimate of the memory that might actually be accessed at runtime
   * (for example, the global side effects of a function call).
   */
  pragma[inline]
  final predicate hasResultMayMemoryAccess() { this.getOpcode().hasMayWriteMemoryAccess() }

  /**
   * Gets the operand that holds the memory address to which this instruction stores its
   * result, if any. For example, in `m3 = Store r1, r2`, the result of `getResultAddressOperand()`
   * is `r1`.
   */
  final AddressOperand getResultAddressOperand() {
    this.getResultMemoryAccess().usesAddressOperand() and
    result.getUse() = this
  }

  /**
   * Gets the instruction that holds the exact memory address to which this instruction stores its
   * result, if any. For example, in `m3 = Store r1, r2`, the result of `getResultAddressOperand()`
   * is the instruction that defines `r1`.
   */
  final Instruction getResultAddress() { result = this.getResultAddressOperand().getDef() }

  /**
   * Holds if the result of this instruction is precisely modeled in SSA. Always
   * holds for a register result. For a memory result, a modeled result is
   * connected to its actual uses. An unmodeled result has no uses.
   *
   * For example:
   * ```
   * int x = 1;
   * int *p = &x;
   * int y = *p;
   * ```
   * In non-aliased SSA, `x` will not be modeled because it has its address
   * taken. In that case, `isResultModeled()` would not hold for the result of
   * the `Store` to `x`.
   */
  final predicate isResultModeled() {
    // Register results are always in SSA form.
    not this.hasMemoryResult() or
    Construction::hasModeledMemoryResult(this)
  }

  /**
   * Holds if this is an instruction with a memory result that represents a
   * conflation of more than one memory allocation.
   *
   * This happens in practice when dereferencing a pointer that cannot be
   * tracked back to a single local allocation. Such memory is instead modeled
   * as originating on the `AliasedDefinitionInstruction` at the entry of the
   * function.
   */
  final predicate isResultConflated() { Construction::hasConflatedMemoryResult(this) }

  /**
   * Gets the successor of this instruction along the control flow edge
   * specified by `kind`.
   */
  final Instruction getSuccessor(EdgeKind kind) {
    result = Construction::getInstructionSuccessor(this, kind)
  }

  /**
   * Gets the a _back-edge successor_ of this instruction along the control
   * flow edge specified by `kind`. A back edge in the control-flow graph is
   * intuitively the edge that goes back around a loop. If all back edges are
   * removed from the control-flow graph, it becomes acyclic.
   */
  final Instruction getBackEdgeSuccessor(EdgeKind kind) {
    // We don't take these edges from
    // `Construction::getInstructionBackEdgeSuccessor` since that relation has
    // not been treated to remove any loops that might be left over due to
    // flaws in the IR construction or back-edge detection.
    exists(IRBlock block |
      block = this.getBlock() and
      this = block.getLastInstruction() and
      result = block.getBackEdgeSuccessor(kind).getFirstInstruction()
    )
  }

  /**
   * Gets all direct successors of this instruction.
   */
  final Instruction getASuccessor() { result = this.getSuccessor(_) }

  /**
   * Gets a predecessor of this instruction such that the predecessor reaches
   * this instruction along the control flow edge specified by `kind`.
   */
  final Instruction getPredecessor(EdgeKind kind) { result.getSuccessor(kind) = this }

  /**
   * Gets all direct predecessors of this instruction.
   */
  final Instruction getAPredecessor() { result = this.getPredecessor(_) }
}

/**
 * An instruction that refers to a variable.
 *
 * This class is used for any instruction whose operation fundamentally depends on a specific
 * variable. For example, it is used for `VariableAddress`, which returns the address of a specific
 * variable, and `InitializeParameter`, which returns the value that was passed to the specified
 * parameter by the caller. `VariableInstruction` is not used for `Load` or `Store` instructions
 * that happen to load from or store to a particular variable; in those cases, the memory location
 * being accessed is specified by the `AddressOperand` on the instruction, which may or may not be
 * defined by the result of a `VariableAddress` instruction.
 */
class VariableInstruction extends Instruction {
  IRVariable var;

  VariableInstruction() { var = Raw::getInstructionVariable(this) }

  override string getImmediateString() { result = var.toString() }

  /**
   * Gets the variable that this instruction references.
   */
  final IRVariable getIRVariable() { result = var }

  /**
   * Gets the AST variable that this instruction's IR variable refers to, if one exists.
   */
  final Language::Variable getAstVariable() { result = var.(IRUserVariable).getVariable() }
}

/**
 * An instruction that refers to a field of a class, struct, or union.
 *
 * This class is used for any instruction whose operation fundamentally depends on a specific
 * field. For example, it is used for `FieldAddress`, which computes the address of a specific
 * field on an object. `FieldInstruction` is not used for `Load` or `Store` instructions that happen
 * to load from or store to a particular field; in those cases, the memory location being accessed
 * is specified by the `AddressOperand` on the instruction, which may or may not be defined by the
 * result of a `FieldAddress` instruction.
 */
class FieldInstruction extends Instruction {
  Language::Field field;

  FieldInstruction() { field = Raw::getInstructionField(this) }

  final override string getImmediateString() { result = field.toString() }

  /**
   * Gets the field that this instruction references.
   */
  final Language::Field getField() { result = field }
}

/**
 * An instruction that refers to a function.
 *
 * This class is used for any instruction whose operation fundamentally depends on a specific
 * function. For example, it is used for `FunctionAddress`, which returns the address of a specific
 * function. `FunctionInstruction` is not used for `Call` instructions that happen to call a
 * particular function; in that case, the function being called is specified by the
 * `CallTargetOperand` on the instruction, which may or may not be defined by the result of a
 * `FunctionAddress` instruction.
 */
class FunctionInstruction extends Instruction {
  Language::Function funcSymbol;

  FunctionInstruction() { funcSymbol = Raw::getInstructionFunction(this) }

  final override string getImmediateString() { result = funcSymbol.toString() }

  /**
   * Gets the function that this instruction references.
   */
  final Language::Function getFunctionSymbol() { result = funcSymbol }
}

/**
 * An instruction whose result is a compile-time constant value.
 */
class ConstantValueInstruction extends Instruction {
  string value;

  ConstantValueInstruction() { value = Raw::getInstructionConstantValue(this) }

  final override string getImmediateString() { result = value }

  /**
   * Gets the constant value of this instruction's result.
   */
  final string getValue() { result = value }
}

/**
 * An instruction that refers to an argument of a `Call` instruction.
 *
 * This instruction is used for side effects of a `Call` instruction that read or write memory
 * pointed to by one of the arguments of the call.
 */
class IndexedInstruction extends Instruction {
  int index;

  IndexedInstruction() { index = Raw::getInstructionIndex(this) }

  final override string getImmediateString() { result = index.toString() }

  /**
   * Gets the zero-based index of the argument that this instruction references.
   */
  final int getIndex() { result = index }
}

/**
 * An instruction representing the entry point to a function.
 *
 * Each `IRFunction` has exactly one `EnterFunction` instruction. Execution of the function begins
 * at this instruction. This instruction has no predecessors.
 */
class EnterFunctionInstruction extends Instruction {
  EnterFunctionInstruction() { this.getOpcode() instanceof Opcode::EnterFunction }
}

/**
 * An instruction that returns the address of a variable.
 *
 * This instruction returns the address of a local variable, parameter, static field,
 * namespace-scope variable, or global variable. For the address of a non-static field of a class,
 * struct, or union, see `FieldAddressInstruction`.
 */
class VariableAddressInstruction extends VariableInstruction {
  VariableAddressInstruction() { this.getOpcode() instanceof Opcode::VariableAddress }
}

/**
 * An instruction that returns the address of a function.
 *
 * This instruction returns the address of a function, including non-member functions, static member
 * functions, and non-static member functions.
 *
 * The result has an `IRFunctionAddress` type.
 */
class FunctionAddressInstruction extends FunctionInstruction {
  FunctionAddressInstruction() { this.getOpcode() instanceof Opcode::FunctionAddress }
}

/**
 * An instruction that returns the address of a "virtual" delete function.
 *
 * This function, which does not actually exist in the source code, is used to
 * delete objects of a class with a virtual destructor. In that case the deacllocation
 * function is selected at runtime based on the dynamic type of the object. So this
 * function dynamically dispatches to the correct deallocation function.
 * It also should pass in the required extra arguments to the deallocation function
 * which may differ dynamically depending on the type of the object.
 */
class VirtualDeleteFunctionAddressInstruction extends Instruction {
  VirtualDeleteFunctionAddressInstruction() {
    this.getOpcode() instanceof Opcode::VirtualDeleteFunctionAddress
  }
}

/**
 * An instruction that initializes a parameter of the enclosing function with the value of the
 * corresponding argument passed by the caller.
 *
 * Each parameter of a function will have exactly one `InitializeParameter` instruction that
 * initializes that parameter.
 */
class InitializeParameterInstruction extends VariableInstruction {
  InitializeParameterInstruction() { this.getOpcode() instanceof Opcode::InitializeParameter }

  /**
   * Gets the parameter initialized by this instruction.
   */
  final Language::Parameter getParameter() { result = var.(IRUserVariable).getVariable() }

  /**
   * Holds if this instruction initializes the parameter with index `index`, or
   * if `index` is `-1` and this instruction initializes `this`.
   */
  pragma[noinline]
  final predicate hasIndex(int index) {
    index >= 0 and index = this.getParameter().getIndex()
    or
    index = -1 and this.getIRVariable() instanceof IRThisVariable
  }
}

/**
 * An instruction that initializes all memory that existed before this function was called.
 *
 * This instruction provides a definition for memory that, because it was actually allocated and
 * initialized elsewhere, would not otherwise have a definition in this function.
 */
class InitializeNonLocalInstruction extends Instruction {
  InitializeNonLocalInstruction() { this.getOpcode() instanceof Opcode::InitializeNonLocal }
}

/**
 * An instruction that initializes the memory pointed to by a parameter of the enclosing function
 * with the value of that memory on entry to the function.
 */
class InitializeIndirectionInstruction extends VariableInstruction {
  InitializeIndirectionInstruction() { this.getOpcode() instanceof Opcode::InitializeIndirection }

  /**
   * Gets the parameter initialized by this instruction.
   */
  final Language::Parameter getParameter() { result = var.(IRUserVariable).getVariable() }

  /**
   * Holds if this instruction initializes the memory pointed to by the parameter with
   * index `index`, or if `index` is `-1` and this instruction initializes the memory
   * pointed to by `this`.
   */
  pragma[noinline]
  final predicate hasIndex(int index) {
    index >= 0 and index = this.getParameter().getIndex()
    or
    index = -1 and this.getIRVariable() instanceof IRThisVariable
  }
}

/**
 * An instruction that initializes the `this` pointer parameter of the enclosing function.
 */
class InitializeThisInstruction extends Instruction {
  InitializeThisInstruction() { this.getOpcode() instanceof Opcode::InitializeThis }
}

/**
 * An instruction that computes the address of a non-static field of an object.
 */
class FieldAddressInstruction extends FieldInstruction {
  FieldAddressInstruction() { this.getOpcode() instanceof Opcode::FieldAddress }

  /**
   * Gets the operand that provides the address of the object containing the field.
   */
  final UnaryOperand getObjectAddressOperand() { result = this.getAnOperand() }

  /**
   * Gets the instruction whose result provides the address of the object containing the field.
   */
  final Instruction getObjectAddress() { result = this.getObjectAddressOperand().getDef() }
}

/**
 * An instruction that computes the address of the first element of a managed array.
 *
 * This instruction is used for element access to C# arrays.
 */
class ElementsAddressInstruction extends UnaryInstruction {
  ElementsAddressInstruction() { this.getOpcode() instanceof Opcode::ElementsAddress }

  /**
   * Gets the operand that provides the address of the array object.
   */
  final UnaryOperand getArrayObjectAddressOperand() { result = this.getAnOperand() }

  /**
   * Gets the instruction whose result provides the address of the array object.
   */
  final Instruction getArrayObjectAddress() {
    result = this.getArrayObjectAddressOperand().getDef()
  }
}

/**
 * An instruction that produces a well-defined but unknown result and has
 * unknown side effects, including side effects that are not conservatively
 * modeled in the SSA graph.
 *
 * This type of instruction appears when there is an `ErrorExpr` in the AST,
 * meaning that the extractor could not understand the expression and therefore
 * produced a partial AST. Queries that give alerts when some action is _not_
 * taken may want to ignore any function that contains an `ErrorInstruction`.
 */
class ErrorInstruction extends Instruction {
  ErrorInstruction() { this.getOpcode() instanceof Opcode::Error }
}

/**
 * An instruction that returns an uninitialized value.
 *
 * This instruction is used to provide an initial definition for a stack variable that does not have
 * an initializer, or whose initializer only partially initializes the variable.
 */
class UninitializedInstruction extends VariableInstruction {
  UninitializedInstruction() { this.getOpcode() instanceof Opcode::Uninitialized }

  /**
   * Gets the variable that is uninitialized.
   */
  final Language::Variable getLocalVariable() { result = var.(IRUserVariable).getVariable() }
}

/**
 * An instruction that has no effect.
 *
 * This instruction is typically inserted to ensure that a particular AST is associated with at
 * least one instruction, even when the AST has no semantic effect.
 */
class NoOpInstruction extends Instruction {
  NoOpInstruction() { this.getOpcode() instanceof Opcode::NoOp }
}

/**
 * An instruction that returns control to the caller of the function.
 *
 * This instruction represents the normal (non-exception) return from a function, either from an
 * explicit `return` statement or from control flow reaching the end of the function's body.
 *
 * Each function has exactly one `ReturnInstruction`. Each `return` statement in a function is
 * represented as an initialization of the temporary variable that holds the return value, with
 * control then flowing to the common `ReturnInstruction` for that function. Exception: A function
 * that never returns will not have a `ReturnInstruction`.
 *
 * The `ReturnInstruction` for a function will have a control-flow successor edge to a block
 * containing the `ExitFunction` instruction for that function.
 *
 * There are two different return instructions: `ReturnValueInstruction`, for returning a value from
 * a non-`void`-returning function, and `ReturnVoidInstruction`, for returning from a
 * `void`-returning function.
 */
class ReturnInstruction extends Instruction {
  ReturnInstruction() { this.getOpcode() instanceof ReturnOpcode }
}

/**
 * An instruction that returns control to the caller of the function, without returning a value.
 */
class ReturnVoidInstruction extends ReturnInstruction {
  ReturnVoidInstruction() { this.getOpcode() instanceof Opcode::ReturnVoid }
}

/**
 * An instruction that returns control to the caller of the function, including a return value.
 */
class ReturnValueInstruction extends ReturnInstruction {
  ReturnValueInstruction() { this.getOpcode() instanceof Opcode::ReturnValue }

  /**
   * Gets the operand that provides the value being returned by the function.
   */
  final LoadOperand getReturnValueOperand() { result = this.getAnOperand() }

  /**
   * Gets the operand that provides the address of the value being returned by the function.
   */
  final AddressOperand getReturnAddressOperand() { result = this.getAnOperand() }

  /**
   * Gets the instruction whose result provides the value being returned by the function, if an
   * exact definition is available.
   */
  final Instruction getReturnValue() { result = this.getReturnValueOperand().getDef() }

  /**
   * Gets the instruction whose result provides the address of the value being returned by the function.
   */
  final Instruction getReturnAddress() { result = this.getReturnAddressOperand().getDef() }
}

/**
 * An instruction that represents the use of the value pointed to by a parameter of the function
 * after the function returns control to its caller.
 *
 * This instruction does not itself return control to the caller. It merely represents the potential
 * for a caller to use the memory pointed to by the parameter sometime after the call returns. This
 * is the counterpart to the `InitializeIndirection` instruction, which represents the possibility
 * that the caller initialized the memory pointed to by the parameter before the call.
 */
class ReturnIndirectionInstruction extends VariableInstruction {
  ReturnIndirectionInstruction() { this.getOpcode() instanceof Opcode::ReturnIndirection }

  /**
   * Gets the operand that provides the value of the pointed-to memory.
   */
  final SideEffectOperand getSideEffectOperand() { result = this.getAnOperand() }

  /**
   * Gets the instruction whose result provides the value of the pointed-to memory, if an exact
   * definition is available.
   */
  final Instruction getSideEffect() { result = this.getSideEffectOperand().getDef() }

  /**
   * Gets the operand that provides the address of the pointed-to memory.
   */
  final AddressOperand getSourceAddressOperand() { result = this.getAnOperand() }

  /**
   * Gets the instruction whose result provides the address of the pointed-to memory.
   */
  final Instruction getSourceAddress() { result = this.getSourceAddressOperand().getDef() }

  /**
   * Gets the parameter for which this instruction reads the final pointed-to value within the
   * function.
   */
  final Language::Parameter getParameter() { result = var.(IRUserVariable).getVariable() }

  /**
   * Holds if this instruction is the return indirection for `this`.
   */
  final predicate isThisIndirection() { var instanceof IRThisVariable }

  /**
   * Holds if this instruction is the return indirection for the parameter with index `index`, or
   * if this instruction is the return indirection for `this` and `index` is `-1`.
   */
  pragma[noinline]
  final predicate hasIndex(int index) {
    index >= 0 and index = this.getParameter().getIndex()
    or
    index = -1 and this.isThisIndirection()
  }
}

/**
 * An instruction that returns a copy of its operand.
 *
 * There are several different copy instructions, depending on the source and destination of the
 * copy operation:
 * - `CopyValueInstruction` - Copies a register operand to a register result.
 * - `LoadInstruction` - Copies a memory operand to a register result.
 * - `StoreInstruction` - Copies a register operand to a memory result.
 */
class CopyInstruction extends Instruction {
  CopyInstruction() { this.getOpcode() instanceof CopyOpcode }

  /**
   * Gets the operand that provides the input value of the copy.
   */
  Operand getSourceValueOperand() { none() }

  /**
   * Gets the instruction whose result provides the input value of the copy, if an exact definition
   * is available.
   */
  final Instruction getSourceValue() { result = this.getSourceValueOperand().getDef() }
}

/**
 * An instruction that returns a register result containing a copy of its register operand.
 */
class CopyValueInstruction extends CopyInstruction, UnaryInstruction {
  CopyValueInstruction() { this.getOpcode() instanceof Opcode::CopyValue }

  final override UnaryOperand getSourceValueOperand() { result = this.getAnOperand() }
}

/**
 * Gets a string describing the location pointed to by the specified address operand.
 */
private string getAddressOperandDescription(AddressOperand operand) {
  result = operand.getDef().(VariableAddressInstruction).getIRVariable().toString()
  or
  not operand.getDef() instanceof VariableAddressInstruction and
  result = "?"
}

/**
 * An instruction that returns a register result containing a copy of its memory operand.
 */
class LoadInstruction extends CopyInstruction {
  LoadInstruction() { this.getOpcode() instanceof Opcode::Load }

  final override string getImmediateString() {
    result = getAddressOperandDescription(this.getSourceAddressOperand())
  }

  /**
   * Gets the operand that provides the address of the value being loaded.
   */
  final AddressOperand getSourceAddressOperand() { result = this.getAnOperand() }

  /**
   * Gets the instruction whose result provides the address of the value being loaded.
   */
  final Instruction getSourceAddress() { result = this.getSourceAddressOperand().getDef() }

  final override LoadOperand getSourceValueOperand() { result = this.getAnOperand() }
}

/**
 * An instruction that returns a memory result containing a copy of its register operand.
 */
class StoreInstruction extends CopyInstruction {
  StoreInstruction() { this.getOpcode() instanceof Opcode::Store }

  final override string getImmediateString() {
    result = getAddressOperandDescription(this.getDestinationAddressOperand())
  }

  /**
   * Gets the operand that provides the address of the location to which the value will be stored.
   */
  final AddressOperand getDestinationAddressOperand() { result = this.getAnOperand() }

  /**
   * Gets the instruction whose result provides the address of the location to which the value will
   * be stored, if an exact definition is available.
   */
  final Instruction getDestinationAddress() {
    result = this.getDestinationAddressOperand().getDef()
  }

  final override StoreValueOperand getSourceValueOperand() { result = this.getAnOperand() }
}

/**
 * An instruction that branches to one of two successor instructions based on the value of a Boolean
 * operand.
 */
class ConditionalBranchInstruction extends Instruction {
  ConditionalBranchInstruction() { this.getOpcode() instanceof Opcode::ConditionalBranch }

  /**
   * Gets the operand that provides the Boolean condition controlling the branch.
   */
  final ConditionOperand getConditionOperand() { result = this.getAnOperand() }

  /**
   * Gets the instruction whose result provides the Boolean condition controlling the branch.
   */
  final Instruction getCondition() { result = this.getConditionOperand().getDef() }

  /**
   * Gets the instruction to which control will flow if the condition is true.
   */
  final Instruction getTrueSuccessor() { result = this.getSuccessor(EdgeKind::trueEdge()) }

  /**
   * Gets the instruction to which control will flow if the condition is false.
   */
  final Instruction getFalseSuccessor() { result = this.getSuccessor(EdgeKind::falseEdge()) }
}

/**
 * An instruction representing the exit point of a function.
 *
 * Each `IRFunction` has exactly one `ExitFunction` instruction, unless the function neither returns
 * nor throws an exception. Control flows to the `ExitFunction` instruction from both normal returns
 * (`ReturnVoid`, `ReturnValue`) and propagated exceptions (`Unwind`). This instruction has no
 * successors.
 */
class ExitFunctionInstruction extends Instruction {
  ExitFunctionInstruction() { this.getOpcode() instanceof Opcode::ExitFunction }
}

/**
 * An instruction whose result is a constant value.
 */
class ConstantInstruction extends ConstantValueInstruction {
  ConstantInstruction() { this.getOpcode() instanceof Opcode::Constant }
}

/**
 * An instruction whose result is a constant value of integer or Boolean type.
 */
class IntegerConstantInstruction extends ConstantInstruction {
  IntegerConstantInstruction() {
    exists(IRType resultType | resultType = this.getResultIRType() |
      resultType instanceof IRIntegerType or resultType instanceof IRBooleanType
    )
  }
}

/**
 * An instruction whose result is a constant value of floating-point type.
 */
class FloatConstantInstruction extends ConstantInstruction {
  FloatConstantInstruction() { this.getResultIRType() instanceof IRFloatingPointType }
}

/**
 * An instruction whose result is a constant value of a pointer type.
 */
class PointerConstantInstruction extends ConstantInstruction {
  PointerConstantInstruction() {
    exists(IRType resultType | resultType = this.getResultIRType() |
      resultType instanceof IRAddressType or resultType instanceof IRFunctionAddressType
    )
  }
}

/**
 * An instruction whose result is the address of a string literal.
 */
class StringConstantInstruction extends VariableInstruction {
  override IRStringLiteral var;

  final override string getImmediateString() {
    result = Language::getStringLiteralText(this.getValue())
  }

  /**
   * Gets the string literal whose address is returned by this instruction.
   */
  final Language::StringLiteral getValue() { result = var.getLiteral() }
}

/**
 * An instruction whose result is computed from two operands.
 */
class BinaryInstruction extends Instruction {
  BinaryInstruction() { this.getOpcode() instanceof BinaryOpcode }

  /**
   * Gets the left operand of this binary instruction.
   */
  final LeftOperand getLeftOperand() { result = this.getAnOperand() }

  /**
   * Gets the right operand of this binary instruction.
   */
  final RightOperand getRightOperand() { result = this.getAnOperand() }

  /**
   * Gets the instruction whose result provides the value of the left operand of this binary
   * instruction.
   */
  final Instruction getLeft() { result = this.getLeftOperand().getDef() }

  /**
   * Gets the instruction whose result provides the value of the right operand of this binary
   * instruction.
   */
  final Instruction getRight() { result = this.getRightOperand().getDef() }

  /**
   * Holds if this instruction's operands are `op1` and `op2`, in either order.
   */
  final predicate hasOperands(Operand op1, Operand op2) {
    op1 = this.getLeftOperand() and op2 = this.getRightOperand()
    or
    op1 = this.getRightOperand() and op2 = this.getLeftOperand()
  }
}

/**
 * An instruction that computes the result of an arithmetic operation.
 */
class ArithmeticInstruction extends Instruction {
  ArithmeticInstruction() { this.getOpcode() instanceof ArithmeticOpcode }
}

/**
 * An instruction that performs an arithmetic operation on two numeric operands.
 */
class BinaryArithmeticInstruction extends ArithmeticInstruction, BinaryInstruction { }

/**
 * An instruction whose result is computed by performing an arithmetic operation on a single
 * numeric operand.
 */
class UnaryArithmeticInstruction extends ArithmeticInstruction, UnaryInstruction { }

/**
 * An instruction that computes the sum of two numeric operands.
 *
 * Both operands must have the same numeric type, which will also be the result type. The result of
 * integer overflow is the infinite-precision result modulo 2^n. Floating-point addition is
 * performed according to IEEE-754.
 */
class AddInstruction extends BinaryArithmeticInstruction {
  AddInstruction() { this.getOpcode() instanceof Opcode::Add }
}

/**
 * An instruction that computes the difference of two numeric operands.
 *
 * Both operands must have the same numeric type, which will also be the result type. The result of
 * integer overflow is the infinite-precision result modulo 2^n. Floating-point subtraction is performed
 * according to IEEE-754.
 */
class SubInstruction extends BinaryArithmeticInstruction {
  SubInstruction() { this.getOpcode() instanceof Opcode::Sub }
}

/**
 * An instruction that computes the product of two numeric operands.
 *
 * Both operands must have the same numeric type, which will also be the result type. The result of
 * integer overflow is the infinite-precision result modulo 2^n. Floating-point multiplication is
 * performed according to IEEE-754.
 */
class MulInstruction extends BinaryArithmeticInstruction {
  MulInstruction() { this.getOpcode() instanceof Opcode::Mul }
}

/**
 * An instruction that computes the quotient of two numeric operands.
 *
 * Both operands must have the same numeric type, which will also be the result type. The result of
 * division by zero or integer overflow is undefined. Floating-point division is performed according
 * to IEEE-754.
 */
class DivInstruction extends BinaryArithmeticInstruction {
  DivInstruction() { this.getOpcode() instanceof Opcode::Div }
}

/**
 * An instruction that computes the remainder of two integer operands.
 *
 * Both operands must have the same integer type, which will also be the result type. The result of
 * division by zero or integer overflow is undefined.
 */
class RemInstruction extends BinaryArithmeticInstruction {
  RemInstruction() { this.getOpcode() instanceof Opcode::Rem }
}

/**
 * An instruction that negates a single numeric operand.
 *
 * The operand must have a numeric type, which will also be the result type. The result of integer
 * negation uses two's complement, and is computed modulo 2^n. The result of floating-point negation
 * is performed according to IEEE-754.
 */
class NegateInstruction extends UnaryArithmeticInstruction {
  NegateInstruction() { this.getOpcode() instanceof Opcode::Negate }
}

/**
 * An instruction that computes the result of a bitwise operation.
 */
class BitwiseInstruction extends Instruction {
  BitwiseInstruction() { this.getOpcode() instanceof BitwiseOpcode }
}

/**
 * An instruction that performs a bitwise operation on two integer operands.
 */
class BinaryBitwiseInstruction extends BitwiseInstruction, BinaryInstruction { }

/**
 * An instruction that performs a bitwise operation on a single integer operand.
 */
class UnaryBitwiseInstruction extends BitwiseInstruction, UnaryInstruction { }

/**
 * An instruction that computes the bitwise "and" of two integer operands.
 *
 * Both operands must have the same integer type, which will also be the result type.
 */
class BitAndInstruction extends BinaryBitwiseInstruction {
  BitAndInstruction() { this.getOpcode() instanceof Opcode::BitAnd }
}

/**
 * An instruction that computes the bitwise "or" of two integer operands.
 *
 * Both operands must have the same integer type, which will also be the result type.
 */
class BitOrInstruction extends BinaryBitwiseInstruction {
  BitOrInstruction() { this.getOpcode() instanceof Opcode::BitOr }
}

/**
 * An instruction that computes the bitwise "xor" of two integer operands.
 *
 * Both operands must have the same integer type, which will also be the result type.
 */
class BitXorInstruction extends BinaryBitwiseInstruction {
  BitXorInstruction() { this.getOpcode() instanceof Opcode::BitXor }
}

/**
 * An instruction that shifts its left operand to the left by the number of bits specified by its
 * right operand.
 *
 * Both operands must have an integer type. The result has the same type as the left operand. The
 * rightmost bits are zero-filled.
 */
class ShiftLeftInstruction extends BinaryBitwiseInstruction {
  ShiftLeftInstruction() { this.getOpcode() instanceof Opcode::ShiftLeft }
}

/**
 * An instruction that shifts its left operand to the right by the number of bits specified by its
 * right operand.
 *
 * Both operands must have an integer type. The result has the same type as the left operand. If the
 * left operand has an unsigned integer type, the leftmost bits are zero-filled. If the left operand
 * has a signed integer type, the leftmost bits are filled by duplicating the most significant bit
 * of the left operand.
 */
class ShiftRightInstruction extends BinaryBitwiseInstruction {
  ShiftRightInstruction() { this.getOpcode() instanceof Opcode::ShiftRight }
}

/**
 * An instruction that shifts its left operand to the right by the number of bits specified by its
 * right operand.
 *
 * Both operands must have an integer type. The result has the same type as the left operand.
 * The leftmost bits are zero-filled.
 */
class UnsignedShiftRightInstruction extends BinaryBitwiseInstruction {
  UnsignedShiftRightInstruction() { this.getOpcode() instanceof Opcode::UnsignedShiftRight }
}

/**
 * An instruction that performs a binary arithmetic operation involving at least one pointer
 * operand.
 */
class PointerArithmeticInstruction extends BinaryInstruction {
  int elementSize;

  PointerArithmeticInstruction() {
    this.getOpcode() instanceof PointerArithmeticOpcode and
    elementSize = Raw::getInstructionElementSize(this)
  }

  final override string getImmediateString() { result = elementSize.toString() }

  /**
   * Gets the size of the elements pointed to by the pointer operands, in bytes.
   *
   * When adding an integer offset to a pointer (`PointerAddInstruction`) or subtracting an integer
   * offset from a pointer (`PointerSubInstruction`), the integer offset is multiplied by the
   * element size to compute the actual number of bytes added to or subtracted from the pointer
   * address. When computing the integer difference between two pointers (`PointerDiffInstruction`),
   * the result is computed by computing the difference between the two pointer byte addresses, then
   * dividing that byte count by the element size.
   */
  final int getElementSize() { result = elementSize }
}

/**
 * An instruction that adds or subtracts an integer offset from a pointer.
 */
class PointerOffsetInstruction extends PointerArithmeticInstruction {
  PointerOffsetInstruction() { this.getOpcode() instanceof PointerOffsetOpcode }
}

/**
 * An instruction that adds an integer offset to a pointer.
 *
 * The result is the byte address computed by adding the value of the right (integer) operand,
 * multiplied by the element size, to the value of the left (pointer) operand. The result of pointer
 * overflow is undefined.
 */
class PointerAddInstruction extends PointerOffsetInstruction {
  PointerAddInstruction() { this.getOpcode() instanceof Opcode::PointerAdd }
}

/**
 * An instruction that subtracts an integer offset from a pointer.
 *
 * The result is the byte address computed by subtracting the value of the right (integer) operand,
 * multiplied by the element size, from the value of the left (pointer) operand. The result of
 * pointer underflow is undefined.
 */
class PointerSubInstruction extends PointerOffsetInstruction {
  PointerSubInstruction() { this.getOpcode() instanceof Opcode::PointerSub }
}

/**
 * An instruction that computes the difference between two pointers.
 *
 * Both operands must have the same pointer type. The result must have an integer type whose size is
 * the same as that of the pointer operands. The result is computed by subtracting the byte address
 * in the right operand from the byte address in the left operand, and dividing by the element size.
 * If the difference in byte addresses is not divisible by the element size, the result is
 * undefined.
 */
class PointerDiffInstruction extends PointerArithmeticInstruction {
  PointerDiffInstruction() { this.getOpcode() instanceof Opcode::PointerDiff }
}

/**
 * An instruction whose result is computed from a single operand.
 */
class UnaryInstruction extends Instruction {
  UnaryInstruction() { this.getOpcode() instanceof UnaryOpcode }

  /**
   * Gets the sole operand of this instruction.
   */
  final UnaryOperand getUnaryOperand() { result = this.getAnOperand() }

  /**
   * Gets the instruction whose result provides the sole operand of this instruction.
   */
  final Instruction getUnary() { result = this.getUnaryOperand().getDef() }
}

/**
 * An instruction that converts the value of its operand to a value of a different type.
 */
class ConvertInstruction extends UnaryInstruction {
  ConvertInstruction() { this.getOpcode() instanceof Opcode::Convert }
}

/**
 * An instruction that converts the address of a polymorphic object to the address of a different
 * subobject of the same polymorphic object, returning a null address if the dynamic type of the
 * object is not compatible with the result type.
 *
 * If the operand holds a null address, the result is a null address.
 *
 * This instruction is used to represent a C++ `dynamic_cast<>` to a pointer type, or a C# `is` or
 * `as` expression.
 */
class CheckedConvertOrNullInstruction extends UnaryInstruction {
  CheckedConvertOrNullInstruction() { this.getOpcode() instanceof Opcode::CheckedConvertOrNull }
}

/**
 * An instruction that converts the address of a polymorphic object to the address of a different
 * subobject of the same polymorphic object, throwing an exception if the dynamic type of the object
 * is not compatible with the result type.
 *
 * If the operand holds a null address, the result is a null address.
 *
 * This instruction is used to represent a C++ `dynamic_cast<>` to a reference type, or a C# cast
 * expression.
 */
class CheckedConvertOrThrowInstruction extends UnaryInstruction {
  CheckedConvertOrThrowInstruction() { this.getOpcode() instanceof Opcode::CheckedConvertOrThrow }
}

/**
 * An instruction that returns the address of the complete object that contains the subobject
 * pointed to by its operand.
 *
 * If the operand holds a null address, the result is a null address.
 *
 * This instruction is used to represent `dynamic_cast<void*>` in C++, which returns the pointer to
 * the most-derived object.
 */
class CompleteObjectAddressInstruction extends UnaryInstruction {
  CompleteObjectAddressInstruction() { this.getOpcode() instanceof Opcode::CompleteObjectAddress }
}

/**
 * An instruction that converts the address of an object to the address of a different subobject of
 * the same object, without any type checking at runtime.
 */
class InheritanceConversionInstruction extends UnaryInstruction {
  Language::Class baseClass;
  Language::Class derivedClass;

  InheritanceConversionInstruction() {
    Raw::getInstructionInheritance(this, baseClass, derivedClass)
  }

  final override string getImmediateString() {
    result = derivedClass.toString() + " : " + baseClass.toString()
  }

  /**
   * Gets the `ClassDerivation` for the inheritance relationship between
   * the base and derived classes. This predicate does not hold if the
   * conversion is to an indirect virtual base class.
   */
  final Language::ClassDerivation getDerivation() {
    result.getBaseClass() = baseClass and result.getDerivedClass() = derivedClass
  }

  /**
   * Gets the base class of the conversion. This will be either a direct
   * base class of the derived class, or a virtual base class of the
   * derived class.
   */
  final Language::Class getBaseClass() { result = baseClass }

  /**
   * Gets the derived class of the conversion.
   */
  final Language::Class getDerivedClass() { result = derivedClass }
}

/**
 * An instruction that converts from the address of a derived class to the address of a base class.
 */
class ConvertToBaseInstruction extends InheritanceConversionInstruction {
  ConvertToBaseInstruction() { this.getOpcode() instanceof ConvertToBaseOpcode }
}

/**
 * An instruction that converts from the address of a derived class to the address of a direct
 * non-virtual base class.
 *
 * If the operand holds a null address, the result is a null address.
 */
class ConvertToNonVirtualBaseInstruction extends ConvertToBaseInstruction {
  ConvertToNonVirtualBaseInstruction() {
    this.getOpcode() instanceof Opcode::ConvertToNonVirtualBase
  }
}

/**
 * An instruction that converts from the address of a derived class to the address of a virtual base
 * class.
 *
 * If the operand holds a null address, the result is a null address.
 */
class ConvertToVirtualBaseInstruction extends ConvertToBaseInstruction {
  ConvertToVirtualBaseInstruction() { this.getOpcode() instanceof Opcode::ConvertToVirtualBase }
}

/**
 * An instruction that converts from the address of a base class to the address of a direct
 * non-virtual derived class.
 *
 * If the operand holds a null address, the result is a null address.
 */
class ConvertToDerivedInstruction extends InheritanceConversionInstruction {
  ConvertToDerivedInstruction() { this.getOpcode() instanceof Opcode::ConvertToDerived }
}

/**
 * An instruction that computes the bitwise complement of its operand.
 *
 * The operand must have an integer type, which will also be the result type.
 */
class BitComplementInstruction extends UnaryBitwiseInstruction {
  BitComplementInstruction() { this.getOpcode() instanceof Opcode::BitComplement }
}

/**
 * An instruction that computes the logical complement of its operand.
 *
 * The operand must have a Boolean type, which will also be the result type.
 */
class LogicalNotInstruction extends UnaryInstruction {
  LogicalNotInstruction() { this.getOpcode() instanceof Opcode::LogicalNot }
}

/**
 * An instruction that compares two numeric operands.
 */
class CompareInstruction extends BinaryInstruction {
  CompareInstruction() { this.getOpcode() instanceof CompareOpcode }
}

/**
 * An instruction that returns a `true` result if its operands are equal.
 *
 * Both operands must have the same numeric or address type. The result must have a Boolean type.
 * The result is `true` if `left == right`, and `false` if `left != right` or the two operands are
 * unordered. Floating-point comparison is performed according to IEEE-754.
 */
class CompareEQInstruction extends CompareInstruction {
  CompareEQInstruction() { this.getOpcode() instanceof Opcode::CompareEQ }
}

/**
 * An instruction that returns a `true` result if its operands are not equal.
 *
 * Both operands must have the same numeric or address type. The result must have a Boolean type.
 * The result is `true` if `left != right` or if the two operands are unordered, and `false` if
 * `left == right`. Floating-point comparison is performed according to IEEE-754.
 */
class CompareNEInstruction extends CompareInstruction {
  CompareNEInstruction() { this.getOpcode() instanceof Opcode::CompareNE }
}

/**
 * An instruction that does a relative comparison of two values, such as `<` or `>=`.
 */
class RelationalInstruction extends CompareInstruction {
  RelationalInstruction() { this.getOpcode() instanceof RelationalOpcode }

  /**
   * Gets the operand on the "greater" (or "greater-or-equal") side
   * of this relational instruction, that is, the side that is larger
   * if the overall instruction evaluates to `true`; for example on
   * `x <= 20` this is the `20`, and on `y > 0` it is `y`.
   */
  Instruction getGreater() { none() }

  /**
   * Gets the operand on the "lesser" (or "lesser-or-equal") side
   * of this relational instruction, that is, the side that is smaller
   * if the overall instruction evaluates to `true`; for example on
   * `x <= 20` this is `x`, and on `y > 0` it is the `0`.
   */
  Instruction getLesser() { none() }

  /**
   * Holds if this relational instruction is strict (is not an "or-equal" instruction).
   */
  predicate isStrict() { none() }
}

/**
 * An instruction that returns a `true` result if its left operand is less than its right operand.
 *
 * Both operands must have the same numeric or address type. The result must have a Boolean type.
 * The result is `true` if the `left < right`, and `false` if `left >= right` or if the two operands
 * are unordered. Floating-point comparison is performed according to IEEE-754.
 */
class CompareLTInstruction extends RelationalInstruction {
  CompareLTInstruction() { this.getOpcode() instanceof Opcode::CompareLT }

  override Instruction getLesser() { result = this.getLeft() }

  override Instruction getGreater() { result = this.getRight() }

  override predicate isStrict() { any() }
}

/**
 * An instruction that returns a `true` result if its left operand is greater than its right operand.
 *
 * Both operands must have the same numeric or address type. The result must have a Boolean type.
 * The result is `true` if the `left > right`, and `false` if `left <= right` or if the two operands
 * are unordered. Floating-point comparison is performed according to IEEE-754.
 */
class CompareGTInstruction extends RelationalInstruction {
  CompareGTInstruction() { this.getOpcode() instanceof Opcode::CompareGT }

  override Instruction getLesser() { result = this.getRight() }

  override Instruction getGreater() { result = this.getLeft() }

  override predicate isStrict() { any() }
}

/**
 * An instruction that returns a `true` result if its left operand is less than or equal to its
 * right operand.
 *
 * Both operands must have the same numeric or address type. The result must have a Boolean type.
 * The result is `true` if the `left <= right`, and `false` if `left > right` or if the two operands
 * are unordered. Floating-point comparison is performed according to IEEE-754.
 */
class CompareLEInstruction extends RelationalInstruction {
  CompareLEInstruction() { this.getOpcode() instanceof Opcode::CompareLE }

  override Instruction getLesser() { result = this.getLeft() }

  override Instruction getGreater() { result = this.getRight() }

  override predicate isStrict() { none() }
}

/**
 * An instruction that returns a `true` result if its left operand is greater than or equal to its
 * right operand.
 *
 * Both operands must have the same numeric or address type. The result must have a Boolean type.
 * The result is `true` if the `left >= right`, and `false` if `left < right` or if the two operands
 * are unordered. Floating-point comparison is performed according to IEEE-754.
 */
class CompareGEInstruction extends RelationalInstruction {
  CompareGEInstruction() { this.getOpcode() instanceof Opcode::CompareGE }

  override Instruction getLesser() { result = this.getRight() }

  override Instruction getGreater() { result = this.getLeft() }

  override predicate isStrict() { none() }
}

/**
 * An instruction that branches to one of multiple successor instructions based on the value of an
 * integer operand.
 *
 * This instruction will have zero or more successors whose edge kind is `CaseEdge`, each
 * representing the branch that will be taken if the controlling expression is within the range
 * specified for that case edge. The range of a case edge must be disjoint from the range of each
 * other case edge.
 *
 * The instruction may optionally have a successor edge whose edge kind is `DefaultEdge`,
 * representing the branch that will be taken if the controlling expression is not within the range
 * of any case edge.
 */
class SwitchInstruction extends Instruction {
  SwitchInstruction() { this.getOpcode() instanceof Opcode::Switch }

  /** Gets the operand that provides the integer value controlling the switch. */
  final ConditionOperand getExpressionOperand() { result = this.getAnOperand() }

  /** Gets the instruction whose result provides the integer value controlling the switch. */
  final Instruction getExpression() { result = this.getExpressionOperand().getDef() }

  /** Gets the successor instructions along the case edges of the switch. */
  final Instruction getACaseSuccessor() { exists(CaseEdge edge | result = this.getSuccessor(edge)) }

  /** Gets the successor instruction along the default edge of the switch, if any. */
  final Instruction getDefaultSuccessor() { result = this.getSuccessor(EdgeKind::defaultEdge()) }
}

/**
 * An instruction that calls a function.
 */
class CallInstruction extends Instruction {
  CallInstruction() { this.getOpcode() instanceof Opcode::Call }

  final override string getImmediateString() {
    result = this.getStaticCallTarget().toString()
    or
    not exists(this.getStaticCallTarget()) and result = "?"
  }

  /**
   * Gets the operand the specifies the target function of the call.
   */
  final CallTargetOperand getCallTargetOperand() { result = this.getAnOperand() }

  /**
   * Gets the `Instruction` that computes the target function of the call. This is usually a
   * `FunctionAddress` instruction, but can also be an arbitrary instruction that produces a
   * function pointer.
   */
  final Instruction getCallTarget() { result = this.getCallTargetOperand().getDef() }

  /**
   * Gets all of the argument operands of the call, including the `this` pointer, if any.
   */
  final ArgumentOperand getAnArgumentOperand() { result = this.getAnOperand() }

  /**
   * Gets the `Function` that the call targets, if this is statically known.
   */
  final Language::Function getStaticCallTarget() {
    result = this.getCallTarget().(FunctionAddressInstruction).getFunctionSymbol()
  }

  /**
   * Gets all of the arguments of the call, including the `this` pointer, if any.
   */
  final Instruction getAnArgument() { result = this.getAnArgumentOperand().getDef() }

  /**
   * Gets the `this` pointer argument operand of the call, if any.
   */
  final ThisArgumentOperand getThisArgumentOperand() { result = this.getAnOperand() }

  /**
   * Gets the `this` pointer argument of the call, if any.
   */
  final Instruction getThisArgument() { result = this.getThisArgumentOperand().getDef() }

  /**
   * Gets the argument operand at the specified index.
   */
  pragma[noinline]
  final PositionalArgumentOperand getPositionalArgumentOperand(int index) {
    result = this.getAnOperand() and
    result.getIndex() = index
  }

  /**
   * Gets the argument at the specified index.
   */
  pragma[noinline]
  final Instruction getPositionalArgument(int index) {
    result = this.getPositionalArgumentOperand(index).getDef()
  }

  /**
   * Gets the argument operand at the specified index, or `this` if `index` is `-1`.
   */
  pragma[noinline]
  final ArgumentOperand getArgumentOperand(int index) {
    index >= 0 and result = this.getPositionalArgumentOperand(index)
    or
    index = -1 and result = this.getThisArgumentOperand()
  }

  /**
   * Gets the argument at the specified index, or `this` if `index` is `-1`.
   */
  pragma[noinline]
  final Instruction getArgument(int index) { result = this.getArgumentOperand(index).getDef() }

  /**
   * Gets the number of arguments of the call, including the `this` pointer, if any.
   */
  final int getNumberOfArguments() { result = count(this.getAnArgumentOperand()) }

  /**
   * Holds if the result is a side effect for the argument at the specified index, or `this` if
   * `index` is `-1`.
   *
   * This helper predicate makes it easy to join on both of these columns at once, avoiding
   * pathological join orders in case the argument index should get joined first.
   */
  pragma[noinline]
  final SideEffectInstruction getAParameterSideEffect(int index) {
    this = result.getPrimaryInstruction() and
    index = result.(IndexedInstruction).getIndex()
  }
}

/**
 * An instruction representing a side effect of a function call.
 */
class SideEffectInstruction extends Instruction {
  SideEffectInstruction() { this.getOpcode() instanceof SideEffectOpcode }

  /**
   * Gets the instruction whose execution causes this side effect.
   */
  final Instruction getPrimaryInstruction() {
    result = Construction::getPrimaryInstructionForSideEffect(this)
  }
}

/**
 * An instruction representing the side effect of a function call on any memory that might be
 * accessed by that call.
 */
class CallSideEffectInstruction extends SideEffectInstruction {
  CallSideEffectInstruction() { this.getOpcode() instanceof Opcode::CallSideEffect }
}

/**
 * An instruction representing the side effect of a function call on any memory
 * that might be read by that call.
 *
 * This instruction is emitted instead of `CallSideEffectInstruction` when it is certain that the
 * call target cannot write to escaped memory.
 */
class CallReadSideEffectInstruction extends SideEffectInstruction {
  CallReadSideEffectInstruction() { this.getOpcode() instanceof Opcode::CallReadSideEffect }
}

/**
 * An instruction representing a read side effect of a function call on a
 * specific parameter.
 */
class ReadSideEffectInstruction extends SideEffectInstruction, IndexedInstruction {
  ReadSideEffectInstruction() { this.getOpcode() instanceof ReadSideEffectOpcode }

  /** Gets the operand for the value that will be read from this instruction, if known. */
  final SideEffectOperand getSideEffectOperand() { result = this.getAnOperand() }

  /** Gets the value that will be read from this instruction, if known. */
  final Instruction getSideEffect() { result = this.getSideEffectOperand().getDef() }

  /** Gets the operand for the address from which this instruction may read. */
  final AddressOperand getArgumentOperand() { result = this.getAnOperand() }

  /** Gets the address from which this instruction may read. */
  final Instruction getArgumentDef() { result = this.getArgumentOperand().getDef() }
}

/**
 * An instruction representing the read of an indirect parameter within a function call.
 */
class IndirectReadSideEffectInstruction extends ReadSideEffectInstruction {
  IndirectReadSideEffectInstruction() { this.getOpcode() instanceof Opcode::IndirectReadSideEffect }
}

/**
 * An instruction representing the read of an indirect buffer parameter within a function call.
 */
class BufferReadSideEffectInstruction extends ReadSideEffectInstruction {
  BufferReadSideEffectInstruction() { this.getOpcode() instanceof Opcode::BufferReadSideEffect }
}

/**
 * An instruction representing the read of an indirect buffer parameter within a function call.
 */
class SizedBufferReadSideEffectInstruction extends ReadSideEffectInstruction {
  SizedBufferReadSideEffectInstruction() {
    this.getOpcode() instanceof Opcode::SizedBufferReadSideEffect
  }

  /**
   * Gets the operand that holds the number of bytes read from the buffer.
   */
  final BufferSizeOperand getBufferSizeOperand() { result = this.getAnOperand() }

  /**
   * Gets the instruction whose result provides the number of bytes read from the buffer.
   */
  final Instruction getBufferSize() { result = this.getBufferSizeOperand().getDef() }
}

/**
 * An instruction representing a write side effect of a function call on a
 * specific parameter.
 */
class WriteSideEffectInstruction extends SideEffectInstruction, IndexedInstruction {
  WriteSideEffectInstruction() { this.getOpcode() instanceof WriteSideEffectOpcode }

  /**
   * Get the operand that holds the address of the memory to be written.
   */
  final AddressOperand getDestinationAddressOperand() { result = this.getAnOperand() }

  /**
   * Gets the instruction whose result provides the address of the memory to be written.
   */
  Instruction getDestinationAddress() { result = this.getDestinationAddressOperand().getDef() }
}

/**
 * An instruction representing the write of an indirect parameter within a function call.
 */
class IndirectMustWriteSideEffectInstruction extends WriteSideEffectInstruction {
  IndirectMustWriteSideEffectInstruction() {
    this.getOpcode() instanceof Opcode::IndirectMustWriteSideEffect
  }
}

/**
 * An instruction representing the write of an indirect buffer parameter within a function call. The
 * entire buffer is overwritten.
 */
class BufferMustWriteSideEffectInstruction extends WriteSideEffectInstruction {
  BufferMustWriteSideEffectInstruction() {
    this.getOpcode() instanceof Opcode::BufferMustWriteSideEffect
  }
}

/**
 * An instruction representing the write of an indirect buffer parameter within a function call. The
 * entire buffer is overwritten.
 */
class SizedBufferMustWriteSideEffectInstruction extends WriteSideEffectInstruction {
  SizedBufferMustWriteSideEffectInstruction() {
    this.getOpcode() instanceof Opcode::SizedBufferMustWriteSideEffect
  }

  /**
   * Gets the operand that holds the number of bytes written to the buffer.
   */
  final BufferSizeOperand getBufferSizeOperand() { result = this.getAnOperand() }

  /**
   * Gets the instruction whose result provides the number of bytes written to the buffer.
   */
  final Instruction getBufferSize() { result = this.getBufferSizeOperand().getDef() }
}

/**
 * An instruction representing the potential write of an indirect parameter within a function call.
 *
 * Unlike `IndirectWriteSideEffectInstruction`, the location might not be completely overwritten.
 * written.
 */
class IndirectMayWriteSideEffectInstruction extends WriteSideEffectInstruction {
  IndirectMayWriteSideEffectInstruction() {
    this.getOpcode() instanceof Opcode::IndirectMayWriteSideEffect
  }
}

/**
 * An instruction representing the write of an indirect buffer parameter within a function call.
 *
 * Unlike `BufferWriteSideEffectInstruction`, the buffer might not be completely overwritten.
 */
class BufferMayWriteSideEffectInstruction extends WriteSideEffectInstruction {
  BufferMayWriteSideEffectInstruction() {
    this.getOpcode() instanceof Opcode::BufferMayWriteSideEffect
  }
}

/**
 * An instruction representing the write of an indirect buffer parameter within a function call.
 *
 * Unlike `BufferWriteSideEffectInstruction`, the buffer might not be completely overwritten.
 */
class SizedBufferMayWriteSideEffectInstruction extends WriteSideEffectInstruction {
  SizedBufferMayWriteSideEffectInstruction() {
    this.getOpcode() instanceof Opcode::SizedBufferMayWriteSideEffect
  }

  /**
   * Gets the operand that holds the number of bytes written to the buffer.
   */
  final BufferSizeOperand getBufferSizeOperand() { result = this.getAnOperand() }

  /**
   * Gets the instruction whose result provides the number of bytes written to the buffer.
   */
  final Instruction getBufferSize() { result = this.getBufferSizeOperand().getDef() }
}

/**
 * An instruction representing the initial value of newly allocated memory, such as the result of a
 * call to `malloc`.
 */
class InitializeDynamicAllocationInstruction extends SideEffectInstruction {
  InitializeDynamicAllocationInstruction() {
    this.getOpcode() instanceof Opcode::InitializeDynamicAllocation
  }

  /**
   * Gets the operand that represents the address of the allocation this instruction is initializing.
   */
  final AddressOperand getAllocationAddressOperand() { result = this.getAnOperand() }

  /**
   * Gets the address for the allocation this instruction is initializing.
   */
  final Instruction getAllocationAddress() { result = this.getAllocationAddressOperand().getDef() }
}

/**
 * An instruction representing a GNU or MSVC inline assembly statement.
 */
class InlineAsmInstruction extends Instruction {
  InlineAsmInstruction() { this.getOpcode() instanceof Opcode::InlineAsm }
}

/**
 * An instruction that throws an exception.
 */
class ThrowInstruction extends Instruction {
  ThrowInstruction() { this.getOpcode() instanceof ThrowOpcode }
}

/**
 * An instruction that throws a new exception.
 */
class ThrowValueInstruction extends ThrowInstruction {
  ThrowValueInstruction() { this.getOpcode() instanceof Opcode::ThrowValue }

  /**
   * Gets the address operand of the exception thrown by this instruction.
   */
  final AddressOperand getExceptionAddressOperand() { result = this.getAnOperand() }

  /**
   * Gets the address of the exception thrown by this instruction.
   */
  final Instruction getExceptionAddress() { result = this.getExceptionAddressOperand().getDef() }

  /**
   * Gets the operand for the exception thrown by this instruction.
   */
  final LoadOperand getExceptionOperand() { result = this.getAnOperand() }

  /**
   * Gets the exception thrown by this instruction.
   */
  final Instruction getException() { result = this.getExceptionOperand().getDef() }
}

/**
 * An instruction that re-throws the current exception.
 */
class ReThrowInstruction extends ThrowInstruction {
  ReThrowInstruction() { this.getOpcode() instanceof Opcode::ReThrow }
}

/**
 * An instruction that exits the current function by propagating an exception.
 */
class UnwindInstruction extends Instruction {
  UnwindInstruction() { this.getOpcode() instanceof Opcode::Unwind }
}

/**
 * An instruction that starts a `catch` handler.
 */
class CatchInstruction extends Instruction {
  CatchInstruction() { this.getOpcode() instanceof CatchOpcode }
}

/**
 * An instruction that catches an exception of a specific type.
 */
class CatchByTypeInstruction extends CatchInstruction {
  Language::LanguageType exceptionType;

  CatchByTypeInstruction() {
    this.getOpcode() instanceof Opcode::CatchByType and
    exceptionType = Raw::getInstructionExceptionType(this)
  }

  final override string getImmediateString() { result = exceptionType.toString() }

  /**
   * Gets the type of exception to be caught.
   */
  final Language::LanguageType getExceptionType() { result = exceptionType }
}

/**
 * An instruction that catches any exception.
 */
class CatchAnyInstruction extends CatchInstruction {
  CatchAnyInstruction() { this.getOpcode() instanceof Opcode::CatchAny }
}

/**
 * An instruction that initializes all escaped memory.
 */
class AliasedDefinitionInstruction extends Instruction {
  AliasedDefinitionInstruction() { this.getOpcode() instanceof Opcode::AliasedDefinition }
}

/**
 * An instruction that consumes all escaped memory on exit from the function.
 */
class AliasedUseInstruction extends Instruction {
  AliasedUseInstruction() { this.getOpcode() instanceof Opcode::AliasedUse }
}

/**
 * An instruction representing the choice of one of multiple input values based on control flow.
 *
 * A `PhiInstruction` is inserted at the beginning of a block whenever two different definitions of
 * the same variable reach that block. The `PhiInstruction` will have one operand corresponding to
 * each control flow predecessor of the block, with that operand representing the version of the
 * variable that flows from that predecessor. The result value of the `PhiInstruction` will be
 * a copy of whichever operand corresponds to the actual predecessor that entered the block at
 * runtime.
 */
class PhiInstruction extends Instruction {
  PhiInstruction() { this.getOpcode() instanceof Opcode::Phi }

  /**
   * Gets all of the instruction's `PhiInputOperand`s, representing the values that flow from each predecessor block.
   */
  final PhiInputOperand getAnInputOperand() { result = this.getAnOperand() }

  /**
   * Gets an instruction that defines the input to one of the operands of this
   * instruction. It's possible for more than one operand to have the same
   * defining instruction, so this predicate will have the same number of
   * results as `getAnInputOperand()` or fewer.
   */
  pragma[noinline]
  final Instruction getAnInput() { result = this.getAnInputOperand().getDef() }

  /**
   * Gets the input operand representing the value that flows from the specified predecessor block.
   */
  final PhiInputOperand getInputOperand(IRBlock predecessorBlock) {
    result = this.getAnOperand() and
    result.getPredecessorBlock() = predecessorBlock
  }
}

/**
 * An instruction representing the effect that a write to a memory may have on potential aliases of
 * that memory.
 *
 * A `ChiInstruction` is inserted immediately after an instruction that writes to memory. The
 * `ChiInstruction` has two operands. The first operand, given by `getTotalOperand()`, represents
 * the previous state of all of the memory that might be aliased by the memory write. The second
 * operand, given by `getPartialOperand()`, represents the memory that was actually modified by the
 * memory write. The result of the `ChiInstruction` represents the same memory as
 * `getTotalOperand()`, updated to include the changes due to the value that was actually stored by
 * the memory write.
 *
 * As an example, suppose that variable `p` and `q` are pointers that may or may not point to the
 * same memory:
 * ```
 * *p = 5;
 * x = *q;
 * ```
 *
 * The IR would look like:
 * ```
 * r1_1 = VariableAddress[p]
 * r1_2 = Load r1_1, m0_0  // Load the value of `p`
 * r1_3 = Constant[5]
 * m1_4 = Store r1_2, r1_3  // Store to `*p`
 * m1_5 = ^Chi m0_1, m1_4  // Side effect of the previous Store on aliased memory
 * r1_6 = VariableAddress[x]
 * r1_7 = VariableAddress[q]
 * r1_8 = Load r1_7, m0_2  // Load the value of `q`
 * r1_9 = Load r1_8, m1_5  // Load the value of `*q`
 * m1_10 = Store r1_6, r1_9  // Store to x
 * ```
 *
 * Note the `Chi` instruction after the store to `*p`. The indicates that the previous contents of
 * aliased memory (`m0_1`) are merged with the new value written by the store (`m1_4`), producing a
 * new version of aliased memory (`m1_5`). On the subsequent load from `*q`, the source operand of
 * `*q` is `m1_5`, indicating that the store to `*p` may (or may not) have updated the memory
 * pointed to by `q`.
 *
 * For more information about how `Chi` instructions are used to model memory side effects, see
 * https://link.springer.com/content/pdf/10.1007%2F3-540-61053-7_66.pdf.
 */
class ChiInstruction extends Instruction {
  ChiInstruction() { this.getOpcode() instanceof Opcode::Chi }

  /**
   * Gets the operand that represents the previous state of all memory that might be aliased by the
   * memory write.
   */
  final ChiTotalOperand getTotalOperand() { result = this.getAnOperand() }

  /**
   * Gets the operand that represents the previous state of all memory that might be aliased by the
   * memory write.
   */
  final Instruction getTotal() { result = this.getTotalOperand().getDef() }

  /**
   * Gets the operand that represents the new value written by the memory write.
   */
  final ChiPartialOperand getPartialOperand() { result = this.getAnOperand() }

  /**
   * Gets the operand that represents the new value written by the memory write.
   */
  final Instruction getPartial() { result = this.getPartialOperand().getDef() }

  /**
   * Holds if the `ChiPartialOperand` totally, but not exactly, overlaps with the `ChiTotalOperand`.
   * This means that the `ChiPartialOperand` will not override the entire memory associated with the
   * `ChiTotalOperand`.
   */
  final predicate isPartialUpdate() { Construction::chiOnlyPartiallyUpdatesLocation(this) }
}

/**
 * An instruction that initializes a set of allocations that are each assigned
 * the same "virtual variable".
 *
 * As an example, consider the following snippet:
 * ```
 * int a;
 * int b;
 * int* p;
 * if(b) {
 *   p = &a;
 * } else {
 *   p = &b;
 * }
 * *p = 5;
 * int x = a;
 * ```
 *
 * Since both the address of `a` and `b` reach `p` at `*p = 5` the IR alias
 * analysis will create a region that contains both `a` and `b`. The region
 * containing both `a` and `b` are initialized by an `UninitializedGroup`
 * instruction in the entry block of the enclosing function.
 */
class UninitializedGroupInstruction extends Instruction {
  UninitializedGroupInstruction() { this.getOpcode() instanceof Opcode::UninitializedGroup }

  /**
   * Gets an `IRVariable` whose memory is initialized by this instruction, if any.
   * Note: Allocations that are not represented as `IRVariable`s (such as
   * dynamic allocations) are not returned by this predicate even if this
   * instruction initializes such memory.
   */
  final IRVariable getAnIRVariable() {
    result = Construction::getAnUninitializedGroupVariable(this)
  }

  final override string getImmediateString() {
    result = strictconcat(this.getAnIRVariable().toString(), ",")
  }
}

/**
 * An instruction representing unreachable code.
 *
 * This instruction is inserted in place of the original target instruction of a `ConditionalBranch`
 * or `Switch` instruction where that particular edge is infeasible.
 */
class UnreachedInstruction extends Instruction {
  UnreachedInstruction() { this.getOpcode() instanceof Opcode::Unreached }
}

/**
 * An instruction representing a built-in operation.
 *
 * This is used to represent a variety of intrinsic operations provided by the compiler
 * implementation, such as vector arithmetic.
 */
class BuiltInOperationInstruction extends Instruction {
  Language::BuiltInOperation operation;

  BuiltInOperationInstruction() {
    this.getOpcode() instanceof BuiltInOperationOpcode and
    operation = Raw::getInstructionBuiltInOperation(this)
  }

  /**
   * Gets the language-specific `BuiltInOperation` object that specifies the operation that is
   * performed by this instruction.
   */
  final Language::BuiltInOperation getBuiltInOperation() { result = operation }
}

/**
 * An instruction representing a built-in operation that does not have a specific opcode. The
 * actual operation is specified by the `getBuiltInOperation()` predicate.
 */
class BuiltInInstruction extends BuiltInOperationInstruction {
  BuiltInInstruction() { this.getOpcode() instanceof Opcode::BuiltIn }

  final override string getImmediateString() { result = this.getBuiltInOperation().toString() }
}

/**
 * An instruction that returns a `va_list` to access the arguments passed to the `...` parameter.
 *
 * The operand specifies the address of the `IREllipsisVariable` used to represent the `...`
 * parameter. The result is a `va_list` that initially refers to the first argument that was passed
 * to the `...` parameter.
 */
class VarArgsStartInstruction extends UnaryInstruction {
  VarArgsStartInstruction() { this.getOpcode() instanceof Opcode::VarArgsStart }
}

/**
 * An instruction that cleans up a `va_list` after it is no longer in use.
 *
 * The operand specifies the address of the `va_list` to clean up. This instruction does not return
 * a result.
 */
class VarArgsEndInstruction extends UnaryInstruction {
  VarArgsEndInstruction() { this.getOpcode() instanceof Opcode::VarArgsEnd }
}

/**
 * An instruction that returns the address of the argument currently pointed to by a `va_list`.
 *
 * The operand is the `va_list` that points to the argument. The result is the address of the
 * argument.
 */
class VarArgInstruction extends UnaryInstruction {
  VarArgInstruction() { this.getOpcode() instanceof Opcode::VarArg }
}

/**
 * An instruction that modifies a `va_list` to point to the next argument that was passed to the
 * `...` parameter.
 *
 * The operand is the current `va_list`. The result is an updated `va_list` that points to the next
 * argument of the `...` parameter.
 */
class NextVarArgInstruction extends UnaryInstruction {
  NextVarArgInstruction() { this.getOpcode() instanceof Opcode::NextVarArg }
}

/**
 * An instruction that allocates a new object on the managed heap.
 *
 * This instruction is used to represent the allocation of a new object in C# using the `new`
 * expression. This instruction does not invoke a constructor for the object. Instead, there will be
 * a subsequent `Call` instruction to invoke the appropriate constructor directory, passing the
 * result of the `NewObj` as the `this` argument.
 *
 * The result is the address of the newly allocated object.
 */
class NewObjInstruction extends Instruction {
  NewObjInstruction() { this.getOpcode() instanceof Opcode::NewObj }
}
