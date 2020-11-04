/**
 * Outputs a representation of the IR as a control flow graph.
 *
 * This file contains the actual implementation of `PrintIR.ql`. For test cases and very small
 * databases, `PrintIR.ql` can be run directly to dump the IR for the entire database. For most
 * uses, however, it is better to write a query that imports `PrintIR.qll`, extends
 * `PrintIRConfiguration`, and overrides `shouldPrintFunction()` to select a subset of functions to
 * dump.
 */

private import internal.IRInternal
private import IR
private import internal.PrintIRImports as Imports
import Imports::IRConfiguration

private newtype TPrintIRConfiguration = MkPrintIRConfiguration()

/**
 * The query can extend this class to control which functions are printed.
 */
class PrintIRConfiguration extends TPrintIRConfiguration {
  /** Gets a textual representation of this configuration. */
  string toString() { result = "PrintIRConfiguration" }

  /**
   * Holds if the IR for `func` should be printed. By default, holds for all
   * functions.
   */
  predicate shouldPrintFunction(Language::Function func) { any() }
}

/**
 * Override of `IRConfiguration` to only evaluate debug strings for the functions that are to be dumped.
 */
private class FilteredIRConfiguration extends IRConfiguration {
  override predicate shouldEvaluateDebugStringsForFunction(Language::Function func) {
    shouldPrintFunction(func)
  }
}

private predicate shouldPrintFunction(Language::Function func) {
  exists(PrintIRConfiguration config | config.shouldPrintFunction(func))
}

private string getAdditionalInstructionProperty(Instruction instr, string key) {
  exists(IRPropertyProvider provider | result = provider.getInstructionProperty(instr, key))
}

private string getAdditionalBlockProperty(IRBlock block, string key) {
  exists(IRPropertyProvider provider | result = provider.getBlockProperty(block, key))
}

/**
 * Gets the properties of an operand from any active property providers.
 */
private string getAdditionalOperandProperty(Operand operand, string key) {
  exists(IRPropertyProvider provider | result = provider.getOperandProperty(operand, key))
}

/**
 * Gets a string listing the properties of the operand and their corresponding values. If the
 * operand has no properties, this predicate has no result.
 */
private string getOperandPropertyListString(Operand operand) {
  result =
    strictconcat(string key, string value |
      value = getAdditionalOperandProperty(operand, key)
    |
      key + ":" + value, ", "
    )
}

/**
 * Gets a string listing the properties of the operand and their corresponding values. The list is
 * surrounded by curly braces. If the operand has no properties, this predicate returns an empty
 * string.
 */
private string getOperandPropertyString(Operand operand) {
  result = "{" + getOperandPropertyListString(operand) + "}"
  or
  not exists(getOperandPropertyListString(operand)) and result = ""
}

private newtype TPrintableIRNode =
  TPrintableIRFunction(IRFunction irFunc) { shouldPrintFunction(irFunc.getFunction()) } or
  TPrintableIRBlock(IRBlock block) { shouldPrintFunction(block.getEnclosingFunction()) } or
  TPrintableInstruction(Instruction instr) { shouldPrintFunction(instr.getEnclosingFunction()) }

/**
 * A node to be emitted in the IR graph.
 */
abstract private class PrintableIRNode extends TPrintableIRNode {
  abstract string toString();

  /**
   * Gets the location to be emitted for the node.
   */
  abstract Language::Location getLocation();

  /**
   * Gets the label to be emitted for the node.
   */
  abstract string getLabel();

  /**
   * Gets the order in which the node appears in its parent node.
   */
  abstract int getOrder();

  /**
   * Gets the parent of this node.
   */
  abstract PrintableIRNode getParent();

  /**
   * Gets the kind of graph represented by this node ("graph" or "tree").
   */
  string getGraphKind() { none() }

  /**
   * Holds if this node should always be rendered as text, even in a graphical
   * viewer.
   */
  predicate forceText() { none() }

  /**
   * Gets the value of the node property with the specified key.
   */
  string getProperty(string key) {
    key = "semmle.label" and result = getLabel()
    or
    key = "semmle.order" and result = getOrder().toString()
    or
    key = "semmle.graphKind" and result = getGraphKind()
    or
    key = "semmle.forceText" and forceText() and result = "true"
  }
}

/**
 * An IR graph node representing a `IRFunction` object.
 */
private class PrintableIRFunction extends PrintableIRNode, TPrintableIRFunction {
  IRFunction irFunc;

  PrintableIRFunction() { this = TPrintableIRFunction(irFunc) }

  override string toString() { result = irFunc.toString() }

  override Language::Location getLocation() { result = irFunc.getLocation() }

  override string getLabel() { result = Language::getIdentityString(irFunc.getFunction()) }

  override int getOrder() {
    this =
      rank[result + 1](PrintableIRFunction orderedFunc, Language::Location location |
        location = orderedFunc.getIRFunction().getLocation()
      |
        orderedFunc
        order by
          location.getFile().getAbsolutePath(), location.getStartLine(), location.getStartColumn(),
          orderedFunc.getLabel()
      )
  }

