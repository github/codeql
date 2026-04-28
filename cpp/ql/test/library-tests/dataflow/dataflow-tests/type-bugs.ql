import utils.test.InlineExpectationsTest
import cpp

module AstTest {
  private import semmle.code.cpp.dataflow.internal.DataFlowUtil

  query predicate astTypeBugs(Location location, Node node) {
    exists(int n |
      n = count(node.getType()) and
      location = node.getLocation() and
      n != 1
    )
  }
}

import AstTest

module IrTest {
  private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil
  private import semmle.code.cpp.ir.dataflow.internal.DataFlowNodes

  query predicate irTypeBugs(Location location, Node node) {
    exists(int n |
      // Flow summary nodes don't have a type since we don't necessarily have
      // the source code in the database.
      not node instanceof FlowSummaryNode and
      n = count(node.getType()) and
      location = node.getLocation() and
      n != 1
    )
  }

  query predicate incorrectBaseType(Node n, string msg) {
    exists(PointerType pointerType, Type nodeType, Type baseType |
      not n.isGLValue() and
      pointerType = n.asIndirectExpr(1).getActualType() and
      baseType = pointerType.getBaseType() and
      nodeType = n.getType() and
      nodeType != baseType and
      msg = "Expected 'Node.getType()' to be " + baseType + ", but it was " + nodeType
    )
  }
}

import IrTest
