/**
 * @name Type Propagation
 * @description Type propagation through assignments and data flow
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * An assignment that propagates type information.
 */
class TypePropagatingAssignment extends TS::PHP::AssignmentExpression {
  /** Gets the variable being assigned */
  TS::PHP::VariableName getAssignedVariable() {
    result = this.getLeft()
  }

  /** Gets the value being assigned */
  TS::PHP::AstNode getAssignedValue() {
    result = this.getRight()
  }
}

/**
 * A reference assignment.
 */
class ReferenceAssignment extends TS::PHP::AssignmentExpression {
  ReferenceAssignment() {
    this.getRight() instanceof TS::PHP::ReferenceAssignmentExpression
  }
}

/**
 * A compound assignment (+=, -=, etc.).
 */
class CompoundAssignment extends TS::PHP::AugmentedAssignmentExpression {
  /** Gets the operator used */
  string getCompoundOperator() {
    result = this.getOperator()
  }

  /** Gets the variable being modified */
  TS::PHP::VariableName getModifiedVariable() {
    result = this.getLeft()
  }
}

/**
 * A variable that receives a value from a parameter.
 */
class ParameterVariable extends TS::PHP::VariableName {
  TS::PHP::SimpleParameter param;

  ParameterVariable() {
    this = param.getName()
  }

  /** Gets the parameter this variable corresponds to */
  TS::PHP::SimpleParameter getParameter() {
    result = param
  }

  /** Gets the declared type if available */
  string getDeclaredType() {
    result = param.getType().(TS::PHP::PrimitiveType).toString() or
    result = param.getType().(TS::PHP::NamedType).getChild().(TS::PHP::Name).getValue()
  }
}

/**
 * A foreach loop that assigns types to loop variables.
 */
class ForeachTypeAssignment extends TS::PHP::ForeachStatement {
  /** Gets a variable in the loop */
  TS::PHP::AstNode getLoopVariable() {
    result = this.getChild(_)
  }

  /** Gets the loop body */
  TS::PHP::AstNode getLoopBody() {
    result = this.getBody()
  }
}

/**
 * A list() or array destructuring assignment.
 */
class DestructuringAssignment extends TS::PHP::AssignmentExpression {
  DestructuringAssignment() {
    this.getLeft() instanceof TS::PHP::ListLiteral or
    this.getLeft() instanceof TS::PHP::ArrayCreationExpression
  }

  /** Gets the destructuring target */
  TS::PHP::AstNode getDestructuringTarget() {
    result = this.getLeft()
  }

  /** Gets the source value */
  TS::PHP::AstNode getSourceValue() {
    result = this.getRight()
  }
}

/**
 * A static variable declaration with optional initialization.
 */
class StaticVariableDecl extends TS::PHP::StaticVariableDeclaration {
  /** Gets the variable name */
  string getVariableName() {
    result = this.getName().(TS::PHP::VariableName).getChild().(TS::PHP::Name).getValue()
  }

  /** Holds if this has an initial value */
  predicate hasInitialValue() {
    exists(this.getValue())
  }

  /** Gets the initial value if present */
  TS::PHP::AstNode getInitialValue() {
    result = this.getValue()
  }
}

/**
 * A global variable import.
 */
class GlobalVariableDeclaration extends TS::PHP::GlobalDeclaration {
  /** Gets a variable being imported */
  TS::PHP::VariableName getImportedVariable() {
    result = this.getChild(_)
  }
}
