/**
 * @name Code injection
 * @description Interpreting unsanitized user input as code allows a malicious user arbitrary
 *              code execution.
 * @kind problem
 * @problem.severity error
 * @sub-severity high
 * @precision medium
 * @id py/code-injection
 * @tags security
 *       external/owasp/owasp-a1
 *       external/cwe/cwe-094
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import python

/* Sources */
import semmle.python.web.HttpRequest

/* Sinks */
import semmle.python.security.injection.Exec


from TaintSource src, TaintSink sink
where src.flowsToSink(sink)

select sink, "$@ flows to here and is interpreted as code.", src, "User-provided value"
