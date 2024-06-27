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
import AutomodelSharedCharacteristics as SharedCharacteristics
import AutomodelEndpointTypes as AutomodelEndpointTypes

newtype JavaRelatedLocationType =
  MethodDoc() or
  ClassDoc()

newtype TFrameworkModeEndpoint =
  TExplicitParameter(Parameter p) {
    AutomodelJavaUtil::isFromSource(p) and
    not AutomodelJavaUtil::isUnexploitableType(p.getType())
  } or
  TQualifier(Callable c) { AutomodelJavaUtil::isFromSource(c) and not c instanceof Constructor } or
  TReturnValue(Callable c) {
    AutomodelJavaUtil::isFromSource(c) and
    c instanceof Constructor
    or
    AutomodelJavaUtil::isFromSource(c) and
    c instanceof Method and
    not AutomodelJavaUtil::isUnexploitableType(c.getReturnType())
  } or
  TOverridableParameter(Method m, Parameter p) {
    AutomodelJavaUtil::isFromSource(p) and
    not AutomodelJavaUtil::isUnexploitableType(p.getType()) and
    p.getCallable() = m and
    m instanceof ModelExclusions::ModelApi and
    AutomodelJavaUtil::isOverridable(m)
  } or
  TOverridableQualifier(Method m) {
    AutomodelJavaUtil::isFromSource(m) and
    m instanceof ModelExclusions::ModelApi and
    AutomodelJavaUtil::isOverridable(m)
  }

/**
 * A framework mode endpoint.
 */
abstract class FrameworkModeEndpoint extends TFrameworkModeEndpoint {
  /**
   * Gets the input (if any) for this endpoint, eg.: `Argument[0]`.
   *
   * For endpoints that are source candidates, this will be `none()`.
   */
  abstract string getMaDInput();

  /**
   * Gets the output (if any) for this endpoint, eg.: `ReturnValue`.
   *
   * For endpoints that are sink candidates, this will be `none()`.
   */
  abstract string getMaDOutput();

  /**
   * Returns the name of the parameter of the endpoint.
   */
  abstract string getParamName();

  /**
   * Returns the callable that contains the endpoint.
   */
  abstract Callable getCallable();

  abstract Top asTop();

  abstract string getExtensibleType();

  string toString() { result = this.asTop().toString() }

  Location getLocation() { result = this.asTop().getLocation() }
}

class ExplicitParameterEndpoint extends FrameworkModeEndpoint, TExplicitParameter {
  Parameter param;

  ExplicitParameterEndpoint() { this = TExplicitParameter(param) and param.fromSource() }

  override string getMaDInput() { result = "Argument[" + param.getPosition() + "]" }

  override string getMaDOutput() { none() }

  override string getParamName() { result = param.getName() }

  override Callable getCallable() { result = param.getCallable() }

  override Top asTop() { result = param }

  override string getExtensibleType() { result = "sinkModel" }
}

class QualifierEndpoint extends FrameworkModeEndpoint, TQualifier {
  Callable callable;

  QualifierEndpoint() {
    this = TQualifier(callable) and not callable.isStatic() and callable.fromSource()
  }

  override string getMaDInput() { result = "Argument[this]" }

  override string getMaDOutput() { none() }

  override string getParamName() { result = "this" }

  override Callable getCallable() { result = callable }

  override Top asTop() { result = callable }

  override string getExtensibleType() { result = "sinkModel" }
}

class ReturnValue extends FrameworkModeEndpoint, TReturnValue {
  Callable callable;

  ReturnValue() { this = TReturnValue(callable) and callable.fromSource() }

  override string getMaDInput() { none() }

  override string getMaDOutput() { result = "ReturnValue" }

  override string getParamName() { none() }

  override Callable getCallable() { result = callable }

  override Top asTop() { result = callable }

  override string getExtensibleType() { result = "sourceModel" }
}

class OverridableParameter extends FrameworkModeEndpoint, TOverridableParameter {
  Method method;
  Parameter param;

  OverridableParameter() { this = TOverridableParameter(method, param) }

  override string getMaDInput() { none() }

  override string getMaDOutput() { result = "Parameter[" + param.getPosition() + "]" }

  override string getParamName() { result = param.getName() }

