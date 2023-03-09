/**
 * @kind problem
 */

import javascript
import experimental.poi.PoI
import semmle.javascript.security.dataflow.CommandInjectionQuery as CommandInjection
import semmle.javascript.security.dataflow.IndirectCommandInjectionQuery as IndirectCommandInjection
import semmle.javascript.security.dataflow.ShellCommandInjectionFromEnvironmentQuery as ShellCommandInjectionFromEnvironment

class MyDataFlowConfigurationPoIs extends DataFlowConfigurationPoI, ActivePoI { }

query predicate problems = alertQuery/6;
