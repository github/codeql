/**
 * For internal use only.
 */

private import java
private import semmle.code.Location as Location
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.PathCreation
private import semmle.code.java.dataflow.ExternalFlow as ExternalFlow
private import semmle.code.java.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.java.security.ExternalAPIs as ExternalAPIs
private import semmle.code.java.Expr as Expr
private import semmle.code.java.security.QueryInjection
private import semmle.code.java.security.RequestForgery
private import semmle.code.java.dataflow.internal.ModelExclusions as ModelExclusions
import AutomodelSharedCharacteristics as SharedCharacteristics
import AutomodelEndpointTypes as AutomodelEndpointTypes

/**
 * A meta data extractor. Any Java extraction mode needs to implement exactly
 * one instance of this class.
 */
abstract class MetadataExtractor extends string {
  bindingset[this]
  MetadataExtractor() { any() }

  abstract predicate hasMetadata(
    DataFlow::ParameterNode e, string package, string type, boolean subtypes, string name,
    string signature, int input, string parameterName
  );
}

newtype JavaRelatedLocationType =
  MethodDoc() or
  ClassDoc()

/**
 * A candidates implementation for framework mode.
 *
 * Some important notes:
 *  - This mode is using parameters as endpoints.
 *  - Sink- and neutral-information is being used from MaD models.
 *  - When available, we use method- and class-java-docs as related locations.
 */
module FrameworkCandidatesImpl implements SharedCharacteristics::CandidateSig {
  // for documentation of the implementations here, see the QLDoc in the CandidateSig signature module.
  class Endpoint = DataFlow::ParameterNode;

  class EndpointType = AutomodelEndpointTypes::EndpointType;

  class NegativeEndpointType = AutomodelEndpointTypes::NegativeSinkType;

  class RelatedLocation = Location::Top;

  class RelatedLocationType = JavaRelatedLocationType;

  // Sanitizers are currently not modeled in MaD. TODO: check if this has large negative impact.
  predicate isSanitizer(Endpoint e, EndpointType t) { none() }

  RelatedLocation asLocation(Endpoint e) { result = e.asParameter() }

  predicate isKnownKind(string kind, string humanReadableKind, EndpointType type) {
    kind = "read-file" and
    humanReadableKind = "read file" and
    type instanceof AutomodelEndpointTypes::TaintedPathSinkType
    or
    kind = "create-file" and
    humanReadableKind = "create file" and
    type instanceof AutomodelEndpointTypes::TaintedPathSinkType
    or
    kind = "sql" and
    humanReadableKind = "mad modeled sql" and
    type instanceof AutomodelEndpointTypes::SqlSinkType
    or
    kind = "open-url" and
    humanReadableKind = "open url" and
    type instanceof AutomodelEndpointTypes::RequestForgerySinkType
    or
    kind = "jdbc-url" and
    humanReadableKind = "jdbc url" and
    type instanceof AutomodelEndpointTypes::RequestForgerySinkType
    or
    kind = "command-injection" and
    humanReadableKind = "command injection" and
    type instanceof AutomodelEndpointTypes::CommandInjectionSinkType
  }

  predicate isSink(Endpoint e, string kind) {
    exists(string package, string type, string name, string signature, string ext, string input |
      sinkSpec(e, package, type, name, signature, ext, input) and
      ExternalFlow::sinkModel(package, type, _, name, [signature, ""], ext, input, kind, _)
    )
  }

  predicate isNeutral(Endpoint e) {
    exists(string package, string type, string name, string signature |
      sinkSpec(e, package, type, name, signature, _, _) and
      ExternalFlow::neutralModel(package, type, name, [signature, ""], _, _)
    )
  }

  additional predicate sinkSpec(
    Endpoint e, string package, string type, string name, string signature, string ext, string input
  ) {
    FrameworkCandidatesImpl::getCallable(e).hasQualifiedName(package, type, name) and
    signature = ExternalFlow::paramsString(getCallable(e)) and
    ext = "" and
    exists(int paramIdx | e.isParameterOf(_, paramIdx) |
      if paramIdx = -1 then input = "Argument[this]" else input = "Argument[" + paramIdx + "]"
    )
  }

  /**
   * Returns the related location for the given endpoint.
   *
   * Related locations can be JavaDoc comments of the class or the method.
   */
  RelatedLocation getRelatedLocation(Endpoint e, RelatedLocationType type) {
    type = MethodDoc() and
    result = FrameworkCandidatesImpl::getCallable(e).(Documentable).getJavadoc()
    or
    type = ClassDoc() and
    result = FrameworkCandidatesImpl::getCallable(e).getDeclaringType().(Documentable).getJavadoc()
  }

