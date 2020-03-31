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

abstract private class InsecureNettyObjectCreation extends ClassInstanceExpr { }

private class InsecureDefaultHttpHeadersClassInstantiation extends InsecureNettyObjectCreation {
  InsecureDefaultHttpHeadersClassInstantiation() {
    getConstructedType().hasQualifiedName("io.netty.handler.codec.http", "DefaultHttpHeaders") and
    getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = false
  }
}

private class InsecureDefaultHttpResponseClassInstantiation extends InsecureNettyObjectCreation {
  InsecureDefaultHttpResponseClassInstantiation() {
    getConstructedType().hasQualifiedName("io.netty.handler.codec.http", "DefaultHttpResponse") and
    getArgument(2).(CompileTimeConstantExpr).getBooleanValue() = false
  }
}

private class InsecureDefaultFullHttpResponseClassInstantiation extends InsecureNettyObjectCreation {
  InsecureDefaultFullHttpResponseClassInstantiation() {
    getConstructedType().hasQualifiedName("io.netty.handler.codec.http", "DefaultFullHttpResponse") and
    getArgument(3).(CompileTimeConstantExpr).getBooleanValue() = false
  }
}

from InsecureNettyObjectCreation new
select new, "Response-splitting vulnerability due to header value verification being disabled."
