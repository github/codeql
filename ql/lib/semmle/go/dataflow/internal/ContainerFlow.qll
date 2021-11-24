/** Contains predicates for dealing with container flow. */

import go
private import DataFlowNodes
private import DataFlowPrivate
private import DataFlowUtil
private import semmle.go.dataflow.ExternalFlow

private class BuiltinModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;append;;;ArrayElement of Argument[0];ArrayElement of ReturnValue;value",
        ";;false;append;;;Argument[1];ArrayElement of ReturnValue;value"
      ]
  }
}

/**
 * Holds if the step from `node1` to `node2` stores a value in a slice or array.
 * Thus, `node2` references an object with a content `c` that contains the value
 * of `node1`. This covers array assignments and initializers as well as
 * implicit array creations for varargs.
 */
predicate containerStoreStep(Node node1, Node node2, Content c) {
  c instanceof ArrayContent and
  (
    // currently there is no database information about variadic functions
    (
      node2.getType() instanceof ArrayType or
      node2.getType() instanceof SliceType
    ) and
    exists(Write w | w.writesElement(node2, _, node1))
  )
  or
  c instanceof CollectionContent and
  exists(BinaryOperationNode send | send.hasOperands(node1, node2) | send.getOperator() = "<-")
  or
  c instanceof MapKeyContent and
  node1.getType() instanceof MapType and
  exists(Write w | w.writesElement(node1, node2, _))
  or
  c instanceof MapValueContent and
  node1.getType() instanceof MapType and
  exists(Write w | w.writesElement(node1, _, node2))
}

/**
 * Holds if the step from `node1` to `node2` reads a value from a slice or array.
 * Thus, `node1` references an object with a content `c` whose value ends up in
 * `node2`. This covers ordinary array reads as well as array iteration through
 * enhanced `for` statements.
 */
predicate containerReadStep(Node node1, Node node2, Content c) {
  c instanceof ArrayContent and
  (
    node2.(Read).readsElement(node1, _) and
    (
      node1.getType() instanceof ArrayType or
      node1.getType() instanceof SliceType
    )
    or
    node2.(RangeElementNode).getBase() = node1
  )
  or
  c instanceof CollectionContent and
  exists(UnaryOperationNode recv | recv = node2 |
    node2 = recv.getOperand() and
    recv.getOperator() = "<-"
  )
  or
  c instanceof MapKeyContent and
  node1.getType() instanceof MapType and
  node2.(RangeIndexNode).getBase() = node1
  or
  c instanceof MapValueContent and
  node1.getType() instanceof MapType and
  node2.(Read).readsElement(node1, _)
}
