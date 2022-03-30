import semmle.code.java.security.RelativePaths

from Element elem, string command
where
  relativePath(elem, command) and
  elem.fromSource()
select elem, command
