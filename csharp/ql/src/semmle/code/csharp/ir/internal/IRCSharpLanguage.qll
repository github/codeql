private import csharp as CSharp
private import IRUtilities
import CSharpType

class LanguageType = CSharpType;

class OpaqueTypeTag = CSharp::ValueOrRefType;

class Function = CSharp::Callable;

class Location = CSharp::Location;

class AST = CSharp::Element;

class Type = CSharp::Type;

class UnknownType = CSharp::NullType;

class VoidType = CSharp::VoidType;

class IntegralType = CSharp::IntegralType;

class FloatingPointType = CSharp::FloatingPointType;

private newtype TClassDerivation =
  // Note that this is the `Class` type exported from this module, not CSharp::Class.
  MkClassDerivation(Class base, Class derived) { derived.getABaseType() = base }

private newtype TBuiltInOperation = NoOp()

class BuiltInOperation extends TBuiltInOperation {
  string toString() { result = "BuiltInOp" }
}

class ClassDerivation extends MkClassDerivation {
  Class baseClass;
  Class derivedClass;

  ClassDerivation() { this = MkClassDerivation(baseClass, derivedClass) }

  string toString() { result = "ClassDerivation" }

  final Class getBaseClass() { result = baseClass }

  final Class getDerivedClass() { result = derivedClass }

  final int getByteOffset() {
    // Inheritance never requires adjusting the `this` pointer in C#.
    result = 0
  }
}

class StringLiteral = CSharp::StringLiteral;

class Variable = CSharp::Variable;

class AutomaticVariable = CSharp::LocalScopeVariable;

class StaticVariable = CSharp::Variable;

class Parameter = CSharp::Parameter;

class Field = CSharp::Field;

// TODO: Remove necessity for these.
class Expr = CSharp::Expr;

class Class = CSharp::ValueOrRefType; // Used for inheritance conversions

string getIdentityString(Function func) { result = func.getLabel() }

predicate hasCaseEdge(string minValue, string maxValue) {
  // TODO: Need to handle pattern matching
  exists(CSharp::CaseStmt cst | hasCaseEdge(cst, minValue, maxValue))
}

predicate hasPositionalArgIndex(int argIndex) {
  exists(CSharp::MethodCall call | exists(call.getArgument(argIndex)))
  or
  // Quick fix so that generated calls (`Invoke` etc) will have the
  // correct number of parameters; it is an overestimation,
  // since we don't care about all the callables, so it
  // should be restricted more
  argIndex in [0 .. any(CSharp::Callable c).getNumberOfParameters() - 1]
}

predicate hasAsmOperandIndex(int operandIndex) { none() }

predicate isVariableAutomatic(Variable var) { var instanceof CSharp::LocalScopeVariable }

string getStringLiteralText(StringLiteral s) {
  // REVIEW: Is this the right escaping?
  result = s.toString()
}

predicate hasPotentialLoop(Function f) {
  exists(CSharp::LoopStmt l | l.getEnclosingCallable() = f) or
  exists(CSharp::GotoStmt s | s.getEnclosingCallable() = f)
}

predicate hasGoto(Function f) { exists(CSharp::GotoStmt s | s.getEnclosingCallable() = f) }
