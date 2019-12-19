import semmle.code.cpp.models.interfaces.Alias

class Fread extends AliasFunction {
  Fread() { this.hasGlobalName("fread") }

  override predicate parameterNeverEscapes(int n) {
    n = 0 or
    n = 3
  }

  override predicate parameterEscapesOnlyViaReturn(int n) { none() }

  override predicate parameterIsAlwaysReturned(int n) { none() }
}
