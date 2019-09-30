import SSAConstructionInternal
private import SSAConstructionImports
private import NewIR

private class OldBlock = Reachability::ReachableBlock;

private class OldInstruction = Reachability::ReachableInstruction;

import Cached

cached
private module Cached {
  private IRBlock getNewBlock(OldBlock oldBlock) {
    result.getFirstInstruction() = getNewInstruction(oldBlock.getFirstInstruction())
  }

  cached
  predicate functionHasIR(Language::Function func) {
    exists(OldIR::IRFunction irFunc | irFunc.getFunction() = func)
  }

  cached
  OldInstruction getOldInstruction(Instruction instr) { instr = WrappedInstruction(result) }

  private IRVariable getNewIRVariable(OldIR::IRVariable var) {
    // This is just a type cast. Both classes derive from the same newtype.
    result = var
  }

  cached
  newtype TInstruction =
    WrappedInstruction(OldInstruction oldInstruction) {
      not oldInstruction instanceof OldIR::PhiInstruction
    } or
    Phi(OldBlock block, Alias::MemoryLocation defLocation) {
      definitionHasPhiNode(defLocation, block)
    } or
    Chi(OldInstruction oldInstruction) {
      not oldInstruction instanceof OldIR::PhiInstruction and
      hasChiNode(_, oldInstruction)
    } or
    Unreached(Language::Function function) {
      exists(OldInstruction oldInstruction |
        function = oldInstruction.getEnclosingFunction() and
        Reachability::isInfeasibleInstructionSuccessor(oldInstruction, _)
      )
    }

  cached
  predicate hasTempVariable(
    Language::Function func, Language::AST ast, TempVariableTag tag, Language::LanguageType type
  ) {
    exists(OldIR::IRTempVariable var |
      var.getEnclosingFunction() = func and
      var.getAST() = ast and
      var.getTag() = tag and
      var.getLanguageType() = type
    )
  }

  cached
  predicate hasModeledMemoryResult(Instruction instruction) {
    exists(Alias::getResultMemoryLocation(getOldInstruction(instruction))) or
    instruction instanceof PhiInstruction or // Phis always have modeled results
    instruction instanceof ChiInstruction // Chis always have modeled results
  }

  cached
  Instruction getRegisterOperandDefinition(Instruction instruction, RegisterOperandTag tag) {
    exists(OldInstruction oldInstruction, OldIR::RegisterOperand oldOperand |
      oldInstruction = getOldInstruction(instruction) and
      oldOperand = oldInstruction.getAnOperand() and
      tag = oldOperand.getOperandTag() and
      result = getNewInstruction(oldOperand.getAnyDef())
    )
  }

  cached
  Instruction getMemoryOperandDefinition(
    Instruction instruction, MemoryOperandTag tag, Overlap overlap
  ) {
    exists(OldInstruction oldInstruction, OldIR::NonPhiMemoryOperand oldOperand |
      oldInstruction = getOldInstruction(instruction) and
      oldOperand = oldInstruction.getAnOperand() and
      tag = oldOperand.getOperandTag() and
      (
        (
          if exists(Alias::getOperandMemoryLocation(oldOperand))
          then
            exists(
              OldBlock useBlock, int useRank, Alias::MemoryLocation useLocation,
              Alias::MemoryLocation defLocation, OldBlock defBlock, int defRank, int defOffset
            |
              useLocation = Alias::getOperandMemoryLocation(oldOperand) and
              hasDefinitionAtRank(useLocation, defLocation, defBlock, defRank, defOffset) and
              hasUseAtRank(useLocation, useBlock, useRank, oldInstruction) and
              definitionReachesUse(useLocation, defBlock, defRank, useBlock, useRank) and
              overlap = Alias::getOverlap(defLocation, useLocation) and
              result = getDefinitionOrChiInstruction(defBlock, defOffset, defLocation)
            )
          else (
            result = instruction.getEnclosingIRFunction().getUnmodeledDefinitionInstruction() and
            overlap instanceof MustTotallyOverlap
          )
        )
        or
        // Connect any definitions that are not being modeled in SSA to the
        // `UnmodeledUse` instruction.
        exists(OldInstruction oldDefinition |
          instruction instanceof UnmodeledUseInstruction and
          tag instanceof UnmodeledUseOperandTag and
          oldDefinition = oldOperand.getAnyDef() and
          not exists(Alias::getResultMemoryLocation(oldDefinition)) and
          result = getNewInstruction(oldDefinition) and
          overlap instanceof MustTotallyOverlap
        )
      )
    )
    or
    instruction = Chi(getOldInstruction(result)) and
    tag instanceof ChiPartialOperandTag and
    overlap instanceof MustExactlyOverlap
    or
    exists(IRFunction f |
      tag instanceof UnmodeledUseOperandTag and
      result = f.getUnmodeledDefinitionInstruction() and
      instruction = f.getUnmodeledUseInstruction() and
      overlap instanceof MustTotallyOverlap
    )
    or
    tag instanceof ChiTotalOperandTag and
    result = getChiInstructionTotalOperand(instruction) and
    overlap instanceof MustExactlyOverlap
  }

