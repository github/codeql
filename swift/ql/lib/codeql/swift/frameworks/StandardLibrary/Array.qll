/**
 * Provides models for `Array` and related Swift classes.
 */

import swift
private import codeql.swift.dataflow.ExternalFlow

/**
 * An instance of the `Array` type.
 */
class ArrayType extends Type {
  ArrayType() { this.getCanonicalType().getName().matches("Array<%") }
}

/**
 * A model for `Array` and related Swift class members that permit taint flow.
 */
private class ArraySummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";Array;true;init(arrayLiteral:);;;Argument[0].CollectionElement;ReturnValue.CollectionElement;value",
        ";Array;true;insert(_:at:);;;Argument[0];Argument[-1].CollectionElement;value",
        ";Array;true;insert(_:at:);;;Argument[1];Argument[-1];taint",
        ";Array;true;withUnsafeBufferPointer(_:);;;Argument[-1];Argument[0].Parameter[0].CollectionElement;taint",
        ";Array;true;withUnsafeBufferPointer(_:);;;Argument[-1].CollectionElement;Argument[0].Parameter[0].CollectionElement;value",
        ";Array;true;withUnsafeBufferPointer(_:);;;Argument[0].ReturnValue;ReturnValue;value",
        ";Array;true;withUnsafeMutableBufferPointer(_:);;;Argument[-1];Argument[0].Parameter[0].CollectionElement;taint",
        ";Array;true;withUnsafeMutableBufferPointer(_:);;;Argument[-1].CollectionElement;Argument[0].Parameter[0].CollectionElement;value",
        ";Array;true;withUnsafeMutableBufferPointer(_:);;;Argument[0].Parameter[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";Array;true;withUnsafeMutableBufferPointer(_:);;;Argument[0].ReturnValue;ReturnValue;value",
        ";Array;true;withUnsafeBytes(_:);;;Argument[-1];Argument[0].Parameter[0].CollectionElement;taint",
        ";Array;true;withUnsafeBytes(_:);;;Argument[-1].CollectionElement;Argument[0].Parameter[0].CollectionElement;taint",
        ";Array;true;withUnsafeBytes(_:);;;Argument[0].ReturnValue;ReturnValue;value",
        ";Array;true;withUnsafeMutableBytes(_:);;;Argument[-1];Argument[0].Parameter[0].CollectionElement;taint",
        ";Array;true;withUnsafeMutableBytes(_:);;;Argument[-1].CollectionElement;Argument[0].Parameter[0].CollectionElement;taint",
        ";Array;true;withUnsafeMutableBytes(_:);;;Argument[0].Parameter[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";Array;true;withUnsafeMutableBytes(_:);;;Argument[0].ReturnValue;ReturnValue;value",
        ";Array;true;makeIterator();;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;value",
        ";ContiguousArray;true;withUnsafeBufferPointer(_:);;;Argument[-1];Argument[0].Parameter[0].CollectionElement;taint",
        ";ContiguousArray;true;withUnsafeBufferPointer(_:);;;Argument[-1].CollectionElement;Argument[0].Parameter[0].CollectionElement;value",
        ";ContiguousArray;true;withUnsafeBufferPointer(_:);;;Argument[0].ReturnValue;ReturnValue;value",
        ";ContiguousArray;true;withUnsafeMutableBufferPointer(_:);;;Argument[-1];Argument[0].Parameter[0].CollectionElement;taint",
        ";ContiguousArray;true;withUnsafeMutableBufferPointer(_:);;;Argument[-1].CollectionElement;Argument[0].Parameter[0].CollectionElement;value",
        ";ContiguousArray;true;withUnsafeMutableBufferPointer(_:);;;Argument[0].Parameter[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";ContiguousArray;true;withUnsafeMutableBufferPointer(_:);;;Argument[0].ReturnValue;ReturnValue;value",
        ";ContiguousArray;true;withUnsafeMutableBytes(_:);;;Argument[-1];Argument[0].Parameter[0].CollectionElement;taint",
        ";ContiguousArray;true;withUnsafeMutableBytes(_:);;;Argument[-1].CollectionElement;Argument[0].Parameter[0].CollectionElement;taint",
        ";ContiguousArray;true;withUnsafeMutableBytes(_:);;;Argument[0].Parameter[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";ContiguousArray;true;withUnsafeMutableBytes(_:);;;Argument[0].ReturnValue;ReturnValue;value",
        ";ContiguousBytes;true;withUnsafeBytes(_:);;;Argument[-1];Argument[0].Parameter[0].CollectionElement;taint",
        ";ContiguousBytes;true;withUnsafeBytes(_:);;;Argument[-1].CollectionElement;Argument[0].Parameter[0].CollectionElement;taint",
        ";ContiguousBytes;true;withUnsafeBytes(_:);;;Argument[0].ReturnValue;ReturnValue;value",
      ]
  }
}
