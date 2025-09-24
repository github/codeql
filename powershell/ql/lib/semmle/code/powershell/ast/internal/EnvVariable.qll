private import AstImport

/**
 * A PowerShell environment variable (for example, `$env:PATH`).
 */
class EnvVariable extends Variable instanceof EnvVariableImpl {
  string getLowerCaseName() { result = super.getLowerCaseNameImpl() }

  bindingset[name]
  pragma[inline_late]
  final predicate matchesName(string name) { this.getLowerCaseName() = name.toLowerCase() }

  bindingset[result]
  pragma[inline_late]
  final string getAName() { result.toLowerCase() = this.getLowerCaseName() }

  override Ast getChild(ChildIndex childIndex) { none() }
}
