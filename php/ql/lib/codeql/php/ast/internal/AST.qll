/**
 * Internal module providing the implementation of PHP AST node types.
 *
 * This module should not be imported directly; instead, import `codeql.php.AST`.
 */

private import codeql.Locations

/**
 * Base class for all AST nodes.
 *
 * Maps to the @php_node types defined in the database schema.
 */
class AstNode extends @php_node {
  /** Gets the parent node in the AST. */
  AstNode getParent() {
    php_ast_node_parent(this, result)
  }

  /** Gets a child node of this node. */
  AstNode getChild(int index) {
    php_ast_node_parent(result, this) and result = getChild(index)
  }

  /** Gets the number of children of this node. */
  int getNumChild() {
    result = count(AstNode child | php_ast_node_parent(child, this))
  }

  /** Gets the location of this node. */
  Location getLocation() {
    locations_default(this, file, _, _, startLine, startColumn, endLine, endColumn) and
    result = Location(file, startLine, startColumn, endLine, endColumn)
  }

  /** Gets a string representation of this node. */
  string toString() { result = this.getAPrimaryQlClass() }

  string getAPrimaryQlClass() { result = "AstNode" }
}

/** A PHP file. */
class PhpFile extends AstNode {
  PhpFile() { this instanceof @file }

  /** Gets the path of this file. */
  string getPath() {
    files(this, result, 0)
  }

  /** Gets the base name of this file. */
  string getBaseName() {
    result = this.getPath().regexCapture(".*/([^/]+)$", 1)
    or
    not this.getPath().matches("%/%") and result = this.getPath()
  }

  string toString() { result = this.getBaseName() }
}

/** Base class for all expressions. */
class Expr extends AstNode {
  Expr() { this instanceof @php_expr }

  string getAPrimaryQlClass() { result = "Expr" }
}

/** Base class for all statements. */
class Stmt extends AstNode {
  Stmt() { this instanceof @php_stmt }

  string getAPrimaryQlClass() { result = "Stmt" }
}

/** Base class for all declarations. */
class Declaration extends AstNode {
  Declaration() { this instanceof @php_decl }

  string getAPrimaryQlClass() { result = "Declaration" }
}

/** A name or identifier in the source code. */
class Name extends AstNode {
  Name() { this instanceof @php_name or this instanceof @php_identifier }

  /** Gets the text of this name. */
  string getValue() {
    php_identifier(this, result)
    or
    php_name(this, result)
  }

  string toString() { result = this.getValue() }
}

/** An expression statement (expression followed by semicolon). */
class ExprStmt extends Stmt {
  ExprStmt() { this instanceof @php_expr_stmt }

  /** Gets the expression of this statement. */
  Expr getExpr() {
    php_expr_stmt(this, result)
  }

  string getAPrimaryQlClass() { result = "ExprStmt" }
}

/** A block of statements. */
class Block extends Stmt {
  Block() { this instanceof @php_block }

  /** Gets the i-th statement in this block. */
  Stmt getStmt(int i) {
    php_block(this, result, i)
  }

  /** Gets any statement in this block. */
  Stmt getStmt() {
    php_block(this, result, _)
  }

  /** Gets the number of statements in this block. */
  int getNumStmts() {
    result = count(Stmt stmt | php_block(this, stmt, _))
  }

  string getAPrimaryQlClass() { result = "Block" }
}

/** A binary operation expression. */
class BinaryOp extends Expr {
  BinaryOp() { this instanceof @php_binary_op }

  /** Gets the left operand. */
  Expr getLeftOperand() {
    php_binary_op(this, result, _, _)
  }

  /** Gets the right operand. */
  Expr getRightOperand() {
    php_binary_op(this, _, result, _)
  }

  /** Gets the operator string. */
  string getOperator() {
    php_binary_op(this, _, _, result)
  }

  string getAPrimaryQlClass() { result = "BinaryOp" }
}

/** A unary operation expression. */
class UnaryOp extends Expr {
  UnaryOp() { this instanceof @php_unary_op }

  /** Gets the operand. */
  Expr getOperand() {
    php_unary_op(this, result, _, _)
  }

  /** Gets the operator string. */
  string getOperator() {
    php_unary_op(this, _, result, _)
  }

  /** Returns true if this is a prefix operator. */
  predicate isPrefix() {
    php_unary_op(this, _, _, true)
  }

  /** Returns true if this is a postfix operator. */
  predicate isPostfix() {
    php_unary_op(this, _, _, false)
  }

  string getAPrimaryQlClass() { result = "UnaryOp" }
}

