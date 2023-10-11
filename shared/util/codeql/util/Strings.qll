private import Numbers

/**
 * Gets the result of backslash-escaping newlines, carriage-returns, backslashes, and unicode characters in `s`.
 */
bindingset[s]
string escape(string s) {
  result =
    escapeUnicodeString(s.replaceAll("\\", "\\\\")
          .replaceAll("\n", "\\n")
          .replaceAll("\r", "\\r")
          .replaceAll("\t", "\\t"))
}

/**
 * Gets a string where the unicode characters in `s` have been escaped.
 */
bindingset[s]
private string escapeUnicodeString(string s) {
  result =
    concat(int i, string char | char = escapeUnicodeChar(getCodepointAt(s, i)) | char order by i)
}

/**
 * Gets a unicode escaped string for `char`.
 * If `char` is a printable char, then `char` is returned.
 */
bindingset[char]
private string escapeUnicodeChar(string char) {
  if isPrintable(char)
  then result = char
  else
    if exists(to4digitHex(any(int i | i.toUnicode() = char)))
    then result = "\\u" + to4digitHex(any(int i | i.toUnicode() = char))
    else result = "\\u{" + toHex(any(int i | i.toUnicode() = char)) + "}"
}

/** Holds if `char` is easily printable char, or whitespace. */
private predicate isPrintable(string char) {
  exists(asciiPrintable(char))
  or
  char = "\n\r\t".charAt(_)
}

/**
 * Gets the `i`th codepoint in `s`.
 */
bindingset[s]
string getCodepointAt(string s, int i) { result = s.regexpFind("(.|\\s)", i, _) }

/**
 * Gets the length of `s` in codepoints.
 */
bindingset[str]
int getCodepointLength(string str) { result = str.regexpReplaceAll("(.|\\s)", "x").length() }

/**
 * Gets the ASCII code for `char`.
 * Only the easily printable chars are included (so no newline, tab, null, etc).
 */
int asciiPrintable(string char) {
  char =
    rank[result](string c |
      c =
        "! \"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
            .charAt(_)
    )
}
