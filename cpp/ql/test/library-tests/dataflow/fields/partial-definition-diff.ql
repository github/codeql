/**
 * @kind problem
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow::DataFlow as IR
import semmle.code.cpp.dataflow.DataFlow::DataFlow as AST
import Nodes

class AstPartialDefNode extends AstNode {
  AstPartialDefNode() { exists(n.asPartialDefinition()) }

  override string toString() { result = n.asPartialDefinition().toString() }
}

class IRPartialDefNode extends IRNode {
  IRPartialDefNode() { exists(n.asPartialDefinition()) }

  override string toString() { result = n.asPartialDefinition().toString() }
}

from Node node, string msg
where
  exists(IR::Node irNode, Expr partial |
    node.asIR() = irNode and
    partial = irNode.asPartialDefinition() and
    not exists(AST::Node otherNode | otherNode.asPartialDefinition() = partial)
  ) and
  msg = "IR only"
  or
  exists(AST::Node astNode, Expr partial |
    node.asAst() = astNode and
    partial = astNode.asPartialDefinition() and
    not exists(IR::Node otherNode | otherNode.asPartialDefinition() = partial)
  ) and
  msg = "AST only"
select node, msg
