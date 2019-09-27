private import internal.IRInternal
import IRFunction
import IRBlock
import IRVariable
import Operand
private import internal.InstructionImports as Imports
import Imports::EdgeKind
import Imports::MemoryAccessKind
import Imports::Opcode
private import Imports::OperandTag

module InstructionSanity {
  /**
   * Holds if the instruction `instr` should be expected to have an operand
   * with operand tag `tag`. Only holds for singleton operand tags. Tags with
   * parameters, such as `PhiInputOperand` and `PositionalArgumentOperand` are handled
   * separately in `unexpectedOperand`.
   */
  private predicate expectsOperand(Instruction instr, OperandTag tag) {
    exists(Opcode opcode |
      opcode = instr.getOpcode() and
      (
        opcode instanceof UnaryOpcode and tag instanceof UnaryOperandTag
        or
        opcode instanceof BinaryOpcode and
        (
          tag instanceof LeftOperandTag or
          tag instanceof RightOperandTag
        )
        or
        opcode instanceof MemoryAccessOpcode and tag instanceof AddressOperandTag
        or
        opcode instanceof SizedBufferAccessOpcode and tag instanceof BufferSizeOperandTag
        or
        opcode instanceof OpcodeWithCondition and tag instanceof ConditionOperandTag
        or
        opcode instanceof OpcodeWithLoad and tag instanceof LoadOperandTag
        or
        opcode instanceof Opcode::Store and tag instanceof StoreValueOperandTag
        or
        opcode instanceof Opcode::UnmodeledUse and tag instanceof UnmodeledUseOperandTag
        or
        opcode instanceof Opcode::Call and tag instanceof CallTargetOperandTag
        or
        opcode instanceof Opcode::Chi and tag instanceof ChiTotalOperandTag
        or
        opcode instanceof Opcode::Chi and tag instanceof ChiPartialOperandTag
        or
        (
          opcode instanceof ReadSideEffectOpcode or
          opcode instanceof Opcode::InlineAsm or
          opcode instanceof Opcode::CallSideEffect
        ) and
        tag instanceof SideEffectOperandTag
      )
    )
  }

  /**
   * Holds if instruction `instr` is missing an expected operand with tag `tag`.
   */
  query predicate missingOperand(Instruction instr, string message, IRFunction func, string funcText) {
    exists(OperandTag tag |
      expectsOperand(instr, tag) and
      not exists(NonPhiOperand operand |
        operand = instr.getAnOperand() and
        operand.getOperandTag() = tag
      ) and
      message = "Instruction '" + instr.getOpcode().toString() +
          "' is missing an expected operand with tag '" + tag.toString() + "' in function '$@'." and
      func = instr.getEnclosingIRFunction() and
      funcText = Language::getIdentityString(func.getFunction())
    )
  }

  /**
   * Holds if instruction `instr` has an unexpected operand with tag `tag`.
   */
  query predicate unexpectedOperand(Instruction instr, OperandTag tag) {
    exists(NonPhiOperand operand |
      operand = instr.getAnOperand() and
      operand.getOperandTag() = tag
    ) and
    not expectsOperand(instr, tag) and
    not (instr instanceof CallInstruction and tag instanceof ArgumentOperandTag) and
    not (
      instr instanceof BuiltInOperationInstruction and tag instanceof PositionalArgumentOperandTag
    ) and
    not (instr instanceof InlineAsmInstruction and tag instanceof AsmOperandTag)
  }

  /**
   * Holds if instruction `instr` has multiple operands with tag `tag`.
   */
  query predicate duplicateOperand(Instruction instr, OperandTag tag) {
    strictcount(NonPhiOperand operand |
      operand = instr.getAnOperand() and
      operand.getOperandTag() = tag
    ) > 1 and
    not tag instanceof UnmodeledUseOperandTag
  }

  /**
   * Holds if `Phi` instruction `instr` is missing an operand corresponding to
   * the predecessor block `pred`.
   */
  query predicate missingPhiOperand(PhiInstruction instr, IRBlock pred) {
    pred = instr.getBlock().getAPredecessor() and
    not exists(PhiInputOperand operand |
      operand = instr.getAnOperand() and
      operand.getPredecessorBlock() = pred
    )
  }

  query predicate missingOperandType(Operand operand, string message) {
    exists(Language::Function func |
      not exists(operand.getType()) and
      func = operand.getUse().getEnclosingFunction() and
      message = "Operand missing type in function '" + Language::getIdentityString(func) + "'."
    )
  }

