/**
 * @name Potentially misspelled property or variable name
 * @description A property or variable is only mentioned once, but there is one with the same name
 *              in different capitalization that is mentioned more than once, suggesting that this
 *              may be a typo.
 * @kind problem
 * @problem.severity warning
 * @id js/wrong-capitalization
 * @tags reliability
 * @precision low
 * @deprecated This query is prone to false positives. Deprecated since 1.17.
 */

import javascript

/** Gets the number of identifiers and string literals that refer to `name`. */
int countOccurrences(string name) {
  (
    exists(PropAccess pacc | name = pacc.getPropertyName()) or
    exists(VarAccess acc | name = acc.getName())
  ) and
  result = strictcount(Expr id |
      id.(Identifier).getName() = name
      or
      // count string literals as well to capture meta-programming
      id.getStringValue() = name
    )
}

/**
 * An access to an undeclared variable or property that is only referenced
 * once in the entire program.
 */
abstract class Hapax extends @expr {
  /** Gets the name of the accessed variable or property. */
  abstract string getName();

  /** Gets a textual representation of this element. */
  string toString() { result = this.(Expr).toString() }
}

/**
 * An access to a property that is covered neither by a JSLint property declaration
 * nor by an externs declaration, and that is only mentioned once in the entire program.
 */
class UndeclaredPropertyAccess extends Hapax, @dotexpr {
  UndeclaredPropertyAccess() {
    exists(string name | name = this.(DotExpr).getPropertyName() |
      countOccurrences(name) = 1 and
      not exists(JSLintProperties jslpd | jslpd.appliesTo(this) and jslpd.getAProperty() = name) and
      not exists(ExternalMemberDecl emd | emd.getProperty() = this)
    )
  }

  override string getName() { result = this.(DotExpr).getPropertyName() }
}

/**
 * An access to a global variable that is neither declared nor covered by a linter
 * directive, and that is only mentioned once in the entire program.
 */
class UndeclaredGlobal extends Hapax, @varaccess {
  UndeclaredGlobal() {
    exists(GlobalVariable gv, string name | this = gv.getAnAccess() and name = gv.getName() |
      countOccurrences(name) = 1 and
      not exists(Linting::GlobalDeclaration glob | glob.declaresGlobalForAccess(this)) and
      not exists(gv.getADeclaration())
    )
  }

  override string getName() { result = this.(VarAccess).getName() }
}

/**
 * Gets the number of occurrences of `m`, which is the same as `hapax`
 * except for capitalization, ensuring that it occurs at least twice.
 */
int candidateSpellingCount(Hapax hapax, string m) {
  exists(string n | n = hapax.getName() |
    m.toLowerCase() = n.toLowerCase() and
    m != n and
    result = countOccurrences(m) and
    result > 1
  )
}

from Hapax hapax, string n, string m
where
  n = hapax.getName() and
  candidateSpellingCount(hapax, m) = max(candidateSpellingCount(hapax, _))
select hapax.(Expr), "'" + n + "' is mentioned only once; it may be a typo for '" + m + "'."
