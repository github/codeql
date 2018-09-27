private import IR
import cpp

private string getAdditionalInstructionProperty(Instruction instr, string key) {
  exists(IRPropertyProvider provider |
    result = provider.getInstructionProperty(instr, key)
  )
}

private string getAdditionalBlockProperty(IRBlock block, string key) {
  exists(IRPropertyProvider provider |
    result = provider.getBlockProperty(block, key)
  )
}

private newtype TPrintableIRNode =
  TPrintableFunctionIR(FunctionIR funcIR) or
  TPrintableIRBlock(IRBlock block) or
  TPrintableInstruction(Instruction instr)

/**
 * A node to be emitted in the IR graph.
 */
abstract class PrintableIRNode extends TPrintableIRNode {
  abstract string toString();

  /**
   * Gets the location to be emitted for the node.
   */
  abstract Location getLocation();

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
  string getGraphKind() {
    none()
  }

  /**
   * Holds if this node should always be rendered as text, even in a graphical
   * viewer.
   */
  predicate forceText() {
    none()
  }

  /**
   * Gets the value of the node property with the specified key.
   */
  string getProperty(string key) {
    key = "semmle.label" and result = getLabel() or
    key = "semmle.order" and result = getOrder().toString() or
    key = "semmle.graphKind" and result = getGraphKind() or
    key = "semmle.forceText" and forceText() and result = "true"
  }
}

/**
 * An IR graph node representing a `FunctionIR` object.
 */
class PrintableFunctionIR extends PrintableIRNode, TPrintableFunctionIR {
  FunctionIR funcIR;

  PrintableFunctionIR() {
    this = TPrintableFunctionIR(funcIR)
  }

  override string toString() {
    result = funcIR.toString()
  }

  override Location getLocation() {
    result = funcIR.getLocation()
  }

  override string getLabel() {
    result = funcIR.getFunction().getFullSignature()
  }

  override int getOrder() {
    this = rank[result + 1](PrintableFunctionIR orderedFunc, Location location |
      location = orderedFunc.getFunctionIR().getLocation() |
      orderedFunc order by location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), orderedFunc.getLabel()
    )
  }

  override final PrintableIRNode getParent() {
    none()
  }

  final FunctionIR getFunctionIR() {
    result = funcIR
  }
}

/**
 * An IR graph node representing an `IRBlock` object.
 */
class PrintableIRBlock extends PrintableIRNode, TPrintableIRBlock {
  IRBlock block;

  PrintableIRBlock() {
    this = TPrintableIRBlock(block)
  }

  override string toString() {
    result = getLabel()
  }

  override Location getLocation() {
    result = block.getLocation()
  }

  override string getLabel() {
    result = "Block " + block.getDisplayIndex().toString()
  }

  override int getOrder() {
    result = block.getDisplayIndex()
  }

  override final string getGraphKind() {
    result = "tree"
  }

  override final predicate forceText() {
    any()
  }

  override final PrintableFunctionIR getParent() {
    result.getFunctionIR() = block.getFunctionIR()
  }

  override string getProperty(string key) {
    result = PrintableIRNode.super.getProperty(key) or
    result = getAdditionalBlockProperty(block, key)
  }

  final IRBlock getBlock() {
    result = block
  }
}

/**
 * An IR graph node representing an `Instruction`.
 */
class PrintableInstruction extends PrintableIRNode, TPrintableInstruction {
  Instruction instr;

  PrintableInstruction() {
    this = TPrintableInstruction(instr)
  }

  override string toString() {
    result = instr.toString()
  }

  override Location getLocation() {
    result = instr.getLocation()
  }

  override string getLabel() {
    exists(IRBlock block |
      instr = block.getAnInstruction() and
      exists(string resultString, string operationString, string operandsString,
        int resultWidth, int operationWidth |
        resultString = instr.getResultString() and
        operationString = instr.getOperationString() and
        operandsString = instr.getOperandsString() and
        columnWidths(block, resultWidth, operationWidth) and
        result = resultString + getPaddingString(resultWidth - resultString.length()) +
          " = " + operationString + getPaddingString(operationWidth - operationString.length()) +
          " : " + operandsString
      )
    )
  }

  override int getOrder() {
    result = instr.getDisplayIndexInBlock()
  }

  override final PrintableIRBlock getParent() {
    result.getBlock() = instr.getBlock()
  }

  final Instruction getInstruction() {
    result = instr
  }

  override string getProperty(string key) {
    result = PrintableIRNode.super.getProperty(key) or
    result = getAdditionalInstructionProperty(instr, key)
  }
}

private predicate columnWidths(IRBlock block, int resultWidth, int operationWidth) {
  resultWidth = max(Instruction instr | instr.getBlock() = block | instr.getResultString().length()) and
  operationWidth = max(Instruction instr | instr.getBlock() = block | instr.getOperationString().length())
}

private int maxColumnWidth() {
  result = max(Instruction instr, int width |
    width = instr.getResultString().length() or
    width = instr.getOperationString().length() or
    width = instr.getOperandsString().length()  |
    width)
}

private string getPaddingString(int n) {
  n = 0 and result = "" or
  n > 0 and n <= maxColumnWidth() and result = getPaddingString(n - 1) + " "
}

query predicate nodes(PrintableIRNode node, string key, string value) {
  value = node.getProperty(key)
}

private int getSuccessorIndex(IRBlock pred, IRBlock succ) {
  succ = rank[result + 1](IRBlock aSucc, EdgeKind kind |
    aSucc = pred.getSuccessor(kind) |
    aSucc order by kind.toString()
  )
}

query predicate edges(PrintableIRBlock pred, PrintableIRBlock succ, string key, string value) {
  exists(EdgeKind kind, IRBlock predBlock, IRBlock succBlock |
    predBlock = pred.getBlock() and
    succBlock = succ.getBlock() and
    predBlock.getSuccessor(kind) = succBlock and
    (
      (
        key = "semmle.label" and
        value = kind.toString()
      ) or
      (
        key = "semmle.order" and
        value = getSuccessorIndex(predBlock, succBlock).toString()
      )
    )
  )
}

query predicate parents(PrintableIRNode child, PrintableIRNode parent) {
  parent = child.getParent()
}
