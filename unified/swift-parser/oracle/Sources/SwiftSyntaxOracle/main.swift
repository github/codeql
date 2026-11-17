import Foundation
import SwiftOperators
import SwiftParser

// `@_spi(RawSyntax)` exposes the `childName(_:)` helper that maps a child's
// key path to its field name in the parent layout; used to emit named fields.
@_spi(RawSyntax) import SwiftSyntax

#if canImport(Glibc)
    import Glibc
#elseif canImport(Darwin)
    import Darwin
#endif

/// Return the UTF-8 byte offset of the start of every physical source line.
///
/// Deriving this from `SourceLocationConverter.sourceLines` keeps newline
/// handling exactly aligned with swift-syntax (`\n`, `\r`, and `\r\n`).
private func lineStarts(_ converter: SourceLocationConverter) -> [Any] {
    var result: [Any] = []
    var offset = 0
    for line in converter.sourceLines {
        result.append(offset)
        offset += line.utf8.count
    }
    return result
}

/// Trivia kinds worth preserving in the serialized tree. Comments carry
/// developer intent (including doc comments), and `unexpectedText` flags source
/// the parser had to skip. Whitespace and multi-line-string escape markers are
/// dropped: node offsets already encode positions, so they would only bloat the
/// output.
private let keptTriviaKinds: Set<String> = [
    "lineComment",
    "blockComment",
    "docLineComment",
    "docBlockComment",
    "unexpectedText",
]

/// Serialize a trivia collection into an array of `{ kind, text, $pos, $end }`
/// pieces, keeping only the kinds in `keptTriviaKinds`.
///
/// `start` is the absolute position of the first piece (a token's leading
/// trivia starts at `token.position`; its trailing trivia at
/// `token.endPositionBeforeTrailingTrivia`). Each piece's range is derived by
/// accumulating piece lengths, so kept pieces carry an exact source location.
private func serializeTrivia(
    _ trivia: Trivia,
    startingAt start: AbsolutePosition
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
                "$pos": offset,
                "$end": offset + length,
                "kind": kind,
                "text": Trivia(pieces: [piece]).description,
            ])
        }
        offset += length
    }
    return result
}

/// Recursively convert a SwiftSyntax node into a JSON-serializable value.
///
///   * Tokens carry `kind`, `tokenKind`, `text`, `$pos`, and `$end`, plus
///     `leadingTrivia`/`trailingTrivia` — but only when non-empty (after
///     filtering, most tokens have no trivia, so the keys are simply absent).
///   * Layout nodes (e.g. `functionDecl`) carry `kind`, `$pos`, and `$end`,
///     and additionally embed their children directly as members keyed by the
///     child's name in the parent (e.g. `name`, `signature`, `body`); absent
///     optional children are omitted.
///   * Collection nodes (e.g. `codeBlockItemList`) are *elided*: they become a
///     plain array of their serialized elements, taking the place of the
///     collection node itself. A list-valued layout field (e.g. `parameters`) is
///     therefore simply a JSON array. This drops the collection node's own
///     `kind`/location, which are unnamed and largely recoverable from the
///     elements.
private let maximumSerializationDepth = 2048

private struct SerializationDepthError: Error, CustomStringConvertible {
    var description: String {
        "syntax tree exceeds maximum serialization depth (\(maximumSerializationDepth))"
    }
}

