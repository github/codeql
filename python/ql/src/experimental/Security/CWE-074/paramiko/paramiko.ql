/**
 * @name RCE with user provided command with paramiko ssh client
 * @description user provided command can lead to execute code on a external server that can be belong to other users or admins
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id py/command-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-074
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.ApiGraphs
import DataFlow::PathGraph

class ParamikoCMDInjectionConfiguration extends TaintTracking::Configuration {
  ParamikoCMDInjectionConfiguration() { this = "ParamikoCMDInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink =
      [
        API::moduleImport("paramiko")
            .getMember("SSHClient")
            .getReturn()
            .getMember("exec_command")
            .getACall()
            .getArgByName("command"),
        API::moduleImport("paramiko")
            .getMember("SSHClient")
            .getReturn()
            .getMember("exec_command")
            .getACall()
            .getArg(0)
      ]
    or
    sink =
      [
        API::moduleImport("paramiko")
            .getMember("SSHClient")
            .getReturn()
            .getMember("connect")
            .getACall()
            .getArgByName("sock"),
        API::moduleImport("paramiko")
            .getMember("SSHClient")
            .getReturn()
            .getMember("connect")
            .getACall()
            .getArg(11)
      ]
  }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(API::CallNode call |
      call = API::moduleImport("paramiko").getMember("ProxyCommand").getACall() and
      nodeFrom = [call.getArg(0), call.getArgByName("command_line")] and
      nodeTo = call
    )
  }
}

from ParamikoCMDInjectionConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This code execution depends on a $@.", source.getNode(),
  "a user-provided value"
