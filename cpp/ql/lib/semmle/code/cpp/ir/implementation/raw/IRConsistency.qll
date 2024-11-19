private import IR
import InstructionConsistency // module is below
import IRTypeConsistency // module is in IRType.qll
import internal.IRConsistencyImports

module InstructionConsistency {
  private import internal.InstructionImports as Imports
  private import Imports::OperandTag
  private import Imports::Overlap
  private import internal.IRInternal

  private newtype TOptionalIRFunction =
    TPresentIRFunction(IRFunction irFunc) or
    TMissingIRFunction()

  /**
   * An `IRFunction` that might not exist. This is used so that we can produce consistency failures
   * for IR that also incorrectly lacks a `getEnclosingIRFunction()`.
   */
  abstract private class OptionalIRFunction extends TOptionalIRFunction {
    abstract string toString();

    abstract Language::Location getLocation();
  }

  class PresentIRFunction extends OptionalIRFunction, TPresentIRFunction {
    private IRFunction irFunc;

    PresentIRFunction() { this = TPresentIRFunction(irFunc) }

    override string toString() {
      result = concat(LanguageDebug::getIdentityString(irFunc.getFunction()), "; ")
    }

    override Language::Location getLocation() {
      // To avoid an overwhelming number of results when the extractor merges functions with the
      // same name, just pick a single location.
      result =
        min(Language::Location loc | loc = irFunc.getLocation() | loc order by loc.toString())
    }

    IRFunction getIRFunction() { result = irFunc }
  }

  private class MissingIRFunction extends OptionalIRFunction, TMissingIRFunction {
    override string toString() { result = "<Missing IRFunction>" }

    override Language::Location getLocation() { result instanceof Language::UnknownDefaultLocation }
  }

  private OptionalIRFunction getInstructionIRFunction(Instruction instr) {
    result = TPresentIRFunction(instr.getEnclosingIRFunction())
    or
    not exists(instr.getEnclosingIRFunction()) and result = TMissingIRFunction()
  }

  pragma[inline]
  private OptionalIRFunction getInstructionIRFunction(Instruction instr, string irFuncText) {
    result = getInstructionIRFunction(instr) and
    irFuncText = result.toString()
  }

  private OptionalIRFunction getOperandIRFunction(Operand operand) {
    result = TPresentIRFunction(operand.getEnclosingIRFunction())
    or
    not exists(operand.getEnclosingIRFunction()) and result = TMissingIRFunction()
  }

  pragma[inline]
  private OptionalIRFunction getOperandIRFunction(Operand operand, string irFuncText) {
    result = getOperandIRFunction(operand) and
    irFuncText = result.toString()
  }

  private OptionalIRFunction getBlockIRFunction(IRBlock block) {
    result = TPresentIRFunction(block.getEnclosingIRFunction())
    or
    not exists(block.getEnclosingIRFunction()) and result = TMissingIRFunction()
  }

  /**
   * Holds if instruction `instr` is missing an expected operand with tag `tag`.
   */
  query predicate missingOperand(
    Instruction instr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    exists(OperandTag tag |
      instr.getOpcode().hasOperand(tag) and
      not exists(NonPhiOperand operand |
        operand = instr.getAnOperand() and
        operand.getOperandTag() = tag
      ) and
      message =
        "Instruction '" + instr.getOpcode().toString() +
          "' is missing an expected operand with tag '" + tag.toString() + "' in function '$@'." and
      irFunc = getInstructionIRFunction(instr, irFuncText)
    )
  }

  /**
   * Holds if instruction `instr` has an unexpected operand with tag `tag`.
   */
  query predicate unexpectedOperand(
    Instruction instr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    exists(OperandTag tag |
      exists(NonPhiOperand operand |
        operand = instr.getAnOperand() and
        operand.getOperandTag() = tag
      ) and
      not instr.getOpcode().hasOperand(tag) and
      not (instr instanceof CallInstruction and tag instanceof ArgumentOperandTag) and
      not (
        instr instanceof BuiltInOperationInstruction and tag instanceof PositionalArgumentOperandTag
      ) and
      not (instr instanceof InlineAsmInstruction and tag instanceof AsmOperandTag) and
      message =
        "Instruction '" + instr.toString() + "' has unexpected operand '" + tag.toString() +
          "' in function '$@'." and
      irFunc = getInstructionIRFunction(instr, irFuncText)
    )
  }

