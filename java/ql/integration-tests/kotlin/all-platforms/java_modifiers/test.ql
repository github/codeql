import java

query predicate mods(Method m, string modifiers) {
  m.getName() = "m" and
  modifiers = concat(string s | m.hasModifier(s) | s, ", ")
}
