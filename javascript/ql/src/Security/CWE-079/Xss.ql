/**
 * @name Client side cross-site scripting
 * @description Writing user input directly to the DOM allows for
 *              a cross-site scripting vulnerability.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.DomBasedXss::DomBasedXss

from Configuration xss, DataFlow::Node source, Sink sink
where xss.hasFlow(source, sink)
select sink, sink.getVulnerabilityKind() + " vulnerability due to $@.",
       source, "user-provided value"
