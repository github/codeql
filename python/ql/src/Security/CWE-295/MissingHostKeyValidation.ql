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

private ModuleObject theParamikoClientModule() { result = ModuleObject::named("paramiko.client") }

private ClassObject theParamikoSSHClientClass() {
    result = theParamikoClientModule().attr("SSHClient")
}

private ClassObject unsafe_paramiko_policy(string name) {
    (name = "AutoAddPolicy" or name = "WarningPolicy") and
    result = theParamikoClientModule().attr(name)
}

from CallNode call, ControlFlowNode arg, string name
where
    call = theParamikoSSHClientClass()
           .lookupAttribute("set_missing_host_key_policy")
           .(FunctionObject)
           .getACall() and
    arg = call.getAnArg() and
    (
        arg.refersTo(unsafe_paramiko_policy(name)) or
        arg.refersTo(_, unsafe_paramiko_policy(name), _)
    )
select call, "Setting missing host key policy to " + name + " may be unsafe."