  /**
   * Returns the callable that contains the given endpoint.
   *
   * Each Java mode should implement this predicate.
   */
  additional Callable getCallable(Endpoint e) { result = e.getEnclosingCallable() }
}

module CharacteristicsImpl = SharedCharacteristics::SharedCharacteristics<FrameworkCandidatesImpl>;

class EndpointCharacteristic = CharacteristicsImpl::EndpointCharacteristic;

class Endpoint = FrameworkCandidatesImpl::Endpoint;

/*
 * Predicates that are used to surface prompt examples and candidates for classification with an ML model.
 */

/**
 * A MetadataExtractor that extracts metadata for framework mode.
 */
class FrameworkModeMetadataExtractor extends MetadataExtractor {
  FrameworkModeMetadataExtractor() { this = "FrameworkModeMetadataExtractor" }

  /**
   * By convention, the subtypes property of the MaD declaration should only be
   * true when there _can_ exist any subtypes with a different implementation.
   *
   * It would technically be ok to always use the value 'true', but this would
   * break convention.
   */
  boolean considerSubtypes(Callable callable) {
    if
      callable.isStatic() or
      callable.getDeclaringType().isStatic() or
      callable.isFinal() or
      callable.getDeclaringType().isFinal()
    then result = false
    else result = true
  }

  override predicate hasMetadata(
    Endpoint e, string package, string type, boolean subtypes, string name, string signature,
    int input, string parameterName
  ) {
    exists(Callable callable |
      e.asParameter() = callable.getParameter(input) and
      package = callable.getDeclaringType().getPackage().getName() and
      type = callable.getDeclaringType().getErasure().(RefType).nestedName() and
      subtypes = this.considerSubtypes(callable) and
      name = callable.getName() and
      parameterName = e.asParameter().getName() and
      signature = ExternalFlow::paramsString(callable)
    )
  }
}

/*
 * EndpointCharacteristic classes that are specific to Automodel for Java.
 */

/**
 * A negative characteristic that indicates that an is-style boolean method is unexploitable even if it is a sink.
 *
 * A sink is highly unlikely to be exploitable if its callable's name starts with `is` and the callable has a boolean return
 * type (e.g. `isDirectory`). These kinds of calls normally do only checks, and appear before the proper call that does
 * the dangerous/interesting thing, so we want the latter to be modeled as the sink.
 *
 * TODO: this might filter too much, it's possible that methods with more than one parameter contain interesting sinks
 */
private class UnexploitableIsCharacteristic extends CharacteristicsImpl::NotASinkCharacteristic {
  UnexploitableIsCharacteristic() { this = "unexploitable (is-style boolean method)" }

  override predicate appliesToEndpoint(Endpoint e) {
    not FrameworkCandidatesImpl::isSink(e, _) and
    FrameworkCandidatesImpl::getCallable(e).getName().matches("is%") and
    FrameworkCandidatesImpl::getCallable(e).getReturnType() instanceof BooleanType
  }
}

/**
 * A negative characteristic that indicates that an existence-checking boolean method is unexploitable even if it is a
 * sink.
 *
 * A sink is highly unlikely to be exploitable if its callable's name is `exists` or `notExists` and the callable has a
 * boolean return type. These kinds of calls normally do only checks, and appear before the proper call that does the
 * dangerous/interesting thing, so we want the latter to be modeled as the sink.
 */
private class UnexploitableExistsCharacteristic extends CharacteristicsImpl::NotASinkCharacteristic {
  UnexploitableExistsCharacteristic() { this = "unexploitable (existence-checking boolean method)" }

  override predicate appliesToEndpoint(Endpoint e) {
    not FrameworkCandidatesImpl::isSink(e, _) and
    exists(Callable callable |
      callable = FrameworkCandidatesImpl::getCallable(e) and
      callable.getName().toLowerCase() = ["exists", "notexists"] and
      callable.getReturnType() instanceof BooleanType
    )
  }
}

/**
 * A negative characteristic that indicates that an endpoint is an argument to an exception, which is not a sink.
 */
private class ExceptionCharacteristic extends CharacteristicsImpl::NotASinkCharacteristic {
  ExceptionCharacteristic() { this = "exception" }

