private import cpp
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil
private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate
private import SsaInternals as Ssa
private import PrintIRUtilities

/**
 * Gets the local dataflow from other nodes in the same function to this node.
 */
private string getFromFlow(Node node2, int order1, int order2) {
  exists(Node node1 |
    simpleLocalFlowStep(node1, node2, _) and
    result = nodeId(node1, order1, order2)
  )
}

/**
 * Gets the local dataflow from this node to other nodes in the same function.
 */
private string getToFlow(Node node1, int order1, int order2) {
  exists(Node node2 |
    simpleLocalFlowStep(node1, node2, _) and
    result = nodeId(node2, order1, order2)
  )
}

/**
 * Gets the properties of the dataflow node `node`.
 */
private string getNodeProperty(Node node, string key) {
  // List dataflow into and out of this node. Flow into this node is printed as `src->@`, and flow
  // out of this node is printed as `@->dest`.
  key = "flow" and
  result =
    strictconcat(string flow, boolean to, int order1, int order2 |
      flow = getFromFlow(node, order1, order2) + "->" + stars(node) + "@" and to = false
      or
      flow = stars(node) + "@->" + getToFlow(node, order1, order2) and to = true
    |
      flow, ", " order by to, order1, order2, flow
    )
}

/**
 * Property provider for local IR dataflow.
 */
class LocalFlowPropertyProvider extends IRPropertyProvider {
  override string getOperandProperty(Operand operand, string key) {
    exists(Node node |
      operand = [node.asOperand(), node.(RawIndirectOperand).getOperand()] and
      result = getNodeProperty(node, key)
    )
  }

  override string getInstructionProperty(Instruction instruction, string key) {
    exists(Node node |
      instruction = [node.asInstruction(), node.(RawIndirectInstruction).getInstruction()]
    |
      result = getNodeProperty(node, key)
    )
  }
}
