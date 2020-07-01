/**
 * @name AV Rule 20
 * @description The setjmp macro and the longjmp function shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-20
 * @problem.severity warning
 * @tags correctness
 *       portability
 *       readability
 *       external/jsf
 */

import cpp

class Setjmp extends Macro {
  Setjmp() {
    super.getHead().matches("setjmp(%)") and
    super.getFile().getAbsolutePath().matches("%setjmp.h")
  }
}

class Longjmp extends Function {
  Longjmp() {
    super.hasName("longjmp") and
    super.getNumberOfParameters() = 2 and
    super.getFile().getAbsolutePath().matches("%setjmp.h")
  }
}

from Setjmp setjmp, Longjmp longjmp, Locatable use
where
  use = setjmp.getAnInvocation() or
  use = longjmp.getACallToThisFunction()
select use, "AV Rule 20: The setjmp macro and the longjmp function shall not be used."
