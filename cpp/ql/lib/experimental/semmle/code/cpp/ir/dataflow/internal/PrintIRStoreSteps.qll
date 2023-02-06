/**
 * Print the dataflow local store steps in IR dumps.
 */

private import cpp
// The `ValueNumbering` library has to be imported right after `cpp` to ensure
// that the cached IR gets the same checksum here as it does in queries that use
// `ValueNumbering` without `DataFlow`.
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.DataFlow
private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil
private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate
private import PrintIRUtilities

/**
 * Property provider for local IR dataflow store steps.
 */
class LocalFlowPropertyProvider extends IRPropertyProvider {
  override string getInstructionProperty(Instruction instruction, string key) {
    exists(DataFlow::Node objectNode, Content content |
      key = "content[" + content.toString() + "]" and
      instruction = objectNode.asInstruction() and
      result =
        strictconcat(string element, DataFlow::Node fieldNode |
          storeStep(fieldNode, content, objectNode) and
          element = nodeId(fieldNode, _, _)
        |
          element, ", "
        )
    )
  }
}
