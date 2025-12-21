/**
 * @name Type System Data Flow Integration
 * @description Integration between type system and data flow analysis
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.types.Type

/**
 * A node in the type-aware data flow graph.
 * This is a placeholder for integration with CodeQL's data flow framework.
 */
class TypedDataFlowNode extends TS::PHP::AstNode {
  TypedDataFlowNode() {
    this instanceof TS::PHP::Expression or
    this instanceof TS::PHP::VariableName
  }
}

/**
 * A type constraint from a parameter type hint.
 */
class ParameterTypeConstraint extends TS::PHP::SimpleParameter {
  ParameterTypeConstraint() {
    exists(this.getType())
  }

  /** Gets the constrained type */
  string getConstrainedType() {
    result = this.getType().(TS::PHP::PrimitiveType).getValue() or
    result = this.getType().(TS::PHP::NamedType).getChild().(TS::PHP::Name).getValue()
  }

  /** Gets the parameter name */
  string getParameterName() {
    result = this.getName().getChild().(TS::PHP::Name).getValue()
  }
}

/**
 * A type constraint from a return type hint.
 */
class ReturnTypeConstraint extends TS::PHP::AstNode {
  string constrainedType;

  ReturnTypeConstraint() {
    exists(TS::PHP::FunctionDefinition f |
      this = f.getReturnType() and
      (
        constrainedType = this.(TS::PHP::PrimitiveType).getValue() or
        constrainedType = this.(TS::PHP::NamedType).getChild().(TS::PHP::Name).getValue()
      )
    )
    or
    exists(TS::PHP::MethodDeclaration m |
      this = m.getReturnType() and
      (
        constrainedType = this.(TS::PHP::PrimitiveType).getValue() or
        constrainedType = this.(TS::PHP::NamedType).getChild().(TS::PHP::Name).getValue()
      )
    )
  }

  /** Gets the constrained return type */
  string getConstrainedType() {
    result = constrainedType
  }
}

/**
 * A type constraint from a property type hint.
 */
class PropertyTypeConstraint extends TS::PHP::PropertyDeclaration {
  PropertyTypeConstraint() {
    exists(this.getType())
  }

  /** Gets the constrained type */
  string getConstrainedType() {
    result = this.getType().(TS::PHP::PrimitiveType).getValue() or
    result = this.getType().(TS::PHP::NamedType).getChild().(TS::PHP::Name).getValue()
  }
}

/**
 * A type assertion through casting.
 */
class TypeAssertion extends TS::PHP::CastExpression {
  /** Gets the asserted type */
  string getAssertedType() {
    exists(string castType | castType = this.getType().(TS::PHP::CastType).getValue() |
      castType in ["int", "integer"] and result = "int" or
      castType in ["float", "double", "real"] and result = "float" or
      castType = "string" and result = "string" or
      castType in ["bool", "boolean"] and result = "bool" or
      castType = "array" and result = "array" or
      castType = "object" and result = "object"
    )
  }

  /** Gets the expression being cast */
  TS::PHP::AstNode getCastExpr() {
    result = this.getValue()
  }
}

/**
 * A type guard from an instanceof check in a conditional.
 */
class TypeGuard extends TS::PHP::BinaryExpression {
  TypeGuard() {
    this.getOperator() = "instanceof"
  }

  /** Gets the guarded expression */
  TS::PHP::AstNode getGuardedExpr() {
    result = this.getLeft()
  }

  /** Gets the guard type */
  string getGuardType() {
    result = this.getRight().(TS::PHP::Name).getValue() or
    result = this.getRight().(TS::PHP::QualifiedName).toString()
  }
}
