float maximalConfidence() { result = 1.0 }

float highConfidence() { result = 0.9 }

float mediumConfidence() { result = 0.6 }

/**
 * A specification of how to  instantiate the shared characteristics for a given candidate class.
 *
 * The `CandidateSig` implementation specifies a type to use for Endpoints (eg., `ParameterNode`), as well as a type
 * to label endpoint classes (the `EndpointType`). One of the endpoint classes needs to be a 'negative' class, meaning
 *   "not any of the other known endpoint types".
 */
signature module CandidateSig {
  /**
   * An endpoint is a potential candidate for modeling. This will typically be bound to the language's
   * DataFlow node class, or a subtype thereof.
   */
  class Endpoint {
    /**
     * Gets the kind of this endpoint, either "sourceModel" or "sinkModel".
     */
    string getExtensibleType();

    /**
     * Gets a string representation of this endpoint.
     */
    string toString();
  }

  /**
   * A related location for an endpoint. This will typically be bound to the supertype of all AST nodes (eg., `Top`).
   */
  class RelatedLocation;

  /**
   * A label for a related location.
   *
   * Eg., method-doc, class-doc, etc.
   */
  class RelatedLocationType;

  /**
   * An endpoint type considered by this specification.
   */
  class EndpointType extends string;

  /**
   * A sink endpoint type considered by this specification.
   */
  class SinkType extends EndpointType;

  /**
   * A source endpoint type considered by this specification.
   */
  class SourceType extends EndpointType;

  /**
   * Gets the endpoint as a location.
   *
   * This is a utility function to convert an endpoint to its corresponding location.
   */
  RelatedLocation asLocation(Endpoint e);

  /**
   * Defines what MaD kinds are known, and what endpoint type they correspond to.
   */
  predicate isKnownKind(string kind, EndpointType type);

  /**
   * Holds if `e` is a flow sanitizer, and has type `t`.
   */
  predicate isSanitizer(Endpoint e, EndpointType t);

  /**
   * Holds if `e` is a sink with the label `kind`, and provenance `provenance`.
   */
  predicate isSink(Endpoint e, string kind, string provenance);

  /**
   * Holds if `e` is a source with the label `kind`, and provenance `provenance`.
   */
  predicate isSource(Endpoint e, string kind, string provenance);

  /**
   * Holds if `e` is not a source or sink of any kind.
   */
  predicate isNeutral(Endpoint e);

  /**
   * Gets a related location.
   *
   * A related location is a source code location that may hold extra information about an endpoint that can be useful
   * to the machine learning model.
   *
   * For example, a related location for a method call may be the documentation comment of a method.
   */
  RelatedLocation getRelatedLocation(Endpoint e, RelatedLocationType name);
}

/**
 * A set of shared characteristics for a given candidate class.
 *
 * This module is language-agnostic, although the `CandidateSig` module will be language-specific.
 *
 * The language specific implementation can also further extend the behavior of this module by adding additional
 *   implementations of endpoint characteristics exported by this module.
 */
module SharedCharacteristics<CandidateSig Candidate> {
  predicate isSink = Candidate::isSink/3;

  predicate isNeutral = Candidate::isNeutral/1;

  predicate isModeled(Candidate::Endpoint e, string kind, string extensibleKind, string provenance) {
    Candidate::isSink(e, kind, provenance) and extensibleKind = "sinkModel"
    or
    Candidate::isSource(e, kind, provenance) and extensibleKind = "sourceModel"
  }

  /**
   * Holds if `endpoint` is modeled as `endpointType`.
   */
  predicate isKnownAs(
    Candidate::Endpoint endpoint, Candidate::EndpointType endpointType,
    EndpointCharacteristic characteristic
  ) {
    // If the list of characteristics includes positive indicators with maximal confidence for this class, then it's a
    // known sink for the class.
    characteristic.appliesToEndpoint(endpoint) and
    characteristic.hasImplications(endpointType, true, maximalConfidence())
  }

  /**
   * Gets a potential type of this endpoint to make sure that sources are
   * associated with source types and sinks with sink types.
   */
  Candidate::EndpointType getAPotentialType(Candidate::Endpoint endpoint) {
    endpoint.getExtensibleType() = "sourceModel" and
    result instanceof Candidate::SourceType
    or
    endpoint.getExtensibleType() = "sinkModel" and
    result instanceof Candidate::SinkType
  }

  /**
   * Holds if the given `endpoint` should be considered as a candidate for type `endpointType`,
   * and classified by the ML model.
   *
   * A candidate is an endpoint that cannot be excluded from `endpointType` based on its characteristics.
   */
  predicate isCandidate(Candidate::Endpoint endpoint, Candidate::EndpointType endpointType) {
    endpointType = getAPotentialType(endpoint) and
    not exists(getAnExcludingCharacteristic(endpoint, endpointType))
  }

