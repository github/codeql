/**
 * @name Disabled Netty HTTP header validation
 * @description Disabling HTTP header validation makes code vulnerable to
 *              attack by header splitting if user input is written directly to
 *              an HTTP header.
 * @kind problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id java/netty-http-request-or-response-splitting
 * @tags security
 *       external/cwe/cwe-93
 *       external/cwe/cwe-113
 */

import java
import semmle.code.java.dataflow.FlowSources

abstract private class InsecureNettyObjectCreation extends ClassInstanceExpr {
  int vulnerableArgumentIndex;

  InsecureNettyObjectCreation() {
    DataFlow::localExprFlow(any(CompileTimeConstantExpr ctce | ctce.getBooleanValue() = false),
      this.getArgument(vulnerableArgumentIndex))
  }

  abstract string splittingType();
}

abstract private class RequestOrResponseSplittingInsecureNettyObjectCreation extends InsecureNettyObjectCreation
{
  override string splittingType() { result = "Request splitting or response splitting" }
}

/**
 * Request splitting can allowing an attacker to inject/smuggle an additional HTTP request into the socket connection.
 */
abstract private class RequestSplittingInsecureNettyObjectCreation extends InsecureNettyObjectCreation
{
  override string splittingType() { result = "Request splitting" }
}

/**
 * Response splitting can lead to HTTP vulnerabilities like XSS and cache poisoning.
 */
abstract private class ResponseSplittingInsecureNettyObjectCreation extends InsecureNettyObjectCreation
{
  override string splittingType() { result = "Response splitting" }
}

private class InsecureDefaultHttpHeadersClassInstantiation extends RequestOrResponseSplittingInsecureNettyObjectCreation
{
  InsecureDefaultHttpHeadersClassInstantiation() {
    this.getConstructedType()
        .hasQualifiedName("io.netty.handler.codec.http",
          ["DefaultHttpHeaders", "CombinedHttpHeaders"]) and
    vulnerableArgumentIndex = 0
  }
}

private class InsecureDefaultHttpResponseClassInstantiation extends ResponseSplittingInsecureNettyObjectCreation
{
  InsecureDefaultHttpResponseClassInstantiation() {
    this.getConstructedType().hasQualifiedName("io.netty.handler.codec.http", "DefaultHttpResponse") and
    vulnerableArgumentIndex = 2
  }
}

private class InsecureDefaultHttpRequestClassInstantiation extends RequestSplittingInsecureNettyObjectCreation
{
  InsecureDefaultHttpRequestClassInstantiation() {
    this.getConstructedType().hasQualifiedName("io.netty.handler.codec.http", "DefaultHttpRequest") and
    vulnerableArgumentIndex = 3
  }
}

private class InsecureDefaultFullHttpResponseClassInstantiation extends ResponseSplittingInsecureNettyObjectCreation
{
  InsecureDefaultFullHttpResponseClassInstantiation() {
    this.getConstructedType()
        .hasQualifiedName("io.netty.handler.codec.http", "DefaultFullHttpResponse") and
    vulnerableArgumentIndex = [2, 3]
  }
}

private class InsecureDefaultFullHttpRequestClassInstantiation extends RequestSplittingInsecureNettyObjectCreation
{
  InsecureDefaultFullHttpRequestClassInstantiation() {
    this.getConstructedType()
        .hasQualifiedName("io.netty.handler.codec.http", "DefaultFullHttpRequest") and
    vulnerableArgumentIndex = [3, 4]
  }
}

from InsecureNettyObjectCreation new
select new, new.splittingType() + " vulnerability due to header value verification being disabled."
