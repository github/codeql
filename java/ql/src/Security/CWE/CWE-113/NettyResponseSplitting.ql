/**
 * @name Disabled Netty HTTP header validation
 * @description Disabling HTTP header validation makes code vulnerable to
 *              attack by header splitting if user input is written directly to
 *              an HTTP header.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/netty-http-response-splitting
 * @tags security
 *       external/cwe/cwe-113
 */

import java

from ClassInstanceExpr new
where
  new.getConstructedType().hasQualifiedName("io.netty.handler.codec.http", "DefaultHttpHeaders") and
  new.getArgument(0).getProperExpr().(BooleanLiteral).getBooleanValue() = false
select new, "Response-splitting vulnerability due to verification being disabled."
