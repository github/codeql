/**
 * Print the dataflow local store steps in IR dumps.
 */

private import cpp
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil
private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate
private import PrintIRUtilities

/** A property provider for local IR dataflow store steps. */
class FieldFlowPropertyProvider extends IRPropertyProvider {
  override string getOperandProperty(Operand operand, string key) {
    exists(PostFieldUpdateNode pfun, Content content |
      key = "store " + content.toString() and
      pfun.getPreUpdateNode().(IndirectOperand).hasOperandAndIndirectionIndex(operand, _) and
      result =
        strictconcat(string element, Node node |
          storeStep(node, content, pfun) and
          element = nodeId(node, _, _)
        |
          element, ", "
        )
    )
    or
    exists(Node node2, Content content |
      key = "read " + content.toString() and
      node2.(IndirectOperand).hasOperandAndIndirectionIndex(operand, _) and
      result =
        strictconcat(string element, Node node1 |
          readStep(node1, content, node2) and
          element = nodeId(node1, _, _)
        |
          element, ", "
        )
    )
  }
}
