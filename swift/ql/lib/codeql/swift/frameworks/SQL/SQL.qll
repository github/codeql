/**
 * Provides models for SQL libraries.
 */

import swift
private import codeql.swift.dataflow.ExternalFlow

/**
 * A model for SQL library functions that permit taint flow.
 */
private class FilePathSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        // SQLite.Swift
        ";;false;<-(_:_:);;;Argument[0..1];ReturnValue;taint",
        ";Expression;true;init(_:_:);;;Argument[0];ReturnValue;taint",
        ";Expression;true;init(_:_:);;;Argument[1].CollectionElement;ReturnValue;taint",
        ";ExpressionType;true;init(_:);;;Argument[0];ReturnValue;taint",
        ";ExpressionType;true;replace(_:with:);;;Argument[1];ReturnValue;taint",
        ";Blob;true;init(bytes:);;;Argument[0];ReturnValue;taint",
        ";Blob;true;init(bytes:length:);;;Argument[0];ReturnValue;taint",
      ]
  }
}
