import SSAConstructionInternal
import cpp
private import semmle.code.cpp.ir.implementation.Opcode
import NewIR
import IRBlockConstruction as BlockConstruction

import Cached
cached private module Cached {

  private OldIR::OperandTag getOldOperandTag(OperandTag newTag) {
    newTag instanceof LoadStoreAddressOperand and result instanceof OldIR::LoadStoreAddressOperand or
    newTag instanceof CopySourceOperand and result instanceof OldIR::CopySourceOperand or
    newTag instanceof UnaryOperand and result instanceof OldIR::UnaryOperand or
    newTag instanceof LeftOperand and result instanceof OldIR::LeftOperand or
    newTag instanceof RightOperand and result instanceof OldIR::RightOperand or
    newTag instanceof ReturnValueOperand and result instanceof OldIR::ReturnValueOperand or
    newTag instanceof ExceptionOperand and result instanceof OldIR::ExceptionOperand or
    newTag instanceof ConditionOperand and result instanceof OldIR::ConditionOperand or
    newTag instanceof UnmodeledUseOperand and result instanceof OldIR::UnmodeledUseOperand or
    newTag instanceof CallTargetOperand and result instanceof OldIR::CallTargetOperand or
    newTag instanceof ThisArgumentOperand and result instanceof OldIR::ThisArgumentOperand or
    exists(PositionalArgumentOperand newArg |
      newArg = newTag and
      result.(OldIR::PositionalArgumentOperand).getArgIndex() = newArg.getArgIndex()
    )
  }

  private IRBlock getNewBlock(OldIR::IRBlock oldBlock) {
    result.getFirstInstruction() = getNewInstruction(oldBlock.getFirstInstruction())
  }

  cached newtype TInstructionTag =
    WrappedInstructionTag(OldIR::Instruction oldInstruction) {
      not oldInstruction instanceof OldIR::PhiInstruction
    } or
    PhiTag(Alias::VirtualVariable vvar, OldIR::IRBlock block) {
      hasPhiNode(vvar, block)
    }

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

  cached int getMaxCallArgIndex() {
    result = max(int argIndex |
      exists(OldIR::PositionalArgumentOperand oldOperand |
        argIndex = oldOperand.getArgIndex()
      )
    )
  }

  cached OldIR::Instruction getOldInstruction(Instruction instr) {
    instr.getTag() = WrappedInstructionTag(result)
  }

  private Instruction getNewInstruction(OldIR::Instruction instr) {
    getOldInstruction(result) = instr
  }

  private PhiInstruction getPhiInstruction(Function func, OldIR::IRBlock oldBlock,
    Alias::VirtualVariable vvar) {
    result.getFunction() = func and
    result.getAST() = oldBlock.getFirstInstruction().getAST() and
    result.getTag() = PhiTag(vvar, oldBlock)
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
    exists(OldIR::Instruction instr |
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
    exists(OldIR::IRBlock block, Alias::VirtualVariable vvar |
      hasPhiNode(vvar, block) and
      block.getFunction() = func and
      opcode instanceof Opcode::Phi and
      ast = block.getFirstInstruction().getAST() and
      tag = PhiTag(vvar, block) and
      resultType = vvar.getType() and
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
    instruction instanceof PhiInstruction  // Phis always have modeled results
  }

  cached Instruction getInstructionOperand(Instruction instruction, OperandTag tag) {
    exists(OldIR::Instruction oldUse, OldIR::OperandTag oldTag |
      oldUse = getOldInstruction(instruction) and
      oldTag = getOldOperandTag(tag) and
      if oldUse.isMemoryOperand(oldTag) then (
        (
          if exists(Alias::getOperandMemoryAccess(oldUse, oldTag)) then (
            exists(OldIR::IRBlock useBlock, int useRank, Alias::VirtualVariable vvar,
              OldIR::IRBlock defBlock, int defRank, int defIndex |
              vvar = Alias::getOperandMemoryAccess(oldUse, oldTag).getVirtualVariable() and
              hasDefinitionAtRank(vvar, defBlock, defRank, defIndex) and
              hasUseAtRank(vvar, useBlock, useRank, oldUse) and
              definitionReachesUse(vvar, defBlock, defRank, useBlock, useRank) and
              if defIndex >= 0 then
                result = getNewInstruction(defBlock.getInstruction(defIndex))
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
        exists(OldIR::Instruction oldDefinition |
          instruction instanceof UnmodeledUseInstruction and
          tag instanceof UnmodeledUseOperand and
          oldDefinition = oldUse.getOperand(oldTag) and
          not exists(Alias::getResultMemoryAccess(oldDefinition)) and
          result = getNewInstruction(oldDefinition)
        )
      )
      else 
        result = getNewInstruction(oldUse.getOperand(oldTag))
    ) or
    result = getPhiInstructionOperand(instruction.(PhiInstruction), tag.(PhiOperand))
  }

  cached Instruction getPhiInstructionOperand(PhiInstruction instr, PhiOperand tag) {
    exists(Alias::VirtualVariable vvar, OldIR::IRBlock phiBlock,
      OldIR::IRBlock defBlock, int defRank, int defIndex, OldIR::IRBlock predBlock |
      hasPhiNode(vvar, phiBlock) and
      predBlock = phiBlock.getAPredecessor() and
      instr.getTag() = PhiTag(vvar, phiBlock) and
      tag.getPredecessorBlock() = getNewBlock(predBlock) and
      hasDefinitionAtRank(vvar, defBlock, defRank, defIndex) and
      definitionReachesEndOfBlock(vvar, defBlock, defRank, predBlock) and
      if defIndex >= 0 then
        result = getNewInstruction(defBlock.getInstruction(defIndex))
      else
        result = getPhiInstruction(instr.getFunction(), defBlock, vvar)
    )
  }

  cached Instruction getPhiInstructionBlockStart(PhiInstruction instr) {
    exists(OldIR::IRBlock oldBlock |
      instr.getTag() = PhiTag(_, oldBlock) and
      result = getNewInstruction(oldBlock.getFirstInstruction())
    )
  }

  cached Expr getInstructionResultExpression(Instruction instruction) {
    result = getOldInstruction(instruction).getResultExpression()
  }

  cached Instruction getInstructionSuccessor(Instruction instruction, EdgeKind kind) {
    result = getNewInstruction(getOldInstruction(instruction).getSuccessor(kind))
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

  private predicate ssa_variableUpdate(Alias::VirtualVariable vvar,
    OldIR::Instruction instr, OldIR::IRBlock block, int index) {
    block.getInstruction(index) = instr and
    Alias::getResultMemoryAccess(instr).getVirtualVariable() = vvar
  }

  private predicate hasDefinition(Alias::VirtualVariable vvar, OldIR::IRBlock block, int index) {
    (
      hasPhiNode(vvar, block) and
      index = -1
    ) or
    exists(Alias::MemoryAccess access, OldIR::Instruction def |
      access = Alias::getResultMemoryAccess(def) and
      block.getInstruction(index) = def and
      vvar = access.getVirtualVariable()
    )
  }

  private predicate defUseRank(Alias::VirtualVariable vvar, OldIR::IRBlock block, int rankIndex, int index) {
    index = rank[rankIndex](int j | hasDefinition(vvar, block, j) or hasUse(vvar, _, block, j))
  }

  private predicate hasUse(Alias::VirtualVariable vvar, 
    OldIR::Instruction use, OldIR::IRBlock block, int index) {
    exists(Alias::MemoryAccess access |
      access = Alias::getOperandMemoryAccess(use, _) and
      block.getInstruction(index) = use and
      vvar = access.getVirtualVariable()
    )
  }

  private predicate variableLiveOnEntryToBlock(Alias::VirtualVariable vvar, OldIR::IRBlock block) {
    exists (int index | hasUse(vvar, _, block, index) |
      not exists (int j | ssa_variableUpdate(vvar, _, block, j) | j < index)
    ) or
    (variableLiveOnExitFromBlock(vvar, block) and not ssa_variableUpdate(vvar, _, block, _))
  }

  pragma[noinline]
  private predicate variableLiveOnExitFromBlock(Alias::VirtualVariable vvar, OldIR::IRBlock block) {
    variableLiveOnEntryToBlock(vvar, block.getASuccessor())
  }

  /**
   * Gets the rank index of a hyphothetical use one instruction past the end of
   * the block. This index can be used to determine if a definition reaches the
   * end of the block, even if the definition is the last instruction in the
   * block.
   */
  private int exitRank(Alias::VirtualVariable vvar, OldIR::IRBlock block) {
    result = max(int rankIndex | defUseRank(vvar, block, rankIndex, _)) + 1
  }

  private predicate hasDefinitionAtRank(Alias::VirtualVariable vvar,
    OldIR::IRBlock block, int rankIndex, int instructionIndex) {
    hasDefinition(vvar, block, instructionIndex) and
    defUseRank(vvar, block, rankIndex, instructionIndex)
  }

  private predicate hasUseAtRank(Alias::VirtualVariable vvar, OldIR::IRBlock block,
    int rankIndex, OldIR::Instruction use) {
    exists(int index |
      hasUse(vvar, use, block, index) and
      defUseRank(vvar, block, rankIndex, index)
    )
  }

  /**
    * Holds if the definition of `vvar` at `(block, defRank)` reaches the rank
    * index `reachesRank` in block `block`.
    */
  private predicate definitionReachesRank(Alias::VirtualVariable vvar,
    OldIR::IRBlock block, int defRank, int reachesRank) {
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
  private predicate definitionReachesEndOfBlock(Alias::VirtualVariable vvar,
    OldIR::IRBlock defBlock, int defRank, OldIR::IRBlock block) {
    hasDefinitionAtRank(vvar, defBlock, defRank, _) and
    (
      (
        // If we're looking at the def's own block, just see if it reaches the exit
        // rank of the block.
        block = defBlock and
        variableLiveOnExitFromBlock(vvar, defBlock) and
        definitionReachesRank(vvar, defBlock, defRank, exitRank(vvar, defBlock))
      ) or
      exists(OldIR::IRBlock idom |
        definitionReachesEndOfBlock(vvar, defBlock, defRank, idom) and
        noDefinitionsSinceIDominator(vvar, idom, block)
      )
    )
  }

  pragma[noinline]
  private predicate noDefinitionsSinceIDominator(Alias::VirtualVariable vvar,
    OldIR::IRBlock idom, OldIR::IRBlock block) {
    idom.immediatelyDominates(block) and // It is sufficient to traverse the dominator graph, cf. discussion above.
    variableLiveOnExitFromBlock(vvar, block) and
    not hasDefinition(vvar, block, _)
  }

  private predicate definitionReachesUseWithinBlock(
    Alias::VirtualVariable vvar, OldIR::IRBlock defBlock, int defRank, 
    OldIR::IRBlock useBlock, int useRank) {
    defBlock = useBlock and
    hasDefinitionAtRank(vvar, defBlock, defRank, _) and
    hasUseAtRank(vvar, useBlock, useRank, _) and
    definitionReachesRank(vvar, defBlock, defRank, useRank)
  }

  private predicate definitionReachesUse(Alias::VirtualVariable vvar,
    OldIR::IRBlock defBlock, int defRank, OldIR::IRBlock useBlock, int useRank) {
    hasUseAtRank(vvar, useBlock, useRank, _) and
    (
      definitionReachesUseWithinBlock(vvar, defBlock, defRank, useBlock,
        useRank) or
      (
        definitionReachesEndOfBlock(vvar, defBlock, defRank,
          useBlock.getAPredecessor()) and
        not definitionReachesUseWithinBlock(vvar, useBlock, _, useBlock, useRank)
      )
    )
  }

  private predicate hasFrontierPhiNode(Alias::VirtualVariable vvar, 
    OldIR::IRBlock phiBlock) {
    exists(OldIR::IRBlock defBlock |
      phiBlock = defBlock.dominanceFrontier() and
      hasDefinition(vvar, defBlock, _) and
      /* We can also eliminate those nodes where the variable is not live on any incoming edge */
      variableLiveOnEntryToBlock(vvar, phiBlock)
    )
  }

  private predicate hasPhiNode(Alias::VirtualVariable vvar,
    OldIR::IRBlock phiBlock) {
    hasFrontierPhiNode(vvar, phiBlock)
    //or ssa_sanitized_custom_phi_node(vvar, block)
  }
}

import CachedForDebugging
cached private module CachedForDebugging {
  cached string getTempVariableUniqueId(IRTempVariable var) {
    result = getOldTempVariable(var).getUniqueId()
  }

  cached string getInstructionUniqueId(Instruction instr) {
    exists(OldIR::Instruction oldInstr |
      oldInstr = getOldInstruction(instr) and
      result = "NonSSA: " + oldInstr.getUniqueId()
    ) or
    exists(Alias::VirtualVariable vvar, OldIR::IRBlock phiBlock |
      instr.getTag() = PhiTag(vvar, phiBlock) and
      result = "Phi Block(" + phiBlock.getUniqueId() + "): " + vvar.getUniqueId() 
    )
  }

  private OldIR::IRTempVariable getOldTempVariable(IRTempVariable var) {
    result.getFunction() = var.getFunction() and
    result.getAST() = var.getAST() and
    result.getTag() = var.getTag()
  }
}
