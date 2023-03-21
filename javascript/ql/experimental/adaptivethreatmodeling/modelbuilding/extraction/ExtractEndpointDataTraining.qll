/**
 * For internal use only.
 *
 * Extracts training data we can use to train ML models for ML-powered queries.
 */

import javascript
import experimental.adaptivethreatmodeling.EndpointCharacteristics
import experimental.adaptivethreatmodeling.EndpointFeatures as EndpointFeatures
import NoFeaturizationRestrictionsConfig
private import Exclusions as Exclusions
import Queries
private import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionAtm
private import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionAtm
private import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathAtm
private import experimental.adaptivethreatmodeling.XssATM as XssAtm
private import experimental.adaptivethreatmodeling.XssThroughDomATM as XssThroughDomAtm
private import experimental.adaptivethreatmodeling.ShellCommandInjectionFromEnvironmentATM as ShellCommandInjectionFromEnvironmentAtm

/**
 * Gets the set of featureName-featureValue pairs for each endpoint in the training set.
 *
 * `EndpointFeatures::tokenFeatures` has no results when `featureName` is absent for the endpoint
 * `endpoint`. To preserve compatibility with the data pipeline, this relation will instead set
 * `featureValue` to the empty string in this case.
 */
predicate tokenFeatures(DataFlow::Node endpoint, string featureName, string featureValue) {
  trainingEndpoints(endpoint, _, _) and
  (
    EndpointFeatures::tokenFeatures(endpoint, featureName, featureValue)
    or
    // Performance note: this creates a Cartesian product between `endpoint` and `featureName`.
    featureName = EndpointFeatures::getASupportedFeatureName() and
    not EndpointFeatures::tokenFeatures(endpoint, featureName, _) and
    featureValue = ""
  )
}

/**
 * Holds if the given endpoint should be included in the training set as a sample belonging to endpointClass, and has
 * the given characteristic. This query uses the endpoint characteristics to select and label endpoints for the training
 * set, and provides a list of characteristics for each endpoint in the training set, which is used in the modeling
 * code.
 *
 * Params:
 * endpoint: The endpoint to include / exclude.
 * endpointClass: The sink type. See the documentation of EndpointType.getEncoding for details about the relationship
 * between an EndpointType and a class in the classifier.
 * characteristic: Provides the list of characteristics that apply to the endpoint, which the modeling code currently
 * uses for type balancing.
 *
 * Note: This predicate will produce multiple tuples for endpoints that have multiple characteristics, which we must
 * then group together into a list of characteristics.
 */
query predicate trainingEndpoints(
  DataFlow::Node endpoint, EndpointType endpointClass, EndpointCharacteristic characteristic
) {
  characteristic.appliesToEndpoint(endpoint) and
  // Only consider the source code for the project being analyzed.
  exists(endpoint.getFile().getRelativePath()) and
  // Only select endpoints that can be part of a tainted flow: Constant expressions always evaluate to a constant
  // primitive value. Therefore they can't ever appear in an alert, making them less interesting training examples.
  // TODO: Experiment with removing this requirement.
  not endpoint.asExpr() instanceof ConstantExpr and
  // Do not select endpoints filtered out by end-to-end evaluation.
  // TODO: Experiment with removing this requirement.
  not Exclusions::isFileExcluded(endpoint.getFile()) and
  // Filter out negative examples that also have a LikelyNotASinkReason, because this is currently done here
  // https://github.com/github/codeql/blob/387e57546bf7352f7c1cfe781daa1a3799b7063e/javascript/ql/experimental/adaptivethreatmodeling/modelbuilding/extraction/ExtractEndpointData.qll#L77
  // TODO: Experiment with removing this requirement.
  not (
    endpointClass instanceof NegativeType and
    exists(EndpointCharacteristic c |
      c.appliesToEndpoint(endpoint) and
      c instanceof LikelyNotASinkCharacteristic
    )
  ) and
  // Don't surface endpoint filters as characteristics, because they were previously not surfaced.
  // TODO: Experiment with surfacing these to the modeling code by removing the following line (and then make
  // EndpointFilterCharacteristic private).
  not characteristic instanceof EndpointFilterCharacteristic and
  (
    // If the list of characteristics includes positive indicators with high confidence for this class, select this as a
    // training sample belonging to the class.
    exists(EndpointCharacteristic characteristic2, float confidence |
      characteristic2.appliesToEndpoint(endpoint) and
      characteristic2.hasImplications(endpointClass, true, confidence) and
      confidence >= characteristic2.getHighConfidenceThreshold()
    ) and
    (
      // Temporarily limit this only to positive classes. For negative classes, additionally select only endpoints that
      // have no high confidence indicators that they are sinks, because this is what was previously done.
      // TODO: Experiment with removing this requirement, and instead ensuring that an endpoint never has both a high
      // confidence indicator that it _is_ a sink and a high confidence indicator that it is _not_ a sink.
      not endpointClass instanceof NegativeType
      or
      not exists(EndpointCharacteristic characteristic3, float confidence3, EndpointType posClass |
        characteristic3.appliesToEndpoint(endpoint) and
        characteristic3.hasImplications(posClass, true, confidence3) and
        confidence3 >= characteristic3.getHighConfidenceThreshold() and
        not posClass instanceof NegativeType
      )
    )
    or
    // If the list of characteristics includes negative indicators with high confidence for all classes other than 0,
    // select this as a training sample of class 0 (this means we had query-specific characteristics to decide this
    // endpoint isn't a sink for each of our sink types).
    endpointClass instanceof NegativeType and
    forall(EndpointType otherClass | not otherClass instanceof NegativeType |
      exists(EndpointCharacteristic characteristic2, float confidence |
        characteristic2.appliesToEndpoint(endpoint) and
        characteristic2.hasImplications(otherClass, false, confidence) and
        confidence >= characteristic2.getHighConfidenceThreshold()
      )
    )
  )
}

