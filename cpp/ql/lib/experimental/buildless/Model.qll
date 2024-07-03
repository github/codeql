import AST

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

    /*
      Any compile-time concept that can be named.
    */
  class Entity extends string
  {
    bindingset[this] Entity() { any() }
  }

  /*
    An entity that contains named members.
  */
  class Scope extends Entity
  {
    bindingset[this] Scope() { any() }

    Member getAMember() { result = this.getAMember(_) }

    abstract Member getAMember(string name);
  }

  /*
    An entity that is a member of a scope.
  */
  class Member extends Entity
  {
    bindingset[this] Member() { any() }

    abstract string getName();
    abstract Scope getParent();
  }

  class Namespace2 extends Member, Scope
  {
    AST::SourceNamespace ns;

    Namespace2() { this = "::" + getQualifiedName(ns) }

    AST::SourceNamespace getAstNode() { result = ns }

    override Namespace2 getParent() { result.getAstNode() = ns.getParent() }

    override string getName() { result = ns.getName() }

    override Member getAMember(string name) {
      result = this.getMemberNamespace(name)
      // !! Types
    }

    Namespace2 getMemberNamespace(string name) {
      result.getParent() = this and result.getName() = name
    }

  }

  class Type extends Member, Scope {
    Type() { exists(SourceTypeDeclaration t | t.getMangledName() = this) }

    AST::SourceType getAstNode() { result = this.getADeclaration().getSourceNode() }

    // string toString() { result = "i am a type" }
    override string getName() { result = this.getADeclaration().getName() }

    Location getLocation() { result = this.getADefinition().getLocation() }

    SourceTypeDeclaration getADeclaration() { result.getMangledName() = this }

    SourceTypeDefinition getADefinition() { result.getMangledName() = this }

    override Member getAMember(string name)
    {
      result = getMemberType(name)
    }

    Type getMemberType(string name)
    {
      none()
    }

    Namespace2 getParentNamespace() {
      result.getAstNode() = this.getADeclaration().getParentNamespace()
    }

    Type getParentType() { result.getADeclaration() = this.getADeclaration().getParentType() }

    override Scope getParent() { result = this.getParentNamespace() or result = this.getParentType() }

    string getFullyQualifiedName() { result = this.getADeclaration().getFullyQualifiedName() }

    Field getAField() { result.getParentType() = this }
  }

  private Type lookupNameInType(Type type, string name)
  {
    // Is the name a member of this type?

    // Is the name in the same scope as the type?

    // Is the name in global scope?

    // TODO!
    none()
  }

  class Field extends string {
    Type containingType;
    SourceTypeDefinition containingTypeDef;
    AST::SourceVariableDeclaration fieldDef;

    Field() {
      containingType.getADefinition() = containingTypeDef and
      fieldDef = containingTypeDef.getAField() and
      this = containingTypeDef.getMangledName() + "::" + fieldDef.getName()
    }

    Location getLocation() { result = fieldDef.getLocation() }

    Type getParentType() { result = containingType }

    string getName() { result = fieldDef.getName() }

    // TODO: The type of the field

  }

  class Element extends TElement {
    string toString() { result = "element" }
  }

  class Namespace extends Element, TNamespace {
    string getFullyQualifiedName() { this = TNamespace(result) }

    override string toString() { result = "namespace " + this.getFullyQualifiedName() }

    NamespaceDeclaration getADeclaration() { result.getNamespace() = this }
  }

  class SourceElement extends Element, TASTNode {
    AST::SourceElement node;

    SourceElement() { this = TASTNode(node) }

    Location getLocation() { result = node.getLocation() }

    AST::SourceElement getSourceNode() { result = node }
  }

  class SourceDeclaration extends SourceElement, TASTNode {
    abstract SourceDeclaration getParent();

    abstract string getName();

    abstract string getMangledName();

    abstract predicate isDefinition();
  }

  abstract class SourceDefinition extends SourceDeclaration { }

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

    override string getMangledName() { result = "::" + this.getFullyQualifiedName() }

    override predicate isDefinition() { any() }
  }

  class SourceTypeDeclaration extends SourceDeclaration {
    AST::SourceTypeDefinition def;

    SourceTypeDeclaration() { def = node }

    override Location getLocation() { result = def.getLocation() }

    override string toString() { result = "typename " + def.getName() }

    string getFullyQualifiedName() {
      if exists(this.getParentNamespace())
      then result = this.getParentNamespace().getFullyQualifiedName() + "::" + this.getName()
      else
        if exists(this.getParentType())
        then result = this.getParentType() + "::" + this.getName()
        else result = this.getName()
    }

    NamespaceDeclaration getParentNamespace() { result.getSourceNode() = def.getParent() }

    SourceTypeDeclaration getParentType() { result.getSourceNode() = def.getParent() }

    override SourceDeclaration getParent() {
      result = this.getParentNamespace() or result = this.getParentType()
    }

    override string getName() { result = def.getName() }

    // Mangled name
    override string getMangledName() {
      if exists(this.getParent())
      then result = this.getParent().getMangledName() + "::" + this.getName()
      else result = "::" + this.getName()
    }

    override predicate isDefinition() { def.isDefinition() }

    AST::SourceVariableDeclaration getAField() {
      result = def.getAMember()
    }
  }

  class SourceTypeDefinition extends SourceTypeDeclaration, SourceDefinition {
    SourceTypeDefinition() { this.isDefinition() }
  }

  class SourceFunctionDeclaration extends SourceDeclaration {
    AST::SourceFunction fn;

    SourceFunctionDeclaration() { fn = node }

    SourceTypeDeclaration getParentType() { result.getSourceNode() = fn.getParent() }

    NamespaceDeclaration getParentNamespace() { result.getSourceNode() = fn.getParent() }

    override SourceDeclaration getParent() {
      result = this.getParentType() or result = this.getParentNamespace()
    }

    override string toString() { result = fn.getName() + "()" }

    override Location getLocation() { result = fn.getLocation() }

    override string getName() { result = fn.getName() }

    override string getMangledName() {
      if exists(this.getParent())
      then result = this.getParent().getMangledName() + "::" + this.getName() + "()"
      else result = "::" + this.getName() + "()"
    }

    override predicate isDefinition() { fn.isDefinition() }
  }

  class SourceFunctionDefinition extends SourceFunctionDeclaration, SourceDefinition {
    SourceFunctionDefinition() { this.isDefinition() }
  }

  predicate invalidParent(SourceDeclaration decl) { decl.getParent+() = decl }
}

// For debugging in context
module TestModel = BuildlessModel<CompiledAST>;
