/**
 * @name Cleartext transmission of sensitive information
 * @description Transmitting sensitive information across a network in
 *              cleartext can expose it to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id cpp/cleartext-transmission
 * @tags security
 *       external/cwe/cwe-319
 */

import cpp
import semmle.code.cpp.security.SensitiveExprs
import semmle.code.cpp.dataflow.TaintTracking
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.models.interfaces.FlowSource
import DataFlow::PathGraph

/**
 * A function call that sends or receives data over a network.
 *
 * note: functions such as `write` may be writing to a network source or a file. We could attempt to determine which, and sort results into `cpp/cleartext-transmission` and perhaps `cpp/cleartext-storage-file`. In practice it usually isn't very important which query reports a result as long as its reported exactly once. See `checkSocket` to narrow this down somewhat.
 */
abstract class NetworkSendRecv extends FunctionCall {
  /**
   * Gets the expression for the socket or similar object used for sending or
   * receiving data (if any).
   */
  abstract Expr getSocketExpr();

  /**
   * Gets the expression for the buffer to be sent from / received into.
   */
  abstract Expr getDataExpr();

  /**
   * Holds if any socket used by this call could be a true network socket.
   * A zero socket descriptor is standard input, which is not a network
   * operation.
   */
  predicate checkSocket() {
    not exists(Zero zero |
      DataFlow::localFlow(DataFlow::exprNode(zero), DataFlow::exprNode(getSocketExpr()))
    )
  }
}

/**
 * A function call that sends data over a network.
 */
class NetworkSend extends NetworkSendRecv {
  RemoteFlowSinkFunction target;

  NetworkSend() { target = this.getTarget() }

  override Expr getSocketExpr() {
    exists(FunctionInput input, int arg |
      target.hasSocketInput(input) and
      input.isParameter(arg) and
      result = this.getArgument(arg)
    )
  }

  override Expr getDataExpr() {
    exists(FunctionInput input, int arg |
      target.hasRemoteFlowSink(input, _) and
      input.isParameterDeref(arg) and
      result = this.getArgument(arg)
    )
  }
}

/**
 * A function call that receives data over a network.
 */
class NetworkRecv extends NetworkSendRecv {
  RemoteFlowSourceFunction target;

  NetworkRecv() { target = this.getTarget() }

  override Expr getSocketExpr() {
    exists(FunctionInput input, int arg |
      target.hasSocketInput(input) and
      input.isParameter(arg) and
      result = this.getArgument(arg)
    )
  }

  override Expr getDataExpr() {
    exists(FunctionOutput output, int arg |
      target.hasRemoteFlowSource(output, _) and
      output.isParameterDeref(arg) and
      result = this.getArgument(arg)
    )
  }
}

/**
 * An expression that is an argument or return value from an encryption or
 * decryption call.
 */
class Encrypted extends Expr {
  Encrypted() {
    exists(FunctionCall fc |
      fc.getTarget().getName().toLowerCase().regexpMatch(".*(crypt|encode|decode).*") and
      (
        this = fc or
        this = fc.getAnArgument()
      )
    )
  }
}

/**
 * Taint flow from a sensitive expression.
 */
class FromSensitiveConfiguration extends TaintTracking::Configuration {
  FromSensitiveConfiguration() { this = "FromSensitiveConfiguration" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof SensitiveExpr }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(NetworkSendRecv nsr | nsr.checkSocket()).getDataExpr()
    or
    sink.asExpr() instanceof Encrypted
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    // flow from pre-update to post-update of the source
    isSource(node1) and
    node2.(DataFlow::PostUpdateNode).getPreUpdateNode() = node1
    or
    // flow from pre-update to post-update of the sink (in case we can reach other sinks)
    isSink(node1) and
    node2.(DataFlow::PostUpdateNode).getPreUpdateNode() = node1
    or
    // flow through encryption functions to the return value (in case we can reach other sinks)
    node2.asExpr().(Encrypted).(FunctionCall).getAnArgument() = node1.asExpr()
  }
}

from
  FromSensitiveConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink,
  NetworkSendRecv networkSendRecv, string msg
where
  // flow from sensitive -> network data
  config.hasFlowPath(source, sink) and
  sink.getNode().asExpr() = networkSendRecv.getDataExpr() and
  networkSendRecv.checkSocket() and
  // no flow from sensitive -> evidence of encryption
  not exists(DataFlow::Node anySource, DataFlow::Node encrypted |
    config.hasFlow(anySource, sink.getNode()) and
    config.hasFlow(anySource, encrypted) and
    encrypted.asExpr() instanceof Encrypted
  ) and
  // construct result
  if networkSendRecv instanceof NetworkSend
  then
    msg =
      "This operation transmits '" + sink.toString() +
        "', which may contain unencrypted sensitive data from $@"
  else
    msg =
      "This operation receives into '" + sink.toString() +
        "', which may put unencrypted sensitive data into $@"
select networkSendRecv, source, sink, msg, source, source.getNode().asExpr().toString()