  override Callable getCallable() { result = method }

  override Top asTop() { result = param }

  override string getExtensibleType() { result = "sourceModel" }
}

class OverridableQualifier extends FrameworkModeEndpoint, TOverridableQualifier {
  Method m;

  OverridableQualifier() { this = TOverridableQualifier(m) }

  override string getMaDInput() { none() }

  override string getMaDOutput() { result = "Parameter[this]" }

  override string getParamName() { result = "this" }

  override Callable getCallable() { result = m }

  override Top asTop() { result = m }

  override string getExtensibleType() { result = "sourceModel" }
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

  class SinkType = AutomodelEndpointTypes::SinkType;

  class SourceType = AutomodelEndpointTypes::SourceType;

  class RelatedLocation = Location::Top;

  class RelatedLocationType = JavaRelatedLocationType;

  // Sanitizers are currently not modeled in MaD. TODO: check if this has large negative impact.
  predicate isSanitizer(Endpoint e, EndpointType t) { none() }

  RelatedLocation asLocation(Endpoint e) { result = e.asTop() }

  predicate isKnownKind = AutomodelJavaUtil::isKnownKind/2;

  predicate isSink(Endpoint e, string kind, string provenance) {
    exists(
      string package, string type, boolean subtypes, string name, string signature, string ext,
      string input
    |
      sinkSpec(e, package, type, subtypes, name, signature, ext, input) and
      ExternalFlow::sinkModel(package, type, subtypes, name, [signature, ""], ext, input, kind,
        provenance, _)
    )
  }

  predicate isSource(Endpoint e, string kind, string provenance) {
    exists(
      string package, string type, boolean subtypes, string name, string signature, string ext,
      string output
    |
      sourceSpec(e, package, type, subtypes, name, signature, ext, output) and
      ExternalFlow::sourceModel(package, type, subtypes, name, [signature, ""], ext, output, kind,
        provenance, _)
    )
  }

  predicate isNeutral(Endpoint e) {
    exists(string package, string type, string name, string signature, string endpointType |
      sinkSpec(e, package, type, _, name, signature, _, _) and
      endpointType = "sink"
      or
      sourceSpec(e, package, type, _, name, signature, _, _) and
      endpointType = "source"
    |
      ExternalFlow::neutralModel(package, type, name, [signature, ""], endpointType, _)
    )
  }

  /**
   * Holds if the endpoint concerns a callable with the given package, type, name and signature.
   *
   * If `subtypes` is `false`, only the exact callable is considered. If `true`, the callable and
   * all its overrides are considered.
   */
  additional predicate endpointCallable(
    Endpoint e, string package, string type, boolean subtypes, string name, string signature
  ) {
    exists(Callable c |
      c = e.getCallable() and subtypes in [true, false]
      or
      e.getCallable().(Method).getSourceDeclaration().overrides+(c) and subtypes = true
    |
      c.hasQualifiedName(package, type, name) and
      signature = ExternalFlow::paramsString(c)
    )
  }

  additional predicate sinkSpec(
    Endpoint e, string package, string type, boolean subtypes, string name, string signature,
    string ext, string input
  ) {
    endpointCallable(e, package, type, subtypes, name, signature) and
    ext = "" and
    input = e.getMaDInput()
  }

  additional predicate sourceSpec(
    Endpoint e, string package, string type, boolean subtypes, string name, string signature,
    string ext, string output
  ) {
    endpointCallable(e, package, type, subtypes, name, signature) and
    ext = "" and
    output = e.getMaDOutput()
  }

