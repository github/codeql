/**
 * @name Code injection
 * @description Interpreting unsanitized user input as code allows a malicious user arbitrary
 *              code execution.
 * @kind path-problem
 * @problem.severity error
 * @sub-severity high
 * @precision high
 * @id py/code-injection
 * @tags security
 *       external/owasp/owasp-a1
 *       external/cwe/cwe-094
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import python
import semmle.python.security.Paths

/* Sources */
import semmle.python.web.HttpRequest

/* Sinks */
import semmle.python.security.injection.Exec


from TaintedNode srcnode, TaintedNode sinknode, TaintSource src, TaintSink sink
where src.flowsToSink(sink) and srcnode.getNode() = src and sinknode.getNode() = sink

select sink, srcnode, sinknode, "$@ flows to here and is interpreted as code.", src, "User-provided value"