/**
 * Temporary:
 * Reformat the training data that was extracted with the new logic to match the format produced by the old predicate.
 * This is the format expected by the endpoint pipeline.
 */
query predicate reformattedTrainingEndpoints(
  DataFlow::Node endpoint, string queryName, string key, string value, string valueType
) {
  trainingEndpoints(endpoint, _, _) and
  exists(Query query |
    queryName = query.getName() and
    // For sinks, only list that sink type, but for non-sinks, list all sink types.
    (
      exists(EndpointType endpointClass |
        endpointClass.getDescription().matches(queryName + "%") and
        not endpointClass instanceof NegativeType and
        trainingEndpoints(endpoint, endpointClass, _)
      )
      or
      exists(EndpointType endpointClass |
        endpointClass instanceof NegativeType and
        trainingEndpoints(endpoint, endpointClass, _)
      )
    ) and
    (
      // NOTE: We don't use hasFlowFromSource in training, so we could just hardcode it to be false.
      key = "hasFlowFromSource" and
      (
        if FlowFromSource::hasFlowFromSource(endpoint, query)
        then value = "true"
        else value = "false"
      ) and
      valueType = "boolean"
      or
      // Constant expressions always evaluate to a constant primitive value. Therefore they can't ever
      // appear in an alert, making them less interesting training examples.
      key = "isConstantExpression" and
      (if endpoint.asExpr() instanceof ConstantExpr then value = "true" else value = "false") and
      valueType = "boolean"
      or
      // Holds if alerts involving the endpoint are excluded from the end-to-end evaluation.
      key = "isExcludedFromEndToEndEvaluation" and
      (if Exclusions::isFileExcluded(endpoint.getFile()) then value = "true" else value = "false") and
      valueType = "boolean"
      or
      // The label for this query, considering the endpoint as a sink.
      key = "sinkLabel" and
      valueType = "string" and
      value = "Sink" and
      exists(EndpointType endpointClass |
        endpointClass.getDescription().matches(queryName + "%") and
        not endpointClass instanceof NegativeType and
        trainingEndpoints(endpoint, endpointClass, _)
      )
      or
      key = "sinkLabel" and
      valueType = "string" and
      value = "NotASink" and
      exists(EndpointType endpointClass |
        endpointClass instanceof NegativeType and
        trainingEndpoints(endpoint, endpointClass, _)
      )
      or
      // The reason, or reasons, why the endpoint was labeled NotASink for this query, only for negative examples.
      key = "notASinkReason" and
      exists(EndpointCharacteristic characteristic, EndpointType endpointClass |
        characteristic.appliesToEndpoint(endpoint) and
        characteristic.hasImplications(endpointClass, true, _) and
        endpointClass instanceof NegativeType and
        value = characteristic
      ) and
      // Don't include a notASinkReason for endpoints that are also known sinks.
      not exists(EndpointCharacteristic characteristic3, float confidence3, EndpointType posClass |
        characteristic3.appliesToEndpoint(endpoint) and
        characteristic3.hasImplications(posClass, true, confidence3) and
        confidence3 >= characteristic3.getHighConfidenceThreshold() and
        not posClass instanceof NegativeType
      ) and
      // Don't surface endpoint filters as notASinkReasons, because they were previously not surfaced.
      // TODO: Experiment with surfacing these to the modeling code by removing the following line (and then make
      // EndpointFilterCharacteristic private).
      not value instanceof EndpointFilterCharacteristic and
      valueType = "string"
    )
  )
}

/**
 * Gets the ATM data flow configuration for the specified query.
 * TODO: Delete this once we are no longer surfacing `hasFlowFromSource`.
 */
DataFlow::Configuration getDataFlowCfg(Query query) {
  query instanceof NosqlInjectionQuery and
  result instanceof NosqlInjectionAtm::NosqlInjectionAtmConfig
  or
  query instanceof SqlInjectionQuery and result instanceof SqlInjectionAtm::SqlInjectionAtmConfig
  or
  query instanceof TaintedPathQuery and result instanceof TaintedPathAtm::TaintedPathAtmConfig
  or
  query instanceof XssQuery and result instanceof XssAtm::DomBasedXssAtmConfig
  or
  query instanceof XssThroughDomQuery and result instanceof XssThroughDomAtm::XssThroughDomAtmConfig
  or
  query instanceof ShellCommandInjectionFromEnvironmentQuery and
  result instanceof
    ShellCommandInjectionFromEnvironmentAtm::ShellCommandInjectionFromEnvironmentAtmConfig
}

// TODO: Delete this once we are no longer surfacing `hasFlowFromSource`.
private module FlowFromSource {
  predicate hasFlowFromSource(DataFlow::Node endpoint, Query q) {
    exists(Configuration cfg | cfg.getQuery() = q | cfg.hasFlow(_, endpoint))
  }

  /**
   * A data flow configuration that replicates the data flow configuration for a specific query, but
   * replaces the set of sinks with the set of endpoints we're extracting.
   *
   * We use this to find out when there is flow to a particular endpoint from a known source.
   *
   * This configuration behaves in a very similar way to the `ForwardExploringConfiguration` class
   * from the CodeQL standard libraries for JavaScript.
   */
  private class Configuration extends DataFlow::Configuration {
    Query q;

    Configuration() { this = getDataFlowCfg(q) }

    Query getQuery() { result = q }

    /** Holds if `sink` is an endpoint we're extracting. */
    override predicate isSink(DataFlow::Node sink) { any() }

    /** Holds if `sink` is an endpoint we're extracting. */
    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel lbl) { exists(lbl) }
  }
}
