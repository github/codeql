private import SSAConstructionInternal
private import OldIR
private import Alias
private import SSAConstruction
private import DebugSSA

bindingset[offset]
private string getKeySuffixForOffset(int offset) {
  offset >= 0 and
  if offset % 2 = 0 then result = "" else result = "_Chi"
}

bindingset[offset]
private int getIndexForOffset(int offset) { offset >= 0 and result = offset / 2 }

/**
 * Property provide that dumps the memory access of each result. Useful for debugging SSA
 * construction.
 */
class PropertyProvider extends IRPropertyProvider {
  override string getInstructionProperty(Instruction instruction, string key) {
    key = "ResultMemoryLocation" and
    result =
      strictconcat(MemoryLocation loc |
        loc = getResultMemoryLocation(instruction)
      |
        loc.toString(), ","
      )
    or
    key = "ResultVirtualVariable" and
    result =
      strictconcat(MemoryLocation loc |
        loc = getResultMemoryLocation(instruction)
      |
        loc.getVirtualVariable().toString(), ","
      )
    or
    key = "OperandMemoryLocation" and
    result =
      strictconcat(MemoryLocation loc |
        loc = getOperandMemoryLocation(instruction.getAnOperand())
      |
        loc.toString(), ","
      )
    or
    key = "OperandVirtualVariable" and
    result =
      strictconcat(MemoryLocation loc |
        loc = getOperandMemoryLocation(instruction.getAnOperand())
      |
        loc.getVirtualVariable().toString(), ","
      )
    or
    exists(MemoryLocation useLocation, IRBlock defBlock, int defRank, int defOffset |
      hasDefinitionAtRank(useLocation, _, defBlock, defRank, defOffset) and
      defBlock.getInstruction(getIndexForOffset(defOffset)) = instruction and
      key = "DefinitionRank" + getKeySuffixForOffset(defOffset) + "[" + useLocation.toString() + "]" and
      result = defRank.toString()
    )
    or
    exists(MemoryLocation useLocation, IRBlock useBlock, int useRank |
      hasUseAtRank(useLocation, useBlock, useRank, instruction) and
      key = "UseRank[" + useLocation.toString() + "]" and
      result = useRank.toString()
    )
    or
    exists(MemoryLocation useLocation, IRBlock defBlock, int defRank, int defOffset |
      hasDefinitionAtRank(useLocation, _, defBlock, defRank, defOffset) and
      defBlock.getInstruction(getIndexForOffset(defOffset)) = instruction and
      key =
        "DefinitionReachesUse" + getKeySuffixForOffset(defOffset) + "[" + useLocation.toString() +
          "]" and
      result =
        strictconcat(IRBlock useBlock, int useRank, int useIndex |
          exists(Instruction useInstruction |
            hasUseAtRank(useLocation, useBlock, useRank, useInstruction) and
            useBlock.getInstruction(useIndex) = useInstruction and
            definitionReachesUse(useLocation, defBlock, defRank, useBlock, useRank)
          )
        |
          useBlock.getDisplayIndex().toString() + "_" + useIndex, ", "
          order by
            useBlock.getDisplayIndex(), useIndex
        )
    )
  }

  override string getBlockProperty(IRBlock block, string key) {
    exists(MemoryLocation useLocation, int defRank, int defIndex |
      hasDefinitionAtRank(useLocation, _, block, defRank, defIndex) and
      defIndex = -1 and
      key = "DefinitionRank(Phi)[" + useLocation.toString() + "]" and
      result = defRank.toString()
    )
    or
    exists(MemoryLocation useLocation, MemoryLocation defLocation, int defRank, int defIndex |
      hasDefinitionAtRank(useLocation, defLocation, block, defRank, defIndex) and
      defIndex = -1 and
      key = "DefinitionReachesUse(Phi)[" + useLocation.toString() + "]" and
      result =
        strictconcat(IRBlock useBlock, int useRank, int useIndex |
          exists(Instruction useInstruction |
            hasUseAtRank(useLocation, useBlock, useRank, useInstruction) and
            useBlock.getInstruction(useIndex) = useInstruction and
            definitionReachesUse(useLocation, block, defRank, useBlock, useRank) and
            exists(getOverlap(defLocation, useLocation))
          )
        |
          useBlock.getDisplayIndex().toString() + "_" + useIndex, ", "
          order by
            useBlock.getDisplayIndex(), useIndex
        )
    )
    or
    exists(
      MemoryLocation useLocation, IRBlock predBlock, IRBlock defBlock, int defIndex, Overlap overlap
    |
      hasPhiOperandDefinition(_, useLocation, block, predBlock, defBlock, defIndex) and
      key =
        "PhiUse[" + useLocation.toString() + " from " + predBlock.getDisplayIndex().toString() + "]" and
      result =
        defBlock.getDisplayIndex().toString() + "_" + defIndex + " (" + overlap.toString() + ")"
    )
    or
    key = "LiveOnEntry" and
    result =
      strictconcat(MemoryLocation useLocation |
        locationLiveOnEntryToBlock(useLocation, block)
      |
        useLocation.toString(), ", " order by useLocation.toString()
      )
    or
    key = "LiveOnExit" and
    result =
      strictconcat(MemoryLocation useLocation |
        locationLiveOnExitFromBlock(useLocation, block)
      |
        useLocation.toString(), ", " order by useLocation.toString()
      )
    or
    key = "DefsLiveOnEntry" and
    result =
      strictconcat(MemoryLocation defLocation |
        definitionLiveOnEntryToBlock(defLocation, block)
      |
        defLocation.toString(), ", " order by defLocation.toString()
      )
    or
    key = "DefsLiveOnExit" and
    result =
      strictconcat(MemoryLocation defLocation |
        definitionLiveOnExitFromBlock(defLocation, block)
      |
        defLocation.toString(), ", " order by defLocation.toString()
      )
  }
}
