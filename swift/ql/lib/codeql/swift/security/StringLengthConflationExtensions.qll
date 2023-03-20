/**
 * Provides classes and predicates for reasoning about string length
 * conflation vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow

/**
 * A flow state for encoding types of Swift string encoding.
 */
class StringLengthConflationFlowState extends string {
  string equivClass;
  string singular;

  StringLengthConflationFlowState() {
    this = "String" and singular = "a String" and equivClass = "String"
    or
    this = "NSString" and singular = "an NSString" and equivClass = "NSString"
    or
    this = "String.utf8" and singular = "a String.utf8" and equivClass = "String.utf8"
    or
    this = "String.utf16" and singular = "a String.utf16" and equivClass = "NSString"
    or
    this = "String.unicodeScalars" and
    singular = "a String.unicodeScalars" and
    equivClass = "String.unicodeScalars"
  }

  /**
   * Gets the equivalence class for this flow state. If these are equal,
   * they should be treated as equivalent.
   */
  string getEquivClass() { result = equivClass }

  /**
   * Gets text for the singular form of this flow state.
   */
  string getSingular() { result = singular }
}
