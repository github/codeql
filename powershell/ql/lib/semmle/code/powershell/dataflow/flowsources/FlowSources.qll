/** Provides classes representing various flow sources for taint tracking. */
private import semmle.code.powershell.dataflow.internal.DataFlowPublic as DataFlow
import semmle.code.powershell.dataflow.flowsources.Remote
import semmle.code.powershell.dataflow.flowsources.Local
import semmle.code.powershell.dataflow.flowsources.Stored
import semmle.code.powershell.frameworks.data.internal.ApiGraphModels

/**
 * A data flow source.
 */
abstract class SourceNode extends DataFlow::Node {
  /**
   * Gets a string that represents the source kind with respect to threat modeling.
   */
  abstract string getThreatModel();

  /** Gets a string that describes the type of this flow source. */
  abstract string getSourceType();
}
