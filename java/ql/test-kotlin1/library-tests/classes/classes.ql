import java

from Class c
where c.fromSource()
select c, c.getQualifiedName(), concat(string s | c.hasModifier(s) | s, ", ")
