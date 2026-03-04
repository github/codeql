/**
 * Provides classes for PHP class-like declarations (classes, interfaces, traits, enums).
 */

private import codeql.php.AST
private import internal.TreeSitter

/** A class-like declaration (class, interface, trait, or enum). */
class ClassLike extends Stmt {
  ClassLike() {
    this instanceof ClassDecl or
    this instanceof InterfaceDecl or
    this instanceof TraitDecl or
    this instanceof EnumDecl
  }

  /** Gets the name of this class-like declaration. */
  Name getName() { none() }

  /** Gets the string name. */
  string getNameString() {
    result = this.getName().getValue()
  }
}

/** A class declaration. */
class ClassDecl extends Stmt, @php_class_declaration {
  override string getAPrimaryQlClass() { result = "ClassDecl" }

  /** Gets the name. */
  Name getName() { php_class_declaration_def(this, _, result) }

  /** Gets the string name. */
  string getNameString() { result = this.getName().getValue() }

  /** Gets the declaration list (body). */
  DeclarationList getBody() { php_class_declaration_def(this, result, _) }

  /** Gets the base clause (extends). */
  BaseClause getBaseClause() { php_class_declaration_child(this, _, result) }

  /** Gets the interface implementation clause. */
  ClassInterfaceClause getInterfaceClause() { php_class_declaration_child(this, _, result) }

  /** Holds if this class extends another class. */
  predicate hasBaseClass() { exists(this.getBaseClause()) }

  override string toString() { result = "class " + this.getNameString() }
}

/** A base clause (`extends ClassName`). */
class BaseClause extends AstNode, @php_base_clause {
  override string getAPrimaryQlClass() { result = "BaseClause" }

  override AstNode getChild(int i) { php_base_clause_child(this, i, result) }

  override string toString() { result = "extends ..." }
}

/** A class interface clause (`implements InterfaceName, ...`). */
class ClassInterfaceClause extends AstNode, @php_class_interface_clause {
  override string getAPrimaryQlClass() { result = "ClassInterfaceClause" }

  AstNode getInterface(int i) { php_class_interface_clause_child(this, i, result) }

  AstNode getAnInterface() { result = this.getInterface(_) }

  override string toString() { result = "implements ..." }
}

/** A declaration list (class body). */
class DeclarationList extends AstNode, @php_declaration_list {
  override string getAPrimaryQlClass() { result = "DeclarationList" }

  AstNode getMember(int i) { php_declaration_list_child(this, i, result) }

  AstNode getAMember() { result = this.getMember(_) }

  override string toString() { result = "{ ... }" }
}

/** An interface declaration. */
class InterfaceDecl extends Stmt, @php_interface_declaration {
  override string getAPrimaryQlClass() { result = "InterfaceDecl" }

  Name getName() { php_interface_declaration_def(this, _, result) }

  string getNameString() { result = this.getName().getValue() }

  DeclarationList getBody() { php_interface_declaration_def(this, result, _) }

  BaseClause getBaseClause() { php_interface_declaration_child(this, result) }

  override string toString() { result = "interface " + this.getNameString() }
}

/** A trait declaration. */
class TraitDecl extends Stmt, @php_trait_declaration {
  override string getAPrimaryQlClass() { result = "TraitDecl" }

  Name getName() { php_trait_declaration_def(this, _, result) }

  string getNameString() { result = this.getName().getValue() }

  DeclarationList getBody() { php_trait_declaration_def(this, result, _) }

  override string toString() { result = "trait " + this.getNameString() }
}

/** An enum declaration. */
class EnumDecl extends Stmt, @php_enum_declaration {
  override string getAPrimaryQlClass() { result = "EnumDecl" }

  Name getName() { php_enum_declaration_def(this, _, result) }

  string getNameString() { result = this.getName().getValue() }

  AstNode getBody() { php_enum_declaration_def(this, result, _) }

  override string toString() { result = "enum " + this.getNameString() }
}

/** An enum case declaration. */
class EnumCase extends AstNode, @php_enum_case {
  override string getAPrimaryQlClass() { result = "EnumCase" }

  Name getName() { php_enum_case_def(this, result) }

  Expr getValue() { php_enum_case_value(this, result) }

  override string toString() { result = "case " + this.getName().getValue() }
}

/** A property declaration. */
class PropertyDecl extends AstNode, @php_property_declaration {
  override string getAPrimaryQlClass() { result = "PropertyDecl" }

  TypeNode getType() { php_property_declaration_type(this, result) }

  override AstNode getChild(int i) { php_property_declaration_child(this, i, result) }

  PropertyElement getAProperty() { php_property_declaration_child(this, _, result) }

  override string toString() { result = "property declaration" }
}

/** A property element within a property declaration. */
class PropertyElement extends AstNode, @php_property_element {
  override string getAPrimaryQlClass() { result = "PropertyElement" }

  VariableName getName() { php_property_element_def(this, result) }

  Expr getDefault() { php_property_element_default_value(this, result) }

  predicate hasDefault() { exists(this.getDefault()) }

  override string toString() { result = this.getName().getValue() }
}

/** A constant declaration. */
class ConstDecl extends AstNode, @php_const_declaration {
  override string getAPrimaryQlClass() { result = "ConstDecl" }

  AstNode getConstant(int i) { php_const_declaration_child(this, i, result) }

  AstNode getAConstant() { result = this.getConstant(_) }

  override string toString() { result = "const ..." }
}

/** A constant element. */
class ConstElement extends AstNode, @php_const_element {
  override string getAPrimaryQlClass() { result = "ConstElement" }

  override AstNode getChild(int i) { php_const_element_child(this, i, result) }

  override string toString() { result = "const element" }
}
