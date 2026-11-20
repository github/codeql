/**
 * @name Pattern applied to a single stream chunk without carried state
 * @description A regular expression that can match more than one character is applied to one
 *              chunk of a stream at a time, and nothing from the previous chunk is carried over.
 *              A value that straddles two chunks is never matched, so a redaction or blocking
 *              filter forwards it unchanged.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 5.3
 * @precision medium
 * @id js/split-boundary-chunk-filter
 * @tags security
 *       experimental
 *       external/cwe/cwe-693
 */

import javascript

/** A term that matches the empty string only (anchors, boundaries, lookarounds). */
predicate zeroWidth(RegExpTerm t) {
  t instanceof RegExpAnchor or
  t instanceof RegExpWordBoundary or
  t instanceof RegExpNonWordBoundary or
  t instanceof RegExpSubPattern
}

/** Holds if `t` can match a string of two or more characters. */
predicate multiChar(RegExpTerm t) {
  t instanceof InfiniteRepetitionQuantifier
  or
  t.(RegExpRange).getUpperBound() > 1
  or
  t.(RegExpConstant).getValue().length() > 1
  or
  count(RegExpTerm c | c = t.(RegExpSequence).getAChild() and not zeroWidth(c)) > 1
  or
  multiChar(t.getAChild())
}

/** The value that holds one chunk inside a per-chunk stream callback. */
DataFlow::Node chunkValue() {
  // class method _transform(chunk, ...) / _write(chunk, ...)
  exists(MethodDeclaration m | m.getName() = ["_transform", "_write"] |
    result = DataFlow::parameterNode(m.getBody().getParameter(0))
  )
  or
  // Mastra processors: processOutputStream({ part, ... })
  exists(MethodDeclaration m, PropertyPattern pp |
    m.getName() = "processOutputStream" and
    pp.getName() = "part" and
    pp.getContainer() = m.getBody() and
    result = DataFlow::valueNode(pp.getValuePattern().(VarDecl).getVariable().getAnAccess())
  )
  or
  // new Transform({ transform(chunk, ...) }), new TransformStream({ transform(chunk, controller) }),
  // new Writable({ write(chunk, ...) }), through2(function (chunk, enc, cb) {...})
  exists(DataFlow::InvokeNode inv, DataFlow::FunctionNode f |
    inv.getCalleeName() =
      ["Transform", "TransformStream", "Writable", "Duplex", "through2", "through"] and
    (
      f =
        inv.getAnArgument()
            .getALocalSource()
            .(DataFlow::ObjectLiteralNode)
            .getAPropertyWrite(["transform", "write"])
            .getRhs()
            .getAFunctionValue()
      or
      f = inv.getAnArgument().getAFunctionValue()
    ) and
    result = f.getParameter(0)
  )
  or
  // stream.on('data', chunk => ...)
  exists(DataFlow::MethodCallNode on |
    on.getMethodName() = "on" and
    on.getArgument(0).getStringValue() = "data" and
    result = on.getArgument(1).getAFunctionValue().getParameter(0)
  )
  or
  // for await (const chunk of stream) { ... }
  exists(ForOfStmt fo | fo.isAwait() |
    result = DataFlow::valueNode(fo.getLValue().(VarDecl).getVariable().getAnAccess())
  )
}

/**
 * A string operation that applies the regular expression `re` to the string `str`.
 * `resolved` is false when the regular expression object could not be traced to a literal,
 * which only happens for `exec` and `test`, whose receiver must be a regular expression.
 */
predicate regexApplication(DataFlow::MethodCallNode mc, DataFlow::Node str, boolean resolved) {
  exists(RegExpTerm re | re.isRootTerm() and multiChar(re) and resolved = true |
    mc.getMethodName() = ["replace", "replaceAll", "match", "matchAll", "search", "split"] and
    re = RegExp::getRegExpFromNode(mc.getArgument(0)) and
    str = mc.getReceiver()
    or
    mc.getMethodName() = ["test", "exec"] and
    re = RegExp::getRegExpFromNode(mc.getReceiver()) and
    str = mc.getArgument(0)
  )
  or
  mc.getMethodName() = ["test", "exec"] and
  not exists(RegExp::getRegExpFromNode(mc.getReceiver())) and
  str = mc.getArgument(0) and
  resolved = false
}

module ChunkConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source = chunkValue() }

  predicate isSink(DataFlow::Node sink) { regexApplication(_, sink, _) }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    // the chunk's fields (payload.text, choices[0].delta.content, ...)
    succ.(DataFlow::PropRead).getBase() = pred
    or
    // decoding and trimming keep it the same chunk
    exists(DataFlow::MethodCallNode mc | succ = mc and mc.getReceiver() = pred |
      mc.getMethodName() =
        [
          "toString", "trim", "trimStart", "trimEnd", "toLowerCase", "toUpperCase", "normalize",
          "valueOf"
        ]
    )
    or
    exists(DataFlow::CallNode c | succ = c and c.getArgument(0) = pred |
      c.getCalleeName() = ["String", "decode", "decodeURIComponent", "from"]
    )
  }
}

module ChunkFlow = DataFlow::Global<ChunkConfig>;

import ChunkFlow::PathGraph

from
  ChunkFlow::PathNode source, ChunkFlow::PathNode sink, DataFlow::MethodCallNode mc,
  boolean resolved
where
  ChunkFlow::flowPath(source, sink) and
  regexApplication(mc, sink.getNode(), resolved)
select mc, source, sink,
  "A pattern " +
    any(string s |
      if resolved = true
      then s = "that can match more than one character"
      else s = "of unknown width"
    ) +
    " is applied to $@ with no state carried from the previous chunk; a value that straddles two chunks is not matched.",
  source.getNode(), "a single stream chunk"