  /**
   * Holds if an instruction, other than `ExitFunction`, has no successors.
   */
  query predicate instructionWithoutSuccessor(Instruction instr) {
    not exists(instr.getASuccessor()) and
    not instr instanceof ExitFunctionInstruction and
    // Phi instructions aren't linked into the instruction-level flow graph.
    not instr instanceof PhiInstruction and
    not instr instanceof UnreachedInstruction
  }

  /**
   * Holds if there are multiple (`n`) edges of kind `kind` from `source`,
   * where `target` is among the targets of those edges.
   */
  query predicate ambiguousSuccessors(Instruction source, EdgeKind kind, int n, Instruction target) {
    n = strictcount(Instruction t | source.getSuccessor(kind) = t) and
    n > 1 and
    source.getSuccessor(kind) = target
  }

  /**
   * Holds if `instr` in `f` is part of a loop even though the AST of `f`
   * contains no element that can cause loops.
   */
  query predicate unexplainedLoop(Language::Function f, Instruction instr) {
    exists(IRBlock block |
      instr.getBlock() = block and
      block.getEnclosingFunction() = f and
      block.getASuccessor+() = block
    ) and
    not Language::hasPotentialLoop(f)
  }

  /**
   * Holds if a `Phi` instruction is present in a block with fewer than two
   * predecessors.
   */
  query predicate unnecessaryPhiInstruction(PhiInstruction instr) {
    count(instr.getBlock().getAPredecessor()) < 2
  }

  /**
   * Holds if operand `operand` consumes a value that was defined in
   * a different function.
   */
  query predicate operandAcrossFunctions(Operand operand, Instruction instr, Instruction defInstr) {
    operand.getUse() = instr and
    operand.getAnyDef() = defInstr and
    instr.getEnclosingIRFunction() != defInstr.getEnclosingIRFunction()
  }

  /**
   * Holds if instruction `instr` is not in exactly one block.
   */
  query predicate instructionWithoutUniqueBlock(Instruction instr, int blockCount) {
    blockCount = count(instr.getBlock()) and
    blockCount != 1
  }

  private predicate forwardEdge(IRBlock b1, IRBlock b2) {
    b1.getASuccessor() = b2 and
    not b1.getBackEdgeSuccessor(_) = b2
  }

  /**
   * Holds if `f` contains a loop in which no edge is a back edge.
   *
   * This check ensures we don't have too _few_ back edges.
   */
  query predicate containsLoopOfForwardEdges(IRFunction f) {
    exists(IRBlock block |
      forwardEdge+(block, block) and
      block.getEnclosingIRFunction() = f
    )
  }

  /**
   * Holds if `block` is reachable from its function entry point but would not
   * be reachable by traversing only forward edges. This check is skipped for
   * functions containing `goto` statements as the property does not generally
   * hold there.
   *
   * This check ensures we don't have too _many_ back edges.
   */
  query predicate lostReachability(IRBlock block) {
    exists(IRFunction f, IRBlock entry |
      entry = f.getEntryBlock() and
      entry.getASuccessor+() = block and
      not forwardEdge+(entry, block) and
      not Language::hasGoto(f.getFunction())
    )
  }

  /**
   * Holds if the number of back edges differs between the `Instruction` graph
   * and the `IRBlock` graph.
   */
  query predicate backEdgeCountMismatch(Language::Function f, int fromInstr, int fromBlock) {
    fromInstr = count(Instruction i1, Instruction i2 |
        i1.getEnclosingFunction() = f and i1.getBackEdgeSuccessor(_) = i2
      ) and
    fromBlock = count(IRBlock b1, IRBlock b2 |
        b1.getEnclosingFunction() = f and b1.getBackEdgeSuccessor(_) = b2
      ) and
    fromInstr != fromBlock
  }

  /**
   * Gets the point in the function at which the specified operand is evaluated. For most operands,
   * this is at the instruction that consumes the use. For a `PhiInputOperand`, the effective point
   * of evaluation is at the end of the corresponding predecessor block.
   */
  private predicate pointOfEvaluation(Operand operand, IRBlock block, int index) {
    block = operand.(PhiInputOperand).getPredecessorBlock() and
    index = block.getInstructionCount()
    or
    exists(Instruction use |
      use = operand.(NonPhiOperand).getUse() and
      block.getInstruction(index) = use
    )
  }

