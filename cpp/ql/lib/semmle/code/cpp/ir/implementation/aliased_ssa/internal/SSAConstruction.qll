import SSAConstructionInternal
private import SSAConstructionImports as Imports
private import Imports::Opcode
private import Imports::OperandTag
private import Imports::Overlap
private import Imports::TInstruction
private import Imports::RawIR as RawIR
private import SsaInstructions
private import SsaOperands
private import NewIR

private class OldBlock = Reachability::ReachableBlock;

private class OldInstruction = Reachability::ReachableInstruction;

import Cached

/**
 * Holds if `instruction` is the first instruction that may be followed by
 * an `UninitializedGroup` instruction, and the enclosing function of
 * `instruction` is `func`.
 */
private predicate isFirstInstructionBeforeUninitializedGroup(
  Instruction instruction, IRFunction func
) {
  instruction = getChi(any(OldIR::InitializeNonLocalInstruction init)) and
  func = instruction.getEnclosingIRFunction()
}

/** Gets the `i`'th `UninitializedGroup` instruction in `func`. */
private UninitializedGroupInstruction getInitGroupInstruction(int i, IRFunction func) {
  exists(Alias::VariableGroup vg |
    vg.getIRFunction() = func and
    vg.getInitializationOrder() = i and
    result = uninitializedGroup(vg)
  )
}

/**
 * Holds if `instruction` is the last instruction in the chain of `UninitializedGroup`
 * instructions in `func`. The chain of instructions may be empty in which case
 * `instruction` satisfies
 * ```
 * isFirstInstructionBeforeUninitializedGroup(instruction, func)
 * ```
 */
predicate isLastInstructionForUninitializedGroups(Instruction instruction, IRFunction func) {
  exists(int i |
    instruction = getInitGroupInstruction(i, func) and
    not exists(getChi(instruction)) and
    not exists(getInitGroupInstruction(i + 1, func))
  )
  or
  exists(int i |
    instruction = getChi(getInitGroupInstruction(i, func)) and
    not exists(getInitGroupInstruction(i + 1, func))
  )
  or
  isFirstInstructionBeforeUninitializedGroup(instruction, func) and
  not exists(getInitGroupInstruction(0, func))
}

cached
private module Cached {
  cached
  predicate hasPhiInstructionCached(
    OldInstruction blockStartInstr, Alias::MemoryLocation defLocation
  ) {
    exists(OldBlock oldBlock |
      definitionHasPhiNode(defLocation, oldBlock) and
      blockStartInstr = oldBlock.getFirstInstruction()
    )
  }

  cached
  predicate hasChiInstructionCached(OldInstruction primaryInstruction) {
    hasChiNode(_, primaryInstruction)
  }

  cached
  predicate hasChiNodeAfterUninitializedGroup(UninitializedGroupInstruction initGroup) {
    hasChiNodeAfterUninitializedGroup(_, initGroup)
  }

  cached
  predicate hasUnreachedInstructionCached(IRFunction irFunc) {
    exists(OldIR::Instruction oldInstruction |
      irFunc = oldInstruction.getEnclosingIRFunction() and
      (
        Reachability::isInfeasibleInstructionSuccessor(oldInstruction, _)
        or
        oldInstruction.getOpcode() instanceof Opcode::Unreached
      )
    )
  }

  class TStageInstruction =
    TRawInstruction or TPhiInstruction or TChiInstruction or TUnreachedInstruction or
        TUninitializedGroupInstruction;

  /**
   * If `oldInstruction` is a `Phi` instruction that has exactly one reachable predecessor block,
   * this predicate returns the `PhiInputOperand` corresponding to that predecessor block.
   * Otherwise, this predicate does not hold.
   */
  private OldIR::PhiInputOperand getDegeneratePhiOperand(OldInstruction oldInstruction) {
    result =
      unique(OldIR::PhiInputOperand operand |
        operand = oldInstruction.(OldIR::PhiInstruction).getAnInputOperand() and
        operand.getPredecessorBlock() instanceof OldBlock
      )
  }

  cached
  predicate hasInstruction(TStageInstruction instr) {
    instr instanceof TRawInstruction and instr instanceof OldInstruction
    or
    instr = phiInstruction(_, _)
    or
    instr = reusedPhiInstruction(_) and
    // Check that the phi instruction is *not* degenerate, but we can't use
    // getDegeneratePhiOperand in the first stage with phi instructions
    not exists(
      unique(OldIR::PhiInputOperand operand |
        operand = instr.(OldIR::PhiInstruction).getAnInputOperand() and
        operand.getPredecessorBlock() instanceof OldBlock
      )
    )
    or
    instr instanceof TChiInstruction
    or
    instr instanceof TUninitializedGroupInstruction
    or
    instr instanceof TUnreachedInstruction
  }

  cached
  IRBlock getNewBlock(OldBlock oldBlock) {
    exists(Instruction newEnd, OldIR::Instruction oldEnd |
      (
        result.getLastInstruction() = newEnd and
        not newEnd instanceof ChiInstruction
        or
        newEnd = result.getLastInstruction().(ChiInstruction).getAPredecessor() // does this work?
      ) and
      (
        oldBlock.getLastInstruction() = oldEnd and
        not oldEnd instanceof OldIR::ChiInstruction
        or
        oldEnd = oldBlock.getLastInstruction().(OldIR::ChiInstruction).getAPredecessor() // does this work?
      ) and
      oldEnd = getNewInstruction(newEnd)
    )
  }