private func serialize(_ node: Syntax, depth: Int = 1) throws -> Any {
    if depth > maximumSerializationDepth {
        throw SerializationDepthError()
    }

    if node.kind.isSyntaxCollection {
        return try node.children(viewMode: .sourceAccurate).map {
            try serialize($0, depth: depth + 1)
        }
    }

    // Half-open UTF-8 byte range covering the node's content, excluding
    // surrounding trivia.
    let start = node.positionAfterSkippingLeadingTrivia.utf8Offset
    let end = node.endPositionBeforeTrailingTrivia.utf8Offset

    if let token = node.as(TokenSyntax.self) {
        var result: [String: Any] = [
            "$pos": start,
            "$end": end,
            "kind": "token",
            "tokenKind": "\(token.tokenKind)",
            "text": token.text,
        ]
        // Only emit trivia when present; after filtering, most tokens have none.
        // Leading trivia starts at the token's own position; trailing trivia
        // starts just after the token's content.
        let leading = serializeTrivia(
            token.leadingTrivia, startingAt: token.position)
        if !leading.isEmpty {
            result["leadingTrivia"] = leading
        }
        let trailing = serializeTrivia(
            token.trailingTrivia,
            startingAt: token.endPositionBeforeTrailingTrivia)
        if !trailing.isEmpty {
            result["trailingTrivia"] = trailing
        }
        return result
    }

    var result: [String: Any] = [
        "$pos": start,
        "$end": end,
        "kind": "\(node.kind)",
    ]
    var unnamed = 0
    for child in node.children(viewMode: .sourceAccurate) {
        // Layout children are named; embed each under its field name in the
        // parent (the same mechanism SwiftSyntax uses for its debug dump). A
        // child that is a collection serializes to an array (see above).
        if let keyPath = child.keyPathInParent, let name = childName(keyPath) {
            result[name] = try serialize(child, depth: depth + 1)
        } else {
            // Defensive fallback for any unnamed layout child.
            result["child\(unnamed)"] = try serialize(child, depth: depth + 1)
            unnamed += 1
        }
    }
    return result
}

/// Fold the flat operator sequences in `tree` into structured binary/ternary
/// expressions, using operator precedence.
///
/// Swift's grammar does not encode operator precedence: an expression like
/// `a + b * c` is parsed as a flat `SequenceExpr` (a list of operands and
/// operators). Resolving it into a precedence-correct tree requires knowing the
/// operators' precedence groups, which live in declarations rather than the
/// grammar. We fold using two sources of operator definitions:
///
///   * `OperatorTable.standardOperators` — the Swift standard library's
///     operators (a built-in approximation), and
///   * the operator / precedence-group declarations in *this* file
///     (via `addSourceFile`).
///
/// Operators from anywhere else (e.g. imported from another module) are
/// unknown to us. Rather than guess their precedence — which would silently
/// produce an incorrectly-structured tree — we fold each top-level sequence
/// *independently* and leave any sequence containing an unknown operator as a
/// flat `SequenceExpr`. Downstream can treat such a sequence as unsupported.
/// This keeps folding correct for the operators we do know while isolating the
/// rest per sequence, so one exotic operator doesn't block folding elsewhere.
private func foldOperators(in tree: SourceFileSyntax) -> Syntax {
    var operators = OperatorTable.standardOperators
    // Register operators and precedence groups declared in this file. Swallow
    // errors (e.g. a redeclaration of a standard operator): keep whatever we
    // can and carry on.
    operators.addSourceFile(tree, errorHandler: { _ in })
    return PerSequenceFolder(operators: operators).rewrite(tree)
}

/// A `SyntaxRewriter` that folds each `SequenceExpr` on its own, leaving
/// sequences it cannot fold (because they use an operator we don't know) flat.
///
/// This is deliberately more conservative than `OperatorTable.foldAll`, which
/// is all-or-nothing: with a throwing error handler a single unknown operator
/// aborts folding for the *entire* tree, while with a non-throwing handler
/// unknown operators are folded *arbitrarily* (left-associatively), silently
/// producing a wrong tree. Folding each sequence with a throwing handler and
/// catching the error gives us per-sequence isolation instead.
private final class PerSequenceFolder: SyntaxRewriter {
    private let operators: OperatorTable

    init(operators: OperatorTable) {
        self.operators = operators
        super.init()
    }

    override func visit(_ node: SequenceExprSyntax) -> ExprSyntax {
        // Fold any nested sequences first (bottom-up), so that an unfoldable
        // outer sequence still keeps its foldable inner sequences folded.
        let inner = super.visit(node).as(SequenceExprSyntax.self)!
        do {
            // The default error handler throws on the first unknown operator or
            // incomparable-precedence pair.
            return try operators.foldSingle(inner)
        } catch {
            // Leave this sequence flat; it uses an operator we don't know.
            return ExprSyntax(inner)
        }
    }
}

private struct JSONEncodingError: Error, CustomStringConvertible {
    let type: Any.Type

    var description: String {
        "unsupported JSON value of type \(String(reflecting: type))"
    }
}

