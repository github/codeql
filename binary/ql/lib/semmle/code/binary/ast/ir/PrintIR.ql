/**
 * @kind graph
 */

import IR

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
        if orderedFunc.getFunction().isProgramEntryPoint()
        then isEntryPoint = 0
        else isEntryPoint = 1
      |
        orderedFunc order by isEntryPoint, orderedFunc.getLabel()
      )
  }

  final override PrintableNode getParent() { none() }

  Function getFunction() { result = func }
}

private predicate isFunctionEntryBlock(BasicBlock bb) { bb.isFunctionEntryBasicBlock() }

private predicate basicBlockSuccessor(BasicBlock bb1, BasicBlock bb2) { bb2 = bb1.getASuccessor() }

private int distanceFromEntry(BasicBlock entry, BasicBlock bb) =
  shortestDistances(isFunctionEntryBlock/1, basicBlockSuccessor/2)(entry, bb, result)

/** Gets a best-effort ordering of basic blocks within a function. */
pragma[nomagic]
private int getBlockOrderingInFunction(Function f, BasicBlock bb) {
  bb =
    rank[result + 1](BasicBlock bb2, string s, int d |
      bb2.getEnclosingFunction() = f and
      (
        d = distanceFromEntry(f.getEntryBlock(), bb2)
        or
        // Unreachable blocks get a large distance so they sort last
        not exists(distanceFromEntry(f.getEntryBlock(), bb2)) and d = 999999
      ) and
      s =
        concat(int i, string instr |
          instr = bb2.getNode(i).asInstruction().toString()
        |
          instr, "" order by i
        )
    |
      bb2 order by d, s
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

  override string getLabel() {
    result = "Block " + this.getOrder()
    or
    not exists(this.getOrder()) and
    result = "Block (unordered)"
  }

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

  override string getLabel() { result = instr.toString() }

  override int getOrder() { instr = instr.getBasicBlock().getNode(result).asInstruction() }

  final override PrintableIRBlock getParent() { result.getBlock() = instr.getBasicBlock() }

  override string getProperty(string key) { result = PrintableNode.super.getProperty(key) }
}

/**
 * Holds if `node` belongs to the output graph, and its property `key` has the given `value`.
 */
query predicate nodes(PrintableNode node, string key, string value) {
  value = node.getProperty(key)
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
    value = ""
  )
}

/**
 * Holds if `parent` is the parent node of `child` in the output graph.
 */
query predicate parents(PrintableNode child, PrintableNode parent) { parent = child.getParent() }
