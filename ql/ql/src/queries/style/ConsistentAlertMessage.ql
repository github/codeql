/**
 * @name Consistent alert message
 * @description The alert message should be consistent across languages.
 * @kind problem
 * @problem.severity warning
 * @id ql/consistent-alert-message
 * @tags correctness
 * @precision very-high
 */

import ql

/**
 * Gets a string representation of the entire message in `sel`.
 * Ignores everything that is not a string constant.
 */
string getMessage(Select sel) {
  result =
    strictconcat(String e, Location l |
      // is child of an expression in the select (in an odd-indexed position, that's where the message is)
      e.getParent*() = sel.getExpr(any(int i | i % 2 = 1)) and l = e.getFullLocation()
    |
      e.getValue(), " | " order by l.getStartLine(), l.getStartColumn()
    ).trim()
}

/**
 * Gets a language agnostic fingerprint for a Select.
 * The fingerPrint includes e.g. the query-id, the @kind of the query, and the number of expressions in the select.
 *
 * This fingerprint avoids false positives where two queries with the same ID behave differently (which is OK).
 */
string getSelectFingerPrint(Select sel) {
  exists(QueryDoc doc | doc = sel.getQueryDoc() |
    result =
      doc.getQueryId() // query ID (without lang)
        + "-" + doc.getQueryKind() // @kind
        + "-" +
        strictcount(String e | e.getParent*() = sel.getExpr(any(int i | i % 2 = 1))) // the number of string constants in the select
        + "-" + count(sel.getExpr(_)) // and the total number of expressions in the select
  )
}

/**
 * Gets information about the select.
 * The query-id (without language), the language, the message from the select, and a language agnostic fingerprint.
 */
Select parseSelect(string id, string lang, string msg, string fingerPrint) {
  exists(QueryDoc doc |
    doc = result.getQueryDoc() and
    id = doc.getQueryId() and
    lang = doc.getQueryLanguage() and
    fingerPrint = getSelectFingerPrint(result) and
    msg = getMessage(result).toLowerCase() // case normalize, because some languages upper-case methods.
  ) and
  // excluding experimental
  not result.getLocation().getFile().getRelativePath().matches("%/experimental/%") and
  not lang = "ql" // excluding QL-for-QL
}

from Select sel, string id, string lang, string msg, string fingerPrint, string otherLangs
where
  // for a select with a fingerprint
  sel = parseSelect(id, lang, msg, fingerPrint) and
  // there exists other languages with the same fingerprint, but other message
  otherLangs =
    strictconcat(string bad |
      bad != lang and
      exists(parseSelect(id, bad, any(string otherMsg | otherMsg != msg), fingerPrint))
    |
      bad, ", "
    )
select sel,
  "The " + lang + "/" + id + " query does not have the same alert message as " + otherLangs + "."
