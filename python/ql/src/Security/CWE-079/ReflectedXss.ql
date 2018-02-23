/**
 * @name Reflected server-side cross-site scripting
 * @description Writing user input directly to a web page
 *              allows for a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @sub-severity high
 * @precision high
 * @id py/reflective-xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import python
import semmle.python.security.Paths

/* Sources */
import semmle.python.web.HttpRequest

/* Sinks */

import semmle.python.web.HttpResponse

/* Flow */
import semmle.python.security.strings.Untrusted

from TaintedNode srcnode, TaintedNode sinknode, TaintSource src, TaintSink sink
where src.flowsToSink(sink) and srcnode.getNode() = src and sinknode.getNode() = sink

select sink, srcnode, sinknode, "Cross-site scripting vulnerability due to $@.",
       src, "user-provided value"