  /**
   * Gets the related location for the given endpoint.
   *
   * Related locations can be JavaDoc comments of the class or the method.
   */
  RelatedLocation getRelatedLocation(Endpoint e, RelatedLocationType type) {
    type = MethodDoc() and
    result = e.getCallable().(Documentable).getJavadoc()
    or
    type = ClassDoc() and
    result = e.getCallable().getDeclaringType().(Documentable).getJavadoc()
  }
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
    string input, string output, string parameterName, string alreadyAiModeled,
    string extensibleType
  ) {
    exists(Callable callable | e.getCallable() = callable |
      (if exists(e.getMaDInput()) then input = e.getMaDInput() else input = "") and
      (if exists(e.getMaDOutput()) then output = e.getMaDOutput() else output = "") and
      package = callable.getDeclaringType().getPackage().getName() and
      // we're using the erased types because the MaD convention is to not specify type parameters.
      // Whether something is or isn't a sink doesn't usually depend on the type parameters.
      type = callable.getDeclaringType().getErasure().(RefType).nestedName() and
      subtypes = AutomodelJavaUtil::considerSubtypes(callable).toString() and
      name = callable.getName() and
      signature = ExternalFlow::paramsString(callable) and
      (if exists(e.getParamName()) then parameterName = e.getParamName() else parameterName = "") and
      e.getExtensibleType() = extensibleType
    ) and
    (
      not CharacteristicsImpl::isModeled(e, _, extensibleType, _) and alreadyAiModeled = ""
      or
      CharacteristicsImpl::isModeled(e, _, extensibleType, alreadyAiModeled)
    )
  }
}

/**
 * Holds if the given `endpoint` should be considered a candidate for the `extensibleType`.
 *
 * The other parameters record various other properties of interest.
 */
predicate isCandidate(
  Endpoint endpoint, string package, string type, string subtypes, string name, string signature,
  string input, string output, string parameterName, string extensibleType, string alreadyAiModeled
) {
  CharacteristicsImpl::isCandidate(endpoint, _) and
  not exists(CharacteristicsImpl::UninterestingToModelCharacteristic u |
    u.appliesToEndpoint(endpoint)
  ) and
  any(FrameworkModeMetadataExtractor meta)
      .hasMetadata(endpoint, package, type, subtypes, name, signature, input, output, parameterName,
        alreadyAiModeled, extensibleType) and
  // If a node is already modeled in MaD, we don't include it as a candidate. Otherwise, we might include it as a
  // candidate for query A, but the model will label it as a sink for one of the sink types of query B, for which it's
  // already a known sink. This would result in overlap between our detected sinks and the pre-existing modeling. We
  // assume that, if a sink has already been modeled in a MaD model, then it doesn't belong to any additional sink
  // types, and we don't need to reexamine it.
  alreadyAiModeled.matches(["", "%ai-%"]) and
  AutomodelJavaUtil::includeAutomodelCandidate(package, type, name, signature)
}

/**
 * Holds if the given `endpoint` is a negative example for the `extensibleType`
 * because of the `characteristic`.
 *
 * The other parameters record various other properties of interest.
 */
predicate isNegativeExample(
  Endpoint endpoint, EndpointCharacteristic characteristic, float confidence, string package,
  string type, string subtypes, string name, string signature, string input, string output,
  string parameterName, string extensibleType
) {
  characteristic.appliesToEndpoint(endpoint) and
  // the node is known not to be an endpoint of any appropriate type
  forall(AutomodelEndpointTypes::EndpointType tp |
    tp = CharacteristicsImpl::getAPotentialType(endpoint)
  |
    characteristic.hasImplications(tp, false, _)
  ) and
  // the lowest confidence across all endpoint types should be at least highConfidence
  confidence =
    min(float c |
      characteristic.hasImplications(CharacteristicsImpl::getAPotentialType(endpoint), false, c)
    ) and
  confidence >= SharedCharacteristics::highConfidence() and
  any(FrameworkModeMetadataExtractor meta)
      .hasMetadata(endpoint, package, type, subtypes, name, signature, input, output, parameterName,
        _, extensibleType) and
  // It's valid for a node to be both a potential source/sanitizer and a sink. We don't want to include such nodes
  // as negative examples in the prompt, because they're ambiguous and might confuse the model, so we explicitly exclude them here.
  not exists(EndpointCharacteristic characteristic2, float confidence2 |
    characteristic2 != characteristic
  |
    characteristic2.appliesToEndpoint(endpoint) and
    confidence2 >= SharedCharacteristics::maximalConfidence() and
    characteristic2
        .hasImplications(CharacteristicsImpl::getAPotentialType(endpoint), true, confidence2)
  )
}

/**
 * Holds if the given `endpoint` is a positive example for the `endpointType`.
 *
 * The other parameters record various other properties of interest.
 */
