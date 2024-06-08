import ast

module BuildlessModel<BuildlessASTSig Sig> {
  module AST = BuildlessAST<Sig>;

  private string getQualifiedName(AST::SourceNamespace ns) {
    not exists(AST::SourceNamespace p | ns = p.getAChild()) and result = ns.getName()
    or
    exists(AST::SourceNamespace p | ns = p.getAChild() and ns != p |
      result = getQualifiedName(p) + "::" + ns.getName()
    )
  }

  private newtype TElement =
    TNamespace(string fqn) { fqn = getQualifiedName(_) } or
    TASTNode(AST::SourceElement node) { any() } 

  class Element extends TElement {
    string toString() { result = "element" }
  }

  class Namespace extends Element, TNamespace {
    string getFullyQualifiedName() { this = TNamespace(result) }

    override string toString() { result = "namespace " + this.getFullyQualifiedName() }
  }

  class SourceElement extends Element, TASTNode
  {
    AST::SourceElement node;

    SourceElement() { this = TASTNode(node) }
    Location getLocation() { result = node.getLocation() }

    AST::SourceElement getSourceNode() { result = node }
  }

  class SourceDeclaration extends SourceElement, TASTNode
  {
    abstract SourceDeclaration getParent();
    abstract string getName();
    abstract string getMangledName();
  }

  class NamespaceDeclaration extends SourceDeclaration {

    AST::SourceNamespace ns;

    NamespaceDeclaration() { ns = node }

    override string getName() { result = ns.getName() }

    Namespace getNamespace() { result.getFullyQualifiedName() = this.getFullyQualifiedName() }

    override string toString() { result = "namespace " + this.getName() + " { ... }" }

    override NamespaceDeclaration getParent() { result.getSourceNode() = node.getParent() }

    string getFullyQualifiedName() {
      if exists(this.getParent())
      then result = this.getParent().getFullyQualifiedName() + "::" + this.getName()
      else result = this.getName()
    }

    override string getMangledName() { result = this.getFullyQualifiedName() }
  }

  class SourceTypeDeclaration extends SourceDeclaration {
    AST::SourceTypeDefinition def;

    SourceTypeDeclaration() { def = node }

    override Location getLocation() { result = def.getLocation() }

    override string toString() { result = "typename " + def.getName() }

    NamespaceDeclaration getParentNamespace() { 
        result.getSourceNode() = def.getParent()
    }

    SourceTypeDeclaration getParentType() { 
        result.getSourceNode() = def.getParent()
    }

    override SourceDeclaration getParent() { 
        result = this.getParentNamespace() or result = this.getParentType()
    }

    override string getName() { result = def.getName() }

    // Mangled name
    override string getMangledName() { 
        if exists(this.getParent()) then result = this.getParent().getMangledName() + 
            "." + this.getName() else result = this.getName() }
  }

  class SourceFunctionDeclaration extends SourceDeclaration
  {
    AST::SourceFunction fn;

    SourceFunctionDeclaration() { fn=node }

    SourceTypeDeclaration getParentType() { result.getSourceNode() = fn.getParent() }
    NamespaceDeclaration getParentNamespace() { result.getSourceNode() = fn.getParent() }

    override SourceDeclaration getParent() { 
        result = this.getParentType() or result = this.getParentNamespace()
    }

    override string toString() { result = fn.getName() + "()" }

    override Location getLocation() { result = fn.getLocation() }

    override string getName() { result = fn.getName() }

    override string getMangledName() { 
        if exists(this.getParent()) then result = this.getParent().getMangledName() + 
            "." + this.getName()+"()" else result = this.getName()+"()" }
}
}

// For debugging in context
module TestModel = BuildlessModel<CompiledAST>;
