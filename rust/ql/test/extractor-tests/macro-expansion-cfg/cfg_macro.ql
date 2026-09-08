import rust
import TestUtils

query predicate functions(Function f, string name) {
  toBeTested(f) and name = f.getName().getText()
}
