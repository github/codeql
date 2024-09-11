/**
 * Classes and predicates for working with suspicious character ranges.
 */

private import RegexTreeView

/**
 * Classes and predicates implementing an analysis detecting suspicious character ranges.
 */
module Make<RegexTreeViewSig TreeImpl> {
  private import TreeImpl
  private import codeql.util.Strings as Strings

  /**
   * Gets a rank for `range` that is unique for ranges in the same file.
   * Prioritizes ranges that match more characters.
   */
  int rankRange(RegExpCharacterRange range) {
    range =
      rank[result](RegExpCharacterRange r, int startline, int startcolumn, int low, int high |
        r.hasLocationInfo(_, startline, startcolumn, _, _) and
        isRange(r, low, high)
      |
        r order by (high - low) desc, startline, startcolumn
      )
  }

  /** Holds if `range` spans from the unicode code points `low` to `high` (both inclusive). */
  predicate isRange(RegExpCharacterRange range, int low, int high) {
    exists(string lowc, string highc |
      range.isRange(lowc, highc) and
      low.toUnicode() = lowc and
      high.toUnicode() = highc
    )
  }

  /** Holds if `char` is an alpha-numeric character. */
  predicate isAlphanumeric(string char) {
    // written like this to avoid having a bindingset for the predicate
    char = [[48 .. 57], [65 .. 90], [97 .. 122]].toUnicode() // 0-9, A-Z, a-z
  }

  /**
   * Holds if the given ranges are from the same character class
   * and there exists at least one character matched by both ranges.
   */
  predicate overlap(RegExpCharacterRange a, RegExpCharacterRange b) {
    exists(RegExpCharacterClass clz |
      a = clz.getAChild() and
      b = clz.getAChild() and
      a != b
    |
      exists(int alow, int ahigh, int blow, int bhigh |
        isRange(a, alow, ahigh) and
        isRange(b, blow, bhigh) and
        alow <= bhigh and
        blow <= ahigh
      )
    )
  }

  /**
   * Holds if `range` overlaps with the char class `escape` from the same character class.
   */
  predicate overlapsWithCharEscape(RegExpCharacterRange range, RegExpCharacterClassEscape escape) {
    exists(RegExpCharacterClass clz, string low, string high |
      range = clz.getAChild() and
      escape = clz.getAChild() and
      range.isRange(low, high)
    |
      escape.getValue() = "w" and
      getInRange(low, high).regexpMatch("\\w")
      or
      escape.getValue() = "d" and
      getInRange(low, high).regexpMatch("\\d")
      or
      escape.getValue() = "s" and
      getInRange(low, high).regexpMatch("\\s")
    )
  }

  /** Gets the unicode code point for a `char`. */
  bindingset[char]
  int toCodePoint(string char) { result.toUnicode() = char }

  final private class FinalRegExpCharacterRange = RegExpCharacterRange;

  /** A character range that appears to be overly wide. */
  class OverlyWideRange extends FinalRegExpCharacterRange {
    OverlyWideRange() {
      exists(int low, int high, int numChars |
        isRange(this, low, high) and
        numChars = (1 + high - low) and
        this.getRootTerm().isUsedAsRegExp() and
        numChars >= 10
      |
        // across the Z-a range (which includes backticks)
        toCodePoint("Z") >= low and
        toCodePoint("a") <= high
        or
        // across the 9-A range (which includes e.g. ; and ?)
        toCodePoint("9") >= low and
        toCodePoint("A") <= high
        or
        // a non-alphanumeric char as part of the range boundaries
        exists(int bound | bound = [low, high] | not isAlphanumeric(bound.toUnicode())) and
        // while still being ascii
        low < 128 and
        high < 128
      ) and
      // allowlist for known ranges
      not this = allowedWideRanges()
    }

    /** Gets a string representation of a character class that matches the same chars as this range. */
    string printEquivalent() { result = RangePrinter::printEquivalentCharClass(this) }
  }

  /** Gets a range that should not be reported as an overly wide range. */
  RegExpCharacterRange allowedWideRanges() {
    // ~ is the last printable ASCII character, it's used right in various wide ranges.
    result.isRange(_, "~")
    or
    // the same with " " and "!". " " is the first printable character, and "!" is the first non-white-space printable character.
    result.isRange([" ", "!"], _)
    or
    // the `[@-_]` range is intentional
    result.isRange("@", "_")
    or
    // starting from the zero byte is a good indication that it's purposely matching a large range.
    result.isRange(0.toUnicode(), _)
    or
    // the range 0123456789:;<=>? is intentional
    result.isRange("0", "?")
    or
    // [@-Z] is intentional, it's the same as [A-Z@]
    result.isRange("@", "Z")
  }

  /** Gets a char between (and including) `low` and `high`. */
  bindingset[low, high]
  private string getInRange(string low, string high) {
    result = [toCodePoint(low) .. toCodePoint(high)].toUnicode()
  }

  /** A module computing an equivalent character class for an overly wide range. */
  module RangePrinter {
    bindingset[char]
    bindingset[result]
    private string next(string char) {
      exists(int prev, int next |
        prev.toUnicode() = char and
        next.toUnicode() = result and
        next = prev + 1
      )
    }