  final override PrintableIRNode getParent() { none() }

  final IRFunction getIRFunction() { result = irFunc }
}

/**
 * An IR graph node representing an `IRBlock` object.
 */
private class PrintableIRBlock extends PrintableIRNode, TPrintableIRBlock {
  IRBlock block;

  PrintableIRBlock() { this = TPrintableIRBlock(block) }

  override string toString() { result = getLabel() }

  override Language::Location getLocation() { result = block.getLocation() }

  override string getLabel() { result = "Block " + block.getDisplayIndex().toString() }

  override int getOrder() { result = block.getDisplayIndex() }

  final override string getGraphKind() { result = "tree" }

  final override predicate forceText() { any() }

  final override PrintableIRFunction getParent() {
    result.getIRFunction() = block.getEnclosingIRFunction()
  }

  override string getProperty(string key) {
    result = PrintableIRNode.super.getProperty(key) or
    result = getAdditionalBlockProperty(block, key)
  }

  final IRBlock getBlock() { result = block }
}

/**
 * An IR graph node representing an `Instruction`.
 */
private class PrintableInstruction extends PrintableIRNode, TPrintableInstruction {
  Instruction instr;

  PrintableInstruction() { this = TPrintableInstruction(instr) }

  override string toString() { result = instr.toString() }

  override Language::Location getLocation() { result = instr.getLocation() }

  override string getLabel() {
    exists(IRBlock block |
      instr = block.getAnInstruction() and
      exists(
        string resultString, string operationString, string operandsString, int resultWidth,
        int operationWidth
      |
        resultString = instr.getResultString() and
        operationString = instr.getOperationString() and
        operandsString = getOperandsString() and
        columnWidths(block, resultWidth, operationWidth) and
        result =
          resultString + getPaddingString(resultWidth - resultString.length()) + " = " +
            operationString + getPaddingString(operationWidth - operationString.length()) + " : " +
            operandsString
      )
    )
  }

  override int getOrder() { result = instr.getDisplayIndexInBlock() }

  final override PrintableIRBlock getParent() { result.getBlock() = instr.getBlock() }

  final Instruction getInstruction() { result = instr }

  override string getProperty(string key) {
    result = PrintableIRNode.super.getProperty(key) or
    result = getAdditionalInstructionProperty(instr, key)
  }

  /**
   * Gets the string representation of the operand list. This is the same as
   * `Instruction::getOperandsString()`, except that each operand is annotated with any properties
   * provided by active `IRPropertyProvider` instances.
   */
  private string getOperandsString() {
    result =
      concat(Operand operand |
        operand = instr.getAnOperand()
      |
        operand.getDumpString() + getOperandPropertyString(operand), ", "
        order by
          operand.getDumpSortOrder()
      )
  }
}

private predicate columnWidths(IRBlock block, int resultWidth, int operationWidth) {
  resultWidth = max(Instruction instr | instr.getBlock() = block | instr.getResultString().length()) and
  operationWidth =
    max(Instruction instr | instr.getBlock() = block | instr.getOperationString().length())
}

private int maxColumnWidth() {
  result =
    max(Instruction instr, int width |
      width = instr.getResultString().length() or
      width = instr.getOperationString().length() or
      width = instr.getOperandsString().length()
    |
      width
    )
}

private string getPaddingString(int n) {
  n = 0 and result = ""
  or
  n > 0 and n <= maxColumnWidth() and result = getPaddingString(n - 1) + " "
}

/**
 * Holds if `node` belongs to the output graph, and its property `key` has the given `value`.
 */
query predicate nodes(PrintableIRNode node, string key, string value) {
  value = node.getProperty(key)
}

private int getSuccessorIndex(IRBlock pred, IRBlock succ) {
  succ =
    rank[result + 1](IRBlock aSucc, EdgeKind kind |
      aSucc = pred.getSuccessor(kind)
    |
      aSucc order by kind.toString()
    )
}

/**
 * Holds if the output graph contains an edge from `pred` to `succ`, and that edge's property `key`
 * has the given `value`.
 */
query predicate edges(PrintableIRBlock pred, PrintableIRBlock succ, string key, string value) {
  exists(EdgeKind kind, IRBlock predBlock, IRBlock succBlock |
    predBlock = pred.getBlock() and
    succBlock = succ.getBlock() and
    predBlock.getSuccessor(kind) = succBlock and
    (
      (
        key = "semmle.label" and
        if predBlock.getBackEdgeSuccessor(kind) = succBlock
        then value = kind.toString() + " (back edge)"
        else value = kind.toString()
      )
      or
      key = "semmle.order" and
      value = getSuccessorIndex(predBlock, succBlock).toString()
    )
  )
}

/**
 * Holds if `parent` is the parent node of `child` in the output graph.
 */
query predicate parents(PrintableIRNode child, PrintableIRNode parent) {
  parent = child.getParent()
}
