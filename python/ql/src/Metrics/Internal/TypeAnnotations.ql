/**
 * @name Type metrics
 * @description Counts of various kinds of type annotations in Python code.
 * @kind table
 * @id py/type-metrics
 */

import python

class BuiltinType extends Name {
  BuiltinType() { this.getId() in ["int", "float", "str", "bool", "bytes", "None"] }
}

newtype TAnnotatable =
  TAnnotatedFunction(FunctionExpr f) { exists(f.getReturns()) } or
  TAnnotatedParameter(Parameter p) { exists(p.getAnnotation()) } or
  TAnnotatedAssignment(AnnAssign a) { exists(a.getAnnotation()) }

abstract class Annotatable extends TAnnotatable {
  string toString() { result = "Annotatable" }

  abstract Expr getAnnotation();
}

class AnnotatedFunction extends TAnnotatedFunction, Annotatable {
  FunctionExpr function;

  AnnotatedFunction() { this = TAnnotatedFunction(function) }

  override Expr getAnnotation() { result = function.getReturns() }
}

class AnnotatedParameter extends TAnnotatedParameter, Annotatable {
  Parameter parameter;

  AnnotatedParameter() { this = TAnnotatedParameter(parameter) }

  override Expr getAnnotation() { result = parameter.getAnnotation() }
}

class AnnotatedAssignment extends TAnnotatedAssignment, Annotatable {
  AnnAssign assignment;

  AnnotatedAssignment() { this = TAnnotatedAssignment(assignment) }

  override Expr getAnnotation() { result = assignment.getAnnotation() }
}

/** Holds if `e` is a forward declaration of a type. */
predicate is_forward_declaration(Expr e) { e instanceof StringLiteral }

/** Holds if `e` is a type that may be difficult to analyze. */
predicate is_complex_type(Expr e) {
  e instanceof Subscript and not is_optional_type(e)
  or
  e instanceof Tuple
  or
  e instanceof List
}

/** Holds if `e` is a type of the form `Optional[...]`. */
predicate is_optional_type(Subscript e) { e.getObject().(Name).getId() = "Optional" }

/** Holds if `e` is a simple type, that is either an identifier (excluding built-in types) or an attribute of a simple type. */
predicate is_simple_type(Expr e) {
  e instanceof Name and not e instanceof BuiltinType
  or
  is_simple_type(e.(Attribute).getObject())
}

/** Holds if `e` is a built-in type. */
predicate is_builtin_type(Expr e) { e instanceof BuiltinType }

predicate type_count(
  string kind, int total, int built_in_count, int forward_declaration_count, int simple_type_count,
  int complex_type_count, int optional_type_count
) {
  kind = "Parameter annotation" and
  total = count(AnnotatedParameter p) and
  built_in_count = count(AnnotatedParameter p | is_builtin_type(p.getAnnotation())) and
  forward_declaration_count =
    count(AnnotatedParameter p | is_forward_declaration(p.getAnnotation())) and
  simple_type_count = count(AnnotatedParameter p | is_simple_type(p.getAnnotation())) and
  complex_type_count = count(AnnotatedParameter p | is_complex_type(p.getAnnotation())) and
  optional_type_count = count(AnnotatedParameter p | is_optional_type(p.getAnnotation()))
  or
  kind = "Return type annotation" and
  total = count(AnnotatedFunction f) and
  built_in_count = count(AnnotatedFunction f | is_builtin_type(f.getAnnotation())) and
  forward_declaration_count = count(AnnotatedFunction f | is_forward_declaration(f.getAnnotation())) and
  simple_type_count = count(AnnotatedFunction f | is_simple_type(f.getAnnotation())) and
  complex_type_count = count(AnnotatedFunction f | is_complex_type(f.getAnnotation())) and
  optional_type_count = count(AnnotatedFunction f | is_optional_type(f.getAnnotation()))
  or
  kind = "Annotated assignment" and
  total = count(AnnotatedAssignment a) and
  built_in_count = count(AnnotatedAssignment a | is_builtin_type(a.getAnnotation())) and
  forward_declaration_count =
    count(AnnotatedAssignment a | is_forward_declaration(a.getAnnotation())) and
  simple_type_count = count(AnnotatedAssignment a | is_simple_type(a.getAnnotation())) and
  complex_type_count = count(AnnotatedAssignment a | is_complex_type(a.getAnnotation())) and
  optional_type_count = count(AnnotatedAssignment a | is_optional_type(a.getAnnotation()))
}

from
  string message, int total, int built_in, int forward_decl, int simple, int complex, int optional
where type_count(message, total, built_in, forward_decl, simple, complex, optional)
select message, total, built_in, forward_decl, simple, complex, optional
