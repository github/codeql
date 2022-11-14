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
   * endpointClass: The sink type. Each EndpointType has a predicate getEncoding, which specifies the classifier
   * class for this sink type. Class 0 is the negative class (non-sink). Each positive int corresponds to a single
   * sink type.
   * isPositiveIndicator: If true, this characteristic indicates that this endpoint _is_ a member of the class; if
   * false, it indicates that it _isn't_ a member of the class.
   * confidence: A float in [0, 1], which tells us how strong an indicator this characteristic is for the endpoint
   * belonging / not belonging to the given class. A confidence near zero means this characteristic is a very weak
   * indicator of whether or not the endpoint belongs to the class. A confidence of 1 means that all endpoints with
   * this characteristic definitively do/don't belong to the class.
   */
  abstract predicate getImplications(
    EndpointType endpointClass, boolean isPositiveIndicator, float confidence
  );

  /** Indicators with confidence at or above this threshold are considered to be high-confidence indicators. */
  final float getHighConfidenceThreshold() { result = 0.8 }

  // The following are some confidence values that are used in practice by the subclasses. They are defined as named
  // constants here to make it easier to change them in the future.
  final float maximalConfidence() { result = 1.0 }

  final float highConfidence() { result = 0.9 }

  final float mediumConfidence() { result = 0.6 }
}

/*
 * Characteristics that are indicative of a sink.
 * NOTE: Initially each sink type has only one characteristic, which is that it's a sink of this type in the standard
 * JavaScript libraries.
 */

/**
 * Endpoints identified as "DomBasedXssSink" by the standard JavaScript libraries are XSS sinks with maximal confidence.
 */
private class DomBasedXssSinkCharacteristic extends EndpointCharacteristic {
  DomBasedXssSinkCharacteristic() { this = "DomBasedXssSink" }

  override predicate getEndpoints(DataFlow::Node n) { n instanceof DomBasedXss::Sink }

  override predicate getImplications(
    EndpointType endpointClass, boolean isPositiveIndicator, float confidence
  ) {
    endpointClass instanceof XssSinkType and
    isPositiveIndicator = true and
    confidence = maximalConfidence()
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
    endpointClass instanceof TaintedPathSinkType and
    isPositiveIndicator = true and
    confidence = maximalConfidence()
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
    confidence = maximalConfidence()
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
    confidence = maximalConfidence()
  }
}

/*
 * Characteristics that are indicative of not being a sink of any type.
 */

/**
 * A characteristic that is an indicator of not being a sink of any type, because it's an argument that has a manual
 * model.
 */
abstract private class OtherModeledArgumentCharacteristic extends EndpointCharacteristic {
  bindingset[this]
  OtherModeledArgumentCharacteristic() { any() }
}

/**
 * A characteristic that is an indicator of not being a sink of any type, because it's an argument to a function of a
 * builtin object.
 */
abstract private class ArgumentToBuiltinFunctionCharacteristic extends OtherModeledArgumentCharacteristic {
  bindingset[this]
  ArgumentToBuiltinFunctionCharacteristic() { any() }
}

/**
 * A high-confidence characteristic that indicates that an endpoint is not a sink of any type.
 */
abstract private class NotASinkCharacteristic extends OtherModeledArgumentCharacteristic {
  bindingset[this]
  NotASinkCharacteristic() { any() }

  override predicate getImplications(
    EndpointType endpointClass, boolean isPositiveIndicator, float confidence
  ) {
    endpointClass instanceof NegativeType and
    isPositiveIndicator = true and
    confidence = highConfidence()
  }
}

/**
 * A medium-confidence characteristic that indicates that an endpoint is not a sink of any type.
 *
 * TODO: This class is currently not private, because the current extraction logic explicitly avoids including these
 * endpoints in the training data. We might want to change this in the future.
 */
abstract class LikelyNotASinkCharacteristic extends OtherModeledArgumentCharacteristic {
  bindingset[this]
  LikelyNotASinkCharacteristic() { any() }

