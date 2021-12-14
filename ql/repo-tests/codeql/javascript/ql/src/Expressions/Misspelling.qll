/**
 * Provides predicates for identifying misspellings in JavaScript code.
 */

import javascript
// import typo database (generated from Wikipedia, licensed under CC BY-SA 3.0)
import TypoDatabase

/**
 * Holds if `wrong` is a misspelling of `right` that might be intentional or
 * is not interesting enough to flag.
 */
predicate whitelisted(string wrong, string right) {
  wrong = "thru" and right = "through"
  or
  wrong = "cant" and right = "cannot"
  or
  wrong = "inbetween" and right = "between"
  or
  wrong = "strat" and right = "start" // often used as abbreviation for "strategy"
}

/**
 * Holds if `wrong` is a misspelling of `right` that is not white-listed,
 * where `wrongstart` and `wrongend` are the first and last characters, respectively,
 * of `wrong`, and similarly for `rightstart` and `rightend`.
 */
cached
predicate normalized_typos(
  string wrong, string right, string wrongstart, string wrongend, string rightstart, string rightend
) {
  typos(wrong, right) and
  not whitelisted(wrong, right) and
  // omit very short identifiers, which are often idiosyncratic abbreviations
  wrong.length() > 3 and
  // record first and last characters
  wrongstart = wrong.charAt(0) and
  wrongend = wrong.charAt(wrong.length() - 1) and
  rightstart = right.charAt(0) and
  rightend = right.charAt(right.length() - 1)
}

/**
 * Holds if `part` is an identifier part of `id` starting at `offset`.
 *
 * An identifier part is a maximal substring of an identifier that falls into one
 * of the following categories:
 *
 * 1.  It consists of two or more upper-case characters;
 * 2.  It consists of a single initial upper-case character followed by one or more
 *     lower-case characters, and is not preceded by another upper-case character
 *     (and hence does not overlap with the previous case);
 * 3.  It consists entirely of lower-case characters, which are not preceded by
 *     a single upper-case character (and hence not covered by the previous case).
 *
 * For instance, `memberVariable` has two parts, `member` and
 * `Variable`, as does `member_Variable`.
 *
 * For performance reasons, we restrict our attention to identifier parts
 * that are either known typos or known typo fixes.
 */
cached
predicate idPart(Identifier id, string part, int offset) {
  (normalized_typos(part, _, _, _, _, _) or normalized_typos(_, part, _, _, _, _)) and
  part = id.getName().regexpFind("[A-Z]([A-Z]+|[a-z]+)|[a-z]+", _, offset).toLowerCase()
}

/** An identifier that contains at least one misspelling. */
private class WrongIdentifier extends Identifier {
  WrongIdentifier() {
    exists(string wrongPart |
      idPart(this, wrongPart, _) and
      normalized_typos(wrongPart, _, _, _, _, _)
    )
  }
}

/** A variable whose name contains at least one misspelling. */
private class WrongVariable extends LocalVariable {
  WrongVariable() {
    exists(string wrongPart |
      idPart(this.getADeclaration(), wrongPart, _) and
      normalized_typos(wrongPart, _, _, _, _, _)
    )
  }
}

/** Gets the name of identifier `wrong`, with one misspelling corrected. */
private string replaceATypoAndLowerCase(Identifier wrong) {
  exists(string wrongPart, string rightName, string rightPart, int offset |
    idPart(wrong, wrongPart, offset)
  |
    normalized_typos(wrongPart, rightPart, _, _, _, _) and
    rightName =
      wrong.getName().substring(0, offset) + rightPart +
        wrong.getName().suffix(offset + wrongPart.length()) and
    result = rightName.toLowerCase()
  )
}

/** Gets a scope containing the identifier `wrong`. */
private LocalScope scopeAroundWrongIdentifier(WrongIdentifier wrong) {
  result.getScopeElement() = wrong.getParent+()
}

/** Gets an identifier contained in the scope of variable `wrong`. */
private Identifier idInScopeOfWrongVariable(WrongVariable wrong) {
  result.getParent+() = wrong.getScope().getScopeElement()
}

/**
 * Holds if `gva` is a global variable access contained in the scope
 * of variable declaration `lvd`, such that `gva` is a misspelling
 * of `lvd` or vice versa.
 */
predicate misspelledVariableName(GlobalVarAccess gva, VarDecl lvd) {
  exists(LocalVariable lv | lvd = lv.getADeclaration() |
    lv.getScope() = scopeAroundWrongIdentifier(gva) and
    lv.getName().toLowerCase() = replaceATypoAndLowerCase(gva)
    or
    gva = idInScopeOfWrongVariable(lv) and
    gva.getName().toLowerCase() = replaceATypoAndLowerCase(lvd)
  )
}
