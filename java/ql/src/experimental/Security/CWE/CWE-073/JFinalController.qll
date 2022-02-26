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

/** A request attribute getter method of `JFinalController`. */
class GetRequestAttributeMethod extends Method {
  GetRequestAttributeMethod() {
    this.getName().matches("getAttr%") and
    this.getDeclaringType().getASupertype*() instanceof JFinalController
  }
}

/** A request attribute setter method of `JFinalController`. */
class SetRequestAttributeMethod extends Method {
  SetRequestAttributeMethod() {
    this.getName() = ["set", "setAttr"] and
    this.getDeclaringType().getASupertype*() instanceof JFinalController
  }
}

/**
 * Value step from a setter call to a corresponding getter call relating to a
 * session or request attribute.
 */
private class SetToGetAttributeStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(MethodAccess gma, MethodAccess sma |
      (
        gma.getMethod() instanceof GetSessionAttributeMethod and
        sma.getMethod() instanceof SetSessionAttributeMethod
        or
        gma.getMethod() instanceof GetRequestAttributeMethod and
        sma.getMethod() instanceof SetRequestAttributeMethod
      ) and
      gma.getArgument(0).(CompileTimeConstantExpr).getStringValue() =
        sma.getArgument(0).(CompileTimeConstantExpr).getStringValue()
    |
      pred.asExpr() = sma.getArgument(1) and
      succ.asExpr() = gma
    )
  }
}

/** Remote flow source models relating to `JFinal`. */
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
