/**
 * Provides classes for working with PHP declarations (functions, classes, interfaces, traits).
 *
 * This module builds on top of the auto-generated TreeSitter classes
 * to provide a more convenient API for declaration analysis.
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.Locations as L

/**
 * A function definition.
 */
class FunctionDef extends TS::PHP::FunctionDefinition {
  /** Gets the function name. */
  string getName() { result = super.getName().getValue() }

  /** Gets the parameters node. */
  TS::PHP::FormalParameters getParametersNode() { result = this.getParameters() }

  /** Gets the i-th parameter. */
  TS::PHP::AstNode getParameter(int i) { result = this.getParameters().getChild(i) }

  /** Gets any parameter. */
  TS::PHP::AstNode getAParameter() { result = this.getParameters().getChild(_) }

  /** Gets the number of parameters. */
  int getNumParameters() { result = count(this.getAParameter()) }

  /** Gets the function body. */
  TS::PHP::CompoundStatement getBodyNode() { result = this.getBody() }

  /** Gets the return type, if specified. */
  TS::PHP::AstNode getReturnTypeNode() { result = this.getReturnType() }

  /** Holds if this function has a return type. */
  predicate hasReturnType() { exists(this.getReturnType()) }
}

/**
 * A function parameter (simple parameter).
 */
class Parameter extends TS::PHP::SimpleParameter {
  /** Gets the parameter name (without the $). */
  string getName() { result = super.getName().getChild().getValue() }

  /** Gets the type, if specified. */
  TS::PHP::Type getTypeNode() { result = this.getType() }

  /** Gets the default value, if specified. */
  TS::PHP::Expression getDefaultValueExpr() { result = this.getDefaultValue() }

  /** Holds if this has a default value. */
  predicate hasDefaultValue() { exists(this.getDefaultValue()) }

  /** Holds if this is a reference parameter. */
  predicate isReference() { exists(this.getReferenceModifier()) }
}

/**
 * A variadic parameter (...$param).
 */
class VariadicParam extends TS::PHP::VariadicParameter {
  /** Gets the parameter name (without the $). */
  string getName() { result = super.getName().getChild().getValue() }

  /** Gets the type, if specified. */
  TS::PHP::Type getTypeNode() { result = this.getType() }

  /** Holds if this is a reference parameter. */
  predicate isReference() { exists(this.getReferenceModifier()) }
}

/**
 * A constructor parameter with property promotion.
 */
class PromotedParameter extends TS::PHP::PropertyPromotionParameter {
  /** Gets the parameter/property name. */
  TS::PHP::AstNode getNameNode() { result = super.getName() }

  /** Gets the visibility modifier. */
  TS::PHP::VisibilityModifier getVisibilityNode() { result = this.getVisibility() }

  /** Gets the type, if specified. */
  TS::PHP::Type getTypeNode() { result = this.getType() }

  /** Gets the default value, if specified. */
  TS::PHP::Expression getDefaultValueExpr() { result = this.getDefaultValue() }

  /** Holds if this is readonly. */
  predicate isReadonly() { exists(this.getReadonly()) }
}

/**
 * A class declaration.
 */
class ClassDef extends TS::PHP::ClassDeclaration {
  /** Gets the class name. */
  string getName() { result = super.getName().getValue() }

  /** Gets the class body (DeclarationList). */
  TS::PHP::DeclarationList getBodyNode() { result = this.getBody() }

  /** Gets the i-th child modifier/clause. */
  TS::PHP::AstNode getModifier(int i) { result = this.getChild(i) }

  /** Gets any child modifier/clause. */
  TS::PHP::AstNode getAModifier() { result = this.getChild(_) }

  /** Gets the base clause (extends), if any. */
  TS::PHP::BaseClause getBaseClause() { result = this.getChild(_) }

  /** Gets the interface clause (implements), if any. */
  TS::PHP::ClassInterfaceClause getInterfaceClause() { result = this.getChild(_) }

  /** Gets any method in this class. */
  TS::PHP::MethodDeclaration getAMethod() { result = this.getBody().getChild(_) }

  /** Gets any property declaration in this class. */
  TS::PHP::PropertyDeclaration getAProperty() { result = this.getBody().getChild(_) }

  /** Gets any constant declaration in this class. */
  TS::PHP::ConstDeclaration getAConstant() { result = this.getBody().getChild(_) }

