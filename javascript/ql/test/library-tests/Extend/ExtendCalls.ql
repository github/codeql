import javascript

class Assertion extends CallExpr {
  Assertion() {
    this.getCalleeName() = "checkDeep" or
    this.getCalleeName() = "checkShallow"
  }

  predicate shouldBeDeep() { this.getCalleeName() = "checkDeep" }

  ExtendCall getExtendCall() { result = this.getArgument(0).flow() }

  string getMessage() {
    if not exists(this.getExtendCall())
    then result = "Not an extend call"
    else
      if this.shouldBeDeep() and not this.getExtendCall().isDeep()
      then result = "Not deep"
      else
        if not this.shouldBeDeep() and this.getExtendCall().isDeep()
        then result = "Not shallow"
        else result = "OK"
  }
}

from Assertion assertion
select assertion, assertion.getMessage()
