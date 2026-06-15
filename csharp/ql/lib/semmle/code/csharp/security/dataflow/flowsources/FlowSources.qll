/** Provides classes representing various flow sources for taint tracking. */

private import semmle.code.csharp.dataflow.internal.ExternalFlow
private import codeql.threatmodels.ThreatModels
import semmle.code.csharp.security.dataflow.flowsources.Remote
import semmle.code.csharp.security.dataflow.flowsources.Local
import semmle.code.csharp.security.dataflow.flowsources.Stored

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

/**
 * DEPRECATED: Use `ActiveThreatModelSource` instead.
 *
 * A class of data flow sources that respects the
 * current threat model configuration.
 */
deprecated class ThreatModelFlowSource = ActiveThreatModelSource;

/**
 * A data flow source that is enabled in the current threat model configuration.
 */
class ActiveThreatModelSource extends DataFlow::Node {
  ActiveThreatModelSource() {
    exists(string kind |
      // Specific threat model.
      currentThreatModel(kind) and
      (this.(SourceNode).getThreatModel() = kind or sourceNode(this, kind))
    )
  }
}

/**
 * A data flow source node for an API, which should be considered
 * supported from a modeling perspective.
 */
abstract class ApiSourceNode extends DataFlow::Node { }

private class AddSourceNodes extends ApiSourceNode instanceof SourceNode { }

/**
 * Add all source models as data sources.
 */
private class ApiSourceNodeExternal extends ApiSourceNode {
  ApiSourceNodeExternal() { sourceNode(this, _) }
}