/** An assignment expression. */
class Assignment extends Expr {
  Assignment() { this instanceof @php_assign }

  /** Gets the target of the assignment. */
  Expr getTarget() {
    php_assign(this, result, _, _)
  }

  /** Gets the assigned value. */
  Expr getValue() {
    php_assign(this, _, result, _)
  }

  /** Gets the assignment operator (e.g., "=", "+=", "-="). */
  string getOperator() {
    php_assign(this, _, _, result)
  }

  string getAPrimaryQlClass() { result = "Assignment" }
}

/** A variable reference. */
class Variable extends Expr {
  Variable() { this instanceof @php_variable }

  /** Gets the name of the variable. */
  string getName() {
    php_variable(this, result)
  }

  string getAPrimaryQlClass() { result = "Variable" }
  string toString() { result = "$" + this.getName() }
}

/** A function or method call. */
class Call extends Expr {
  Call() { this instanceof @php_call }

  /** Gets the function/method being called. */
  Expr getTarget() {
    php_call(this, result, _, _)
  }

  /** Gets the i-th argument to this call. */
  Expr getArgument(int i) {
    php_call(this, _, result, i)
  }

  /** Gets any argument to this call. */
  Expr getArgument() {
    php_call(this, _, result, _)
  }

  /** Gets the number of arguments. */
  int getNumArguments() {
    result = count(Expr arg | php_call(this, _, arg, _))
  }

  string getAPrimaryQlClass() { result = "Call" }
}

/** A member access expression (e.g., $obj->prop or $obj->method()). */
class MemberAccess extends Expr {
  MemberAccess() { this instanceof @php_member_access }

  /** Gets the object being accessed. */
  Expr getObject() {
    php_member_access(this, result, _, _)
  }

  /** Gets the member name. */
  string getMember() {
    php_member_access(this, _, result, _)
  }

  /** Returns true if this accesses a method. */
  predicate isMethod() {
    php_member_access(this, _, _, true)
  }

  /** Returns true if this accesses a property. */
  predicate isProperty() {
    php_member_access(this, _, _, false)
  }

  string getAPrimaryQlClass() { result = "MemberAccess" }
}

/** A static member access expression (e.g., Class::$prop or Class::method()). */
class StaticAccess extends Expr {
  StaticAccess() { this instanceof @php_static_access }

  /** Gets the class name. */
  string getClassName() {
    php_static_access(this, result, _, _)
  }

  /** Gets the member name. */
  string getMember() {
    php_static_access(this, _, result, _)
  }

  /** Returns true if this accesses a method. */
  predicate isMethod() {
    php_static_access(this, _, _, true)
  }

  /** Returns true if this accesses a property. */
  predicate isProperty() {
    php_static_access(this, _, _, false)
  }

  string getAPrimaryQlClass() { result = "StaticAccess" }
}

/** An array access expression (e.g., $arr[0] or $arr[$key]). */
class ArrayAccess extends Expr {
  ArrayAccess() { this instanceof @php_array_access }

  /** Gets the array being accessed. */
  Expr getArray() {
    php_array_access(this, result, _)
  }

  /** Gets the index expression. */
  Expr getIndex() {
    php_array_access(this, _, result)
  }

  string getAPrimaryQlClass() { result = "ArrayAccess" }
}

/** An array literal (e.g., [1, 2, 3] or array(1, 2, 3)). */
class ArrayLiteral extends Expr {
  ArrayLiteral() { this instanceof @php_array }

  /** Gets the i-th element. */
  Expr getElement(int i) {
    php_array(this, result, i)
  }

  /** Gets any element. */
  Expr getElement() {
    php_array(this, result, _)
  }

  /** Gets the number of elements. */
  int getNumElements() {
    result = count(Expr elem | php_array(this, elem, _))
  }

  string getAPrimaryQlClass() { result = "ArrayLiteral" }
}

/** A string literal. */
class StringLiteral extends Expr {
  StringLiteral() { this instanceof @php_string }

  /** Gets the string value. */
  string getValue() {
    php_string(this, result)
  }

  string getAPrimaryQlClass() { result = "StringLiteral" }
  string toString() { result = "\"" + this.getValue() + "\"" }
}

/** A numeric literal. */
class NumberLiteral extends Expr {
  NumberLiteral() { this instanceof @php_number }

  /** Gets the numeric value as a string. */
  string getValue() {
    php_number(this, result)
  }

  string getAPrimaryQlClass() { result = "NumberLiteral" }
  string toString() { result = this.getValue() }
}

/** A boolean literal (true or false). */
class BooleanLiteral extends Expr {
  BooleanLiteral() { this instanceof @php_boolean }

