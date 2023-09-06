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
private import semmle.code.java.dataflow.internal.ModelExclusions as ModelExclusions
private import AutomodelJavaUtil as AutomodelJavaUtil
private import semmle.code.java.security.PathSanitizer as PathSanitizer
private import AutomodelSharedGetCallable as AutomodelSharedGetCallable
import AutomodelSharedCharacteristics as SharedCharacteristics
import AutomodelEndpointTypes as AutomodelEndpointTypes

newtype JavaRelatedLocationType = CallContext()

newtype TApplicationModeEndpoint =
  TExplicitArgument(Call call, DataFlow::Node arg) {
    exists(Argument argExpr |
      arg.asExpr() = argExpr and call = argExpr.getCall() and not argExpr.isVararg()
    )
  } or
  TInstanceArgument(Call call, DataFlow::Node arg) { arg = DataFlow::getInstanceArgument(call) } or
  TImplicitVarargsArray(Call call, DataFlow::Node arg, int idx) {
    exists(Argument argExpr |
      arg.asExpr() = argExpr and
      call.getArgument(idx) = argExpr and
      argExpr.isVararg() and
      not exists(int i | i < idx and call.getArgument(i).(Argument).isVararg())
    )
  }

/**
 * An endpoint is a node that is a candidate for modeling.
 */
abstract private class ApplicationModeEndpoint extends TApplicationModeEndpoint {
  abstract predicate isArgOf(Call c, int idx);

  Call getCall() { this.isArgOf(result, _) }

  int getArgIndex() { this.isArgOf(_, result) }

  abstract Top asTop();

  abstract DataFlow::Node asNode();

  abstract string toString();
}

/**
 * A class representing nodes that are arguments to calls.
 */
class ExplicitArgument extends ApplicationModeEndpoint, TExplicitArgument {
  Call call;
  DataFlow::Node arg;

  ExplicitArgument() { this = TExplicitArgument(call, arg) }

  override predicate isArgOf(Call c, int idx) { c = call and this.asTop() = c.getArgument(idx) }

  override Top asTop() { result = arg.asExpr() }

  override DataFlow::Node asNode() { result = arg }

  override string toString() { result = arg.toString() }
}

class InstanceArgument extends ApplicationModeEndpoint, TInstanceArgument {
  Call call;
  DataFlow::Node arg;

  InstanceArgument() { this = TInstanceArgument(call, arg) }

  override predicate isArgOf(Call c, int idx) {
    c = call and this.asTop() = c.getQualifier() and idx = -1
  }

  override Top asTop() { if exists(arg.asExpr()) then result = arg.asExpr() else result = call }

  override DataFlow::Node asNode() { result = arg }

  override string toString() { result = arg.toString() }
}

/**
 * An endpoint that represents an implicit varargs array.
 * We choose to represent the varargs array as a single endpoint, rather than as multiple endpoints.
 *
 * This avoids the problem of having to deal with redundant endpoints downstream.
 *
 * In order to be able to distinguish between varargs endpoints and regular endpoints, we export the `isVarargsArray`
 * meta data field in the extraction queries.
 */
class ImplicitVarargsArray extends ApplicationModeEndpoint, TImplicitVarargsArray {
  Call call;
  DataFlow::Node vararg;
  int idx;

  ImplicitVarargsArray() { this = TImplicitVarargsArray(call, vararg, idx) }

  override predicate isArgOf(Call c, int i) { c = call and i = idx }

  override Top asTop() { result = this.getCall() }

  override DataFlow::Node asNode() { result = vararg }

  override string toString() { result = vararg.toString() }
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
  class Endpoint = ApplicationModeEndpoint;

  class EndpointType = AutomodelEndpointTypes::EndpointType;

  class NegativeEndpointType = AutomodelEndpointTypes::NegativeSinkType;

  class RelatedLocation = Location::Top;

  class RelatedLocationType = JavaRelatedLocationType;

  // Sanitizers are currently not modeled in MaD. TODO: check if this has large negative impact.
  predicate isSanitizer(Endpoint e, EndpointType t) {
    exists(t) and
    (
      e.asNode().getType() instanceof BoxedType
      or
      e.asNode().getType() instanceof PrimitiveType
      or
      e.asNode().getType() instanceof NumberType
    )
    or
    t instanceof AutomodelEndpointTypes::PathInjectionSinkType and
    e.asNode() instanceof PathSanitizer::PathInjectionSanitizer
  }