    /** Gets the points where the parts of the pretty printed range should be cut off. */
    private string cutoffs() { result = ["A", "Z", "a", "z", "0", "9"] }

    /** Gets the char to use in the low end of a range for a given `cut` */
    private string lowCut(string cut) {
      cut = ["A", "a", "0"] and
      result = cut
      or
      cut = ["Z", "z", "9"] and
      result = next(cut)
    }

    /** Gets the char to use in the high end of a range for a given `cut` */
    private string highCut(string cut) {
      cut = ["Z", "z", "9"] and
      result = cut
      or
      cut = ["A", "a", "0"] and
      next(result) = cut
    }

    /** Gets the cutoff char used for a given `part` of a range when pretty-printing it. */
    private string cutoff(OverlyWideRange range, int part) {
      exists(int low, int high | isRange(range, low, high) |
        result =
          rank[part + 1](string cut |
            cut = cutoffs() and low < toCodePoint(cut) and toCodePoint(cut) < high
          |
            cut order by toCodePoint(cut)
          )
      )
    }

    /** Gets the number of parts we should print for a given `range`. */
    private int parts(OverlyWideRange range) { result = 1 + count(cutoff(range, _)) }

    /** Holds if the given part of a range should span from `low` to `high`. */
    private predicate part(OverlyWideRange range, int part, string low, string high) {
      // first part.
      part = 0 and
      (
        range.isRange(low, high) and
        parts(range) = 1
        or
        parts(range) >= 2 and
        range.isRange(low, _) and
        high = highCut(cutoff(range, part))
      )
      or
      // middle
      part >= 1 and
      part < parts(range) - 1 and
      low = lowCut(cutoff(range, part - 1)) and
      high = highCut(cutoff(range, part))
      or
      // last.
      part = parts(range) - 1 and
      low = lowCut(cutoff(range, part - 1)) and
      range.isRange(_, high)
    }

    /** Gets an escaped `char` for use in a character class. */
    bindingset[char]
    private string escape(string char) {
      exists(string reg | reg = "(\\[|\\]|\\\\|-|/)" |
        if char.regexpMatch(reg) then result = "\\" + char else result = Strings::escape(char)
      )
    }

    /** Gets a part of the equivalent range. */
    private string printEquivalentCharClass(OverlyWideRange range, int part) {
      exists(string low, string high | part(range, part, low, high) |
        if
          isAlphanumeric(low) and
          isAlphanumeric(high)
        then result = low + "-" + high
        else
          result =
            strictconcat(string char | char = getInRange(low, high) | escape(char) order by char)
      )
    }

    /** Gets the entire pretty printed equivalent range. */
    string printEquivalentCharClass(OverlyWideRange range) {
      result =
        strictconcat(string r, int part |
          r = "[" and part = -1 and exists(range)
          or
          r = printEquivalentCharClass(range, part)
          or
          r = "]" and part = parts(range)
        |
          r order by part
        )
    }
  }

  /** Gets a char range that is overly large because of `reason`. */
  RegExpCharacterRange getABadRange(string reason, int priority) {
    result instanceof OverlyWideRange and
    priority = 0 and
    exists(string equiv | equiv = result.(OverlyWideRange).printEquivalent() |
      if equiv.length() <= 50
      then reason = "is equivalent to " + equiv
      else reason = "is equivalent to " + equiv.substring(0, 50) + "..."
    )
    or
    priority = 1 and
    exists(RegExpCharacterRange other |
      reason = "overlaps with " + Strings::escape(other.toString()) + " in the same character class" and
      rankRange(result) < rankRange(other) and
      overlap(result, other)
    )
    or
    priority = 2 and
    exists(RegExpCharacterClassEscape escape |
      reason =
        "overlaps with " + escapeRegExpCharacterClassEscape(escape) + " in the same character class" and
      overlapsWithCharEscape(result, escape)
    )
    or
    reason = "is empty" and
    priority = 3 and
    exists(int low, int high |
      isRange(result, low, high) and
      low > high
    )
  }

  pragma[inline]
  private string escapeRegExpCharacterClassEscape(RegExpCharacterClassEscape escape) {
    if escape.toString().matches("%-%")
    then result = Strings::escape(escape.toString()) // might contain unicode characters
    else result = escape.toString() // just a plain `\d` or `\w` etc. Those are already escaped.
  }

  /** Holds if `range` matches suspiciously many characters. */
  predicate problem(RegExpCharacterRange range, string reason) {
    reason =
      strictconcat(string m, int priority |
        range = getABadRange(m, priority)
      |
        m, ", and " order by priority desc
      ) and
    // specifying a range using an escape is usually OK.
    not range.getAChild() instanceof RegExpEscape and
    // Unicode escapes in strings are interpreted before it turns into a regexp,
    // so e.g. [\u0001-\uFFFF] will just turn up as a range between two constants.
    // We therefore exclude these ranges.
    range.getRootTerm().getParent() instanceof RegExpLiteral and
    // is used as regexp (mostly for JS where regular expressions are parsed eagerly)
    range.getRootTerm().isUsedAsRegExp()
  }
}
