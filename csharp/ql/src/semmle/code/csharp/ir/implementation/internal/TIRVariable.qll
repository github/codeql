private import TIRVariableInternal
private import Imports::TempVariableTag

newtype TIRVariable =
  TIRUserVariable(Language::Variable var, Language::LanguageType type, Language::Function func) {
    Construction::hasUserVariable(func, var, type)
  } or
  TIRTempVariable(
    Language::Function func, Language::AST ast, TempVariableTag tag, Language::LanguageType type
  ) {
    Construction::hasTempVariable(func, ast, tag, type)
  }
