import java
import semmle.code.java.DependencyCounts

from RefType t, RefType dep, int num
where
  numDepends(t, dep, num) and
  t.getFile().getStem() = "Example"
select t, dep.getName(), num
