/**
 * @name Constant password
 * @description Finds places where a string literal is used in a function call
 *              argument named something like "password".
 * @id rust/examples/simple-constant-password
 * @tags example
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking

module ConstantPasswordConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr().getExpr() instanceof StringLiteralExpr }

  predicate isSink(DataFlow::Node node) {
    // `node` is an argument whose corresponding parameter name matches the pattern "pass%"
    exists(CallExpr call, Function target, int argIndex |
      call.getStaticTarget() = target and
      target.getParam(argIndex).getPat().(IdentPat).getName().getText().matches("pass%") and
      call.getArg(argIndex) = node.asExpr().getExpr()
    )
  }
}

module ConstantPasswordFlow = TaintTracking::Global<ConstantPasswordConfig>;

from DataFlow::Node sourceNode, DataFlow::Node sinkNode
where ConstantPasswordFlow::flow(sourceNode, sinkNode)
select sinkNode, "The value $@ is used as a constant password.", sourceNode, sourceNode.toString()
