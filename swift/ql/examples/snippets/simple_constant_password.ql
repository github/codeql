/**
 * @name Constant password
 * @description Finds places where a string literal is used in a function call
 *              argument named "password".
 * @id swift/examples/simple-constant-password
 * @tags example
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking

module ConstantPasswordConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof StringLiteralExpr }

  predicate isSink(DataFlow::Node node) {
    // any argument called `password`
    exists(CallExpr call | call.getArgumentWithLabel("password").getExpr() = node.asExpr())
  }
}

module ConstantPasswordFlow = TaintTracking::Global<ConstantPasswordConfig>;

from DataFlow::Node sourceNode, DataFlow::Node sinkNode
where ConstantPasswordFlow::flow(sourceNode, sinkNode)
select sinkNode, "The value $@ is used as a constant password.", sourceNode, sourceNode.toString()
