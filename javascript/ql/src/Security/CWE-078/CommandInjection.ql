/**
 * @name Uncontrolled command line
 * @description Using externally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/command-line-injection
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import javascript
import semmle.javascript.security.dataflow.CommandInjection::CommandInjection

from Configuration cfg, DataFlow::Node source, DataFlow::Node sink, DataFlow::Node highlight
where cfg.hasFlow(source, sink) and
      if cfg.isSink(sink, _) then cfg.isSink(sink, highlight) else highlight = sink
select highlight, "This command depends on $@.", source, "a user-provided value"
