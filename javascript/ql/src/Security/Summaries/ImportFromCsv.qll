/**
 * Provides classes for importing source, sink and flow step summaries
 * from external CSV data added at snapshot build time.
 */

import javascript
import semmle.javascript.dataflow.Portals
import external.ExternalArtifact

/**
 * An additional source specified in an `additional-sources.csv` file.
 */
class AdditionalSourceSpec extends ExternalData {
  AdditionalSourceSpec() {
    this.getDataPath() = "additional-sources.csv"
  }

  /**
   * Gets the portal of this additional source.
   */
  Portal getPortal() {
    result.toString() = getField(0)
  }

  /**
   * Gets the flow label of this source.
   */
  DataFlow::FlowLabel getFlowLabel() {
    result.toString() = getField(1)
  }

  /**
   * Gets the configuration for which this is a source.
   */
  DataFlow::Configuration getConfiguration() {
    result.toString() = getField(2)
  }

  override string toString() {
    result = getPortal() + " as " + getFlowLabel() + " source for " + getConfiguration()
  }
}

private class AdditionalSourceFromSpec extends DataFlow::AdditionalSource {
  AdditionalSourceSpec spec;

  AdditionalSourceFromSpec() {
    this = spec.getPortal().getAnExitNode(_)
  }

  override predicate isSourceFor(DataFlow::Configuration cfg, DataFlow::FlowLabel lbl) {
    cfg = spec.getConfiguration() and lbl = spec.getFlowLabel()
  }
}

/**
 * An additional sink specified in an `additional-sinks.csv` file.
 */
class AdditionalSinkSpec extends ExternalData {
  AdditionalSinkSpec() {
    this.getDataPath() = "additional-sinks.csv"
  }

  /**
   * Gets the portal specification of this additional sink.
   */
  Portal getPortal() {
    result.toString() = getField(0)
  }

  /**
   * Gets the flow label of this sink.
   */
  DataFlow::FlowLabel getFlowLabel() {
    result.toString() = getField(1)
  }

  /**
   * Gets the configuration for which this is a sink.
   */
  DataFlow::Configuration getConfiguration() {
    result.toString() = getField(2)
  }

  override string toString() {
    result = getPortal() + " as " + getFlowLabel() + " sink for " + getConfiguration()
  }
}

private class AdditionalSinkFromSpec extends DataFlow::AdditionalSink {
  AdditionalSinkSpec spec;

  AdditionalSinkFromSpec() {
    this = spec.getPortal().getAnEntryNode(_)
  }

  override predicate isSinkFor(DataFlow::Configuration cfg, DataFlow::FlowLabel lbl) {
    cfg = spec.getConfiguration() and lbl = spec.getFlowLabel()
  }
}
/**
 * An additional flow step specified in an `additional-steps.csv` file.
 */
class AdditionalStepSpec extends ExternalData {
  AdditionalStepSpec() {
    this.getDataPath() = "additional-steps.csv"
  }

  /**
   * Gets the start portal of this additional step.
   */
  Portal getStartPortal() {
    result.toString() = getField(0)
  }

  /**
   * Gets the start flow label of this additional step.
   */
  DataFlow::FlowLabel getStartFlowLabel() {
    result.toString() = getField(1)
  }

  /**
   * Gets the end portal of this additional step.
   */
  Portal getEndPortal() {
    result.toString() = getField(2)
  }

  /**
   * Gets the end flow label of this additional step.
   */
  DataFlow::FlowLabel getEndFlowLabel() {
    result.toString() = getField(3)
  }

  /**
   * Gets the configuration to which this step should be added.
   */
  DataFlow::Configuration getConfiguration() {
    result.toString() = getField(4)
  }

  override string toString() {
    result = "edge from " + getStartPortal() + " to " + getEndPortal() +
             ", transforming " + getStartFlowLabel() + " into " + getEndFlowLabel() +
             " for " + getConfiguration()
  }
}

private class AdditionalFlowStepFromSpec extends DataFlow::Configuration {
  AdditionalStepSpec spec;
  DataFlow::Node entry;
  DataFlow::Node exit;

  AdditionalFlowStepFromSpec() {
    this = spec.getConfiguration() and
    entry = spec.getStartPortal().getAnEntryNode(_) and
    exit = spec.getEndPortal().getAnExitNode(_)
  }

  override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ,
                                          DataFlow::FlowLabel predlbl, DataFlow::FlowLabel succlbl) {
    pred = entry and
    succ = exit and
    predlbl = spec.getStartFlowLabel() and
    succlbl = spec.getEndFlowLabel()
  }
}
