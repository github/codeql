import java
import semmle.code.java.dataflow.FlowSources

/** The class `com.jfinal.config.Routes`. */
class JFinalRoutes extends RefType {
  JFinalRoutes() { this.hasQualifiedName("com.jfinal.config", "Routes") }
}

/** The method `add` of the class `Routes`. */
class AddJFinalRoutes extends Method {
  AddJFinalRoutes() {
    this.getDeclaringType() instanceof JFinalRoutes and
    this.getName() = "add"
  }
}

/** The class `com.jfinal.core.Controller`. */
class JFinalController extends RefType {
  JFinalController() { this.hasQualifiedName("com.jfinal.core", "Controller") }
}

/** Source model of remote flow source with `JFinal`. */
private class JFinalControllerSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        "com.jfinal.core;Controller;true;getAttr" + ["", "ForInt", "ForStr"] +
          ";;;ReturnValue;remote",
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
        "com.jfinal.core;Controller;true;getSession" + ["", "Attr"] + ";;;ReturnValue;remote",
        "com.jfinal.core;Controller;true;get" + ["", "Int", "Long", "Boolean", "Date"] +
          ";;;ReturnValue;remote"
      ]
  }
}
