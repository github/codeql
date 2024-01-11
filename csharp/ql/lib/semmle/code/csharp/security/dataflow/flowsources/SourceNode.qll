private import semmle.code.csharp.dataflow.internal.ExternalFlow
private import codeql.threatmodels.ThreatModels

/**
 * A data flow source.
 */
abstract class SourceNode extends DataFlow::Node {
  /**
   * Gets a string that represents the source kind with respect to threat modeling.
   */
  abstract string getThreatModel();
}

/**
 * A class of data flow sources that respects the
 * current threat model configuration.
 */
class ThreatModelFlowSource extends DataFlow::Node {
  ThreatModelFlowSource() {
    exists(string kind |
      // Specific threat model.
      currentThreatModel(kind) and
      (this.(SourceNode).getThreatModel() = kind or sourceNode(this, kind))
    )
  }
}
