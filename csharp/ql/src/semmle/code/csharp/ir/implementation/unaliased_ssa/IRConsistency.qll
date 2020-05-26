private import IR
import InstructionConsistency // module is below
import IRTypeConsistency // module is in IRType.qll

module InstructionConsistency {
  private import internal.InstructionImports as Imports
  private import Imports::OperandTag
  private import Imports::Overlap
  private import internal.IRInternal

  /**
   * Holds if instruction `instr` is missing an expected operand with tag `tag`.
   */
  query predicate missingOperand(Instruction instr, string message, IRFunction func, string funcText) {
    exists(OperandTag tag |
      instr.getOpcode().hasOperand(tag) and
      not exists(NonPhiOperand operand |
        operand = instr.getAnOperand() and
        operand.getOperandTag() = tag
      ) and
      message =
        "Instruction '" + instr.getOpcode().toString() +
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
    not instr.getOpcode().hasOperand(tag) and
    not (instr instanceof CallInstruction and tag instanceof ArgumentOperandTag) and
    not (
      instr instanceof BuiltInOperationInstruction and tag instanceof PositionalArgumentOperandTag
    ) and
    not (instr instanceof InlineAsmInstruction and tag instanceof AsmOperandTag)
  }

  /**
   * Holds if instruction `instr` has multiple operands with tag `tag`.
   */
  query predicate duplicateOperand(
    Instruction instr, string message, IRFunction func, string funcText
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
      func = instr.getEnclosingIRFunction() and
      funcText = Language::getIdentityString(func.getFunction())
    )
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
    exists(Language::Function func, Instruction use |
      not exists(operand.getType()) and
      use = operand.getUse() and
      func = use.getEnclosingFunction() and
      message =
        "Operand '" + operand.toString() + "' of instruction '" + use.getOpcode().toString() +
          "' missing type in function '" + Language::getIdentityString(func) + "'."
    )
  }

  query predicate duplicateChiOperand(
    ChiInstruction chi, string message, IRFunction func, string funcText
  ) {
    chi.getTotal() = chi.getPartial() and
    message =
      "Chi instruction for " + chi.getPartial().toString() +
        " has duplicate operands in function $@" and
    func = chi.getEnclosingIRFunction() and
    funcText = Language::getIdentityString(func.getFunction())
  }

  query predicate sideEffectWithoutPrimary(
    SideEffectInstruction instr, string message, IRFunction func, string funcText
  ) {
    not exists(instr.getPrimaryInstruction()) and
    message = "Side effect instruction missing primary instruction in function $@" and
    func = instr.getEnclosingIRFunction() and
    funcText = Language::getIdentityString(func.getFunction())
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
   * Holds if a memory operand is connected to a definition with an unmodeled result.
   */
  query predicate memoryOperandDefinitionIsUnmodeled(
    Instruction instr, string message, IRFunction func, string funcText
  ) {
    exists(MemoryOperand operand, Instruction def |
      operand = instr.getAnOperand() and
      def = operand.getAnyDef() and
      not def.isResultModeled() and
      message = "Memory operand definition has unmodeled result in function '$@'" and
      func = instr.getEnclosingIRFunction() and
      funcText = Language::getIdentityString(func.getFunction())
    )
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
    fromInstr =
      count(Instruction i1, Instruction i2 |
        i1.getEnclosingFunction() = f and i1.getBackEdgeSuccessor(_) = i2
      ) and
    fromBlock =
      count(IRBlock b1, IRBlock b2 |
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
      func = useOperand.getEnclosingIRFunction() and
      funcText = Language::getIdentityString(func.getFunction())
    )
  }

  query predicate switchInstructionWithoutDefaultEdge(
    SwitchInstruction switchInstr, string message, IRFunction func, string funcText
  ) {
    not exists(switchInstr.getDefaultSuccessor()) and
    message =
      "SwitchInstruction " + switchInstr.toString() + " without a DefaultEdge in function '$@'." and
    func = switchInstr.getEnclosingIRFunction() and
    funcText = Language::getIdentityString(func.getFunction())
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

  query predicate notMarkedAsConflated(Instruction instr) {
    shouldBeConflated(instr) and
    not instr.isResultConflated()
  }

  query predicate wronglyMarkedAsConflated(Instruction instr) {
    instr.isResultConflated() and
    not shouldBeConflated(instr)
  }

  query predicate invalidOverlap(
    MemoryOperand useOperand, string message, IRFunction func, string funcText
  ) {
    exists(Overlap overlap |
      overlap = useOperand.getDefinitionOverlap() and
      overlap instanceof MayPartiallyOverlap and
      message =
        "MemoryOperand '" + useOperand.toString() + "' has a `getDefinitionOverlap()` of '" +
          overlap.toString() + "'." and
      func = useOperand.getEnclosingIRFunction() and
      funcText = Language::getIdentityString(func.getFunction())
    )
  }
}