  /**
   * Gets the block from the old IR that corresponds to `newBlock`.
   */
  private OldBlock getOldBlock(IRBlock newBlock) { getNewBlock(result) = newBlock }

  /**
   * Holds if this iteration of SSA can model the def/use information for the result of
   * `oldInstruction`, either because alias analysis has determined a memory location for that
   * result, or because a previous iteration of the IR already computed that def/use information
   * completely.
   */
  private predicate canModelResultForOldInstruction(OldInstruction oldInstruction) {
    // We're modeling the result's memory location ourselves.
    exists(Alias::getResultMemoryLocation(oldInstruction))
    or
    // This result was already modeled by a previous iteration of SSA.
    Alias::canReuseSsaForOldResult(oldInstruction)
  }

  cached
  predicate hasModeledMemoryResult(Instruction instruction) {
    canModelResultForOldInstruction(getOldInstruction(instruction)) or
    instruction instanceof PhiInstruction or // Phis always have modeled results
    instruction instanceof ChiInstruction or // Chis always have modeled results
    instruction instanceof UninitializedGroupInstruction // Group initializers always have modeled results
  }

  cached
  predicate hasConflatedMemoryResult(Instruction instruction) {
    instruction instanceof AliasedDefinitionInstruction
    or
    instruction.getOpcode() instanceof Opcode::InitializeNonLocal
    or
    // Chi instructions track virtual variables, and therefore a chi instruction is
    // conflated if it's associated with the aliased virtual variable.
    exists(Instruction input | instruction = getChi(input) |
      Alias::getResultMemoryLocation(input).getVirtualVariable() instanceof
        Alias::AliasedVirtualVariable
      or
      // A chi following an `UninitializedGroupInstruction` only happens when the virtual
      // variable of the grouped memory location is `{AllAliasedMemory}`.
      exists(Alias::GroupedMemoryLocation gml |
        input = uninitializedGroup(gml.getGroup()) and
        gml.getVirtualVariable() instanceof Alias::AliasedVirtualVariable
      )
    )
    or
    // Phi instructions track locations, and therefore a phi instruction is
    // conflated if it's associated with a conflated location.
    exists(Alias::MemoryLocation location |
      instruction = getPhi(_, location) and
      not exists(location.getAnAllocation())
    )
  }

  pragma[noopt]
  private predicate hasMemoryOperandDefinition(
    OldInstruction oldInstruction, OldIR::NonPhiMemoryOperand oldOperand, Overlap overlap,
    Instruction instr
  ) {
    oldOperand = oldInstruction.getAnOperand() and
    oldOperand instanceof OldIR::NonPhiMemoryOperand and
    exists(
      OldBlock useBlock, int useRank, Alias::MemoryLocation useLocation,
      Alias::MemoryLocation defLocation, OldBlock defBlock, int defRank, int defOffset,
      Alias::MemoryLocation actualDefLocation
    |
      useLocation = Alias::getOperandMemoryLocation(oldOperand) and
      hasUseAtRank(useLocation, useBlock, useRank, oldInstruction) and
      definitionReachesUse(useLocation, defBlock, defRank, useBlock, useRank) and
      hasDefinitionAtRank(useLocation, defLocation, defBlock, defRank, defOffset) and
      instr = getDefinitionOrChiInstruction(defBlock, defOffset, defLocation, actualDefLocation) and
      overlap = Alias::getOverlap(actualDefLocation, useLocation)
    )
  }

  /**
   * Gets the new definition instruction for `oldOperand` based on `oldOperand`'s definition in the
   * old IR. Usually, this will just get the old definition of `oldOperand` and map it to the
   * corresponding new instruction. However, if the old definition of `oldOperand` is a `Phi`
   * instruction that is now degenerate due all but one of its predecessor branches being
   * unreachable, this predicate will recurse through any degenerate `Phi` instructions to find the
   * true definition.
   */
  private Instruction getNewDefinitionFromOldSsa(OldIR::MemoryOperand oldOperand, Overlap overlap) {
    exists(Overlap originalOverlap |
      originalOverlap = oldOperand.getDefinitionOverlap() and
      (
        result = getNewInstruction(oldOperand.getAnyDef()) and
        overlap = originalOverlap
        or
        exists(OldIR::PhiInputOperand phiOperand, Overlap phiOperandOverlap |
          phiOperand = getDegeneratePhiOperand(oldOperand.getAnyDef()) and
          result = getNewDefinitionFromOldSsa(phiOperand, phiOperandOverlap) and
          overlap =
            combineOverlap(pragma[only_bind_out](phiOperandOverlap),
              pragma[only_bind_out](originalOverlap))
        )
      )
    )
  }

