/**
 * Provides models for `NSObject` and related Swift classes.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSteps

/**
 * A model for `NSObject`, `NSCopying` and `NSMutableCopying` members that permit taint flow.
 */
private class NsObjectSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";NSObject;true;copy();;;Argument[-1];ReturnValue;taint",
        ";NSObject;true;mutableCopy();;;Argument[-1];ReturnValue;taint",
        ";NSCopying;true;copy(with:);;;Argument[-1];ReturnValue;taint",
        ";NSMutableCopying;true;mutableCopy(with:);;;Argument[-1];ReturnValue;taint",
      ]
  }
}
