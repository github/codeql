/**
 * Provides classes for importing source, sink and flow step summaries
 * through external predicates.
 */

import javascript
import semmle.javascript.dataflow.Portals
import external.ExternalArtifact
import Shared

/**
 * An external predicate providing information about additional sources.
 *
 * This predicate can be populated from the output of the `ExtractSourceSummaries` query.
 */
external predicate additionalSources(string portal, string flowLabel, string config);

/**
 * An external predicate providing information about additional sinks.
 *
 * This predicate can be populated from the output of the `ExtractSinkSummaries` query.
 */
external predicate additionalSinks(string portal, string flowLabel, string config);

/**
 * An external predicate providing information about additional flow steps.
 *
 * This predicate can be populated from the output of the `ExtractFlowStepSummaries` query.
 */
external predicate additionalSteps(
  string startPortal, string startFlowLabel, string endPortal, string endFlowLabel, string config
);

/**
 * An additional source specified through the `additionalSources` predicate.
 */
private class AdditionalSourceFromSpec extends DataFlow::AdditionalSource {
  string flowLabel;
  string config;

  AdditionalSourceFromSpec() {
    exists(Portal portal |
      additionalSources(portal.toString(), flowLabel, config) and
      this = portal.getAnExitNode(_)
    )
  }

  override predicate isSourceFor(DataFlow::Configuration cfg, DataFlow::FlowLabel lbl) {
    configSpec(cfg, config) and sourceFlowLabelSpec(lbl, flowLabel)
  }
}

/**
 * An additional sink specified through the `additionalSinks` predicate.
 */
private class AdditionalSinkFromSpec extends DataFlow::AdditionalSink {
  string flowLabel;
  string config;

  AdditionalSinkFromSpec() {
    exists(Portal portal |
      additionalSinks(portal.toString(), flowLabel, config) and
      this = portal.getAnEntryNode(_)
    )
  }

  override predicate isSinkFor(DataFlow::Configuration cfg, DataFlow::FlowLabel lbl) {
    configSpec(cfg, config) and sinkFlowLabelSpec(lbl, flowLabel)
  }
}

/**
 * An additional flow step specified through the `additionalSteps` predicate.
 */
private class AdditionalFlowStepFromSpec extends DataFlow::Configuration {
  DataFlow::Node entry;
  string startFlowLabel;
  DataFlow::Node exit;
  string endFlowLabel;

  AdditionalFlowStepFromSpec() {
    exists(Portal startPortal, Portal endPortal, string config |
      additionalSteps(startPortal.toString(), startFlowLabel, endPortal.toString(), endFlowLabel,
        config) and
      configSpec(this, config) and
      entry = startPortal.getAnEntryNode(_) and
      exit = endPortal.getAnExitNode(_)
    )
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel predlbl,
    DataFlow::FlowLabel succlbl
  ) {
    pred = entry and
    succ = exit and
    predlbl = startFlowLabel and
    succlbl = endFlowLabel
  }
}