  /** Holds if this class has the abstract modifier. */
  predicate isAbstract() { this.getChild(_) instanceof TS::PHP::AbstractModifier }

  /** Holds if this class has the final modifier. */
  predicate isFinal() { this.getChild(_) instanceof TS::PHP::FinalModifier }

  /** Holds if this class has the readonly modifier. */
  predicate isReadonly() { this.getChild(_) instanceof TS::PHP::ReadonlyModifier }
}

/**
 * A method declaration.
 */
class MethodDef extends TS::PHP::MethodDeclaration {
  /** Gets the method name. */
  string getName() { result = super.getName().getValue() }

  /** Gets the parameters node. */
  TS::PHP::FormalParameters getParametersNode() { result = this.getParameters() }

  /** Gets the i-th parameter. */
  TS::PHP::AstNode getParameter(int i) { result = this.getParameters().getChild(i) }

  /** Gets any parameter. */
  TS::PHP::AstNode getAParameter() { result = this.getParameters().getChild(_) }

  /** Gets the number of parameters. */
  int getNumParameters() { result = count(this.getAParameter()) }

  /** Gets the method body, if present (not abstract). */
  TS::PHP::CompoundStatement getBodyNode() { result = this.getBody() }

  /** Gets the return type, if specified. */
  TS::PHP::AstNode getReturnTypeNode() { result = this.getReturnType() }

  /** Gets the i-th modifier. */
  TS::PHP::AstNode getModifier(int i) { result = this.getChild(i) }

  /** Gets any modifier. */
  TS::PHP::AstNode getAModifier() { result = this.getChild(_) }

  /** Holds if this is a static method. */
  predicate isStatic() { this.getChild(_) instanceof TS::PHP::StaticModifier }

  /** Holds if this is an abstract method. */
  predicate isAbstract() { this.getChild(_) instanceof TS::PHP::AbstractModifier }

  /** Holds if this is a final method. */
  predicate isFinal() { this.getChild(_) instanceof TS::PHP::FinalModifier }

  /** Holds if this is a public method. */
  predicate isPublic() {
    exists(TS::PHP::VisibilityModifier v | v = this.getChild(_) |
      v.getChild().getValue() = "public"
    )
  }

  /** Holds if this is a protected method. */
  predicate isProtected() {
    exists(TS::PHP::VisibilityModifier v | v = this.getChild(_) |
      v.getChild().getValue() = "protected"
    )
  }

  /** Holds if this is a private method. */
  predicate isPrivate() {
    exists(TS::PHP::VisibilityModifier v | v = this.getChild(_) |
      v.getChild().getValue() = "private"
    )
  }

  /** Holds if this is a constructor. */
  predicate isConstructor() { this.getName() = "__construct" }

  /** Holds if this is a destructor. */
  predicate isDestructor() { this.getName() = "__destruct" }
}

/**
 * A property declaration in a class.
 */
class PropertyDef extends TS::PHP::PropertyDeclaration {
  /** Gets the type, if specified. */
  TS::PHP::Type getTypeNode() { result = this.getType() }

  /** Gets the i-th modifier. */
  TS::PHP::AstNode getModifier(int i) { result = this.getChild(i) }

  /** Gets any modifier. */
  TS::PHP::AstNode getAModifier() { result = this.getChild(_) }

  /** Gets any property element. */
  TS::PHP::PropertyElement getAPropertyElement() { result = this.getChild(_) }

  /** Holds if this is a static property. */
  predicate isStatic() { this.getChild(_) instanceof TS::PHP::StaticModifier }

  /** Holds if this is a readonly property. */
  predicate isReadonly() { this.getChild(_) instanceof TS::PHP::ReadonlyModifier }

  /** Holds if this is public. */
  predicate isPublic() {
    exists(TS::PHP::VisibilityModifier v | v = this.getChild(_) |
      v.getChild().getValue() = "public"
    ) or
    this.getChild(_) instanceof TS::PHP::VarModifier
  }

  /** Holds if this is protected. */
  predicate isProtected() {
    exists(TS::PHP::VisibilityModifier v | v = this.getChild(_) |
      v.getChild().getValue() = "protected"
    )
  }

  /** Holds if this is private. */
  predicate isPrivate() {
    exists(TS::PHP::VisibilityModifier v | v = this.getChild(_) |
      v.getChild().getValue() = "private"
    )
  }
}

/**
 * An interface declaration.
 */