  cached
  private Instruction getMemoryOperandDefinition0(
    Instruction instruction, MemoryOperandTag tag, Overlap overlap
  ) {
    exists(OldInstruction oldInstruction, OldIR::NonPhiMemoryOperand oldOperand |
      oldInstruction = getOldInstruction(instruction) and
      oldOperand = oldInstruction.getAnOperand() and
      tag = oldOperand.getOperandTag() and
      hasMemoryOperandDefinition(oldInstruction, oldOperand, overlap, result)
    )
    or
    (
      instruction = getChi(getOldInstruction(result))
      or
      instruction = getChi(result.(UninitializedGroupInstruction))
    ) and
    tag instanceof ChiPartialOperandTag and
    overlap instanceof MustExactlyOverlap
    or
    tag instanceof ChiTotalOperandTag and
    result = getChiInstructionTotalOperand(instruction) and
    overlap instanceof MustExactlyOverlap
  }

  cached
  Instruction getMemoryOperandDefinition(
    Instruction instruction, MemoryOperandTag tag, Overlap overlap
  ) {
    // getMemoryOperandDefinition0 currently has a bug where it can match with multiple overlaps.
    // This predicate ensures that the chosen overlap is the most conservative if there's any doubt.
    result = getMemoryOperandDefinition0(instruction, tag, overlap) and
    not (
      overlap instanceof MustExactlyOverlap and
      exists(MustTotallyOverlap o | exists(getMemoryOperandDefinition0(instruction, tag, o)))
    )
    or
    exists(OldIR::NonPhiMemoryOperand oldOperand |
      result = getNewDefinitionFromOldSsa(oldOperand, overlap) and
      oldOperand.getUse() = instruction and
      tag = oldOperand.getOperandTag()
    )
  }

  /**
   * Holds if `operand` totally overlaps with its definition and consumes the bit range
   * `[startBitOffset, endBitOffset)`.
   */
  cached
  predicate getUsedInterval(NonPhiMemoryOperand operand, int startBitOffset, int endBitOffset) {
    exists(Alias::MemoryLocation location, OldIR::NonPhiMemoryOperand oldOperand |
      oldOperand = operand.getUse().(OldInstruction).getAnOperand() and
      location = Alias::getOperandMemoryLocation(oldOperand) and
      startBitOffset = Alias::getStartBitOffset(location) and
      endBitOffset = Alias::getEndBitOffset(location)
    )
  }

  /**
   * Holds if the `ChiPartialOperand` only partially overlaps with the `ChiTotalOperand`.
   * This means that the `ChiPartialOperand` will not override the entire memory associated
   * with the `ChiTotalOperand`.
   */
  cached
  predicate chiOnlyPartiallyUpdatesLocation(ChiInstruction chi) {
    exists(Alias::MemoryLocation location, OldInstruction oldInstruction |
      oldInstruction = getOldInstruction(chi.getPartial()) and
      location = Alias::getResultMemoryLocation(oldInstruction)
    |
      Alias::getStartBitOffset(location) != 0 or
      Alias::getEndBitOffset(location) != 8 * location.getType().getByteSize()
    )
  }

  cached
  IRVariable getAnUninitializedGroupVariable(UninitializedGroupInstruction init) {
    exists(Alias::VariableGroup vg |
      init = uninitializedGroup(vg) and
      result = vg.getAnAllocation().getABaseInstruction().(VariableInstruction).getIRVariable()
    )
  }

  /**
   * Holds if `instr` is part of a cycle in the operand graph that doesn't go
   * through a phi instruction and therefore should be impossible.
   *
   * For performance reasons, this predicate is not implemented (never holds)
   * for the SSA stages of the IR.
   */
  cached
  predicate isInCycle(Instruction instr) { none() }

  cached
  Language::LanguageType getInstructionOperandType(Instruction instr, TypedOperandTag tag) {
    exists(OldInstruction oldInstruction, OldIR::TypedOperand oldOperand |
      oldInstruction = getOldInstruction(instr) and
      oldOperand = oldInstruction.getAnOperand() and
      tag = oldOperand.getOperandTag() and
      result = oldOperand.getLanguageType()
    )
  }

  /**
   * Gets the new definition instruction for the operand of `instr` that flows from the block
   * `newPredecessorBlock`, based on that operand's definition in the old IR.
   */
  private Instruction getNewPhiOperandDefinitionFromOldSsa(
    Instruction instr, IRBlock newPredecessorBlock, Overlap overlap
  ) {
    exists(OldIR::PhiInstruction oldPhi, OldIR::PhiInputOperand oldOperand |
      oldPhi = getOldInstruction(instr) and
      oldOperand = oldPhi.getInputOperand(getOldBlock(newPredecessorBlock)) and
      result = getNewDefinitionFromOldSsa(oldOperand, overlap)
    )
  }

  pragma[noopt]
  cached
  Instruction getPhiOperandDefinition(
    Instruction instr, IRBlock newPredecessorBlock, Overlap overlap
  ) {
    exists(
      Alias::MemoryLocation defLocation, Alias::MemoryLocation useLocation, OldBlock phiBlock,
      OldBlock predBlock, OldBlock defBlock, int defOffset, Alias::MemoryLocation actualDefLocation
    |
      hasPhiOperandDefinition(defLocation, useLocation, phiBlock, predBlock, defBlock, defOffset) and
      instr = getPhi(phiBlock, useLocation) and
      newPredecessorBlock = getNewBlock(predBlock) and
      result = getDefinitionOrChiInstruction(defBlock, defOffset, defLocation, actualDefLocation) and
      overlap = Alias::getOverlap(actualDefLocation, useLocation)
    )
    or
    result = getNewPhiOperandDefinitionFromOldSsa(instr, newPredecessorBlock, overlap)
  }

