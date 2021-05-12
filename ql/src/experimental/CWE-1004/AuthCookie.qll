import go

/**
 * A simplistic points-to alternative: given a struct creation and a field name, get the values that field can be assigned.
 *
 * Assumptions:
 *    - we don't reassign the variable that the creation is stored in
 *    - we always access the creation through the same variable it is initially assigned to
 *
 * This should cover most typical patterns...
 */
DataFlow::Node getValueForFieldWrite(StructLit sl, string field) {
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
    exists(CallExpr c |
      c.getTarget().hasQualifiedName("net/http", "SetCookie") and
      this.asExpr() = c.getArgument(1)
    )
  }
}

/**
 * Tracks `net/http.Cookie` creation to `net/http.SetCookie`.
 */
class NetHttpCookieTrackingConfiguration extends TaintTracking::Configuration {
  NetHttpCookieTrackingConfiguration() { this = "NetHttpCookieTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(StructLit sl |
      source.asExpr() = sl and
      sl.getType().hasQualifiedName("net/http", "Cookie")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof SetCookieSink and
    exists(NameToNetHttpCookieTrackingConfiguration cfg, DataFlow::Node nameArg |
      cfg.hasFlow(_, nameArg) and
      sink.asExpr() = nameArg.asExpr()
    )
  }
}

/**
 * Tracks sensitive name to `net/http.SetCookie`.
 */
private class NameToNetHttpCookieTrackingConfiguration extends TaintTracking2::Configuration {
  NameToNetHttpCookieTrackingConfiguration() { this = "NameToNetHttpCookieTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) { isAuthVariable(source.asExpr()) }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SetCookieSink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(StructLit sl |
      sl.getType().hasQualifiedName("net/http", "Cookie") and
      getValueForFieldWrite(sl, "Name") = pred and
      sl = succ.asExpr()
    )
  }
}

/**
 * Tracks `HttpOnly` set to `false` to `net/http.SetCookie`.
 */
class BoolToNetHttpCookieTrackingConfiguration extends TaintTracking::Configuration {
  BoolToNetHttpCookieTrackingConfiguration() { this = "BoolToNetHttpCookieTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) { source.asExpr().getBoolValue() = false }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SetCookieSink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(StructLit sl |
      sl.getType().hasQualifiedName("net/http", "Cookie") and
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

  override predicate isSource(DataFlow::Node source) { source.asExpr().getBoolValue() = false }

  override predicate isSink(DataFlow::Node sink) {
    exists(CallExpr c |
      c.getTarget().getQualifiedName() = "github.com/gin-gonic/gin.Context.SetCookie" and
      c.getArgument(6) = sink.asExpr() and
      exists(NameToGinSetCookieTrackingConfiguration cfg, DataFlow::Node nameArg |
        cfg.hasFlow(_, nameArg) and
        c.getArgument(0) = nameArg.asExpr()
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
    exists(CallExpr c |
      c.getTarget().getQualifiedName() = "github.com/gin-gonic/gin.Context.SetCookie" and
      c.getArgument(0) = sink.asExpr()
    )
  }
}

/**
 * A cookie passed the second parameter to `gorilla/sessions.Session.Save`.
 */
private class GorillaSessionSaveSink extends DataFlow::Node {
  GorillaSessionSaveSink() {
    exists(CallExpr c |
      this.asExpr() = c.getCalleeExpr().(SelectorExpr).getBase() and
      c.getTarget().getQualifiedName() = "github.com/gorilla/sessions.Session.Save"
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
    exists(CallExpr c |
      source.asExpr() = c and
      c.getTarget().hasQualifiedName("github.com/gorilla/sessions", "NewCookieStore")
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof GorillaSessionSaveSink }

  override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Function f, DataFlow::CallNode cn | cn = f.getACall() |
      f.getQualifiedName() = "github.com/gorilla/sessions.CookieStore.Get" and
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
      sl.getType().hasQualifiedName("github.com/gorilla/sessions", "Options") and
      source.asExpr() = sl
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof GorillaSessionSaveSink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Field f, DataFlow::Write w, DataFlow::Node base |
      f.getQualifiedName() = "github.com/gorilla/sessions.Session.Options" and
      w.writesField(base, f, pred) and
      succ = base
    )
  }
}

/**
 * Tracks `HttpOnly` set to `false` to `gorilla/sessions.Session.Save`.
 */
class BoolToGorillaSessionOptionsTrackingConfiguration extends TaintTracking::Configuration {
  BoolToGorillaSessionOptionsTrackingConfiguration() {
    this = "BoolToGorillaSessionOptionsTrackingConfiguration"
  }

  override predicate isSource(DataFlow::Node source) { source.asExpr().getBoolValue() = false }

  override predicate isSink(DataFlow::Node sink) { sink instanceof GorillaSessionSaveSink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(StructLit sl |
      getValueForFieldWrite(sl, "HttpOnly") = pred and
      sl = succ.asExpr()
    )
    or
    exists(Field f, DataFlow::Write w, DataFlow::Node base |
      f.getQualifiedName() = "github.com/gorilla/sessions.Session.Options" and
      w.writesField(base, f, pred) and
      succ = base
    )
  }
}
