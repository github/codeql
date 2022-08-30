import java

from Method m, string s
where m.fromSource() and m.hasModifier(s)
select m, s

query predicate isPublic(Method m) { m.fromSource() and m.isPublic() }

query predicate isInternal(Method m) { m.fromSource() and m.isInternal() }
