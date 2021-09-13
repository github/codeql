/**
 * @name Cleartext transmission of sensitive information
 * @description Transmitting sensitive information across a network in
 *              cleartext can expose it to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5 TODO
 * @precision high TODO
 * @id cpp/cleartext-transmission
 * @tags security
 *       external/cwe/cwe-319
 */

import cpp
import semmle.code.cpp.security.SensitiveExprs
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph

/**
 * A function call that sends or receives data over a network.
 */
abstract class NetworkSendRecv extends FunctionCall {
  /**
   * Gets the expression for the socket or similar object used for sending or
   * receiving data.
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
 * note: functions such as `read` may be reading from a network source or a file. We could attempt to determine which, and sort results into `cpp/cleartext-transmission` and perhaps `cpp/cleartext-storage-file`. In practice it probably isn't very important which query reports a result as long as its reported exactly once.
 */
class NetworkSend extends NetworkSendRecv {
  NetworkSend() {
    this.getTarget()
        .hasGlobalName(["send", "sendto", "sendmsg", "write", "writev", "pwritev", "pwritev2"])
  }

  override Expr getSocketExpr() { result = this.getArgument(0) }

  override Expr getDataExpr() { result = this.getArgument(1) }
}

/**
 * A function call that receives data over a network.
 */
class NetworkRecv extends NetworkSendRecv {
  NetworkRecv() {
    this.getTarget()
        .hasGlobalName([
            "recv", "recvfrom", "recvmsg", "read", "pread", "readv", "preadv", "preadv2"
          ])
  }

  override Expr getSocketExpr() { result = this.getArgument(0) }

  override Expr getDataExpr() { result = this.getArgument(1) }
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
