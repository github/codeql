/**
 * Provides Swift-specific type inference logic.
 */
overlay[local?]
module;

private import Type
private import TypeInference
private import TypeInferencePlugin as Plugin
private import codeql.unified.internal.Builtins

private class StructType extends ClassLikeDeclarationType {
  StructType() { c.getAModifier().getValue() = "struct" }
}

private class EnumType extends ClassLikeDeclarationType {
  EnumType() { c.getAModifier().getValue() = "enum" }
}

private class BuiltinType extends ClassLikeDeclarationType {
  BuiltinType() { this.getClassLikeDeclaration() instanceof BuiltinClassLikeDeclaration }
}

private class BuiltinStructType extends BuiltinType, StructType { }

private class BuiltinEnumType extends BuiltinType, EnumType { }

private class BoolType extends BuiltinStructType {
  BoolType() { this.getName() = "Bool" }
}

private class IntType extends BuiltinStructType {
  IntType() { this.getName() = "Int" }
}

private class DoubleType extends BuiltinStructType {
  DoubleType() { this.getName() = "Double" }
}

private class StringType extends BuiltinStructType {
  StringType() { this.getName() = "String" }
}

private class ArrayType extends BuiltinStructType {
  ArrayType() { this.getName() = "Array" }
}

class FunctionType extends BuiltinStructType {
  FunctionType() { this.getName() = "Function" }
}

class OptionalType extends BuiltinEnumType {
  OptionalType() { this.getName() = "Optional" }
}

pragma[nomagic]
TypeParameter getFunctionArgsTypeParameter() {
  result = any(FunctionType t).getPositionalTypeParameter(0)
}

pragma[nomagic]
TypeParameter getFunctionReturnTypeParameter() {
  result = any(FunctionType t).getPositionalTypeParameter(1)
}

/** Gets the path to a closure's `index`th parameter type, where the arity is `arity`. */
pragma[nomagic]
private TypePath functionParameterPath(int arity, int index) {
  result =
    TypePath::cons(getFunctionArgsTypeParameter(),
      TypePath::singleton(getTupleTypeParameter(arity, index)))
}

pragma[nomagic]
private TypePath functionReturnPath() {
  result = TypePath::singleton(getFunctionReturnTypeParameter())
}

private class TupleType extends BuiltinStructType {
  private int arity;

  TupleType() { arity = this.getName().regexpCapture("Tuple([0-9]+)", 1).toInt() }

  int getArity() { result = arity }

  VariableDeclaration getField(string name) {
    result = this.getClassLikeDeclaration().getAMember() and
    name = result.getPattern().(Identifier).getValue().regexpCapture("\\_(.+)", 1)
  }
}

pragma[nomagic]
TypeParameter getTupleTypeParameter(int arity, int i) {
  result = any(TupleType t | t.getArity() = arity).getPositionalTypeParameter(i)
}

private class Enum extends ClassLikeDeclaration {
  Enum() { this.getAModifier().getValue() = "enum" }
}

private class EnumConstructor extends EnumCaseConstructor {
  private Enum e;

  EnumConstructor() { this = e.getAMember().(EnumCaseClass).getConstructor() }

  Identifier getNameNode() { result = this.getEnumCaseClass().getNameNode() }

  Enum getEnum() { result = e }
}

private class EnumField extends VariableDeclaration {
  private Enum e;

  EnumField() {
    this = e.getAMember() and
    this.getAModifier().getValue() = "enum_case"
  }

  Enum getEnum() { result = e }
}

private predicate inferTypeAlias = inferType/2;

private class SwiftTypeInferencePlugin extends Plugin::TypeInferencePlugin {
  override Type getBoolType() { result instanceof BoolType }

  override Type getIntType() { result instanceof IntType }

  override Type getFloatType() { result instanceof DoubleType }

  override Type getStringType() { result instanceof StringType }

  override TypeParameter getArrayElementTypeParameter() {
    result = any(ArrayType t).getPositionalTypeParameter(0)
  }

  bindingset[fe]
  override Type getFunctionExprType(FunctionExpr fe) {
    result instanceof FunctionType and
    exists(fe)
  }

  bindingset[t]
  override TypePath getFunctionExprParameterTypePath(Type t, int arity, int i) {
    result = functionParameterPath(arity, i) and exists(t)
  }

  bindingset[t]
  override TypePath getFunctionExprReturnTypePath(Type t) {
    result = functionReturnPath() and exists(t)
  }

  pragma[nomagic]
  override FunctionDeclaration getFunctionInvoke(Type t) {
    result = t.(FunctionType).getClassLikeDeclaration().getAMember() and
    result.getName() = "callAsFunction"
  }

  bindingset[t, arity, i]
  override predicate functionInvokeSignature(Type t, int arity, int i, int j, TypePath path) {
    j = 1 and
    path = TypePath::singleton(getTupleTypeParameter(arity, i)) and
    exists(t)
  }

  override Type getTupleType(int arity) { result.(TupleType).getArity() = arity }

  override predicate tupleField(Type tuple, string name, VariableDeclaration field) {
    field = tuple.(TupleType).getField(name)
  }

  override predicate isEnumConstructor(
    ClassLikeDeclaration enum, ConstructorDeclaration case, Identifier i
  ) {
    case =
      any(EnumConstructor ec |
        enum = ec.getEnum() and
        i = ec.getNameNode()
      )
  }

  override predicate isEnumField(ClassLikeDeclaration enum, VariableDeclaration field) {
    enum = field.(EnumField).getEnum()
  }

  override Type inferType(AstNode n, TypePath path) {
    // todo: approximation for now
    n instanceof BinaryExpr and
    result = inferTypeAlias(n.(BinaryExpr).getLeft(), path) and
    result = inferTypeAlias(n.(BinaryExpr).getRight(), path)
  }
}
