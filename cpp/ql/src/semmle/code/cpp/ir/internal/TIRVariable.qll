private import IRLanguageInternal
private import semmle.code.cpp.ir.implementation.TempVariableTag
private import semmle.code.cpp.ir.implementation.raw.internal.IRConstruction as Construction

newtype TIRVariable =
  TIRUserVariable(Language::Variable var, Language::Type type,
      Language::Function func) {
    Construction::hasUserVariable(func, var, type)
  } or
  TIRTempVariable(Language::Function func, Language::AST ast, TempVariableTag tag,
      Language::Type type) {
    Construction::hasTempVariable(func, ast, tag, type)
  }
