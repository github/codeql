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
import semmle.code.cpp.models.interfaces.FlowSource
import DataFlow::PathGraph

/**
 * A function call that sends or receives data over a network.
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
}

/**
 * A function call that sends data over a network.
 *
 * note: functions such as `write` may be writing to a network source or a file. We could attempt to determine which, and sort results into `cpp/cleartext-transmission` and perhaps `cpp/cleartext-storage-file`. In practice it usually isn't very important which query reports a result as long as its reported exactly once.
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
 * Taint flow from a sensitive expression to a network operation with data
 * tainted by that expression.
 */
class SensitiveSendRecvConfiguration extends TaintTracking::Configuration {
  SensitiveSendRecvConfiguration() { this = "SensitiveSendRecvConfiguration" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof SensitiveExpr }

  override predicate isSink(DataFlow::Node sink) {
    exists(NetworkSendRecv transmission |
      sink.asExpr() = transmission.getDataExpr() and
      // a zero socket descriptor is standard input, which is not interesting for this query.
      not exists(Zero zero |
        DataFlow::localFlow(DataFlow::exprNode(zero),
          DataFlow::exprNode(transmission.getSocketExpr()))
      )
    )
  }
}

from
  SensitiveSendRecvConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink,
  NetworkSendRecv transmission, string msg
where
  config.hasFlowPath(source, sink) and
  sink.getNode().asExpr() = transmission.getDataExpr() and
  if transmission instanceof NetworkSend
  then
    msg =
      "This operation transmits '" + sink.toString() +
        "', which may contain unencrypted sensitive data from $@"
  else
    msg =
      "This operation receives into '" + sink.toString() +
        "', which may put unencrypted sensitive data into $@"
select transmission, source, sink, msg, source, source.getNode().asExpr().toString()
