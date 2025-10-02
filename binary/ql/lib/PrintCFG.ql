/**
 * @kind graph
 */

import binary
private import semmle.code.binary.controlflow.BasicBlock

newtype TPrintableNode =
  TPrintableFunction(Function f) or
  TPrintableBasicBlock(BasicBlock bb) or
  TPrintableInstruction(Instruction i)

/**
 * A node to be emitted in the graph.
 */
abstract private class PrintableNode extends TPrintableNode {
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
  abstract PrintableNode getParent();

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
    key = "semmle.label" and result = this.getLabel()
    or
    key = "semmle.order" and result = this.getOrder().toString()
    or
    key = "semmle.graphKind" and result = this.getGraphKind()
    or
    key = "semmle.forceText" and this.forceText() and result = "true"
  }
}

/**
 * An IR graph node representing a `IRFunction` object.
 */
private class PrintableFunction extends PrintableNode, TPrintableFunction {
  Function func;

  PrintableFunction() { this = TPrintableFunction(func) }

  override string toString() { result = func.toString() }

  override Location getLocation() { result = func.getLocation() }

  override string getLabel() { result = func.toString() }

  override int getOrder() {
    this =
      rank[result + 1](PrintableFunction orderedFunc, int isEntryPoint |
        if orderedFunc.getFunction() instanceof ProgramEntryFunction
        then isEntryPoint = 0
        else isEntryPoint = 1
      |
        orderedFunc order by isEntryPoint, orderedFunc.getLabel()
      )
  }

  final override PrintableNode getParent() { none() }

  Function getFunction() { result = func }
}

pragma[nomagic]
private int getBlockOrderingInFunction(Function f, BasicBlock bb) {
  bb =
    rank[result + 1](BasicBlock bb2, QlBuiltins::BigInt index, int isEntryPoint |
      bb2.getEnclosingFunction() = f and
      index = bb2.getFirstInstruction().getIndex() and
      if bb2 instanceof FunctionEntryBasicBlock then isEntryPoint = 0 else isEntryPoint = 1
    |
      bb2 order by isEntryPoint, index
    )
}

int getBlockIndex(BasicBlock bb) {
  exists(Function f |
    f = bb.getEnclosingFunction() and
    result = getBlockOrderingInFunction(f, bb)
  )
}

/**
 * An IR graph node representing an `BasicBlock` object.
 */
private class PrintableIRBlock extends PrintableNode, TPrintableBasicBlock {
  BasicBlock block;

  PrintableIRBlock() { this = TPrintableBasicBlock(block) }

  override string toString() { result = this.getLabel() }

  override Location getLocation() { result = block.getLocation() }

  override string getLabel() { result = "Block " + this.getOrder() }

  override int getOrder() { result = getBlockIndex(block) }

  final override string getGraphKind() { result = "tree" }

  final override predicate forceText() { any() }

  final override PrintableFunction getParent() {
    result.getFunction() = block.getEnclosingFunction()
  }

  override string getProperty(string key) { result = PrintableNode.super.getProperty(key) }

  final BasicBlock getBlock() { result = block }
}

/**
 * An IR graph node representing an `Instruction`.
 */
private class PrintableInstruction extends PrintableNode, TPrintableInstruction {
  Instruction instr;

  PrintableInstruction() { this = TPrintableInstruction(instr) }

  override string toString() { result = instr.toString() }

  override Location getLocation() { result = instr.getLocation() }

  override string getLabel() {
    exists(string extra |
      if exists(getAdditionalDumpText(instr))
      then extra = " ; " + getAdditionalDumpText(instr)
      else extra = ""
    |
      result = instr.toString() + extra
    )
  }

  override int getOrder() { instr = instr.getBasicBlock().getInstruction(result) }

  final override PrintableIRBlock getParent() {
    result.getBlock() = instr.getBasicBlock()
  }

  override string getProperty(string key) { result = PrintableNode.super.getProperty(key) }
}

/**
 * Holds if `node` belongs to the output graph, and its property `key` has the given `value`.
 */
query predicate nodes(PrintableNode node, string key, string value) {
  value = node.getProperty(key)
}

private int getSuccessorIndex(BasicBlock pred, BasicBlock succ) {
  succ =
    rank[result + 1](BasicBlock aSucc |
      aSucc = pred.getASuccessor()
    |
      aSucc order by aSucc.getFirstInstruction().getIndex()
    )
}

/**
 * Holds if the output graph contains an edge from `pred` to `succ`, and that edge's property `key`
 * has the given `value`.
 */
query predicate edges(PrintableIRBlock pred, PrintableIRBlock succ, string key, string value) {
  exists(BasicBlock predBlock, BasicBlock succBlock |
    predBlock = pred.getBlock() and
    succBlock = succ.getBlock() and
    predBlock.getASuccessor() = succBlock
  |
    key = "semmle.label" and
    if predBlock.getBackEdgeSuccessor() = succBlock then value = "(back edge)" else value = ""
    or
    key = "semmle.order" and
    value = getSuccessorIndex(predBlock, succBlock).toString()
  )
}

/**
 * Holds if `parent` is the parent node of `child` in the output graph.
 */
query predicate parents(PrintableNode child, PrintableNode parent) { parent = child.getParent() }
