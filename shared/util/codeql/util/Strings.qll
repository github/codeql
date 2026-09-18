/** Provides predicates for working with strings. */
overlay[local?]
module;

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
    concat(int i, string char |
      char = escapeUnicodeChar(s.codePointAt(i).toUnicode())
    |
      char order by i
    )
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
 * Unpaired surrogates are skipped.
 */
bindingset[s]
string getCodepointAt(string s, int i) {
  // codePointAt returns the integer codePoint, so we need to convert to a string.
  // codePointAt returns integers for both the high and low end. The invalid strings are filtered out by `toUnicode`, but we need to re-count the index, therefore the rank.
  // rank is 1-indexed, so we need to offset for that to make this predicate 0-indexed.
  result =
    rank[i + 1](string char, int charIndex |
      char = s.codePointAt(charIndex).toUnicode()
    |
      char order by charIndex
    )
}

/**
 * Gets any unicode character that appears in `s`.
 */
bindingset[s]
string getACodepoint(string s) { result = s.codePointAt(_).toUnicode() }

/**
 * Gets the number of unicode codepoints in `s` not counting unpaired surrogates.
 */
bindingset[str]
int getCodepointLength(string str) { result = str.codePointCount(0, str.length()) }

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

/**
 * Escapes all characters in `s` that have special meaning in regular expressions.
 */
bindingset[s]
string regexpEscape(string s) {
  result = s.regexpReplaceAll("([\\\\.*+?\\[^\\]$(){}=!<>|:\\-])", "\\\\$1")
}

/** Provides the input to `InverseAppend`. */
signature module InverseAppendInputSig {
  /** A prefix matching result. */
  bindingset[this]
  class Result;

  /**
   * Holds if `prefix` is a prefix candidate with resulting value `res`.
   */
  predicate prefixCandidate(string prefix, Result res);
}

/** Provides the `inverseAppend` predicate. */
module InverseAppend<InverseAppendInputSig Input> {
  /**
   * Holds if `s = prefix + suffix` with resulting value `res`.
   *
   * The predicate avoids unnecessary result fan-out by first constraining the
   * prefix using a regular expression match.
   */
  bindingset[s]
  predicate inverseAppend(string s, string prefix, string suffix, Input::Result res) {
    exists(string regexp |
      regexp =
        "(" +
          strictconcat(string prefixCand |
            Input::prefixCandidate(prefixCand, _)
          |
            regexpEscape(prefixCand), "|"
          ) + ").*" and
      prefix = s.regexpCapture(regexp, 1) and
      s = prefix + suffix and
      Input::prefixCandidate(prefix, res)
    )
  }
}

/** Provides the input to `InverseAppend1`. */
signature module InverseAppend1InputSig {
  /** A prefix matching context. */
  bindingset[this]
  class C;

  /** A prefix matching result. */
  bindingset[this]
  class Result;

  /**
   * Holds if `prefix` is a prefix candidate in the context `c`
   * with resulting value `res`.
   */
  predicate prefixCandidate(string prefix, C c, Result res);
}

/** Provides the `inverseAppend` predicate. */
module InverseAppend1<InverseAppend1InputSig Input> {
  /**
   * Holds if `s = prefix + suffix` in the context `c` with resulting
   * value `res`.
   *
   * The predicate avoids unnecessary result fan-out by first constraining the
   * prefix using a regular expression match.
   */
  bindingset[s]
  predicate inverseAppend(string s, string prefix, string suffix, Input::C c, Input::Result res) {
    exists(string regexp |
      regexp =
        "(" +
          strictconcat(string prefixCand |
            Input::prefixCandidate(prefixCand, c, _)
          |
            regexpEscape(prefixCand), "|"
          ) + ").*" and
      prefix = s.regexpCapture(regexp, 1) and
      s = prefix + suffix and
      Input::prefixCandidate(prefix, c, res)
    )
  }
}

/** Provides the input to `InverseAppend2`. */
signature module InverseAppend2InputSig {
  /** A prefix matching context. */
  bindingset[this]
  class C1;

  /** A prefix matching context. */
  bindingset[this]
  class C2;

  /** A prefix matching result. */
  bindingset[this]
  class Result;

  /**
   * Holds if `prefix` is a prefix candidate in the context `(c1, c2)`
   * with resulting value `res`.
   */
  predicate prefixCandidate(string prefix, C1 c1, C2 c2, Result res);
}

/** Provides the `inverseAppend` predicate. */
module InverseAppend2<InverseAppend2InputSig Input> {
  /**
   * Holds if `s = prefix + suffix` in the context `(c1, c2)` with resulting
   * value `res`.
   *
   * The predicate avoids unnecessary result fan-out by first constraining the
   * prefix using a regular expression match.
   */
  bindingset[s]
  predicate inverseAppend(
    string s, string prefix, string suffix, Input::C1 c1, Input::C2 c2, Input::Result res
  ) {
    exists(string regexp |
      regexp =
        "(" +
          strictconcat(string prefixCand |
            Input::prefixCandidate(prefixCand, c1, c2, _)
          |
            regexpEscape(prefixCand), "|"
          ) + ").*" and
      prefix = s.regexpCapture(regexp, 1) and
      s = prefix + suffix and
      Input::prefixCandidate(prefix, c1, c2, res)
    )
  }
}

/** Provides the input to `InverseAppend3`. */
signature module InverseAppend3InputSig {
  /** A prefix matching context. */
  bindingset[this]
  class C1;

  /** A prefix matching context. */
  bindingset[this]
  class C2;

  /** A prefix matching context. */
  bindingset[this]
  class C3;

  /** A prefix matching result. */
  bindingset[this]
  class Result;

  /**
   * Holds if `prefix` is a prefix candidate in the context `(c1, c2, c3)`
   * with resulting value `res`.
   */
  predicate prefixCandidate(string prefix, C1 c1, C2 c2, C3 c3, Result res);
}

/** Provides the `inverseAppend` predicate. */
module InverseAppend3<InverseAppend3InputSig Input> {
  /**
   * Holds if `s = prefix + suffix` in the context `(c1, c2, c3)` with resulting
   * value `res`.
   *
   * The predicate avoids unnecessary result fan-out by first constraining the
   * prefix using a regular expression match.
   */
  bindingset[s]
  predicate inverseAppend(
    string s, string prefix, string suffix, Input::C1 c1, Input::C2 c2, Input::C3 c3,
    Input::Result res
  ) {
    exists(string regexp |
      regexp =
        "(" +
          strictconcat(string prefixCand |
            Input::prefixCandidate(prefixCand, c1, c2, c3, _)
          |
            regexpEscape(prefixCand), "|"
          ) + ").*" and
      prefix = s.regexpCapture(regexp, 1) and
      s = prefix + suffix and
      Input::prefixCandidate(prefix, c1, c2, c3, res)
    )
  }
}