predicate isPositiveExample(
  Endpoint endpoint, string endpointType, string package, string type, string subtypes, string name,
  string signature, string input, string output, string parameterName, string extensibleType
) {
  any(FrameworkModeMetadataExtractor meta)
      .hasMetadata(endpoint, package, type, subtypes, name, signature, input, output, parameterName,
        _, extensibleType) and
  CharacteristicsImpl::isKnownAs(endpoint, endpointType, _)
}

/*
 * EndpointCharacteristic classes that are specific to Automodel for Java.
 */

/**
 * A negative characteristic that indicates that parameters of an is-style boolean method should not be considered sinks,
 * and its return value should not be considered a source.
 *
 * A sink is highly unlikely to be exploitable if its callable's name starts with `is` and the callable has a boolean return
 * type (e.g. `isDirectory`). These kinds of calls normally do only checks, and appear before the proper call that does
 * the dangerous/interesting thing, so we want the latter to be modeled as the sink.
 *
 * TODO: this might filter too much, it's possible that methods with more than one parameter contain interesting sinks
 */
private class UnexploitableIsCharacteristic extends CharacteristicsImpl::NeitherSourceNorSinkCharacteristic
{
  UnexploitableIsCharacteristic() { this = "argument of is-style boolean method" }

  override predicate appliesToEndpoint(Endpoint e) {
    e.getCallable().getName().matches("is%") and
    e.getCallable().getReturnType() instanceof BooleanType and
    (
      e.getExtensibleType() = "sinkModel" and
      not FrameworkCandidatesImpl::isSink(e, _, _)
      or
      e.getExtensibleType() = "sourceModel" and
      not FrameworkCandidatesImpl::isSource(e, _, _) and
      e.getMaDOutput() = "ReturnValue"
    )
  }
}

/**
 * A negative characteristic that indicates that parameters of an existence-checking boolean method should not be
 * considered sinks, and its return value should not be considered a source.
 *
 * A sink is highly unlikely to be exploitable if its callable's name is `exists` or `notExists` and the callable has a
 * boolean return type. These kinds of calls normally do only checks, and appear before the proper call that does the
 * dangerous/interesting thing, so we want the latter to be modeled as the sink.
 */
private class UnexploitableExistsCharacteristic extends CharacteristicsImpl::NeitherSourceNorSinkCharacteristic
{
  UnexploitableExistsCharacteristic() { this = "argument of existence-checking boolean method" }

  override predicate appliesToEndpoint(Endpoint e) {
    exists(Callable callable |
      callable = e.getCallable() and
      callable.getName().toLowerCase() = ["exists", "notexists"] and
      callable.getReturnType() instanceof BooleanType
    |
      e.getExtensibleType() = "sinkModel" and
      not FrameworkCandidatesImpl::isSink(e, _, _)
      or
      e.getExtensibleType() = "sourceModel" and
      not FrameworkCandidatesImpl::isSource(e, _, _) and
      e.getMaDOutput() = "ReturnValue"
    )
  }
}

/**
 * A negative characteristic that indicates that parameters of an exception method or constructor should not be considered sinks,
 * and its return value should not be considered a source.
 */
private class ExceptionCharacteristic extends CharacteristicsImpl::NeitherSourceNorSinkCharacteristic
{
  ExceptionCharacteristic() { this = "argument/result of exception-related method" }

  override predicate appliesToEndpoint(Endpoint e) {
    e.getCallable().getDeclaringType().getASupertype*() instanceof TypeThrowable and
    (
      e.getExtensibleType() = "sinkModel" and
      not FrameworkCandidatesImpl::isSink(e, _, _)
      or
      e.getExtensibleType() = "sourceModel" and
      not FrameworkCandidatesImpl::isSource(e, _, _) and
      e.getMaDOutput() = "ReturnValue"
    )
  }
}

/**
 * A characteristic that limits candidates to parameters of methods that are recognized as `ModelApi`, iow., APIs that
 * are considered worth modeling.
 */
private class NotAModelApi extends CharacteristicsImpl::UninterestingToModelCharacteristic {
  NotAModelApi() { this = "not a model API" }

  override predicate appliesToEndpoint(Endpoint e) {
    not e.getCallable() instanceof ModelExclusions::ModelApi
  }
}
