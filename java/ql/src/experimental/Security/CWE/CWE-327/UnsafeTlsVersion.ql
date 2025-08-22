/**
 * @name Unsafe TLS version
 * @description SSL and older TLS versions are known to be vulnerable.
 *              TLS 1.3 or at least TLS 1.2 should be used.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-tls-version
 * @tags security
 *       experimental
 *       external/cwe/cwe-327
 */

import java
deprecated import SslLib
deprecated import UnsafeTlsVersionFlow::PathGraph

deprecated query predicate problems(
  DataFlow::Node sinkNode, UnsafeTlsVersionFlow::PathNode source,
  UnsafeTlsVersionFlow::PathNode sink, string message1, DataFlow::Node sourceNode, string message2
) {
  UnsafeTlsVersionFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "$@ is unsafe." and
  sourceNode = source.getNode() and
  message2 = source.getNode().asExpr().(StringLiteral).getValue()
}
