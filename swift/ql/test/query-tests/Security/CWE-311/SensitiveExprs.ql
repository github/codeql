import swift
import codeql.swift.security.SensitiveExprs

string describe(SensitiveExpr e) {
  result = "label:" + e.getLabel()
  or
  result = "type:" + e.getSensitiveType().toString()
  or
  e.isProbablySafe() and result = "isProbablySafe"
}

from SensitiveExpr e
where e.getFile().getBaseName() != ""
select e, concat(describe(e), ", ")