  /**
   * Gets the related location of `e` with name `name`, if it exists.
   * Otherwise, gets the candidate itself.
   */
  Candidate::RelatedLocation getRelatedLocationOrCandidate(
    Candidate::Endpoint e, Candidate::RelatedLocationType type
  ) {
    if exists(Candidate::getRelatedLocation(e, type))
    then result = Candidate::getRelatedLocation(e, type)
    else result = Candidate::asLocation(e)
  }

  /**
   * Gets a characteristics that disbar `endpoint` from being a candidate for `endpointType`
   * with at least medium confidence.
   */
  EndpointCharacteristic getAnExcludingCharacteristic(
    Candidate::Endpoint endpoint, Candidate::EndpointType endpointType
  ) {
    result.appliesToEndpoint(endpoint) and
    exists(float confidence |
      confidence >= mediumConfidence() and
      result.hasImplications(endpointType, false, confidence)
    )
  }

  /**
   * A set of characteristics that a particular endpoint might have. This set of characteristics is used to make decisions
   * about whether to include the endpoint in the training set and with what kind, as well as whether to score the
   * endpoint at inference time.
   */
  abstract class EndpointCharacteristic extends string {
    /**
     * Holds for the string that is the name of the characteristic. This should describe some property of an endpoint
     * that is meaningful for determining whether it's a sink, and if so, of which sink type.
     */
    bindingset[this]
    EndpointCharacteristic() { any() }

    /**
     * Holds for endpoints that have this characteristic.
     */
    abstract predicate appliesToEndpoint(Candidate::Endpoint n);

    /**
     * This predicate describes what the characteristic tells us about an endpoint.
     *
     * Params:
     * endpointType: The sink/source type.
     * isPositiveIndicator: If true, this characteristic indicates that this endpoint _is_ a member of the class; if
     * false, it indicates that it _isn't_ a member of the class.
     * confidence: A float in [0, 1], which tells us how strong an indicator this characteristic is for the endpoint
     * belonging / not belonging to the given class. A confidence near zero means this characteristic is a very weak
     * indicator of whether or not the endpoint belongs to the class. A confidence of 1 means that all endpoints with
     * this characteristic definitively do/don't belong to the class.
     */
    abstract predicate hasImplications(
      Candidate::EndpointType endpointType, boolean isPositiveIndicator, float confidence
    );

    /** Indicators with confidence at or above this threshold are considered to be high-confidence indicators. */
    final float getHighConfidenceThreshold() { result = 0.8 }
  }

  /**
   * A high-confidence characteristic that indicates that an endpoint is a sink of a specified type. These endpoints can
   * be used as positive samples for training or for a few-shot prompt.
   */
  abstract class SinkCharacteristic extends EndpointCharacteristic {
    bindingset[this]
    SinkCharacteristic() { any() }

    abstract Candidate::EndpointType getSinkType();

    final override predicate hasImplications(
      Candidate::EndpointType endpointType, boolean isPositiveIndicator, float confidence
    ) {
      endpointType = this.getSinkType() and
      isPositiveIndicator = true and
      confidence = maximalConfidence()
    }
  }

  /**
   * A high-confidence characteristic that indicates that an endpoint is a source of a specified type. These endpoints can
   * be used as positive samples for training or for a few-shot prompt.
   */
  abstract class SourceCharacteristic extends EndpointCharacteristic {
    bindingset[this]
    SourceCharacteristic() { any() }

    abstract Candidate::EndpointType getSourceType();

    final override predicate hasImplications(
      Candidate::EndpointType endpointType, boolean isPositiveIndicator, float confidence
    ) {
      endpointType = this.getSourceType() and
      isPositiveIndicator = true and
      confidence = maximalConfidence()
    }
  }

  /**
   * A high-confidence characteristic that indicates that an endpoint is not a sink of any type. These endpoints can be
   * used as negative samples for training or for a few-shot prompt.
   */
  abstract class NotASinkCharacteristic extends EndpointCharacteristic {
    bindingset[this]
    NotASinkCharacteristic() { any() }

    override predicate hasImplications(
      Candidate::EndpointType endpointType, boolean isPositiveIndicator, float confidence
    ) {
      endpointType instanceof Candidate::SinkType and
      isPositiveIndicator = false and
      confidence = highConfidence()
    }
  }

  /**
   * A high-confidence characteristic that indicates that an endpoint is not a source of any type. These endpoints can be
   * used as negative samples for training or for a few-shot prompt.
   */
  abstract class NotASourceCharacteristic extends EndpointCharacteristic {
    bindingset[this]
    NotASourceCharacteristic() { any() }