  /** Returns true if this is the literal 'true'. */
  predicate isTrue() {
    php_boolean(this, true)
  }

  /** Returns true if this is the literal 'false'. */
  predicate isFalse() {
    php_boolean(this, false)
  }

  string getAPrimaryQlClass() { result = "BooleanLiteral" }
}

/** The null literal. */
class NullLiteral extends Expr {
  NullLiteral() { this instanceof @php_null }

  string getAPrimaryQlClass() { result = "NullLiteral" }
  string toString() { result = "null" }
}

/** A magic constant (__FILE__, __DIR__, __LINE__, etc.). */
class MagicConstant extends Expr {
  MagicConstant() { this instanceof @php_magic_const }

  /** Gets the name of the magic constant. */
  string getName() {
    php_magic_const(this, result)
  }

  string getAPrimaryQlClass() { result = "MagicConstant" }
}

/** A ternary conditional expression (cond ? true_expr : false_expr). */
class TernaryExpr extends Expr {
  TernaryExpr() { this instanceof @php_ternary }

  /** Gets the condition expression. */
  Expr getCondition() {
    php_ternary(this, result, _, _)
  }

  /** Gets the true branch expression. */
  Expr getTrueExpr() {
    php_ternary(this, _, result, _)
  }

  /** Gets the false branch expression. */
  Expr getFalseExpr() {
    php_ternary(this, _, _, result)
  }

  string getAPrimaryQlClass() { result = "TernaryExpr" }
}

/** An instanceof expression (e.g., $obj instanceof ClassName). */
class InstanceofExpr extends Expr {
  InstanceofExpr() { this instanceof @php_instanceof }

  /** Gets the expression being tested. */
  Expr getExpr() {
    php_instanceof(this, result, _)
  }

  /** Gets the class name being tested against. */
  string getClassName() {
    php_instanceof(this, _, result)
  }

  string getAPrimaryQlClass() { result = "InstanceofExpr" }
}

/** A cast expression (e.g., (int)$x, (string)$y). */
class CastExpr extends Expr {
  CastExpr() { this instanceof @php_cast }

  /** Gets the expression being cast. */
  Expr getExpr() {
    php_cast(this, result, _)
  }

  /** Gets the target cast type (int, string, bool, float, array, object). */
  string getCastType() {
    php_cast(this, _, result)
  }

  string getAPrimaryQlClass() { result = "CastExpr" }
}

/** A new expression (constructor call). */
class NewExpr extends Expr {
  NewExpr() { this instanceof @php_new }

  /** Gets the class name. */
  string getClassName() {
    php_new(this, result, _, _)
  }

  /** Gets the i-th argument to the constructor. */
  Expr getArgument(int i) {
    php_new(this, _, result, i)
  }

  /** Gets any argument to the constructor. */
  Expr getArgument() {
    php_new(this, _, result, _)
  }

  string getAPrimaryQlClass() { result = "NewExpr" }
}

/** A function declaration. */
class Function extends Declaration {
  Function() { this instanceof @php_function }

  /** Gets the name of this function. */
  string getName() {
    php_function(this, result, _, _, _, _, _)
  }

  /** Gets the i-th parameter. */
  FunctionParam getParameter(int i) {
    php_function(this, _, result, i, _, _, _)
  }

  /** Gets any parameter. */
  FunctionParam getParameter() {
    php_function(this, _, result, _, _, _, _)
  }

  /** Gets the number of parameters. */
  int getNumParameters() {
    result = count(FunctionParam param | php_function(this, _, param, _, _, _, _))
  }

  /** Gets the return type declaration, if any. */
  string getReturnType() {
    php_function(this, _, _, _, result, _, _) and result != ""
  }

  /** Gets the function body. */
  Block getBody() {
    php_function(this, _, _, _, _, result, _)
  }

  string getAPrimaryQlClass() { result = "Function" }
}

/** A function parameter. */
class FunctionParam extends AstNode {
  FunctionParam() { this instanceof @php_function_param }

  /** Gets the parameter name. */
  string getName() {
    php_function_param(this, result, _, _, _, _)
  }

  /** Gets the parameter type declaration, if any. */
  string getType() {
    php_function_param(this, _, _, result, _, _) and result != ""
  }

  /** Gets the default value, if any. */
  Expr getDefaultValue() {
    php_function_param(this, _, result, _, _, _)
  }

  /** Returns true if this is a reference parameter. */
  predicate isReference() {
    php_function_param(this, _, _, _, true, _)
  }

  /** Returns true if this is a variadic parameter. */
  predicate isVariadic() {
    php_function_param(this, _, _, _, _, true)
  }

