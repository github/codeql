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
  final string toString() { result = getOpcode().toString() + ": " + getAST().toString() }

  /**
   * Gets a string showing the result, opcode, and operands of the instruction, equivalent to what
   * would be printed by PrintIR.ql. For example:
   *
   * `mu0_28(int) = Store r0_26, r0_27`
   */
  final string getDumpString() {
    result = getResultString() + " = " + getOperationString() + " " + getOperandsString()
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
    shouldGenerateDumpStrings() and
    if exists(getImmediateString())
    then result = getOperationPrefix() + getOpcode().toString() + "[" + getImmediateString() + "]"
    else result = getOperationPrefix() + getOpcode().toString()
  }

  /**
   * Gets a string describing the immediate value of this instruction, if any.
   */
  string getImmediateString() { none() }

  private string getOperationPrefix() {
    shouldGenerateDumpStrings() and
    if this instanceof SideEffectInstruction then result = "^" else result = ""
  }

  private string getResultPrefix() {
    shouldGenerateDumpStrings() and
    if getResultIRType() instanceof IRVoidType
    then result = "v"
    else
      if hasMemoryResult()
      then if isResultModeled() then result = "m" else result = "mu"
      else result = "r"
  }

  /**
   * Gets the zero-based index of this instruction within its block. This is
   * used by debugging and printing code only.
   */
  int getDisplayIndexInBlock() {
    shouldGenerateDumpStrings() and
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
    shouldGenerateDumpStrings() and
    this =
      rank[result](Instruction instr |
        instr =
          getAnInstructionAtLine(getEnclosingIRFunction(), getLocation().getFile(),
            getLocation().getStartLine())
      |
        instr order by instr.getBlock().getDisplayIndex(), instr.getDisplayIndexInBlock()
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
    shouldGenerateDumpStrings() and
    result = getResultPrefix() + getAST().getLocation().getStartLine() + "_" + getLineRank()
  }

  /**
   * Gets a string describing the result of this instruction, suitable for
   * display in IR dumps. This consists of the result ID plus the type of the
   * result.
   *
   * Example: `r1_1(int*)`
   */
  final string getResultString() {
    shouldGenerateDumpStrings() and
    result = getResultId() + "(" + getResultLanguageType().getDumpString() + ")"
  }

  /**
   * Gets a string describing the operands of this instruction, suitable for
   * display in IR dumps.
   *
   * Example: `func:r3_4, this:r3_5`
   */
  string getOperandsString() {
    shouldGenerateDumpStrings() and
    result =
      concat(Operand operand |
        operand = getAnOperand()
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
   * Gets the basic block that contains this instruction.
   */
  final IRBlock getBlock() { result.getAnInstruction() = this }

  /**
   * Gets the function that contains this instruction.
   */
  final Language::Function getEnclosingFunction() {
    result = getEnclosingIRFunction().getFunction()
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
  final Language::AST getAST() { result = Construction::getInstructionAST(this) }

  /**
   * Gets the location of the source code for this instruction.
   */
  final Language::Location getLocation() { result = getAST().getLocation() }

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
  cached
  final IRType getResultIRType() { result = getResultLanguageType().getIRType() }

  /**
   * Gets the type of the result produced by this instruction. If the
   * instruction does not produce a result, its result type will be `VoidType`.
   *
   * If `isGLValue()` holds, then the result type of this instruction should be
   * thought of as "pointer to `getResultType()`".
   */
  final Language::Type getResultType() {
    exists(Language::LanguageType resultType |
      resultType = getResultLanguageType() and
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
  final predicate isGLValue() { getResultLanguageType().hasType(_, true) }

  /**
   * Gets the size of the result produced by this instruction, in bytes. If the
   * result does not have a known constant size, this predicate does not hold.
   *
   * If `this.isGLValue()` holds for this instruction, the value of
   * `getResultSize()` will always be the size of a pointer.
   */
  final int getResultSize() { result = getResultLanguageType().getByteSize() }

  /**
   * Gets the opcode that specifies the operation performed by this instruction.
   */
  final Opcode getOpcode() { result = Construction::getInstructionOpcode(this) }

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
  final predicate hasMemoryResult() { exists(getResultMemoryAccess()) }

  /**
   * Gets the kind of memory access performed by this instruction's result.
   * Holds only for instructions with a memory result.
   */
  pragma[inline]
  final MemoryAccessKind getResultMemoryAccess() { result = getOpcode().getWriteMemoryAccess() }

  /**
   * Holds if the memory access performed by this instruction's result will not always write to
   * every bit in the memory location. This is most commonly used for memory accesses that may or
   * may not actually occur depending on runtime state (for example, the write side effect of an
   * output parameter that is not written to on all paths), or for accesses where the memory
   * location is a conservative estimate of the memory that might actually be accessed at runtime
   * (for example, the global side effects of a function call).
   */
  pragma[inline]
  final predicate hasResultMayMemoryAccess() { getOpcode().hasMayWriteMemoryAccess() }

  /**
   * Gets the operand that holds the memory address to which this instruction stores its
   * result, if any. For example, in `m3 = Store r1, r2`, the result of `getResultAddressOperand()`
   * is `r1`.
   */
  final AddressOperand getResultAddressOperand() {
    getResultMemoryAccess().usesAddressOperand() and
    result.getUse() = this
  }

  /**
   * Gets the instruction that holds the exact memory address to which this instruction stores its
   * result, if any. For example, in `m3 = Store r1, r2`, the result of `getResultAddressOperand()`
   * is the instruction that defines `r1`.
   */
  final Instruction getResultAddress() { result = getResultAddressOperand().getDef() }

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
    not hasMemoryResult() or
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
  final Instruction getASuccessor() { result = getSuccessor(_) }

  /**
   * Gets a predecessor of this instruction such that the predecessor reaches
   * this instruction along the control flow edge specified by `kind`.
   */
  final Instruction getPredecessor(EdgeKind kind) { result.getSuccessor(kind) = this }

  /**
   * Gets all direct predecessors of this instruction.
   */
  final Instruction getAPredecessor() { result = getPredecessor(_) }
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
  final Language::Variable getASTVariable() { result = var.(IRUserVariable).getVariable() }
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
  EnterFunctionInstruction() { getOpcode() instanceof Opcode::EnterFunction }
}

/**
 * An instruction that returns the address of a variable.
 *
 * This instruction returns the address of a local variable, parameter, static field,
 * namespace-scope variable, or global variable. For the address of a non-static field of a class,
 * struct, or union, see `FieldAddressInstruction`.
 */
class VariableAddressInstruction extends VariableInstruction {
  VariableAddressInstruction() { getOpcode() instanceof Opcode::VariableAddress }
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
  FunctionAddressInstruction() { getOpcode() instanceof Opcode::FunctionAddress }
}

/**
 * An instruction that initializes a parameter of the enclosing function with the value of the
 * corresponding argument passed by the caller.
 *
 * Each parameter of a function will have exactly one `InitializeParameter` instruction that
 * initializes that parameter.
 */
class InitializeParameterInstruction extends VariableInstruction {
  InitializeParameterInstruction() { getOpcode() instanceof Opcode::InitializeParameter }

  /**
   * Gets the parameter initialized by this instruction.
   */
  final Language::Parameter getParameter() { result = var.(IRUserVariable).getVariable() }
}

/**
 * An instruction that initializes all memory that existed before this function was called.
 *
 * This instruction provides a definition for memory that, because it was actually allocated and
 * initialized elsewhere, would not otherwise have a definition in this function.
 */
class InitializeNonLocalInstruction extends Instruction {
  InitializeNonLocalInstruction() { getOpcode() instanceof Opcode::InitializeNonLocal }
}

/**
 * An instruction that initializes the memory pointed to by a parameter of the enclosing function
 * with the value of that memory on entry to the function.
 */
class InitializeIndirectionInstruction extends VariableInstruction {
  InitializeIndirectionInstruction() { getOpcode() instanceof Opcode::InitializeIndirection }

  /**
   * Gets the parameter initialized by this instruction.
   */
  final Language::Parameter getParameter() { result = var.(IRUserVariable).getVariable() }
}

/**
 * An instruction that initializes the `this` pointer parameter of the enclosing function.
 */
class InitializeThisInstruction extends Instruction {
  InitializeThisInstruction() { getOpcode() instanceof Opcode::InitializeThis }
}

/**
 * An instruction that computes the address of a non-static field of an object.
 */
class FieldAddressInstruction extends FieldInstruction {
  FieldAddressInstruction() { getOpcode() instanceof Opcode::FieldAddress }

  /**
   * Gets the operand that provides the address of the object containing the field.
   */
  final UnaryOperand getObjectAddressOperand() { result = getAnOperand() }

  /**
   * Gets the instruction whose result provides the address of the object containing the field.
   */
  final Instruction getObjectAddress() { result = getObjectAddressOperand().getDef() }
}

/**
 * An instruction that computes the address of the first element of a managed array.
 *
 * This instruction is used for element access to C# arrays.
 */
class ElementsAddressInstruction extends UnaryInstruction {
  ElementsAddressInstruction() { getOpcode() instanceof Opcode::ElementsAddress }

  /**
   * Gets the operand that provides the address of the array object.
   */
  final UnaryOperand getArrayObjectAddressOperand() { result = getAnOperand() }

  /**
   * Gets the instruction whose result provides the address of the array object.
   */
  final Instruction getArrayObjectAddress() { result = getArrayObjectAddressOperand().getDef() }
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
  ErrorInstruction() { getOpcode() instanceof Opcode::Error }
}

/**
 * An instruction that returns an uninitialized value.
 *
 * This instruction is used to provide an initial definition for a stack variable that does not have
 * an initializer, or whose initializer only partially initializes the variable.
 */
class UninitializedInstruction extends VariableInstruction {
  UninitializedInstruction() { getOpcode() instanceof Opcode::Uninitialized }

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
  NoOpInstruction() { getOpcode() instanceof Opcode::NoOp }
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
 * There are two differet return instructions: `ReturnValueInstruction`, for returning a value from
 * a non-`void`-returning function, and `ReturnVoidInstruction`, for returning from a
 * `void`-returning function.
 */
class ReturnInstruction extends Instruction {
  ReturnInstruction() { getOpcode() instanceof ReturnOpcode }
}

/**
 * An instruction that returns control to the caller of the function, without returning a value.
 */
class ReturnVoidInstruction extends ReturnInstruction {
  ReturnVoidInstruction() { getOpcode() instanceof Opcode::ReturnVoid }
}

/**
 * An instruction that returns control to the caller of the function, including a return value.
 */
class ReturnValueInstruction extends ReturnInstruction {
  ReturnValueInstruction() { getOpcode() instanceof Opcode::ReturnValue }

  /**
   * Gets the operand that provides the value being returned by the function.
   */
  final LoadOperand getReturnValueOperand() { result = getAnOperand() }

  /**
   * Gets the instruction whose result provides the value being returned by the function, if an
   * exact definition is available.
   */
  final Instruction getReturnValue() { result = getReturnValueOperand().getDef() }
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
  ReturnIndirectionInstruction() { getOpcode() instanceof Opcode::ReturnIndirection }

  /**
   * Gets the operand that provides the value of the pointed-to memory.
   */
  final SideEffectOperand getSideEffectOperand() { result = getAnOperand() }

  /**
   * Gets the instruction whose result provides the value of the pointed-to memory, if an exact
   * definition is available.
   */
  final Instruction getSideEffect() { result = getSideEffectOperand().getDef() }

  /**
   * Gets the operand that provides the address of the pointed-to memory.
   */
  final AddressOperand getSourceAddressOperand() { result = getAnOperand() }

  /**
   * Gets the instruction whose result provides the address of the pointed-to memory.
   */
  final Instruction getSourceAddress() { result = getSourceAddressOperand().getDef() }

  /**
   * Gets the parameter for which this instruction reads the final pointed-to value within the
   * function.
   */
  final Language::Parameter getParameter() { result = var.(IRUserVariable).getVariable() }

  /**
   * Holds if this instruction is the return indirection for `this`.
   */
  final predicate isThisIndirection() { var instanceof IRThisVariable }
}

/**
 * An instruction that returns a copy of its operand.
 *
 * There are several different copy instructions, depending on the source and destination of the
 * copy operation:
 * - `CopyInstruction` - Copies a register operand to a register result.
 * - `LoadInstruction` - Copies a memory operand to a register result.
 * - `StoreInstruction` - Copies a register operand to a memory result.
 */
class CopyInstruction extends Instruction {
  CopyInstruction() { getOpcode() instanceof CopyOpcode }

  /**
   * Gets the operand that provides the input value of the copy.
   */
  Operand getSourceValueOperand() { none() }

  /**
   * Gets the instruction whose result provides the input value of the copy, if an exact definition
   * is available.
   */
  final Instruction getSourceValue() { result = getSourceValueOperand().getDef() }
}

/**
 * An instruction that returns a register result containing a copy of its register operand.
 */
class CopyValueInstruction extends CopyInstruction, UnaryInstruction {
  CopyValueInstruction() { getOpcode() instanceof Opcode::CopyValue }

  final override UnaryOperand getSourceValueOperand() { result = getAnOperand() }
}

/**
 * An instruction that returns a register result containing a copy of its memory operand.
 */
class LoadInstruction extends CopyInstruction {
  LoadInstruction() { getOpcode() instanceof Opcode::Load }

  /**
   * Gets the operand that provides the address of the value being loaded.
   */
  final AddressOperand getSourceAddressOperand() { result = getAnOperand() }

  /**
   * Gets the instruction whose result provides the address of the value being loaded.
   */
  final Instruction getSourceAddress() { result = getSourceAddressOperand().getDef() }

  final override LoadOperand getSourceValueOperand() { result = getAnOperand() }
}

/**
 * An instruction that returns a memory result containing a copy of its register operand.
 */
class StoreInstruction extends CopyInstruction {
  StoreInstruction() { getOpcode() instanceof Opcode::Store }

  /**
   * Gets the operand that provides the address of the location to which the value will be stored.
   */
  final AddressOperand getDestinationAddressOperand() { result = getAnOperand() }

  /**
   * Gets the instruction whose result provides the address of the location to which the value will
   * be stored, if an exact definition is available.
   */
  final Instruction getDestinationAddress() { result = getDestinationAddressOperand().getDef() }

  final override StoreValueOperand getSourceValueOperand() { result = getAnOperand() }
}

/**
 * An instruction that branches to one of two successor instructions based on the value of a Boolean
 * operand.
 */
class ConditionalBranchInstruction extends Instruction {
  ConditionalBranchInstruction() { getOpcode() instanceof Opcode::ConditionalBranch }

  /**
   * Gets the operand that provides the Boolean condition controlling the branch.
   */
  final ConditionOperand getConditionOperand() { result = getAnOperand() }

  /**
   * Gets the instruction whose result provides the Boolean condition controlling the branch.
   */
  final Instruction getCondition() { result = getConditionOperand().getDef() }

  /**
   * Gets the instruction to which control will flow if the condition is true.
   */
  final Instruction getTrueSuccessor() { result = getSuccessor(EdgeKind::trueEdge()) }

  /**
   * Gets the instruction to which control will flow if the condition is false.
   */
  final Instruction getFalseSuccessor() { result = getSuccessor(EdgeKind::falseEdge()) }
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
  ExitFunctionInstruction() { getOpcode() instanceof Opcode::ExitFunction }
}

/**
 * An instruction whose result is a constant value.
 */
class ConstantInstruction extends ConstantValueInstruction {
  ConstantInstruction() { getOpcode() instanceof Opcode::Constant }
}

/**
 * An instruction whose result is a constant value of integer or Boolean type.
 */
class IntegerConstantInstruction extends ConstantInstruction {
  IntegerConstantInstruction() {
    exists(IRType resultType |
      resultType = getResultIRType() and
      (resultType instanceof IRIntegerType or resultType instanceof IRBooleanType)
    )
  }
}

/**
 * An instruction whose result is a constant value of floating-point type.
 */
class FloatConstantInstruction extends ConstantInstruction {
  FloatConstantInstruction() { getResultIRType() instanceof IRFloatingPointType }
}

/**
 * An instruction whose result is the address of a string literal.
 */
class StringConstantInstruction extends VariableInstruction {
  override IRStringLiteral var;

  final override string getImmediateString() { result = Language::getStringLiteralText(getValue()) }

  /**
   * Gets the string literal whose address is returned by this instruction.
   */
  final Language::StringLiteral getValue() { result = var.getLiteral() }
}

/**
 * An instruction whose result is computed from two operands.
 */
class BinaryInstruction extends Instruction {
  BinaryInstruction() { getOpcode() instanceof BinaryOpcode }

  /**
   * Gets the left operand of this binary instruction.
   */
  final LeftOperand getLeftOperand() { result = getAnOperand() }

  /**
   * Gets the right operand of this binary instruction.
   */
  final RightOperand getRightOperand() { result = getAnOperand() }

  /**
   * Gets the instruction whose result provides the value of the left operand of this binary
   * instruction.
   */
  final Instruction getLeft() { result = getLeftOperand().getDef() }

  /**
   * Gets the instruction whose result provides the value of the right operand of this binary
   * instruction.
   */
  final Instruction getRight() { result = getRightOperand().getDef() }

  /**
   * Holds if this instruction's operands are `op1` and `op2`, in either order.
   */
  final predicate hasOperands(Operand op1, Operand op2) {
    op1 = getLeftOperand() and op2 = getRightOperand()
    or
    op1 = getRightOperand() and op2 = getLeftOperand()
  }
}

/**
 * An instruction that computes the result of an arithmetic operation.
 */
class ArithmeticInstruction extends Instruction {
  ArithmeticInstruction() { getOpcode() instanceof ArithmeticOpcode }
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
  AddInstruction() { getOpcode() instanceof Opcode::Add }
}

/**
 * An instruction that computes the difference of two numeric operands.
 *
 * Both operands must have the same numeric type, which will also be the result type. The result of
 * integer overflow is the infinite-precision result modulo 2^n. Floating-point subtraction is performed
 * according to IEEE-754.
 */
class SubInstruction extends BinaryArithmeticInstruction {
  SubInstruction() { getOpcode() instanceof Opcode::Sub }
}

/**
 * An instruction that computes the product of two numeric operands.
 *
 * Both operands must have the same numeric type, which will also be the result type. The result of
 * integer overflow is the infinite-precision result modulo 2^n. Floating-point multiplication is
 * performed according to IEEE-754.
 */
class MulInstruction extends BinaryArithmeticInstruction {
  MulInstruction() { getOpcode() instanceof Opcode::Mul }
}

/**
 * An instruction that computes the quotient of two numeric operands.
 *
 * Both operands must have the same numeric type, which will also be the result type. The result of
 * division by zero or integer overflow is undefined. Floating-point division is performed according
 * to IEEE-754.
 */
class DivInstruction extends BinaryArithmeticInstruction {
  DivInstruction() { getOpcode() instanceof Opcode::Div }
}

/**
 * An instruction that computes the remainder of two integer operands.
 *
 * Both operands must have the same integer type, which will also be the result type. The result of
 * division by zero or integer overflow is undefined.
 */
class RemInstruction extends BinaryArithmeticInstruction {
  RemInstruction() { getOpcode() instanceof Opcode::Rem }
}

/**
 * An instruction that negates a single numeric operand.
 *
 * The operand must have a numeric type, which will also be the result type. The result of integer
 * negation uses two's complement, and is computed modulo 2^n. The result of floating-point negation
 * is performed according to IEEE-754.
 */
class NegateInstruction extends UnaryArithmeticInstruction {
  NegateInstruction() { getOpcode() instanceof Opcode::Negate }
}

/**
 * An instruction that computes the result of a bitwise operation.
 */
class BitwiseInstruction extends Instruction {
  BitwiseInstruction() { getOpcode() instanceof BitwiseOpcode }
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
  BitAndInstruction() { getOpcode() instanceof Opcode::BitAnd }
}

/**
 * An instruction that computes the bitwise "or" of two integer operands.
 *
 * Both operands must have the same integer type, which will also be the result type.
 */
class BitOrInstruction extends BinaryBitwiseInstruction {
  BitOrInstruction() { getOpcode() instanceof Opcode::BitOr }
}

/**
 * An instruction that computes the bitwise "xor" of two integer operands.
 *
 * Both operands must have the same integer type, which will also be the result type.
 */
class BitXorInstruction extends BinaryBitwiseInstruction {
  BitXorInstruction() { getOpcode() instanceof Opcode::BitXor }
}

/**
 * An instruction that shifts its left operand to the left by the number of bits specified by its
 * right operand.
 *
 * Both operands must have an integer type. The result has the same type as the left operand. The
 * rightmost bits are zero-filled.
 */
class ShiftLeftInstruction extends BinaryBitwiseInstruction {
  ShiftLeftInstruction() { getOpcode() instanceof Opcode::ShiftLeft }
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
  ShiftRightInstruction() { getOpcode() instanceof Opcode::ShiftRight }
}

/**
 * An instruction that performs a binary arithmetic operation involving at least one pointer
 * operand.
 */
class PointerArithmeticInstruction extends BinaryInstruction {
  int elementSize;

  PointerArithmeticInstruction() {
    getOpcode() instanceof PointerArithmeticOpcode and
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
  PointerOffsetInstruction() { getOpcode() instanceof PointerOffsetOpcode }
}

/**
 * An instruction that adds an integer offset to a pointer.
 *
 * The result is the byte address computed by adding the value of the right (integer) operand,
 * multiplied by the element size, to the value of the left (pointer) operand. The result of pointer
 * overflow is undefined.
 */
class PointerAddInstruction extends PointerOffsetInstruction {
  PointerAddInstruction() { getOpcode() instanceof Opcode::PointerAdd }
}

/**
 * An instruction that subtracts an integer offset from a pointer.
 *
 * The result is the byte address computed by subtracting the value of the right (integer) operand,
 * multiplied by the element size, from the value of the left (pointer) operand. The result of
 * pointer underflow is undefined.
 */
class PointerSubInstruction extends PointerOffsetInstruction {
  PointerSubInstruction() { getOpcode() instanceof Opcode::PointerSub }
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
  PointerDiffInstruction() { getOpcode() instanceof Opcode::PointerDiff }
}

/**
 * An instruction whose result is computed from a single operand.
 */
class UnaryInstruction extends Instruction {
  UnaryInstruction() { getOpcode() instanceof UnaryOpcode }

  /**
   * Gets the sole operand of this instruction.
   */
  final UnaryOperand getUnaryOperand() { result = getAnOperand() }

  /**
   * Gets the instruction whose result provides the sole operand of this instruction.
   */
  final Instruction getUnary() { result = getUnaryOperand().getDef() }
}

/**
 * An instruction that converts the value of its operand to a value of a different type.
 */
class ConvertInstruction extends UnaryInstruction {
  ConvertInstruction() { getOpcode() instanceof Opcode::Convert }
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
  CheckedConvertOrNullInstruction() { getOpcode() instanceof Opcode::CheckedConvertOrNull }
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
  CheckedConvertOrThrowInstruction() { getOpcode() instanceof Opcode::CheckedConvertOrThrow }
}

/**
 * An instruction that returns the address of the complete object that contains the subobject
 * pointed to by its operand.
 *
 * If the operand holds a null address, the result is a null address.
 *
 * This instruction is used to represent `dyanmic_cast<void*>` in C++, which returns the pointer to
 * the most-derived object.
 */
class CompleteObjectAddressInstruction extends UnaryInstruction {
  CompleteObjectAddressInstruction() { getOpcode() instanceof Opcode::CompleteObjectAddress }
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
  ConvertToBaseInstruction() { getOpcode() instanceof ConvertToBaseOpcode }
}

/**
 * An instruction that converts from the address of a derived class to the address of a direct
 * non-virtual base class.
 *
 * If the operand holds a null address, the result is a null address.
 */
class ConvertToNonVirtualBaseInstruction extends ConvertToBaseInstruction {
  ConvertToNonVirtualBaseInstruction() { getOpcode() instanceof Opcode::ConvertToNonVirtualBase }
}

/**
 * An instruction that converts from the address of a derived class to the address of a virtual base
 * class.
 *
 * If the operand holds a null address, the result is a null address.
 */
class ConvertToVirtualBaseInstruction extends ConvertToBaseInstruction {
  ConvertToVirtualBaseInstruction() { getOpcode() instanceof Opcode::ConvertToVirtualBase }
}

/**
 * An instruction that converts from the address of a base class to the address of a direct
 * non-virtual derived class.
 *
 * If the operand holds a null address, the result is a null address.
 */
class ConvertToDerivedInstruction extends InheritanceConversionInstruction {
  ConvertToDerivedInstruction() { getOpcode() instanceof Opcode::ConvertToDerived }
}

/**
 * An instruction that computes the bitwise complement of its operand.
 *
 * The operand must have an integer type, which will also be the result type.
 */
class BitComplementInstruction extends UnaryBitwiseInstruction {
  BitComplementInstruction() { getOpcode() instanceof Opcode::BitComplement }
}

/**
 * An instruction that computes the logical complement of its operand.
 *
 * The operand must have a Boolean type, which will also be the result type.
 */
class LogicalNotInstruction extends UnaryInstruction {
  LogicalNotInstruction() { getOpcode() instanceof Opcode::LogicalNot }
}

/**
 * An instruction that compares two numeric operands.
 */
class CompareInstruction extends BinaryInstruction {
  CompareInstruction() { getOpcode() instanceof CompareOpcode }
}

/**
 * An instruction that returns a `true` result if its operands are equal.
 *
 * Both operands must have the same numeric or address type. The result must have a Boolean type.
 * The result is `true` if `left == right`, and `false` if `left != right` or the two operands are
 * unordered. Floating-point comparison is performed according to IEEE-754.
 */
class CompareEQInstruction extends CompareInstruction {
  CompareEQInstruction() { getOpcode() instanceof Opcode::CompareEQ }
}

/**
 * An instruction that returns a `true` result if its operands are not equal.
 *
 * Both operands must have the same numeric or address type. The result must have a Boolean type.
 * The result is `true` if `left != right` or if the two operands are unordered, and `false` if
 * `left == right`. Floating-point comparison is performed according to IEEE-754.
 */
class CompareNEInstruction extends CompareInstruction {
  CompareNEInstruction() { getOpcode() instanceof Opcode::CompareNE }
}

/**
 * An instruction that does a relative comparison of two values, such as `<` or `>=`.
 */
class RelationalInstruction extends CompareInstruction {
  RelationalInstruction() { getOpcode() instanceof RelationalOpcode }

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
  CompareLTInstruction() { getOpcode() instanceof Opcode::CompareLT }

  override Instruction getLesser() { result = getLeft() }

  override Instruction getGreater() { result = getRight() }

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
  CompareGTInstruction() { getOpcode() instanceof Opcode::CompareGT }

  override Instruction getLesser() { result = getRight() }

  override Instruction getGreater() { result = getLeft() }

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
  CompareLEInstruction() { getOpcode() instanceof Opcode::CompareLE }

  override Instruction getLesser() { result = getLeft() }

  override Instruction getGreater() { result = getRight() }

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
  CompareGEInstruction() { getOpcode() instanceof Opcode::CompareGE }

  override Instruction getLesser() { result = getRight() }

  override Instruction getGreater() { result = getLeft() }

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
  SwitchInstruction() { getOpcode() instanceof Opcode::Switch }

  /** Gets the operand that provides the integer value controlling the switch. */
  final ConditionOperand getExpressionOperand() { result = getAnOperand() }

  /** Gets the instruction whose result provides the integer value controlling the switch. */
  final Instruction getExpression() { result = getExpressionOperand().getDef() }

  /** Gets the successor instructions along the case edges of the switch. */
  final Instruction getACaseSuccessor() { exists(CaseEdge edge | result = getSuccessor(edge)) }

  /** Gets the successor instruction along the default edge of the switch, if any. */
  final Instruction getDefaultSuccessor() { result = getSuccessor(EdgeKind::defaultEdge()) }
}

/**
 * An instruction that calls a function.
 */
class CallInstruction extends Instruction {
  CallInstruction() { getOpcode() instanceof Opcode::Call }

  /**
   * Gets the operand the specifies the target function of the call.
   */
  final CallTargetOperand getCallTargetOperand() { result = getAnOperand() }

  /**
   * Gets the `Instruction` that computes the target function of the call. This is usually a
   * `FunctionAddress` instruction, but can also be an arbitrary instruction that produces a
   * function pointer.
   */
  final Instruction getCallTarget() { result = getCallTargetOperand().getDef() }

  /**
   * Gets all of the argument operands of the call, including the `this` pointer, if any.
   */
  final ArgumentOperand getAnArgumentOperand() { result = getAnOperand() }

  /**
   * Gets the `Function` that the call targets, if this is statically known.
   */
  final Language::Function getStaticCallTarget() {
    result = getCallTarget().(FunctionAddressInstruction).getFunctionSymbol()
  }

  /**
   * Gets all of the arguments of the call, including the `this` pointer, if any.
   */
  final Instruction getAnArgument() { result = getAnArgumentOperand().getDef() }

  /**
   * Gets the `this` pointer argument operand of the call, if any.
   */
  final ThisArgumentOperand getThisArgumentOperand() { result = getAnOperand() }

  /**
   * Gets the `this` pointer argument of the call, if any.
   */
  final Instruction getThisArgument() { result = getThisArgumentOperand().getDef() }

  /**
   * Gets the argument operand at the specified index.
   */
  final PositionalArgumentOperand getPositionalArgumentOperand(int index) {
    result = getAnOperand() and
    result.getIndex() = index
  }

  /**
   * Gets the argument at the specified index.
   */
  final Instruction getPositionalArgument(int index) {
    result = getPositionalArgumentOperand(index).getDef()
  }

  /**
   * Gets the number of arguments of the call, including the `this` pointer, if any.
   */
  final int getNumberOfArguments() { result = count(this.getAnArgumentOperand()) }
}

/**
 * An instruction representing a side effect of a function call.
 */
class SideEffectInstruction extends Instruction {
  SideEffectInstruction() { getOpcode() instanceof SideEffectOpcode }

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
  CallSideEffectInstruction() { getOpcode() instanceof Opcode::CallSideEffect }
}

/**
 * An instruction representing the side effect of a function call on any memory
 * that might be read by that call.
 *
 * This instruction is emitted instead of `CallSideEffectInstruction` when it is certain that the
 * call target cannot write to escaped memory.
 */
class CallReadSideEffectInstruction extends SideEffectInstruction {
  CallReadSideEffectInstruction() { getOpcode() instanceof Opcode::CallReadSideEffect }
}

/**
 * An instruction representing a read side effect of a function call on a
 * specific parameter.
 */
class ReadSideEffectInstruction extends SideEffectInstruction, IndexedInstruction {
  ReadSideEffectInstruction() { getOpcode() instanceof ReadSideEffectOpcode }

  /** Gets the operand for the value that will be read from this instruction, if known. */
  final SideEffectOperand getSideEffectOperand() { result = getAnOperand() }

  /** Gets the value that will be read from this instruction, if known. */
  final Instruction getSideEffect() { result = getSideEffectOperand().getDef() }

  /** Gets the operand for the address from which this instruction may read. */
  final AddressOperand getArgumentOperand() { result = getAnOperand() }

  /** Gets the address from which this instruction may read. */
  final Instruction getArgumentDef() { result = getArgumentOperand().getDef() }
}

/**
 * An instruction representing the read of an indirect parameter within a function call.
 */
class IndirectReadSideEffectInstruction extends ReadSideEffectInstruction {
  IndirectReadSideEffectInstruction() { getOpcode() instanceof Opcode::IndirectReadSideEffect }
}

/**
 * An instruction representing the read of an indirect buffer parameter within a function call.
 */
class BufferReadSideEffectInstruction extends ReadSideEffectInstruction {
  BufferReadSideEffectInstruction() { getOpcode() instanceof Opcode::BufferReadSideEffect }
}

/**
 * An instruction representing the read of an indirect buffer parameter within a function call.
 */
class SizedBufferReadSideEffectInstruction extends ReadSideEffectInstruction {
  SizedBufferReadSideEffectInstruction() {
    getOpcode() instanceof Opcode::SizedBufferReadSideEffect
  }

  /**
   * Gets the operand that holds the number of bytes read from the buffer.
   */
  final BufferSizeOperand getBufferSizeOperand() { result = getAnOperand() }

  /**
   * Gets the instruction whose result provides the number of bytes read from the buffer.
   */
  final Instruction getBufferSize() { result = getBufferSizeOperand().getDef() }
}

/**
 * An instruction representing a write side effect of a function call on a
 * specific parameter.
 */
class WriteSideEffectInstruction extends SideEffectInstruction, IndexedInstruction {
  WriteSideEffectInstruction() { getOpcode() instanceof WriteSideEffectOpcode }

  /**
   * Get the operand that holds the address of the memory to be written.
   */
  final AddressOperand getDestinationAddressOperand() { result = getAnOperand() }

  /**
   * Gets the instruction whose result provides the address of the memory to be written.
   */
  Instruction getDestinationAddress() { result = getDestinationAddressOperand().getDef() }
}

/**
 * An instruction representing the write of an indirect parameter within a function call.
 */
class IndirectMustWriteSideEffectInstruction extends WriteSideEffectInstruction {
  IndirectMustWriteSideEffectInstruction() {
    getOpcode() instanceof Opcode::IndirectMustWriteSideEffect
  }
}

/**
 * An instruction representing the write of an indirect buffer parameter within a function call. The
 * entire buffer is overwritten.
 */
class BufferMustWriteSideEffectInstruction extends WriteSideEffectInstruction {
  BufferMustWriteSideEffectInstruction() {
    getOpcode() instanceof Opcode::BufferMustWriteSideEffect
  }
}

/**
 * An instruction representing the write of an indirect buffer parameter within a function call. The
 * entire buffer is overwritten.
 */
class SizedBufferMustWriteSideEffectInstruction extends WriteSideEffectInstruction {
  SizedBufferMustWriteSideEffectInstruction() {
    getOpcode() instanceof Opcode::SizedBufferMustWriteSideEffect
  }

  /**
   * Gets the operand that holds the number of bytes written to the buffer.
   */
  final BufferSizeOperand getBufferSizeOperand() { result = getAnOperand() }

  /**
   * Gets the instruction whose result provides the number of bytes written to the buffer.
   */
  final Instruction getBufferSize() { result = getBufferSizeOperand().getDef() }
}

/**
 * An instruction representing the potential write of an indirect parameter within a function call.
 *
 * Unlike `IndirectWriteSideEffectInstruction`, the location might not be completely overwritten.
 * written.
 */
class IndirectMayWriteSideEffectInstruction extends WriteSideEffectInstruction {
  IndirectMayWriteSideEffectInstruction() {
    getOpcode() instanceof Opcode::IndirectMayWriteSideEffect
  }
}

/**
 * An instruction representing the write of an indirect buffer parameter within a function call.
 *
 * Unlike `BufferWriteSideEffectInstruction`, the buffer might not be completely overwritten.
 */
class BufferMayWriteSideEffectInstruction extends WriteSideEffectInstruction {
  BufferMayWriteSideEffectInstruction() { getOpcode() instanceof Opcode::BufferMayWriteSideEffect }
}

/**
 * An instruction representing the write of an indirect buffer parameter within a function call.
 *
 * Unlike `BufferWriteSideEffectInstruction`, the buffer might not be completely overwritten.
 */
class SizedBufferMayWriteSideEffectInstruction extends WriteSideEffectInstruction {
  SizedBufferMayWriteSideEffectInstruction() {
    getOpcode() instanceof Opcode::SizedBufferMayWriteSideEffect
  }

  /**
   * Gets the operand that holds the number of bytes written to the buffer.
   */
  final BufferSizeOperand getBufferSizeOperand() { result = getAnOperand() }

  /**
   * Gets the instruction whose result provides the number of bytes written to the buffer.
   */
  final Instruction getBufferSize() { result = getBufferSizeOperand().getDef() }
}

/**
 * An instruction representing the initial value of newly allocated memory, such as the result of a
 * call to `malloc`.
 */
class InitializeDynamicAllocationInstruction extends SideEffectInstruction {
  InitializeDynamicAllocationInstruction() {
    getOpcode() instanceof Opcode::InitializeDynamicAllocation
  }

  /**
   * Gets the address of the allocation this instruction is initializing.
   */
  final AddressOperand getAllocationAddressOperand() { result = getAnOperand() }

  /**
   * Gets the operand for the allocation this instruction is initializing.
   */
  final Instruction getAllocationAddress() { result = getAllocationAddressOperand().getDef() }
}

/**
 * An instruction representing a GNU or MSVC inline assembly statement.
 */
class InlineAsmInstruction extends Instruction {
  InlineAsmInstruction() { getOpcode() instanceof Opcode::InlineAsm }
}

/**
 * An instruction that throws an exception.
 */
class ThrowInstruction extends Instruction {
  ThrowInstruction() { getOpcode() instanceof ThrowOpcode }
}

/**
 * An instruction that throws a new exception.
 */
class ThrowValueInstruction extends ThrowInstruction {
  ThrowValueInstruction() { getOpcode() instanceof Opcode::ThrowValue }

  /**
   * Gets the address operand of the exception thrown by this instruction.
   */
  final AddressOperand getExceptionAddressOperand() { result = getAnOperand() }

  /**
   * Gets the address of the exception thrown by this instruction.
   */
  final Instruction getExceptionAddress() { result = getExceptionAddressOperand().getDef() }

  /**
   * Gets the operand for the exception thrown by this instruction.
   */
  final LoadOperand getExceptionOperand() { result = getAnOperand() }

  /**
   * Gets the exception thrown by this instruction.
   */
  final Instruction getException() { result = getExceptionOperand().getDef() }
}

/**
 * An instruction that re-throws the current exception.
 */
class ReThrowInstruction extends ThrowInstruction {
  ReThrowInstruction() { getOpcode() instanceof Opcode::ReThrow }
}

/**
 * An instruction that exits the current function by propagating an exception.
 */
class UnwindInstruction extends Instruction {
  UnwindInstruction() { getOpcode() instanceof Opcode::Unwind }
}

/**
 * An instruction that starts a `catch` handler.
 */
class CatchInstruction extends Instruction {
  CatchInstruction() { getOpcode() instanceof CatchOpcode }
}

/**
 * An instruction that catches an exception of a specific type.
 */
class CatchByTypeInstruction extends CatchInstruction {
  Language::LanguageType exceptionType;

  CatchByTypeInstruction() {
    getOpcode() instanceof Opcode::CatchByType and
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
  CatchAnyInstruction() { getOpcode() instanceof Opcode::CatchAny }
}

/**
 * An instruction that initializes all escaped memory.
 */
class AliasedDefinitionInstruction extends Instruction {
  AliasedDefinitionInstruction() { getOpcode() instanceof Opcode::AliasedDefinition }
}

/**
 * An instruction that consumes all escaped memory on exit from the function.
 */
class AliasedUseInstruction extends Instruction {
  AliasedUseInstruction() { getOpcode() instanceof Opcode::AliasedUse }
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
  PhiInstruction() { getOpcode() instanceof Opcode::Phi }

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
  ChiInstruction() { getOpcode() instanceof Opcode::Chi }

  /**
   * Gets the operand that represents the previous state of all memory that might be aliased by the
   * memory write.
   */
  final ChiTotalOperand getTotalOperand() { result = getAnOperand() }

  /**
   * Gets the operand that represents the previous state of all memory that might be aliased by the
   * memory write.
   */
  final Instruction getTotal() { result = getTotalOperand().getDef() }

  /**
   * Gets the operand that represents the new value written by the memory write.
   */
  final ChiPartialOperand getPartialOperand() { result = getAnOperand() }

  /**
   * Gets the operand that represents the new value written by the memory write.
   */
  final Instruction getPartial() { result = getPartialOperand().getDef() }

  /**
   * Gets the bit range `[startBit, endBit)` updated by the partial operand of this `ChiInstruction`, relative to the start address of the total operand.
   */
  final predicate getUpdatedInterval(int startBit, int endBit) {
    Construction::getIntervalUpdatedByChi(this, startBit, endBit)
  }
}

/**
 * An instruction representing unreachable code.
 *
 * This instruction is inserted in place of the original target instruction of a `ConditionalBranch`
 * or `Switch` instruction where that particular edge is infeasible.
 */
class UnreachedInstruction extends Instruction {
  UnreachedInstruction() { getOpcode() instanceof Opcode::Unreached }
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
    getOpcode() instanceof BuiltInOperationOpcode and
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
  BuiltInInstruction() { getOpcode() instanceof Opcode::BuiltIn }

  final override string getImmediateString() { result = getBuiltInOperation().toString() }
}

/**
 * An instruction that returns a `va_list` to access the arguments passed to the `...` parameter.
 *
 * The operand specifies the address of the `IREllipsisVariable` used to represent the `...`
 * parameter. The result is a `va_list` that initially refers to the first argument that was passed
 * to the `...` parameter.
 */
class VarArgsStartInstruction extends UnaryInstruction {
  VarArgsStartInstruction() { getOpcode() instanceof Opcode::VarArgsStart }
}

/**
 * An instruction that cleans up a `va_list` after it is no longer in use.
 *
 * The operand specifies the address of the `va_list` to clean up. This instruction does not return
 * a result.
 */
class VarArgsEndInstruction extends UnaryInstruction {
  VarArgsEndInstruction() { getOpcode() instanceof Opcode::VarArgsEnd }
}

/**
 * An instruction that returns the address of the argument currently pointed to by a `va_list`.
 *
 * The operand is the `va_list` that points to the argument. The result is the address of the
 * argument.
 */
class VarArgInstruction extends UnaryInstruction {
  VarArgInstruction() { getOpcode() instanceof Opcode::VarArg }
}

/**
 * An instruction that modifies a `va_list` to point to the next argument that was passed to the
 * `...` parameter.
 *
 * The operand is the current `va_list`. The result is an updated `va_list` that points to the next
 * argument of the `...` parameter.
 */
class NextVarArgInstruction extends UnaryInstruction {
  NextVarArgInstruction() { getOpcode() instanceof Opcode::NextVarArg }
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
  NewObjInstruction() { getOpcode() instanceof Opcode::NewObj }
}
