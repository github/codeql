/**
 * @name NULL application name with an unquoted path in call to CreateProcess
 * @description Calling a function of the CreateProcess* family of functions, where the path contains spaces, introduces a security vulnerability.
 * @id cpp/unsafe-create-process-call
 * @kind problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @msrc.severity important
 * @tags security
 *       external/cwe/cwe-428
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow

predicate isCreateProcessFunction(FunctionCall call, int applicationNameIndex, int commandLineIndex) {
  call.getTarget().hasGlobalName("CreateProcessA") and
  applicationNameIndex = 0 and
  commandLineIndex = 1
  or
  call.getTarget().hasGlobalName("CreateProcessW") and
  applicationNameIndex = 0 and
  commandLineIndex = 1
  or
  call.getTarget().hasGlobalName("CreateProcessWithTokenW") and
  applicationNameIndex = 2 and
  commandLineIndex = 3
  or
  call.getTarget().hasGlobalName("CreateProcessWithLogonW") and
  applicationNameIndex = 4 and
  commandLineIndex = 5
  or
  call.getTarget().hasGlobalName("CreateProcessAsUserA") and
  applicationNameIndex = 1 and
  commandLineIndex = 2
  or
  call.getTarget().hasGlobalName("CreateProcessAsUserW") and
  applicationNameIndex = 1 and
  commandLineIndex = 2
}

/**
 * A function call to CreateProcess (either wide-char or single byte string versions)
 */
class CreateProcessFunctionCall extends FunctionCall {
  CreateProcessFunctionCall() { isCreateProcessFunction(this, _, _) }

  int getApplicationNameArgumentId() { isCreateProcessFunction(this, result, _) }

  int getCommandLineArgumentId() { isCreateProcessFunction(this, _, result) }
}

/**
 * Dataflow that detects a call to CreateProcess with a NULL value for lpApplicationName argument
 */
module NullAppNameCreateProcessFunctionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof NullValue }

  predicate isSink(DataFlow::Node sink) {
    exists(CreateProcessFunctionCall call, Expr val | val = sink.asExpr() |
      val = call.getArgument(call.getApplicationNameArgumentId())
    )
  }
}

module NullAppNameCreateProcessFunction = DataFlow::Global<NullAppNameCreateProcessFunctionConfig>;

/**
 * Dataflow that detects a call to CreateProcess with an unquoted commandLine argument
 */
module QuotedCommandInCreateProcessFunctionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(string s |
      s = source.asExpr().getValue().toString() and
      not isQuotedOrNoSpaceApplicationNameOnCmd(s)
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(CreateProcessFunctionCall call, Expr val | val = sink.asExpr() |
      val = call.getArgument(call.getCommandLineArgumentId())
    )
  }
}

module QuotedCommandInCreateProcessFunction =
  DataFlow::Global<QuotedCommandInCreateProcessFunctionConfig>;

bindingset[s]
predicate isQuotedOrNoSpaceApplicationNameOnCmd(string s) {
  s.regexpMatch("\"([^\"])*\"[\\s\\S]*") // The first element (path) is quoted
  or
  s.regexpMatch("[^\\s]+") // There are no spaces in the string
}

from CreateProcessFunctionCall call, string msg1, string msg2
where
  exists(Expr appName |
    appName = call.getArgument(call.getApplicationNameArgumentId()) and
    NullAppNameCreateProcessFunction::flowToExpr(appName) and
    msg1 = call.toString() + " with lpApplicationName == NULL (" + appName + ")"
  ) and
  exists(Expr cmd |
    cmd = call.getArgument(call.getCommandLineArgumentId()) and
    QuotedCommandInCreateProcessFunction::flowToExpr(cmd) and
    msg2 =
      " and with an unquoted lpCommandLine (" + cmd +
        ") introduces a security vulnerability if the path contains spaces."
  )
select call, msg1 + " " + msg2
