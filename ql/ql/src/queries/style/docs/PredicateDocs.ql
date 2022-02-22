/**
 * @name Predicate QLDoc style.
 * @description The QLDoc for a predicate should start with "Gets" or "Holds".
 * @kind problem
 * @problem.severity warning
 * @id ql/pred-doc-style
 * @tags maintainability
 * @precision very-high
 */

import ql

string docLines(Predicate pred) {
  result =
    pred.getQLDoc().getContents().replaceAll("/**", "").replaceAll("*", "").splitAt("\n").trim()
}

from Predicate pred, string message
where
  not pred.isPrivate() and
  // only considering qldocs that look like a class-doc, to avoid reporting way too much.
  docLines(pred).matches(["A", "An", "The"] + " %") and // looks like a class doc.
  not pred instanceof NewTypeBranch and // <- these are actually kinda class-like.
  (
    exists(pred.getReturnTypeExpr()) and
    not docLines(pred)
        .matches([
            "Gets %", //
            "Get %", //
            "Holds %", // <- predicates without a result can sometimes still use 'Holds'.
            "Create %", //
            "Creates %", //
            "INTERNAL%", //
            "DEPRECATED%", //
            "EXPERIMENTAL%"
          ]) and
    message = "The QLDoc for a predicate with a result should start with 'Gets'."
    or
    not exists(pred.getReturnTypeExpr()) and
    not docLines(pred)
        .matches([
            "Holds %", //
            "INTERNAL%", //
            "DEPRECATED%", //
            "EXPERIMENTAL%" //
          ]) and
    message = "The QLDoc for a predicate without a result should start with 'Holds'."
  )
select pred.getQLDoc(), message
