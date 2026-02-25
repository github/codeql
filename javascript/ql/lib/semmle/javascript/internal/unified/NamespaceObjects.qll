overlay[local?]
module;

private import minimal.minimal
private import JSUnified

private newtype TNamespaceObject =
  MkAllocationSite(AstNode node) {
    node instanceof Function
    or
    node instanceof ObjectExpr
  } or
  MkPrototype(Function f) {
    not f instanceof ArrowFunctionExpr and
    not f = any(MethodDeclaration m | not m instanceof ConstructorDeclaration).getBody()
  } or
  MkModuleObject(TopLevel top) or
  MkModuleExportsObject(TopLevel top)

private string getPrettyName1(AstNode node) {
  result = node.(Function).getName() and
  not node = any(ClassDefinition cls).getConstructor().getBody()
  or
  result = node.(ClassDefinition).getName()
  or
  exists(ClassDefinition cls |
    node = cls.getConstructor().getBody() and
    result = cls.getName()
  )
}

private string getPrettyName(AstNode node) {
  result = getPrettyName1(node)
  or
  not exists(getPrettyName1(node)) and
  result = node.toString()
}

class NamespaceObject extends TNamespaceObject {
  predicate isAllocationSite(AstNode node) { this = MkAllocationSite(node) }

  predicate isPrototype(Function f) { this = MkPrototype(f) }

  predicate isModuleObject(TopLevel top) { this = MkModuleObject(top) }

  predicate isModuleExportsObject(TopLevel top) { this = MkModuleExportsObject(top) }

  AstNode asAstNode() {
    this.isAllocationSite(result) or
    this.isPrototype(result) or
    this.isModuleObject(result) or
    this.isModuleExportsObject(result)
  }

  string toString() {
    exists(AstNode node |
      this.isAllocationSite(node) and
      result = getPrettyName(node)
      or
      this.isPrototype(node) and
      result = "[prototype] " + getPrettyName(node)
    )
    or
    exists(TopLevel top |
      this.isModuleObject(top) and
      result = "[module] " + top
    )
    or
    exists(TopLevel top |
      this.isModuleExportsObject(top) and
      result = "[module.exports] " + top
    )
  }

  Location getLocation() { result = this.asAstNode().getLocation() }

  StmtContainer getEnclosingCallable() {
    result = this.asAstNode().getContainer() or result = this.asAstNode().(TopLevel)
  }
}

module NamespaceObject {
  NamespaceObject allocationSite(AstNode node) { result.isAllocationSite(node) }

  NamespaceObject prototype(Function f) { result.isPrototype(f) }

  NamespaceObject moduleObject(TopLevel top) { result.isModuleObject(top) }

  NamespaceObject moduleExportsObject(TopLevel top) { result.isModuleExportsObject(top) }
}

class ClassLikeObject extends NamespaceObject {
  private Function f;

  ClassLikeObject() {
    this.isAllocationSite(f) and
    any(NamespaceObject obj).isPrototype(f)
  }

  NamespaceObject getInstancePrototype() { result.isPrototype(f) }

  Function getConstructor() { result = f }
}
