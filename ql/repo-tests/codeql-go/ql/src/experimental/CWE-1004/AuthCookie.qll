import go

private class NetHttpCookieType extends Type {
  NetHttpCookieType() { this.hasQualifiedName(package("net/http", ""), "Cookie") }
}

private class GinContextSetCookieMethod extends Method {
  GinContextSetCookieMethod() {
    this.hasQualifiedName(package("github.com/gin-gonic/gin", ""), "Context", "SetCookie")
  }
}

private class GorillaSessionOptionsField extends Field {
  GorillaSessionOptionsField() {
    this.hasQualifiedName(package("github.com/gorilla/sessions", ""), "Session", "Options")
  }
}

/**
 * A simplistic points-to alternative: given a struct creation and a field name, get the values that field can be assigned.
 *
 * Assumptions:
 *    - we don't reassign the variable that the creation is stored in
 *    - we always access the creation through the same variable it is initially assigned to
 *
 * This should cover most typical patterns...
 */
private DataFlow::Node getValueForFieldWrite(StructLit sl, string field) {
  exists(Write w, DataFlow::Node base, Field f |
    f.getName() = field and
    w.writesField(base, f, result) and
    (
      sl = base.asExpr()
      or
      base.asExpr() instanceof VariableName and
      base.getAPredecessor*().asExpr() = sl
    )
  )
}

/**
 * Holds if the expression or its value has a sensitive name
 */
private predicate isAuthVariable(Expr expr) {
  exists(string val |
    (
      val = expr.getStringValue() or
      val = expr.(Name).getTarget().getName()
    ) and
    val.regexpMatch("(?i).*(session|login|token|user|auth|credential).*") and
    not val.regexpMatch("(?i).*(xsrf|csrf|forgery).*")
  )
}

/**
 * A cookie passed as the second parameter to `net/http.SetCookie`.
 */
private class SetCookieSink extends DataFlow::Node {
  SetCookieSink() {
    exists(DataFlow::CallNode cn |
      cn.getTarget().hasQualifiedName(package("net/http", ""), "SetCookie") and
      this = cn.getArgument(1)
    )
  }
}

/**
 * Tracks sensitive name to `net/http.SetCookie`.
 */
class NameToNetHttpCookieTrackingConfiguration extends TaintTracking::Configuration {
  NameToNetHttpCookieTrackingConfiguration() { this = "NameToNetHttpCookieTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) { isAuthVariable(source.asExpr()) }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SetCookieSink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(StructLit sl |
      sl.getType() instanceof NetHttpCookieType and
      getValueForFieldWrite(sl, "Name") = pred and
      sl = succ.asExpr()
    )
  }
}

/**
 * Tracks `bool` assigned to `HttpOnly` that flows into `net/http.SetCookie`.
 */
class BoolToNetHttpCookieTrackingConfiguration extends TaintTracking::Configuration {
  BoolToNetHttpCookieTrackingConfiguration() { this = "BoolToNetHttpCookieTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.getType().getUnderlyingType() instanceof BoolType
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SetCookieSink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(StructLit sl |
      sl.getType() instanceof NetHttpCookieType and
      getValueForFieldWrite(sl, "HttpOnly") = pred and
      sl = succ.asExpr()
    )
  }
}

/**
 * Tracks `HttpOnly` set to `false` to `gin-gonic/gin.Context.SetCookie`.
 */
class BoolToGinSetCookieTrackingConfiguration extends DataFlow::Configuration {
  BoolToGinSetCookieTrackingConfiguration() { this = "BoolToGinSetCookieTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) { source.getBoolValue() = false }

  override predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::MethodCallNode mcn |
      mcn.getTarget() instanceof GinContextSetCookieMethod and
      mcn.getArgument(6) = sink and
      exists(NameToGinSetCookieTrackingConfiguration cfg, DataFlow::Node nameArg |
        cfg.hasFlowTo(nameArg) and
        mcn.getArgument(0) = nameArg
      )
    )
  }
}

/**
 * Tracks sensitive name to `gin-gonic/gin.Context.SetCookie`.
 */
private class NameToGinSetCookieTrackingConfiguration extends DataFlow2::Configuration {
  NameToGinSetCookieTrackingConfiguration() { this = "NameToGinSetCookieTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) { isAuthVariable(source.asExpr()) }

  override predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::MethodCallNode mcn |
      mcn.getTarget() instanceof GinContextSetCookieMethod and
      mcn.getArgument(0) = sink
    )
  }
}

/**
 * The receiver of `gorilla/sessions.Session.Save` call.
 */
private class GorillaSessionSaveSink extends DataFlow::Node {
  GorillaSessionSaveSink() {
    exists(DataFlow::MethodCallNode mcn |
      this = mcn.getReceiver() and
      mcn.getTarget()
          .hasQualifiedName(package("github.com/gorilla/sessions", ""), "Session", "Save")
    )
  }
}

private class GorillaStoreSaveSink extends DataFlow::Node {
  GorillaStoreSaveSink() {
    exists(DataFlow::MethodCallNode mcn |
      this = mcn.getArgument(2) and
      mcn.getTarget()
          .hasQualifiedName(package("github.com/gorilla/sessions", ""), "CookieStore", "Save")
    )
  }
}

/**
 * Tracks from gorilla cookie store creation to `gorilla/sessions.Session.Save`.
 */
class GorillaCookieStoreSaveTrackingConfiguration extends DataFlow::Configuration {
  GorillaCookieStoreSaveTrackingConfiguration() {
    this = "GorillaCookieStoreSaveTrackingConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    source
        .(DataFlow::CallNode)
        .getTarget()
        .hasQualifiedName(package("github.com/gorilla/sessions", ""), "NewCookieStore")
  }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof GorillaSessionSaveSink or
    sink instanceof GorillaStoreSaveSink
  }

  override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::MethodCallNode cn |
      cn.getTarget()
          .hasQualifiedName(package("github.com/gorilla/sessions", ""), "CookieStore", "Get") and
      pred = cn.getReceiver() and
      succ = cn.getResult(0)
    )
  }
}

/**
 * Tracks session options to `gorilla/sessions.Session.Save`.
 */
class GorillaSessionOptionsTrackingConfiguration extends TaintTracking::Configuration {
  GorillaSessionOptionsTrackingConfiguration() {
    this = "GorillaSessionOptionsTrackingConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    exists(StructLit sl |
      sl.getType().hasQualifiedName(package("github.com/gorilla/sessions", ""), "Options") and
      source.asExpr() = sl
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof GorillaSessionSaveSink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(GorillaSessionOptionsField f, DataFlow::Write w, DataFlow::Node base |
      w.writesField(base, f, pred) and
      succ = base
    )
  }
}

/**
 * Tracks `bool` assigned to `HttpOnly` that flows into `gorilla/sessions.Session.Save`.
 */
class BoolToGorillaSessionOptionsTrackingConfiguration extends TaintTracking::Configuration {
  BoolToGorillaSessionOptionsTrackingConfiguration() {
    this = "BoolToGorillaSessionOptionsTrackingConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    source.getType().getUnderlyingType() instanceof BoolType
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof GorillaSessionSaveSink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(StructLit sl |
      getValueForFieldWrite(sl, "HttpOnly") = pred and
      sl = succ.asExpr()
    )
    or
    exists(GorillaSessionOptionsField f, DataFlow::Write w, DataFlow::Node base |
      w.writesField(base, f, pred) and
      succ = base
    )
  }
}
