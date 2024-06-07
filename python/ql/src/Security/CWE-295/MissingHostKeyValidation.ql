/**
 * @name Accepting unknown SSH host keys when using Paramiko
 * @description Accepting unknown host keys can allow man-in-the-middle attacks.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id py/paramiko-missing-host-key-validation
 * @tags security
 *       external/cwe/cwe-295
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs

private API::Node unsafe_paramiko_policy(string name) {
  name in ["AutoAddPolicy", "WarningPolicy"] and
  (
    result = API::moduleImport("paramiko").getMember("client").getMember(name)
    or
    result = API::moduleImport("paramiko").getMember(name)
  )
}

private API::Node paramikoSshClientInstance() {
  result = API::moduleImport("paramiko").getMember("client").getMember("SSHClient").getReturn()
  or
  result = API::moduleImport("paramiko").getMember("SSHClient").getReturn()
}

from DataFlow::CallCfgNode call, DataFlow::Node arg, string name
where
  // see http://docs.paramiko.org/en/stable/api/client.html#paramiko.client.SSHClient.set_missing_host_key_policy
  call = paramikoSshClientInstance().getMember("set_missing_host_key_policy").getACall() and
  arg in [call.getArg(0), call.getArgByName("policy")] and
  (
    arg = unsafe_paramiko_policy(name).getAValueReachableFromSource() or
    arg = unsafe_paramiko_policy(name).getReturn().getAValueReachableFromSource()
  )
select call, "Setting missing host key policy to " + name + " may be unsafe."
