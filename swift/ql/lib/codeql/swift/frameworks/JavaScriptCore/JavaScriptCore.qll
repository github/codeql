/**
 * Provides models for the `JavaScriptCore` library.
 */

import swift
private import codeql.swift.dataflow.ExternalFlow

/**
 * A model for `JavaScriptCore` functions and class members that permit taint flow.
 */
private class JSStringSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;JSStringCreateWithUTF8CString(_:);;;Argument[0];ReturnValue;taint",
        ";;false;JSStringCreateWithCharacters(_:_:);;;Argument[0];ReturnValue;taint",
        ";;false;JSStringRetain(_:);;;Argument[0];ReturnValue;taint",
      ]
  }
}
