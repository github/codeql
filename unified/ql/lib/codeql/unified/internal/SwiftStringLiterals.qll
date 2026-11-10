/** Provides decoded values of Swift string literals. */
overlay[local?]
module;

private import unified
private import codeql.util.Numbers

private predicate literalContents(StringLiteral literal, string text, string escapePrefix) {
  exists(string raw, string hashes, string quote, string contents |
    raw = literal.getValue().replaceAll("\r\n", "\n").replaceAll("\r", "\n") and
    hashes = raw.regexpCapture("(?s)(#*)(\"\"\"|\")(.*)\\2\\1", 1) and
    quote = raw.regexpCapture("(?s)(#*)(\"\"\"|\")(.*)\\2\\1", 2) and
    contents = raw.regexpCapture("(?s)(#*)(\"\"\"|\")(.*)\\2\\1", 3) and
    escapePrefix = "\\" + hashes
  |
    quote = "\"" and text = contents
    or
    quote = "\"\"\"" and
    exists(string body, string indent |
      body = contents.regexpCapture("(?s)\n(.*)\n([ \t]*)", 1) and
      indent = contents.regexpCapture("(?s)\n(.*)\n([ \t]*)", 2) and
      text = body.regexpReplaceAll("(?m)^" + indent, "")
    )
  )
}

private predicate decodedPart(StringLiteral literal, int start, int end, string value) {
  exists(string text, string prefix |
    literalContents(literal, text, prefix) and
    start in [0 .. text.length() - 1]
  |
    not text.substring(start, start + prefix.length()) = prefix and
    end = start + 1 and
    value = text.charAt(start)
    or
    text.substring(start, start + prefix.length()) = prefix and
    exists(int next | next = start + prefix.length() |
      end = next + 1 and
      (
        text.charAt(next) = "0" and value = 0.toUnicode()
        or
        text.charAt(next) = "t" and value = "\t"
        or
        text.charAt(next) = "n" and value = "\n"
        or
        text.charAt(next) = "r" and value = "\r"
        or
        value = text.charAt(next) and value = ["\\", "\"", "'"]
      )
      or
      exists(string hex |
        hex =
          text.substring(next, text.length()).regexpCapture("(?s)u\\{([0-9a-fA-F]{1,8})\\}.*", 1) and
        end = next + hex.length() + 3 and
        value = parseHexInt(hex).toUnicode()
      )
      or
      exists(string continuation |
        continuation = text.substring(next, text.length()).regexpCapture("(?s)([ \t]*\n).*", 1) and
        end = next + continuation.length() and
        value = ""
      )
    )
  )
}

private predicate decodedOffset(StringLiteral literal, int offset) {
  offset = 0
  or
  decodedPart(literal, _, offset, _) and
  exists(int previous |
    decodedOffset(literal, previous) and
    decodedPart(literal, previous, offset, _)
  )
}

/** Gets the decoded value of `literal`, if it is a complete, valid string literal. */
string getStringValue(StringLiteral literal) {
  exists(string text |
    literalContents(literal, text, _) and
    decodedOffset(literal, text.length())
  |
    result =
      concat(int start, int end, string value |
        decodedOffset(literal, start) and decodedPart(literal, start, end, value)
      |
        value order by start
      )
  )
}
