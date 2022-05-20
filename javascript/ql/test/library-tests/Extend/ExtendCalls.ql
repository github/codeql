import javascript

class Assertion extends CallExpr {
  Assertion() {
    getCalleeName() = "checkDeep" or
    getCalleeName() = "checkShallow"
  }

  predicate shouldBeDeep() { getCalleeName() = "checkDeep" }

  ExtendCall getExtendCall() { result = getArgument(0).flow() }

  string getMessage() {
    if not exists(getExtendCall())
    then result = "Not an extend call"
    else
      if shouldBeDeep() and not getExtendCall().isDeep()
      then result = "Not deep"
      else
        if not shouldBeDeep() and getExtendCall().isDeep()
        then result = "Not shallow"
        else result = "OK"
  }
}

from Assertion assertion
select assertion, assertion.getMessage()
