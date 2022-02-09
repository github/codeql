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

/** `JFinal` data model related to session and request attribute operations. */
private class JFinalDataModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "com.jfinal.core;Controller;true;setSessionAttr;;;Argument[0];MapKey of SyntheticField[com.jfinal.core.Controller.session] of Argument[-1];value",
        "com.jfinal.core;Controller;true;setSessionAttr;;;Argument[1];MapValue of SyntheticField[com.jfinal.core.Controller.session] of Argument[-1];value",
        "com.jfinal.core;Controller;true;getSessionAttr;;;MapValue of SyntheticField[com.jfinal.core.Controller.session] of Argument[-1];ReturnValue;value",
        "com.jfinal.core;Controller;true;set" + ["", "Attr"] +
          ";;;Argument[0];MapKey of SyntheticField[com.jfinal.core.Controller.request] of Argument[-1];value",
        "com.jfinal.core;Controller;true;set" + ["", "Attr"] +
          ";;;Argument[1];MapValue of SyntheticField[com.jfinal.core.Controller.request] of Argument[-1];value",
        "com.jfinal.core;Controller;true;get" + ["Attr", "AttrForStr"] +
          ";;;MapValue of SyntheticField[com.jfinal.core.Controller.request] of Argument[-1];ReturnValue;value"
      ]
  }
}
