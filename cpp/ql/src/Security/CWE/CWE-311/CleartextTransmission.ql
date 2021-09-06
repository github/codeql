/**
 * @name Cleartext transmission of sensitive information
 * @description Transmitting sensitive information across a network in
 *              cleartext can expose it to an attacker.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5 TODO
 * @precision high
 * @id cpp/cleartext-transmission
 * @tags security
 *       external/cwe/cwe-319
 */

import cpp
import semmle.code.cpp.security.SensitiveExprs
import semmle.code.cpp.security.FileWrite
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/**
 * A function call that sends or receives data over a network.
 */
abstract class NetworkSendRecv extends FunctionCall {
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
  NetworkSend() { this.getTarget().hasGlobalName("send") }

  override Expr getDataExpr() { result = this.getArgument(1) }
}

/**
 * A function call that receives data over a network.
 */
class NetworkRecv extends NetworkSendRecv {
  NetworkRecv() { this.getTarget().hasGlobalName("recv") }

  override Expr getDataExpr() { result = this.getArgument(1) }
}

from NetworkSendRecv transmission, SensitiveExpr e
where DataFlow::localFlow(DataFlow::exprNode(e), DataFlow::exprNode(transmission.getDataExpr()))
select transmission, e
