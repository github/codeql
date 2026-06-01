private import rust

predicate toBeTested(Element e) {
  not e instanceof CrateElement and
  not e instanceof Builtin and
  (
    not e instanceof Locatable
    or
    exists(e.(Locatable).getFile().getRelativePath())
  )
}

class CrateElement extends Element {
  CrateElement() {
    this instanceof Crate or
    this instanceof NamedCrate
  }
}

class Builtin extends AstNode {
  Builtin() { this.getFile().getAbsolutePath().matches("%/builtins/%.rs") }
}

predicate commmentAt(string text, string filepath, int line) {
  exists(Comment c |
    c.getLocation().hasLocationInfo(filepath, line, _, _, _) and
    c.getCommentText().trim() = text and
    c.fromSource() and
    not text.matches("$%")
  )
}
