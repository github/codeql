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
private import semmle.code.java.security.PathSanitizer as PathSanitizer
private import AutomodelSharedGetCallable as AutomodelSharedGetCallable
import AutomodelSharedCharacteristics as SharedCharacteristics
import AutomodelEndpointTypes as AutomodelEndpointTypes

newtype JavaRelatedLocationType = CallContext()

/**
 * A class representing nodes that are arguments to calls.
 */
private class ArgumentNode extends DataFlow::Node {
  ArgumentNode() { this.asExpr() = [any(Call c).getAnArgument(), any(Call c).getQualifier()] }
}

/**
 * A candidates implementation.
 *
 * Some important notes:
 *  - This mode is using arguments as endpoints.
 *  - We use the `CallContext` (the surrounding call expression) as related location.
 */
module ApplicationCandidatesImpl implements SharedCharacteristics::CandidateSig {
  // for documentation of the implementations here, see the QLDoc in the CandidateSig signature module.
  class Endpoint = ArgumentNode;

  class EndpointType = AutomodelEndpointTypes::EndpointType;

  class NegativeEndpointType = AutomodelEndpointTypes::NegativeSinkType;

  class RelatedLocation = Location::Top;

  class RelatedLocationType = JavaRelatedLocationType;

  // Sanitizers are currently not modeled in MaD. TODO: check if this has large negative impact.
  predicate isSanitizer(Endpoint e, EndpointType t) {
    exists(t) and
    (
      e.getType() instanceof BoxedType
      or
      e.getType() instanceof PrimitiveType
      or
      e.getType() instanceof NumberType
    )
    or
    t instanceof AutomodelEndpointTypes::PathInjectionSinkType and
    e instanceof PathSanitizer::PathInjectionSanitizer
  }

  RelatedLocation asLocation(Endpoint e) { result = e.asExpr() }

  predicate isKnownKind = AutomodelJavaUtil::isKnownKind/2;

  predicate isSink(Endpoint e, string kind) {
    exists(string package, string type, string name, string signature, string ext, string input |
      sinkSpec(e, package, type, name, signature, ext, input) and
      ExternalFlow::sinkModel(package, type, _, name, [signature, ""], ext, input, kind, _)
    )
    or
    isCustomSink(e, kind)
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
    ApplicationModeGetCallable::getCallable(e).hasQualifiedName(package, type, name) and
    signature = ExternalFlow::paramsString(ApplicationModeGetCallable::getCallable(e)) and
    ext = "" and
    (
      exists(Call c, int argIdx |
        e.asExpr() = c.getArgument(argIdx) and
        input = AutomodelJavaUtil::getArgumentForIndex(argIdx)
      )
      or
      exists(Call c |
        e.asExpr() = c.getQualifier() and input = AutomodelJavaUtil::getArgumentForIndex(-1)
      )
    )
  }

  /**
   * Gets the related location for the given endpoint.
   *
   * The only related location we model is the the call expression surrounding to
   * which the endpoint is either argument or qualifier (known as the call context).
   */
  RelatedLocation getRelatedLocation(Endpoint e, RelatedLocationType type) {
    type = CallContext() and
    result = any(Call c | e.asExpr() = [c.getAnArgument(), c.getQualifier()])
  }
}

private class JavaCallable = Callable;

private module ApplicationModeGetCallable implements AutomodelSharedGetCallable::GetCallableSig {
  class Callable = JavaCallable;

  class Endpoint = ApplicationCandidatesImpl::Endpoint;

  /**
   * Returns the API callable being modeled.
   */
  Callable getCallable(Endpoint e) {
    exists(Call c |
      e.asExpr() = [c.getAnArgument(), c.getQualifier()] and
      result = c.getCallee()
    )
  }
}

/**
 * Contains endpoints that are defined in QL code rather than as a MaD model. Ideally this predicate
 * should be empty.
 */
private predicate isCustomSink(Endpoint e, string kind) {
  e.asExpr() instanceof ArgumentToExec and kind = "command injection"
  or
  e instanceof RequestForgerySink and kind = "request forgery"
  or
  e instanceof QueryInjectionSink and kind = "sql"
}

module CharacteristicsImpl =
  SharedCharacteristics::SharedCharacteristics<ApplicationCandidatesImpl>;

class EndpointCharacteristic = CharacteristicsImpl::EndpointCharacteristic;

class Endpoint = ApplicationCandidatesImpl::Endpoint;

/*
 * Predicates that are used to surface prompt examples and candidates for classification with an ML model.
 */

/**
 * A MetadataExtractor that extracts metadata for application mode.
 */
class ApplicationModeMetadataExtractor extends string {
  ApplicationModeMetadataExtractor() { this = "ApplicationModeMetadataExtractor" }

