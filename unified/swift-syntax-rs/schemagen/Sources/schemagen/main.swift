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

// The yeast type-ref(s) a child maps to. A collection wrapper is elided by the
// adapter, so a collection child maps to its element kind(s).
func typeRefs(_ child: Child) -> [String] {
    switch child.kind {
    case .node(let k):
        return [k.rawValue]
    case .nodeChoices(let choices, _):
        return choices.flatMap { typeRefs($0) }
    case .collection(let k, _, _, _, _):
        if let coll = SYNTAX_NODES.first(where: { $0.kind == k })?.collectionNode {
            let elems = coll.elementChoices.map { $0.rawValue }
            return elems.isEmpty ? [k.rawValue] : elems
        }
        return [k.rawValue]
    case .token:
        return ["_token"]
    }
}

func isMultiple(_ child: Child) -> Bool {
    if case .collection = child.kind { return true }
    return false
}

var supertypes: [String: [String]] = [:]
var named: [(String, [Child])] = []

for node in SYNTAX_NODES {
    if node.kind.isBase { continue }
    if node.base == .syntaxCollection { continue }  // collections are elided
    supertypes[node.base.rawValue, default: []].append(node.kind.rawValue)
    named.append((node.kind.rawValue, node.layoutNode?.children ?? []))
}

var out = ""
out += "# GENERATED from swift-syntax by unified/swift-syntax-rs/schemagen.\n"
out += "# Do not edit; run unified/scripts/regenerate-node-types.sh instead.\n"
let emitSupertypes = ProcessInfo.processInfo.environment["EMIT_SUPERTYPES"] != "0"
if emitSupertypes {
    out += "supertypes:\n"
    for base in supertypes.keys.sorted() {
        out += "  \(base):\n"
        for m in supertypes[base]!.sorted() { out += "    - \(m)\n" }
    }
}
out += "named:\n"
for (kind, children) in named.sorted(by: { $0.0 < $1.0 }) {
    if children.isEmpty {
        out += "  \(kind):\n"
        continue
    }
    out += "  \(kind):\n"
    for child in children {
        // swift-syntax error-recovery slots (unexpectedBeforeX / unexpected
        // BetweenXAndY) are never matched by rules; elide them.
        if child.name.hasPrefix("unexpected") { continue }
        var key = child.name
        if isMultiple(child) {
            key += "*"
        } else if child.isOptional {
            key += "?"
        }
        let refs = typeRefs(child)
        let value = refs.count == 1 ? refs[0] : "[" + refs.joined(separator: ", ") + "]"
        out += "    \(key): \(value)\n"
    }
}
// Synthetic leaf for token-typed fields, plus the named ("varying") token
// kinds that aren't already emitted as layout nodes (e.g. `stringSegment` is
// both a node and a token kind; emit it once).
let namedKinds = Set(named.map { $0.0 })
out += "  _token:\n"
for t in varyingTokens.sorted() where !namedKinds.contains(t) { out += "  \(t):\n" }

print(out, terminator: "")
