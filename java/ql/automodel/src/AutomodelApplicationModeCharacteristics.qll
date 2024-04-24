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
import AutomodelSharedCharacteristics as SharedCharacteristics
import AutomodelEndpointTypes as AutomodelEndpointTypes

newtype JavaRelatedLocationType =
  CallContext() or
  MethodDoc() or
  ClassDoc()

newtype TApplicationModeEndpoint =
  TExplicitArgument(Call call, DataFlow::Node arg) {
    AutomodelJavaUtil::isFromSource(call) and
    exists(Argument argExpr |
      arg.asExpr() = argExpr and call = argExpr.getCall() and not argExpr.isVararg()
    ) and
    not AutomodelJavaUtil::isUnexploitableType(arg.getType())
  } or
  TInstanceArgument(Call call, DataFlow::Node arg) {
    AutomodelJavaUtil::isFromSource(call) and
    arg = DataFlow::getInstanceArgument(call) and
    not call instanceof ConstructorCall and
    not AutomodelJavaUtil::isUnexploitableType(arg.getType())
  } or
  TImplicitVarargsArray(Call call, DataFlow::ImplicitVarargsArray arg, int idx) {
    AutomodelJavaUtil::isFromSource(call) and
    call = arg.getCall() and
    idx = call.getCallee().getVaragsParameterIndex() and
    not AutomodelJavaUtil::isUnexploitableType(arg.getType())
  } or
  TMethodReturnValue(MethodCall call) {
    AutomodelJavaUtil::isFromSource(call) and
    not AutomodelJavaUtil::isUnexploitableType(call.getType())
  } or
  TOverriddenParameter(Parameter p, Method overriddenMethod) {
    AutomodelJavaUtil::isFromSource(p) and
    p.getCallable().(Method).overrides(overriddenMethod)
  }

/**
 * An endpoint is a node that is a candidate for modeling.
 */
abstract private class ApplicationModeEndpoint extends TApplicationModeEndpoint {
  /**
   * Gets the callable to be modeled that this endpoint represents.
   */
  abstract Callable getCallable();

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

  abstract Top asTop();

  /**
   * Converts the endpoint to a node that can be used in a data flow graph.
   */
  abstract DataFlow::Node asNode();

  string getExtensibleType() {
    if not exists(this.getMaDInput()) and exists(this.getMaDOutput())
    then result = "sourceModel"
    else
      if exists(this.getMaDInput()) and not exists(this.getMaDOutput())
      then result = "sinkModel"
      else none() // if both exist, it would be a summaryModel (not yet supported)
  }

  abstract string toString();
}

class TCallArgument = TExplicitArgument or TInstanceArgument or TImplicitVarargsArray;

/**
 * An endpoint that represents an "argument" to a call in a broad sense, including
 * both explicit arguments and the instance argument.
 */
abstract class CallArgument extends ApplicationModeEndpoint, TCallArgument {
  Call call;
  DataFlow::Node arg;

  override Callable getCallable() { result = call.getCallee().getSourceDeclaration() }

  override string getMaDOutput() { none() }

  override DataFlow::Node asNode() { result = arg }

  Call getCall() { result = call }

  override string toString() { result = arg.toString() }
}

/**
 * An endpoint that represents an explicit argument to a call.
 */
class ExplicitArgument extends CallArgument, TExplicitArgument {
  ExplicitArgument() { this = TExplicitArgument(call, arg) }

  private int getArgIndex() { this.asTop() = call.getArgument(result) }

  override string getMaDInput() { result = "Argument[" + this.getArgIndex() + "]" }

  override Top asTop() { result = arg.asExpr() }
}

/**
 * An endpoint that represents the instance argument to a call.
 */
class InstanceArgument extends CallArgument, TInstanceArgument {
  InstanceArgument() { this = TInstanceArgument(call, arg) }

  override string getMaDInput() { result = "Argument[this]" }

  override Top asTop() { if exists(arg.asExpr()) then result = arg.asExpr() else result = call }

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
class ImplicitVarargsArray extends CallArgument, TImplicitVarargsArray {
  int idx;

  ImplicitVarargsArray() { this = TImplicitVarargsArray(call, arg, idx) }

  override string getMaDInput() { result = "Argument[" + idx + "]" }

  override Top asTop() { result = call }
}

/**
 * An endpoint that represents a method call. The `ReturnValue` of a method call
 * may be a source.
 */
class MethodReturnValue extends ApplicationModeEndpoint, TMethodReturnValue {
  MethodCall call;

