private import csharp as Cpp

class Function = Cpp::Callable;
class Location = Cpp::Location;
class AST = Cpp::Element;

class Type = Cpp::Type;
//REVIEW: This might not exist in the database. 
class UnknownType = Cpp::UnknownType;
class VoidType = Cpp::VoidType;
class IntegralType = Cpp::IntegralType;
class FloatingPointType = Cpp::FloatingPointType;

private newtype TClassDerivation = 
  // Note that this is the `Class` type exported from this module, not CSharp::Class.
  MkClassDerivation(Class base, Class derived) {
    derived.getABaseType() = base
  }

class ClassDerivation extends MkClassDerivation {
  Class baseClass;
  Class derivedClass;

  ClassDerivation() {
    this = MkClassDerivation(baseClass, derivedClass)
  }

  string toString() {
    result = "ClassDerivation"
  }

  final Class getBaseClass() {
    result = baseClass
  }

  final Class getDerivedClass() {
    result = derivedClass
  }

  final int getByteOffset() {
    // Inheritance never requires adjusting the `this` pointer in C#.
    result = 0
  }
}

class StringLiteral = Cpp::StringLiteral;

class Variable = Cpp::Variable;
class AutomaticVariable = Cpp::LocalScopeVariable;
class StaticVariable = Cpp::Variable;
class Parameter = Cpp::Parameter;
class Field = Cpp::Field;

// TODO: Remove necessity for these.
class Expr = Cpp::Expr;
class Class = Cpp::RefType;  // Used for inheritance conversions

string getIdentityString(Function func) {
  // REVIEW: Is this enough to make it unique?
//  result = func.getQualifiedName()
  result = func.getName()
}

predicate hasCaseEdge(string minValue, string maxValue) {
  // TODO: Need to handle `switch` statements that switch on an integer.
  none()
}

predicate hasPositionalArgIndex(int argIndex) {
  exists(Cpp::MethodCall call |
    exists(call.getArgument(argIndex))
  )
}

predicate hasAsmOperandIndex(int operandIndex) {
  none()
}

int getTypeSize(Type type) {
  // REVIEW: Is this complete?
  result = type.(Cpp::SimpleType).getSize() or
  result = getTypeSize(type.(Cpp::Enum).getUnderlyingType()) or
  // TODO: Generate a reasonable size
  type instanceof Cpp::Struct and result = 16 or
  type instanceof Cpp::RefType and result = getPointerSize() or
  type instanceof Cpp::PointerType and result = getPointerSize() or
  result = getTypeSize(type.(Cpp::TupleType).getUnderlyingType()) or
  // TODO: Add room for extra field
  result = getTypeSize(type.(Cpp::NullableType).getUnderlyingType()) or
  type instanceof Cpp::VoidType and result = 0
}

int getPointerSize() {
  // TODO: Deal with sizes in general
  result = 8
}

predicate isVariableAutomatic(Variable var) {
  var instanceof Cpp::LocalScopeVariable
}

string getStringLiteralText(StringLiteral s) {
  // REVIEW: Is this the right escaping?
  result = s.toString()
}

predicate hasPotentialLoop(Function f) {
  exists(Cpp::LoopStmt l | l.getEnclosingCallable() = f) or
  exists(Cpp::GotoStmt s | s.getEnclosingCallable() = f)
}

predicate hasGoto(Function f) {
  exists(Cpp::GotoStmt s | s.getEnclosingCallable() = f)
}
