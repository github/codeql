/**
 * @kind problem
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow::DataFlow as IR
import semmle.code.cpp.dataflow.DataFlow::DataFlow as AST
import Nodes

class ASTPartialDefNode extends ASTNode {
  ASTPartialDefNode() { exists(n.asPartialDefinition()) }

  override string toString() { result = n.asPartialDefinition().toString() }
}

class IRPartialDefNode extends IRNode {
  IRPartialDefNode() { exists(n.asPartialDefinition()) }

  override string toString() { result = n.asPartialDefinition().toString() }
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
