/**
 * @name Command Injection into Runtime.exec() with dangerous command
 * @description Testing query. High sensitvity and precision version of java/command-line-injection, designed to find more cases of command injection in rare cases that the default query does not find
 * @kind problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id java/command-line-injection-extra-test
 * @tags testing
 *       test
 *       experimental
 *       security
 *       external/cwe/cwe-078
 */

import CommandInjectionRuntimeExec

class DataSource extends Source {
  DataSource() { this instanceof RemoteFlowSource or this instanceof LocalUserInput }
}

from
  DataFlow::Node source, DataFlow::Node sink, ExecTaintConfiguration2 conf, MethodAccess call,
  int index, DataFlow::Node sourceCmd, DataFlow::Node sinkCmd, ExecTaintConfiguration confCmd
where
  call.getMethod() instanceof RuntimeExecMethod and
  // this is a command-accepting call to exec, e.g. exec("/bin/sh", ...)
  (
    confCmd.hasFlow(sourceCmd, sinkCmd) and
    sinkCmd.asExpr() = call.getArgument(0)
  ) and
  // it is tainted by untrusted user input
  (
    conf.hasFlow(source, sink) and
    sink.asExpr() = call.getArgument(index)
  )
select sink,
  "Call to dangerous java.lang.Runtime.exec() with command '$@' with arg from untrusted input '$@'",
  sourceCmd, sourceCmd.toString(), source, source.toString()
