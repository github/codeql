/**
 * @kind problem
 */

import javascript
import experimental.poi.PoI
import semmle.javascript.security.dataflow.CommandInjection
import semmle.javascript.security.dataflow.IndirectCommandInjection
import semmle.javascript.security.dataflow.ShellCommandInjectionFromEnvironment

class Config extends DataFlowConfigurationPoIConfiguration { }

query predicate problems = alertQuery/6;
