import javascript

abstract class Assertion extends CallExpr {
  string functionName;

  Assertion() { this.getCalleeName() = functionName }

  Variable getVariable() { result.getAnAccess() = this.getArgument(0) }

  abstract string getViolation();
}

class ResolveGlobalCall extends Assertion {
  ResolveGlobalCall() { functionName = "resolveGlobal" }

  override string getViolation() {
    not getVariable().isGlobal() and
    result = getVariable().getName() + " should resolve to a global variable"
  }
}

class ResolveAmbientCall extends Assertion {
  ResolveAmbientCall() { functionName = "resolveAmbient" }

  override string getViolation() {
    getVariable().isGlobal() and
    result = getVariable().getName() + " should not resolve to a global"
  }
}

from Assertion call
select call, call.getViolation()
