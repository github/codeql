/**
 * Provides classes and predicates for the 'js/unused-local-variable' query.
 */

import javascript
import LanguageFeatures.UnusedIndexVariable

/**
 * A local variable that is neither used nor exported, and is not a parameter
 * or a function name.
 */
class UnusedLocal extends LocalVariable {
  UnusedLocal() {
    not exists(this.getAnAccess()) and
    not exists(Parameter p | this = p.getAVariable()) and
    not exists(FunctionExpr fe | this = fe.getVariable()) and
    not exists(ClassExpr ce | this = ce.getVariable()) and
    not exists(ExportDeclaration ed | ed.exportsAs(this, _)) and
    not exists(LocalVarTypeAccess type | type.getVariable() = this) and
    // avoid double reporting
    not unusedIndexVariable(_, this, _) and
    // common convention: variables with leading underscore are intentionally unused
    this.getName().charAt(0) != "_"
  }
}
