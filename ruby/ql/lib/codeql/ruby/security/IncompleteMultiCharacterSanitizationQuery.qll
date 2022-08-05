/**
 * Provides predicates for reasoning about improper multi-character sanitization.
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.frameworks.core.String
private import codeql.ruby.dataflow.internal.DataFlowDispatch
private import codeql.ruby.security.IncompleteMultiCharacterSanitization

/**
 * Holds if `replace` has a pattern argument containing a regular expression
 * `dangerous` which matches a dangerous string beginning with `prefix`, in
 * attempt to avoid a vulnerability of kind `kind`.
 */
query predicate problems(
  StringSubstitutionCall replace, EmptyReplaceRegExpTerm dangerous, string prefix, string kind
) {
  exists(EmptyReplaceRegExpTerm regexp |
    replace = regexp.getCall() and
    dangerous.getRootTerm() = regexp and
    // skip leading optional elements
    not dangerous.isNullable() and
    // only warn about the longest match
    prefix = max(string m | matchesDangerousPrefix(dangerous, m, kind) | m order by m.length(), m) and
    // only warn once per kind
    not exists(EmptyReplaceRegExpTerm other |
      other = dangerous.getAChild+() or other = dangerous.getPredecessor+()
    |
      matchesDangerousPrefix(other, _, kind) and
      not other.isNullable()
    ) and
    not exists(RegExpCaret c | regexp = c.getRootTerm()) and
    not exists(RegExpDollar d | regexp = d.getRootTerm()) and
    // Don't flag replace operations that are called repeatedly in a loop, as they can actually work correctly.
    not replace.flowsTo(replace.getReceiver+())
  )
}