  private ChiInstruction getChiAfterUninitializedGroup(int i, IRFunction func) {
    result =
      rank[i + 1](VariableGroup vg, UninitializedGroupInstruction initGroup, ChiInstruction chi,
        int r |
        initGroup.getEnclosingIRFunction() = func and
        chi = getChi(initGroup) and
        initGroup = uninitializedGroup(vg) and
        r = vg.getInitializationOrder()
      |
        chi order by r
      )
  }

  cached
  Instruction getChiInstructionTotalOperand(ChiInstruction chiInstr) {
    exists(
      Alias::VirtualVariable vvar, OldInstruction oldInstr, OldBlock defBlock, int defRank,
      int defOffset, OldBlock useBlock, int useRank
    |
      chiInstr = getChi(oldInstr) and
      vvar = Alias::getResultMemoryLocation(oldInstr).getVirtualVariable() and
      hasDefinitionAtRank(vvar, _, defBlock, defRank, defOffset) and
      hasUseAtRank(vvar, useBlock, useRank, oldInstr) and
      definitionReachesUse(vvar, defBlock, defRank, useBlock, useRank) and
      result = getDefinitionOrChiInstruction(defBlock, defOffset, vvar, _)
    )
    or
    exists(UninitializedGroupInstruction initGroup, IRFunction func |
      chiInstr = getChi(initGroup) and
      func = initGroup.getEnclosingIRFunction()
    |
      chiInstr = getChiAfterUninitializedGroup(0, func) and
      isFirstInstructionBeforeUninitializedGroup(result, func)
      or
      exists(int i |
        chiInstr = getChiAfterUninitializedGroup(i + 1, func) and
        result = getChiAfterUninitializedGroup(i, func)
      )
    )
  }

  cached
  Instruction getPhiInstructionBlockStart(PhiInstruction instr) {
    exists(OldBlock oldBlock |
      (
        instr = getPhi(oldBlock, _)
        or
        // Any `Phi` that we propagated from the previous iteration stays in the same block.
        getOldInstruction(instr).getBlock() = oldBlock
      ) and
      result = getNewInstruction(oldBlock.getFirstInstruction())
    )
  }

  private UninitializedGroupInstruction firstInstructionToUninitializedGroup(
    Instruction instruction, EdgeKind kind
  ) {
    exists(IRFunction func |
      isFirstInstructionBeforeUninitializedGroup(instruction, func) and
      result = getInitGroupInstruction(0, func) and
      kind instanceof GotoEdge
    )
  }

  private Instruction getNextUninitializedGroupInstruction(Instruction instruction, EdgeKind kind) {
    exists(int i, IRFunction func |
      func = instruction.getEnclosingIRFunction() and
      instruction = getInitGroupInstruction(i, func) and
      kind instanceof GotoEdge
    |
      if hasChiNodeAfterUninitializedGroup(_, instruction)
      then result = getChi(instruction)
      else result = getInitGroupInstruction(i + 1, func)
    )
    or
    exists(int i, IRFunction func, UninitializedGroupInstruction initGroup |
      func = instruction.getEnclosingIRFunction() and
      instruction = getChi(initGroup) and
      initGroup = getInitGroupInstruction(i, func) and
      kind instanceof GotoEdge
    |
      result = getInitGroupInstruction(i + 1, func)
    )
  }

  private Instruction getInstructionSuccessorAfterUninitializedGroup0(
    Instruction instruction, EdgeKind kind
  ) {
    if hasChiNode(_, getOldInstruction(instruction))
    then
      result = getChi(getOldInstruction(instruction)) and
      kind instanceof GotoEdge
    else
      exists(OldInstruction oldInstruction |
        (
          oldInstruction = getOldInstruction(instruction)
          or
          instruction = getChi(oldInstruction)
        ) and
        (
          if Reachability::isInfeasibleInstructionSuccessor(oldInstruction, kind)
          then result = unreachedInstruction(instruction.getEnclosingIRFunction())
          else result = getNewInstruction(oldInstruction.getSuccessor(kind))
        )
      )
  }

  private Instruction getInstructionSuccessorAfterUninitializedGroup(
    Instruction instruction, EdgeKind kind
  ) {
    exists(IRFunction func, Instruction firstBeforeUninitializedGroup |
      isLastInstructionForUninitializedGroups(instruction, func) and
      isFirstInstructionBeforeUninitializedGroup(firstBeforeUninitializedGroup, func) and
      result = getInstructionSuccessorAfterUninitializedGroup0(firstBeforeUninitializedGroup, kind)
    )
  }

