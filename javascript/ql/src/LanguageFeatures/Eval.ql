/**
 * @name Use of eval
 * @description The 'eval' function and the 'Function' constructor execute strings as code. This is dangerous and impedes
 *              program analysis and understanding. Consequently, these two functions should not be used.
 * @kind problem
 * @problem.severity recommendation
 * @id js/eval-call
 * @tags maintainability
 *       language-features
 *       external/cwe/cwe-676
 * @precision medium
 */

import javascript

/**
 * A call to `new Function(...)`.
 */
class NewFunction extends DataFlow::NewNode {
  NewFunction() { this = DataFlow::globalVarRef("Function").getAnInvocation() }
}

/**
 * A call to `eval`.
 */
class EvalCall extends DataFlow::CallNode {
  EvalCall() { this = DataFlow::globalVarRef("eval").getACall() }
}

/**
 * A call to `new Function(...)` or `eval`.
 */
class EvalUse extends DataFlow::Node {
  EvalUse() { this instanceof NewFunction or this instanceof EvalCall }
}

from EvalUse eval
select eval, "Do not use eval or the Function constructor."
