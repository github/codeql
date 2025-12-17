/**
 * @name Type Inference
 * @description Type inference utilities for PHP
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * Gets the inferred type from a literal expression.
 */
string inferLiteralType(TS::PHP::AstNode literal) {
  literal instanceof TS::PHP::Integer and result = "int" or
  literal instanceof TS::PHP::Float and result = "float" or
  literal instanceof TS::PHP::String and result = "string" or
  literal instanceof TS::PHP::EncapsedString and result = "string" or
  literal instanceof TS::PHP::Heredoc and result = "string" or
  literal instanceof TS::PHP::Boolean and result = "bool" or
  literal instanceof TS::PHP::Null and result = "null" or
  literal instanceof TS::PHP::ArrayCreationExpression and result = "array"
}

/**
 * Gets the inferred result type from a binary expression.
 */
string inferBinaryOpType(TS::PHP::BinaryExpression expr) {
  exists(string op | op = expr.getOperator() |
    // Arithmetic operators produce numeric types
    op in ["+", "-", "*", "/", "%", "**"] and result = "numeric" or
    // String concatenation produces string
    op = "." and result = "string" or
    // Comparison operators produce bool
    op in ["==", "===", "!=", "!==", "<>", "<", "<=", ">", ">=", "<=>"] and result = "bool" or
    // Logical operators produce bool
    op in ["&&", "||", "and", "or", "xor"] and result = "bool" or
    // Bitwise operators produce int
    op in ["&", "|", "^", "<<", ">>"] and result = "int" or
    // Null coalescing preserves type
    op = "??" and result = "mixed"
  )
}

/**
 * Gets the inferred result type from a unary expression.
 */
string inferUnaryOpType(TS::PHP::UnaryOpExpression expr) {
  exists(string op | op = expr.getOperator().toString() |
    // Logical not produces bool
    op = "!" and result = "bool" or
    // Arithmetic negation preserves type
    op = "-" and result = "numeric" or
    op = "+" and result = "numeric" or
    // Bitwise not produces int
    op = "~" and result = "int" or
    // Error suppression preserves type
    op = "@" and result = "mixed"
  )
}

/**
 * Gets the inferred type from a cast expression.
 */
string inferCastType(TS::PHP::CastExpression expr) {
  exists(string castType | castType = expr.getType().toString() |
    castType in ["int", "integer"] and result = "int" or
    castType in ["float", "double", "real"] and result = "float" or
    castType = "string" and result = "string" or
    castType in ["bool", "boolean"] and result = "bool" or
    castType = "array" and result = "array" or
    castType = "object" and result = "object" or
    castType = "unset" and result = "null"
  )
}

/**
 * A parameter with a type hint.
 */
class TypedParameter extends TS::PHP::SimpleParameter {
  TypedParameter() {
    exists(this.getType())
  }

  /** Gets the declared type of this parameter */
  string getDeclaredType() {
    result = this.getType().(TS::PHP::PrimitiveType).toString() or
    result = this.getType().(TS::PHP::NamedType).getChild().(TS::PHP::Name).getValue()
  }
}

/**
 * A function/method with a return type declaration.
 */
class TypedFunction extends TS::PHP::FunctionDefinition {
  TypedFunction() {
    exists(this.getReturnType())
  }

  /** Gets the declared return type */
  string getDeclaredReturnType() {
    result = this.getReturnType().(TS::PHP::PrimitiveType).toString() or
    result = this.getReturnType().(TS::PHP::NamedType).getChild().(TS::PHP::Name).getValue()
  }
}

/**
 * A method with a return type declaration.
 */
class TypedMethod extends TS::PHP::MethodDeclaration {
  TypedMethod() {
    exists(this.getReturnType())
  }

  /** Gets the declared return type */
  string getDeclaredReturnType() {
    result = this.getReturnType().(TS::PHP::PrimitiveType).toString() or
    result = this.getReturnType().(TS::PHP::NamedType).getChild().(TS::PHP::Name).getValue()
  }
}

/**
 * A property with a type declaration.
 */
class TypedProperty extends TS::PHP::PropertyDeclaration {
  TypedProperty() {
    exists(this.getType())
  }

  /** Gets the declared type */
  string getDeclaredType() {
    result = this.getType().(TS::PHP::PrimitiveType).toString() or
    result = this.getType().(TS::PHP::NamedType).getChild().(TS::PHP::Name).getValue()
  }
}
