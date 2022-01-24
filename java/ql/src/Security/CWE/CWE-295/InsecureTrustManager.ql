/**
 * @name `TrustManager` that accepts all certificates
 * @description Trusting all certificates allows an attacker to perform a machine-in-the-middle attack.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id java/insecure-trustmanager
 * @tags security
 *       external/cwe/cwe-295
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.InsecureTrustManagerQuery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink
where any(InsecureTrustManagerConfiguration cfg).hasFlowPath(source, sink)
select sink, source, sink, "This $@, which is defined $@ and trusts any certificate, is used here.",
  source, "TrustManager", source.getNode().asExpr().(ClassInstanceExpr).getConstructedType(), "here"
