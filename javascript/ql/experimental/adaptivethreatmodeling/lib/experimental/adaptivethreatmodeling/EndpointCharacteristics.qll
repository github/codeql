/**
 * For internal use only.
 */

import experimental.adaptivethreatmodeling.EndpointTypes
private import semmle.javascript.security.dataflow.SqlInjectionCustomizations
private import semmle.javascript.security.dataflow.DomBasedXssCustomizations
private import semmle.javascript.security.dataflow.NosqlInjectionCustomizations
private import semmle.javascript.security.dataflow.TaintedPathCustomizations
private import CoreKnowledge as CoreKnowledge
private import semmle.javascript.heuristics.SyntacticHeuristics as SyntacticHeuristics
private import semmle.javascript.filters.ClassifyFiles as ClassifyFiles
private import StandardEndpointFilters as StandardEndpointFilters

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
 * Characteristics that are indicative of not being a sink of any type, and have historically been used to select
 * negative samples for training.
 */

/**
 * A characteristic that is an indicator of not being a sink of any type, because it's an argument to a function of a
 * builtin object.
 */
abstract private class ArgumentToBuiltinFunctionCharacteristic extends EndpointCharacteristic {
  bindingset[this]
  ArgumentToBuiltinFunctionCharacteristic() { any() }
}

/**
 * A high-confidence characteristic that indicates that an endpoint is not a sink of any type.
 */
abstract private class NotASinkCharacteristic extends EndpointCharacteristic {
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
abstract class LikelyNotASinkCharacteristic extends EndpointCharacteristic {
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

/*
 * Characteristics that have historically acted as endpoint filters to exclude endpoints from scoring at inference time.
 */

/** A characteristic that has historically acted as an endpoint filter for inference-time scoring. */
abstract class EndpointFilterCharacteristic extends EndpointCharacteristic {
  bindingset[this]
  EndpointFilterCharacteristic() { any() }
}

/**
 * An EndpointFilterCharacteristic that indicates that an endpoint is unlikely to be a sink of any type.
 * Replaces https://github.com/github/codeql/blob/387e57546bf7352f7c1cfe781daa1a3799b7063e/javascript/ql/experimental/adaptivethreatmodeling/lib/experimental/adaptivethreatmodeling/StandardEndpointFilters.qll#LL15C24-L15C24
 */
abstract private class StandardEndpointFilterCharacteristic extends EndpointFilterCharacteristic {
  bindingset[this]
  StandardEndpointFilterCharacteristic() { any() }

  override predicate getImplications(
    EndpointType endpointClass, boolean isPositiveIndicator, float confidence
  ) {
    endpointClass instanceof NegativeType and
    isPositiveIndicator = true and
    confidence = mediumConfidence()
  }
}

private class IsArgumentToModeledFunctionCharacteristic extends StandardEndpointFilterCharacteristic {
  IsArgumentToModeledFunctionCharacteristic() { this = "argument to modeled function" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::InvokeNode invk, DataFlow::Node known |
      invk.getAnArgument() = n and
      invk.getAnArgument() = known and
      (
        CoreKnowledge::isKnownLibrarySink(known)
        or
        CoreKnowledge::isKnownStepSrc(known)
        or
        CoreKnowledge::isOtherModeledArgument(known, _)
      )
    )
  }
}

private class IsArgumentToSinklessLibraryCharacteristic extends StandardEndpointFilterCharacteristic {
  IsArgumentToSinklessLibraryCharacteristic() { this = "argument to sinkless library" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::InvokeNode invk, DataFlow::SourceNode commonSafeLibrary, string libraryName |
      libraryName = ["slugify", "striptags", "marked"]
    |
      commonSafeLibrary = DataFlow::moduleImport(libraryName) and
      invk = [commonSafeLibrary, commonSafeLibrary.getAPropertyRead()].getAnInvocation() and
      n = invk.getAnArgument()
    )
  }
}

private class IsSanitizerCharacteristic extends StandardEndpointFilterCharacteristic {
  IsSanitizerCharacteristic() { this = "sanitizer" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      call.getCalleeName().regexpMatch("(?i).*(escape|valid(ate)?|sanitize|purify).*")
    )
  }
}

private class IsPredicateCharacteristic extends StandardEndpointFilterCharacteristic {
  IsPredicateCharacteristic() { this = "predicate" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      call.getCalleeName().regexpMatch("(equals|(|is|has|can)(_|[A-Z])).*")
    )
  }
}

private class IsHashCharacteristic extends StandardEndpointFilterCharacteristic {
  IsHashCharacteristic() { this = "hash" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      call.getCalleeName().regexpMatch("(?i)^(sha\\d*|md5|hash)$")
    )
  }
}