  override predicate getImplications(
    EndpointType endpointClass, boolean isPositiveIndicator, float confidence
  ) {
    endpointClass instanceof NegativeType and
    isPositiveIndicator = true and
    confidence = mediumConfidence()
  }
}

private class LodashUnderscore extends NotASinkCharacteristic {
  LodashUnderscore() { this = "LodashUnderscoreArgument" }

  override predicate getEndpoints(DataFlow::Node n) {
    any(LodashUnderscore::Member m).getACall().getAnArgument() = n
  }
}

private class JQueryArgumentCharacteristic extends NotASinkCharacteristic {
  JQueryArgumentCharacteristic() { this = "JQueryArgument" }

  override predicate getEndpoints(DataFlow::Node n) {
    any(JQuery::MethodCall m).getAnArgument() = n
  }
}

private class ClientRequestCharacteristic extends NotASinkCharacteristic {
  ClientRequestCharacteristic() { this = "ClientRequest" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(ClientRequest r |
      r.getAnArgument() = n or n = r.getUrl() or n = r.getHost() or n = r.getADataNode()
    )
  }
}

private class PromiseDefinitionCharacteristic extends NotASinkCharacteristic {
  PromiseDefinitionCharacteristic() { this = "PromiseDefinition" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(PromiseDefinition p |
      n = [p.getResolveParameter(), p.getRejectParameter()].getACall().getAnArgument()
    )
  }
}

private class CryptographicKeyCharacteristic extends NotASinkCharacteristic {
  CryptographicKeyCharacteristic() { this = "CryptographicKey" }

  override predicate getEndpoints(DataFlow::Node n) { n instanceof CryptographicKey }
}

private class CryptographicOperationFlowCharacteristic extends NotASinkCharacteristic {
  CryptographicOperationFlowCharacteristic() { this = "CryptographicOperationFlow" }

  override predicate getEndpoints(DataFlow::Node n) {
    any(CryptographicOperation op).getInput() = n
  }
}

private class LoggerMethodCharacteristic extends NotASinkCharacteristic {
  LoggerMethodCharacteristic() { this = "LoggerMethod" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      call.getCalleeName() = getAStandardLoggerMethodName()
    )
  }
}

private class TimeoutCharacteristic extends NotASinkCharacteristic {
  TimeoutCharacteristic() { this = "Timeout" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      call.getCalleeName() = ["setTimeout", "clearTimeout"]
    )
  }
}

private class ReceiverStorageCharacteristic extends NotASinkCharacteristic {
  ReceiverStorageCharacteristic() { this = "ReceiverStorage" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      call.getReceiver() = DataFlow::globalVarRef(["localStorage", "sessionStorage"])
    )
  }
}

private class StringStartsWithCharacteristic extends NotASinkCharacteristic {
  StringStartsWithCharacteristic() { this = "StringStartsWith" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      call instanceof StringOps::StartsWith
    )
  }
}

private class StringEndsWithCharacteristic extends NotASinkCharacteristic {
  StringEndsWithCharacteristic() { this = "StringEndsWith" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() | call instanceof StringOps::EndsWith)
  }
}

private class StringRegExpTestCharacteristic extends NotASinkCharacteristic {
  StringRegExpTestCharacteristic() { this = "StringRegExpTest" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      call instanceof StringOps::RegExpTest
    )
  }
}

private class EventRegistrationCharacteristic extends NotASinkCharacteristic {
  EventRegistrationCharacteristic() { this = "EventRegistration" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() | call instanceof EventRegistration)
  }
}

private class EventDispatchCharacteristic extends NotASinkCharacteristic {
  EventDispatchCharacteristic() { this = "EventDispatch" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() | call instanceof EventDispatch)
  }
}

private class MembershipCandidateTestCharacteristic extends NotASinkCharacteristic {
  MembershipCandidateTestCharacteristic() { this = "MembershipCandidateTest" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      call = any(MembershipCandidate c).getTest()
    )
  }
}

private class FileSystemAccessCharacteristic extends NotASinkCharacteristic {
  FileSystemAccessCharacteristic() { this = "FileSystemAccess" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() | call instanceof FileSystemAccess)
  }
}

