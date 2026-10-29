/**
 * Provides models for `NSData` and related Swift classes.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSteps

/** The class `NSData`. */
class NsData extends ClassDecl {
  NsData() { this.getFullName() = "NSData" }
}

/** The class `NSMutableData`. */
class NsMutableData extends ClassDecl {
  NsMutableData() { this.getFullName() = "NSMutableData" }
}

private class NsDataSources extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        ";NSData;true;init(contentsOf:);;;ReturnValue;remote",
        ";NSData;true;init(contentsOf:options:);;;ReturnValue;remote"
      ]
  }
}

private class NsDataSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";NSData;true;init(bytes:length:);;;Argument[0];ReturnValue;taint",
        ";NSData;true;init(bytesNoCopy:length:);;;Argument[0];ReturnValue;taint",
        ";NSData;true;init(bytesNoCopy:length:deallocator:);;;Argument[0];ReturnValue;taint",
        ";NSData;true;init(bytesNoCopy:length:freeWhenDone:);;;Argument[0];ReturnValue;taint",
        ";NSData;true;init(data:);;;Argument[0];ReturnValue;taint",
        ";NSData;true;init(contentsOfFile:);;;Argument[0];ReturnValue;taint",
        ";NSData;true;init(contentsOfFile:options:);;;Argument[0];ReturnValue;taint",
        ";NSData;true;init(contentsOf:);;;Argument[0];ReturnValue;taint",
        ";NSData;true;init(contentsOf:options:);;;Argument[0];ReturnValue;taint",
        ";NSData;true;init(contentsOfMappedFile:);;;Argument[0];ReturnValue;taint",
        ";NSData;true;init(base64Encoded:options:);;;Argument[0];ReturnValue;taint",
        ";NSData;true;init(base64Encoding:);;;Argument[0];ReturnValue;taint",
        ";NSData;true;base64EncodedData(options:);;;Argument[-1];ReturnValue;taint",
        ";NSData;true;base64EncodedString(options:);;;Argument[-1];ReturnValue;taint",
        ";NSData;true;base64Encoding();;;Argument[-1];ReturnValue;taint",
        ";NSData;true;dataWithContentsOfMappedFile(_:);;;Argument[0];ReturnValue;taint",
        ";NSData;true;enumerateBytes(_:);;;Argument[-1];Argument[0].Parameter[0];taint",
        ";NSData;true;getBytes(_:);;;Argument[-1];Argument[0];taint",
        ";NSData;true;getBytes(_:length:);;;Argument[-1];Argument[0];taint",
        ";NSData;true;getBytes(_:range:);;;Argument[-1];Argument[0];taint",
        ";NSData;true;subdata(with:);;;Argument[-1];ReturnValue;taint",
        ";NSData;true;compressed(using:);;;Argument[-1];ReturnValue;taint",
        ";NSData;true;decompressed(using:);;;Argument[-1];ReturnValue;taint"
      ]
  }
}

private class NsMutableDataSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";NSMutableData;true;append(_:length:);;;Argument[0];Argument[-1];taint",
        ";NSMutableData;true;append(_:);;;Argument[0];Argument[-1];taint",
        ";NSMutableData;true;replaceBytes(in:withBytes:);;;Argument[1];Argument[-1];taint",
        ";NSMutableData;true;replaceBytes(in:withBytes:length:);;;Argument[1];Argument[-1];taint",
        ";NSMutableData;true;setData(_:);;;Argument[0];Argument[-1];taint",
      ]
  }
}

/** A content implying that, if a `NSData` object is tainted, some of its fields are also tainted. */
private class NsDataTaintedFields extends TaintInheritingContent, DataFlow::Content::FieldContent {
  NsDataTaintedFields() {
    exists(FieldDecl f | this.getField() = f |
      f.getEnclosingDecl().asNominalTypeDecl() instanceof NsData and
      f.getName() = ["bytes", "description"]
    )
  }
}

/** A content implying that, if a `NSMutableData` object is tainted, some of its fields are also tainted. */
private class NsMutableDataTaintedFields extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  NsMutableDataTaintedFields() {
    exists(FieldDecl f | this.getField() = f |
      f.getEnclosingDecl().asNominalTypeDecl() instanceof NsMutableData and
      f.getName() = "mutableBytes"
    )
  }
}
