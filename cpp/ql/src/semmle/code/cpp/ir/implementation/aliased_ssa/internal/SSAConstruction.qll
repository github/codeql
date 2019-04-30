import SSAConstructionInternal
import cpp
private import semmle.code.cpp.ir.implementation.Opcode
private import semmle.code.cpp.ir.internal.OperandTag
private import NewIR

private class OldBlock = Reachability::ReachableBlock;
private class OldInstruction = Reachability::ReachableInstruction;

import Cached
cached private module Cached {

  private IRBlock getNewBlock(OldBlock oldBlock) {
    result.getFirstInstruction() = getNewInstruction(oldBlock.getFirstInstruction())
  }

  cached predicate functionHasIR(Function func) {
    exists(OldIR::IRFunction irFunc |
      irFunc.getFunction() = func
    )
  }

  cached OldInstruction getOldInstruction(Instruction instr) {
    instr = WrappedInstruction(result)
  }

  private Instruction getNewInstruction(OldInstruction instr) {
    getOldInstruction(result) = instr
  }

  /**
   * Gets the chi node corresponding to `instr` if one is present, or the new `Instruction`
   * corresponding to `instr` if there is no `Chi` node.
   */
  private Instruction getNewFinalInstruction(OldInstruction instr) {
    result = Chi(instr)
    or
    not exists(Chi(instr)) and
    result = getNewInstruction(instr)
  }

  private IRVariable getNewIRVariable(OldIR::IRVariable var) {
    // This is just a type cast. Both classes derive from the same newtype.
    result = var
  }

  cached newtype TInstruction =
    WrappedInstruction(OldInstruction oldInstruction) {
      not oldInstruction instanceof OldIR::PhiInstruction
    } or
    Phi(OldBlock block, Alias::VirtualVariable vvar) {
      hasPhiNode(vvar, block)
    } or
    Chi(OldInstruction oldInstruction) {
      not oldInstruction instanceof OldIR::PhiInstruction and
      hasChiNode(_, oldInstruction)
    } or
    Unreached(Function function) {
      exists(OldInstruction oldInstruction |
        function = oldInstruction.getEnclosingFunction() and
        Reachability::isInfeasibleInstructionSuccessor(oldInstruction, _)
      )
    }

  cached predicate hasTempVariable(Function func, Locatable ast, TempVariableTag tag,
      Type type) {
    exists(OldIR::IRTempVariable var |
      var.getEnclosingFunction() = func and
      var.getAST() = ast and
      var.getTag() = tag and
      var.getType() = type
    )
  }

  cached predicate hasModeledMemoryResult(Instruction instruction) {
    exists(Alias::getResultMemoryAccess(getOldInstruction(instruction))) or
    instruction instanceof PhiInstruction or  // Phis always have modeled results
    instruction instanceof ChiInstruction  // Chis always have modeled results
  }

  cached Instruction getInstructionOperandDefinition(Instruction instruction, OperandTag tag) {
    exists(OldInstruction oldInstruction, OldIR::NonPhiOperand oldOperand |
      oldInstruction = getOldInstruction(instruction) and
      oldOperand = oldInstruction.getAnOperand() and
      tag = oldOperand.getOperandTag() and
      if oldOperand instanceof OldIR::MemoryOperand then (
        (
          if exists(Alias::getOperandMemoryAccess(oldOperand)) then (
            exists(OldBlock useBlock, int useRank, Alias::VirtualVariable vvar,
              OldBlock defBlock, int defRank, int defIndex |
              vvar = Alias::getOperandMemoryAccess(oldOperand).getVirtualVariable() and
              hasDefinitionAtRank(vvar, defBlock, defRank, defIndex) and
              hasUseAtRank(vvar, useBlock, useRank, oldInstruction) and
              definitionReachesUse(vvar, defBlock, defRank, useBlock, useRank) and
              if defIndex >= 0 then
                result = getNewFinalInstruction(defBlock.getInstruction(defIndex))
              else
                result = Phi(defBlock, vvar)
            )
          )
          else (
            result = instruction.getEnclosingIRFunction().getUnmodeledDefinitionInstruction()
          )
        ) or
        // Connect any definitions that are not being modeled in SSA to the
        // `UnmodeledUse` instruction.
        exists(OldInstruction oldDefinition |
          instruction instanceof UnmodeledUseInstruction and
          tag instanceof UnmodeledUseOperandTag and
          oldDefinition = oldOperand.getDefinitionInstruction() and
          not exists(Alias::getResultMemoryAccess(oldDefinition)) and
          result = getNewInstruction(oldDefinition)
        )
      )
      else 
        result = getNewInstruction(oldOperand.getDefinitionInstruction())
    ) or
    instruction = Chi(getOldInstruction(result)) and
    tag instanceof ChiPartialOperandTag
    or
    exists(IRFunction f |
      tag instanceof UnmodeledUseOperandTag and
      result = f.getUnmodeledDefinitionInstruction() and
      instruction = f.getUnmodeledUseInstruction()
    )
    or
    tag instanceof ChiTotalOperandTag and
    result = getChiInstructionTotalOperand(instruction)
  }

  cached Type getInstructionOperandType(Instruction instr, TypedOperandTag tag) {
    exists(OldInstruction oldInstruction, OldIR::TypedOperand oldOperand |
      oldInstruction = getOldInstruction(instr) and
      oldOperand = oldInstruction.getAnOperand() and
      tag = oldOperand.getOperandTag() and
      result = oldOperand.getType()
    )
  }

  cached int getInstructionOperandSize(Instruction instr, SideEffectOperandTag tag) {
    exists(OldInstruction oldInstruction, OldIR::SideEffectOperand oldOperand |
      oldInstruction = getOldInstruction(instr) and
      oldOperand = oldInstruction.getAnOperand() and
      tag = oldOperand.getOperandTag() and
      // Only return a result for operands that need an explicit result size.
      oldOperand.getType() instanceof UnknownType and
      result = oldOperand.getSize()
    )
  }

  cached Instruction getPhiInstructionOperandDefinition(PhiInstruction instr,
      IRBlock newPredecessorBlock) {
    exists(Alias::VirtualVariable vvar, OldBlock phiBlock,
        OldBlock defBlock, int defRank, int defIndex, OldBlock predBlock |
      hasPhiNode(vvar, phiBlock) and
      predBlock = phiBlock.getAFeasiblePredecessor() and
      instr = Phi(phiBlock, vvar) and
      newPredecessorBlock = getNewBlock(predBlock) and
      hasDefinitionAtRank(vvar, defBlock, defRank, defIndex) and
      definitionReachesEndOfBlock(vvar, defBlock, defRank, predBlock) and
      if defIndex >= 0 then
        result = getNewFinalInstruction(defBlock.getInstruction(defIndex))
      else
        result = Phi(defBlock, vvar)
    )
  }

  cached Instruction getChiInstructionTotalOperand(ChiInstruction chiInstr) {
    exists(Alias::VirtualVariable vvar, OldInstruction oldInstr, OldBlock defBlock,
        int defRank, int defIndex, OldBlock useBlock, int useRank |
      chiInstr = Chi(oldInstr) and
      vvar = Alias::getResultMemoryAccess(oldInstr).getVirtualVariable() and
      hasDefinitionAtRank(vvar, defBlock, defRank, defIndex) and
      hasUseAtRank(vvar, useBlock, useRank, oldInstr) and
      definitionReachesUse(vvar, defBlock, defRank, useBlock, useRank) and
      if defIndex >= 0 then
        result = getNewFinalInstruction(defBlock.getInstruction(defIndex))
      else
        result = Phi(defBlock, vvar)
    )
  }

  cached Instruction getPhiInstructionBlockStart(PhiInstruction instr) {
    exists(OldBlock oldBlock |
      instr = Phi(oldBlock, _) and
      result = getNewInstruction(oldBlock.getFirstInstruction())
    )
  }

  cached Expr getInstructionConvertedResultExpression(Instruction instruction) {
    result = getOldInstruction(instruction).getConvertedResultExpression()
  }

  cached Expr getInstructionUnconvertedResultExpression(Instruction instruction) {
    result = getOldInstruction(instruction).getUnconvertedResultExpression()
  }

  /*
   * This adds Chi nodes to the instruction successor relation; if an instruction has a Chi node,
   * that node is its successor in the new successor relation, and the Chi node's successors are
   * the new instructions generated from the successors of the old instruction
   */
  cached Instruction getInstructionSuccessor(Instruction instruction, EdgeKind kind) {
    if(hasChiNode(_, getOldInstruction(instruction)))
    then
      result = Chi(getOldInstruction(instruction)) and
      kind instanceof GotoEdge
    else (
      exists(OldInstruction oldInstruction |
        oldInstruction = getOldInstruction(instruction) and
        (
          if Reachability::isInfeasibleInstructionSuccessor(oldInstruction, kind) then (
            result = Unreached(instruction.getEnclosingFunction())
          )
          else (
            result = getNewInstruction(oldInstruction.getSuccessor(kind))
          )
        )
      ) or
      exists(OldInstruction oldInstruction |
        instruction = Chi(oldInstruction) and
        result = getNewInstruction(oldInstruction.getSuccessor(kind))
      )
    )
  }

  cached Instruction getInstructionBackEdgeSuccessor(Instruction instruction, EdgeKind kind) {
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

  cached Locatable getInstructionAST(Instruction instruction) {
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

  cached predicate instructionHasType(Instruction instruction, Type type, boolean isGLValue) {
    exists(OldInstruction oldInstruction |
      instruction = WrappedInstruction(oldInstruction) and
      type = oldInstruction.getResultType() and
      if oldInstruction.isGLValue()
      then isGLValue = true
      else isGLValue = false
    )
    or
    exists(OldInstruction oldInstruction, Alias::VirtualVariable vvar |
      instruction = Chi(oldInstruction) and
      hasChiNode(vvar, oldInstruction) and
      type = vvar.getType() and
      isGLValue = false
    )
    or
    exists(Alias::VirtualVariable vvar |
      instruction = Phi(_, vvar) and
      type = vvar.getType() and
      isGLValue = false
    )
    or
    instruction = Unreached(_) and
    type instanceof VoidType and
    isGLValue = false
  }

  cached Opcode getInstructionOpcode(Instruction instruction) {
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

  cached IRFunction getInstructionEnclosingIRFunction(Instruction instruction) {
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

  cached IRVariable getInstructionVariable(Instruction instruction) {
    result = getNewIRVariable(getOldInstruction(instruction).(OldIR::VariableInstruction).getVariable())
  }

  cached Field getInstructionField(Instruction instruction) {
    result = getOldInstruction(instruction).(OldIR::FieldInstruction).getField()
  }

  cached Function getInstructionFunction(Instruction instruction) {
    result = getOldInstruction(instruction).(OldIR::FunctionInstruction).getFunctionSymbol()
  }

  cached string getInstructionConstantValue(Instruction instruction) {
    result = getOldInstruction(instruction).(OldIR::ConstantValueInstruction).getValue()
  }

  cached StringLiteral getInstructionStringLiteral(Instruction instruction) {
    result = getOldInstruction(instruction).(OldIR::StringConstantInstruction).getValue()
  }

  cached Type getInstructionExceptionType(Instruction instruction) {
    result = getOldInstruction(instruction).(OldIR::CatchByTypeInstruction).getExceptionType()
  }

  cached int getInstructionElementSize(Instruction instruction) {
    result = getOldInstruction(instruction).(OldIR::PointerArithmeticInstruction).getElementSize()
  }

  cached int getInstructionResultSize(Instruction instruction) {
    // Only return a result for instructions that needed an explicit result size.
    instruction.getResultType() instanceof UnknownType and
    result = getOldInstruction(instruction).getResultSize()
  }

  cached predicate getInstructionInheritance(Instruction instruction, Class baseClass,
      Class derivedClass) {
    exists(OldIR::InheritanceConversionInstruction oldInstr |
      oldInstr = getOldInstruction(instruction) and
      baseClass = oldInstr.getBaseClass() and
      derivedClass = oldInstr.getDerivedClass()
    )
  }

  cached Instruction getPrimaryInstructionForSideEffect(Instruction instruction) {
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

  /**
   * Holds if the previous stage had a definition of `vvar` at `instr`, where
   * `instr` is at position `index` in `block`.
   */
  private predicate hasOldDefinition(Alias::VirtualVariable vvar,
      OldBlock block, int index, OldInstruction instr) {
    block.getInstruction(index) = instr and
    Alias::getResultMemoryAccess(instr).getVirtualVariable() = vvar
  }

  private predicate hasDefinition(Alias::VirtualVariable vvar, OldBlock block, int index) {
    (
      hasPhiNode(vvar, block) and
      index = -1
    ) or (
      hasOldDefinition(vvar, block, index, _)
    )
  }

  private predicate defUseRank(Alias::VirtualVariable vvar, OldBlock block, int rankIndex, int index) {
    index = rank[rankIndex](int j | hasDefinition(vvar, block, j) or hasUse(vvar, block, j, _))
  }

  private predicate hasUse(Alias::VirtualVariable vvar, OldBlock block, int index,
      OldInstruction use) {
    exists(Alias::MemoryAccess access |
      (
        access = Alias::getOperandMemoryAccess(use.getAnOperand())
        or
        /*
         * a partial write to a virtual variable is going to generate a use of that variable when
         * Chi nodes are inserted, so we need to mark it as a use in the old IR
         */
        access = Alias::getResultMemoryAccess(use) and
        access.isPartialMemoryAccess()
      ) and
      block.getInstruction(index) = use and
      vvar = access.getVirtualVariable()
    )
  }

  private predicate variableLiveOnEntryToBlock(Alias::VirtualVariable vvar, OldBlock block) {
    exists(int firstAccess |
      hasUse(vvar, block, firstAccess, _) and
      firstAccess = min(int index |
          hasUse(vvar, block, index, _)
          or
          hasOldDefinition(vvar, block, index, _)
        )
    )
    or
    (variableLiveOnExitFromBlock(vvar, block) and not hasOldDefinition(vvar, block, _, _))
  }

  pragma[noinline]
  private predicate variableLiveOnExitFromBlock(Alias::VirtualVariable vvar, OldBlock block) {
    variableLiveOnEntryToBlock(vvar, block.getAFeasibleSuccessor())
  }

  /**
   * Gets the rank index of a hyphothetical use one instruction past the end of
   * the block. This index can be used to determine if a definition reaches the
   * end of the block, even if the definition is the last instruction in the
   * block.
   */
  private int exitRank(Alias::VirtualVariable vvar, OldBlock block) {
    result = max(int rankIndex | defUseRank(vvar, block, rankIndex, _)) + 1
  }

  private predicate hasDefinitionAtRank(Alias::VirtualVariable vvar, OldBlock block, int rankIndex,
      int instructionIndex) {
    hasDefinition(vvar, block, instructionIndex) and
    defUseRank(vvar, block, rankIndex, instructionIndex)
  }

  private predicate hasUseAtRank(Alias::VirtualVariable vvar, OldBlock block, int rankIndex,
      OldInstruction use) {
    exists(int index |
      hasUse(vvar, block, index, use) and
      defUseRank(vvar, block, rankIndex, index)
    )
  }

  /**
    * Holds if the definition of `vvar` at `(block, defRank)` reaches the rank
    * index `reachesRank` in block `block`.
    */
  private predicate definitionReachesRank(Alias::VirtualVariable vvar, OldBlock block, int defRank,
      int reachesRank) {
    hasDefinitionAtRank(vvar, block, defRank, _) and
    reachesRank <= exitRank(vvar, block) and  // Without this, the predicate would be infinite.
    (
      // The def always reaches the next use, even if there is also a def on the
      // use instruction.
      reachesRank = defRank + 1 or
      (
        // If the def reached the previous rank, it also reaches the current rank,
        // unless there was another def at the previous rank.
        definitionReachesRank(vvar, block, defRank, reachesRank - 1) and
        not hasDefinitionAtRank(vvar, block, reachesRank - 1, _)
      )
    )
  }

  /**
   * Holds if the definition of `vvar` at `(defBlock, defRank)` reaches the end of
   * block `block`.
   */
  private predicate definitionReachesEndOfBlock(Alias::VirtualVariable vvar, OldBlock defBlock,
      int defRank, OldBlock block) {
    hasDefinitionAtRank(vvar, defBlock, defRank, _) and
    (
      (
        // If we're looking at the def's own block, just see if it reaches the exit
        // rank of the block.
        block = defBlock and
        variableLiveOnExitFromBlock(vvar, defBlock) and
        definitionReachesRank(vvar, defBlock, defRank, exitRank(vvar, defBlock))
      ) or
      exists(OldBlock idom |
        definitionReachesEndOfBlock(vvar, defBlock, defRank, idom) and
        noDefinitionsSinceIDominator(vvar, idom, block)
      )
    )
  }

  pragma[noinline]
  private predicate noDefinitionsSinceIDominator(Alias::VirtualVariable vvar, OldBlock idom,
      OldBlock block) {
    Dominance::blockImmediatelyDominates(idom, block) and // It is sufficient to traverse the dominator graph, cf. discussion above.
    variableLiveOnExitFromBlock(vvar, block) and
    not hasDefinition(vvar, block, _)
  }

  private predicate definitionReachesUseWithinBlock(Alias::VirtualVariable vvar, OldBlock defBlock,
      int defRank, OldBlock useBlock, int useRank) {
    defBlock = useBlock and
    hasDefinitionAtRank(vvar, defBlock, defRank, _) and
    hasUseAtRank(vvar, useBlock, useRank, _) and
    definitionReachesRank(vvar, defBlock, defRank, useRank)
  }

  private predicate definitionReachesUse(Alias::VirtualVariable vvar, OldBlock defBlock,
      int defRank, OldBlock useBlock, int useRank) {
    hasUseAtRank(vvar, useBlock, useRank, _) and
    (
      definitionReachesUseWithinBlock(vvar, defBlock, defRank, useBlock,
        useRank) or
      (
        definitionReachesEndOfBlock(vvar, defBlock, defRank,
          useBlock.getAFeasiblePredecessor()) and
        not definitionReachesUseWithinBlock(vvar, useBlock, _, useBlock, useRank)
      )
    )
  }

  /**
   * Gets the block where a phi node should be placed for `vvar` if it has a
   * definition in `defBlock`, either because it's defined there in the
   * original source or because it has another phi node there.
   */
  private OldBlock getFrontierBlockIfDefinedIn(Alias::VirtualVariable vvar, OldBlock defBlock) {
    result = Dominance::getDominanceFrontier(defBlock) and
    variableLiveOnEntryToBlock(vvar, result) and
    // Cut down the size of this predicate by requiring that `vvar` _could_ be
    // defined in `defBlock`, either directly or with a phi node.
    (
      hasOldDefinition(vvar, defBlock, _, _)
      or
      defBlock = Dominance::getDominanceFrontier(_)
    )
  }

  private predicate hasPhiNode(Alias::VirtualVariable vvar, OldBlock phiBlock) {
    exists(OldBlock defBlock |
      hasDefinition(vvar, defBlock, _) and
      phiBlock = getFrontierBlockIfDefinedIn(vvar, defBlock)
    )
  }
  
  private predicate hasChiNode(Alias::VirtualVariable vvar, OldInstruction def) {
    exists(Alias::MemoryAccess ma |
      ma = Alias::getResultMemoryAccess(def) and
      ma.isPartialMemoryAccess() and
      ma.getVirtualVariable() = vvar
    )
  }
}

import CachedForDebugging
cached private module CachedForDebugging {
  cached string getTempVariableUniqueId(IRTempVariable var) {
    result = getOldTempVariable(var).getUniqueId()
  }

  cached string getInstructionUniqueId(Instruction instr) {
    exists(OldInstruction oldInstr |
      oldInstr = getOldInstruction(instr) and
      result = "NonSSA: " + oldInstr.getUniqueId()
    ) or
    exists(Alias::VirtualVariable vvar, OldBlock phiBlock |
      instr = Phi(phiBlock, vvar) and
      result = "Phi Block(" + phiBlock.getUniqueId() + "): " + vvar.getUniqueId() 
    ) or
    (
      instr = Unreached(_) and
      result = "Unreached"
    )
  }

  private OldIR::IRTempVariable getOldTempVariable(IRTempVariable var) {
    result.getEnclosingFunction() = var.getEnclosingFunction() and
    result.getAST() = var.getAST() and
    result.getTag() = var.getTag()
  }
}
