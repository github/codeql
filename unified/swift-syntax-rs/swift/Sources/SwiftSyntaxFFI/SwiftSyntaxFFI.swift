import Foundation
import SwiftParser

// `@_spi(RawSyntax)` exposes `childName(_:)`, which maps a child's key path
// to its field name in the parent layout.
@_spi(RawSyntax) import SwiftSyntax

#if canImport(Glibc)
    import Glibc
#elseif canImport(Darwin)
    import Darwin
#endif

/// Convert an absolute position into `{ offset, line, column }`.
/// `offset` is a UTF-8 byte offset; `line`/`column` are 1-based.
private func location(
    _ position: AbsolutePosition,
    _ converter: SourceLocationConverter
) -> [String: Any] {
    let loc = converter.location(for: position)
    return [
        "offset": position.utf8Offset,
        "line": loc.line,
        "column": loc.column,
    ]
}

/// Trivia kinds worth preserving: comments (including doc comments) and
/// `unexpectedText` (source the parser skipped). Whitespace is dropped since
/// node ranges already encode positions.
private let keptTriviaKinds: Set<String> = [
    "lineComment",
    "blockComment",
    "docLineComment",
    "docBlockComment",
    "unexpectedText",
]

/// Serialize a trivia collection into `{ kind, text, range }` pieces, keeping
/// only kinds in `keptTriviaKinds`. `start` is the absolute position of the
/// first piece (leading trivia at `token.position`; trailing trivia at
/// `token.endPositionBeforeTrailingTrivia`).
private func serializeTrivia(
    _ trivia: Trivia,
    startingAt start: AbsolutePosition,
    _ converter: SourceLocationConverter
) -> [Any] {
    var result: [Any] = []
    var offset = start.utf8Offset
    for piece in trivia.pieces {
        let length = piece.sourceLength.utf8Length
        // Enum-case mirror label gives us a stable kind (e.g. "lineComment")
        // without an exhaustive switch over every TriviaPiece case.
        let kind = Mirror(reflecting: piece).children.first?.label ?? "\(piece)"
        if keptTriviaKinds.contains(kind) {
            result.append([
                "kind": kind,
                "text": Trivia(pieces: [piece]).description,
                "range": [
                    "start": location(AbsolutePosition(utf8Offset: offset), converter),
                    "end": location(AbsolutePosition(utf8Offset: offset + length), converter),
                ],
            ])
        }
        offset += length
    }
    return result
}

/// Recursively convert a SwiftSyntax node into a JSON-serializable value.
///
///   * Tokens carry `kind`, `tokenKind`, `text`, and `range`, plus
///     `leadingTrivia`/`trailingTrivia` when non-empty.
///   * Layout nodes (e.g. `functionDecl`) carry `kind` and `range`, and
///     embed their children as members keyed by the field name in the parent
///     (e.g. `name`, `body`); absent optional children are omitted.
///   * Collection nodes (e.g. `codeBlockItemList`) are elided to a plain array
///     of their serialized elements — their own `kind`/`range` are dropped.
private func serialize(
    _ node: Syntax,
    _ converter: SourceLocationConverter
) -> Any {
    if node.kind.isSyntaxCollection {
        return node.children(viewMode: .sourceAccurate).map {
            serialize($0, converter)
        }
    }

    // Node's content range, excluding surrounding trivia.
    let range: [String: Any] = [
        "start": location(node.positionAfterSkippingLeadingTrivia, converter),
        "end": location(node.endPositionBeforeTrailingTrivia, converter),
    ]

    if let token = node.as(TokenSyntax.self) {
        var result: [String: Any] = [
            "kind": "token",
            "tokenKind": "\(token.tokenKind)",
            "text": token.text,
            "range": range,
        ]
        let leading = serializeTrivia(
            token.leadingTrivia, startingAt: token.position, converter)
        if !leading.isEmpty {
            result["leadingTrivia"] = leading
        }
        let trailing = serializeTrivia(
            token.trailingTrivia,
            startingAt: token.endPositionBeforeTrailingTrivia,
            converter)
        if !trailing.isEmpty {
            result["trailingTrivia"] = trailing
        }
        return result
    }

    var result: [String: Any] = [
        "kind": "\(node.kind)",
        "range": range,
    ]
    var unnamed = 0
    for child in node.children(viewMode: .sourceAccurate) {
        if let keyPath = child.keyPathInParent, let name = childName(keyPath) {
            result[name] = serialize(child, converter)
        } else {
            // Defensive fallback for any unnamed layout child.
            result["child\(unnamed)"] = serialize(child, converter)
            unnamed += 1
        }
    }
    return result
}

/// Parse a NUL-terminated Swift source string and return a heap-allocated,
/// NUL-terminated JSON representation of the syntax tree. Caller must release
/// the returned pointer with `ssr_string_free`. Returns `nil` on failure.
@_cdecl("ssr_parse_json")
public func ssr_parse_json(_ source: UnsafePointer<CChar>?) -> UnsafeMutablePointer<CChar>? {
    guard let source = source else { return nil }
    let code = String(cString: source)
    let tree = Parser.parse(source: code)
    let converter = SourceLocationConverter(fileName: "<input>", tree: tree)
    let json = serialize(Syntax(tree), converter)

    guard
        let data = try? JSONSerialization.data(
            withJSONObject: json, options: [.sortedKeys]),
        let string = String(data: data, encoding: .utf8)
    else {
        return nil
    }
    return strdup(string)
}

/// Free a string previously returned by this library.
@_cdecl("ssr_string_free")
public func ssr_string_free(_ ptr: UnsafeMutablePointer<CChar>?) {
    free(ptr)
}
