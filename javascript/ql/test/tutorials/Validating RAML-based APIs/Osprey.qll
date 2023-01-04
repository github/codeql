/** Model of Osprey API implementations. */

import javascript
import HTTP

/** An import of the Osprey module. */
class OspreyImport extends Require {
  OspreyImport() { getImportedPath().getValue() = "osprey" }
}

/** A variable that holds the Osprey module. */
class Osprey extends Variable {
  Osprey() { getAnAssignedExpr() instanceof OspreyImport }
}

/** A call to `osprey.create`. */
class OspreyCreateApiCall extends MethodCallExpr {
  OspreyCreateApiCall() {
    getReceiver().(VarAccess).getVariable() instanceof Osprey and
    getMethodName() = "create"
  }

  /** Get the specification file for the API definition. */
  File getSpecFile() {
    exists(ObjectExpr oe, PathExpr p |
      oe = getArgument(2) and
      p = oe.getPropertyByName("ramlFile").getInit() and
      result = p.resolve()
    )
  }
}

/** DEPRECATED: Alias for OspreyCreateApiCall */
deprecated class OspreyCreateAPICall = OspreyCreateApiCall;

/** A variable in which an Osprey API object is stored. */
class OspreyApi extends Variable {
  OspreyApi() { getAnAssignedExpr() instanceof OspreyCreateApiCall }

  File getSpecFile() { result = getAnAssignedExpr().(OspreyCreateApiCall).getSpecFile() }
}

/** DEPRECATED: Alias for OspreyApi */
deprecated class OspreyAPI = OspreyApi;

/** An Osprey REST method definition. */
class OspreyMethodDefinition extends MethodCallExpr {
  OspreyMethodDefinition() {
    exists(OspreyApi api | getReceiver() = api.getAnAccess()) and
    getMethodName() = httpVerb()
  }

  /** Get the API to which this method belongs. */
  OspreyApi getApi() { getReceiver() = result.getAnAccess() }

  /** DEPRECATED: Alias for getApi */
  deprecated OspreyAPI getAPI() { result = getApi() }

  /** Get the verb which this method implements. */
  string getVerb() { result = getMethodName() }

  /** Get the resource path to which this method belongs. */
  string getResourcePath() { result = getArgument(0).getStringValue() }
}

/** A callback function bound to a REST method. */
class OspreyMethod extends FunctionExpr {
  OspreyMethod() { exists(OspreyMethodDefinition omd | this = omd.getArgument(1)) }

  OspreyMethodDefinition getDefinition() { this = result.getArgument(1) }

  string getVerb() { result = getDefinition().getVerb() }

  string getResourcePath() { result = getDefinition().getResourcePath() }
}

/** A variable that is bound to a response object. */
class MethodResponse extends Variable {
  MethodResponse() {
    exists(OspreyMethod m, SimpleParameter res |
      res = m.getParameter(1) and
      this = res.getVariable()
    )
  }

  OspreyMethod getMethod() { this = result.getParameter(1).(SimpleParameter).getVariable() }
}

/** A call that sets the status on a response object. */
class MethodResponseSetStatus extends MethodCallExpr {
  MethodResponseSetStatus() {
    exists(MethodResponse mr |
      getReceiver() = mr.getAnAccess() and
      getMethodName() = "status"
    )
  }

  OspreyMethod getMethod() {
    exists(MethodResponse mr |
      getReceiver() = mr.getAnAccess() and
      result = mr.getMethod()
    )
  }

  int getStatusCode() { result = getArgument(0).getIntValue() }
}
