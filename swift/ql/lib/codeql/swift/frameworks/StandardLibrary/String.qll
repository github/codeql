/**
 * Provides models for `String` and related Swift classes.
 */

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
 * A model for members of `String`, `StringProtocol` and similar classes that permit taint flow.
 */
private class StringSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";StringProtocol;true;init(cString:);;;Argument[0];ReturnValue;taint",
        ";StringProtocol;true;init(cString:);;;Argument[0].CollectionElement;ReturnValue;taint",
        ";StringProtocol;true;init(decoding:as:);;;Argument[0];ReturnValue;taint",
        ";StringProtocol;true;init(decodingCString:as:);;;Argument[0].OptionalSome.CollectionElement;ReturnValue.OptionalSome.TupleElement[0];taint",
        ";StringProtocol;true;addingPercentEncoding(withAllowedCharacter:);;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;addingPercentEscapes(using:);;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;appending(_:);;;Argument[-1..0];ReturnValue;taint",
        ";StringProtocol;true;appendingFormat(_:_:);;;Argument[-1..0];ReturnValue;taint",
        ";StringProtocol;true;appendingFormat(_:_:);;;Argument[1].CollectionElement;ReturnValue;taint",
        ";StringProtocol;true;applyingTransform(_:reverse:);;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;cString(using:);;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;capitalized(with:);;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;completePath(into:caseSensitive:matchesInto:filterTypes:);;;Argument[-1];Argument[0].CollectionElement;taint",
        ";StringProtocol;true;completePath(into:caseSensitive:matchesInto:filterTypes:);;;Argument[-1];Argument[2].CollectionElement.CollectionElement;taint",
        ";StringProtocol;true;components(separatedBy:);;;Argument[-1];ReturnValue.CollectionElement;taint",
        ";StringProtocol;true;data(using:allowLossyConversion:);;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;folding(options:locale:);;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;getBytes(_:maxLength:usedLength:encoding:options:range:remaining:);;;Argument[-1];Argument[0].CollectionElement;taint",
        ";StringProtocol;true;getCString(_:maxLength:encoding:);;;Argument[-1];Argument[0].CollectionElement;taint",
        ";StringProtocol;true;lowercased();;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;lowercased(with:);;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;padding(toLength:withPad:startingAt:);;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;padding(toLength:withPad:startingAt:);;;Argument[1];ReturnValue;taint",
        ";StringProtocol;true;propertyList();;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;propertyListFromStringsFileFormat();;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;replacingCharacters(in:with:);;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;replacingCharacters(in:with:);;;Argument[1];ReturnValue;taint",
        ";StringProtocol;true;replacingOccurrences(of:with:options:range:);;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;replacingOccurrences(of:with:options:range:);;;Argument[1];ReturnValue;taint",
        ";StringProtocol;true;replacingPercentEscapes(using:);;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;substring(from:);;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;substring(with:);;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;trimmingCharacters(in:);;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;uppercased();;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;uppercased(with:);;;Argument[-1];ReturnValue;taint",
        ";StringProtocol;true;withCString(_:);;;Argument[-1];Argument[0].Parameter[0].CollectionElement;taint",
        ";StringProtocol;true;withCString(_:);;;Argument[0].ReturnValue;ReturnValue;value",
        ";StringProtocol;true;withCString(encodedAs:_:);;;Argument[-1];Argument[1].Parameter[0].CollectionElement;taint",
        ";StringProtocol;true;withCString(encodedAs:_:);;;Argument[1].ReturnValue;ReturnValue;value",
        ";String;true;init(decoding:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(_:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(_:);;;Argument[0];ReturnValue.OptionalSome;taint",
        ";String;true;init(repeating:count:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(data:encoding:);;;Argument[0];ReturnValue.OptionalSome;taint",
        ";String;true;init(validatingUTF8:);;;Argument[0];ReturnValue.OptionalSome;taint",
        ";String;true;init(validatingUTF8:);;;Argument[0].CollectionElement;ReturnValue.OptionalSome;taint",
        ";String;true;init(utf16CodeUnits:count:);;;Argument[0].CollectionElement;ReturnValue;taint",
        ";String;true;init(utf16CodeUnitsNoCopy:count:freeWhenDone:);;;Argument[0].CollectionElement;ReturnValue;taint",
        ";String;true;init(format:_:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(format:_:);;;Argument[1].CollectionElement;ReturnValue;taint",
        ";String;true;init(format:arguments:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(format:arguments:);;;Argument[1].CollectionElement;ReturnValue;taint",
        ";String;true;init(format:locale:_:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(format:locale:_:);;;Argument[2].CollectionElement;ReturnValue;taint",
        ";String;true;init(format:locale:arguments:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(format:locale:arguments:);;;Argument[2].CollectionElement;ReturnValue;taint",
        ";String;true;init(_:radix:uppercase:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(bytes:encoding:);;;Argument[0].CollectionElement;ReturnValue.OptionalSome;taint",
        ";String;true;init(bytesNoCopy:length:encoding:freeWhenDone:);;;Argument[0].CollectionElement;ReturnValue.OptionalSome;taint",
        ";String;true;init(describing:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(contentsOf:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(contentsOf:encoding:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(contendsOf:usedEncoding:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(contentsOfFile:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(contentsOfFile:encoding:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(contentsOfFile:usedEncoding:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(from:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(from:);;;Argument[0];ReturnValue.OptionalSome;taint",
        ";String;true;init(stringInterpolation:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(stringLiteral:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(unicodeScalarLiteral:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(extendedGraphemeClusterLiteral:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(cString:encoding:);;;Argument[0];ReturnValue.OptionalSome;taint",
        ";String;true;init(cString:encoding:);;;Argument[0].CollectionElement;ReturnValue.OptionalSome;taint",
        ";String;true;init(platformString:);;;Argument[0];ReturnValue;taint",
        ";String;true;init(platformString:);;;Argument[0].CollectionElement;ReturnValue;taint",
        ";String;true;init(utf8String:);;;Argument[0];ReturnValue.OptionalSome;taint",
        ";String;true;init(utf8String:);;;Argument[0].CollectionElement;ReturnValue.OptionalSome;taint",
        ";String;true;init(validating:);;;Argument[0];ReturnValue.OptionalSome;taint",
        ";String;true;init(validatingPlatformString:);;;Argument[0];ReturnValue.OptionalSome;taint",
        ";String;true;init(validatingPlatformString:);;;Argument[0].CollectionElement;ReturnValue.OptionalSome;taint",
        ";String;true;init(unsafeUninitializedCapacity:initializingUTF8With:);;;Argument[1].Parameter[0].CollectionElement;ReturnValue;taint",
        ";String;true;localizedStringWithFormat(_:_:);;;Argument[0];ReturnValue;taint",
        ";String;true;localizedStringWithFormat(_:_:);;;Argument[1].CollectionElement;ReturnValue;taint",
        ";String;true;insert(contentsOf:at:);;;Argument[0];Argument[-1];taint",
        ";String;true;max();;;Argument[-1];ReturnValue;taint",
        ";String;true;max(by:);;;Argument[-1];ReturnValue;taint",
        ";String;true;min();;;Argument[-1];ReturnValue;taint",
        ";String;true;min(by:);;;Argument[-1];ReturnValue;taint",
        ";String;true;subscript(_:);;;Argument[-1];ReturnValue;taint",
        ";String;true;split(maxSplits:omittingEmptySubsequences:whereSeparator:);;;Argument[-1];ReturnValue;taint",
        ";String;true;randomElement();;;Argument[-1];ReturnValue;taint",
        ";String;true;randomElement(using:);;;Argument[-1];ReturnValue;taint",
        ";String;true;enumerated();;;Argument[-1];ReturnValue;taint",
        ";String;true;encode(to:);;;Argument[-1];Argument[0];taint",
        ";String;true;decodeCString(_:as:repairingInvalidCodeUnits:);;;Argument[0];ReturnValue.TupleElement[0];taint",
        ";String;true;decodeCString(_:as:repairingInvalidCodeUnits:);;;Argument[0].CollectionElement;ReturnValue.TupleElement[0];taint",
        ";String;true;withUTF8(_:);;;Argument[-1];Argument[0].Parameter[0].CollectionElement;taint",
        ";String;true;withUTF8(_:);;;Argument[0].Parameter[0].CollectionElement;Argument[-1];taint",
        ";String;true;withUTF8(_:);;;Argument[0].ReturnValue;ReturnValue;value",
        ";String;true;withPlatformString(_:);;;Argument[-1];Argument[0].Parameter[0].CollectionElement;taint",
        ";String;true;withPlatformString(_:);;;Argument[0].ReturnValue;ReturnValue;value",
        ";String;true;withMutableCharacters(_:);;;Argument[-1];Argument[0].Parameter[0];value",
        ";String;true;withMutableCharacters(_:);;;Argument[0].Parameter[0];Argument[-1];value",
        ";String;true;withMutableCharacters(_:);;;Argument[0].Parameter[0].CollectionElement;Argument[-1];taint",
        ";String;true;withMutableCharacters(_:);;;Argument[0].ReturnValue;ReturnValue;value",
        ";LosslessStringConvertible;true;init(_:);;;Argument[0];ReturnValue;taint",
        ";Substring;true;withUTF8(_:);;;Argument[-1];Argument[0].Parameter[0].CollectionElement;taint",
        ";Substring;true;withUTF8(_:);;;Argument[0].Parameter[0].CollectionElement;Argument[-1];taint",
        ";Substring;true;withUTF8(_:);;;Argument[0].ReturnValue;ReturnValue;value",
      ]
  }
}