  /**
   * Holds if `useOperand` has a definition that does not dominate the use.
   */
  query predicate useNotDominatedByDefinition(
    Operand useOperand, string message, IRFunction func, string funcText
  ) {
    exists(IRBlock useBlock, int useIndex, Instruction defInstr, IRBlock defBlock, int defIndex |
      not useOperand.getUse() instanceof UnmodeledUseInstruction and
      pointOfEvaluation(useOperand, useBlock, useIndex) and
      defInstr = useOperand.getAnyDef() and
      (
        defInstr instanceof PhiInstruction and
        defBlock = defInstr.getBlock() and
        defIndex = -1
        or
        defBlock.getInstruction(defIndex) = defInstr
      ) and
      not (
        defBlock.strictlyDominates(useBlock)
        or
        defBlock = useBlock and
        defIndex < useIndex
      ) and
      message = "Operand '" + useOperand.toString() +
          "' is not dominated by its definition in function '$@'." and
      func = useOperand.getEnclosingIRFunction() and
      funcText = Language::getIdentityString(func.getFunction())
    )
  }
}

/**
 * Represents a single operation in the IR.
 */
class Instruction extends Construction::TInstruction {
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

  /**
   * Gets a string describing the operation of this instruction. This includes
   * the opcode and the immediate value, if any. For example:
   *
   * VariableAddress[x]
   */
  final string getOperationString() {
    if exists(getImmediateString())
    then result = getOperationPrefix() + getOpcode().toString() + "[" + getImmediateString() + "]"
    else result = getOperationPrefix() + getOpcode().toString()
  }

  /**
   * Gets a string describing the immediate value of this instruction, if any.
   */
  string getImmediateString() { none() }

  private string getOperationPrefix() {
    if this instanceof SideEffectInstruction then result = "^" else result = ""
  }

  private string getResultPrefix() {
    if getResultType() instanceof Language::VoidType
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
    exists(IRBlock block |
      block = getBlock() and
      (
        exists(int index, int phiCount |
          phiCount = count(block.getAPhiInstruction()) and
          this = block.getInstruction(index) and
          result = index + phiCount
        )
        or
        this instanceof PhiInstruction and
        this = rank[result + 1](PhiInstruction phiInstr |
            phiInstr = block.getAPhiInstruction()
          |
            phiInstr order by phiInstr.getUniqueId()
          )
      )
    )
  }

  bindingset[type]
  private string getValueCategoryString(string type) {
    if isGLValue() then result = "glval<" + type + ">" else result = type
  }

