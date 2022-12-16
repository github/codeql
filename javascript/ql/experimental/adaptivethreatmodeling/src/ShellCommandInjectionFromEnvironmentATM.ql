/**
 * For internal use only.
 *
 * @name Shell command built from environment values
 * @description Building a shell command string with values from the enclosing
 *              environment may cause subtle bugs or vulnerabilities.
 * @kind path-problem
 * @scored
 * @problem.severity warning
 * @security-severity 6.3
 * @precision high
 * @id js/ml-powered/shell-command-injection-from-environment
 * @tags experimental security
 *       correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import javascript
import experimental.adaptivethreatmodeling.ShellCommandInjectionFromEnvironmentATM
import ATM::ResultsInfo
import DataFlow::PathGraph

from AtmConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink, float score
where cfg.hasBoostedFlowPath(source, sink, score)
select sink.getNode(), source, sink,
  "(Experimental) This shell command depends on $@. Identified using machine learning.",
  source.getNode(), "an uncontrolled value", score
