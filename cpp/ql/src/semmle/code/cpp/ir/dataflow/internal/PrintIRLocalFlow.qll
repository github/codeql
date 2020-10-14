private import cpp
// The `ValueNumbering` library has to be imported right after `cpp` to ensure
// that the cached IR gets the same checksum here as it does in queries that use
// `ValueNumbering` without `DataFlow`.
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.DataFlow
private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil

/**
 * Gets a short ID for an IR dataflow node.
 * - For `Instruction`s, this is just the result ID of the instruction (e.g. `m128`).
 * - For `Operand`s, this is the label of the operand, prefixed with the result ID of the
 *   instruction and a dot (e.g. `m128.left`).
 * - For `Variable`s, this is the qualified name of the variable.
 */
private string nodeId(DataFlow::Node node, int order1, int order2) {
  exists(Instruction instruction | instruction = node.asInstruction() |
    result = instruction.getResultId() and
    order1 = instruction.getBlock().getDisplayIndex() and
    order2 = instruction.getDisplayIndexInBlock()
  )
  or
  exists(Operand operand, Instruction instruction |
    operand = node.asOperand() and
    instruction = operand.getUse()
  |
    result = instruction.getResultId() + "." + operand.getDumpId() and
    order1 = instruction.getBlock().getDisplayIndex() and
    order2 = instruction.getDisplayIndexInBlock()
  )
  or
  result = "var(" + node.asVariable().getQualifiedName() + ")" and
  order1 = 1000000 and
  order2 = 0
}

/**
 * Gets the local dataflow from other nodes in the same function to this node.
 */
private string getFromFlow(DataFlow::Node useNode, int order1, int order2) {
  exists(DataFlow::Node defNode, string prefix |
    (
      simpleLocalFlowStep(defNode, useNode) and prefix = ""
      or
      any(DataFlow::Configuration cfg).isAdditionalFlowStep(defNode, useNode) and
      defNode.getEnclosingCallable() = useNode.getEnclosingCallable() and
      prefix = "+"
    ) and
    if defNode.asInstruction() = useNode.asOperand().getAnyDef()
    then
      // Shorthand for flow from the def of this operand.
      result = prefix + "def" and
      order1 = -1 and
      order2 = 0
    else
      if defNode.asOperand().getUse() = useNode.asInstruction()
      then
        // Shorthand for flow from an operand of this instruction
        result = prefix + defNode.asOperand().getDumpId() and
        order1 = -1 and
        order2 = defNode.asOperand().getDumpSortOrder()
      else result = prefix + nodeId(defNode, order1, order2)
  )
}

/**
 * Gets the local dataflow from this node to other nodes in the same function.
 */
private string getToFlow(DataFlow::Node defNode, int order1, int order2) {
  exists(DataFlow::Node useNode, string prefix |
    (
      simpleLocalFlowStep(defNode, useNode) and prefix = ""
      or
      any(DataFlow::Configuration cfg).isAdditionalFlowStep(defNode, useNode) and
      defNode.getEnclosingCallable() = useNode.getEnclosingCallable() and
      prefix = "+"
    ) and
    if useNode.asInstruction() = defNode.asOperand().getUse()
    then
      // Shorthand for flow to this operand's instruction.
      result = prefix + "result" and
      order1 = -1 and
      order2 = 0
    else result = prefix + nodeId(useNode, order1, order2)
  )
}

/**
 * Gets the properties of the dataflow node `node`.
 */
private string getNodeProperty(DataFlow::Node node, string key) {
  // List dataflow into and out of this node. Flow into this node is printed as `src->@`, and flow
  // out of this node is printed as `@->dest`.
  key = "flow" and
  result =
    strictconcat(string flow, boolean to, int order1, int order2 |
      flow = getFromFlow(node, order1, order2) + "->@" and to = false
      or
      flow = "@->" + getToFlow(node, order1, order2) and to = true
    |
      flow, ", " order by to, order1, order2, flow
    )
  or
  // Is this node a dataflow sink?
  key = "sink" and
  any(DataFlow::Configuration cfg).isSink(node) and
  result = "true"
  or
  // Is this node a dataflow source?
  key = "source" and
  any(DataFlow::Configuration cfg).isSource(node) and
  result = "true"
  or
  // Is this node a dataflow barrier, and if so, what kind?
  key = "barrier" and
  result =
    strictconcat(string kind |
      any(DataFlow::Configuration cfg).isBarrier(node) and kind = "full"
      or
      any(DataFlow::Configuration cfg).isBarrierIn(node) and kind = "in"
      or
      any(DataFlow::Configuration cfg).isBarrierOut(node) and kind = "out"
      or
      exists(DataFlow::BarrierGuard guard |
        any(DataFlow::Configuration cfg).isBarrierGuard(guard) and
        node = guard.getAGuardedNode() and
        kind = "guard(" + guard.getResultId() + ")"
      )
    |
      kind, ", "
    )
}

/**
 * Property provider for local IR dataflow.
 */
class LocalFlowPropertyProvider extends IRPropertyProvider {
  override string getOperandProperty(Operand operand, string key) {
    exists(DataFlow::Node node |
      operand = node.asOperand() and
      result = getNodeProperty(node, key)
    )
  }

  override string getInstructionProperty(Instruction instruction, string key) {
    exists(DataFlow::Node node |
      instruction = node.asInstruction() and
      result = getNodeProperty(node, key)
    )
  }
}