  string getAPrimaryQlClass() { result = "FunctionParam" }
}

/** A class declaration. */
class Class extends Declaration {
  Class() { this instanceof @php_class }

  /** Gets the class name. */
  string getName() {
    php_class(this, result, _, _, _, _, _)
  }

  /** Gets the parent class name, if any. */
  string getExtends() {
    php_class(this, _, result, _, _, _, _) and result != ""
  }

  /** Gets the i-th implemented interface. */
  string getImplements(int i) {
    php_class(this, _, _, result, i, _, _)
  }

  /** Gets any implemented interface. */
  string getImplements() {
    php_class(this, _, _, result, _, _, _)
  }

  /** Gets the i-th member (property or method). */
  AstNode getMember(int i) {
    php_class(this, _, _, _, _, result, i)
  }

  /** Gets any member. */
  AstNode getMember() {
    php_class(this, _, _, _, _, result, _)
  }

  /** Gets any property member. */
  Property getProperty() {
    result = this.getMember() and result instanceof Property
  }

  /** Gets any method member. */
  Method getMethod() {
    result = this.getMember() and result instanceof Method
  }

  string getAPrimaryQlClass() { result = "Class" }
}

/** A class property. */
class Property extends AstNode {
  Property() { this instanceof @php_property }

  /** Gets the property name. */
  string getName() {
    php_property(this, result, _, _, _, _, _, _)
  }

  /** Gets the property type, if declared. */
  string getType() {
    php_property(this, _, result, _, _, _, _, _) and result != ""
  }

  /** Returns true if this is a static property. */
  predicate isStatic() {
    php_property(this, _, _, true, _, _, _, _)
  }

  /** Returns true if this is public. */
  predicate isPublic() {
    php_property(this, _, _, _, true, _, _, _)
  }

  /** Returns true if this is protected. */
  predicate isProtected() {
    php_property(this, _, _, _, _, true, _, _)
  }

  /** Returns true if this is private. */
  predicate isPrivate() {
    php_property(this, _, _, _, _, _, true, _)
  }

  /** Gets the default value, if any. */
  Expr getDefaultValue() {
    php_property(this, _, _, _, _, _, _, result)
  }

  string getAPrimaryQlClass() { result = "Property" }
}

/** A class method. */
class Method extends Declaration {
  Method() { this instanceof @php_class_method }

  /** Gets the method name. */
  string getName() {
    php_class_method(this, result, _, _, _, _, _, _, _, _, _)
  }

  /** Gets the i-th parameter. */
  FunctionParam getParameter(int i) {
    php_class_method(this, _, result, i, _, _, _, _, _, _, _)
  }

  /** Gets any parameter. */
  FunctionParam getParameter() {
    php_class_method(this, _, result, _, _, _, _, _, _, _, _)
  }

  /** Gets the return type, if declared. */
  string getReturnType() {
    php_class_method(this, _, _, _, result, _, _, _, _, _, _) and result != ""
  }

  /** Gets the method body. */
  Block getBody() {
    php_class_method(this, _, _, _, _, result, _, _, _, _, _)
  }

  /** Returns true if this is a static method. */
  predicate isStatic() {
    php_class_method(this, _, _, _, _, _, true, _, _, _, _)
  }

  /** Returns true if this is an abstract method. */
  predicate isAbstract() {
    php_class_method(this, _, _, _, _, _, _, true, _, _, _)
  }

  /** Returns true if this is public. */
  predicate isPublic() {
    php_class_method(this, _, _, _, _, _, _, _, true, _, _)
  }

  /** Returns true if this is protected. */
  predicate isProtected() {
    php_class_method(this, _, _, _, _, _, _, _, _, true, _)
  }

  /** Returns true if this is private. */
  predicate isPrivate() {
    php_class_method(this, _, _, _, _, _, _, _, _, _, true)
  }

  string getAPrimaryQlClass() { result = "Method" }
}

/** An interface declaration. */
class Interface extends Declaration {
  Interface() { this instanceof @php_interface }

  /** Gets the interface name. */
  string getName() {
    php_interface(this, result, _, _, _, _)
  }

  /** Gets any parent interface. */
  string getExtends(int i) {
    php_interface(this, _, result, i, _, _)
  }

  /** Gets any parent interface. */
  string getExtends() {
    php_interface(this, _, result, _, _, _)
  }

  string getAPrimaryQlClass() { result = "Interface" }
}

/** A trait declaration. */
class Trait extends Declaration {
  Trait() { this instanceof @php_trait }