  predicate hasMetadata(
    Endpoint e, string package, string type, string subtypes, string name, string signature,
    string input
  ) {
    exists(Call call, Callable callable, int argIdx |
      call.getCallee() = callable and
      (
        e.asExpr() = call.getArgument(argIdx)
        or
        e.asExpr() = call.getQualifier() and argIdx = -1
      ) and
      input = AutomodelJavaUtil::getArgumentForIndex(argIdx) and
      package = callable.getDeclaringType().getPackage().getName() and
      // we're using the erased types because the MaD convention is to not specify type parameters.
      // Whether something is or isn't a sink doesn't usually depend on the type parameters.
      type = callable.getDeclaringType().getErasure().(RefType).nestedName() and
      subtypes = AutomodelJavaUtil::considerSubtypes(callable).toString() and
      name = callable.getName() and
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
    not ApplicationCandidatesImpl::isSink(e, _) and
    ApplicationModeGetCallable::getCallable(e).getName().matches("is%") and
    ApplicationModeGetCallable::getCallable(e).getReturnType() instanceof BooleanType
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
    not ApplicationCandidatesImpl::isSink(e, _) and
    exists(Callable callable |
      callable = ApplicationModeGetCallable::getCallable(e) and
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
    ApplicationModeGetCallable::getCallable(e).getDeclaringType().getASupertype*() instanceof
      TypeThrowable
  }
}

/**
 * A negative characteristic that indicates that an endpoint is a MaD taint step. MaD modeled taint steps are global,
 * so they are not sinks for any query. Non-MaD taint steps might be specific to a particular query, so we don't
 * filter those out.
 */
private class IsMaDTaintStepCharacteristic extends CharacteristicsImpl::NotASinkCharacteristic {
  IsMaDTaintStepCharacteristic() { this = "taint step" }

  override predicate appliesToEndpoint(Endpoint e) {
    FlowSummaryImpl::Private::Steps::summaryThroughStepValue(e, _, _) or
    FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(e, _, _) or
    FlowSummaryImpl::Private::Steps::summaryGetterStep(e, _, _, _) or
    FlowSummaryImpl::Private::Steps::summarySetterStep(e, _, _, _)
  }
}

/**
 * A negative characteristic that filters out qualifiers that are classes (i.e. static calls). These
 * are unlikely to have any non-trivial flow going into them.
 *
 * Technically, an accessed type _could_ come from outside of the source code, but there's not
 * much likelihood of that being user-controlled.
 */
private class ClassQualifierCharacteristic extends CharacteristicsImpl::NotASinkCharacteristic {
  ClassQualifierCharacteristic() { this = "class qualifier" }

  override predicate appliesToEndpoint(Endpoint e) {
    exists(Call c |
      e.asExpr() = c.getQualifier() and
      c.getQualifier() instanceof TypeAccess
    )
  }
}

/**
 * A call to a method that's known locally will not be considered as a candidate to model.
 *
 * The reason is that we would expect data/taint flow into the method implementation to uncover
 * any sinks that are present there.
 */
private class ArgumentToLocalCall extends CharacteristicsImpl::UninterestingToModelCharacteristic {
  ArgumentToLocalCall() { this = "argument to local call" }

  override predicate appliesToEndpoint(Endpoint e) {
    ApplicationModeGetCallable::getCallable(e).fromSource()
  }
}

/**
 * A Characteristic that marks endpoints as uninteresting to model, according to the Java ModelExclusions module.
 */
private class ExcludedFromModeling extends CharacteristicsImpl::UninterestingToModelCharacteristic {
  ExcludedFromModeling() { this = "excluded from modeling" }

  override predicate appliesToEndpoint(Endpoint e) {
    ModelExclusions::isUninterestingForModels(ApplicationModeGetCallable::getCallable(e))
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
    not ApplicationModeGetCallable::getCallable(e).isPublic()
  }
}

/**
 * A negative characteristic that indicates that an endpoint is a non-sink argument to a method whose sinks have already
 * been modeled.
 *
 * WARNING: These endpoints should not be used as negative samples for training, because some sinks may have been missed
 * when the method was modeled. Specifically, as we start using ATM to merge in new declarations, we can be less sure
 * that a method with one argument modeled as a MaD sink has also had its remaining arguments manually reviewed. The
 * ML model might have predicted argument 0 of some method to be a sink but not argument 1, when in fact argument 1 is
 * also a sink.
 */
private class OtherArgumentToModeledMethodCharacteristic extends CharacteristicsImpl::LikelyNotASinkCharacteristic
{
  OtherArgumentToModeledMethodCharacteristic() {
    this = "other argument to a method that has already been modeled"
  }

  override predicate appliesToEndpoint(Endpoint e) {
    not ApplicationCandidatesImpl::isSink(e, _) and
    exists(DataFlow::Node otherSink |
      ApplicationCandidatesImpl::isSink(otherSink, _) and
      e.asExpr() = otherSink.asExpr().(Argument).getCall().getAnArgument() and
      e != otherSink
    )
  }
}

/**
 * A characteristic that marks functional expression as likely not sinks.
 *
 * These expressions may well _contain_ sinks, but rarely are sinks themselves.
 */
private class FunctionValueCharacteristic extends CharacteristicsImpl::LikelyNotASinkCharacteristic {
  FunctionValueCharacteristic() { this = "function value" }

  override predicate appliesToEndpoint(Endpoint e) { e.asExpr() instanceof FunctionalExpr }
}

/**
 * A negative characteristic that indicates that an endpoint is not a `to` node for any known taint step. Such a node
 * cannot be tainted, because taint can't flow into it.
 *
 * WARNING: These endpoints should not be used as negative samples for training, because they may include sinks for
 * which our taint tracking modeling is incomplete.
 */
private class CannotBeTaintedCharacteristic extends CharacteristicsImpl::LikelyNotASinkCharacteristic
{
  CannotBeTaintedCharacteristic() { this = "cannot be tainted" }

  override predicate appliesToEndpoint(Endpoint e) { not this.isKnownOutNodeForStep(e) }

  /**
   * Holds if the node `n` is known as the predecessor in a modeled flow step.
   */
  private predicate isKnownOutNodeForStep(Endpoint e) {
    e.asExpr() instanceof Call or // we just assume flow in that case
    TaintTracking::localTaintStep(_, e) or
    FlowSummaryImpl::Private::Steps::summaryThroughStepValue(_, e, _) or
    FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(_, e, _) or
    FlowSummaryImpl::Private::Steps::summaryGetterStep(_, _, e, _) or
    FlowSummaryImpl::Private::Steps::summarySetterStep(_, _, e, _)
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
