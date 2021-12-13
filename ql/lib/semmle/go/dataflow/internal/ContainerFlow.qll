/** Contains predicates for dealing with container flow. */

import go
private import DataFlowNodes
private import DataFlowPrivate
private import DataFlowUtil
private import semmle.go.dataflow.ExternalFlow

/**
 * Holds if the step from `node1` to `node2` stores a value in an array, a
 * slice, a collection or a map. Thus, `node2` references an object with a
 * content `c` that contains the value of `node1`. This covers array
 * assignments and initializers as well as implicit array creations for
 * varargs.
 */
predicate containerStoreStep(Node node1, Node node2, Content c) {
  c instanceof ArrayContent and
  (
    (
      node2.getType() instanceof ArrayType or
      node2.getType() instanceof SliceType
    ) and
    exists(Write w | w.writesElement(node2, _, node1))
  )
  or
  c instanceof CollectionContent and
  exists(SendStmt send |
    send.getChannel() = node2.(ExprNode).asExpr() and send.getValue() = node1.(ExprNode).asExpr()
  )
  or
  c instanceof MapKeyContent and
  node2.getType() instanceof MapType and
  exists(Write w | w.writesElement(node2, node1, _))
  or
  c instanceof MapValueContent and
  node2.getType() instanceof MapType and
  exists(Write w | w.writesElement(node2, _, node1))
}

/**
 * Holds if the step from `node1` to `node2` reads a value from an array, a
 * slice, a collection or a map. Thus, `node1` references an object with a
 * content `c` whose value ends up in `node2`. This covers ordinary array reads
 * as well as array iteration through enhanced `for` statements.
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
    node1 = recv.getOperand() and
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
