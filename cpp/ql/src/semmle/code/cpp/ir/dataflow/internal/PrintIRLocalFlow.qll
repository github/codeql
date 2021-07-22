private import cpp
// The `ValueNumbering` library has to be imported right after `cpp` to ensure
// that the cached IR gets the same checksum here as it does in queries that use
// `ValueNumbering` without `DataFlow`.
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.DataFlow
private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil
private import PrintIRUtilities

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
  or
  // Is there partial flow from a source to this node?
  // This property will only be emitted if partial flow is enabled by overriding
  // `DataFlow::Configration::explorationLimit()`.
  key = "pflow" and
  result =
    strictconcat(DataFlow::PartialPathNode sourceNode, DataFlow::PartialPathNode destNode, int dist,
      int order1, int order2 |
      any(DataFlow::Configuration cfg).hasPartialFlow(sourceNode, destNode, dist) and
      destNode.getNode() = node and
      // Only print flow from a source in the same function.
      sourceNode.getNode().getEnclosingCallable() = node.getEnclosingCallable()
    |
      nodeId(sourceNode.getNode(), order1, order2) + "+" + dist.toString(), ", "
      order by
        order1, order2, dist desc
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
