/**
 * @name Type Narrowing
 * @description Type narrowing through conditionals and type checks
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * An instanceof check that narrows a type.
 */
class InstanceofCheck extends TS::PHP::BinaryExpression {
  InstanceofCheck() {
    this.getOperator() = "instanceof"
  }

  /** Gets the expression being checked */
  TS::PHP::AstNode getCheckedExpr() {
    result = this.getLeft()
  }

  /** Gets the type being checked against */
  string getCheckedType() {
    result = this.getRight().(TS::PHP::Name).getValue() or
    result = this.getRight().(TS::PHP::QualifiedName).toString()
  }
}

/**
 * A type-checking function call (is_string, is_int, etc.).
 */
class TypeCheckCall extends TS::PHP::FunctionCallExpression {
  string checkedType;

  TypeCheckCall() {
    exists(string funcName | funcName = this.getFunction().(TS::PHP::Name).getValue() |
      funcName = "is_string" and checkedType = "string" or
      funcName = "is_int" and checkedType = "int" or
      funcName = "is_integer" and checkedType = "int" or
      funcName = "is_long" and checkedType = "int" or
      funcName = "is_float" and checkedType = "float" or
      funcName = "is_double" and checkedType = "float" or
      funcName = "is_real" and checkedType = "float" or
      funcName = "is_bool" and checkedType = "bool" or
      funcName = "is_array" and checkedType = "array" or
      funcName = "is_object" and checkedType = "object" or
      funcName = "is_null" and checkedType = "null" or
      funcName = "is_numeric" and checkedType = "numeric" or
      funcName = "is_callable" and checkedType = "callable" or
      funcName = "is_iterable" and checkedType = "iterable" or
      funcName = "is_resource" and checkedType = "resource"
    )
  }

  /** Gets the type this call checks for */
  string getCheckedType() {
    result = checkedType
  }

  /** Gets the expression being type-checked */
  TS::PHP::AstNode getCheckedExpr() {
    result = this.getArguments().(TS::PHP::Arguments).getChild(0)
  }
}

/**
 * A gettype() call that returns a type string.
 */
class GetTypeCall extends TS::PHP::FunctionCallExpression {
  GetTypeCall() {
    this.getFunction().(TS::PHP::Name).getValue() = "gettype"
  }

  /** Gets the expression whose type is being retrieved */
  TS::PHP::AstNode getCheckedExpr() {
    result = this.getArguments().(TS::PHP::Arguments).getChild(0)
  }
}

/**
 * A get_class() call that returns a class name.
 */
class GetClassCall extends TS::PHP::FunctionCallExpression {
  GetClassCall() {
    this.getFunction().(TS::PHP::Name).getValue() = "get_class"
  }

  /** Gets the expression whose class is being retrieved */
  TS::PHP::AstNode getCheckedExpr() {
    result = this.getArguments().(TS::PHP::Arguments).getChild(0)
  }
}

/**
 * A null check using === null or !== null.
 */
class NullCheck extends TS::PHP::BinaryExpression {
  boolean isPositive;

  NullCheck() {
    (this.getOperator() = "===" and this.getRight() instanceof TS::PHP::Null and isPositive = true) or
    (this.getOperator() = "!==" and this.getRight() instanceof TS::PHP::Null and isPositive = false) or
    (this.getOperator() = "===" and this.getLeft() instanceof TS::PHP::Null and isPositive = true) or
    (this.getOperator() = "!==" and this.getLeft() instanceof TS::PHP::Null and isPositive = false)
  }

  /** Gets the expression being checked for null */
  TS::PHP::AstNode getCheckedExpr() {
    this.getRight() instanceof TS::PHP::Null and result = this.getLeft() or
    this.getLeft() instanceof TS::PHP::Null and result = this.getRight()
  }

  /** Holds if this is a positive null check (=== null) */
  predicate isNullCheck() {
    isPositive = true
  }

  /** Holds if this is a negative null check (!== null) */
  predicate isNotNullCheck() {
    isPositive = false
  }
}

/**
 * An isset() check.
 */
class IssetCheck extends TS::PHP::FunctionCallExpression {
  IssetCheck() {
    this.getFunction().(TS::PHP::Name).getValue() = "isset"
  }

  /** Gets an expression being checked */
  TS::PHP::AstNode getCheckedExpr() {
    result = this.getArguments().(TS::PHP::Arguments).getChild(_)
  }
}

/**
 * An empty() check.
 */
class EmptyCheck extends TS::PHP::FunctionCallExpression {
  EmptyCheck() {
    this.getFunction().(TS::PHP::Name).getValue() = "empty"
  }

  /** Gets the expression being checked */
  TS::PHP::AstNode getCheckedExpr() {
    result = this.getArguments().(TS::PHP::Arguments).getChild(0)
  }
}
