import java

from Type t
where
  t.getName().contains("MyType") and
  t.getName().matches(["List<%", "Stack<%", "MkT<%"])
select t
