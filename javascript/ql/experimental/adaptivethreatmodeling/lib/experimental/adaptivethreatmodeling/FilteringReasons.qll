/**
 * For internal use only.
 *
 * Defines a set of reasons why a particular endpoint was filtered out. This set of reasons
 * contains both reasons why an endpoint could be `NotASink` and reasons why an endpoint could be
 * `LikelyNotASink`. The `NotASinkReason`s defined here are exhaustive, but the
 * `LikelyNotASinkReason`s are not exhaustive.
 */
newtype TFilteringReason =
  TIsArgumentToBuiltinFunctionReason() or
  TLodashUnderscoreArgumentReason() or
  TClientRequestReason() or
  TPromiseDefinitionReason() or
  TCryptographicKeyReason() or
  TCryptographicOperationFlowReason() or
  TLoggerMethodReason() or
  TTimeoutReason() or
  TReceiverStorageReason() or
  TStringStartsWithReason() or
  TStringEndsWithReason() or
  TStringRegExpTestReason() or
  TEventRegistrationReason() or
  TEventDispatchReason() or
  TMembershipCandidateTestReason() or
  TFileSystemAccessReason() or
  TDatabaseAccessReason() or
  TDomReason() or
  TNextFunctionCallReason() or
  TArgumentToArrayReason() or
  TArgumentToBuiltinGlobalVarRefReason() or
  TConstantReceiverReason() or
  TBuiltinCallNameReason() or
  TBase64ManipulationReason() or
  TJQueryArgumentReason() or
  TDojoRequireReason()

/** A reason why a particular endpoint was filtered out by the endpoint filters. */
abstract class FilteringReason extends TFilteringReason {
  abstract string getDescription();

  abstract int getEncoding();

  string toString() { result = getDescription() }
}

/**
 * A reason why a particular endpoint might be considered to be `NotASink`.
 *
 * An endpoint is `NotASink` if it has at least one `NotASinkReason`, it does not have any
 * `LikelyNotASinkReason`s, and it is not a known sink.
 */
abstract class NotASinkReason extends FilteringReason { }

/**
 * A reason why a particular endpoint might be considered to be `LikelyNotASink`.
 *
 * An endpoint is `LikelyNotASink` if it has at least one `LikelyNotASinkReason` and it is not a
 * known sink.
 */
abstract class LikelyNotASinkReason extends FilteringReason { }

class IsArgumentToBuiltinFunctionReason extends NotASinkReason, TIsArgumentToBuiltinFunctionReason {
  override string getDescription() { result = "IsArgumentToBuiltinFunction" }

  override int getEncoding() { result = 5 }
}

class LodashUnderscoreArgumentReason extends NotASinkReason, TLodashUnderscoreArgumentReason {
  override string getDescription() { result = "LodashUnderscoreArgument" }

  override int getEncoding() { result = 6 }
}

class ClientRequestReason extends NotASinkReason, TClientRequestReason {
  override string getDescription() { result = "ClientRequest" }

  override int getEncoding() { result = 7 }
}

class PromiseDefinitionReason extends NotASinkReason, TPromiseDefinitionReason {
  override string getDescription() { result = "PromiseDefinition" }

  override int getEncoding() { result = 8 }
}

class CryptographicKeyReason extends NotASinkReason, TCryptographicKeyReason {
  override string getDescription() { result = "CryptographicKey" }

  override int getEncoding() { result = 9 }
}

class CryptographicOperationFlowReason extends NotASinkReason, TCryptographicOperationFlowReason {
  override string getDescription() { result = "CryptographicOperationFlow" }

  override int getEncoding() { result = 10 }
}

class LoggerMethodReason extends NotASinkReason, TLoggerMethodReason {
  override string getDescription() { result = "LoggerMethod" }

  override int getEncoding() { result = 11 }
}

class TimeoutReason extends NotASinkReason, TTimeoutReason {
  override string getDescription() { result = "Timeout" }

  override int getEncoding() { result = 12 }
}

class ReceiverStorageReason extends NotASinkReason, TReceiverStorageReason {
  override string getDescription() { result = "ReceiverStorage" }

  override int getEncoding() { result = 13 }
}

class StringStartsWithReason extends NotASinkReason, TStringStartsWithReason {
  override string getDescription() { result = "StringStartsWith" }

  override int getEncoding() { result = 14 }
}

class StringEndsWithReason extends NotASinkReason, TStringEndsWithReason {
  override string getDescription() { result = "StringEndsWith" }

  override int getEncoding() { result = 15 }
}

class StringRegExpTestReason extends NotASinkReason, TStringRegExpTestReason {
  override string getDescription() { result = "StringRegExpTest" }

  override int getEncoding() { result = 16 }
}

class EventRegistrationReason extends NotASinkReason, TEventRegistrationReason {
  override string getDescription() { result = "EventRegistration" }

  override int getEncoding() { result = 17 }
}

class EventDispatchReason extends NotASinkReason, TEventDispatchReason {
  override string getDescription() { result = "EventDispatch" }

  override int getEncoding() { result = 18 }
}

class MembershipCandidateTestReason extends NotASinkReason, TMembershipCandidateTestReason {
  override string getDescription() { result = "MembershipCandidateTest" }

  override int getEncoding() { result = 19 }
}

class FileSystemAccessReason extends NotASinkReason, TFileSystemAccessReason {
  override string getDescription() { result = "FileSystemAccess" }

  override int getEncoding() { result = 20 }
}

class DatabaseAccessReason extends NotASinkReason, TDatabaseAccessReason {
  override string getDescription() { result = "DatabaseAccess" }

  override int getEncoding() { result = 21 }
}

class DomReason extends NotASinkReason, TDomReason {
  override string getDescription() { result = "DOM" }

  override int getEncoding() { result = 22 }
}

/** DEPRECATED: Alias for DomReason */
deprecated class DOMReason = DomReason;

class NextFunctionCallReason extends NotASinkReason, TNextFunctionCallReason {
  override string getDescription() { result = "NextFunctionCall" }

  override int getEncoding() { result = 23 }
}

class ArgumentToArrayReason extends LikelyNotASinkReason, TArgumentToArrayReason {
  override string getDescription() { result = "ArgumentToArray" }

  override int getEncoding() { result = 24 }
}

class ArgumentToBuiltinGlobalVarRefReason extends LikelyNotASinkReason,
  TArgumentToBuiltinGlobalVarRefReason {
  override string getDescription() { result = "ArgumentToBuiltinGlobalVarRef" }

  override int getEncoding() { result = 25 }
}

class ConstantReceiverReason extends NotASinkReason, TConstantReceiverReason {
  override string getDescription() { result = "ConstantReceiver" }

  override int getEncoding() { result = 26 }
}

class BuiltinCallNameReason extends NotASinkReason, TBuiltinCallNameReason {
  override string getDescription() { result = "BuiltinCallName" }

  override int getEncoding() { result = 27 }
}

class Base64ManipulationReason extends NotASinkReason, TBase64ManipulationReason {
  override string getDescription() { result = "Base64Manipulation" }

  override int getEncoding() { result = 28 }
}

class JQueryArgumentReason extends NotASinkReason, TJQueryArgumentReason {
  override string getDescription() { result = "JQueryArgument" }

  override int getEncoding() { result = 29 }
}

class DojoRequireReason extends NotASinkReason, TDojoRequireReason {
  override string getDescription() { result = "DojoRequire" }

  override int getEncoding() { result = 30 }
}