  cached
  Language::LanguageType getInstructionOperandType(Instruction instr, TypedOperandTag tag) {
    exists(OldInstruction oldInstruction, OldIR::TypedOperand oldOperand |
      oldInstruction = getOldInstruction(instr) and
      oldOperand = oldInstruction.getAnOperand() and
      tag = oldOperand.getOperandTag() and
      result = oldOperand.getLanguageType()
    )
  }

  cached
  Instruction getPhiOperandDefinition(
    PhiInstruction instr, IRBlock newPredecessorBlock, Overlap overlap
  ) {
    exists(
      Alias::MemoryLocation defLocation, Alias::MemoryLocation useLocation, OldBlock phiBlock,
      OldBlock predBlock, OldBlock defBlock, int defOffset
    |
      hasPhiOperandDefinition(defLocation, useLocation, phiBlock, predBlock, defBlock, defOffset,
        overlap) and
      instr = Phi(phiBlock, useLocation) and
      newPredecessorBlock = getNewBlock(predBlock) and
      result = getDefinitionOrChiInstruction(defBlock, defOffset, defLocation)
    )
  }

  cached
  Instruction getChiInstructionTotalOperand(ChiInstruction chiInstr) {
    exists(
      Alias::VirtualVariable vvar, OldInstruction oldInstr, Alias::MemoryLocation defLocation,
      OldBlock defBlock, int defRank, int defOffset, OldBlock useBlock, int useRank
    |
      chiInstr = Chi(oldInstr) and
      vvar = Alias::getResultMemoryLocation(oldInstr).getVirtualVariable() and
      hasDefinitionAtRank(vvar, defLocation, defBlock, defRank, defOffset) and
      hasUseAtRank(vvar, useBlock, useRank, oldInstr) and
      definitionReachesUse(vvar, defBlock, defRank, useBlock, useRank) and
      result = getDefinitionOrChiInstruction(defBlock, defOffset, vvar)
    )
  }

  cached
  Instruction getPhiInstructionBlockStart(PhiInstruction instr) {
    exists(OldBlock oldBlock |
      instr = Phi(oldBlock, _) and
      result = getNewInstruction(oldBlock.getFirstInstruction())
    )
  }

  cached
  Language::Expr getInstructionConvertedResultExpression(Instruction instruction) {
    result = getOldInstruction(instruction).getConvertedResultExpression()
  }

  cached
  Language::Expr getInstructionUnconvertedResultExpression(Instruction instruction) {
    result = getOldInstruction(instruction).getUnconvertedResultExpression()
  }

  /*
   * This adds Chi nodes to the instruction successor relation; if an instruction has a Chi node,
   * that node is its successor in the new successor relation, and the Chi node's successors are
   * the new instructions generated from the successors of the old instruction
   */

  cached
  Instruction getInstructionSuccessor(Instruction instruction, EdgeKind kind) {
    if hasChiNode(_, getOldInstruction(instruction))
    then
      result = Chi(getOldInstruction(instruction)) and
      kind instanceof GotoEdge
    else (
      exists(OldInstruction oldInstruction |
        oldInstruction = getOldInstruction(instruction) and
        (
          if Reachability::isInfeasibleInstructionSuccessor(oldInstruction, kind)
          then result = Unreached(instruction.getEnclosingFunction())
          else result = getNewInstruction(oldInstruction.getSuccessor(kind))
        )
      )
      or
      exists(OldInstruction oldInstruction |
        instruction = Chi(oldInstruction) and
        result = getNewInstruction(oldInstruction.getSuccessor(kind))
      )
    )
  }