  /** Gets the trait name. */
  string getName() {
    php_trait(this, result, _, _)
  }

  string getAPrimaryQlClass() { result = "Trait" }
}

/** An if statement. */
class IfStmt extends Stmt {
  IfStmt() { this instanceof @php_if }

  /** Gets the condition expression. */
  Expr getCondition() {
    php_if(this, result, _)
  }

  /** Gets the then-branch. */
  Stmt getThen() {
    php_if(this, _, result)
  }

  string getAPrimaryQlClass() { result = "IfStmt" }
}

/** A while loop. */
class WhileLoop extends Stmt {
  WhileLoop() { this instanceof @php_while }

  /** Gets the loop condition. */
  Expr getCondition() {
    php_while(this, result, _, _)
  }

  /** Gets the loop body. */
  Stmt getBody() {
    php_while(this, _, result, _)
  }

  /** Returns true if this is a do-while loop. */
  predicate isDoWhile() {
    php_while(this, _, _, true)
  }

  string getAPrimaryQlClass() { result = "WhileLoop" }
}

/** A for loop. */
class ForLoop extends Stmt {
  ForLoop() { this instanceof @php_for }

  /** Gets the initialization expression. */
  Expr getInit() {
    php_for(this, result, _, _, _)
  }

  /** Gets the loop condition. */
  Expr getCondition() {
    php_for(this, _, result, _, _)
  }

  /** Gets the update expression. */
  Expr getUpdate() {
    php_for(this, _, _, result, _)
  }

  /** Gets the loop body. */
  Stmt getBody() {
    php_for(this, _, _, _, result)
  }

  string getAPrimaryQlClass() { result = "ForLoop" }
}

/** A foreach loop. */
class ForeachLoop extends Stmt {
  ForeachLoop() { this instanceof @php_foreach }

  /** Gets the array being iterated. */
  Expr getArray() {
    php_foreach(this, result, _, _, _)
  }

  /** Gets the key variable (if any). */
  Variable getKey() {
    php_foreach(this, _, result, _, _)
  }

  /** Gets the value variable. */
  Variable getValue() {
    php_foreach(this, _, _, result, _)
  }

  /** Gets the loop body. */
  Stmt getBody() {
    php_foreach(this, _, _, _, result)
  }

  string getAPrimaryQlClass() { result = "ForeachLoop" }
}

/** A switch statement. */
class SwitchStmt extends Stmt {
  SwitchStmt() { this instanceof @php_switch }

  /** Gets the value being switched on. */
  Expr getValue() {
    php_switch(this, result, _, _)
  }

  /** Gets the i-th case. */
  SwitchCase getCase(int i) {
    php_switch(this, _, result, i)
  }

  /** Gets any case. */
  SwitchCase getCase() {
    php_switch(this, _, result, _)
  }

  string getAPrimaryQlClass() { result = "SwitchStmt" }
}

/** A case in a switch statement. */
class SwitchCase extends AstNode {
  SwitchCase() { this instanceof @php_switch_case }

  /** Gets the case condition (null for default case). */
  Expr getCondition() {
    php_switch_case(this, result, _, _)
  }

  /** Gets the case body. */
  Block getBody() {
    php_switch_case(this, _, result, _)
  }

  /** Returns true if this is the default case. */
  predicate isDefault() {
    php_switch_case(this, _, _, true)
  }

  string getAPrimaryQlClass() { result = "SwitchCase" }
}

/** A return statement. */
class ReturnStmt extends Stmt {
  ReturnStmt() { this instanceof @php_return }

  /** Gets the return value, if any. */
  Expr getValue() {
    php_return(this, result)
  }

  string getAPrimaryQlClass() { result = "ReturnStmt" }
}

/** A throw statement. */
class ThrowStmt extends Stmt {
  ThrowStmt() { this instanceof @php_throw }

  /** Gets the exception expression. */
  Expr getExpr() {
    php_throw(this, result)
  }

  string getAPrimaryQlClass() { result = "ThrowStmt" }
}

/** An echo statement. */
class EchoStmt extends Stmt {
  EchoStmt() { this instanceof @php_echo }

  /** Gets the i-th value being echoed. */
  Expr getValue(int i) {
    php_echo(this, result, i)
  }

  /** Gets any value being echoed. */
  Expr getValue() {
    php_echo(this, result, _)
  }

  string getAPrimaryQlClass() { result = "EchoStmt" }
}

function getLocation(AstNode node) -> Location {
  locations_default(node, file, _, _, startLine, startColumn, endLine, endColumn) and
  result = Location(file, startLine, startColumn, endLine, endColumn)
}