  /**
   * Holds if instruction `instr` has multiple operands with tag `tag`.
   */
  query predicate duplicateOperand(
    Instruction instr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    exists(OperandTag tag, int operandCount |
      operandCount =
        strictcount(NonPhiOperand operand |
          operand = instr.getAnOperand() and
          operand.getOperandTag() = tag
        ) and
      operandCount > 1 and
      message =
        "Instruction has " + operandCount + " operands with tag '" + tag.toString() + "'" +
          " in function '$@'." and
      irFunc = getInstructionIRFunction(instr, irFuncText)
    )
  }

  /**
   * Holds if `Phi` instruction `instr` is missing an operand corresponding to
   * the predecessor block `pred`.
   */
  query predicate missingPhiOperand(
    PhiInstruction instr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    exists(IRBlock pred |
      pred = instr.getBlock().getAPredecessor() and
      not exists(PhiInputOperand operand |
        operand = instr.getAnOperand() and
        operand.getPredecessorBlock() = pred
      ) and
      message =
        "Instruction '" + instr.toString() + "' is missing an operand for predecessor block '" +
          pred.toString() + "' in function '$@'." and
      irFunc = getInstructionIRFunction(instr, irFuncText)
    )
  }

  query predicate missingOperandType(
    Operand operand, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    exists(Instruction use |
      not exists(operand.getType()) and
      use = operand.getUse() and
      message =
        "Operand '" + operand.toString() + "' of instruction '" + use.getOpcode().toString() +
          "' is missing a type in function '$@'." and
      irFunc = getOperandIRFunction(operand, irFuncText)
    )
  }

  query predicate duplicateChiOperand(
    ChiInstruction chi, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    chi.getTotal() = chi.getPartial() and
    message =
      "Chi instruction for " + chi.getPartial().toString() +
        " has duplicate operands in function '$@'." and
    irFunc = getInstructionIRFunction(chi, irFuncText)
  }

  query predicate sideEffectWithoutPrimary(
    SideEffectInstruction instr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    not exists(instr.getPrimaryInstruction()) and
    message =
      "Side effect instruction '" + instr + "' is missing a primary instruction in function '$@'." and
    irFunc = getInstructionIRFunction(instr, irFuncText)
  }

  /**
   * Holds if an instruction, other than `ExitFunction`, has no successors.
   */
  query predicate instructionWithoutSuccessor(
    Instruction instr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    not exists(instr.getASuccessor()) and
    not instr instanceof ExitFunctionInstruction and
    // Phi instructions aren't linked into the instruction-level flow graph.
    not instr instanceof PhiInstruction and
    not instr instanceof UnreachedInstruction and
    message = "Instruction '" + instr.toString() + "' has no successors in function '$@'." and
    irFunc = getInstructionIRFunction(instr, irFuncText)
  }

  /**
   * Holds if there are multiple edges of the same kind from `source`.
   */
  query predicate ambiguousSuccessors(
    Instruction source, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    exists(EdgeKind kind, int n |
      n = strictcount(Instruction t | source.getSuccessor(kind) = t) and
      n > 1 and
      message =
        "Instruction '" + source.toString() + "' has " + n.toString() + " successors of kind '" +
          kind.toString() + "' in function '$@'." and
      irFunc = getInstructionIRFunction(source, irFuncText)
    )
  }

  /**
   * Holds if `instr` is part of a loop even though the AST of `instr`'s enclosing function
   * contains no element that can cause loops.
   */
  query predicate unexplainedLoop(
    Instruction instr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    exists(Language::Function f |
      exists(IRBlock block |
        instr.getBlock() = block and
        block.getEnclosingFunction() = f and
        block.getASuccessor+() = block
      ) and
      not Language::hasPotentialLoop(f) and
      message =
        "Instruction '" + instr.toString() + "' is part of an unexplained loop in function '$@'." and
      irFunc = getInstructionIRFunction(instr, irFuncText)
    )
  }

  /**
   * Holds if a `Phi` instruction is present in a block with fewer than two
   * predecessors.
   */
  query predicate unnecessaryPhiInstruction(
    PhiInstruction instr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    exists(int n |
      n = count(instr.getBlock().getAPredecessor()) and
      n < 2 and
      message =
        "Instruction '" + instr.toString() + "' is in a block with only " + n.toString() +
          " predecessors in function '$@'." and
      irFunc = getInstructionIRFunction(instr, irFuncText)
    )
  }

