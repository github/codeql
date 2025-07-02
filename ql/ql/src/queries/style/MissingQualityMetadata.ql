/**
 * @name Missing quality metadata
 * @description Quality queries should have exactly one top-level category and if sub-categories are used, the appropriate top-level category should be used.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id ql/missing-quality-metadata
 * @tags correctness
 */

import ql

private predicate hasQualityTag(QueryDoc doc) { doc.getAQueryTag() = "quality" }

private predicate correctTopLevelCategorisation(QueryDoc doc) {
  strictcount(string s | s = doc.getAQueryTag() and s = ["maintainability", "reliability"]) = 1
}

private predicate reliabilitySubCategory(QueryDoc doc) {
  doc.getAQueryTag() = ["correctness", "performance", "concurrency", "error-handling"]
}

private predicate maintainabilitySubCategory(QueryDoc doc) {
  doc.getAQueryTag() = ["readability", "useless-code", "complexity"]
}

from TopLevel t, QueryDoc doc, string msg
where
  doc = t.getQLDoc() and
  not t.getLocation().getFile() instanceof TestFile and
  hasQualityTag(doc) and
  (
    not correctTopLevelCategorisation(doc) and
    msg =
      "This query file has incorrect top-level categorisation. It should have exactly one top-level category, either `@tags maintainability` or `@tags reliability`."
    or
    maintainabilitySubCategory(doc) and
    not doc.getAQueryTag() = "maintainability" and
    msg =
      "This query file has a sub-category of maintainability but is missing the `@tags maintainability` tag."
    or
    reliabilitySubCategory(doc) and
    not doc.getAQueryTag() = "reliability" and
    msg =
      "This query file has a sub-category of reliability but is missing the `@tags reliability` tag."
  )
select doc, msg
