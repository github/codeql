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

private class DefaultCleartextLoggingSink extends CleartextLoggingSink {
  DefaultCleartextLoggingSink() { sinkNode(this, "logging") }
}

// TODO: Remove this. It shouldn't be necessary.
private class EncryptionCleartextLoggingSanitizer extends CleartextLoggingSanitizer {
  EncryptionCleartextLoggingSanitizer() { this.asExpr() instanceof EncryptedExpr }
}

/*
 * TODO: Add a sanitizer for the OsLogMessage interpolation with .private/.sensitive privacy options,
 * or restrict the sinks to require .public interpolation depending on what the default behavior is.
 */

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
