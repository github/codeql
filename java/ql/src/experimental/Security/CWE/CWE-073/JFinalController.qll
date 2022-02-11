import java
import semmle.code.java.dataflow.FlowSources

/** The class `com.jfinal.core.Controller`. */
class JFinalController extends RefType {
  JFinalController() { this.hasQualifiedName("com.jfinal.core", "Controller") }
}

/** The method `getSessionAttr` of `JFinalController`. */
class GetSessionAttributeMethod extends Method {
  GetSessionAttributeMethod() {
    this.getName() = "getSessionAttr" and
    this.getDeclaringType().getASupertype*() instanceof JFinalController
  }
}

/** The method `setSessionAttr` of `JFinalController`. */
class SetSessionAttributeMethod extends Method {
  SetSessionAttributeMethod() {
    this.getName() = "setSessionAttr" and
    this.getDeclaringType().getASupertype*() instanceof JFinalController
  }
}

/** The request attribute getter method of `JFinalController`. */
class GetRequestAttributeMethod extends Method {
  GetRequestAttributeMethod() {
    this.getName().matches("getAttr%") and
    this.getDeclaringType().getASupertype*() instanceof JFinalController
  }
}

/** The request attribute setter method of `JFinalController`. */
class SetRequestAttributeMethod extends Method {
  SetRequestAttributeMethod() {
    this.getName() = ["set", "setAttr"] and
    this.getDeclaringType().getASupertype*() instanceof JFinalController
  }
}

/**
 * Holds if the result of an attribute getter call is from a method invocation of remote attribute setter.
 * Only values received from remote flow source is to be checked by the query.
 */
predicate isGetAttributeFromRemoteSource(Expr expr) {
  exists(MethodAccess gma, MethodAccess sma |
    (
      gma.getMethod() instanceof GetSessionAttributeMethod and
      sma.getMethod() instanceof SetSessionAttributeMethod
      or
      gma.getMethod() instanceof GetRequestAttributeMethod and
      sma.getMethod() instanceof SetRequestAttributeMethod
    ) and
    expr = gma and
    gma.getArgument(0).(CompileTimeConstantExpr).getStringValue() =
      sma.getArgument(0).(CompileTimeConstantExpr).getStringValue() and
    gma.getEnclosingCallable() = sma.getEnclosingCallable() and
    TaintTracking::localExprTaint(any(RemoteFlowSource rs).asExpr(), sma.getArgument(1))
  )
}

/** Remote flow source of JFinal request or session attribute getters. */
private class JFinalRequestSource extends RemoteFlowSource {
  JFinalRequestSource() { isGetAttributeFromRemoteSource(this.asExpr()) }

  override string getSourceType() { result = "JFinal session or request attribute source" }
}

/** Source model of remote flow source with `JFinal`. */
private class JFinalControllerSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        "com.jfinal.core;Controller;true;getCookie" + ["", "Object", "Objects", "ToInt", "ToLong"] +
          ";;;ReturnValue;remote",
        "com.jfinal.core;Controller;true;getFile" + ["", "s"] + ";;;ReturnValue;remote",
        "com.jfinal.core;Controller;true;getHeader;;;ReturnValue;remote",
        "com.jfinal.core;Controller;true;getKv;;;ReturnValue;remote",
        "com.jfinal.core;Controller;true;getPara" +
          [
            "", "Map", "ToBoolean", "ToDate", "ToInt", "ToLong", "Values", "ValuesToInt",
            "ValuesToLong"
          ] + ";;;ReturnValue;remote",
        "com.jfinal.core;Controller;true;get" + ["", "Int", "Long", "Boolean", "Date"] +
          ";;;ReturnValue;remote"
      ]
  }
}
