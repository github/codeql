private import TIRVariableInternal
private import Imports::TempVariableTag

newtype TIRVariable =
  TIRUserVariable(Language::Variable var, Language::LanguageType type, Language::Declaration func) {
    Construction::hasUserVariable(func, var, type)
  } or
  TIRTempVariable(
    Language::Declaration func, Language::AST ast, TempVariableTag tag, Language::LanguageType type
  ) {
    Construction::hasTempVariable(func, ast, tag, type)
  } or
  TIRDynamicInitializationFlag(
    Language::Declaration func, Language::Variable var, Language::LanguageType type
  ) {
    Construction::hasDynamicInitializationFlag(func, var, type)
  } or
  TIRStringLiteral(
    Language::Declaration func, Language::AST ast, Language::LanguageType type,
    Language::StringLiteral literal
  ) {
    Construction::hasStringLiteral(func, ast, type, literal)
  }
