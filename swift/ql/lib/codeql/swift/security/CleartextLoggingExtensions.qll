/** Provides classes and predicates to reason about cleartext logging of sensitive data vulnerabilities. */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.security.SensitiveExprs

/** A data flow sink for cleartext logging of sensitive data vulnerabilities. */
abstract class CleartextLoggingSink extends DataFlow::Node { }

/** A sanitizer for cleartext logging of sensitive data vulnerabilities. */
abstract class CleartextLoggingSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to paths related to
 * cleartext logging of sensitive data vulnerabilities.
 */
class CleartextLoggingAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `n1` to `n2` should be considered a taint
   * step for flows related to cleartext logging of sensitive data vulnerabilities.
   */
  abstract predicate step(DataFlow::Node n1, DataFlow::Node n2);
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultCleartextLoggingSink extends CleartextLoggingSink {
  DefaultCleartextLoggingSink() { sinkNode(this, "logging") }
}

/**
 * A sanitizer for `OSLogMessage`s configured with the appropriate privacy option.
 * Numeric and boolean arguments aren't redacted unless the `private` or `sensitive` options are used.
 * Arguments of other types are always redacted unless the `public` option is used.
 */
private class OsLogPrivacyCleartextLoggingSanitizer extends CleartextLoggingSanitizer {
  OsLogPrivacyCleartextLoggingSanitizer() {
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

  OsLogPrivacyRef() {
    exists(FieldDecl f | this.getMember() = f |
      f.getEnclosingDecl().(NominalTypeDecl).getName() = "OSLogPrivacy" and
      optionName = f.getName()
    )
  }

  /** Holds if this is a safe privacy option (private or sensitive). */
  predicate isSafe() { optionName = ["private", "sensitive"] }

  /** Holds if this is a public (that is, unsafe) privacy option. */
  predicate isPublic() { optionName = "public" }
}

private class LoggingSinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;print(_:separator:terminator:);;;Argument[0].ArrayElement;logging",
        ";;false;print(_:separator:terminator:);;;Argument[1..2];logging",
        ";;false;print(_:separator:terminator:toStream:);;;Argument[0].ArrayElement;logging",
        ";;false;print(_:separator:terminator:toStream:);;;Argument[1..2];logging",
        ";;false;NSLog(_:_:);;;Argument[0];logging",
        ";;false;NSLog(_:_:);;;Argument[1].ArrayElement;logging",
        ";;false;NSLogv(_:_:);;;Argument[0];logging",
        ";;false;NSLogv(_:_:);;;Argument[1].ArrayElement;logging",
        ";;false;vfprintf(_:_:_:);;;Agument[1..2];logging",
        ";Logger;true;log(_:);;;Argument[0];logging",
        ";Logger;true;log(level:_:);;;Argument[1];logging",
        ";Logger;true;trace(_:);;;Argument[1];logging",
        ";Logger;true;debug(_:);;;Argument[1];logging",
        ";Logger;true;info(_:);;;Argument[1];logging",
        ";Logger;true;notice(_:);;;Argument[1];logging",
        ";Logger;true;warning(_:);;;Argument[1];logging",
        ";Logger;true;error(_:);;;Argument[1];logging",
        ";Logger;true;critical(_:);;;Argument[1];logging",
        ";Logger;true;fault(_:);;;Argument[1];logging",
      ]
  }
}
