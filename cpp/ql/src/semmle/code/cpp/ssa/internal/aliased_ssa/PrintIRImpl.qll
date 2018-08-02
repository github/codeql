private import IRImpl
import cpp

private int getInstructionIndexInBlock(Instruction instr) {
  exists(IRBlock block |
    block = instr.getBlock() and
    (
      exists(int index, int phiCount |
        phiCount = count(block.getAPhiInstruction()) and
        instr = block.getInstruction(index) and
        result = index + phiCount
      ) or
      (
        instr instanceof PhiInstruction and
        instr = rank[result + 1](PhiInstruction phiInstr |
          phiInstr = block.getAPhiInstruction() |
          phiInstr order by phiInstr.getUniqueId()
        )
      )
    )
  )
}

private string getInstructionResultId(Instruction instr) {
  result = getResultPrefix(instr) + getBlockId(instr.getBlock()) + "_" +
    getInstructionIndexInBlock(instr).toString()
}

private string getResultPrefix(Instruction instr) {
  if instr.hasMemoryResult() then
    if instr.isResultModeled() then
      result = "@m"
    else
      result = "@mu"
  else
    result = "@r"
}

/**
 * Gets the identifier of the specified function scope.
 * Currently just returns the signature of the function.
 */
private string getScopeId(Function func) {
  result = func.getFullSignature()
}

/**
 * Gets the unique identifier of the block within its function.
 * Currently returns a string representation of an integer in the range
 * [0..numBlocks - 1].
 */
private string getBlockId(IRBlock block) {
  exists(int rankIndex |
    block = rank[rankIndex + 1](IRBlock funcBlock |
      funcBlock.getFunction() = block.getFunction() |
      funcBlock order by funcBlock.getUniqueId()
    ) and
    result = rankIndex.toString()
  )
}

/**
 * Prints the full signature and qualified name for each scope. This is primarily
 * so that post-processing tools can identify function overloads, which will have
 * different signatures but the same qualified name.
 */
query predicate printIRGraphScopes(string scopeId, string qualifiedName) {
  exists(FunctionIR ir, Function func |
    func = ir.getFunction() and
    scopeId = getScopeId(func) and
    qualifiedName = func.getQualifiedName()
  )
}

query predicate printIRGraphNodes(string scopeId, string blockId, string label, string location) {
  exists(IRBlock block |
    scopeId = getScopeId(block.getFunction()) and
    blockId = getBlockId(block) and
    label = "" and
    location = ""
  )
}

query predicate printIRGraphInstructions(string scopeId, string blockId,
  string id, string label, string location) {
  exists(IRBlock block, Instruction instr |
    instr = block.getAnInstruction() and
    label = instr.toString() and
    location = instr.getLocation().toString() and
    scopeId = getScopeId(block.getFunction()) and
    blockId = getBlockId(block) and
    id = getInstructionIndexInBlock(instr).toString()
  )
}

query predicate printIRGraphEdges(string scopeId,
  string predecessorId, string successorId, string label) {
  exists(IRBlock predecessor, IRBlock successor, EdgeKind kind |
    scopeId = getScopeId(predecessor.getFunction()) and
    predecessor.getSuccessor(kind) = successor and
    predecessorId = getBlockId(predecessor) and
    successorId = getBlockId(successor) and
    label = kind.toString()
  )
}

private string getValueCategoryString(Instruction instr) {
  if instr.isGLValue() then
    result = "glval:"
  else
    result = ""
}

private string getResultTypeString(Instruction instr) {
  exists(Type resultType, string valcat |
    resultType = instr.getResultType() and
    valcat = getValueCategoryString(instr) and
    if resultType instanceof UnknownType and exists(instr.getResultSize()) then
      result = valcat + resultType.toString() + "[" + instr.getResultSize().toString() + "]"
    else
      result = valcat + resultType.toString()
  )
}

query predicate printIRGraphDestinationOperands(string scopeId, string blockId,
  string instructionId, int operandId, string label) {
  exists(IRBlock block, Instruction instr |
    block.getAnInstruction() = instr and
    scopeId = getScopeId(block.getFunction()) and
    blockId = getBlockId(block) and
    instructionId = getInstructionIndexInBlock(instr).toString() and
    not instr.getResultType() instanceof VoidType and
    operandId = 0 and
    label = getInstructionResultId(instr) + 
      "(" + getResultTypeString(instr) + ")"
  )
}

private string getOperandTagLabel(OperandTag tag) {
  (
    tag instanceof PhiOperand and
    result = "from " + getBlockId(tag.(PhiOperand).getPredecessorBlock()) + ": "
  )
  or (
    tag instanceof ThisArgumentOperand and
    result = "this:"
  )
  or (
    not tag instanceof PhiOperand and
    not tag instanceof ThisArgumentOperand and
    result = ""
  )
}

query predicate printIRGraphSourceOperands(string scopeId, string blockId,
  string instructionId, int operandId, string label) {
  exists(IRBlock block, Instruction instr |
    block.getAnInstruction() = instr and
    blockId = getBlockId(block) and
    scopeId = getScopeId(block.getFunction()) and
    instructionId = getInstructionIndexInBlock(instr).toString() and
    if (instr instanceof UnmodeledUseInstruction) then (
      operandId = 0 and
      label = "@mu*"
    )
    else (
      exists(OperandTag tag, Instruction operandInstr |
        operandInstr = instr.getOperand(tag) and
        operandId = tag.getSortOrder() and
        label = getOperandTagLabel(tag) + 
          getInstructionResultId(operandInstr)
      )
    )
  )
}
