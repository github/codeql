import java

from Method m, string s
where m.fromSource() and m.hasModifier(s)
select m, s

query predicate isPublic(Method m) { m.fromSource() and m.isPublic() }

query predicate isInternal(Method m) { m.fromSource() and m.isInternal() }

query predicate modifiers_methods(Modifier mo, Method me) {
  mo.getElement() = me and me.fromSource()
}