  /**
   * Holds if a memory operand is connected to a definition with an unmodeled result.
   */
  query predicate memoryOperandDefinitionIsUnmodeled(
    Instruction instr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    exists(MemoryOperand operand, Instruction def |
      operand = instr.getAnOperand() and
      def = operand.getAnyDef() and
      not def.isResultModeled() and
      message =
        "Memory operand definition on instruction '" + instr.toString() +
          "' has unmodeled result in function '$@'." and
      irFunc = getInstructionIRFunction(instr, irFuncText)
    )
  }

  /**
   * Holds if operand `operand` consumes a value that was defined in
   * a different function.
   */
  query predicate operandAcrossFunctions(
    Operand operand, string message, OptionalIRFunction useIRFunc, string useIRFuncText,
    OptionalIRFunction defIRFunc, string defIRFuncText
  ) {
    exists(Instruction useInstr, Instruction defInstr |
      operand.getUse() = useInstr and
      operand.getAnyDef() = defInstr and
      useIRFunc = getInstructionIRFunction(useInstr, useIRFuncText) and
      defIRFunc = getInstructionIRFunction(defInstr, defIRFuncText) and
      useIRFunc != defIRFunc and
      message =
        "Operand '" + operand.toString() + "' is used on instruction '" + useInstr.toString() +
          "' in function '$@', but is defined on instruction '" + defInstr.toString() +
          "' in function '$@'."
    )
  }

