import codeql.swift.elements
import TestUtils

from Diagnostics x, string getText, int getKind
where
  getText = x.getText() and
  getKind = x.getKind()
select x, "getText:", getText, "getKind:", getKind
