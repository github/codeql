private import semmle.code.cpp.ir.dataflow.DataFlow as IR
private import semmle.code.cpp.dataflow.DataFlow as AST
private import cpp

private newtype TNode =
  TAstNode(AST::DataFlow::Node n) or
  TIRNode(IR::DataFlow::Node n)

class Node extends TNode {
  string toString() { none() }

  IR::DataFlow::Node asIR() { none() }

  AST::DataFlow::Node asAst() { none() }

  Location getLocation() { none() }
}

class AstNode extends Node, TAstNode {
  AST::DataFlow::Node n;

  AstNode() { this = TAstNode(n) }

  override string toString() { result = n.toString() }

  override AST::DataFlow::Node asAst() { result = n }

  override Location getLocation() { result = n.getLocation() }
}

class IRNode extends Node, TIRNode {
  IR::DataFlow::Node n;

  IRNode() { this = TIRNode(n) }

  override string toString() { result = n.toString() }

  override IR::DataFlow::Node asIR() { result = n }

  override Location getLocation() { result = n.getLocation() }
}