  string getResultTypeString() {
    exists(string valcat |
      valcat = getValueCategoryString(getResultType().toString()) and
      if
        getResultType() instanceof Language::UnknownType and
        not isGLValue() and
        exists(getResultSize())
      then result = valcat + "[" + getResultSize().toString() + "]"
      else result = valcat
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
    result = getResultPrefix() + getBlock().getDisplayIndex().toString() + "_" +
        getDisplayIndexInBlock().toString()
  }

  /**
   * Gets a string describing the result of this instruction, suitable for
   * display in IR dumps. This consists of the result ID plus the type of the
   * result.
   *
   * Example: `r1_1(int*)`
   */
  final string getResultString() { result = getResultId() + "(" + getResultTypeString() + ")" }

  /**
   * Gets a string describing the operands of this instruction, suitable for
   * display in IR dumps.
   *
   * Example: `func:r3_4, this:r3_5`
   */
  string getOperandsString() {
    result = concat(Operand operand |
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
   * Gets the `Expr` whose result is computed by this instruction, if any.
   */
  final Language::Expr getConvertedResultExpression() {
    result = Construction::getInstructionConvertedResultExpression(this)
  }

  /**
   * Gets the unconverted `Expr` whose result is computed by this instruction, if any.
   */
  final Language::Expr getUnconvertedResultExpression() {
    result = Construction::getInstructionUnconvertedResultExpression(this)
  }

  /**
   * Gets the type of the result produced by this instruction. If the
   * instruction does not produce a result, its result type will be `VoidType`.
   *
   * If `isGLValue()` holds, then the result type of this instruction should be
   * thought of as "pointer to `getResultType()`".
   */
  final Language::Type getResultType() { Construction::instructionHasType(this, result, _) }

  /**
   * Holds if the result produced by this instruction is a glvalue. If this
   * holds, the result of the instruction represents the address of a location,
   * and the type of the location is given by `getResultType()`. If this does
   * not hold, the result of the instruction represents a value whose type is
   * given by `getResultType()`.
   *
   * For example, the statement `y = x;` generates the following IR:
   * r1_0(glval: int) = VariableAddress[x]
   * r1_1(int)        = Load r1_0, mu0_1
   * r1_2(glval: int) = VariableAddress[y]
   * mu1_3(int)       = Store r1_2, r1_1
   *
   * The result of each `VariableAddress` instruction is a glvalue of type
   * `int`, representing the address of the corresponding integer variable. The
   * result of the `Load` instruction is a prvalue of type `int`, representing
   * the integer value loaded from variable `x`.
   */
  final predicate isGLValue() { Construction::instructionHasType(this, _, true) }

  /**
   * Gets the size of the result produced by this instruction, in bytes. If the
   * result does not have a known constant size, this predicate does not hold.
   *
   * If `this.isGLValue()` holds for this instruction, the value of
   * `getResultSize()` will always be the size of a pointer.
   */
  final int getResultSize() {
    if isGLValue()
    then
      // a glvalue is always pointer-sized.
      result = Language::getPointerSize()
    else
      if getResultType() instanceof Language::UnknownType
      then result = Construction::getInstructionResultSize(this)
      else result = Language::getTypeSize(getResultType())
  }

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
  MemoryAccessKind getResultMemoryAccess() { none() }

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
   * connected to its actual uses. An unmodeled result is connected to the
   * `UnmodeledUse` instruction.
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

class VariableInstruction extends Instruction {
  IRVariable var;

  VariableInstruction() { var = Construction::getInstructionVariable(this) }

  override string getImmediateString() { result = var.toString() }

  final IRVariable getVariable() { result = var }
}

class FieldInstruction extends Instruction {
  Language::Field field;

  FieldInstruction() { field = Construction::getInstructionField(this) }

  final override string getImmediateString() { result = field.toString() }

  final Language::Field getField() { result = field }
}

class FunctionInstruction extends Instruction {
  Language::Function funcSymbol;

  FunctionInstruction() { funcSymbol = Construction::getInstructionFunction(this) }

  final override string getImmediateString() { result = funcSymbol.toString() }

  final Language::Function getFunctionSymbol() { result = funcSymbol }
}

class ConstantValueInstruction extends Instruction {
  string value;

  ConstantValueInstruction() { value = Construction::getInstructionConstantValue(this) }

  final override string getImmediateString() { result = value }

  final string getValue() { result = value }
}

class IndexedInstruction extends Instruction {
  int index;

  IndexedInstruction() { index = Construction::getInstructionIndex(this) }

  final override string getImmediateString() { result = index.toString() }

  final int getIndex() { result = index }
}

class EnterFunctionInstruction extends Instruction {
  EnterFunctionInstruction() { getOpcode() instanceof Opcode::EnterFunction }
}

class VariableAddressInstruction extends VariableInstruction {
  VariableAddressInstruction() { getOpcode() instanceof Opcode::VariableAddress }
}

class InitializeParameterInstruction extends VariableInstruction {
  InitializeParameterInstruction() { getOpcode() instanceof Opcode::InitializeParameter }

  final Language::Parameter getParameter() { result = var.(IRUserVariable).getVariable() }

  final override MemoryAccessKind getResultMemoryAccess() { result instanceof IndirectMemoryAccess }
}

/**
 * An instruction that initializes the `this` pointer parameter of the enclosing function.
 */
class InitializeThisInstruction extends Instruction {
  InitializeThisInstruction() { getOpcode() instanceof Opcode::InitializeThis }
}

class FieldAddressInstruction extends FieldInstruction {
  FieldAddressInstruction() { getOpcode() instanceof Opcode::FieldAddress }

  final UnaryOperand getObjectAddressOperand() { result = getAnOperand() }

  final Instruction getObjectAddress() { result = getObjectAddressOperand().getDef() }
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

class UninitializedInstruction extends VariableInstruction {
  UninitializedInstruction() { getOpcode() instanceof Opcode::Uninitialized }

  final override MemoryAccessKind getResultMemoryAccess() { result instanceof IndirectMemoryAccess }

  /**
   * Gets the variable that is uninitialized.
   */
  final Language::Variable getLocalVariable() { result = var.(IRUserVariable).getVariable() }
}

class NoOpInstruction extends Instruction {
  NoOpInstruction() { getOpcode() instanceof Opcode::NoOp }
}

class ReturnInstruction extends Instruction {
  ReturnInstruction() { getOpcode() instanceof ReturnOpcode }
}

class ReturnVoidInstruction extends ReturnInstruction {
  ReturnVoidInstruction() { getOpcode() instanceof Opcode::ReturnVoid }
}

class ReturnValueInstruction extends ReturnInstruction {
  ReturnValueInstruction() { getOpcode() instanceof Opcode::ReturnValue }

  final LoadOperand getReturnValueOperand() { result = getAnOperand() }

  final Instruction getReturnValue() { result = getReturnValueOperand().getDef() }
}

class CopyInstruction extends Instruction {
  CopyInstruction() { getOpcode() instanceof CopyOpcode }

  Operand getSourceValueOperand() { none() }

  final Instruction getSourceValue() { result = getSourceValueOperand().getDef() }
}

class CopyValueInstruction extends CopyInstruction, UnaryInstruction {
  CopyValueInstruction() { getOpcode() instanceof Opcode::CopyValue }

  final override UnaryOperand getSourceValueOperand() { result = getAnOperand() }
}

class LoadInstruction extends CopyInstruction {
  LoadInstruction() { getOpcode() instanceof Opcode::Load }

  final AddressOperand getSourceAddressOperand() { result = getAnOperand() }

  final Instruction getSourceAddress() { result = getSourceAddressOperand().getDef() }

  final override LoadOperand getSourceValueOperand() { result = getAnOperand() }
}

class StoreInstruction extends CopyInstruction {
  StoreInstruction() { getOpcode() instanceof Opcode::Store }

  final override MemoryAccessKind getResultMemoryAccess() { result instanceof IndirectMemoryAccess }

  final AddressOperand getDestinationAddressOperand() { result = getAnOperand() }

  final Instruction getDestinationAddress() { result = getDestinationAddressOperand().getDef() }

  final override StoreValueOperand getSourceValueOperand() { result = getAnOperand() }
}

class ConditionalBranchInstruction extends Instruction {
  ConditionalBranchInstruction() { getOpcode() instanceof Opcode::ConditionalBranch }

  final ConditionOperand getConditionOperand() { result = getAnOperand() }

  final Instruction getCondition() { result = getConditionOperand().getDef() }

  final Instruction getTrueSuccessor() { result = getSuccessor(trueEdge()) }

  final Instruction getFalseSuccessor() { result = getSuccessor(falseEdge()) }
}

class ExitFunctionInstruction extends Instruction {
  ExitFunctionInstruction() { getOpcode() instanceof Opcode::ExitFunction }
}

class ConstantInstruction extends ConstantValueInstruction {
  ConstantInstruction() { getOpcode() instanceof Opcode::Constant }
}

class IntegerConstantInstruction extends ConstantInstruction {
  IntegerConstantInstruction() { getResultType() instanceof Language::IntegralType }
}

class FloatConstantInstruction extends ConstantInstruction {
  FloatConstantInstruction() { getResultType() instanceof Language::FloatingPointType }
}

class StringConstantInstruction extends Instruction {
  Language::StringLiteral value;

  StringConstantInstruction() { value = Construction::getInstructionStringLiteral(this) }

  final override string getImmediateString() { result = Language::getStringLiteralText(value) }

  final Language::StringLiteral getValue() { result = value }
}

class BinaryInstruction extends Instruction {
  BinaryInstruction() { getOpcode() instanceof BinaryOpcode }

  final LeftOperand getLeftOperand() { result = getAnOperand() }

  final RightOperand getRightOperand() { result = getAnOperand() }

  final Instruction getLeft() { result = getLeftOperand().getDef() }

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

class ArithmeticInstruction extends Instruction {
  ArithmeticInstruction() { getOpcode() instanceof ArithmeticOpcode }
}

class BinaryArithmeticInstruction extends ArithmeticInstruction, BinaryInstruction { }

class UnaryArithmeticInstruction extends ArithmeticInstruction, UnaryInstruction { }

class AddInstruction extends BinaryArithmeticInstruction {
  AddInstruction() { getOpcode() instanceof Opcode::Add }
}

class SubInstruction extends BinaryArithmeticInstruction {
  SubInstruction() { getOpcode() instanceof Opcode::Sub }
}

class MulInstruction extends BinaryArithmeticInstruction {
  MulInstruction() { getOpcode() instanceof Opcode::Mul }
}

class DivInstruction extends BinaryArithmeticInstruction {
  DivInstruction() { getOpcode() instanceof Opcode::Div }
}

class RemInstruction extends BinaryArithmeticInstruction {
  RemInstruction() { getOpcode() instanceof Opcode::Rem }
}

class NegateInstruction extends UnaryArithmeticInstruction {
  NegateInstruction() { getOpcode() instanceof Opcode::Negate }
}

class BitwiseInstruction extends Instruction {
  BitwiseInstruction() { getOpcode() instanceof BitwiseOpcode }
}

class BinaryBitwiseInstruction extends BitwiseInstruction, BinaryInstruction { }

class UnaryBitwiseInstruction extends BitwiseInstruction, UnaryInstruction { }

class BitAndInstruction extends BinaryBitwiseInstruction {
  BitAndInstruction() { getOpcode() instanceof Opcode::BitAnd }
}

class BitOrInstruction extends BinaryBitwiseInstruction {
  BitOrInstruction() { getOpcode() instanceof Opcode::BitOr }
}

class BitXorInstruction extends BinaryBitwiseInstruction {
  BitXorInstruction() { getOpcode() instanceof Opcode::BitXor }
}

class ShiftLeftInstruction extends BinaryBitwiseInstruction {
  ShiftLeftInstruction() { getOpcode() instanceof Opcode::ShiftLeft }
}

class ShiftRightInstruction extends BinaryBitwiseInstruction {
  ShiftRightInstruction() { getOpcode() instanceof Opcode::ShiftRight }
}

class PointerArithmeticInstruction extends BinaryInstruction {
  int elementSize;

  PointerArithmeticInstruction() {
    getOpcode() instanceof PointerArithmeticOpcode and
    elementSize = Construction::getInstructionElementSize(this)
  }

  final override string getImmediateString() { result = elementSize.toString() }

  final int getElementSize() { result = elementSize }
}

class PointerOffsetInstruction extends PointerArithmeticInstruction {
  PointerOffsetInstruction() { getOpcode() instanceof PointerOffsetOpcode }
}

class PointerAddInstruction extends PointerOffsetInstruction {
  PointerAddInstruction() { getOpcode() instanceof Opcode::PointerAdd }
}

class PointerSubInstruction extends PointerOffsetInstruction {
  PointerSubInstruction() { getOpcode() instanceof Opcode::PointerSub }
}

class PointerDiffInstruction extends PointerArithmeticInstruction {
  PointerDiffInstruction() { getOpcode() instanceof Opcode::PointerDiff }
}

class UnaryInstruction extends Instruction {
  UnaryInstruction() { getOpcode() instanceof UnaryOpcode }

  final UnaryOperand getUnaryOperand() { result = getAnOperand() }

  final Instruction getUnary() { result = getUnaryOperand().getDef() }
}

class ConvertInstruction extends UnaryInstruction {
  ConvertInstruction() { getOpcode() instanceof Opcode::Convert }
}

/**
 * Represents an instruction that converts between two addresses
 * related by inheritance.
 */
class InheritanceConversionInstruction extends UnaryInstruction {
  Language::Class baseClass;
  Language::Class derivedClass;

  InheritanceConversionInstruction() {
    Construction::getInstructionInheritance(this, baseClass, derivedClass)
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
 * Represents an instruction that converts from the address of a derived class
 * to the address of a direct non-virtual base class.
 */
class ConvertToBaseInstruction extends InheritanceConversionInstruction {
  ConvertToBaseInstruction() { getOpcode() instanceof Opcode::ConvertToBase }
}

/**
 * Represents an instruction that converts from the address of a derived class
 * to the address of a virtual base class.
 */
class ConvertToVirtualBaseInstruction extends InheritanceConversionInstruction {
  ConvertToVirtualBaseInstruction() { getOpcode() instanceof Opcode::ConvertToVirtualBase }
}

/**
 * Represents an instruction that converts from the address of a base class
 * to the address of a direct non-virtual derived class.
 */
class ConvertToDerivedInstruction extends InheritanceConversionInstruction {
  ConvertToDerivedInstruction() { getOpcode() instanceof Opcode::ConvertToDerived }
}

class BitComplementInstruction extends UnaryBitwiseInstruction {
  BitComplementInstruction() { getOpcode() instanceof Opcode::BitComplement }
}

class LogicalNotInstruction extends UnaryInstruction {
  LogicalNotInstruction() { getOpcode() instanceof Opcode::LogicalNot }
}

class CompareInstruction extends BinaryInstruction {
  CompareInstruction() { getOpcode() instanceof CompareOpcode }
}

class CompareEQInstruction extends CompareInstruction {
  CompareEQInstruction() { getOpcode() instanceof Opcode::CompareEQ }
}

class CompareNEInstruction extends CompareInstruction {
  CompareNEInstruction() { getOpcode() instanceof Opcode::CompareNE }
}

/**
 * Represents an instruction that does a relative comparison of two values, such as `<` or `>=`.
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

class CompareLTInstruction extends RelationalInstruction {
  CompareLTInstruction() { getOpcode() instanceof Opcode::CompareLT }

  override Instruction getLesser() { result = getLeft() }

  override Instruction getGreater() { result = getRight() }

  override predicate isStrict() { any() }
}

class CompareGTInstruction extends RelationalInstruction {
  CompareGTInstruction() { getOpcode() instanceof Opcode::CompareGT }

  override Instruction getLesser() { result = getRight() }

  override Instruction getGreater() { result = getLeft() }

  override predicate isStrict() { any() }
}

class CompareLEInstruction extends RelationalInstruction {
  CompareLEInstruction() { getOpcode() instanceof Opcode::CompareLE }

  override Instruction getLesser() { result = getLeft() }

  override Instruction getGreater() { result = getRight() }

  override predicate isStrict() { none() }
}

class CompareGEInstruction extends RelationalInstruction {
  CompareGEInstruction() { getOpcode() instanceof Opcode::CompareGE }

  override Instruction getLesser() { result = getRight() }

  override Instruction getGreater() { result = getLeft() }

  override predicate isStrict() { none() }
}

class SwitchInstruction extends Instruction {
  SwitchInstruction() { getOpcode() instanceof Opcode::Switch }

  final ConditionOperand getExpressionOperand() { result = getAnOperand() }

  final Instruction getExpression() { result = getExpressionOperand().getDef() }

  final Instruction getACaseSuccessor() { exists(CaseEdge edge | result = getSuccessor(edge)) }

  final Instruction getDefaultSuccessor() { result = getSuccessor(defaultEdge()) }
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
    result = getCallTarget().(FunctionInstruction).getFunctionSymbol()
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
}

/**
 * An instruction representing a side effect of a function call.
 */
class SideEffectInstruction extends Instruction {
  SideEffectInstruction() { getOpcode() instanceof SideEffectOpcode }

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

  final override MemoryAccessKind getResultMemoryAccess() {
    result instanceof EscapedMayMemoryAccess
  }
}

/**
 * An instruction representing the side effect of a function call on any memory that might be read
 * by that call.
 */
class CallReadSideEffectInstruction extends SideEffectInstruction {
  CallReadSideEffectInstruction() { getOpcode() instanceof Opcode::CallReadSideEffect }
}

/**
 * An instruction representing the read of an indirect parameter within a function call.
 */
class IndirectReadSideEffectInstruction extends SideEffectInstruction {
  IndirectReadSideEffectInstruction() { getOpcode() instanceof Opcode::IndirectReadSideEffect }

  Instruction getArgumentDef() { result = getAnOperand().(AddressOperand).getDef() }
}

/**
 * An instruction representing the read of an indirect buffer parameter within a function call.
 */
class BufferReadSideEffectInstruction extends SideEffectInstruction {
  BufferReadSideEffectInstruction() { getOpcode() instanceof Opcode::BufferReadSideEffect }

  Instruction getArgumentDef() { result = getAnOperand().(AddressOperand).getDef() }
}

/**
 * An instruction representing the read of an indirect buffer parameter within a function call.
 */
class SizedBufferReadSideEffectInstruction extends SideEffectInstruction {
  SizedBufferReadSideEffectInstruction() {
    getOpcode() instanceof Opcode::SizedBufferReadSideEffect
  }

  Instruction getArgumentDef() { result = getAnOperand().(AddressOperand).getDef() }

  Instruction getSizeDef() { result = getAnOperand().(BufferSizeOperand).getDef() }
}

/**
 * An instruction representing a side effect of a function call.
 */
class WriteSideEffectInstruction extends SideEffectInstruction {
  WriteSideEffectInstruction() { getOpcode() instanceof WriteSideEffectOpcode }

  Instruction getArgumentDef() { result = getAnOperand().(AddressOperand).getDef() }
}

/**
 * An instruction representing the write of an indirect parameter within a function call.
 */
class IndirectMustWriteSideEffectInstruction extends WriteSideEffectInstruction {
  IndirectMustWriteSideEffectInstruction() {
    getOpcode() instanceof Opcode::IndirectMustWriteSideEffect
  }

  final override MemoryAccessKind getResultMemoryAccess() { result instanceof IndirectMemoryAccess }
}

/**
 * An instruction representing the write of an indirect buffer parameter within a function call. The
 * entire buffer is overwritten.
 */
class BufferMustWriteSideEffectInstruction extends WriteSideEffectInstruction {
  BufferMustWriteSideEffectInstruction() {
    getOpcode() instanceof Opcode::BufferMustWriteSideEffect
  }

  final override MemoryAccessKind getResultMemoryAccess() { result instanceof BufferMemoryAccess }
}

/**
 * An instruction representing the write of an indirect buffer parameter within a function call. The
 * entire buffer is overwritten.
 */
class SizedBufferMustWriteSideEffectInstruction extends WriteSideEffectInstruction {
  SizedBufferMustWriteSideEffectInstruction() {
    getOpcode() instanceof Opcode::SizedBufferMustWriteSideEffect
  }

  final override MemoryAccessKind getResultMemoryAccess() { result instanceof BufferMemoryAccess }

  Instruction getSizeDef() { result = getAnOperand().(BufferSizeOperand).getDef() }
}

/**
 * An instruction representing the potential write of an indirect parameter within a function call.
 * Unlike `IndirectWriteSideEffectInstruction`, the location might not be completely overwritten.
 * written.
 */
class IndirectMayWriteSideEffectInstruction extends WriteSideEffectInstruction {
  IndirectMayWriteSideEffectInstruction() {
    getOpcode() instanceof Opcode::IndirectMayWriteSideEffect
  }

  final override MemoryAccessKind getResultMemoryAccess() {
    result instanceof IndirectMayMemoryAccess
  }
}

/**
 * An instruction representing the write of an indirect buffer parameter within a function call.
 * Unlike `BufferWriteSideEffectInstruction`, the buffer might not be completely overwritten.
 */
class BufferMayWriteSideEffectInstruction extends WriteSideEffectInstruction {
  BufferMayWriteSideEffectInstruction() { getOpcode() instanceof Opcode::BufferMayWriteSideEffect }

  final override MemoryAccessKind getResultMemoryAccess() {
    result instanceof BufferMayMemoryAccess
  }
}

/**
 * An instruction representing the write of an indirect buffer parameter within a function call.
 * Unlike `BufferWriteSideEffectInstruction`, the buffer might not be completely overwritten.
 */
class SizedBufferMayWriteSideEffectInstruction extends WriteSideEffectInstruction {
  SizedBufferMayWriteSideEffectInstruction() {
    getOpcode() instanceof Opcode::SizedBufferMayWriteSideEffect
  }

  final override MemoryAccessKind getResultMemoryAccess() {
    result instanceof BufferMayMemoryAccess
  }

  Instruction getSizeDef() { result = getAnOperand().(BufferSizeOperand).getDef() }
}

/**
 * An instruction representing a GNU or MSVC inline assembly statement.
 */
class InlineAsmInstruction extends Instruction {
  InlineAsmInstruction() { getOpcode() instanceof Opcode::InlineAsm }

  final override MemoryAccessKind getResultMemoryAccess() {
    result instanceof EscapedMayMemoryAccess
  }
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
  Language::Type exceptionType;

  CatchByTypeInstruction() {
    getOpcode() instanceof Opcode::CatchByType and
    exceptionType = Construction::getInstructionExceptionType(this)
  }

  final override string getImmediateString() { result = exceptionType.toString() }

  /**
   * Gets the type of exception to be caught.
   */
  final Language::Type getExceptionType() { result = exceptionType }
}

/**
 * An instruction that catches any exception.
 */
class CatchAnyInstruction extends CatchInstruction {
  CatchAnyInstruction() { getOpcode() instanceof Opcode::CatchAny }
}

class UnmodeledDefinitionInstruction extends Instruction {
  UnmodeledDefinitionInstruction() { getOpcode() instanceof Opcode::UnmodeledDefinition }

  final override MemoryAccessKind getResultMemoryAccess() {
    result instanceof UnmodeledMemoryAccess
  }
}

/**
 * An instruction that initializes all escaped memory.
 */
class AliasedDefinitionInstruction extends Instruction {
  AliasedDefinitionInstruction() { getOpcode() instanceof Opcode::AliasedDefinition }

  final override MemoryAccessKind getResultMemoryAccess() { result instanceof EscapedMemoryAccess }
}

class UnmodeledUseInstruction extends Instruction {
  UnmodeledUseInstruction() { getOpcode() instanceof Opcode::UnmodeledUse }

  override string getOperandsString() { result = "mu*" }
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

  final override MemoryAccessKind getResultMemoryAccess() { result instanceof PhiMemoryAccess }

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

  final override MemoryAccessKind getResultMemoryAccess() { result instanceof ChiTotalMemoryAccess }

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
}

/**
 * An instruction representing unreachable code. Inserted in place of the original target
 * instruction of a `ConditionalBranch` or `Switch` instruction where that particular edge is
 * infeasible.
 */
class UnreachedInstruction extends Instruction {
  UnreachedInstruction() { getOpcode() instanceof Opcode::Unreached }
}

/**
 * An instruction representing a built-in operation. This is used to represent
 * operations such as access to variable argument lists.
 */
class BuiltInOperationInstruction extends Instruction {
  Language::BuiltInOperation operation;

  BuiltInOperationInstruction() {
    getOpcode() instanceof BuiltInOperationOpcode and
    operation = Construction::getInstructionBuiltInOperation(this)
  }

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
