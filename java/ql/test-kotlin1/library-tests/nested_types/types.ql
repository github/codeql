import java

from Type t
where
  t.getName().matches("%MyType%") and
  t.getName().matches(["List<%", "Stack<%", "MkT<%"])
select t