  cached
  Instruction getInstructionBackEdgeSuccessor(Instruction instruction, EdgeKind kind) {
    exists(OldInstruction oldInstruction |
      not Reachability::isInfeasibleInstructionSuccessor(oldInstruction, kind) and
      // There is only one case for the translation into `result` because the
      // SSA construction never inserts extra instructions _before_ an existing
      // instruction.
      getOldInstruction(result) = oldInstruction.getBackEdgeSuccessor(kind) and
      // There are two cases for the translation into `instruction` because the
      // SSA construction might have inserted a chi node _after_
      // `oldInstruction`, in which case the back edge should come out of the
      // chi node instead.
      if hasChiNode(_, oldInstruction)
      then instruction = Chi(oldInstruction)
      else instruction = getNewInstruction(oldInstruction)
    )
  }

  cached
  Language::AST getInstructionAST(Instruction instruction) {
    exists(OldInstruction oldInstruction |
      instruction = WrappedInstruction(oldInstruction)
      or
      instruction = Chi(oldInstruction)
    |
      result = oldInstruction.getAST()
    )
    or
    exists(OldBlock block |
      instruction = Phi(block, _) and
      result = block.getFirstInstruction().getAST()
    )
    or
    instruction = Unreached(result)
  }

  cached
  Language::LanguageType getInstructionResultType(Instruction instruction) {
    exists(OldInstruction oldInstruction |
      instruction = WrappedInstruction(oldInstruction) and
      result = oldInstruction.getResultLanguageType()
    )
    or
    exists(OldInstruction oldInstruction, Alias::VirtualVariable vvar |
      instruction = Chi(oldInstruction) and
      hasChiNode(vvar, oldInstruction) and
      result = vvar.getType()
    )
    or
    exists(Alias::MemoryLocation location |
      instruction = Phi(_, location) and
      result = location.getType()
    )
    or
    instruction = Unreached(_) and
    result = Language::getVoidType()
  }

  cached
  Opcode getInstructionOpcode(Instruction instruction) {
    exists(OldInstruction oldInstruction |
      instruction = WrappedInstruction(oldInstruction) and
      result = oldInstruction.getOpcode()
    )
    or
    instruction instanceof Chi and
    result instanceof Opcode::Chi
    or
    instruction instanceof Phi and
    result instanceof Opcode::Phi
    or
    instruction instanceof Unreached and
    result instanceof Opcode::Unreached
  }

  cached
  IRFunction getInstructionEnclosingIRFunction(Instruction instruction) {
    exists(OldInstruction oldInstruction |
      instruction = WrappedInstruction(oldInstruction)
      or
      instruction = Chi(oldInstruction)
    |
      result.getFunction() = oldInstruction.getEnclosingFunction()
    )
    or
    exists(OldBlock block |
      instruction = Phi(block, _) and
      result.getFunction() = block.getEnclosingFunction()
    )
    or
    instruction = Unreached(result.getFunction())
  }

  cached
  IRVariable getInstructionVariable(Instruction instruction) {
    result = getNewIRVariable(getOldInstruction(instruction)
            .(OldIR::VariableInstruction)
            .getVariable())
  }

  cached
  Language::Field getInstructionField(Instruction instruction) {
    result = getOldInstruction(instruction).(OldIR::FieldInstruction).getField()
  }

  cached
  Language::Function getInstructionFunction(Instruction instruction) {
    result = getOldInstruction(instruction).(OldIR::FunctionInstruction).getFunctionSymbol()
  }

  cached
  string getInstructionConstantValue(Instruction instruction) {
    result = getOldInstruction(instruction).(OldIR::ConstantValueInstruction).getValue()
  }

  cached
  Language::StringLiteral getInstructionStringLiteral(Instruction instruction) {
    result = getOldInstruction(instruction).(OldIR::StringConstantInstruction).getValue()
  }

  cached
  Language::BuiltInOperation getInstructionBuiltInOperation(Instruction instruction) {
    result = getOldInstruction(instruction)
          .(OldIR::BuiltInOperationInstruction)
          .getBuiltInOperation()
  }

