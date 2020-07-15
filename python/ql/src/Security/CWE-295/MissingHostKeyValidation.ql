/**
 * @name Accepting unknown SSH host keys when using Paramiko
 * @description Accepting unknown host keys can allow man-in-the-middle attacks.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id py/paramiko-missing-host-key-validation
 * @tags security
 *       external/cwe/cwe-295
 */

import python

private ModuleValue theParamikoClientModule() { result = Value::named("paramiko.client") }

private ClassValue theParamikoSSHClientClass() {
  result = theParamikoClientModule().attr("SSHClient")
}

private ClassValue unsafe_paramiko_policy(string name) {
  (name = "AutoAddPolicy" or name = "WarningPolicy") and
  result = theParamikoClientModule().attr(name)
}

from CallNode call, ControlFlowNode arg, string name
where
  call =
    theParamikoSSHClientClass().lookup("set_missing_host_key_policy").(FunctionValue).getACall() and
  arg = call.getAnArg() and
  (
    arg.pointsTo(unsafe_paramiko_policy(name)) or
    arg.pointsTo().getClass() = unsafe_paramiko_policy(name)
  )
select call, "Setting missing host key policy to " + name + " may be unsafe."
