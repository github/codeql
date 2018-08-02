/**
 * @name Code injection
 * @description Interpreting unsanitized user input as code allows a malicious user arbitrary
 *              code execution.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/code-injection
 * @tags security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.CodeInjection::CodeInjection

from Configuration codeInjection, DataFlow::Node source, DataFlow::Node sink
where codeInjection.hasFlow(source, sink)
select sink, "$@ flows to here and is interpreted as code.", source, "User-provided value"