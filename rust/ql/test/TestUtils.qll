private import rust

predicate toBeTested(Element e) { not e instanceof CrateElement }

class CrateElement extends Element {
  CrateElement() {
    this instanceof Crate or
    this instanceof NamedCrate or
    any(Crate c).getModule() = this.(AstNode).getParentNode*()
  }
}
