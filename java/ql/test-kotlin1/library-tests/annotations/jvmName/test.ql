import java

query predicate names(Method m, string name, string kotlinName) {
  m.fromSource() and name = m.getName() and kotlinName = m.getKotlinName()
}
