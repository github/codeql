import Foundation
import SyntaxSupport

// Named-leaf ("varying") token kinds, mirroring the extractor adapter's
// VARYING_TOKEN_KINDS. Fixed tokens are anonymous (keyed by text) and are not
// matched by any rule, so they are not emitted here.
let varyingTokens = [
    "identifier", "integerLiteral", "floatLiteral", "stringSegment",
    "binaryOperator", "prefixOperator", "postfixOperator", "dollarIdentifier",
    "regexLiteralPattern", "rawStringPoundDelimiter", "regexPoundDelimiter",
    "shebang", "unknown",
]

// The yeast type references a child maps to. A collection wrapper is elided by
// the adapter, so a collection child maps to its element kinds.
func typeRefs(_ child: Child) -> [String] {
    switch child.kind {
    case .node(let kind):
        return [kind.rawValue]
    case .nodeChoices(let choices, _):
        return choices.flatMap { typeRefs($0) }
    case .collection(let kind, _, _, _, _):
        if let collection = SYNTAX_NODES.first(where: { $0.kind == kind })?.collectionNode {
            let elements = collection.elementChoices.map { $0.rawValue }
            return elements.isEmpty ? [kind.rawValue] : elements
        }
        return [kind.rawValue]
    case .token:
        return ["_token"]
    }
}

func isMultiple(_ child: Child) -> Bool {
    if case .collection = child.kind {
        return true
    }
    return false
}

var supertypes: [String: [String]] = [:]
var named: [(String, [Child])] = []

for node in SYNTAX_NODES {
    if node.kind.isBase {
        continue
    }
    if node.base == .syntaxCollection {
        continue
    }
    supertypes[node.base.rawValue, default: []].append(node.kind.rawValue)
    named.append((node.kind.rawValue, node.layoutNode?.children ?? []))
}

var output = ""
output += "# GENERATED from swift-syntax by unified/swift-syntax-rs/schemagen.\n"
output += "# Do not edit; run unified/scripts/regenerate-node-types.sh instead.\n"
let emitSupertypes = ProcessInfo.processInfo.environment["EMIT_SUPERTYPES"] != "0"
if emitSupertypes {
    output += "supertypes:\n"
    for base in supertypes.keys.sorted() {
        output += "  \(base):\n"
        for member in supertypes[base]!.sorted() {
            output += "    - \(member)\n"
        }
    }
}
output += "named:\n"
for (kind, children) in named.sorted(by: { $0.0 < $1.0 }) {
    output += "  \(kind):\n"
    for child in children {
        // swift-syntax error-recovery slots (`unexpectedBeforeX` and
        // `unexpectedBetweenXAndY`) are never matched by rules.
        if child.name.hasPrefix("unexpected") {
            continue
        }
        var key = child.name
        if isMultiple(child) {
            key += "*"
        } else if child.isOptional {
            key += "?"
        }
        let refs = typeRefs(child)
        let value = refs.count == 1 ? refs[0] : "[" + refs.joined(separator: ", ") + "]"
        output += "    \(key): \(value)\n"
    }
}

// Synthetic leaf for token-typed fields, plus the named ("varying") token
// kinds that are not already emitted as layout nodes (`stringSegment`, for
// example, is both a node and a token kind and must only be emitted once).
let namedKinds = Set(named.map { $0.0 })
output += "  _token:\n"
for token in varyingTokens.sorted() where !namedKinds.contains(token) {
    output += "  \(token):\n"
}

print(output, terminator: "")
