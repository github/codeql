/**
 * Provides models for `NSString` and related Swift classes.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSteps

/**
 * A model for `NSString` members that are sources of remote flow.
 */
private class NsStringSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        // NSString(contentsOf:) is a remote flow source
        ";NSString;true;init(contentsOf:);;;ReturnValue;remote",
        ";NSString;true;init(contentsOf:encoding:);;;ReturnValue;remote",
        ";NSString;true;init(contentsOf:usedEncoding:);;;ReturnValue;remote",
        ";NSString;true;string(withContentsOf:);;;ReturnValue;remote",
        // NSString(contentsOfFile:) is a local flow source
        ";NSString;true;init(contentsOfFile:);;;ReturnValue;local",
        ";NSString;true;init(contentsOfFile:encoding:);;;ReturnValue;local",
        ";NSString;true;init(contentsOfFile:usedEncoding:);;;ReturnValue;local",
        ";NSString;true;string(withContentsOfFile:);;;ReturnValue;local"
      ]
  }
}

/**
 * A model for `NSString` and `NSMtableString` members that permit taint flow.
 */
private class NsStringSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";NSString;true;init(bytes:length:encoding:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(bytesNoCopy:length:encoding:freeWhenDone:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(bytesNoCopy:length:encoding:deallocator:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(characters:length:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(charactersNoCopy:length:freeWhenDone:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(charactersNoCopy:length:dellocator:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(string:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(cString:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(cString:encoding:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(cString:length:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(cStringNoCopy:length:freeWhenDone:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(utf8String:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(format:arguments:);;;Argument[0..1];ReturnValue;taint",
        ";NSString;true;init(format:locale:arguments:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(format:locale:arguments:);;;Argument[2];ReturnValue;taint",
        ";NSString;true;init(format:_:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(format:_:);;;Argument[1].CollectionElement;ReturnValue;taint",
        ";NSString;true;init(format:locale:_:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(format:locale:_:);;;Argument[2].CollectionElement;ReturnValue;taint",
        ";NSString;true;init(data:encoding:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(contentsOfFile:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(contentsOfFile:encoding:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(contentsOfFile:usedEncoding:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(contentsOf:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(contentsOf:encoding:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(contentsOf:usedEncoding:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;init(coder:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;localizedStringWithFormat(_:_:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;localizedStringWithFormat(_:_:);;;Argument[1].CollectionElement;ReturnValue;taint",
        ";NSString;true;character(at:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;getCharacters(_:);;;Argument[-1];Argument[0];taint",
        ";NSString;true;getCharacters(_:range:);;;Argument[-1];Argument[0];taint",
        ";NSString;true;getBytes(_:maxLength:usedLength:encoding:options:range:remaining:);;;Argument[-1];Argument[0];taint",
        ";NSString;true;cString(using:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;cString();;;Argument[-1];ReturnValue;taint",
        ";NSString;true;lossyCString();;;Argument[-1];ReturnValue;taint",
        ";NSString;true;getCString(_:);;;Argument[-1];Argument[0];taint",
        ";NSString;true;getCString(_:maxLength:);;;Argument[-1];Argument[0];taint",
        ";NSString;true;getCString(_:maxLength:encoding:);;;Argument[-1];Argument[0];taint",
        ";NSString;true;getCString(_:maxLength:range:remaining:);;;Argument[-1];Argument[0];taint",
        ";NSString;true;appendingFormat(_:_:);;;Argument[-1..0];ReturnValue;taint",
        ";NSString;true;appendingFormat(_:_:);;;Argument[1].CollectionElement;ReturnValue;taint",
        ";NSString;true;appending(_:);;;Argument[-1..0];ReturnValue;taint",
        ";NSString;true;padding(toLength:withPad:startingAt:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;padding(toLength:withPad:startingAt:);;;Argument[1];ReturnValue;taint",
        ";NSString;true;lowercased(with:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;uppercased(with:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;capitalized(with:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;components(separatedBy:);;;Argument[-1];ReturnValue.CollectionElement;taint",
        ";NSString;true;trimmingCharacters(in:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;substring(from:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;substring(with:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;substring(to:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;folding(options:locale:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;applyingTransform(_:reverse:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;replacingOccurrences(of:with:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;replacingOccurrences(of:with:);;;Argument[1];ReturnValue;taint",
        ";NSString;true;replacingOccurrences(of:with:options:range:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;replacingOccurrences(of:with:options:range:);;;Argument[1];ReturnValue;taint",
        ";NSString;true;replacingCharacters(in:with:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;replacingCharacters(in:with:);;;Argument[1];ReturnValue;taint",
        ";NSString;true;propertyList();;;Argument[-1];ReturnValue;taint",
        ";NSString;true;propertyListFromStringsFileFormat();;;Argument[-1];ReturnValue;taint",
        ";NSString;true;variantFittingPresentationWidth(_:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;stringEncoding(for:encodingOptions:convertedString:usedLossyCompression:);;;Argument[0];Argument[2];taint",
        ";NSString;true;data(using:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;data(using:allowLossyConversion:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;path(withComponents:);;;Argument[0].CollectionElement;ReturnValue;taint",
        ";NSString;true;completePath(into:caseSensitive:matchesInto:filterTypes:);;;Argument[-1];Argument[0].CollectionElement;taint",
        ";NSString;true;completePath(into:caseSensitive:matchesInto:filterTypes:);;;Argument[-1];Argument[2].CollectionElement.CollectionElement;taint",
        ";NSString;true;getFileSystemRepresentation(_:maxLength:);;;Argument[-1];Argument[0];taint",
        ";NSString;true;appendingPathComponent(_:);;;Argument[-1..0];ReturnValue;taint",
        ";NSString;true;appendingPathComponent(_:conformingTo:);;;Argument[-1..0];ReturnValue;taint",
        ";NSString;true;appendingPathExtension(_:);;;Argument[-1..0];ReturnValue;taint",
        ";NSString;true;strings(byAppendingPaths:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;strings(byAppendingPaths:);;;Argument[0].CollectionElement;ReturnValue;taint",
        ";NSString;true;addingPercentEncoding(withAllowedCharacters:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;string(withCString:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;string(withCString:length:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;string(withContentsOfFile:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;string(withContentsOf:);;;Argument[0];ReturnValue;taint",
        ";NSString;true;addingPercentEscapes(using:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;replacingPercentEscapes(using:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;applyTransform(_:reverse:range:updatedRange:);;;Argument[-1];ReturnValue;taint",
        ";NSString;true;enumerateLines(_:);;;Argument[-1];Argument[0].Parameter[0];taint",
        ";NSString;true;enumerateSubstrings(in:options:using:);;;Argument[-1];Argument[2].Parameter[0].OptionalSome;taint",
        ";NSString;true;enumerateSubstrings(in:options:using:);;;Argument[2].Parameter[0].OptionalSome;Argument[-1];taint",
        ";NSString;true;enumerateLinguisticTags(in:scheme:options:orthography:using:);;;Argument[-1];Argument[4].Parameter[0].OptionalSome;taint",
        ";NSMutableString;true;append(_:);;;Argument[0];Argument[-1];taint",
        ";NSMutableString;true;insert(_:at:);;;Argument[0];Argument[-1];taint",
        ";NSMutableString;true;replaceCharacters(in:with:);;;Argument[1];Argument[-1];taint",
        ";NSMutableString;true;replaceOccurrences(of:with:options:range:);;;Argument[1];Argument[-1];taint",
        ";NSMutableString;true;setString(_:);;;Argument[0];Argument[-1];taint",
        ";NSMutableString;true;appendFormat(_:_:);;;Argument[0];Argument[-1];taint",
        ";NSMutableString;true;appendFormat(_:_:);;;Argument[1].CollectionElement;Argument[-1];taint",
      ]
  }
}

/**
 * A content implying that, if an `NSString` is tainted, then many of its fields are
 * tainted.
 */
private class NsStringFieldsInheritTaint extends TaintInheritingContent,
  DataFlow::Content::FieldContent
{
  NsStringFieldsInheritTaint() {
    this.getField()
        .hasQualifiedName("NSString",
          [
            "utf8String", "lowercased", "localizedLowedCase", "uppercased", "localizedUppercase",
            "capitalized", "localizedCapitalized", "decomposedStringWithCanonicalMapping",
            "decomposedStringWithCompatibilityMapping", "precomposedStringWithCanonicalMapping",
            "precomposedStringWithCompatibilityMapping", "doubleValue", "floatValue", "intValue",
            "integerValue", "longLongValue", "boolValue", "description", "pathComponents",
            "fileSystemRepresentation", "lastPathComponent", "pathExtension",
            "abbreviatingWithTildeInPath", "deletingLastPathComponent", "deletingPathExtension",
            "expandingTildeInPath", "resolvingSymlinksInPath", "standardizingPath",
            "removingPercentEncoding"
          ])
  }
}
