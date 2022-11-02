/**
 * For internal use only.
 *
 * Defines a set of characteristics that a particular endpoint might have. This set of characteristics is used to make
 * decisions about whether to include the endpoint in the training set and with what label, as well as whether to score
 * the endpoint at inference time.
 */

import experimental.adaptivethreatmodeling.EndpointTypes
import semmle.javascript.security.dataflow.SqlInjectionCustomizations
private import semmle.javascript.security.dataflow.DomBasedXssCustomizations
private import semmle.javascript.security.dataflow.NosqlInjectionCustomizations
private import semmle.javascript.security.dataflow.TaintedPathCustomizations

abstract class EndpointCharacteristic extends string {
  // The name of the characteristic, which should describe some characteristic of the endpoint that is meaningful for
  // determining whether it's a sink and if so of which type
  bindingset[this]
  EndpointCharacteristic() { any() }

  // Indicators with confidence at or above this threshold are considered to be high-confidence indicators.
  float getHighConfidenceThreshold() { result = 0.8 }

  // Indicators with confidence at or above this threshold are considered to be medium-confidence indicators.
  float getMediumConfidenceThreshold() { result = 0.5 }

  // The logic to identify which endpoints have this characteristic.
  abstract predicate getEndpoints(DataFlow::Node n);

  // This predicate describes what the characteristic tells us about an endpoint.
  //
  // Params:
  // endpointClass: Class 0 is the negative class. Each positive int corresponds to a single sink type.
  // isPositiveIndicator: Does this characteristic indicate this endpoint _is_ a member of the class, or that it
  // _isn't_ a member of the class?
  // confidence: A number in [0, 1], which tells us how strong an indicator this characteristic is for the endpoint
  // belonging / not belonging to the given class.
  abstract predicate getImplications(
    EndpointType endpointClass, boolean isPositiveIndicator, float confidence
  );
}

/*
 * Endpoints that were identified as "DomBasedXssSink" by the standard Javascript library are XSS sinks with maximal
 * confidence.
 */

private class DomBasedXssSinkCharacteristic extends EndpointCharacteristic {
  DomBasedXssSinkCharacteristic() { this = "DomBasedXssSink" }

  override predicate getEndpoints(DataFlow::Node n) { n instanceof DomBasedXss::Sink }

  override predicate getImplications(
    EndpointType endpointClass, boolean isPositiveIndicator, float confidence
  ) {
    endpointClass instanceof XssSinkType and isPositiveIndicator = true and confidence = 1.0
  }
}

/*
 * Endpoints that were identified as "TaintedPathSink" by the standard Javascript library are path injection sinks with
 * maximal confidence.
 */

private class TaintedPathSinkCharacteristic extends EndpointCharacteristic {
  TaintedPathSinkCharacteristic() { this = "TaintedPathSink" }

  override predicate getEndpoints(DataFlow::Node n) { n instanceof TaintedPath::Sink }

  override predicate getImplications(
    EndpointType endpointClass, boolean isPositiveIndicator, float confidence
  ) {
    endpointClass instanceof TaintedPathSinkType and isPositiveIndicator = true and confidence = 1.0
  }
}

/*
 * Endpoints that were identified as "SqlInjectionSink" by the standard Javascript library are SQL injection sinks with
 * maximal confidence.
 */

private class SqlInjectionSinkCharacteristic extends EndpointCharacteristic {
  SqlInjectionSinkCharacteristic() { this = "SqlInjectionSink" }

  override predicate getEndpoints(DataFlow::Node n) { n instanceof SqlInjection::Sink }

  override predicate getImplications(
    EndpointType endpointClass, boolean isPositiveIndicator, float confidence
  ) {
    endpointClass instanceof SqlInjectionSinkType and
    isPositiveIndicator = true and
    confidence = 1.0
  }
}

/*
 * Endpoints that were identified as "NosqlInjectionSink" by the standard Javascript library are NoSQL injection sinks
 * with maximal confidence.
 */

private class NosqlInjectionSinkCharacteristic extends EndpointCharacteristic {
  NosqlInjectionSinkCharacteristic() { this = "NosqlInjectionSink" }

  override predicate getEndpoints(DataFlow::Node n) { n instanceof NosqlInjection::Sink }

  override predicate getImplications(
    EndpointType endpointClass, boolean isPositiveIndicator, float confidence
  ) {
    endpointClass instanceof NosqlInjectionSinkType and
    isPositiveIndicator = true and
    confidence = 1.0
  }
}
