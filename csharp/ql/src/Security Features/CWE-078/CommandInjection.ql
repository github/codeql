/**
 * @name Uncontrolled command line
 * @description Using externally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/command-line-injection
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import csharp
import semmle.code.csharp.security.dataflow.CommandInjection::CommandInjection

from TaintTrackingConfiguration c, Source source, Sink sink
where c.hasFlow(source, sink)
select sink, "$@ flows to here and is used in a command.", source, "User-provided value"
