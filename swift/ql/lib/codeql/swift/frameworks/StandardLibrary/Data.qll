/**
 * Provides models for the `Data` Swift class.
 */

import swift
private import codeql.swift.dataflow.ExternalFlow

private class DataSources extends SourceModelCsv {
  override predicate row(string row) {
    row = ";Data;true;init(contentsOf:options:);;;ReturnValue;remote"
  }
}

private class DataSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";Data;true;init(_:);;;Argument[0];ReturnValue;taint",
        ";Data;true;init(base64Encoded:options:);;;Argument[0];ReturnValue;taint",
        ";Data;true;init(buffer:);;;Argument[0];ReturnValue;taint",
        ";Data;true;init(bytes:count:);;;Argument[0];ReturnValue;taint",
        ";Data;true;init(contentsOf:options:);;;Argument[0];ReturnValue;taint",
        ";Data;true;init(bytesNoCopy:count:deallocator:);;;Argument[0];ReturnValue;taint",
        ";Data;true;init(referencing:);;;Argument[0];ReturnValue;taint",
        ";Data;true;append(_:count:);;;Argument[0];Argument[-1];taint",
        ";Data;true;base64EncodedData(options:);;;Argument[-1];ReturnValue;taint",
        ";Data;true;base64EncodedString(options:);;;Argument[-1];ReturnValue;taint",
        ";Data;true;compactMap(_:);;;Argument[-1];ReturnValue;taint",
        ";DataProtocol;true;copyBytes(to:);;;Argument[-1];Argument[0];taint",
        ";DataProtocol;true;copyBytes(to:count:);;;Argument[-1];Argument[0];taint",
        ";DataProtocol;true;copyBytes(to:from:);;;Argument[-1];Argument[0];taint",
        ";Data;true;flatMap(_:);;;Argument[-1];ReturnValue;taint",
        ";Data;true;insert(contentsOf:at:);;;Argument[0];Argument[-1];taint",
        ";Data;true;map(_:);;;Argument[-1];ReturnValue;taint",
        ";Data;true;reduce(into:_:);;;Argument[-1];ReturnValue;taint",
        ";Data;true;replace(_:with:maxReplacements:);;;Argument[1];Argument[-1];taint",
        ";Data;true;replaceSubrange(_:with:);;;Argument[1];Argument[-1];taint",
        ";Data;true;replaceSubrange(_:with:count:);;;Argument[1];Argument[-1];taint",
        ";Data;true;replacing(_:with:maxReplacements:);;;Argument[1];Argument[-1];taint",
        ";Data;true;replacing(_:with:subrange:maxReplacements:);;;Argument[1];Argument[-1];taint",
        ";Data;true;sorted();;;Argument[-1];ReturnValue;taint",
        ";Data;true;sorted(by:);;;Argument[-1];ReturnValue;taint",
        ";Data;true;sorted(using:);;;Argument[-1];ReturnValue;taint",
        ";Data;true;shuffled();;;Argument[-1];ReturnValue;taint",
        ";Data;true;shuffled(using:);;;Argument[-1];ReturnValue;taint",
        ";Data;true;trimmingPrefix(_:);;;Argument[-1];ReturnValue;taint",
        ";Data;true;trimmingPrefix(while:);;;Argument[-1];ReturnValue;taint",
        ";Data;true;withUnsafeMutableBytes(_:);;;Argument[-1];Argument[0].Parameter[0].CollectionElement;taint",
        ";Data;true;withUnsafeMutableBytes(_:);;;Argument[-1].CollectionElement;Argument[0].Parameter[0].CollectionElement;taint",
        ";Data;true;withUnsafeMutableBytes(_:);;;Argument[0].Parameter[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";Data;true;withUnsafeMutableBytes(_:);;;Argument[0].ReturnValue;ReturnValue;value",
      ]
  }
}
