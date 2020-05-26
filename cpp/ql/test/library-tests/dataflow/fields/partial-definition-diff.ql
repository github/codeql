/**
 * @kind problem
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow::DataFlow as IR
import semmle.code.cpp.dataflow.DataFlow::DataFlow as AST

newtype TNode =
  TASTNode(AST::Node n) or
  TIRNode(IR::Node n)

class Node extends TNode {
  string toString() { none() }

  IR::Node asIR() { none() }

  AST::Node asAST() { none() }
}

class ASTNode extends Node, TASTNode {
  AST::Node n;

  ASTNode() { this = TASTNode(n) }

  override string toString() { result = n.asPartialDefinition().toString() }

  override AST::Node asAST() { result = n }
}

class IRNode extends Node, TIRNode {
  IR::Node n;

  IRNode() { this = TIRNode(n) }

  override string toString() { result = n.asPartialDefinition().toString() }

  override IR::Node asIR() { result = n }
}

from Node node, AST::Node astNode, IR::Node irNode, string msg
where
  node.asIR() = irNode and
  exists(irNode.asPartialDefinition()) and
  not exists(AST::Node otherNode | otherNode.asPartialDefinition() = irNode.asPartialDefinition()) and
  msg = "IR only"
  or
  node.asAST() = astNode and
  exists(astNode.asPartialDefinition()) and
  not exists(IR::Node otherNode | otherNode.asPartialDefinition() = astNode.asPartialDefinition()) and
  msg = "AST only"
select node, msg
