/**
 * @name Uncontrolled command line
 * @description Using externally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind problem
 * @problem.severity error
 * @sub-severity high
 * @precision medium
 * @id py/command-line-injection
 * @tags correctness
 *       security
 *       external/owasp/owasp-a1
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import python

/* Sources */
import semmle.python.web.HttpRequest

/* Sinks */
import semmle.python.security.injection.Command

from TaintSource src, TaintSink sink
where src.flowsToSink(sink)

select sink, "This command depends on $@.", src, "a user-provided value"
