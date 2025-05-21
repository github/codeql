private import semmle.code.cpp.ir.IR
private import cpp

private newtype TNode = TInstructionNode(Instruction i)

abstract private class NodeImpl extends TNode {
  /** Gets the `Instruction` associated with this node, if any. */
  Instruction asInstruction() { result = this.(InstructionNode).getInstruction() }

  /** Gets the `Expr` associated with this node, if any. */
  Expr asExpr() { result = this.(ExprNode).getExpr() }

  /** Gets the `Parameter` associated with this node, if any. */
  Parameter asParameter() { result = this.(ParameterNode).getParameter() }

  /** Gets the location of this node. */
  Location getLocation() { none() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  final predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets a textual representation of this node. */
  abstract string toString();

  /** Gets the enclosing callable of this node. */
  abstract Callable getEnclosingFunction();
}

final class Node = NodeImpl;

private class InstructionNode extends NodeImpl {
  Instruction instr;

  InstructionNode() { this = TInstructionNode(instr) }

  /** Gets the `Instruction` associated with this node. */
  Instruction getInstruction() { result = instr }

  final override Location getLocation() { result = instr.getLocation() }

  final override string toString() { result = instr.getAst().toString() }

  final override Callable getEnclosingFunction() { result = instr.getEnclosingFunction() }
}

private class ExprNode extends InstructionNode {
  Expr e;

  ExprNode() { e = this.getInstruction().getConvertedResultExpression() }

  /** Gets the `Expr` associated with this node. */
  Expr getExpr() { result = e }
}

private class ParameterNode extends InstructionNode {
  override InitializeParameterInstruction instr;
  Parameter p;

  ParameterNode() { p = instr.getParameter() }

  /** Gets the `Parameter` associated with this node. */
  Parameter getParameter() { result = p }
}

class CallNode extends InstructionNode {
  override CallInstruction instr;
}

class Callable = Function;
