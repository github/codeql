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
private import AutomodelJavaUtil as AutomodelJavaUtil
private import AutomodelSharedGetCallable as AutomodelSharedGetCallable
import AutomodelSharedCharacteristics as SharedCharacteristics
import AutomodelEndpointTypes as AutomodelEndpointTypes

newtype JavaRelatedLocationType =
  MethodDoc() or
  ClassDoc()

newtype TFrameworkModeEndpoint =
  TExplicitParameter(Parameter p) or
  TQualifier(Callable c)

/**
 * A framework mode endpoint.
 */
abstract class FrameworkModeEndpoint extends TFrameworkModeEndpoint {
  /**
   * Returns the parameter index of the endpoint.
   */
  abstract int getIndex();

  /**
   * Returns the name of the parameter of the endpoint.
   */
  abstract string getParamName();

  /**
   * Returns the callable that contains the endpoint.
   */
  abstract Callable getEnclosingCallable();

  abstract Top asTop();

  string toString() { result = this.asTop().toString() }

  Location getLocation() { result = this.asTop().getLocation() }
}

class ExplicitParameterEndpoint extends FrameworkModeEndpoint, TExplicitParameter {
  Parameter param;

  ExplicitParameterEndpoint() { this = TExplicitParameter(param) and param.fromSource() }

  override int getIndex() { result = param.getPosition() }

  override string getParamName() { result = param.getName() }

  override Callable getEnclosingCallable() { result = param.getCallable() }

  override Top asTop() { result = param }
}

class QualifierEndpoint extends FrameworkModeEndpoint, TQualifier {
  Callable callable;

  QualifierEndpoint() {
    this = TQualifier(callable) and not callable.isStatic() and callable.fromSource()
  }

  override int getIndex() { result = -1 }

  override string getParamName() { result = "this" }

  override Callable getEnclosingCallable() { result = callable }

  override Top asTop() { result = callable }
}

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
  class Endpoint = FrameworkModeEndpoint;

  class EndpointType = AutomodelEndpointTypes::EndpointType;

  class NegativeEndpointType = AutomodelEndpointTypes::NegativeSinkType;

  class RelatedLocation = Location::Top;

  class RelatedLocationType = JavaRelatedLocationType;

  // Sanitizers are currently not modeled in MaD. TODO: check if this has large negative impact.
  predicate isSanitizer(Endpoint e, EndpointType t) { none() }

  RelatedLocation asLocation(Endpoint e) { result = e.asTop() }

  predicate isKnownKind = AutomodelJavaUtil::isKnownKind/2;

  predicate isSink(Endpoint e, string kind, string provenance) {
    exists(string package, string type, string name, string signature, string ext, string input |
      sinkSpec(e, package, type, name, signature, ext, input) and
      ExternalFlow::sinkModel(package, type, _, name, [signature, ""], ext, input, kind, provenance)
    )
  }

  predicate isNeutral(Endpoint e) {
    exists(string package, string type, string name, string signature |
      sinkSpec(e, package, type, name, signature, _, _) and
      ExternalFlow::neutralModel(package, type, name, [signature, ""], "sink", _)
    )
  }

  additional predicate sinkSpec(
    Endpoint e, string package, string type, string name, string signature, string ext, string input
  ) {
    FrameworkModeGetCallable::getCallable(e).hasQualifiedName(package, type, name) and
    signature = ExternalFlow::paramsString(FrameworkModeGetCallable::getCallable(e)) and
    ext = "" and
    input = AutomodelJavaUtil::getArgumentForIndex(e.getIndex())
  }

  /**
   * Gets the related location for the given endpoint.
   *
   * Related locations can be JavaDoc comments of the class or the method.
   */
  RelatedLocation getRelatedLocation(Endpoint e, RelatedLocationType type) {
    type = MethodDoc() and
    result = FrameworkModeGetCallable::getCallable(e).(Documentable).getJavadoc()
    or
    type = ClassDoc() and
    result = FrameworkModeGetCallable::getCallable(e).getDeclaringType().(Documentable).getJavadoc()
  }
}

private class JavaCallable = Callable;

private module FrameworkModeGetCallable implements AutomodelSharedGetCallable::GetCallableSig {
  class Callable = JavaCallable;

  class Endpoint = FrameworkCandidatesImpl::Endpoint;

  /**
   * Returns the callable that contains the given endpoint.
   *
   * Each Java mode should implement this predicate.
   */
  Callable getCallable(Endpoint e) { result = e.getEnclosingCallable() }
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
class FrameworkModeMetadataExtractor extends string {
  FrameworkModeMetadataExtractor() { this = "FrameworkModeMetadataExtractor" }

  predicate hasMetadata(
    Endpoint e, string package, string type, string subtypes, string name, string signature,
    string input, string parameterName
  ) {
    parameterName = e.getParamName() and
    name = e.getEnclosingCallable().getName() and
    input = AutomodelJavaUtil::getArgumentForIndex(e.getIndex()) and
    package = e.getEnclosingCallable().getDeclaringType().getPackage().getName() and
    type = e.getEnclosingCallable().getDeclaringType().getErasure().(RefType).nestedName() and
    subtypes = AutomodelJavaUtil::considerSubtypes(e.getEnclosingCallable()).toString() and
    signature = ExternalFlow::paramsString(e.getEnclosingCallable())
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
    not FrameworkCandidatesImpl::isSink(e, _, _) and
    FrameworkModeGetCallable::getCallable(e).getName().matches("is%") and
    FrameworkModeGetCallable::getCallable(e).getReturnType() instanceof BooleanType
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
    not FrameworkCandidatesImpl::isSink(e, _, _) and
    exists(Callable callable |
      callable = FrameworkModeGetCallable::getCallable(e) and
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
    FrameworkModeGetCallable::getCallable(e).getDeclaringType().getASupertype*() instanceof
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
    not e.getEnclosingCallable() instanceof ModelExclusions::ModelApi
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
    not FrameworkModeGetCallable::getCallable(e).isPublic()
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
