import Foundation
import SwiftParser

// `@_spi(RawSyntax)` exposes the `childName(_:)` helper that maps a child's
// key path to its field name in the parent layout; used to emit named fields.
@_spi(RawSyntax) import SwiftSyntax

#if canImport(Glibc)
    import Glibc
#elseif canImport(Darwin)
    import Darwin
#endif

/// Convert an absolute position into an `{ offset, line, column }` dictionary.
///
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

/// Trivia kinds worth preserving in the serialized tree. Comments carry
/// developer intent (including doc comments), and `unexpectedText` flags source
/// the parser had to skip. Whitespace and multi-line-string escape markers are
/// dropped: node ranges already encode positions, so they would only bloat the
/// output.
private let keptTriviaKinds: Set<String> = [
    "lineComment",
    "blockComment",
    "docLineComment",
    "docBlockComment",
    "unexpectedText",
]

/// Serialize a trivia collection into an array of `{ kind, text, range }`
/// pieces, keeping only the kinds in `keptTriviaKinds`.
///
/// `start` is the absolute position of the first piece (a token's leading
/// trivia starts at `token.position`; its trailing trivia at
/// `token.endPositionBeforeTrailingTrivia`). Each piece's range is derived by
/// accumulating piece lengths, so kept pieces carry an exact source location.
private func serializeTrivia(
    _ trivia: Trivia,
    startingAt start: AbsolutePosition,
    _ converter: SourceLocationConverter
) -> [Any] {
    var result: [Any] = []
    var offset = start.utf8Offset
    for piece in trivia.pieces {
        let length = piece.sourceLength.utf8Length
        // The label of an enum case mirror is the case name (e.g. "spaces",
        // "lineComment"), which gives us a stable kind without an exhaustive
        // switch over every `TriviaPiece` case.
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
///     `leadingTrivia`/`trailingTrivia` — but only when non-empty (after
///     filtering, most tokens have no trivia, so the keys are simply absent).
///   * Layout nodes (e.g. `functionDecl`) carry `kind` and source `range`, and
///     additionally embed their children directly as members keyed by the
///     child's name in the parent (e.g. `name`, `signature`, `body`); absent
///     optional children are omitted. Field names never collide with
///     `kind`/`range`.
///   * Collection nodes (e.g. `codeBlockItemList`) are *elided*: they become a
///     plain array of their serialized elements, taking the place of the
///     collection node itself. A list-valued layout field (e.g. `parameters`) is
///     therefore simply a JSON array. This drops the collection node's own
///     `kind`/`range`, which are unnamed and largely recoverable from the
///     elements.
private func serialize(
    _ node: Syntax,
    _ converter: SourceLocationConverter
) -> Any {
    if node.kind.isSyntaxCollection {
        return node.children(viewMode: .sourceAccurate).map {
            serialize($0, converter)
        }
    }

    // Source range covering the node's content, excluding surrounding trivia.
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
        // Only emit trivia when present; after filtering, most tokens have none.
        // Leading trivia starts at the token's own position; trailing trivia
        // starts just after the token's content.
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
        // Layout children are named; embed each under its field name in the
        // parent (the same mechanism SwiftSyntax uses for its debug dump). A
        // child that is a collection serializes to an array (see above).
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

/// Parse the given NUL-terminated Swift source string and return a
/// heap-allocated, NUL-terminated JSON representation of the syntax tree.
///
/// The returned pointer is owned by the caller and MUST be released with
/// `ssr_string_free`. Returns `nil` on failure.
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
