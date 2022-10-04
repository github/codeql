/**
 * @name Uncontrolled command line
 * @description Using externally controlled strings in a command line is vulnerable to malicious
 *              changes in the strings.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id java/command-line-injection
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.ExternalProcess
import semmle.code.java.security.CommandLineQuery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, ArgumentToExec execArg
where execTainted(source, sink, execArg)
select execArg, source, sink, "This command line depends on a $@.", source.getNode(),
  "user-provided value"