private class IsNumericCharacteristic extends StandardEndpointFilterCharacteristic {
  IsNumericCharacteristic() { this = "numeric" }

  override predicate getEndpoints(DataFlow::Node n) {
    SyntacticHeuristics::isReadFrom(n, ".*index.*")
  }
}

private class InIrrelevantFileCharacteristic extends StandardEndpointFilterCharacteristic {
  private string category;

  InIrrelevantFileCharacteristic() {
    this = "in " + category + " file" and category = ["externs", "generated", "library", "test"]
  }

  override predicate getEndpoints(DataFlow::Node n) {
    // Ignore candidate sinks within externs, generated, library, and test code
    ClassifyFiles::classify(n.getFile(), category)
  }
}

/** An EndpointFilterCharacteristic that indicates that an endpoint is unlikely to be a NoSQL injection sink. */
abstract private class NosqlInjectionSinkEndpointFilterCharacteristic extends EndpointFilterCharacteristic {
  bindingset[this]
  NosqlInjectionSinkEndpointFilterCharacteristic() { any() }

  override predicate getImplications(
    EndpointType endpointClass, boolean isPositiveIndicator, float confidence
  ) {
    endpointClass instanceof NosqlInjectionSinkType and
    isPositiveIndicator = false and
    confidence = mediumConfidence()
  }
}

private class DatabaseAccessCallHeuristicCharacteristic extends NosqlInjectionSinkEndpointFilterCharacteristic {
  DatabaseAccessCallHeuristicCharacteristic() { this = "matches database access call heuristic" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::MethodCallNode call | n = call.getAnArgument() |
      // additional databases accesses that aren't modeled yet
      call.getMethodName() = ["create", "createCollection", "createIndexes"]
    )
  }
}

private class ModeledSinkCharacteristic extends NosqlInjectionSinkEndpointFilterCharacteristic {
  ModeledSinkCharacteristic() { this = "modeled sink" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      // Remove modeled sinks
      CoreKnowledge::isArgumentToKnownLibrarySinkFunction(n)
    )
  }
}

private class PredecessorInModeledFlowStepCharacteristic extends NosqlInjectionSinkEndpointFilterCharacteristic {
  PredecessorInModeledFlowStepCharacteristic() { this = "predecessor in a modeled flow step" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      // Remove common kinds of unlikely sinks
      CoreKnowledge::isKnownStepSrc(n)
    )
  }
}

private class ModeledDatabaseAccessCharacteristic extends NosqlInjectionSinkEndpointFilterCharacteristic {
  ModeledDatabaseAccessCharacteristic() { this = "modeled database access" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      // Remove modeled database calls. Arguments to modeled calls are very likely to be modeled
      // as sinks if they are true positives. Therefore arguments that are not modeled as sinks
      // are unlikely to be true positives.
      call instanceof DatabaseAccess
    )
  }
}

private class ReceiverIsHttpRequestExpressionCharacteristic extends NosqlInjectionSinkEndpointFilterCharacteristic {
  ReceiverIsHttpRequestExpressionCharacteristic() { this = "receiver is a HTTP request expression" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      // Remove calls to APIs that aren't relevant to NoSQL injection
      call.getReceiver() instanceof Http::RequestNode
    )
  }
}

private class ReceiverIsHttpResponseExpressionCharacteristic extends NosqlInjectionSinkEndpointFilterCharacteristic {
  ReceiverIsHttpResponseExpressionCharacteristic() {
    this = "receiver is a HTTP response expression"
  }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      // Remove calls to APIs that aren't relevant to NoSQL injection
      call.getReceiver() instanceof Http::ResponseNode
    )
  }
}

private class NotDirectArgumentToLikelyExternalLibraryCallOrHeuristicSinkNosqlCharacteristic extends NosqlInjectionSinkEndpointFilterCharacteristic {
  NotDirectArgumentToLikelyExternalLibraryCallOrHeuristicSinkNosqlCharacteristic() {
    this = "not a direct argument to a likely external library call or a heuristic sink (nosql)"
  }

