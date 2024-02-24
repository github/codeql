import python
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.internal.DataFlowPublic
import codeql.util.Unit

/**
 * Provides sinks and additional taint steps for the secondary command injection configuration
 */
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

/**
 * The exec_command of `paramiko.SSHClient` class execute command on ssh target server
 */
class ParamikoExecCommand extends SecondaryCommandInjection::Sink {
  ParamikoExecCommand() {
    this = paramikoClient().getMember("exec_command").getACall().getParameter(0, "command").asSink()
  }
}

private API::Node paramikoClient() {
  result = API::moduleImport("paramiko").getMember("SSHClient").getReturn()
}

module SecondaryCommandInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof SecondaryCommandInjection::Sink }
}

/** Global taint-tracking for detecting "paramiko command injection" vulnerabilities. */
module SecondaryCommandInjectionFlow = TaintTracking::Global<SecondaryCommandInjectionConfig>;