private class DatabaseAccessCharacteristic extends NotASinkCharacteristic {
  DatabaseAccessCharacteristic() { this = "DatabaseAccess" }

  override predicate getEndpoints(DataFlow::Node n) {
    // TODO database accesses are less well defined than database query sinks, so this may cover unmodeled sinks on
    // existing database models
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      [
        call, call.getAMethodCall()
      /* command pattern where the query is built, and then exec'ed later */ ] instanceof
        DatabaseAccess
    )
  }
}

private class DomCharacteristic extends NotASinkCharacteristic {
  DomCharacteristic() { this = "DOM" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() | call = DOM::domValueRef())
  }
}

private class NextFunctionCallCharacteristic extends NotASinkCharacteristic {
  NextFunctionCallCharacteristic() { this = "NextFunctionCall" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      call.getCalleeName() = "next" and
      exists(DataFlow::FunctionNode f | call = f.getLastParameter().getACall())
    )
  }
}

private class DojoRequireCharacteristic extends NotASinkCharacteristic {
  DojoRequireCharacteristic() { this = "DojoRequire" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      call = DataFlow::globalVarRef("dojo").getAPropertyRead("require").getACall()
    )
  }
}

private class Base64ManipulationCharacteristic extends NotASinkCharacteristic {
  Base64ManipulationCharacteristic() { this = "Base64Manipulation" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(Base64::Decode d | n = d.getInput()) or
    exists(Base64::Encode d | n = d.getInput())
  }
}

private class ArgumentToArrayCharacteristic extends ArgumentToBuiltinFunctionCharacteristic,
  LikelyNotASinkCharacteristic {
  ArgumentToArrayCharacteristic() { this = "ArgumentToArray" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::SourceNode builtin, DataFlow::SourceNode receiver, DataFlow::InvokeNode invk |
      builtin instanceof DataFlow::ArrayCreationNode
    |
      receiver = [builtin.getAnInvocation(), builtin] and
      invk = [receiver, receiver.getAPropertyRead()].getAnInvocation() and
      invk.getAnArgument() = n
    )
  }
}

private class ArgumentToBuiltinGlobalVarRefCharacteristic extends ArgumentToBuiltinFunctionCharacteristic,
  LikelyNotASinkCharacteristic {
  ArgumentToBuiltinGlobalVarRefCharacteristic() { this = "ArgumentToBuiltinGlobalVarRef" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::SourceNode builtin, DataFlow::SourceNode receiver, DataFlow::InvokeNode invk |
      builtin =
        DataFlow::globalVarRef([
            "Map", "Set", "WeakMap", "WeakSet", "Number", "Object", "String", "Array", "Error",
            "Math", "Boolean"
          ])
    |
      receiver = [builtin.getAnInvocation(), builtin] and
      invk = [receiver, receiver.getAPropertyRead()].getAnInvocation() and
      invk.getAnArgument() = n
    )
  }
}

private class ConstantReceiverCharacteristic extends ArgumentToBuiltinFunctionCharacteristic,
  NotASinkCharacteristic {
  ConstantReceiverCharacteristic() { this = "ConstantReceiver" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(Expr primitive, MethodCallExpr c |
      primitive instanceof ConstantString or
      primitive instanceof NumberLiteral or
      primitive instanceof BooleanLiteral
    |
      c.calls(primitive, _) and
      c.getAnArgument() = n.asExpr()
    )
  }
}

private class BuiltinCallNameCharacteristic extends ArgumentToBuiltinFunctionCharacteristic,
  NotASinkCharacteristic {
  BuiltinCallNameCharacteristic() { this = "BuiltinCallName" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call |
      call.getAnArgument() = n and
      call.getCalleeName() =
        [
          "indexOf", "hasOwnProperty", "substring", "isDecimal", "decode", "encode", "keys",
          "shift", "values", "forEach", "toString", "slice", "splice", "push", "isArray", "sort"
        ]
    )
  }
}