  /**
   * Holds if instruction `instr` is not in exactly one block.
   */
  query predicate instructionWithoutUniqueBlock(
    Instruction instr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    exists(int blockCount |
      blockCount = count(instr.getBlock()) and
      blockCount != 1 and
      message =
        "Instruction '" + instr.toString() + "' is a member of " + blockCount.toString() +
          " blocks in function '$@'." and
      irFunc = getInstructionIRFunction(instr, irFuncText)
    )
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
  query predicate containsLoopOfForwardEdges(IRFunction f, string message) {
    exists(IRBlock block |
      forwardEdge+(block, block) and
      block.getEnclosingIRFunction() = f and
      message = "Function contains a loop consisting of only forward edges."
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
  query predicate lostReachability(
    IRBlock block, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    exists(IRFunction f, IRBlock entry |
      entry = f.getEntryBlock() and
      entry.getASuccessor+() = block and
      not forwardEdge+(entry, block) and
      not Language::hasGoto(f.getFunction()) and
      message =
        "Block '" + block.toString() +
          "' is not reachable by traversing only forward edges in function '$@'." and
      irFunc = TPresentIRFunction(f) and
      irFuncText = irFunc.toString()
    )
  }

  /**
   * Holds if the number of back edges differs between the `Instruction` graph
   * and the `IRBlock` graph.
   */
  query predicate backEdgeCountMismatch(OptionalIRFunction irFunc, string message) {
    exists(int fromInstr, int fromBlock |
      fromInstr =
        count(Instruction i1, Instruction i2 |
          getInstructionIRFunction(i1) = irFunc and i1.getBackEdgeSuccessor(_) = i2
        ) and
      fromBlock =
        count(IRBlock b1, IRBlock b2 |
          getBlockIRFunction(b1) = irFunc and b1.getBackEdgeSuccessor(_) = b2
        ) and
      fromInstr != fromBlock and
      message =
        "The instruction graph for function '" + irFunc.toString() + "' contains " +
          fromInstr.toString() + " back edges, but the block graph contains " + fromBlock.toString()
          + " back edges."
    )
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
    Operand useOperand, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    exists(IRBlock useBlock, int useIndex, Instruction defInstr, IRBlock defBlock, int defIndex |
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
      message =
        "Operand '" + useOperand.toString() +
          "' is not dominated by its definition in function '$@'." and
      irFunc = getOperandIRFunction(useOperand, irFuncText)
    )
  }

  query predicate switchInstructionWithoutDefaultEdge(
    SwitchInstruction switchInstr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    not exists(switchInstr.getDefaultSuccessor()) and
    message =
      "SwitchInstruction " + switchInstr.toString() + " without a DefaultEdge in function '$@'." and
    irFunc = getInstructionIRFunction(switchInstr, irFuncText)
  }

  /**
   * Holds if `instr` is on the chain of chi/phi instructions for all aliased
   * memory.
   */
  private predicate isOnAliasedDefinitionChain(Instruction instr) {
    instr instanceof AliasedDefinitionInstruction
    or
    isOnAliasedDefinitionChain(instr.(ChiInstruction).getTotal())
    or
    isOnAliasedDefinitionChain(instr.(PhiInstruction).getAnInputOperand().getAnyDef())
  }

  private predicate shouldBeConflated(Instruction instr) {
    isOnAliasedDefinitionChain(instr)
    or
    instr.getOpcode() instanceof Opcode::InitializeNonLocal
  }

  query predicate notMarkedAsConflated(
    Instruction instr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    shouldBeConflated(instr) and
    not instr.isResultConflated() and
    message =
      "Instruction '" + instr.toString() +
        "' should be marked as having a conflated result in function '$@'." and
    irFunc = getInstructionIRFunction(instr, irFuncText)
  }

  query predicate wronglyMarkedAsConflated(
    Instruction instr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    instr.isResultConflated() and
    not shouldBeConflated(instr) and
    message =
      "Instruction '" + instr.toString() +
        "' should not be marked as having a conflated result in function '$@'." and
    irFunc = getInstructionIRFunction(instr, irFuncText)
  }

  query predicate invalidOverlap(
    MemoryOperand useOperand, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    exists(Overlap overlap |
      overlap = useOperand.getDefinitionOverlap() and
      overlap instanceof MayPartiallyOverlap and
      message =
        "MemoryOperand '" + useOperand.toString() + "' has a `getDefinitionOverlap()` of '" +
          overlap.toString() + "'." and
      irFunc = getOperandIRFunction(useOperand, irFuncText)
    )
  }

  query predicate nonUniqueEnclosingIRFunction(
    Instruction instr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    exists(int irFuncCount |
      irFuncCount = count(instr.getEnclosingIRFunction()) and
      irFuncCount != 1 and
      message =
        "Instruction '" + instr.toString() + "' has " + irFuncCount.toString() +
          " results for `getEnclosingIRFunction()` in function '$@'." and
      irFunc = getInstructionIRFunction(instr, irFuncText)
    )
  }

  /**
   * Holds if the object address operand for the given `FieldAddress` instruction does not have an
   * address type.
   */
  query predicate fieldAddressOnNonPointer(
    FieldAddressInstruction instr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    not instr.getObjectAddressOperand().getIRType() instanceof IRAddressType and
    message =
      "FieldAddress instruction '" + instr.toString() +
        "' has an object address operand that is not an address, in function '$@'." and
    irFunc = getInstructionIRFunction(instr, irFuncText)
  }

  /**
   * Holds if the `this` argument operand for the given `Call` instruction does not have an address
   * type.
   */
  query predicate thisArgumentIsNonPointer(
    CallInstruction instr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    exists(ThisArgumentOperand thisOperand | thisOperand = instr.getThisArgumentOperand() |
      not thisOperand.getIRType() instanceof IRAddressType
    ) and
    message =
      "Call instruction '" + instr.toString() +
        "' has a `this` argument operand that is not an address, in function '$@'." and
    irFunc = getInstructionIRFunction(instr, irFuncText)
  }

  query predicate nonUniqueIRVariable(
    Instruction instr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    exists(VariableInstruction vi, IRVariable v1, IRVariable v2 |
      instr = vi and vi.getIRVariable() = v1 and vi.getIRVariable() = v2 and v1 != v2
    ) and
    message =
      "Variable instruction '" + instr.toString() +
        "' has multiple associated variables, in function '$@'." and
    irFunc = getInstructionIRFunction(instr, irFuncText)
    or
    instr.getOpcode() instanceof Opcode::VariableAddress and
    not instr instanceof VariableInstruction and
    message =
      "Variable address instruction '" + instr.toString() +
        "' has no associated variable, in function '$@'." and
    irFunc = getInstructionIRFunction(instr, irFuncText)
  }

  query predicate nonBooleanOperand(
    Instruction instr, string message, OptionalIRFunction irFunc, string irFuncText
  ) {
    exists(Instruction unary |
      unary = instr.(LogicalNotInstruction).getUnary() and
      not unary.getResultIRType() instanceof IRBooleanType and
      irFunc = getInstructionIRFunction(instr, irFuncText) and
      message =
        "Logical Not instruction " + instr.toString() +
          " with non-Boolean operand, in function '$@'."
    )
    or
    exists(Instruction cond |
      cond = instr.(ConditionalBranchInstruction).getCondition() and
      not cond.getResultIRType() instanceof IRBooleanType and
      irFunc = getInstructionIRFunction(instr, irFuncText) and
      message =
        "Conditional branch instruction " + instr.toString() +
          " with non-Boolean condition, in function '$@'."
    )
  }
}
