/**
 * @name Unsafe TLS version
 * @description SSL and older TLS versions are known to be vulnerable.
 *              TLS 1.3 or at least TLS 1.2 should be used.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-tls-version
 * @tags security
 *       external/cwe/cwe-327
 */

import java
import SslLib
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, UnsafeTlsVersionConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ is unsafe", source.getNode(),
  source.getNode().asExpr().(StringLiteral).getValue()