/**
 * A content implying that, if a `String`, `StringProtocol` or related class is tainted, then many
 * of its fields are tainted.
 */
private class StringFieldsInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  StringFieldsInheritTaint() {
    exists(FieldDecl fieldDecl, Decl declaringDecl, TypeDecl namedTypeDecl |
      (
        namedTypeDecl.getFullName() = ["String", "StringProtocol"] and
        fieldDecl.getName() =
          [
            "unicodeScalars", "utf8", "utf16", "lazy", "utf8CString", "dataValue",
            "identifierValue", "capitalized", "localizedCapitalized", "localizedLowercase",
            "localizedUppercase", "decomposedStringWithCanonicalMapping",
            "decomposedStringWithCompatibilityMapping", "precomposedStringWithCanonicalMapping",
            "precomposedStringWithCompatibilityMapping", "removingPercentEncoding"
          ]
        or
        namedTypeDecl.getFullName() = ["CustomStringConvertible", "BinaryInteger"] and
        fieldDecl.getName() = "description"
        or
        namedTypeDecl.getFullName() = "CustomDebugStringConvertible" and
        fieldDecl.getName() = "debugDescription"
        or
        namedTypeDecl.getFullName() = "CustomTestStringConvertible" and
        fieldDecl.getName() = "testDescription"
        or
        namedTypeDecl.getFullName() = "CustomURLRepresentationParameterConvertible" and
        fieldDecl.getName() = "urlRepresentationParameter"
        or
        namedTypeDecl.getFullName() = "Substring" and
        fieldDecl.getName() = "base"
      ) and
      declaringDecl.getAMember() = fieldDecl and
      declaringDecl.asNominalTypeDecl() = namedTypeDecl.getADerivedTypeDecl*() and
      this.getField() = fieldDecl
    )
  }
}
