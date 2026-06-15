/** Provides classes and predicates to reason about cleartext logging of sensitive data vulnerabilities. */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.security.SensitiveExprs
private import codeql.swift.StringFormat

/** A data flow sink for cleartext logging of sensitive data vulnerabilities. */
abstract class CleartextLoggingSink extends DataFlow::Node { }

/** A barrier for cleartext logging of sensitive data vulnerabilities. */
abstract class CleartextLoggingBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class CleartextLoggingAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `n1` to `n2` should be considered a flow
   * step for flows related to cleartext logging of sensitive data vulnerabilities.
   */
  abstract predicate step(DataFlow::Node n1, DataFlow::Node n2);
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultCleartextLoggingSink extends CleartextLoggingSink {
  DefaultCleartextLoggingSink() { sinkNode(this, "log-injection") }
}

/**
 * A barrier for cleartext logging vulnerabilities.
 *  - encryption; encrypted values are not cleartext.
 *  - booleans; these are more likely to be settings, rather than actual sensitive data.
 */
private class CleartextLoggingDefaultBarrier extends CleartextLoggingBarrier {
  CleartextLoggingDefaultBarrier() {
    this.asExpr() instanceof EncryptedExpr or
    this.asExpr().getType().getUnderlyingType() instanceof BoolType
  }
}

/**
 * A barrier for `OSLogMessage`s configured with the appropriate privacy option.
 * Numeric and boolean arguments aren't redacted unless the `private` or `sensitive` options are used.
 * Arguments of other types are always redacted unless the `public` option is used.
 */
private class OsLogPrivacyCleartextLoggingBarrier extends CleartextLoggingBarrier {
  OsLogPrivacyCleartextLoggingBarrier() {
    exists(CallExpr c, AutoClosureExpr e |
      c.getStaticTarget().getName().matches("appendInterpolation(_:%privacy:%)") and
      c.getArgument(0).getExpr() = e and
      this.asExpr() = e
    |
      e.getExpr().getType() instanceof OsLogNonRedactedType and
      c.getArgumentWithLabel("privacy").getExpr().(OsLogPrivacyRef).isSafe()
      or
      not e.getExpr().getType() instanceof OsLogNonRedactedType and
      not c.getArgumentWithLabel("privacy").getExpr().(OsLogPrivacyRef).isPublic()
    )
  }
}

/** A type that isn't redacted by default in an `OSLogMessage`. */
private class OsLogNonRedactedType extends Type {
  OsLogNonRedactedType() {
    this instanceof NumericType or
    this instanceof BoolType
  }
}

/** A reference to a field of `OsLogPrivacy`. */
private class OsLogPrivacyRef extends MemberRefExpr {
  string optionName;

  OsLogPrivacyRef() { this.getMember().(FieldDecl).hasQualifiedName("OSLogPrivacy", optionName) }

  /** Holds if this is a safe privacy option (private or sensitive). */
  predicate isSafe() { optionName = ["private", "sensitive"] }

  /** Holds if this is a public (that is, unsafe) privacy option. */
  predicate isPublic() { optionName = "public" }
}

/**
 * An additional taint step for cleartext logging vulnerabilities.
 */
private class CleartextLoggingFieldAdditionalFlowStep extends CleartextLoggingAdditionalFlowStep {
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // if an object is sensitive, its fields are always sensitive.
    nodeTo.asExpr().(MemberRefExpr).getBase() = nodeFrom.asExpr()
  }
}

/**
 * A sink that appears to be an imported C `printf` variant.
 */
private class PrintfCleartextLoggingSink extends CleartextLoggingSink {
  PrintfCleartextLoggingSink() {
    exists(CallExpr ce, PrintfFormat f |
      ce.getStaticTarget() = f and
      (
        this.asExpr() = ce.getArgument(f.getFormatParameterIndex()).getExpr() or
        this.asExpr() = ce.getArgument(f.getNumberOfParams() - 1).getExpr()
      ) and
      not f.isSprintf()
    )
  }
}

/**
 * Holds if `label` looks like the name of a logging function.
 */
bindingset[label]
private predicate logLikeHeuristic(string label) {
  label.regexpMatch("(l|.*L)og([A-Z0-9].*)?") // e.g. "logMessage", "debugLog"
}

/**
 * A cleartext logging sink that is determined by imprecise methods.
 */
class HeuristicCleartextLoggingSink extends CleartextLoggingSink {
  HeuristicCleartextLoggingSink() {
    exists(CallExpr ce, Function f, Expr e |
      (
        logLikeHeuristic(f.getShortName()) or
        logLikeHeuristic(f.getDeclaringDecl().(NominalTypeDecl).getName())
      ) and
      ce.getStaticTarget() = f and
      ce.getAnArgument().getExpr() = e and
      e.getType().getUnderlyingType().getName() = ["String", "NSString"] and
      this.asExpr() = e
    )
  }
}

private class LoggingSinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;print(_:separator:terminator:);;;Argument[0..2];log-injection",
        ";;false;print(_:separator:terminator:toStream:);;;Argument[0..2];log-injection",
        ";;false;debugPrint(_:separator:terminator:);;;Argument[0..2];log-injection",
        ";;false;dump(_:name:indent:maxDepth:maxItems:);;;Argument[0..1];log-injection",
        ";;false;assert(_:_:file:line:);;;Argument[1];log-injection",
        ";;false;assertionFailure(_:file:line:);;;Argument[0];log-injection",
        ";;false;precondition(_:_:file:line:);;;Argument[1];log-injection",
        ";;false;preconditionFailure(_:file:line:);;;Argument[0];log-injection",
        ";;false;fatalError(_:file:line:);;;Argument[0];log-injection",
        ";;false;NSLog(_:_:);;;Argument[0..1];log-injection",
        ";;false;NSLogv(_:_:);;;Argument[0..1];log-injection",
        ";;false;vfprintf(_:_:_:);;;Argument[1..2];log-injection",
        ";Logger;true;log(_:);;;Argument[0];log-injection",
        ";Logger;true;log(level:_:);;;Argument[1];log-injection",
        ";Logger;true;trace(_:);;;Argument[1];log-injection",
        ";Logger;true;debug(_:);;;Argument[1];log-injection",
        ";Logger;true;info(_:);;;Argument[1];log-injection",
        ";Logger;true;notice(_:);;;Argument[1];log-injection",
        ";Logger;true;warning(_:);;;Argument[1];log-injection",
        ";Logger;true;error(_:);;;Argument[1];log-injection",
        ";Logger;true;critical(_:);;;Argument[1];log-injection",
        ";Logger;true;fault(_:);;;Argument[1];log-injection",
        ";;false;os_log(_:);;;Argument[0];log-injection",
        ";;false;os_log(_:log:_:);;;Argument[2];log-injection",
        ";;false;os_log(_:dso:log:_:_:);;;Argument[0,4];log-injection",
        ";;false;os_log(_:dso:log:type:_:);;;Argument[0,4];log-injection",
        ";NSException;true;init(name:reason:userInfo:);;;Argument[1];log-injection",
        ";NSException;true;raise(_:format:arguments:);;;Argument[1..2];log-injection",
      ]
  }
}
