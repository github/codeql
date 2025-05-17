private import rust

predicate toBeTested(Element e) { not e instanceof CrateElement and not e instanceof Builtin }

class CrateElement extends Element {
  CrateElement() {
    this instanceof Crate or
    this instanceof NamedCrate or
    any(Crate c).getSourceFile() = this.(AstNode).getParentNode*()
  }
}

class Builtin extends AstNode {
  Builtin() { this.getFile().getAbsolutePath().matches("%/builtins/%.rs") }
}