  /**
   * This adds Chi nodes to the instruction successor relation; if an instruction has a Chi node,
   * that node is its successor in the new successor relation, and the Chi node's successors are
   * the new instructions generated from the successors of the old instruction.
   *
   * Furthermore, the entry block is augmented with `UninitializedGroup` instructions and `Chi`
   * instructions. For example, consider this example:
   * ```cpp
   * int x, y;
   * int* p;
   * if(b) {
   *   p = &x;
   *   escape(&x);
   * } else {
   *   p = &y;
   * }
   * *p = 42;
   *
   * int z, w;
   * int* q;
   * if(b) {
   *   q = &z;
   * } else {
   *   q = &w;
   * }
   * *q = 43;
   * ```
   *
   * the unaliased IR for the entry block of this snippet is:
   * ```
   * v1(void)         = EnterFunction          :
   * m1(unknown)      = AliasedDefinition      :
   * m2(unknown)      = InitializeNonLocal     :
   * r1(glval<bool>)  = VariableAddress[b]     :
   * m3(bool)         = InitializeParameter[b] : &:r1
   * r2(glval<int>)   = VariableAddress[x]     :
   * m4(int)          = Uninitialized[x]       : &:r2
   * r3(glval<int>)   = VariableAddress[y]     :
   * m5(int)          = Uninitialized[y]       : &:r3
   * r4(glval<int *>) = VariableAddress[p]     :
   * m6(int *)        = Uninitialized[p]       : &:r4
   * r5(glval<bool>)  = VariableAddress[b]     :
   * r6(bool)         = Load[b]                : &:r5, m3
   * v2(void)         = ConditionalBranch      : r6
   * ```
   * and we need to transform this to aliased IR by inserting an `UninitializedGroup`
   * instruction for every `VariableGroup` memory location in the function. Furthermore,
   * if the `VariableGroup` memory location contains an allocation that escapes we need
   * to insert a `Chi` that writes the memory produced by `UninitializedGroup` into
   * `{AllAliasedMemory}`. For the above snippet we then end up with:
   * ```
   * v1(void)         = EnterFunction           :
   * m2(unknown)      = AliasedDefinition       :
   * m3(unknown)      = InitializeNonLocal      :
   * m4(unknown)      = Chi                     : total:m2, partial:m3
   * m5(int)          = UninitializedGroup[x,y] :
   * m6(unknown)      = Chi                     : total:m4, partial:m5
   * m7(int)          = UninitializedGroup[w,z] :
   * r1(glval<bool>)  = VariableAddress[b]      :
   * m8(bool)         = InitializeParameter[b]  : &:r1
   * r2(glval<int>)   = VariableAddress[x]      :
   * m10(int)         = Uninitialized[x]       : &:r2
   * m11(unknown)     = Chi                    : total:m6, partial:m10
   * r3(glval<int>)   = VariableAddress[y]      :
   * m12(int)         = Uninitialized[y]       : &:r3
   * m13(unknown)     = Chi                    : total:m11, partial:m12
   * r4(glval<int *>) = VariableAddress[p]      :
   * m14(int *)       = Uninitialized[p]       : &:r4
   * r5(glval<bool>)  = VariableAddress[b]      :
   * r6(bool)         = Load[b]                 : &:r5, m8
   * v2(void)         = ConditionalBranch       : r6
   * ```
   *
   * Here, the group `{x, y}` contains an allocation that escapes (`x`), so there
   * is a `Chi` after the `UninitializedGroup` that initializes the memory for the
   * `VariableGroup` containing `x`. None of the allocations in `{w, z}` escape so
   * there is no `Chi` following that the `UninitializedGroup` that initializes the
   * memory of `{w, z}`.
   */
  cached
  Instruction getInstructionSuccessor(Instruction instruction, EdgeKind kind) {
    result = firstInstructionToUninitializedGroup(instruction, kind)
    or
    result = getNextUninitializedGroupInstruction(instruction, kind)
    or
    result = getInstructionSuccessorAfterUninitializedGroup(instruction, kind)
    or
    not isFirstInstructionBeforeUninitializedGroup(instruction, _) and
    result = getInstructionSuccessorAfterUninitializedGroup0(instruction, kind)
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
      then instruction = getChi(oldInstruction)
      else instruction = getNewInstruction(oldInstruction)
    )
  }

  cached
  Language::AST getInstructionAst(Instruction instr) {
    result = getOldInstruction(instr).getAst()
    or
    exists(RawIR::Instruction blockStartInstr |
      instr = phiInstruction(blockStartInstr, _) and
      result = blockStartInstr.getAst()
    )
    or
    exists(RawIR::Instruction primaryInstr |
      instr = chiInstruction(primaryInstr) and
      result = primaryInstr.getAst()
    )
    or
    exists(IRFunctionBase irFunc |
      instr = unreachedInstruction(irFunc) and result = irFunc.getFunction()
    )
    or
    exists(Alias::VariableGroup vg |
      instr = uninitializedGroup(vg) and
      result = vg.getIRFunction().getFunction()
    )
    or
    exists(UninitializedGroupInstruction initGroup |
      instr = chiInstruction(initGroup) and
      result = getInstructionAst(initGroup)
    )
  }

  cached
  Language::LanguageType getInstructionResultType(Instruction instr) {
    result = instr.(RawIR::Instruction).getResultLanguageType()
    or
    exists(Alias::MemoryLocation defLocation |
      instr = phiInstruction(_, defLocation) and
      result = defLocation.getType()
    )
    or
    exists(Instruction primaryInstr, Alias::VirtualVariable vvar |
      instr = chiInstruction(primaryInstr) and result = vvar.getType()
    |
      hasChiNode(vvar, primaryInstr)
      or
      hasChiNodeAfterUninitializedGroup(vvar, primaryInstr)
    )
    or
    exists(Alias::VariableGroup vg |
      instr = uninitializedGroup(vg) and
      result = vg.getType()
    )
    or
    instr = reusedPhiInstruction(_) and
    result = instr.(OldInstruction).getResultLanguageType()
    or
    instr = unreachedInstruction(_) and result = Language::getVoidType()
  }

  cached
  IRType getInstructionResultIRType(Instruction instr) {
    result = instr.getResultLanguageType().getIRType()
  }

  /**
   * Holds if `opcode` is the opcode that specifies the operation performed by `instr`.
   *
   * The parameters are ordered such that they produce a clean join (with no need for reordering)
   * in the characteristic predicates of the `Instruction` subclasses.
   */
  cached
  predicate getInstructionOpcode(Opcode opcode, Instruction instr) {
    opcode = getOldInstruction(instr).getOpcode()
    or
    instr = phiInstruction(_, _) and opcode instanceof Opcode::Phi
    or
    instr = chiInstruction(_) and opcode instanceof Opcode::Chi
    or
    instr = uninitializedGroup(_) and opcode instanceof Opcode::UninitializedGroup
    or
    instr = unreachedInstruction(_) and opcode instanceof Opcode::Unreached
  }

  cached
  IRFunctionBase getInstructionEnclosingIRFunction(Instruction instr) {
    result = getOldInstruction(instr).getEnclosingIRFunction()
    or
    exists(OldInstruction blockStartInstr |
      instr = phiInstruction(blockStartInstr, _) and
      result = blockStartInstr.getEnclosingIRFunction()
    )
    or
    exists(Instruction primaryInstr |
      instr = chiInstruction(primaryInstr) and result = primaryInstr.getEnclosingIRFunction()
    )
    or
    exists(Alias::VariableGroup vg |
      instr = uninitializedGroup(vg) and
      result = vg.getIRFunction()
    )
    or
    instr = unreachedInstruction(result)
  }

  cached
  Instruction getPrimaryInstructionForSideEffect(Instruction instruction) {
    exists(OldIR::SideEffectInstruction oldInstruction |
      oldInstruction = getOldInstruction(instruction) and
      result = getNewInstruction(oldInstruction.getPrimaryInstruction())
    )
    or
    exists(OldIR::Instruction oldInstruction |
      instruction = getChi(oldInstruction) and
      result = getNewInstruction(oldInstruction)
    )
    or
    instruction = getChi(result.(UninitializedGroupInstruction))
  }
}

