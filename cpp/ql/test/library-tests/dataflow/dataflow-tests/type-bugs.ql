import TestUtilities.InlineExpectationsTest
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

  query predicate irTypeBugs(Location location, Node node) {
    exists(int n |
      n = count(node.getType()) and
      location = node.getLocation() and
      n != 1
    )
  }
}

import IrTest