  override predicate appliesToEndpoint(Endpoint e) {
    FrameworkCandidatesImpl::getCallable(e).getDeclaringType().getASupertype*() instanceof
      TypeThrowable
  }
}

/**
 * A characteristic that limits candidates to parameters of methods that are recognized as `ModelApi`, iow., APIs that
 * are considered worth modeling.
 */
private class NotAModelApiParameter extends CharacteristicsImpl::UninterestingToModelCharacteristic {
  NotAModelApiParameter() { this = "not a model API parameter" }

  override predicate appliesToEndpoint(Endpoint e) {
    not exists(ModelExclusions::ModelApi api | api.getAParameter() = e.asParameter())
  }
}

/**
 * A negative characteristic that filters out non-public methods. Non-public methods are not interesting to include in
 * the standard Java modeling, because they cannot be called from outside the package.
 */
private class NonPublicMethodCharacteristic extends CharacteristicsImpl::UninterestingToModelCharacteristic
{
  NonPublicMethodCharacteristic() { this = "non-public method" }

  override predicate appliesToEndpoint(Endpoint e) {
    not FrameworkCandidatesImpl::getCallable(e).isPublic()
  }
}

/**
 * Holds if the given endpoint has a self-contradictory combination of characteristics. Detects errors in our endpoint
 * characteristics. Lists the problematic characteristics and their implications for all such endpoints, together with
 * an error message indicating why this combination is problematic.
 *
 * Copied from
 *   javascript/ql/experimental/adaptivethreatmodeling/test/endpoint_large_scale/ContradictoryEndpointCharacteristics.ql
 */
predicate erroneousEndpoints(
  Endpoint endpoint, EndpointCharacteristic characteristic,
  AutomodelEndpointTypes::EndpointType endpointType, float confidence, string errorMessage,
  boolean ignoreKnownModelingErrors
) {
  // An endpoint's characteristics should not include positive indicators with medium/high confidence for more than one
  // sink/source type (including the negative type).
  exists(
    EndpointCharacteristic characteristic2, AutomodelEndpointTypes::EndpointType endpointClass2,
    float confidence2
  |
    endpointType != endpointClass2 and
    (
      endpointType instanceof AutomodelEndpointTypes::SinkType and
      endpointClass2 instanceof AutomodelEndpointTypes::SinkType
      or
      endpointType instanceof AutomodelEndpointTypes::SourceType and
      endpointClass2 instanceof AutomodelEndpointTypes::SourceType
    ) and
    characteristic.appliesToEndpoint(endpoint) and
    characteristic2.appliesToEndpoint(endpoint) and
    characteristic.hasImplications(endpointType, true, confidence) and
    characteristic2.hasImplications(endpointClass2, true, confidence2) and
    confidence > SharedCharacteristics::mediumConfidence() and
    confidence2 > SharedCharacteristics::mediumConfidence() and
    (
      ignoreKnownModelingErrors = true and
      not knownOverlappingCharacteristics(characteristic, characteristic2)
      or
      ignoreKnownModelingErrors = false
    )
  ) and
  errorMessage = "Endpoint has high-confidence positive indicators for multiple classes"
  or
  // An endpoint's characteristics should not include positive indicators with medium/high confidence for some class and
  // also include negative indicators with medium/high confidence for this same class.
  exists(EndpointCharacteristic characteristic2, float confidence2 |
    characteristic.appliesToEndpoint(endpoint) and
    characteristic2.appliesToEndpoint(endpoint) and
    characteristic.hasImplications(endpointType, true, confidence) and
    characteristic2.hasImplications(endpointType, false, confidence2) and
    confidence > SharedCharacteristics::mediumConfidence() and
    confidence2 > SharedCharacteristics::mediumConfidence()
  ) and
  ignoreKnownModelingErrors = false and
  errorMessage = "Endpoint has high-confidence positive and negative indicators for the same class"
}

/**
 * Holds if `characteristic1` and `characteristic2` are among the pairs of currently known positive characteristics that
 * have some overlap in their results. This indicates a problem with the underlying Java modeling. Specifically,
 * `PathCreation` is prone to FPs.
 */
private predicate knownOverlappingCharacteristics(
  EndpointCharacteristic characteristic1, EndpointCharacteristic characteristic2
) {
  characteristic1 != characteristic2 and
  characteristic1 = ["mad taint step", "create path", "read file", "known non-sink"] and
  characteristic2 = ["mad taint step", "create path", "read file", "known non-sink"]
}