  RelatedLocation asLocation(Endpoint e) { result = e.asTop() }

  predicate isKnownKind = AutomodelJavaUtil::isKnownKind/2;

  predicate isSink(Endpoint e, string kind, string provenance) {
    exists(string package, string type, string name, string signature, string ext, string input |
      sinkSpec(e, package, type, name, signature, ext, input) and
      ExternalFlow::sinkModel(package, type, _, name, [signature, ""], ext, input, kind, provenance)
    )
    or
    isCustomSink(e, kind) and provenance = "custom-sink"
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
    input = AutomodelJavaUtil::getArgumentForIndex(e.getArgIndex())
  }

  /**
   * Gets the related location for the given endpoint.
   *
   * The only related location we model is the the call expression surrounding to
   * which the endpoint is either argument or qualifier (known as the call context).
   */
  RelatedLocation getRelatedLocation(Endpoint e, RelatedLocationType type) {
    type = CallContext() and
    result = e.getCall()
  }
}

private class JavaCallable = Callable;

private module ApplicationModeGetCallable implements AutomodelSharedGetCallable::GetCallableSig {
  class Callable = JavaCallable;

  class Endpoint = ApplicationCandidatesImpl::Endpoint;

  /**
   * Returns the API callable being modeled.
   */
  Callable getCallable(Endpoint e) { result = e.getCall().getCallee() }
}

/**
 * Contains endpoints that are defined in QL code rather than as a MaD model. Ideally this predicate
 * should be empty.
 */
private predicate isCustomSink(Endpoint e, string kind) {
  e.asNode() instanceof QueryInjectionSink and kind = "sql"
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
    string input, string isVarargsArray
  ) {
    exists(Callable callable |
      e.getCall().getCallee() = callable and
      input = AutomodelJavaUtil::getArgumentForIndex(e.getArgIndex()) and
      package = callable.getDeclaringType().getPackage().getName() and
      // we're using the erased types because the MaD convention is to not specify type parameters.
      // Whether something is or isn't a sink doesn't usually depend on the type parameters.
      type = callable.getDeclaringType().getErasure().(RefType).nestedName() and
      subtypes = AutomodelJavaUtil::considerSubtypes(callable).toString() and
      name = callable.getName() and
      signature = ExternalFlow::paramsString(callable) and
      if e instanceof ImplicitVarargsArray
      then isVarargsArray = "true"
      else isVarargsArray = "false"
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
    not ApplicationCandidatesImpl::isSink(e, _, _) and
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
    not ApplicationCandidatesImpl::isSink(e, _, _) and
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
    FlowSummaryImpl::Private::Steps::summaryThroughStepValue(e.asNode(), _, _) or
    FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(e.asNode(), _, _) or
    FlowSummaryImpl::Private::Steps::summaryGetterStep(e.asNode(), _, _, _) or
    FlowSummaryImpl::Private::Steps::summarySetterStep(e.asNode(), _, _, _)
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
 * been modeled _manually_. This is restricted to manual sinks only, because only during the manual process do we have
 * the expectation that all sinks present in a method have been considered.
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
    this = "other argument to a method that has already been modeled manually"
  }

  override predicate appliesToEndpoint(Endpoint e) {
    not ApplicationCandidatesImpl::isSink(e, _, _) and
    exists(Endpoint otherSink |
      ApplicationCandidatesImpl::isSink(otherSink, _, "manual") and
      e.getCall() = otherSink.getCall() and
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

  override predicate appliesToEndpoint(Endpoint e) { e.asNode().asExpr() instanceof FunctionalExpr }
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
    e.asNode().asExpr() instanceof Call or // we just assume flow in that case
    TaintTracking::localTaintStep(_, e.asNode()) or
    FlowSummaryImpl::Private::Steps::summaryThroughStepValue(_, e.asNode(), _) or
    FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(_, e.asNode(), _) or
    FlowSummaryImpl::Private::Steps::summaryGetterStep(_, _, e.asNode(), _) or
    FlowSummaryImpl::Private::Steps::summarySetterStep(_, _, e.asNode(), _)
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
