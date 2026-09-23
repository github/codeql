/**
 * Provides an interface for language-specific type inference logic.
 */

private import Type
private import TypeInference
private import codeql.util.Unit

private module Plugins {
  private import TypeInferencePluginSwift
}

class TypeInferencePlugin extends Unit {
  /** Gets the boolean type which will be assigned to boolean literals. */
  abstract Type getBoolType();

  /** Gets the integer type which will be assigned to integer literals. */
  abstract Type getIntType();

  /** Gets the floating-point type which will be assigned to floating-point literals. */
  abstract Type getFloatType();

  /** Gets the string type which will be assigned to string literals. */
  abstract Type getStringType();

  /** Gets the type parameter representing the element type of an array. */
  abstract TypeParameter getArrayElementTypeParameter();

  /**
   * Gets the type of the given function expression.
   *
   * For example `Fn` in Rust (which does not depend on `fe`).
   */
  bindingset[fe]
  abstract Type getFunctionExprType(FunctionExpr fe);

  /**
   * Gets the type path for the `i`th parameter of the given function type
   * when the function type has the given arity.
   *
   * For example `"Args.Ti"` in Rust, where `Args` is the type argument of
   * `Fn` and `Ti` is the `i`th type parameter of the tuple type with arity
   * `arity`.
   */
  bindingset[t, arity, i]
  abstract TypePath getFunctionExprParameterTypePath(Type t, int arity, int i);

  /**
   * Gets the type path for the return type of the given function type.
   *
   * For example `"Output"` in Rust, where `Output` is the associated type
   * of `Fn`.
   */
  bindingset[t]
  abstract TypePath getFunctionExprReturnTypePath(Type t);

  /**
   * Gets the `invoke` function for the given function type.
   *
   * For example the `call` method of the `Fn` trait in Rust.
   */
  abstract Callable getFunctionInvoke(Type t);

  /**
   * Holds if the `i`th syntactic argument in a call to the `invoke` function
   * belonging to `t` should map to position `j` and type path `path`.
   *
   * For example, in Rust, in a call `closure(arg0, arg1)` the first argument
   * maps to `(1, "T0")` and the second argument maps to `(1, "T1")`, where `T0`
   * is the first type parameter of the 2-tuple type and `T1` is the second type
   * parameter.
   */
  bindingset[t, arity, i]
  abstract predicate functionInvokeSignature(Type t, int arity, int i, int j, TypePath path);

  /** Gets the tuple type with the given arity. */
  abstract Type getTupleType(int arity);

  /** Holds if `field` is a field of the tuple type `tuple` with the given `name`. */
  abstract predicate tupleField(Type tuple, string name, VariableDeclaration field);

  /** Holds if `case` is an enum case constructor of `enum` with identifier `i`. */
  abstract predicate isEnumConstructor(
    ClassLikeDeclaration enum, ConstructorDeclaration case, Identifier i
  );

  /** Holds if `field` is an enum field of `enum`. */
  abstract predicate isEnumField(ClassLikeDeclaration enum, VariableDeclaration field);

  /** Gets the inferred type for the given AST node and type path. */
  Type inferType(AstNode n, TypePath path) { none() }
}

class BoolType extends Type {
  BoolType() { this = any(TypeInferencePlugin p).getBoolType() }
}

class IntType extends Type {
  IntType() { this = any(TypeInferencePlugin p).getIntType() }
}

class FloatType extends Type {
  FloatType() { this = any(TypeInferencePlugin p).getFloatType() }
}

class StringType extends Type {
  StringType() { this = any(TypeInferencePlugin p).getStringType() }
}

TypeParameter getArrayElementTypeParameter() {
  result = any(TypeInferencePlugin p).getArrayElementTypeParameter()
}

bindingset[fe]
Type getFunctionExprType(FunctionExpr fe) {
  result = any(TypeInferencePlugin p).getFunctionExprType(fe)
}

bindingset[t, arity, i]
TypePath getFunctionExprParameterTypePath(Type t, int arity, int i) {
  result = any(TypeInferencePlugin pl).getFunctionExprParameterTypePath(t, arity, i)
}

TypePath getFunctionExprReturnTypePath(Type t) {
  result = any(TypeInferencePlugin pl).getFunctionExprReturnTypePath(t)
}

class TupleType extends Type {
  int arity;

  TupleType() { this = any(TypeInferencePlugin p).getTupleType(arity) }

  int getArity() { result = arity }

  VariableDeclaration getField(string name) {
    any(TypeInferencePlugin p).tupleField(this, name, result)
  }
}

class EnumConstructor extends ConstructorDeclaration {
  private ClassLikeDeclaration enum;
  private Identifier id;

  EnumConstructor() { any(TypeInferencePlugin p).isEnumConstructor(enum, this, id) }

  ClassLikeDeclaration getEnum() { result = enum }

  Identifier getNameNode() { result = id }
}

class EnumField extends VariableDeclaration {
  private ClassLikeDeclaration enum;

  EnumField() { any(TypeInferencePlugin p).isEnumField(enum, this) }

  ClassLikeDeclaration getEnum() { result = enum }
}

Type inferType(AstNode n, TypePath path) { result = any(TypeInferencePlugin p).inferType(n, path) }

Callable getFunctionInvoke(Type t) { result = any(TypeInferencePlugin p).getFunctionInvoke(t) }

bindingset[t, arity, i]
predicate functionInvokeSignature(Type t, int arity, int i, int j, TypePath path) {
  any(TypeInferencePlugin p).functionInvokeSignature(t, arity, i, j, path)
}
