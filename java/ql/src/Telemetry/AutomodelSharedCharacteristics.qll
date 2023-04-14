float maximalConfidence() { result = 1.0 }

float highConfidence() { result = 0.9 }

float mediumConfidence() { result = 0.6 }

signature module CandidateSig {
  class Endpoint;

  class EndpointType;

  string getLocationString(Endpoint e);

  /**
   * Defines what labels are known, and what endpoint type they correspond to.
   */
  predicate isKnownLabel(string label, string humanReadableLabel, EndpointType type);

  /**
   * EndpointType must have a 'negative' type that denotes the absence of any sink.
   * This predicate should hold for that type, and that type only.
   */
  predicate isNegative(EndpointType t);

  /**
   * Should hold for any endpoint that is a sink of the given (known or unknown) label.
   */
  predicate isSink(Endpoint e, string label);

  /**
   * Should hold for any endpoint that is known to not be any sink.
   */
  predicate isNeutral(Endpoint e);

  /**
   * Holds if `e` has the given metadata.
   *
   * This is a helper function to extract and export needed information about each endpoint in the sink candidate query
   * as well as the queries that extract positive and negative examples for the prompt / training set. The metadata is
   * extracted as a string in the format of a Python dictionary.
   */
  predicate hasMetadata(Endpoint e, string metadata);
}

module SharedCharacteristics<CandidateSig Candidate> {
  predicate isNegative(Candidate::EndpointType e) { Candidate::isNegative(e) }

  predicate isSink(Candidate::Endpoint e, string label) { Candidate::isSink(e, label) }

  predicate isNeutral(Candidate::Endpoint e) { Candidate::isNeutral(e) }

  /**
   * Holds if `sink` is a known sink of type `endpointType`.
   */
  predicate isKnownSink(Candidate::Endpoint sink, Candidate::EndpointType endpointType) {
    // If the list of characteristics includes positive indicators with maximal confidence for this class, then it's a
    // known sink for the class.
    not isNegative(endpointType) and
    exists(EndpointCharacteristic characteristic |
      characteristic.appliesToEndpoint(sink) and
      characteristic.hasImplications(endpointType, true, maximalConfidence())
    )
  }

  /**
   * Holds if the candidate sink `candidateSink` should be considered as a possible sink of type `sinkType`, and
   * classified by the ML model. A candidate sink is a node that cannot be excluded from `sinkType` based on its
   * characteristics.
   */
  predicate isSinkCandidate(Candidate::Endpoint candidateSink, Candidate::EndpointType sinkType) {
    not isNegative(sinkType) and
    not exists(getAReasonSinkExcluded(candidateSink, sinkType))
  }

  predicate hasMetadata(Candidate::Endpoint n, string metadata) {
    Candidate::hasMetadata(n, metadata)
  }

  /**
   * Gets the list of characteristics that cause `candidateSink` to be excluded as an effective sink for a given sink
   * type.
   */
  EndpointCharacteristic getAReasonSinkExcluded(
    Candidate::Endpoint candidateSink, Candidate::EndpointType sinkType
  ) {
    // An endpoint is a sink candidate if none of its characteristics give much indication whether or not it is a sink.
    not isNegative(sinkType) and
    result.appliesToEndpoint(candidateSink) and
    // Exclude endpoints that have a characteristic that implies they're not sinks for _any_ sink type.
    (
      exists(float confidence |
        confidence >= mediumConfidence() and
        result.hasImplications(any(Candidate::EndpointType t | isNegative(t)), true, confidence)
      )
      or
      // Exclude endpoints that have a characteristic that implies they're not sinks for _this particular_ sink type.
      exists(float confidence |
        confidence >= mediumConfidence() and
        result.hasImplications(sinkType, false, confidence)
      )
    )
  }

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
     * Holds for parameters that have this characteristic. This predicate contains the logic that applies characteristics
     * to the appropriate set of dataflow parameters.
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
   * Endpoints identified as sinks by the MaD modeling are sinks with maximal confidence.
   */
  private class KnownSinkCharacteristic extends SinkCharacteristic {
    string madLabel;
    Candidate::EndpointType endpointType;

    KnownSinkCharacteristic() { Candidate::isKnownLabel(madLabel, this, endpointType) }

    override predicate appliesToEndpoint(Candidate::Endpoint e) { Candidate::isSink(e, madLabel) }

    override Candidate::EndpointType getSinkType() { result = endpointType }
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
      Candidate::isNegative(endpointType) and
      isPositiveIndicator = true and
      confidence = highConfidence()
    }
  }

  /**
   * A negative characteristic that indicates that an endpoint is not part of the source code for the project being
   * analyzed.
   *
   * WARNING: These endpoints should not be used as negative samples for training, because they are not necessarily
   * non-sinks. They are merely not interesting sinks to run through the ML model.
   */
  private class IsExternalCharacteristic extends LikelyNotASinkCharacteristic {
    IsExternalCharacteristic() { this = "external" }

    override predicate appliesToEndpoint(Candidate::Endpoint e) {
      not exists(Candidate::getLocationString(e))
    }
  }

  /**
   * A negative characteristic that indicates that an endpoint was manually modeled as a neutral model.
   *
   * TODO: It may be necessary to turn this into a LikelyNotASinkCharacteristic, pending answers to the definition of a
   * neutral model (https://github.com/github/codeql-java-team/issues/254#issuecomment-1435309148).
   */
  private class NeutralModelCharacteristic extends NotASinkCharacteristic {
    NeutralModelCharacteristic() { this = "known non-sink" }

    override predicate appliesToEndpoint(Candidate::Endpoint e) { Candidate::isNeutral(e) }
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
      Candidate::isNegative(endpointType) and
      isPositiveIndicator = true and
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
      Candidate::isNegative(endpointType) and
      isPositiveIndicator = true and
      confidence = mediumConfidence()
    }
  }
}
