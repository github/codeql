/**
 * Provides models for `TextOutputStream` and related Swift classes.
 */

import swift
private import codeql.swift.dataflow.ExternalFlow

/**
 * A model for members of `TextOutputStream` and similar classes that permit taint flow.
 */
private class StringSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";TextOutputStream;true;write(_:);;;Argument[0];Argument[-1];taint",
        ";TextOutputStreamable;true;write(to:);;;Argument[-1];Argument[0];taint",
      ]
  }
}
