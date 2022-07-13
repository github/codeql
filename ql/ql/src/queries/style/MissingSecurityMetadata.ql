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

predicate missingSecuritySeverity(QLDoc doc) {
  exists(string s | s = doc.getContents() |
    exists(string securityTag | securityTag = s.splitAt("@") |
      securityTag.matches("tags%security%")
    ) and
    exists(string precisionTag | precisionTag = s.splitAt("@") |
      precisionTag.matches("precision %")
    ) and
    not exists(string securitySeverity | securitySeverity = s.splitAt("@") |
      securitySeverity.matches("security-severity %")
    )
  )
}

predicate missingSecurityTag(QLDoc doc) {
  exists(string s | s = doc.getContents() |
    exists(string securitySeverity | securitySeverity = s.splitAt("@") |
      securitySeverity.matches("security-severity %")
    ) and
    exists(string precisionTag | precisionTag = s.splitAt("@") |
      precisionTag.matches("precision %")
    ) and
    not exists(string securityTag | securityTag = s.splitAt("@") |
      securityTag.matches("tags%security%")
    )
  )
}

from TopLevel t, string msg
where
  t.getLocation().getFile().getBaseName().matches("%.ql") and
  not t.getLocation()
      .getFile()
      .getRelativePath()
      .matches("%/" + ["experimental", "examples", "test"] + "/%") and
  (
    missingSecuritySeverity(t.getQLDoc()) and
    msg = "This query file is missing a `@security-severity` tag."
    or
    missingSecurityTag(t.getQLDoc()) and msg = "This query file is missing a `@tag security`."
  )
select t, msg