class InterfaceDef extends TS::PHP::InterfaceDeclaration {
  /** Gets the interface name. */
  string getName() { result = super.getName().getValue() }

  /** Gets the interface body (DeclarationList). */
  TS::PHP::DeclarationList getBodyNode() { result = this.getBody() }

  /** Gets the base clause (extends other interfaces), if any. */
  TS::PHP::BaseClause getBaseClause() { result = this.getChild() }

  /** Gets any method signature in this interface. */
  TS::PHP::MethodDeclaration getAMethod() { result = this.getBody().getChild(_) }

  /** Gets any constant declaration in this interface. */
  TS::PHP::ConstDeclaration getAConstant() { result = this.getBody().getChild(_) }
}

/**
 * A trait declaration.
 */
class TraitDef extends TS::PHP::TraitDeclaration {
  /** Gets the trait name. */
  string getName() { result = super.getName().getValue() }

  /** Gets the trait body (DeclarationList). */
  TS::PHP::DeclarationList getBodyNode() { result = this.getBody() }

  /** Gets any method in this trait. */
  TS::PHP::MethodDeclaration getAMethod() { result = this.getBody().getChild(_) }

  /** Gets any property declaration in this trait. */
  TS::PHP::PropertyDeclaration getAProperty() { result = this.getBody().getChild(_) }
}

/**
 * An enum declaration (PHP 8.1+).
 */
class EnumDef extends TS::PHP::EnumDeclaration {
  /** Gets the enum name. */
  string getName() { result = super.getName().getValue() }

  /** Gets the enum body. */
  TS::PHP::EnumDeclarationList getBodyNode() { result = this.getBody() }

  /** Gets any enum case. */
  TS::PHP::EnumCase getACase() { result = this.getBody().getChild(_) }

  /** Gets any method in this enum. */
  TS::PHP::MethodDeclaration getAMethod() { result = this.getBody().getChild(_) }
}

/**
 * A namespace definition.
 */
class NamespaceDef extends TS::PHP::NamespaceDefinition {
  /** Gets the namespace name node, if any. */
  TS::PHP::NamespaceName getNameNode() { result = this.getName() }

  /** Gets the namespace name as a string. */
  string getNameString() {
    result = concat(TS::PHP::Name n, int i |
        n = this.getName().getChild(i)
      |
        n.getValue(), "\\" order by i
      )
  }

  /** Gets the namespace body, if present. */
  TS::PHP::CompoundStatement getBodyNode() { result = this.getBody() }
}

/**
 * A namespace use declaration.
 */
class UseDecl extends TS::PHP::NamespaceUseDeclaration {
  /** Gets the use type (class/function/const), if specified. */
  TS::PHP::AstNode getUseType() { result = this.getType() }

  /** Gets the use group, if this is a grouped use. */
  TS::PHP::NamespaceUseGroup getUseGroup() { result = this.getBody() }

  /** Gets the i-th use clause. */
  TS::PHP::AstNode getClause(int i) { result = this.getChild(i) }

  /** Gets any use clause. */
  TS::PHP::AstNode getAClause() { result = this.getChild(_) }
}

/**
 * A constant declaration.
 */
class ConstDef extends TS::PHP::ConstDeclaration {
  /** Gets the type, if specified. */
  TS::PHP::Type getTypeNode() { result = this.getType() }

  /** Gets the i-th const element. */
  TS::PHP::ConstElement getElement(int i) { result = this.getChild(i) }

  /** Gets any const element. */
  TS::PHP::ConstElement getAnElement() { result = this.getChild(_) }
}

/**
 * An anonymous class expression.
 */
class AnonymousClassDef extends TS::PHP::AnonymousClass {
  /** Gets the class body (DeclarationList). */
  TS::PHP::DeclarationList getBodyNode() { result = this.getBody() }

  /** Gets any method in this class. */
  TS::PHP::MethodDeclaration getAMethod() { result = this.getBody().getChild(_) }

  /** Gets any property declaration in this class. */
  TS::PHP::PropertyDeclaration getAProperty() { result = this.getBody().getChild(_) }
}

/**
 * A use declaration for traits inside a class.
 */
class TraitUse extends TS::PHP::UseDeclaration {
  /** Gets the i-th trait being used. */
  TS::PHP::AstNode getTrait(int i) { result = this.getChild(i) }

  /** Gets any trait being used. */
  TS::PHP::AstNode getATrait() { result = this.getChild(_) }
}
