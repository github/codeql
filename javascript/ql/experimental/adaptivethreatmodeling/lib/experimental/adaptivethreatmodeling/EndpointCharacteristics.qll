/**
 * For internal use only.
 */

import experimental.adaptivethreatmodeling.EndpointTypes
private import semmle.javascript.security.dataflow.SqlInjectionCustomizations
private import semmle.javascript.security.dataflow.DomBasedXssCustomizations
private import semmle.javascript.security.dataflow.NosqlInjectionCustomizations
private import semmle.javascript.security.dataflow.TaintedPathCustomizations

/**
 * A set of characteristics that a particular endpoint might have. This set of characteristics is used to make decisions
 * about whether to include the endpoint in the training set and with what label, as well as whether to score the
 * endpoint at inference time.
 */
abstract class EndpointCharacteristic extends string {
  /**
   * Holds when the string matches the name of the characteristic, which should describe some characteristic of the
   * endpoint that is meaningful for determining whether it's a sink and if so of which type
   */
  bindingset[this]
  EndpointCharacteristic() { any() }

  /**
   * Holds for endpoints that have this characteristic. This predicate contains the logic that applies characteristics
   * to the appropriate set of dataflow nodes.
   */
  abstract predicate getEndpoints(DataFlow::Node n);

  /**
   * This predicate describes what the characteristic tells us about an endpoint.
   *
   * Params:
   * endpointClass: Class 0 is the negative class, containing non-sink endpoints. Each positive int corresponds to a
   * single sink type.
   * isPositiveIndicator: If true, this characteristic indicates that this endpoint _is_ a member of the class; if
   * false, it indicates that it _isn't_ a member of the class.
   * confidence: A float in [0, 1], which tells us how strong an indicator this characteristic is for the endpoint
   * belonging / not belonging to the given class. A confidence near zero means this characterestic is a very weak
   * indicator of whether or not the endpoint belongs to the class. A confidence of 1 means that all endpoints with
   * this characteristic difinitively do/don't belong to the class.
   */
  abstract predicate getImplications(
    EndpointType endpointClass, boolean isPositiveIndicator, float confidence
  );
}

/**
 * Endpoints identified as "DomBasedXssSink" by the standard JavaScript libraries are XSS sinks with maximal confidence.
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

/**
 * Endpoints identified as "TaintedPathSink" by the standard JavaScript libraries are path injection sinks with maximal
 * confidence.
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

/**
 * Endpoints identified as "SqlInjectionSink" by the standard JavaScript libraries are SQL injection sinks with maximal
 * confidence.
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

/**
 * Endpoints identified as "NosqlInjectionSink" by the standard JavaScript libraries are NoSQL injection sinks with
 * maximal confidence.
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
