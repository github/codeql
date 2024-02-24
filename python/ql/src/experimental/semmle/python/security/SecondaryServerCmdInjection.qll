import python
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.internal.DataFlowPublic
import codeql.util.Unit

module SecondaryCommandInjection {
  /**
   * The additional taint steps that need for creating taint tracking or dataflow.
   */
  class AdditionalTaintStep extends Unit {
    /**
     * Holds if there is a additional taint step between pred and succ.
     */
    abstract predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ);
  }

  /**
   * A abstract class responsible for extending new decompression sinks
   */
  abstract class Sink extends DataFlow::Node { }
}

private API::Node paramikoClient() {
  result = API::moduleImport("paramiko").getMember("SSHClient").getReturn()
}

module ParamikoConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  /**
   * exec_command of `paramiko.SSHClient` class execute command on ssh target server
   * the `paramiko.ProxyCommand` is equivalent of `ssh -o ProxyCommand="CMD"`
   *  and it run CMD on current system that running the ssh command
   * the Sink related to proxy command is the `connect` method of `paramiko.SSHClient` class
   */
  predicate isSink(DataFlow::Node sink) {
    sink = paramikoClient().getMember("exec_command").getACall().getParameter(0, "command").asSink()
    or
    sink = paramikoClient().getMember("connect").getACall().getParameter(11, "sock").asSink()
  }

  /**
   * this additional taint step help taint tracking to find the vulnerable `connect` method of `paramiko.SSHClient` class
   */
  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(API::CallNode call |
      call = API::moduleImport("paramiko").getMember("ProxyCommand").getACall() and
      nodeFrom = call.getParameter(0, "command_line").asSink() and
      nodeTo = call
    )
  }
}

/** Global taint-tracking for detecting "paramiko command injection" vulnerabilities. */
module ParamikoFlow = TaintTracking::Global<ParamikoConfig>;
