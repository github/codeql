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
   * A abstract class responsible for extending secondary command injection dataflow sinks.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A data flow source for secondary command injection data flow queries.
   */
  abstract class Source extends DataFlow::Node { }

  class RemoteSources extends Source {
    RemoteSources() { this instanceof RemoteFlowSource }
  }
}
