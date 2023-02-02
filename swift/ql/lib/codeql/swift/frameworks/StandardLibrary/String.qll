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