private Instruction getNewInstruction(OldInstruction instr) { getOldInstruction(result) = instr }

private OldInstruction getOldInstruction(Instruction instr) { instr = result }

private ChiInstruction getChi(Instruction primaryInstr) { result = chiInstruction(primaryInstr) }

private PhiInstruction getPhi(OldBlock defBlock, Alias::MemoryLocation defLocation) {
  result = phiInstruction(defBlock.getFirstInstruction(), defLocation)
}

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

private predicate hasChiNodeAfterUninitializedGroup(
  Alias::AliasedVirtualVariable vvar, UninitializedGroupInstruction initGroup
) {
  exists(Alias::GroupedMemoryLocation defLocation |
    initGroup = uninitializedGroup(defLocation.getGroup()) and
    defLocation.getVirtualVariable() = vvar and
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
   * Holds if `phiBlock` is a block in the dominance frontier of a block that has a definition of the
   * memory location `defLocation`.
   */
  pragma[noinline]
  private predicate dominanceFrontierOfDefinition(
    Alias::MemoryLocation defLocation, OldBlock phiBlock
  ) {
    exists(OldBlock defBlock |
      phiBlock = Dominance::getDominanceFrontier(defBlock) and
      definitionHasDefinitionInBlock(defLocation, defBlock)
    )
  }

  /**
   * Holds if a `Phi` instruction needs to be inserted for location `defLocation` at the beginning of block `phiBlock`.
   */
  predicate definitionHasPhiNode(Alias::MemoryLocation defLocation, OldBlock phiBlock) {
    dominanceFrontierOfDefinition(defLocation, phiBlock) and
    /* We can also eliminate those nodes where the definition is not live on any incoming edge */
    definitionLiveOnEntryToBlock(defLocation, phiBlock)
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
      firstAccess =
        min(int index |
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
  bindingset[index, block]
  pragma[inline_late]
  private int getNonChiOffset(int index, OldBlock block) {
    exists(OldIR::IRFunction func, Instruction i, OldBlock entryBlock |
      func = block.getEnclosingIRFunction() and
      i = block.getInstruction(index) and
      entryBlock = func.getEntryBlock()
    |
      if
        block = entryBlock and
        not i instanceof InitializeNonLocalInstruction and
        not i instanceof AliasedDefinitionInstruction
      then result = 2 * (index + count(VariableGroup vg | vg.getIRFunction() = func))
      else result = 2 * index
    )
  }

  bindingset[index, block]
  pragma[inline_late]
  private int getChiOffset(int index, OldBlock block) { result = getNonChiOffset(index, block) + 1 }

  /**
   * Gets the `Instruction` for the definition at offset `defOffset` in block `defBlock`.
   */
  private Instruction getDefinitionOrChiInstruction0(
    OldBlock defBlock, int defOffset, Alias::MemoryLocation defLocation,
    Alias::MemoryLocation actualDefLocation
  ) {
    exists(OldInstruction oldInstr, int oldOffset | oldInstr = defBlock.getInstruction(oldOffset) |
      // An odd offset corresponds to the `Chi` instruction.
      defOffset = getChiOffset(oldOffset, defBlock) and
      result = getChi(oldInstr) and
      (
        defLocation = Alias::getResultMemoryLocation(oldInstr) or
        defLocation = Alias::getResultMemoryLocation(oldInstr).getVirtualVariable()
      ) and
      actualDefLocation = defLocation.getVirtualVariable()
      or
      // An even offset corresponds to the original instruction.
      defOffset = getNonChiOffset(oldOffset, defBlock) and
      result = getNewInstruction(oldInstr) and
      (
        defLocation = Alias::getResultMemoryLocation(oldInstr) or
        defLocation = Alias::getResultMemoryLocation(oldInstr).getVirtualVariable()
      ) and
      actualDefLocation = defLocation
    )
    or
    defOffset = -1 and
    hasDefinition(_, defLocation, defBlock, defOffset) and
    result = getPhi(defBlock, defLocation) and
    actualDefLocation = defLocation
    or
    exists(
      Alias::VariableGroup vg, int index, UninitializedGroupInstruction initGroup,
      Alias::GroupedMemoryLocation gml
    |
      // Add 3 to account for the function prologue:
      // v1(void)    = EnterFunction
      // m1(unknown) = AliasedDefinition
      // m2(unknown) = InitializeNonLocal
      index = 3 + vg.getInitializationOrder() and
      not gml.isMayAccess() and
      gml.isSome() and
      gml.getGroup() = vg and
      vg.getIRFunction().getEntryBlock() = defBlock and
      initGroup = uninitializedGroup(vg) and
      (defLocation = gml or defLocation = gml.getVirtualVariable())
    |
      result = initGroup and
      defOffset = 2 * index and
      actualDefLocation = defLocation
      or
      result = getChi(initGroup) and
      defOffset = 2 * index + 1 and
      actualDefLocation = defLocation.getVirtualVariable()
    )
  }

  private ChiInstruction remapGetDefinitionOrChiInstruction(Instruction oldResult) {
    exists(IRFunction func |
      isFirstInstructionBeforeUninitializedGroup(oldResult, func) and
      isLastInstructionForUninitializedGroups(result, func)
    )
  }

  Instruction getDefinitionOrChiInstruction(
    OldBlock defBlock, int defOffset, Alias::MemoryLocation defLocation,
    Alias::MemoryLocation actualDefLocation
  ) {
    exists(Instruction oldResult |
      oldResult =
        getDefinitionOrChiInstruction0(defBlock, defOffset, defLocation, actualDefLocation) and
      (
        result = remapGetDefinitionOrChiInstruction(oldResult)
        or
        not exists(remapGetDefinitionOrChiInstruction(oldResult)) and
        result = oldResult
      )
    )
  }

  /**
   * Gets the rank index of a hypothetical use one instruction past the end of
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
    // The def always reaches the next use, even if there is also a def on the
    // use instruction.
    hasDefinitionAtRank(useLocation, _, block, defRank, _) and
    reachesRank = defRank + 1
    or
    // If the def reached the previous rank, it also reaches the current rank,
    // unless there was another def at the previous rank.
    exists(int prevRank |
      reachesRank = prevRank + 1 and
      definitionReachesRank(useLocation, block, defRank, prevRank) and
      not prevRank = exitRank(useLocation, block) and
      not hasDefinitionAtRank(useLocation, _, block, prevRank, _)
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
      firstAccess =
        min(int offset |
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
      then offset = getChiOffset(index, block) // The use will be connected to the definition on the `Chi` instruction.
      else offset = getNonChiOffset(index, block) // The use will be connected to the definition on the original instruction.
    )
    or
    exists(UninitializedGroupInstruction initGroup, int index, Overlap overlap, VariableGroup vg |
      initGroup.getEnclosingIRFunction().getEntryBlock() = getNewBlock(block) and
      vg = defLocation.(Alias::GroupedMemoryLocation).getGroup() and
      // EnterFunction + AliasedDefinition + InitializeNonLocal + index
      index = 3 + vg.getInitializationOrder() and
      initGroup = uninitializedGroup(vg) and
      overlap = Alias::getOverlap(defLocation, useLocation) and
      if overlap instanceof MayPartiallyOverlap and hasChiNodeAfterUninitializedGroup(initGroup)
      then offset = 2 * index + 1 // The use will be connected to the definition on the `Chi` instruction.
      else offset = 2 * index // The use will be connected to the definition on the original instruction.
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
        defLocation = useLocation.getVirtualVariable() and
        // Handle the unusual case where a virtual variable does not overlap one of its member
        // locations. For example, a definition of the virtual variable representing all aliased
        // memory does not overlap a use of a string literal, because the contents of a string
        // literal can never be redefined. The string literal's location could still be a member of
        // the `AliasedVirtualVariable` due to something like:
        // ```
        // char s[10];
        // strcpy(s, p);
        // const char* p = b ? "SomeLiteral" : s;
        // return p[3];
        // ```
        // In the above example, `p[3]` may access either the string literal or the local variable
        // `s`, so both of those locations must be members of the `AliasedVirtualVariable`.
        exists(Alias::getOverlap(defLocation, useLocation))
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
        useLocation = Alias::getOperandMemoryLocation(use.getAnOperand()) and
        offset = getNonChiOffset(index, block)
        or
        // A `Chi` instruction will include a use of the virtual variable.
        hasChiNode(useLocation, use) and offset = getChiOffset(index, block)
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
    offset =
      rank[rankIndex](int j |
        hasDefinition(useLocation, _, block, j) or hasUse(useLocation, block, j, _)
      )
  }

  /**
   * Holds if the `Phi` instruction for location `useLocation` at the beginning of block `phiBlock` has an operand along
   * the incoming edge from `predBlock`, where that operand's definition is at offset `defOffset` in block `defBlock`.
   */
  pragma[noopt]
  predicate hasPhiOperandDefinition(
    Alias::MemoryLocation defLocation, Alias::MemoryLocation useLocation, OldBlock phiBlock,
    OldBlock predBlock, OldBlock defBlock, int defOffset
  ) {
    exists(int defRank |
      definitionHasPhiNode(useLocation, phiBlock) and
      predBlock = phiBlock.getAFeasiblePredecessor() and
      definitionReachesEndOfBlock(useLocation, defBlock, defRank, predBlock) and
      hasDefinitionAtRank(useLocation, defLocation, defBlock, defRank, defOffset) and
      exists(Alias::getOverlap(defLocation, useLocation))
    )
  }
}

predicate canReuseSsaForMemoryResult(Instruction instruction) {
  exists(OldInstruction oldInstruction |
    oldInstruction = getOldInstruction(instruction) and
    (
      // The previous iteration said it was reusable, so we should mark it as reusable as well.
      Alias::canReuseSsaForOldResult(oldInstruction)
      or
      // The current alias analysis says it is reusable.
      Alias::getResultMemoryLocation(oldInstruction).canReuseSsa()
    )
  )
  or
  exists(Alias::MemoryLocation defLocation |
    // This is a `Phi` for a reusable location, so the result of the `Phi` is reusable as well.
    instruction = phiInstruction(_, defLocation) and
    defLocation.canReuseSsa()
  )
  // We don't support reusing SSA for any location that could create a `Chi` instruction.
}

/**
 * Expose some of the internal predicates to PrintSSA.qll. We do this by publicly importing those modules in the
 * `DebugSsa` module, which is then imported by PrintSSA.
 */
module DebugSsa {
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
      instr = getPhi(phiBlock, location) and
      result =
        "Phi Block(" + phiBlock.getFirstInstruction().getUniqueId() + ")[" + specificity + "]: " +
          location.getUniqueId() and
      if location instanceof Alias::VirtualVariable
      then
        // Sort Phi nodes for virtual variables before Phi nodes for member locations.
        specificity = "g"
      else specificity = "s"
    )
    or
    instr = unreachedInstruction(_) and
    result = "Unreached"
  }

  private OldIR::IRTempVariable getOldTempVariable(IRTempVariable var) {
    result.getEnclosingFunction() = var.getEnclosingFunction() and
    result.getAst() = var.getAst() and
    result.getTag() = var.getTag()
  }

  cached
  predicate instructionHasSortKeys(Instruction instr, int key1, int key2) {
    exists(OldInstruction oldInstr |
      oldInstr = getOldInstruction(instr) and
      oldInstr.hasSortKeys(key1, key2)
    )
    or
    instr instanceof TUnreachedInstruction and
    key1 = maxValue() and
    key2 = maxValue()
  }

  /**
   * Returns the value of the maximum representable integer.
   */
  cached
  int maxValue() { result = 2147483647 }
}

/**
 * Provides the portion of the parameterized IR interface that is used to construct the SSA stages
 * of the IR. The raw stage of the IR does not expose these predicates.
 * These predicates are all just aliases for predicates defined in the `Cached` module. This ensures
 * that all of SSA construction will be evaluated in the same stage.
 */
module Ssa {
  class MemoryLocation = Alias::MemoryLocation;

  predicate hasPhiInstruction = Cached::hasPhiInstructionCached/2;

  predicate hasChiInstruction = Cached::hasChiInstructionCached/1;

  predicate hasChiNodeAfterUninitializedGroup = Cached::hasChiNodeAfterUninitializedGroup/1;

  predicate hasUnreachedInstruction = Cached::hasUnreachedInstructionCached/1;

  class VariableGroup = Alias::VariableGroup;
}