  override predicate getEndpoints(DataFlow::Node n) {
    // Require NoSQL injection sink candidates to be (a) direct arguments to external library calls
    // or (b) heuristic sinks for NoSQL injection.
    //
    // ## Direct arguments to external library calls
    //
    // The `StandardEndpointFilters::flowsToArgumentOfLikelyExternalLibraryCall` endpoint filter
    // allows sink candidates which are within object literals or array literals, for example
    // `req.sendFile(_, { path: ENDPOINT })`.
    //
    // However, the NoSQL injection query deals differently with these types of sinks compared to
    // other security queries. Other security queries such as SQL injection tend to treat
    // `ENDPOINT` as the ground truth sink, but the NoSQL injection query instead treats
    // `{ path: ENDPOINT }` as the ground truth sink and defines an additional flow step to ensure
    // data flows from `ENDPOINT` to the ground truth sink `{ path: ENDPOINT }`.
    //
    // Therefore for the NoSQL injection boosted query, we must ignore sink candidates within object
    // literals or array literals, to avoid having multiple alerts for the same security
    // vulnerability (one FP where the sink is `ENDPOINT` and one TP where the sink is
    // `{ path: ENDPOINT }`). We accomplish this by directly testing that the sink candidate is an
    // argument of a likely external library call.
    //
    // ## Heuristic sinks
    //
    // We also allow heuristic sinks in addition to direct arguments to external library calls.
    // These are copied from the `HeuristicNosqlInjectionSink` class defined within
    // `codeql/javascript/ql/src/semmle/javascript/heuristics/AdditionalSinks.qll`.
    // We can't reuse the class because importing that file would cause us to treat these
    // heuristic sinks as known sinks.
    not n = StandardEndpointFilters::getALikelyExternalLibraryCall().getAnArgument() and
    not (
      SyntacticHeuristics::isAssignedToOrConcatenatedWith(n, "(?i)(nosql|query)") or
      SyntacticHeuristics::isArgTo(n, "(?i)(query)")
    )
  }
}

/** An EndpointFilterCharacteristic that indicates that an endpoint is unlikely to be a SQL injection sink. */
abstract private class SqlInjectionSinkEndpointFilterCharacteristic extends EndpointFilterCharacteristic {
  bindingset[this]
  SqlInjectionSinkEndpointFilterCharacteristic() { any() }

  override predicate getImplications(
    EndpointType endpointClass, boolean isPositiveIndicator, float confidence
  ) {
    endpointClass instanceof SqlInjectionSinkType and
    isPositiveIndicator = false and
    confidence = mediumConfidence()
  }
}

private class PreparedSqlStatementCharacteristic extends SqlInjectionSinkEndpointFilterCharacteristic {
  PreparedSqlStatementCharacteristic() { this = "prepared SQL statement" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      // prepared statements for SQL
      any(DataFlow::CallNode cn | cn.getCalleeName() = "prepare")
          .getAMethodCall("run")
          .getAnArgument() = n
    )
  }
}

private class ArrayCreationCharacteristic extends SqlInjectionSinkEndpointFilterCharacteristic {
  ArrayCreationCharacteristic() { this = "array creation" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      n instanceof DataFlow::ArrayCreationNode
    )
  }
}

private class HtmlOrRenderingCharacteristic extends SqlInjectionSinkEndpointFilterCharacteristic {
  HtmlOrRenderingCharacteristic() { this = "HTML / rendering" }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() |
      // UI is unrelated to SQL
      call.getCalleeName().regexpMatch("(?i).*(render|html).*")
    )
  }
}

private class NotAnArgumentToLikelyExternalLibraryCallOrHeuristicSinkCharacteristic extends SqlInjectionSinkEndpointFilterCharacteristic {
  NotAnArgumentToLikelyExternalLibraryCallOrHeuristicSinkCharacteristic() {
    this = "not an argument to a likely external library call or a heuristic sink"
  }

  override predicate getEndpoints(DataFlow::Node n) {
    // Require SQL injection sink candidates to be (a) arguments to external library calls
    // (possibly indirectly), or (b) heuristic sinks.
    //
    // Heuristic sinks are copied from the `HeuristicSqlInjectionSink` class defined within
    // `codeql/javascript/ql/src/semmle/javascript/heuristics/AdditionalSinks.qll`.
    // We can't reuse the class because importing that file would cause us to treat these
    // heuristic sinks as known sinks.
    not StandardEndpointFilters::flowsToArgumentOfLikelyExternalLibraryCall(n) and
    not (
      SyntacticHeuristics::isAssignedToOrConcatenatedWith(n, "(?i)(sql|query)") or
      SyntacticHeuristics::isArgTo(n, "(?i)(query)") or
      SyntacticHeuristics::isConcatenatedWithString(n,
        "(?s).*(ALTER|COUNT|CREATE|DATABASE|DELETE|DISTINCT|DROP|FROM|GROUP|INSERT|INTO|LIMIT|ORDER|SELECT|TABLE|UPDATE|WHERE).*")
    )
  }
}

/** An EndpointFilterCharacteristic that indicates that an endpoint is unlikely to be a tainted path injection sink. */
abstract private class TaintedPathSinkEndpointFilterCharacteristic extends EndpointFilterCharacteristic {
  bindingset[this]
  TaintedPathSinkEndpointFilterCharacteristic() { any() }

  override predicate getImplications(
    EndpointType endpointClass, boolean isPositiveIndicator, float confidence
  ) {
    endpointClass instanceof TaintedPathSinkType and
    isPositiveIndicator = false and
    confidence = mediumConfidence()
  }
}