  cached
  Language::LanguageType getInstructionExceptionType(Instruction instruction) {
    result = getOldInstruction(instruction).(OldIR::CatchByTypeInstruction).getExceptionType()
  }

  cached
  int getInstructionElementSize(Instruction instruction) {
    result = getOldInstruction(instruction).(OldIR::PointerArithmeticInstruction).getElementSize()
  }

  cached
  predicate getInstructionInheritance(
    Instruction instruction, Language::Class baseClass, Language::Class derivedClass
  ) {
    exists(OldIR::InheritanceConversionInstruction oldInstr |
      oldInstr = getOldInstruction(instruction) and
      baseClass = oldInstr.getBaseClass() and
      derivedClass = oldInstr.getDerivedClass()
    )
  }

  cached
  Instruction getPrimaryInstructionForSideEffect(Instruction instruction) {
    exists(OldIR::SideEffectInstruction oldInstruction |
      oldInstruction = getOldInstruction(instruction) and
      result = getNewInstruction(oldInstruction.getPrimaryInstruction())
    )
    or
    exists(OldIR::Instruction oldInstruction |
      instruction = Chi(oldInstruction) and
      result = getNewInstruction(oldInstruction)
    )
  }
}

private Instruction getNewInstruction(OldInstruction instr) { getOldInstruction(result) = instr }

/**
 * Holds if instruction `def` needs to have a `Chi` instruction inserted after it, to account for a partial definition
 * of a virtual variable. The `Chi` instruction provides a definition of the entire virtual variable of which the
 * original definition location is a member.
 */
private predicate hasChiNode(Alias::VirtualVariable vvar, OldInstruction def) {
  exists(Alias::MemoryLocation defLocation |
    defLocation = Alias::getResultMemoryLocation(def) and
    defLocation.getVirtualVariable() = vvar and
    // If the definition totally (or exactly) overlaps the virtual variable, then there's no need for a `Chi`
    // instruction.
    Alias::getOverlap(defLocation, vvar) instanceof MayPartiallyOverlap
  )
}

private import PhiInsertion

/**
 * Module to handle insertion of `Phi` instructions at the correct blocks. We insert a `Phi` instruction at the
 * beginning of a block for a given location when that block is on the dominance frontier of a definition of the
 * location and there is a use of that location reachable from that block without an intervening definition of the
 * location.
 * Within the approach outlined above, we treat a location slightly differently depending on whether or not it is a
 * virtual variable. For a virtual variable, we will insert a `Phi` instruction on the dominance frontier if there is
 * a use of any member location of that virtual variable that is reachable from the `Phi` instruction. For a location
 * that is not a virtual variable, we insert a `Phi` instruction only if there is an exactly-overlapping use of the
 * location reachable from the `Phi` instruction. This ensures that we insert a `Phi` instruction for a non-virtual
 * variable only if doing so would allow dataflow analysis to get a more precise result than if we just used a `Phi`
 * instruction for the virtual variable as a whole.
 */
private module PhiInsertion {
  /**
   * Holds if a `Phi` instruction needs to be inserted for location `defLocation` at the beginning of block `phiBlock`.
   */
  predicate definitionHasPhiNode(Alias::MemoryLocation defLocation, OldBlock phiBlock) {
    exists(OldBlock defBlock |
      phiBlock = Dominance::getDominanceFrontier(defBlock) and
      definitionHasDefinitionInBlock(defLocation, defBlock) and
      /* We can also eliminate those nodes where the definition is not live on any incoming edge */
      definitionLiveOnEntryToBlock(defLocation, phiBlock)
    )
  }

  /**
   * Holds if the memory location `defLocation` has a definition in block `block`, either because of an existing
   * instruction, a `Phi` node, or a `Chi` node.
   */
  private predicate definitionHasDefinitionInBlock(Alias::MemoryLocation defLocation, OldBlock block) {
    definitionHasPhiNode(defLocation, block)
    or
    exists(OldInstruction def, Alias::MemoryLocation resultLocation |
      def.getBlock() = block and
      resultLocation = Alias::getResultMemoryLocation(def) and
      (
        defLocation = resultLocation
        or
        // For a virtual variable, any definition of a member location will either generate a `Chi` node that defines
        // the virtual variable, or will totally overlap the virtual variable. Either way, treat this as a definition of
        // the virtual variable.
        defLocation = resultLocation.getVirtualVariable()
      )
    )
  }

