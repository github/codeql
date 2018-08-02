/**
 * @name User-controlled bypass of sensitive method
 * @description User-controlled bypassing of sensitive methods may allow attackers to avoid
 *              passing through authentication systems.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/user-controlled-bypass
 * @tags security
 *       external/cwe/cwe-807
 *       external/cwe/cwe-247
 *       external/cwe/cwe-350
 */
import csharp
import semmle.code.csharp.security.dataflow.ConditionalBypass::UserControlledBypassOfSensitiveMethod

from Configuration config, Source source, Sink sink
where config.hasFlow(source, sink)
select sink.getSensitiveMethodCall(), "Sensitive method may not be executed depending on $@, which flows from $@.",
  sink, "this condition", source, "user input"