private class NotDirectArgumentToLikelyExternalLibraryCallOrHeuristicSinkTaintedPathCharacteristic extends TaintedPathSinkEndpointFilterCharacteristic {
  NotDirectArgumentToLikelyExternalLibraryCallOrHeuristicSinkTaintedPathCharacteristic() {
    this =
      "not a direct argument to a likely external library call or a heuristic sink (tainted path)"
  }

  override predicate getEndpoints(DataFlow::Node n) {
    // Require path injection sink candidates to be (a) arguments to external library calls
    // (possibly indirectly), or (b) heuristic sinks.
    //
    // Heuristic sinks are mostly copied from the `HeuristicTaintedPathSink` class defined within
    // `codeql/javascript/ql/src/semmle/javascript/heuristics/AdditionalSinks.qll`.
    // We can't reuse the class because importing that file would cause us to treat these
    // heuristic sinks as known sinks.
    not StandardEndpointFilters::flowsToArgumentOfLikelyExternalLibraryCall(n) and
    not (
      SyntacticHeuristics::isAssignedToOrConcatenatedWith(n, "(?i)(file|folder|dir|absolute)")
      or
      SyntacticHeuristics::isArgTo(n, "(?i)(get|read)file")
      or
      exists(string pathPattern |
        // paths with at least two parts, and either a trailing or leading slash
        pathPattern = "(?i)([a-z0-9_.-]+/){2,}" or
        pathPattern = "(?i)(/[a-z0-9_.-]+){2,}"
      |
        SyntacticHeuristics::isConcatenatedWithString(n, pathPattern)
      )
      or
      SyntacticHeuristics::isConcatenatedWithStrings(".*/", n, "/.*")
      or
      // In addition to the names from `HeuristicTaintedPathSink` in the
      // `isAssignedToOrConcatenatedWith` predicate call above, we also allow the noisier "path"
      // name.
      SyntacticHeuristics::isAssignedToOrConcatenatedWith(n, "(?i)path")
    )
  }
}

/** An EndpointFilterCharacteristic that indicates that an endpoint is unlikely to be an XSS sink. */
abstract private class XssSinkEndpointFilterCharacteristic extends EndpointFilterCharacteristic {
  bindingset[this]
  XssSinkEndpointFilterCharacteristic() { any() }

  override predicate getImplications(
    EndpointType endpointClass, boolean isPositiveIndicator, float confidence
  ) {
    endpointClass instanceof XssSinkType and
    isPositiveIndicator = false and
    confidence = mediumConfidence()
  }
}

private class SetStateCallsInReactApplicationsCharacteristic extends XssSinkEndpointFilterCharacteristic {
  SetStateCallsInReactApplicationsCharacteristic() {
    this = "setState calls ought to be safe in react applications"
  }

  override predicate getEndpoints(DataFlow::Node n) {
    exists(DataFlow::CallNode call | n = call.getAnArgument() | call.getCalleeName() = "setState")
  }
}

private class NotDirectArgumentToLikelyExternalLibraryCallOrHeuristicSinkXssCharacteristic extends XssSinkEndpointFilterCharacteristic {
  NotDirectArgumentToLikelyExternalLibraryCallOrHeuristicSinkXssCharacteristic() {
    this = "not a direct argument to a likely external library call or a heuristic sink (xss)"
  }

  override predicate getEndpoints(DataFlow::Node n) {
    // Require XSS sink candidates to be (a) arguments to external library calls (possibly
    // indirectly), or (b) heuristic sinks.
    //
    // Heuristic sinks are copied from the `HeuristicDomBasedXssSink` class defined within
    // `codeql/javascript/ql/src/semmle/javascript/heuristics/AdditionalSinks.qll`.
    // We can't reuse the class because importing that file would cause us to treat these
    // heuristic sinks as known sinks.
    not StandardEndpointFilters::flowsToArgumentOfLikelyExternalLibraryCall(n) and
    not (
      SyntacticHeuristics::isAssignedToOrConcatenatedWith(n, "(?i)(html|innerhtml)")
      or
      SyntacticHeuristics::isArgTo(n, "(?i)(html|render)")
      or
      n instanceof StringOps::HtmlConcatenationLeaf
      or
      SyntacticHeuristics::isConcatenatedWithStrings("(?is).*<[a-z ]+.*", n, "(?s).*>.*")
      or
      // In addition to the heuristic sinks from `HeuristicDomBasedXssSink`, explicitly allow
      // property writes like `elem.innerHTML = <TAINT>` that may not be picked up as HTML
      // concatenation leaves.
      exists(DataFlow::PropWrite pw |
        pw.getPropertyName().regexpMatch("(?i).*html*") and
        pw.getRhs() = n
      )
    )
  }
}