  MethodReturnValue() { this = TMethodReturnValue(call) }

  override Callable getCallable() { result = call.getCallee().getSourceDeclaration() }

  override string getMaDInput() { none() }

  override string getMaDOutput() { result = "ReturnValue" }

  override Top asTop() { result = call }

  override DataFlow::Node asNode() { result.asExpr() = call }

  override string toString() { result = call.toString() }
}

/**
 * An endpoint that represents a parameter of an overridden method that may be
 * a source.
 */
class OverriddenParameter extends ApplicationModeEndpoint, TOverriddenParameter {
  Parameter p;
  Method overriddenMethod;

  OverriddenParameter() { this = TOverriddenParameter(p, overriddenMethod) }

  override Callable getCallable() {
    // NB: we're returning the overridden callable here. This means that the
    // candidate model will be about the overridden method, not the overriding
    // method. This is a more general model, that also applies to other
    // subclasses of the overridden class.
    result = overriddenMethod.getSourceDeclaration()
  }

  private int getArgIndex() { p.getCallable().getParameter(result) = p }

  override string getMaDInput() { none() }

  override string getMaDOutput() { result = "Parameter[" + this.getArgIndex() + "]" }

  override Top asTop() { result = p }

  override DataFlow::Node asNode() { result.(DataFlow::ParameterNode).asParameter() = p }

  override string toString() { result = p.toString() }
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

  class SinkType = AutomodelEndpointTypes::SinkType;

  class SourceType = AutomodelEndpointTypes::SourceType;

  class RelatedLocation = Location::Top;

  class RelatedLocationType = JavaRelatedLocationType;

