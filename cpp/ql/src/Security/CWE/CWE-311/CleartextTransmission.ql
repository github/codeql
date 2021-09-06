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

// TODO: network send?

/**
 * TODO
 */
class NetworkRecv extends FunctionCall {
  NetworkRecv() { this.getTarget().hasGlobalName("recv") }

  Expr getData() { result = this.getArgument(1) }
}

from NetworkRecv recv, SensitiveExpr e
where DataFlow::localFlow(DataFlow::exprNode(e), DataFlow::exprNode(recv.(NetworkRecv).getData()))
select recv, e
