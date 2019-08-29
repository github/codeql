private import TIRVariableInternal
private import Imports::TempVariableTag

newtype TIRVariable =
  TIRUserVariable(Language::Variable var, Language::Type type,
      Language::Function func) {
    Construction::hasUserVariable(func, var, type)
  } or
  TIRTempVariable(Language::Function func, Language::AST ast, TempVariableTag tag,
      Language::Type type) {
    Construction::hasTempVariable(func, ast, tag, type)
  }
