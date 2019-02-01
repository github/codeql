import SSAConstructionInternal
import cpp
private import semmle.code.cpp.ir.implementation.Opcode
private import semmle.code.cpp.ir.internal.OperandTag
private import NewIR

private class OldBlock = Reachability::ReachableBlock;
private class OldInstruction = Reachability::ReachableInstruction;

InstructionTag getInstructionTag(Instruction instruction) {
  instruction = MkInstruction(_, _, _, result, _, _)
}

Locatable getInstructionAST(Instruction instruction) {
  instruction = MkInstruction(_, _, result, _, _, _)
}

predicate instructionHasType(Instruction instruction, Type type, boolean isGLValue) {
  instruction = MkInstruction(_, _, _, _, type, isGLValue)
}

Opcode getInstructionOpcode(Instruction instruction) {
  instruction = MkInstruction(_, result, _, _, _, _)
}

FunctionIR getInstructionEnclosingFunctionIR(Instruction instruction) {
  instruction = MkInstruction(result, _, _, _, _, _)
}

import Cached
cached private module Cached {

  private IRBlock getNewBlock(OldBlock oldBlock) {
    result.getFirstInstruction() = getNewInstruction(oldBlock.getFirstInstruction())
  }

  cached newtype TInstructionTag =
    WrappedInstructionTag(OldInstruction oldInstruction) {
      not oldInstruction instanceof OldIR::PhiInstruction
    } or
    PhiTag(Alias::VirtualVariable vvar, OldBlock block) {
      hasPhiNode(vvar, block)
    } or
    ChiTag(OldInstruction oldInstruction) {
      not oldInstruction instanceof OldIR::PhiInstruction and
      hasChiNode(_, oldInstruction)
    } or
    UnreachedTag()

  cached class InstructionTagType extends TInstructionTag {
    cached final string toString() {
      result = "Tag"
    }
  }

  cached predicate functionHasIR(Function func) {
    exists(OldIR::FunctionIR funcIR |
      funcIR.getFunction() = func
    )
  }

  cached OldInstruction getOldInstruction(Instruction instr) {
    instr.getTag() = WrappedInstructionTag(result)
  }

  private Instruction getNewInstruction(OldInstruction instr) {
    getOldInstruction(result) = instr
  }

  /**
   * Gets the chi node corresponding to `instr` if one is present, or the new `Instruction`
   * corresponding to `instr` if there is no `Chi` node.
   */
  private Instruction getNewFinalInstruction(OldInstruction instr) {
    result = getChiInstruction(instr)
    or
    not exists(getChiInstruction(instr)) and
    result = getNewInstruction(instr)
  }

  private PhiInstruction getPhiInstruction(Function func, OldBlock oldBlock,
    Alias::VirtualVariable vvar) {
    result.getFunction() = func and
    result.getAST() = oldBlock.getFirstInstruction().getAST() and
    result.getTag() = PhiTag(vvar, oldBlock)
  }
  
  private ChiInstruction getChiInstruction (OldInstruction instr) {
    hasChiNode(_, instr) and
    result.getTag() = ChiTag(instr)
  }

  private IRVariable getNewIRVariable(OldIR::IRVariable var) {
    result.getFunction() = var.getFunction() and
    (
      exists(OldIR::IRUserVariable userVar, IRUserVariable newUserVar |
        userVar = var and
        newUserVar.getVariable() = userVar.getVariable() and
        result = newUserVar
      ) or
      exists(OldIR::IRTempVariable tempVar, IRTempVariable newTempVar |
        tempVar = var and
        newTempVar.getAST() = tempVar.getAST() and
        newTempVar.getTag() = tempVar.getTag() and
        result = newTempVar
      )
    )
  }

  cached newtype TInstruction =
    MkInstruction(FunctionIR funcIR, Opcode opcode, Locatable ast,
        InstructionTag tag, Type resultType, boolean isGLValue) {
      hasInstruction(funcIR.getFunction(), opcode, ast, tag,
        resultType, isGLValue)
    }

  private predicate hasInstruction(Function func, Opcode opcode, Locatable ast,
      InstructionTag tag, Type resultType, boolean isGLValue) {
    exists(OldInstruction instr |
      instr.getFunction() = func and
      instr.getOpcode() = opcode and
      instr.getAST() = ast and
      WrappedInstructionTag(instr) = tag and
      instr.getResultType() = resultType and
      if instr.isGLValue() then
        isGLValue = true
      else
        isGLValue = false
    ) or
    exists(OldBlock block, Alias::VirtualVariable vvar |
      hasPhiNode(vvar, block) and
      block.getFunction() = func and
      opcode instanceof Opcode::Phi and
      ast = block.getFirstInstruction().getAST() and
      tag = PhiTag(vvar, block) and
      resultType = vvar.getType() and
      isGLValue = false
    ) or
    exists(OldInstruction instr, Alias::VirtualVariable vvar |
      hasChiNode(vvar, instr) and
      instr.getFunction() = func and
      opcode instanceof Opcode::Chi and
      ast = instr.getAST() and
      tag = ChiTag(instr) and
      resultType = vvar.getType() and
      isGLValue = false
    ) or
    exists(OldInstruction oldInstruction |
      func = oldInstruction.getFunction() and
      Reachability::isInfeasibleInstructionSuccessor(oldInstruction, _) and
      tag = UnreachedTag() and
      opcode instanceof Opcode::Unreached and
      ast = func and
      resultType instanceof VoidType and
      isGLValue = false
    )
  }

  cached predicate hasTempVariable(Function func, Locatable ast, TempVariableTag tag,
      Type type) {
    exists(OldIR::IRTempVariable var |
      var.getFunction() = func and
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
                result = getPhiInstruction(instruction.getFunction(), defBlock, vvar)
            )
          )
          else (
            result = instruction.getFunctionIR().getUnmodeledDefinitionInstruction()
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
    instruction.getTag() = ChiTag(getOldInstruction(result)) and
    tag instanceof ChiPartialOperandTag
    or
    exists(FunctionIR f |
      tag instanceof UnmodeledUseOperandTag and
      result = f.getUnmodeledDefinitionInstruction() and
      instruction = f.getUnmodeledUseInstruction()
    )
    or
    tag instanceof ChiTotalOperandTag and
    result = getChiInstructionTotalOperand(instruction)
  }

  cached Instruction getPhiInstructionOperandDefinition(PhiInstruction instr,
      IRBlock newPredecessorBlock) {
    exists(Alias::VirtualVariable vvar, OldBlock phiBlock,
        OldBlock defBlock, int defRank, int defIndex, OldBlock predBlock |
      hasPhiNode(vvar, phiBlock) and
      predBlock = phiBlock.getAFeasiblePredecessor() and
      instr.getTag() = PhiTag(vvar, phiBlock) and
      newPredecessorBlock = getNewBlock(predBlock) and
      hasDefinitionAtRank(vvar, defBlock, defRank, defIndex) and
      definitionReachesEndOfBlock(vvar, defBlock, defRank, predBlock) and
      if defIndex >= 0 then
        result = getNewFinalInstruction(defBlock.getInstruction(defIndex))
      else
        result = getPhiInstruction(instr.getFunction(), defBlock, vvar)
    )
  }

  cached Instruction getChiInstructionTotalOperand(ChiInstruction chiInstr) {
    exists(Alias::VirtualVariable vvar, OldInstruction oldInstr, OldBlock defBlock,
        int defRank, int defIndex, OldBlock useBlock, int useRank |
      ChiTag(oldInstr) = chiInstr.getTag() and
      vvar = Alias::getResultMemoryAccess(oldInstr).getVirtualVariable() and
      hasDefinitionAtRank(vvar, defBlock, defRank, defIndex) and
      hasUseAtRank(vvar, useBlock, useRank, oldInstr) and
      definitionReachesUse(vvar, defBlock, defRank, useBlock, useRank) and
      if defIndex >= 0 then
        result = getNewFinalInstruction(defBlock.getInstruction(defIndex))
      else
        result = getPhiInstruction(chiInstr.getFunction(), defBlock, vvar)
    )
  }

  cached Instruction getPhiInstructionBlockStart(PhiInstruction instr) {
    exists(OldBlock oldBlock |
      instr.getTag() = PhiTag(_, oldBlock) and
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
      result = getChiInstruction(getOldInstruction(instruction)) and
      kind instanceof GotoEdge
    else (
      exists(OldInstruction oldInstruction |
        oldInstruction = getOldInstruction(instruction) and
        (
          if Reachability::isInfeasibleInstructionSuccessor(oldInstruction, kind) then (
            result.getTag() = UnreachedTag() and
            result.getFunction() = instruction.getFunction()
          )
          else (
            result = getNewInstruction(oldInstruction.getSuccessor(kind))
          )
        )
      ) or
      exists(OldInstruction oldInstruction |
        instruction = getChiInstruction(oldInstruction) and
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
      then instruction = getChiInstruction(oldInstruction)
      else instruction = getNewInstruction(oldInstruction)
    )
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
      instruction.getTag() = ChiTag(oldInstruction) and
      result = getNewInstruction(oldInstruction)
    )
  }

  private predicate ssa_variableUpdate(Alias::VirtualVariable vvar,
      OldInstruction instr, OldBlock block, int index) {
    block.getInstruction(index) = instr and
    Alias::getResultMemoryAccess(instr).getVirtualVariable() = vvar
  }

  private predicate hasDefinition(Alias::VirtualVariable vvar, OldBlock block, int index) {
    (
      hasPhiNode(vvar, block) and
      index = -1
    ) or
    exists(Alias::MemoryAccess access, OldInstruction def |
      access = Alias::getResultMemoryAccess(def) and
      block.getInstruction(index) = def and
      vvar = access.getVirtualVariable()
    )
  }

  private predicate defUseRank(Alias::VirtualVariable vvar, OldBlock block, int rankIndex, int index) {
    index = rank[rankIndex](int j | hasDefinition(vvar, block, j) or hasUse(vvar, _, block, j))
  }

  private predicate hasUse(Alias::VirtualVariable vvar, OldInstruction use, OldBlock block,
      int index) {
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
    exists (int index | hasUse(vvar, _, block, index) |
      not exists (int j | ssa_variableUpdate(vvar, _, block, j) | j < index)
    ) or
    (variableLiveOnExitFromBlock(vvar, block) and not ssa_variableUpdate(vvar, _, block, _))
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
      hasUse(vvar, use, block, index) and
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

  private predicate hasFrontierPhiNode(Alias::VirtualVariable vvar, OldBlock phiBlock) {
    exists(OldBlock defBlock |
      phiBlock = Dominance::getDominanceFrontier(defBlock) and
      hasDefinition(vvar, defBlock, _) and
      /* We can also eliminate those nodes where the variable is not live on any incoming edge */
      variableLiveOnEntryToBlock(vvar, phiBlock)
    )
  }

  private predicate hasPhiNode(Alias::VirtualVariable vvar, OldBlock phiBlock) {
    hasFrontierPhiNode(vvar, phiBlock)
    //or ssa_sanitized_custom_phi_node(vvar, block)
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
      instr.getTag() = PhiTag(vvar, phiBlock) and
      result = "Phi Block(" + phiBlock.getUniqueId() + "): " + vvar.getUniqueId() 
    ) or
    (
      instr.getTag() = UnreachedTag() and
      result = "Unreached"
    )
  }

  private OldIR::IRTempVariable getOldTempVariable(IRTempVariable var) {
    result.getFunction() = var.getFunction() and
    result.getAST() = var.getAST() and
    result.getTag() = var.getTag()
  }
}
