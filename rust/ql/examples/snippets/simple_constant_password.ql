/**
 * @name Constant password
 * @description Finds places where a string literal is used in a function call
 *              argument that looks like a password.
 * @id rust/examples/simple-constant-password
 * @tags example
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking

/**
 * A data flow configuration for tracking flow from a string literal to a function
 * call argument that looks like a password. For example:
 * ```
 * fn set_password(password: &str) { ... }
 *
 * ...
 *
 * let pwd = "123456"; // source
 * set_password(pwd); // sink (argument 0)
 * ```
 */
module ConstantPasswordConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    // `node` is a string literal
    node.asExpr() instanceof StringLiteralExpr
  }

  predicate isSink(DataFlow::Node node) {
    // `node` is an argument whose corresponding parameter name matches the pattern "pass%"
    exists(Call call, Function target, int argIndex, Variable v |
      call.getStaticTarget() = target and
      v.getParameter() = target.getParam(argIndex) and
      v.getText().matches("pass%") and
      call.getPositionalArgument(argIndex) = node.asExpr()
    )
  }
}

// instantiate the data flow configuration as a global taint tracking module
module ConstantPasswordFlow = TaintTracking::Global<ConstantPasswordConfig>;

// report flows from sources to sinks
from DataFlow::Node sourceNode, DataFlow::Node sinkNode
where ConstantPasswordFlow::flow(sourceNode, sinkNode)
select sinkNode, "The value $@ is used as a constant password.", sourceNode, sourceNode.toString()