  /**
   * Holds if there is a use at (`block`, `index`) that could consume the result of a `Phi` instruction for
   * `defLocation`.
   */
  private predicate definitionHasUse(Alias::MemoryLocation defLocation, OldBlock block, int index) {
    exists(OldInstruction use |
      block.getInstruction(index) = use and
      if defLocation instanceof Alias::VirtualVariable
      then (
        exists(Alias::MemoryLocation useLocation |
          // For a virtual variable, any use of a location that is a member of the virtual variable counts as a use.
          useLocation = Alias::getOperandMemoryLocation(use.getAnOperand()) and
          defLocation = useLocation.getVirtualVariable()
        )
        or
        // A `Chi` instruction consumes the enclosing virtual variable of its use location.
        hasChiNode(defLocation, use)
      ) else (
        // For other locations, only an exactly-overlapping use of the same location counts as a use.
        defLocation = Alias::getOperandMemoryLocation(use.getAnOperand()) and
        Alias::getOverlap(defLocation, defLocation) instanceof MustExactlyOverlap
      )
    )
  }

  /**
   * Holds if the location `defLocation` is redefined at (`block`, `index`). A location is considered "redefined" if
   * there is a definition that would prevent a previous definition of `defLocation` from being consumed as the operand
   * of a `Phi` node that occurs after the redefinition.
   */
  private predicate definitionHasRedefinition(
    Alias::MemoryLocation defLocation, OldBlock block, int index
  ) {
    exists(OldInstruction redef, Alias::MemoryLocation redefLocation |
      block.getInstruction(index) = redef and
      redefLocation = Alias::getResultMemoryLocation(redef) and
      if defLocation instanceof Alias::VirtualVariable
      then
        // For a virtual variable, the definition may be consumed by any use of a location that is a member of the
        // virtual variable. Thus, the definition is live until a subsequent redefinition of the entire virtual
        // variable.
        exists(Overlap overlap |
          overlap = Alias::getOverlap(redefLocation, defLocation) and
          not overlap instanceof MayPartiallyOverlap
        )
      else
        // For other locations, the definition may only be consumed by an exactly-overlapping use of the same location.
        // Thus, the definition is live until a subsequent definition of any location that may overlap the original
        // definition location.
        exists(Alias::getOverlap(redefLocation, defLocation))
    )
  }

  /**
   * Holds if the definition `defLocation` is live on entry to block `block`. The definition is live if there is at
   * least one use of that definition before any intervening instruction that redefines the definition location.
   */
  predicate definitionLiveOnEntryToBlock(Alias::MemoryLocation defLocation, OldBlock block) {
    exists(int firstAccess |
      definitionHasUse(defLocation, block, firstAccess) and
      firstAccess = min(int index |
          definitionHasUse(defLocation, block, index)
          or
          definitionHasRedefinition(defLocation, block, index)
        )
    )
    or
    definitionLiveOnExitFromBlock(defLocation, block) and
    not definitionHasRedefinition(defLocation, block, _)
  }

  /**
   * Holds if the definition `defLocation` is live on exit from block `block`. The definition is live on exit if it is
   * live on entry to any of the successors of `block`.
   */
  pragma[noinline]
  predicate definitionLiveOnExitFromBlock(Alias::MemoryLocation defLocation, OldBlock block) {
    definitionLiveOnEntryToBlock(defLocation, block.getAFeasibleSuccessor())
  }
}

private import DefUse

/**
 * Module containing the predicates that connect uses to their reaching definition. The reaching definitions are
 * computed separately for each unique use `MemoryLocation`. An instruction is treated as a definition of a use location
 * if the defined location overlaps the use location in any way. Thus, a single instruction may serve as a definition
 * for multiple use locations, since a single definition location may overlap many use locations.
 *
 * Definitions and uses are identified by a block and an integer "offset". An offset of -1 indicates the definition
 * from a `Phi` instruction at the beginning of the block. An offset of 2*i indicates a definition or use on the
 * instruction at index `i` in the block. An offset of 2*i+1 indicates a definition or use on the `Chi` instruction that
 * will be inserted immediately after the instruction at index `i` in the block.
 *
 * For a given use location, each definition and use is also assigned a "rank" within its block. The rank is simply the
 * one-based index of that definition or use within the list of definitions and uses of that location within the block,
 * ordered by offset. The rank allows the various reachability predicates to be computed more efficiently than they
 * would if based solely on offset, since the set of possible ranks is dense while the set of possible offsets is
 * potentially very sparse.
 */