    override predicate hasImplications(
      Candidate::EndpointType endpointType, boolean isPositiveIndicator, float confidence
    ) {
      endpointType instanceof Candidate::SourceType and
      isPositiveIndicator = false and
      confidence = highConfidence()
    }
  }

  /**
   * A high-confidence characteristic that indicates that an endpoint is neither a source nor a sink of any type.
   */
  abstract class NeitherSourceNorSinkCharacteristic extends NotASinkCharacteristic,
    NotASourceCharacteristic
  {
    bindingset[this]
    NeitherSourceNorSinkCharacteristic() { any() }

    final override predicate hasImplications(
      Candidate::EndpointType endpointType, boolean isPositiveIndicator, float confidence
    ) {
      NotASinkCharacteristic.super.hasImplications(endpointType, isPositiveIndicator, confidence) or
      NotASourceCharacteristic.super.hasImplications(endpointType, isPositiveIndicator, confidence)
    }
  }

  /**
   * A medium-confidence characteristic that indicates that an endpoint is unlikely to be a sink of any type. These
   * endpoints can be excluded from scoring at inference time, both to save time and to avoid false positives. They should
   * not, however, be used as negative samples for training or for a few-shot prompt, because they may include a small
   * number of sinks.
   */
  abstract class LikelyNotASinkCharacteristic extends EndpointCharacteristic {
    bindingset[this]
    LikelyNotASinkCharacteristic() { any() }

    override predicate hasImplications(
      Candidate::EndpointType endpointType, boolean isPositiveIndicator, float confidence
    ) {
      endpointType instanceof Candidate::SinkType and
      isPositiveIndicator = false and
      confidence = mediumConfidence()
    }
  }

  /**
   * A characteristic that indicates not necessarily that an endpoint is not a sink, but rather that it is not a sink
   * that's interesting to model in the standard Java libraries. These filters should be removed when extracting sink
   * candidates within a user's codebase for customized modeling.
   *
   * These endpoints should not be used as negative samples for training or for a few-shot prompt, because they are not
   * necessarily non-sinks.
   */
  abstract class UninterestingToModelCharacteristic extends EndpointCharacteristic {
    bindingset[this]
    UninterestingToModelCharacteristic() { any() }

    override predicate hasImplications(
      Candidate::EndpointType endpointType, boolean isPositiveIndicator, float confidence
    ) {
      endpointType instanceof Candidate::SinkType and
      isPositiveIndicator = false and
      confidence = mediumConfidence()
    }
  }

  /**
   * Contains default implementations that are derived solely from the `CandidateSig` implementation.
   */
  private module DefaultCharacteristicImplementations {
    /**
     * Endpoints identified as sinks by the `CandidateSig` implementation are sinks with maximal confidence.
     */
    private class KnownSinkCharacteristic extends SinkCharacteristic {
      string madKind;
      Candidate::EndpointType endpointType;
      string provenance;

      KnownSinkCharacteristic() {
        Candidate::isKnownKind(madKind, endpointType) and
        // bind "this" to a unique string differing from that of the SinkType classes
        this = madKind + "_" + provenance + "_characteristic" and
        Candidate::isSink(_, madKind, provenance)
      }

      override predicate appliesToEndpoint(Candidate::Endpoint e) {
        Candidate::isSink(e, madKind, provenance)
      }

      override Candidate::EndpointType getSinkType() { result = endpointType }
    }

    private class KnownSourceCharacteristic extends SourceCharacteristic {
      string madKind;
      Candidate::EndpointType endpointType;
      string provenance;

      KnownSourceCharacteristic() {
        Candidate::isKnownKind(madKind, endpointType) and
        // bind "this" to a unique string differing from that of the SinkType classes
        this = madKind + "_" + provenance + "_characteristic" and
        Candidate::isSource(_, madKind, provenance)
      }

      override predicate appliesToEndpoint(Candidate::Endpoint e) {
        Candidate::isSource(e, madKind, provenance)
      }

      override Candidate::EndpointType getSourceType() { result = endpointType }
    }

    /**
     * A negative characteristic that indicates that an endpoint was manually modeled as a neutral model.
     */
    private class NeutralModelCharacteristic extends NeitherSourceNorSinkCharacteristic {
      NeutralModelCharacteristic() { this = "known non-sink" }

      override predicate appliesToEndpoint(Candidate::Endpoint e) { Candidate::isNeutral(e) }
    }

    /**
     * A negative characteristic that indicates that an endpoint is a sanitizer, and thus not a source.
     */
    private class IsSanitizerCharacteristic extends NotASourceCharacteristic {
      IsSanitizerCharacteristic() { this = "known sanitizer" }

      override predicate appliesToEndpoint(Candidate::Endpoint e) { Candidate::isSanitizer(e, _) }
    }
  }
}
