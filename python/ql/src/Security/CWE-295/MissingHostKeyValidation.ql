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
import semmle.python.ApiGraphs

private API::Node unsafe_paramiko_policy(string name) {
  name in ["AutoAddPolicy", "WarningPolicy"] and
  result = API::moduleImport("paramiko").getMember("client").getMember(name)
}

private API::Node paramikoSSHClientInstance() {
  result = API::moduleImport("paramiko").getMember("client").getMember("SSHClient").getReturn()
}

from CallNode call, ControlFlowNode arg, string name
where
  call = paramikoSSHClientInstance().getMember("set_missing_host_key_policy").getACall().asCfgNode() and
  arg = call.getAnArg() and
  (
    arg = unsafe_paramiko_policy(name).getAUse().asCfgNode() or
    arg = unsafe_paramiko_policy(name).getReturn().getAUse().asCfgNode()
  )
select call, "Setting missing host key policy to " + name + " may be unsafe."
