import java
import semmle.code.java.dataflow.TaintTracking2
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
    this.getName() = ["set", "setAttr", "setAttrs"] and
    this.getDeclaringType().getASupertype*() instanceof JFinalController
  }
}

/** Taint configuration of flow from remote source to attribute setter methods. */
class SetRemoteAttributeConfig extends TaintTracking2::Configuration {
  SetRemoteAttributeConfig() { this = "SetRemoteAttributeConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof SetSessionAttributeMethod and
      sink.asExpr() = ma.getArgument(1)
    )
  }
}

/** Holds if the result of an attribute getter call is from a method invocation of remote attribute setter. */
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
    exists(SetRemoteAttributeConfig cc | cc.hasFlowToExpr(sma.getArgument(1)))
  )
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