module DefUse {
  /**
   * Gets the `Instruction` for the definition at offset `defOffset` in block `defBlock`.
   */
  bindingset[defOffset, defLocation]
  pragma[inline]
  Instruction getDefinitionOrChiInstruction(
    OldBlock defBlock, int defOffset, Alias::MemoryLocation defLocation
  ) {
    defOffset >= 0 and
    exists(OldInstruction oldInstr |
      oldInstr = defBlock.getInstruction(defOffset / 2) and
      if (defOffset % 2) > 0
      then
        // An odd offset corresponds to the `Chi` instruction.
        result = Chi(oldInstr)
      else
        // An even offset corresponds to the original instruction.
        result = getNewInstruction(oldInstr)
    )
    or
    defOffset < 0 and
    result = Phi(defBlock, defLocation)
  }

  /**
   * Gets the rank index of a hyphothetical use one instruction past the end of
   * the block. This index can be used to determine if a definition reaches the
   * end of the block, even if the definition is the last instruction in the
   * block.
   */
  private int exitRank(Alias::MemoryLocation useLocation, OldBlock block) {
    result = max(int rankIndex | defUseRank(useLocation, block, rankIndex, _)) + 1
  }

  /**
   * Holds if a definition that overlaps `useLocation` at (`defBlock`, `defRank`) reaches the use of `useLocation` at
   * (`useBlock`, `useRank`) without any intervening definitions that overlap `useLocation`, where `defBlock` and
   * `useBlock` are the same block.
   */
  private predicate definitionReachesUseWithinBlock(
    Alias::MemoryLocation useLocation, OldBlock defBlock, int defRank, OldBlock useBlock,
    int useRank
  ) {
    defBlock = useBlock and
    hasDefinitionAtRank(useLocation, _, defBlock, defRank, _) and
    hasUseAtRank(useLocation, useBlock, useRank, _) and
    definitionReachesRank(useLocation, defBlock, defRank, useRank)
  }

  /**
   * Holds if a definition that overlaps `useLocation` at (`defBlock`, `defRank`) reaches the use of `useLocation` at
   * (`useBlock`, `useRank`) without any intervening definitions that overlap `useLocation`.
   */
  predicate definitionReachesUse(
    Alias::MemoryLocation useLocation, OldBlock defBlock, int defRank, OldBlock useBlock,
    int useRank
  ) {
    hasUseAtRank(useLocation, useBlock, useRank, _) and
    (
      definitionReachesUseWithinBlock(useLocation, defBlock, defRank, useBlock, useRank)
      or
      definitionReachesEndOfBlock(useLocation, defBlock, defRank, useBlock.getAFeasiblePredecessor()) and
      not definitionReachesUseWithinBlock(useLocation, useBlock, _, useBlock, useRank)
    )
  }

  /**
   * Holds if the definition that overlaps `useLocation` at `(block, defRank)` reaches the rank
   * index `reachesRank` in block `block`.
   */
  private predicate definitionReachesRank(
    Alias::MemoryLocation useLocation, OldBlock block, int defRank, int reachesRank
  ) {
    hasDefinitionAtRank(useLocation, _, block, defRank, _) and
    reachesRank <= exitRank(useLocation, block) and // Without this, the predicate would be infinite.
    (
      // The def always reaches the next use, even if there is also a def on the
      // use instruction.
      reachesRank = defRank + 1
      or
      // If the def reached the previous rank, it also reaches the current rank,
      // unless there was another def at the previous rank.
      definitionReachesRank(useLocation, block, defRank, reachesRank - 1) and
      not hasDefinitionAtRank(useLocation, _, block, reachesRank - 1, _)
    )
  }

