/**
 * Provides classes for importing source, sink and flow step summaries
 * from external CSV data added at snapshot build time.
 */

import javascript
import semmle.javascript.dataflow.Portals
import external.ExternalArtifact
private import Shared

/**
 * An additional source specified in an `additional-sources.csv` file.
 */
class AdditionalSourceSpec extends ExternalData {
  AdditionalSourceSpec() { this.getDataPath() = "additional-sources.csv" }

  /**
   * Gets the portal of this additional source.
   */
  Portal getPortal() { result.toString() = getField(0) }

  /**
   * Gets the flow label of this source.
   */
  DataFlow::FlowLabel getFlowLabel() { sourceFlowLabelSpec(result, getField(1)) }

  /**
   * Gets the configuration for which this is a source, or any
   * configuration if this source does not specify a configuration.
   */
  DataFlow::Configuration getConfiguration() { configSpec(result, getField(2)) }

  override string toString() {
    exists(string config |
      if getField(2) = "" then config = "any configuration" else config = getConfiguration()
    |
      result = getPortal() + " as " + getFlowLabel() + " source for " + config
    )
  }
}

private class AdditionalSourceFromSpec extends DataFlow::AdditionalSource {
  AdditionalSourceSpec spec;

  AdditionalSourceFromSpec() { this = spec.getPortal().getAnExitNode(_) }

  override predicate isSourceFor(DataFlow::Configuration cfg, DataFlow::FlowLabel lbl) {
    cfg = spec.getConfiguration() and lbl = spec.getFlowLabel()
  }
}

/**
 * An additional sink specified in an `additional-sinks.csv` file.
 */
class AdditionalSinkSpec extends ExternalData {
  AdditionalSinkSpec() { this.getDataPath() = "additional-sinks.csv" }

  /**
   * Gets the portal specification of this additional sink.
   */
  Portal getPortal() { result.toString() = getField(0) }

  /**
   * Gets the flow label of this sink, or any standard flow label if this sink
   * does not specify a flow label.
   */
  DataFlow::FlowLabel getFlowLabel() { sinkFlowLabelSpec(result, getField(1)) }

  /**
   * Gets the configuration for which this is a sink, or any configuration if
   * this sink does not specify a configuration.
   */
  DataFlow::Configuration getConfiguration() { configSpec(result, getField(2)) }

  override string toString() {
    exists(string labels, string config |
      labels = strictconcat(getFlowLabel(), " or ") and
      if getField(2) = "" then config = "any configuration" else config = getConfiguration()
    |
      result = getPortal() + " as " + labels + " sink for " + config
    )
  }
}

private class AdditionalSinkFromSpec extends DataFlow::AdditionalSink {
  AdditionalSinkSpec spec;

  AdditionalSinkFromSpec() { this = spec.getPortal().getAnEntryNode(_) }

  override predicate isSinkFor(DataFlow::Configuration cfg, DataFlow::FlowLabel lbl) {
    cfg = spec.getConfiguration() and lbl = spec.getFlowLabel()
  }
}

/**
 * An additional flow step specified in an `additional-steps.csv` file.
 */
class AdditionalStepSpec extends ExternalData {
  AdditionalStepSpec() { this.getDataPath() = "additional-steps.csv" }

  /**
   * Gets the start portal of this additional step.
   */
  Portal getStartPortal() { result.toString() = getField(0) }

  /**
   * Gets the start flow label of this additional step.
   */
  DataFlow::FlowLabel getStartFlowLabel() { result.toString() = getField(1) }

  /**
   * Gets the end portal of this additional step.
   */
  Portal getEndPortal() { result.toString() = getField(2) }

  /**
   * Gets the end flow label of this additional step.
   */
  DataFlow::FlowLabel getEndFlowLabel() { result.toString() = getField(3) }

  /**
   * Gets the configuration to which this step should be added.
   */
  DataFlow::Configuration getConfiguration() { configSpec(result, getField(4)) }

  override string toString() {
    exists(string config |
      if getField(4) = "" then config = "any configuration" else config = getConfiguration()
    |
      result =
        "edge from " + getStartPortal() + " to " + getEndPortal() + ", transforming " +
          getStartFlowLabel() + " into " + getEndFlowLabel() + " for " + config
    )
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

  override predicate isAdditionalFlowStep(
    DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel predlbl,
    DataFlow::FlowLabel succlbl
  ) {
    pred = entry and
    succ = exit and
    predlbl = spec.getStartFlowLabel() and
    succlbl = spec.getEndFlowLabel()
  }
}