private let hexDigits = Array("0123456789abcdef".utf8)

private func appendJSONString(_ string: String, to output: inout [UInt8]) {
    output.append(UInt8(ascii: "\""))
    for scalar in string.unicodeScalars {
        switch scalar.value {
        case 0x08:
            output.append(contentsOf: "\\b".utf8)
        case 0x09:
            output.append(contentsOf: "\\t".utf8)
        case 0x0a:
            output.append(contentsOf: "\\n".utf8)
        case 0x0c:
            output.append(contentsOf: "\\f".utf8)
        case 0x0d:
            output.append(contentsOf: "\\r".utf8)
        case 0x22:
            output.append(contentsOf: "\\\"".utf8)
        case 0x2f:
            output.append(contentsOf: "\\/".utf8)
        case 0x5c:
            output.append(contentsOf: "\\\\".utf8)
        case 0x00...0x1f:
            output.append(contentsOf: "\\u00".utf8)
            output.append(hexDigits[Int(scalar.value >> 4)])
            output.append(hexDigits[Int(scalar.value & 0x0f)])
        default:
            output.append(contentsOf: String(scalar).utf8)
        }
    }
    output.append(UInt8(ascii: "\""))
}

private func appendJSON(_ value: Any, to output: inout [UInt8]) throws {
    switch value {
    case let string as String:
        appendJSONString(string, to: &output)
    case let boolean as Bool:
        output.append(contentsOf: (boolean ? "true" : "false").utf8)
    case let integer as Int:
        output.append(contentsOf: String(integer).utf8)
    case let array as [Any]:
        output.append(UInt8(ascii: "["))
        for (index, element) in array.enumerated() {
            if index != 0 {
                output.append(UInt8(ascii: ","))
            }
            try appendJSON(element, to: &output)
        }
        output.append(UInt8(ascii: "]"))
    case let object as [String: Any]:
        output.append(UInt8(ascii: "{"))
        for (index, key) in object.keys.sorted().enumerated() {
            if index != 0 {
                output.append(UInt8(ascii: ","))
            }
            appendJSONString(key, to: &output)
            output.append(UInt8(ascii: ":"))
            try appendJSON(object[key]!, to: &output)
        }
        output.append(UInt8(ascii: "}"))
    default:
        throw JSONEncodingError(type: type(of: value))
    }
}

private func parse(_ source: String) throws -> String {
    let tree = Parser.parse(source: source)
    // Fold operator sequences before serializing. Source positions are
    // preserved by folding (the same tokens, in the same places), so a
    // converter built from the original tree maps the folded tree correctly.
    let folded = foldOperators(in: tree)
    let converter = SourceLocationConverter(fileName: "<input>", tree: tree)
    let serialized = try serialize(folded)
    guard var json = serialized as? [String: Any] else {
        throw JSONEncodingError(type: type(of: serialized))
    }
    json["$lineStarts"] = lineStarts(converter)
    json["$hasError"] = tree.hasError

    var bytes: [UInt8] = []
    try appendJSON(json, to: &bytes)
    return String(decoding: bytes, as: UTF8.self)
}

private enum InputError: Error, CustomStringConvertible {
    case usage
    case invalidUTF8

    var description: String {
        switch self {
        case .usage: "usage: swift-syntax-parse [FILE]"
        case .invalidUTF8: "source is not valid UTF-8"
        }
    }
}

private func readSource() throws -> String {
    let arguments = CommandLine.arguments.dropFirst()
    guard arguments.count <= 1 else { throw InputError.usage }
    let data: Data
    if let path = arguments.first {
        data = try Data(contentsOf: URL(fileURLWithPath: path))
    } else {
        data = FileHandle.standardInput.readDataToEndOfFile()
    }
    // Validate without letting Foundation's UTF-8 initializer strip a leading BOM.
    let source = String(decoding: data, as: UTF8.self)
    guard source.utf8.elementsEqual(data) else {
        throw InputError.invalidUTF8
    }
    return source
}

do {
    print(try parse(readSource()))
} catch {
    FileHandle.standardError.write(Data("swift-syntax-parse: \(error)\n".utf8))
    exit(1)
}
