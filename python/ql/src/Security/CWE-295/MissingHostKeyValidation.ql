/**
 * @name Accepting unknown host keys.
 * @description Accepting unknown host keys can allow man-in-the-middle attacks.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id py/missing-host-key-validation
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

from CallNode call, string name
where
    call = theParamikoSSHClientClass()
        .declaredAttribute("set_missing_host_key_policy")
        .(FunctionObject)
        .getACall() and
    call.getAnArg().refersTo(unsafe_paramiko_policy(name))
select call, "Setting missing host key policy to " + name + " may be unsafe."
