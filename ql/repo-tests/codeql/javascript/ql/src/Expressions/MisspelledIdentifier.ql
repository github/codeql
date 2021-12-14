/**
 * @name Misspelled identifier
 * @description Misspelled identifiers make code harder to read and understand.
 * @kind problem
 * @problem.severity recommendation
 * @id js/misspelled-identifier
 * @tags maintainability
 *       readability
 * @precision low
 */

import Misspelling

/**
 * An identifier part.
 */
class IdentifierPart extends string {
  IdentifierPart() { idPart(_, this, _) }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(Identifier id, int start, Location l, int len |
      this.occursIn(id, start, len) and l = id.getLocation()
    |
      filepath = l.getFile().getAbsolutePath() and
      startline = l.getStartLine() and
      startcolumn = l.getStartColumn() + start and
      // identifiers cannot span more than one line
      endline = startline and
      endcolumn = startcolumn + len - 1
    )
  }

  /**
   * Holds if this identifier part occurs at offset `start` inside identifier `id`,
   * and has length `len`.
   */
  predicate occursIn(Identifier id, int start, int len) {
    idPart(id, this, start) and len = this.length()
  }
}

/**
 * An identifier part that corresponds to a typo in `normalized_typos`.
 */
class WrongIdentifierPart extends IdentifierPart {
  WrongIdentifierPart() { normalized_typos(this, _, _, _, _, _) }

  /**
   * Gets an identifier part that corresponds to a correction of this typo.
   */
  string getASuggestion() {
    exists(IdentifierPart right | normalized_typos(this, right, _, _, _, _) |
      result = "'" + right + "'"
    )
  }

  /**
   * Gets a pretty-printed string representation of all corrections of
   * this typo that appear as identifier parts in the code.
   */
  string ppSuggestions() {
    exists(string cat |
      // first, concatenate with commas
      cat = concat(this.getASuggestion(), ", ") and
      // then, replace last comma with "or"
      result = cat.regexpReplaceAll(", ([^,]++)$", " or $1")
    )
  }

  override predicate occursIn(Identifier id, int start, int len) {
    super.occursIn(id, start, len) and
    // throw out cases where the wrong word appears as a prefix or suffix of a right word,
    // and thus the result is most likely a false positive caused by our word segmentation algorithm
    exists(string lowerid | lowerid = id.getName().toLowerCase() |
      not exists(string right, int rightlen |
        this.prefixOf(right, rightlen) and lowerid.substring(start, start + rightlen) = right
        or
        this.suffixOf(right, rightlen) and
        lowerid.substring(start + len - rightlen, start + len) = right
      )
    ) and
    // also throw out cases flagged by another query
    not misspelledVariableName(id, _)
  }

  /**
   * Holds if this identifier part is a (proper) prefix of `right`, which is
   * a correct spelling with length `rightlen`.
   */
  predicate prefixOf(string right, int rightlen) {
    exists(string c, int wronglen |
      normalized_typos(this, _, c, _, _, _) and
      normalized_typos(_, right, _, _, c, _) and
      wronglen = this.length() and
      rightlen = right.length() and
      wronglen < rightlen and
      right.prefix(wronglen) = this
    )
  }

  /**
   * Holds if this identifier part is a (proper) suffix of `right`, which is
   * a correct spelling with length `rightlen`.
   */
  predicate suffixOf(string right, int rightlen) {
    exists(string c, int wronglen |
      normalized_typos(this, _, _, c, _, _) and
      normalized_typos(_, right, _, _, _, c) and
      wronglen = this.length() and
      rightlen = right.length() and
      wronglen < rightlen and
      right.suffix(rightlen - wronglen) = this
    )
  }
}

from WrongIdentifierPart wrong
where
  // make sure we have at least one occurrence of a correction
  exists(wrong.getASuggestion()) and
  // make sure we have at least one unambiguous occurrence of the wrong word
  wrong.occursIn(_, _, _)
select wrong, "'" + wrong + "' may be a typo for " + wrong.ppSuggestions() + "."
