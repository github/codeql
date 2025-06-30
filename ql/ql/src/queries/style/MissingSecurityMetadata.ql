/**
 * @name Missing security metadata
 * @description Security queries should have both a `@tag security` and a `@security-severity` tag.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id ql/missing-security-metadata
 * @tags correctness
 */

import ql

private predicate unInterestingLocation(File f) {
  f.getRelativePath().matches("%/" + ["experimental", "examples", "test"] + "/%")
}

predicate missingSecuritySeverity(QueryDoc doc) {
  doc.getQueryTags() = "security" and
  exists(doc.getQueryPrecision()) and
  not exists(doc.getQuerySecuritySeverity())
}

predicate missingSecurityTag(QueryDoc doc) {
  exists(doc.getQuerySecuritySeverity()) and
  exists(doc.getQueryPrecision()) and
  not doc.getQueryTags() = "security"
}

from TopLevel t, QueryDoc doc, string msg
where
  doc = t.getQLDoc() and
  not unInterestingLocation(t.getLocation().getFile()) and
  (
    missingSecuritySeverity(doc) and
    msg = "This query file is missing a `@security-severity` tag."
    or
    missingSecurityTag(doc) and msg = "This query file is missing a `@tags security`."
  )
select t, msg
