/**
 * @name Call to eval-like DOM function
 * @description DOM functions that act like 'eval' and execute strings as code are dangerous and impede
 *              program analysis and understanding. Consequently, they should not be used.
 * @kind problem
 * @problem.severity recommendation
 * @id js/eval-like-call
 * @tags maintainability
 *       external/cwe/cwe-676
 * @precision very-high
 */

import javascript

/**
 * A call to either `setTimeout` or `setInterval` where
 * a string literal is passed as first argument.
 */
class EvilTwin extends DataFlow::CallNode {
  EvilTwin() {
    exists(string fn | fn = "setTimeout" or fn = "setInterval" |
      this = DataFlow::globalVarRef(fn).getACall() and
      getArgument(0).asExpr() instanceof ConstantString
    )
  }
}

/** A call to `document.write` or `document.writeln`. */
class DocumentWrite extends DataFlow::CallNode {
  DocumentWrite() {
    exists(string writeln |
      this = DataFlow::globalVarRef("document").getAMemberCall(writeln) and
      writeln.regexpMatch("write(ln)?")
    )
  }
}

/** A call to `window.execScript`. */
class ExecScript extends DataFlow::CallNode {
  ExecScript() { this = DataFlow::globalVarRef("execScript").getACall() }
}

/** A call to a DOM function that may evaluate a string as code. */
class PseudoEval extends DataFlow::Node {
  PseudoEval() {
    this instanceof EvilTwin or
    this instanceof DocumentWrite or
    this instanceof ExecScript
  }
}

from PseudoEval pe
select pe, "Avoid using functions that evaluate strings as code."
