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
 * DEPRECATED: Use `NameToNetHttpCookieTrackingFlow` instead.
 *
 * A taint-tracking configuration for tracking flow from sensitive names to
 * `net/http.SetCookie`.
 */
deprecated class NameToNetHttpCookieTrackingConfiguration extends TaintTracking::Configuration {
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

private module NameToNetHttpCookieTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isAuthVariable(source.asExpr()) }

  predicate isSink(DataFlow::Node sink) { sink instanceof SetCookieSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(StructLit sl |
      sl.getType() instanceof NetHttpCookieType and
      getValueForFieldWrite(sl, "Name") = pred and
      sl = succ.asExpr()
    )
  }
}

/** Tracks taint flow from sensitive names to `net/http.SetCookie`. */
module NameToNetHttpCookieTrackingFlow = TaintTracking::Global<NameToNetHttpCookieTrackingConfig>;

/**
 * DEPRECATED: Use `BoolToNetHttpCookieTrackingFlow` instead.
 *
 * A taint-tracking configuration for tracking flow from `bool` assigned to
 * `HttpOnly` that flows into `net/http.SetCookie`.
 */
deprecated class BoolToNetHttpCookieTrackingConfiguration extends TaintTracking::Configuration {
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

private module BoolToNetHttpCookieTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.getType().getUnderlyingType() instanceof BoolType
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof SetCookieSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(StructLit sl |
      sl.getType() instanceof NetHttpCookieType and
      getValueForFieldWrite(sl, "HttpOnly") = pred and
      sl = succ.asExpr()
    )
  }
}

/**
 * Tracks taint flow from a `bool` assigned to `HttpOnly` to
 * `net/http.SetCookie`.
 */
module BoolToNetHttpCookieTrackingFlow = TaintTracking::Global<BoolToNetHttpCookieTrackingConfig>;

/**
 * DEPRECATED: Use `BoolToGinSetCookieTrackingFlow` instead.
 *
 * A taint-tracking configuration for tracking flow from `HttpOnly` set to
 * `false` to `gin-gonic/gin.Context.SetCookie`.
 */
deprecated class BoolToGinSetCookieTrackingConfiguration extends DataFlow::Configuration {
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

private module BoolToGinSetCookieTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.getBoolValue() = false }

  predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::MethodCallNode mcn |
      mcn.getTarget() instanceof GinContextSetCookieMethod and
      mcn.getArgument(6) = sink and
      exists(DataFlow::Node nameArg |
        NameToGinSetCookieTrackingFlow::flowTo(nameArg) and
        mcn.getArgument(0) = nameArg
      )
    )
  }
}

/**
 * Tracks data flow from `HttpOnly` set to `false` to
 * `gin-gonic/gin.Context.SetCookie`.
 */
module BoolToGinSetCookieTrackingFlow = DataFlow::Global<BoolToGinSetCookieTrackingConfig>;

/**
 * DEPRECATED: Use `NameToGinSetCookieTrackingFlow` instead.
 *
 * A taint-tracking configuration for tracking flow from sensitive names to
 * `gin-gonic/gin.Context.SetCookie`.
 */
deprecated private class NameToGinSetCookieTrackingConfiguration extends DataFlow2::Configuration {
  NameToGinSetCookieTrackingConfiguration() { this = "NameToGinSetCookieTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) { isAuthVariable(source.asExpr()) }

  override predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::MethodCallNode mcn |
      mcn.getTarget() instanceof GinContextSetCookieMethod and
      mcn.getArgument(0) = sink
    )
  }
}

private module NameToGinSetCookieTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isAuthVariable(source.asExpr()) }

  predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::MethodCallNode mcn |
      mcn.getTarget() instanceof GinContextSetCookieMethod and
      mcn.getArgument(0) = sink
    )
  }
}

/**
 * Tracks taint flow from sensitive names to `gin-gonic/gin.Context.SetCookie`.
 */
private module NameToGinSetCookieTrackingFlow = DataFlow::Global<NameToGinSetCookieTrackingConfig>;

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
 * DEPRECATED: Use `GorillaCookieStoreSaveTrackingFlow` instead.
 *
 * A taint-tracking configuration for tracking flow from gorilla cookie store
 * creation to `gorilla/sessions.Session.Save`.
 */
deprecated class GorillaCookieStoreSaveTrackingConfiguration extends DataFlow::Configuration {
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

private module GorillaCookieStoreSaveTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source
        .(DataFlow::CallNode)
        .getTarget()
        .hasQualifiedName(package("github.com/gorilla/sessions", ""), "NewCookieStore")
  }

  predicate isSink(DataFlow::Node sink) {
    sink instanceof GorillaSessionSaveSink or
    sink instanceof GorillaStoreSaveSink
  }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::MethodCallNode cn |
      cn.getTarget()
          .hasQualifiedName(package("github.com/gorilla/sessions", ""), "CookieStore", "Get") and
      pred = cn.getReceiver() and
      succ = cn.getResult(0)
    )
  }
}

/**
 * Tracks data flow from gorilla cookie store creation to
 * `gorilla/sessions.Session.Save`.
 */
module GorillaCookieStoreSaveTrackingFlow = DataFlow::Global<GorillaCookieStoreSaveTrackingConfig>;

/**
 * DEPRECATED: Use `GorillaSessionOptionsTrackingFlow` instead.
 *
 * A taint-tracking configuration for tracking flow from session options to
 * `gorilla/sessions.Session.Save`.
 */
deprecated class GorillaSessionOptionsTrackingConfiguration extends TaintTracking::Configuration {
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

private module GorillaSessionOptionsTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(StructLit sl |
      sl.getType().hasQualifiedName(package("github.com/gorilla/sessions", ""), "Options") and
      source.asExpr() = sl
    )
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof GorillaSessionSaveSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(GorillaSessionOptionsField f, DataFlow::Write w, DataFlow::Node base |
      w.writesField(base, f, pred) and
      succ = base
    )
  }
}

/**
 * Tracks taint flow from session options to
 * `gorilla/sessions.Session.Save`.
 */
module GorillaSessionOptionsTrackingFlow =
  TaintTracking::Global<GorillaSessionOptionsTrackingConfig>;

/**
 * DEPRECATED: Use `BoolToGorillaSessionOptionsTrackingFlow` instead.
 *
 * A taint-tracking configuration for tracking flow from a `bool` assigned to
 * `HttpOnly` to `gorilla/sessions.Session.Save`.
 */
deprecated class BoolToGorillaSessionOptionsTrackingConfiguration extends TaintTracking::Configuration
{
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

private module BoolToGorillaSessionOptionsTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.getType().getUnderlyingType() instanceof BoolType
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof GorillaSessionSaveSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
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

/**
 * Tracks taint flow from a `bool` assigned to `HttpOnly` to
 * `gorilla/sessions.Session.Save`.
 */
module BoolToGorillaSessionOptionsTrackingFlow =
  TaintTracking::Global<BoolToGorillaSessionOptionsTrackingConfig>;
