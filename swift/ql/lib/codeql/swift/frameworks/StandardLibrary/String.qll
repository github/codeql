import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSteps

/**
 * A model for `String` members that are sources of remote flow.
 */
private class StringSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        // String(contentsOf:) is a remote flow source
        ";String;true;init(contentsOf:);(URL);;ReturnValue;remote",
        ";String;true;init(contentsOf:encoding:);(URL,String.Encoding);;ReturnValue;remote",
        ";String;true;init(contentsOf:usedEncoding:);(URL,String.Encoding);;ReturnValue;remote",
        // String(contentsOfFile:) is a local flow source
        ";String;true;init(contentsOfFile:);(String);;ReturnValue;local",
        ";String;true;init(contentsOfFile:encoding:);(String,String.Encoding);;ReturnValue;local",
        ";String;true;init(contentsOfFile:usedEncoding:);(String,String.Encoding);;ReturnValue;local"
      ]
  }
}

/**
 * A model for `String` and `StringProtocol` members that permit taint flow.
 */
private class StringSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";StringProtocol;true;init(cString:);;;Argument[0];ReturnValue;taint",
        ";StringProtocol;true;init(decoding:as:);;;Argument[0];ReturnValue;taint",
        ";StringProtocol;true;init(decodingCString:as:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(decoding:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(_:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(repeating:count:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(data:encoding:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(validatingUTF8:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(utf16CodeUnits:count:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(utf16CodeUnitsNoCopy:count:freeWhenDone:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(format:_:);;;Argument[0];ReturnValue;taint", //0..
        ";String;true;init(format:arguments:);;;Argument[0..1];ReturnValue;taint",
        ";String;true;init(format:locale:_:);;;Argument[0];ReturnValue;taint", //0,2..
        ";String;true;init(format:locale:arguments:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(_:radix:uppercase:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(bytes:encoding:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(bytesNoCopy:length:encoding:freeWhenDone);;;Argument[0];ReturnValue;taint",
        ";String;true;init(describing:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(contentsOf:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(contentsOf:encoding:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(contendsOf:usedEncoding:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(contentsOfFile:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(contentsOfFile:encoding:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(contentsOfFile:usedEncoding:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(from:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(stringInterpolation:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(stringLiteral:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(unicodeScalarLiteral:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(extendedGraphemeClusterLiteral:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(cString:encoding:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(platformString:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(utf8String:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(validating:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(validatingPlatformString:);;;Argument[0];ReturnValue;taint",
        ";String;true;localizedStringWithFormat(_:_:);;;Argument[0..1];ReturnValue;taint",
        ";String;true;write(_:);;;Argument[0];Argument[-1];taint",
        ";String;true;write(to:);;;Argument[-1];Argument[0];taint",
        ";String;true;append(_:);;;Argument[0];Argument[-1];taint",
        ";String;true;append(contentsOf:);;;Argument[0];Argument[-1];taint",
        ";String;true;insert(_:at:);;;Argument[0];Argument[-1];taint",
        ";String;true;insert(contentsOf:at:);;;Argument[0];Argument[-1];taint",
        ";String;true;replaceSubrange(_:with::);;;Argument[1];Argument[-1];taint",
        ";String;true;popLast();;;Argument[-1];ReturnValue;taint",
        ";String;true;lowercased();;;Argument[-1];ReturnValue;taint",
        ";String;true;uppercased();;;Argument[-1];ReturnValue;taint",
        ";String;true;first(where:);;;Argument[-1];ReturnValue;taint",
        ";String;true;last(where:);;;Argument[-1];ReturnValue;taint",
        ";String;true;max();;;Argument[-1];ReturnValue;taint",
        ";String;true;max(by:);;;Argument[-1];ReturnValue;taint",
        ";String;true;min();;;Argument[-1];ReturnValue;taint",
        ";String;true;min(by:);;;Argument[-1];ReturnValue;taint",
        ";String;true;subscript(_:);;;Argument[-1];ReturnValue;taint",
        ";String;true;prefix(_:);;;Argument[-1];ReturnValue;taint",
        ";String;true;prefix(through:);;;Argument[-1];ReturnValue;taint",
        ";String;true;prefix(upTo:);;;Argument[-1];ReturnValue;taint",
        ";String;true;prefix(while:);;;Argument[-1];ReturnValue;taint",
        ";String;true;suffix(_:);;;Argument[-1];ReturnValue;taint",
        ";String;true;suffix(from:);;;Argument[-1];ReturnValue;taint",
        ";String;true;split(separator:maxSplits:omittingEmptySubsequences:);;;Argument[-1];ReturnValue;taint",
        ";String;true;split(maxSplits:omittingEmptySubsequences:whereSeparator:);;;Argument[-1];ReturnValue;taint",
        ";String;true;randomElement();;;Argument[-1];ReturnValue;taint",
        ";String;true;randomElement(using:);;;Argument[-1];ReturnValue;taint",
        ";String;true;enumerated();;;Argument[-1];ReturnValue;taint",
        ";String;true;reversed();;;Argument[-1];ReturnValue;taint",
        ";String;true;encode(to:);;;Argument[-1];Argument[0];taint"
      ]
  }
}

/**
 * A content implying that, if a `String` is tainted, then all its fields are
 * tainted. This also includes fields declared in `StringProtocol`.
 */
private class StringFieldsInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent {
  StringFieldsInheritTaint() {
    exists(FieldDecl f | this.getField() = f |
      (
        f.getEnclosingDecl().(NominalTypeDecl).getName() = ["String", "StringProtocol"] or
        f.getEnclosingDecl().(ExtensionDecl).getExtendedTypeDecl().getName() =
          ["String", "StringProtocol"]
      ) and
      f.getName() =
        [
          "first", "last", "unicodeScalars", "utf8", "utf16", "lazy", "utf8CString", "description",
          "debugDescription", "dataValue", "identifierValue", "capitalized", "localizedCapitalized",
          "localizedLowercase", "localizedUppercase", "decomposedStringWithCanonicalMapping",
          "decomposedStringWithCompatibilityMapping", "precomposedStringWithCanonicalMapping",
          "precomposedStringWithCompatibilityMapping", "removingPercentEncoding"
        ]
    )
  }
}
