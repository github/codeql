import ast

module BuildlessModel<BuildlessASTSig Sig> {
  module AST = Buildless<Sig>;

  private string getQualifiedName(AST::SourceNamespace ns) {
    not exists(AST::SourceNamespace p | ns = p.getAChild()) and result = ns.getName()
    or
    exists(AST::SourceNamespace p | ns = p.getAChild() and ns !=p|
      result = getQualifiedName(p) + "::" + ns.getName()
    )
  }

  private newtype TElement =
    TNamespace(string fqn) { fqn = getQualifiedName(_) } or
    TNamespaceDeclaration(AST::SourceNamespace ns)

  class Element extends TElement {
    string toString() { result = "element" }
  }

  class Namespace extends Element, TNamespace {
    string getFullyQualifiedName() { this = TNamespace(result) }

    override string toString() { result = "namespace " + this.getFullyQualifiedName() }
  }

  class NamespaceDeclaration extends Element, TNamespaceDeclaration {

    AST::SourceNamespace ns;

    NamespaceDeclaration() { this = TNamespaceDeclaration(ns) }

    Location getLocation() {
      result = ns.getLocation()
    }

    string getName() {
      result = ns.getName()
    }

    Namespace getNamespace() { result.getFullyQualifiedName() = getQualifiedName(ns) }

    override string toString() { result = "namespace " + this.getName() + " { ... }" }
  }
}

// For debugging in context
module TestTypes = BuildlessModel<CompiledAST>;
