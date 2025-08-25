import python
private import semmle.python.ApiGraphs
private import experimental.cryptography.utils.CallCfgNodeWithTarget

/**
 * Gets an ultimate local source (not a source in a library)
 */
DataFlow::Node getUltimateSrcFromApiNode(API::Node n) {
  result = n.getAValueReachingSink() and
  (
    // the result is a call to a library only
    result instanceof CallCfgNodeWithTarget and
    not result.(CallCfgNodeWithTarget).getTarget().asExpr().getEnclosingModule().inSource()
    or
    // the result is not a call, and not a function signataure or parameter
    not result instanceof CallCfgNodeWithTarget and
    not result instanceof DataFlow::ParameterNode and
    not result.asExpr() instanceof FunctionExpr and
    result.asExpr().getEnclosingModule().inSource()
  )
}