  // Sanitizers are currently not modeled in MaD. TODO: check if this has large negative impact.
  predicate isSanitizer(Endpoint e, EndpointType t) {
    exists(t) and
    AutomodelJavaUtil::isUnexploitableType([
        // for most endpoints, we can get the type from the node
        e.asNode().getType(),
        // but not for calls to void methods, where we need to go via the AST
        e.asTop().(Expr).getType()
      ])
    or
    t instanceof AutomodelEndpointTypes::PathInjectionSinkType and
    e.asNode() instanceof PathSanitizer::PathInjectionSanitizer
  }

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
    or
    isCustomSink(e, kind) and provenance = "custom-sink"
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
   * The only related location we model is the the call expression surrounding to
   * which the endpoint is either argument or qualifier (known as the call context).
   */
  RelatedLocation getRelatedLocation(Endpoint e, RelatedLocationType type) {
    type = CallContext() and
    result = e.(CallArgument).getCall()
    or
    type = MethodDoc() and
    result = e.getCallable().(Documentable).getJavadoc()
    or
    type = ClassDoc() and
    result = e.getCallable().getDeclaringType().(Documentable).getJavadoc()
  }
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
    string input, string output, string isVarargsArray, string alreadyAiModeled,
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
      (
        if e instanceof ImplicitVarargsArray
        then isVarargsArray = "true"
        else isVarargsArray = "false"
      ) and
      extensibleType = e.getExtensibleType()
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
  string input, string output, string isVarargs, string extensibleType, string alreadyAiModeled
) {
  CharacteristicsImpl::isCandidate(endpoint, _) and
  not exists(CharacteristicsImpl::UninterestingToModelCharacteristic u |
    u.appliesToEndpoint(endpoint)
  ) and
  any(ApplicationModeMetadataExtractor meta)
      .hasMetadata(endpoint, package, type, subtypes, name, signature, input, output, isVarargs,
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
  string isVarargsArray, string extensibleType
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
  any(ApplicationModeMetadataExtractor meta)
      .hasMetadata(endpoint, package, type, subtypes, name, signature, input, output,
        isVarargsArray, _, extensibleType) and
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
  string signature, string input, string output, string isVarargsArray, string extensibleType
) {
  any(ApplicationModeMetadataExtractor meta)
      .hasMetadata(endpoint, package, type, subtypes, name, signature, input, output,
        isVarargsArray, _, extensibleType) and
  CharacteristicsImpl::isKnownAs(endpoint, endpointType, _) and
  exists(CharacteristicsImpl::getRelatedLocationOrCandidate(endpoint, CallContext()))
}

/*
 * EndpointCharacteristic classes that are specific to Automodel for Java.
 */

/**
 * A negative characteristic that indicates that parameters of an is-style boolean method should not be considered sinks.
 *
 * A sink is highly unlikely to be exploitable if its callable's name starts with `is` and the callable has a boolean return
 * type (e.g. `isDirectory`). These kinds of calls normally do only checks, and appear before the proper call that does
 * the dangerous/interesting thing, so we want the latter to be modeled as the sink.
 *
 * TODO: this might filter too much, it's possible that methods with more than one parameter contain interesting sinks
 */
private class UnexploitableIsCharacteristic extends CharacteristicsImpl::NotASinkCharacteristic {
  UnexploitableIsCharacteristic() { this = "argument of is-style boolean method" }

  override predicate appliesToEndpoint(Endpoint e) {
    e.getCallable().getName().matches("is%") and
    e.getCallable().getReturnType() instanceof BooleanType and
    not ApplicationCandidatesImpl::isSink(e, _, _)
  }
}

/**
 * A negative characteristic that indicates that parameters of an existence-checking boolean method should not be
 * considered sinks.
 *
 * A sink is highly unlikely to be exploitable if its callable's name is `exists` or `notExists` and the callable has a
 * boolean return type. These kinds of calls normally do only checks, and appear before the proper call that does the
 * dangerous/interesting thing, so we want the latter to be modeled as the sink.
 */
private class UnexploitableExistsCharacteristic extends CharacteristicsImpl::NotASinkCharacteristic {
  UnexploitableExistsCharacteristic() { this = "argument of existence-checking boolean method" }

  override predicate appliesToEndpoint(Endpoint e) {
    exists(Callable callable | callable = e.getCallable() |
      callable.getName().toLowerCase() = ["exists", "notexists"] and
      callable.getReturnType() instanceof BooleanType
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
      not ApplicationCandidatesImpl::isSink(e, _, _)
      or
      e.getExtensibleType() = "sourceModel" and
      not ApplicationCandidatesImpl::isSource(e, _, _) and
      e.getMaDOutput() = "ReturnValue"
    )
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
    FlowSummaryImpl::Private::Steps::summaryThroughStepValue(e.asNode(), _, _)
    or
    FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(e.asNode(), _, _)
    or
    FlowSummaryImpl::Private::Steps::summaryGetterStep(e.asNode(), _, _, _)
    or
    FlowSummaryImpl::Private::Steps::summarySetterStep(e.asNode(), _, _, _)
  }
}

/**
 * A call to a method that's known locally will not be considered as a candidate to model.
 *
 * The reason is that we would expect data/taint flow into the method implementation to uncover
 * any sinks that are present there.
 */
private class LocalCall extends CharacteristicsImpl::UninterestingToModelCharacteristic {
  LocalCall() { this = "local call" }

  override predicate appliesToEndpoint(Endpoint e) {
    e.(CallArgument).getCallable().fromSource()
    or
    e.(MethodReturnValue).getCallable().fromSource()
  }
}

/**
 * A characteristic that marks endpoints as uninteresting to model, according to the Java ModelExclusions module.
 */
private class ExcludedFromModeling extends CharacteristicsImpl::UninterestingToModelCharacteristic {
  ExcludedFromModeling() { this = "excluded from modeling" }

  override predicate appliesToEndpoint(Endpoint e) {
    ModelExclusions::isUninterestingForModels(e.getCallable())
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
    exists(Callable c | c = e.getCallable() | not c.isPublic())
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
    exists(CallArgument otherSink |
      ApplicationCandidatesImpl::isSink(otherSink, _, "manual") and
      e.(CallArgument).getCall() = otherSink.getCall() and
      e != otherSink
    )
  }
}

/**
 * Holds if the type of the given expression is annotated with `@FunctionalInterface`.
 */
predicate hasFunctionalInterfaceType(Expr e) {
  exists(RefType tp | tp = e.getType().getErasure() |
    tp.getAnAssociatedAnnotation().getType().hasQualifiedName("java.lang", "FunctionalInterface")
  )
}

/**
 * A characteristic that marks functional expression as likely not sinks.
 *
 * These expressions may well _contain_ sinks, but rarely are sinks themselves.
 */
private class FunctionValueCharacteristic extends CharacteristicsImpl::LikelyNotASinkCharacteristic {
  FunctionValueCharacteristic() { this = "function value" }

  override predicate appliesToEndpoint(Endpoint e) {
    exists(Expr expr | expr = e.asNode().asExpr() |
      expr instanceof FunctionalExpr or hasFunctionalInterfaceType(expr)
    )
  }
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
