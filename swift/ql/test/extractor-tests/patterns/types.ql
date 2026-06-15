import codeql.swift.elements

from Pattern p, string s
where
  p.getFile().getBaseName() = "patterns.swift" and
  if exists(p.getType()) then s = p.getType().toString() else s = "(none)"
select p, s