  /**
   * Holds if the definition that overlaps `useLocation` at `(defBlock, defRank)` reaches the end of
   * block `block` without any intervening definitions that overlap `useLocation`.
   */
  predicate definitionReachesEndOfBlock(
    Alias::MemoryLocation useLocation, OldBlock defBlock, int defRank, OldBlock block
  ) {
    hasDefinitionAtRank(useLocation, _, defBlock, defRank, _) and
    (
      // If we're looking at the def's own block, just see if it reaches the exit
      // rank of the block.
      block = defBlock and
      locationLiveOnExitFromBlock(useLocation, defBlock) and
      definitionReachesRank(useLocation, defBlock, defRank, exitRank(useLocation, defBlock))
      or
      exists(OldBlock idom |
        definitionReachesEndOfBlock(useLocation, defBlock, defRank, idom) and
        noDefinitionsSinceIDominator(useLocation, idom, block)
      )
    )
  }

  pragma[noinline]
  private predicate noDefinitionsSinceIDominator(
    Alias::MemoryLocation useLocation, OldBlock idom, OldBlock block
  ) {
    Dominance::blockImmediatelyDominates(idom, block) and // It is sufficient to traverse the dominator graph, cf. discussion above.
    locationLiveOnExitFromBlock(useLocation, block) and
    not hasDefinition(useLocation, _, block, _)
  }

  /**
   * Holds if the specified `useLocation` is live on entry to `block`. This holds if there is a use of `useLocation`
   * that is reachable from the start of `block` without passing through a definition that overlaps `useLocation`.
   * Note that even a partially-overlapping definition blocks liveness, because such a definition will insert a `Chi`
   * instruction whose result totally overlaps the location.
   */
  predicate locationLiveOnEntryToBlock(Alias::MemoryLocation useLocation, OldBlock block) {
    definitionHasPhiNode(useLocation, block)
    or
    exists(int firstAccess |
      hasUse(useLocation, block, firstAccess, _) and
      firstAccess = min(int offset |
          hasUse(useLocation, block, offset, _)
          or
          hasNonPhiDefinition(useLocation, _, block, offset)
        )
    )
    or
    locationLiveOnExitFromBlock(useLocation, block) and
    not hasNonPhiDefinition(useLocation, _, block, _)
  }

  /**
   * Holds if the specified `useLocation` is live on exit from `block`.
   */
  pragma[noinline]
  predicate locationLiveOnExitFromBlock(Alias::MemoryLocation useLocation, OldBlock block) {
    locationLiveOnEntryToBlock(useLocation, block.getAFeasibleSuccessor())
  }

  /**
   * Holds if there is a definition at offset `offset` in block `block` that overlaps memory location `useLocation`.
   * This predicate does not include definitions for Phi nodes.
   */
  private predicate hasNonPhiDefinition(
    Alias::MemoryLocation useLocation, Alias::MemoryLocation defLocation, OldBlock block, int offset
  ) {
    exists(OldInstruction def, Overlap overlap, int index |
      defLocation = Alias::getResultMemoryLocation(def) and
      block.getInstruction(index) = def and
      overlap = Alias::getOverlap(defLocation, useLocation) and
      if overlap instanceof MayPartiallyOverlap
      then offset = (index * 2) + 1 // The use will be connected to the definition on the `Chi` instruction.
      else offset = index * 2 // The use will be connected to the definition on the original instruction.
    )
  }

  /**
   * Holds if there is a definition at offset `offset` in block `block` that overlaps memory location `useLocation`.
   * This predicate includes definitions for Phi nodes (at offset -1).
   */
  private predicate hasDefinition(
    Alias::MemoryLocation useLocation, Alias::MemoryLocation defLocation, OldBlock block, int offset
  ) {
    (
      // If there is a Phi node for the use location itself, treat that as a definition at offset -1.
      offset = -1 and
      if definitionHasPhiNode(useLocation, block)
      then defLocation = useLocation
      else (
        definitionHasPhiNode(defLocation, block) and
        defLocation = useLocation.getVirtualVariable()
      )
    )
    or
    hasNonPhiDefinition(useLocation, defLocation, block, offset)
  }

  /**
   * Holds if there is a definition at offset `offset` in block `block` that overlaps memory location `useLocation`.
   * `rankIndex` is the rank of the definition as computed by `defUseRank()`.
   */
  predicate hasDefinitionAtRank(
    Alias::MemoryLocation useLocation, Alias::MemoryLocation defLocation, OldBlock block,
    int rankIndex, int offset
  ) {
    hasDefinition(useLocation, defLocation, block, offset) and
    defUseRank(useLocation, block, rankIndex, offset)
  }

