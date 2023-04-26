/**
 * @name Insecure TLS configuration
 * @description TLS v1.0 and v1.1 versions are known to be vulnerable. TLS v1.2 or v1.3 should be used instead.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id swift/insecure-tls
 * @tags security
 *       external/cwe/cwe-757
 */

import swift
import codeql.swift.security.InsecureTLSQuery
import InsecureTlsFlow::PathGraph

from InsecureTlsFlow::PathNode sourceNode, InsecureTlsFlow::PathNode sinkNode
where InsecureTlsFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "This TLS configuration is insecure."
