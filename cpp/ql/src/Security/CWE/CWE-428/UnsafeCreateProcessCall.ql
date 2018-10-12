/**
 * @name NULL application name with an unquoted path in call to CreateProcess
 * @description Calling a function of the CreatePorcess* family of functions, which may result in a security vulnerability if the path contains spaces.
 * @id cpp/unsafe-create-process-call
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @tags security
 *       external/cwe/cwe-428
 *       external/microsoft/C6277
 */
 
import cpp
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.dataflow.DataFlow2

/**
 * A function call to CreateProcess (either wide-char or single byte string versions)
 */
class CreateProcessFunctionCall extends FunctionCall {
  CreateProcessFunctionCall() {
    (
      this.getTarget().hasGlobalName("CreateProcessA") or
      this.getTarget().hasGlobalName("CreateProcessW") or
      this.getTarget().hasGlobalName("CreateProcessWithTokenW") or
      this.getTarget().hasGlobalName("CreateProcessWithLogonW") or
      this.getTarget().hasGlobalName("CreateProcessAsUserA") or
      this.getTarget().hasGlobalName("CreateProcessAsUserW") 
    )
  }
  
  int getApplicationNameArgumentId() {
    if(
      this.getTarget().hasGlobalName("CreateProcessA") or
      this.getTarget().hasGlobalName("CreateProcessW") 
    ) then ( result = 0 )
    else if (
      this.getTarget().hasGlobalName("CreateProcessWithTokenW") 
    ) then ( result = 2 )
    else if (
      this.getTarget().hasGlobalName("CreateProcessWithLogonW") 
    ) then ( result = 4 )
    else if(
      this.getTarget().hasGlobalName("CreateProcessAsUserA") or
      this.getTarget().hasGlobalName("CreateProcessAsUserW") 
    ) then ( result = 1 )
    else (result = -1 )
  }
  
  int getCommandLineArgumentId() {
    if(
      this.getTarget().hasGlobalName("CreateProcessA") or
      this.getTarget().hasGlobalName("CreateProcessW") 
    ) then ( result = 1 )
    else if (
      this.getTarget().hasGlobalName("CreateProcessWithTokenW") 
    ) then ( result = 3 )
    else if (
      this.getTarget().hasGlobalName("CreateProcessWithLogonW") 
    ) then ( result = 5 )
    else if(
      this.getTarget().hasGlobalName("CreateProcessAsUserA") or
      this.getTarget().hasGlobalName("CreateProcessAsUserW") 
    ) then ( result = 2 )
    else (result = -1 )
  }
}
 
/**
 * Dataflow that detects a call to CreateProcess with a NULL value for lpApplicationName argument
 */
class NullAppNameCreateProcessFunctionConfiguration extends DataFlow::Configuration {
  NullAppNameCreateProcessFunctionConfiguration() {
    this = "NullAppNameCreateProcessFunctionConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    nullValue(source.asExpr()) 
  }

  override predicate isSink(DataFlow::Node sink) {
    exists( 
      CreateProcessFunctionCall call, Expr val |
      val = sink.asExpr() |
      val = call.getArgument(call.getApplicationNameArgumentId()) 
    )
  }
}

/**
 * Dataflow that detects a call to CreateProcess with an unquoted commandLine argument
 */
class QuotedCommandInCreateProcessFunctionConfiguration extends DataFlow2::Configuration {
  QuotedCommandInCreateProcessFunctionConfiguration() {
    this = "QuotedCommandInCreateProcessFunctionConfiguration"
  }

  override predicate isSource(DataFlow2::Node source) {
    exists( string s |
      s = source.asExpr().getValue().toString()
      and
      not isQuotedApplicationNameOnCmd(s) 
    ) 
  }
 
  override predicate isSink(DataFlow2::Node sink) {
    exists( 
      CreateProcessFunctionCall call, Expr val |
      val = sink.asExpr() |
      val = call.getArgument(call.getCommandLineArgumentId()) 
    )
  }
}

bindingset[s]
predicate isQuotedApplicationNameOnCmd(string s){
  s.regexpMatch("\"([^\"])*\"(\\s|.)*")
}

from CreateProcessFunctionCall call, string msg1, string msg2
where
  exists( Expr source, Expr appName,
    NullAppNameCreateProcessFunctionConfiguration nullAppConfig |
    appName = call.getArgument(call.getApplicationNameArgumentId())
    and nullAppConfig.hasFlow(DataFlow2::exprNode(source), DataFlow2::exprNode(appName))
    and msg1 = call.toString() + " with lpApplicationName == NULL (" + appName + ")"
  )
  and
  exists( Expr source, Expr cmd,
    QuotedCommandInCreateProcessFunctionConfiguration quotedConfig |
    cmd = call.getArgument(call.getCommandLineArgumentId())
    and quotedConfig.hasFlow(DataFlow2::exprNode(source), DataFlow2::exprNode(cmd))
    and msg2 = " and with an unquoted lpCommandLine (" + cmd + ") may result in a security vulnerability if the path contains spaces."
  )
select call, msg1 + " " + msg2