  /**
   * Holds if there is a use of `useLocation` on instruction `use` at offset `offset` in block `block`.
   */
  private predicate hasUse(
    Alias::MemoryLocation useLocation, OldBlock block, int offset, OldInstruction use
  ) {
    exists(int index |
      block.getInstruction(index) = use and
      (
        // A direct use of the location.
        useLocation = Alias::getOperandMemoryLocation(use.getAnOperand()) and offset = index * 2
        or
        // A `Chi` instruction will include a use of the virtual variable.
        hasChiNode(useLocation, use) and offset = (index * 2) + 1
      )
    )
  }

  /**
   * Holds if there is a use of memory location `useLocation` on instruction `use` in block `block`. `rankIndex` is the
   * rank of the use use as computed by `defUseRank`.
   */
  predicate hasUseAtRank(
    Alias::MemoryLocation useLocation, OldBlock block, int rankIndex, OldInstruction use
  ) {
    exists(int offset |
      hasUse(useLocation, block, offset, use) and
      defUseRank(useLocation, block, rankIndex, offset)
    )
  }

  /**
   * Holds if there is a definition at offset `offset` in block `block` that overlaps memory location `useLocation`, or
   * a use of `useLocation` at offset `offset` in block `block`. `rankIndex` is the sequence number of the definition
   * or use within `block`, counting only uses of `useLocation` and definitions that overlap `useLocation`.
   */
  private predicate defUseRank(
    Alias::MemoryLocation useLocation, OldBlock block, int rankIndex, int offset
  ) {
    offset = rank[rankIndex](int j |
        hasDefinition(useLocation, _, block, j) or hasUse(useLocation, block, j, _)
      )
  }

  /**
   * Holds if the `Phi` instruction for location `useLocation` at the beginning of block `phiBlock` has an operand along
   * the incoming edge from `predBlock`, where that operand's definition is at offset `defOffset` in block `defBlock`,
   * and overlaps the use operand with overlap relationship `overlap`.
   */
  pragma[inline]
  predicate hasPhiOperandDefinition(
    Alias::MemoryLocation defLocation, Alias::MemoryLocation useLocation, OldBlock phiBlock,
    OldBlock predBlock, OldBlock defBlock, int defOffset, Overlap overlap
  ) {
    exists(int defRank |
      definitionHasPhiNode(useLocation, phiBlock) and
      predBlock = phiBlock.getAFeasiblePredecessor() and
      hasDefinitionAtRank(useLocation, defLocation, defBlock, defRank, defOffset) and
      definitionReachesEndOfBlock(useLocation, defBlock, defRank, predBlock) and
      overlap = Alias::getOverlap(defLocation, useLocation)
    )
  }
}

/**
 * Expose some of the internal predicates to PrintSSA.qll. We do this by publically importing those modules in the
 * `DebugSSA` module, which is then imported by PrintSSA.
 */
module DebugSSA {
  import PhiInsertion
  import DefUse
}

import CachedForDebugging

cached
private module CachedForDebugging {
  cached
  string getTempVariableUniqueId(IRTempVariable var) {
    result = getOldTempVariable(var).getUniqueId()
  }

  cached
  string getInstructionUniqueId(Instruction instr) {
    exists(OldInstruction oldInstr |
      oldInstr = getOldInstruction(instr) and
      result = "NonSSA: " + oldInstr.getUniqueId()
    )
    or
    exists(Alias::MemoryLocation location, OldBlock phiBlock, string specificity |
      instr = Phi(phiBlock, location) and
      result = "Phi Block(" + phiBlock.getUniqueId() + ")[" + specificity + "]: " +
          location.getUniqueId() and
      if location instanceof Alias::VirtualVariable
      then
        // Sort Phi nodes for virtual variables before Phi nodes for member locations.
        specificity = "g"
      else specificity = "s"
    )
    or
    instr = Unreached(_) and
    result = "Unreached"
  }

  private OldIR::IRTempVariable getOldTempVariable(IRTempVariable var) {
    result.getEnclosingFunction() = var.getEnclosingFunction() and
    result.getAST() = var.getAST() and
    result.getTag() = var.getTag()
  }
}
