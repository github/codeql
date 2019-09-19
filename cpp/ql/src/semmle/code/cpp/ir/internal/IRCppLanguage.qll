private import cpp as Cpp
private import semmle.code.cpp.Print as Print
private import IRUtilities

class Function = Cpp::Function;

class Location = Cpp::Location;

class AST = Cpp::Locatable;

class Type = Cpp::Type;

class UnknownType = Cpp::UnknownType;

class VoidType = Cpp::VoidType;

class IntegralType = Cpp::IntegralType;

class FloatingPointType = Cpp::FloatingPointType;

// REVIEW: May need to synthesize this for other languages. Or do we really need it at all?
class ClassDerivation = Cpp::ClassDerivation;

class StringLiteral = Cpp::StringLiteral;

class Variable = Cpp::Variable;

class AutomaticVariable = Cpp::LocalScopeVariable;

class StaticVariable = Cpp::Variable;

class Parameter = Cpp::Parameter;

class Field = Cpp::Field;

class BuiltInOperation = Cpp::BuiltInOperation;

// TODO: Remove necessity for these.
class Expr = Cpp::Expr;

class Class = Cpp::Class; // Used for inheritance conversions

predicate getIdentityString = Print::getIdentityString/1;

predicate hasCaseEdge(string minValue, string maxValue) {
  exists(Cpp::SwitchCase switchCase | hasCaseEdge(switchCase, minValue, maxValue))
}

predicate hasPositionalArgIndex(int argIndex) {
  exists(Cpp::FunctionCall call | exists(call.getArgument(argIndex))) or
  exists(Cpp::BuiltInOperation op | exists(op.getChild(argIndex)))
}

predicate hasAsmOperandIndex(int operandIndex) {
  exists(Cpp::AsmStmt asm | exists(asm.getChild(operandIndex)))
}

int getTypeSize(Type type) { result = type.getSize() }

int getPointerSize() { exists(Cpp::NullPointerType nullptr | result = nullptr.getSize()) }

predicate isVariableAutomatic(Variable var) {
  var instanceof Cpp::LocalScopeVariable and
  not var.(Cpp::LocalScopeVariable).isStatic()
}

string getStringLiteralText(StringLiteral s) {
  result = s.getValueText().replaceAll("\n", " ").replaceAll("\r", "").replaceAll("\t", " ")
}

predicate hasPotentialLoop(Function f) {
  exists(Cpp::Loop l | l.getEnclosingFunction() = f) or
  exists(Cpp::GotoStmt s | s.getEnclosingFunction() = f)
}

predicate hasGoto(Function f) { exists(Cpp::GotoStmt s | s.getEnclosingFunction() = f) }
