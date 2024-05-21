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
 * assignments and initializers as well as implicit slice creations for
 * varargs.
 */
predicate containerStoreStep(Node node1, Node node2, Content c) {
  exists(Type t | t = node2.getType().getUnderlyingType() |
    c instanceof ArrayContent and
    (
      (
        t instanceof ArrayType or
        t instanceof SliceType
      ) and
      (
        exists(Write w | w.writesElement(node2.(PostUpdateNode).getPreUpdateNode(), _, node1))
        or
        node1 = node2.(ImplicitVarargsSlice).getCallNode().getAnImplicitVarargsArgument()
        or
        // To model data flow from array elements of the base of a `SliceNode` to
        // the `SliceNode` itself, we consider there to be a read step with array
        // content from the base to the corresponding `SliceElementNode` and then
        // a store step with array content from the `SliceelementNode` to the
        // `SliceNode` itself.
        node2 = node1.(SliceElementNode).getSliceNode()
      )
    )
    or
    c instanceof CollectionContent and
    exists(SendStmt send |
      send.getChannel() = node2.(ExprNode).asExpr() and send.getValue() = node1.(ExprNode).asExpr()
    )
    or
    c instanceof MapKeyContent and
    t instanceof MapType and
    exists(Write w | w.writesElement(node2.(PostUpdateNode).getPreUpdateNode(), node1, _))
    or
    c instanceof MapValueContent and
    t instanceof MapType and
    exists(Write w | w.writesElement(node2.(PostUpdateNode).getPreUpdateNode(), _, node1))
  )
}

/**
 * Holds if the step from `node1` to `node2` reads a value from an array, a
 * slice, a collection or a map. Thus, `node1` references an object with a
 * content `c` whose value ends up in `node2`. This covers ordinary array reads
 * as well as array iteration through enhanced `for` statements.
 */
predicate containerReadStep(Node node1, Node node2, Content c) {
  exists(Type t | t = node1.getType().getUnderlyingType() |
    c instanceof ArrayContent and
    (
      t instanceof ArrayType or
      t instanceof SliceType
    ) and
    (
      node2.(Read).readsElement(node1, _)
      or
      node2.(RangeElementNode).getBase() = node1
      or
      // To model data flow from array elements of the base of a `SliceNode` to
      // the `SliceNode` itself, we consider there to be a read step with array
      // content from the base to the corresponding `SliceElementNode` and then
      // a store step with array content from the `SliceelementNode` to the
      // `SliceNode` itself.
      node2.(SliceElementNode).getSliceNode().getBase() = node1
    )
    or
    c instanceof CollectionContent and
    exists(UnaryOperationNode recv | recv = node2 |
      node1 = recv.getOperand() and
      recv.getOperator() = "<-"
    )
    or
    c instanceof MapKeyContent and
    t instanceof MapType and
    node2.(RangeIndexNode).getBase() = node1
    or
    c instanceof MapValueContent and
    t instanceof MapType and
    (node2.(Read).readsElement(node1, _) or node2.(RangeElementNode).getBase() = node1)
  )
}
