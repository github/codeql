/**
 * @name Missing security-severity tag
 * @description Queries tagged as `security` should also have a `@security-severity` tag.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id ql/missing-security-severity
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

from TopLevel t
where
  t.getLocation().getFile().getBaseName().matches("%.ql") and
  not t.getLocation().getFile().getRelativePath().matches(["%/experimental/%", "%/examples/%"]) and
  missingSecuritySeverity(t.getQLDoc())
select t, "This query file is missing a `@security-severity` tag."
