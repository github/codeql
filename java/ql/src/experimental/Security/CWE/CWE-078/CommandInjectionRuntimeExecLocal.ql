/**
 * @name Command Injection into Runtime.exec() with dangerous command
 * @description High sensitvity and precision version of java/command-line-injection, designed to find more cases of command injection in rare cases that the default query does not find
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id java/command-line-injection-extra-local
 * @tags security
 *       experimental
 *       local
 *       external/cwe/cwe-078
 */

deprecated import CommandInjectionRuntimeExec
deprecated import ExecUserFlow::PathGraph

deprecated class LocalSource extends Source instanceof LocalUserInput { }

deprecated query predicate problems(
  ExecUserFlow::PathNode sink, ExecUserFlow::PathNode source, ExecUserFlow::PathNode sink0,
  string message1, DataFlow::Node sourceCmd, string message2, DataFlow::Node sourceNode,
  string message3
) {
  callIsTaintedByUserInputAndDangerousCommand(source, sink, sourceCmd, _) and
  sink0 = sink and
  message1 =
    "Call to dangerous java.lang.Runtime.exec() with command '$@' with arg from untrusted input '$@'" and
  message2 = sourceCmd.toString() and
  sourceNode = source.getNode() and
  message3 = source.toString()
}
