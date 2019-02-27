import javascript
import semmle.javascript.frameworks.Express
import semmle.javascript.frameworks.ExpressModules

query DataFlow::Node test_appCreation() { result = Express::appCreation() }

query predicate test_CookieMiddlewareInstance_getASecretKey(
  HTTP::CookieMiddlewareInstance instance, DataFlow::Node key
) {
  key = instance.getASecretKey()
}

query predicate test_Credentials_getCredentialsKind(Express::Credentials cr, string kind) {
  kind = cr.getCredentialsKind()
}

query predicate test_Session_getOption(
  ExpressLibraries::ExpressSession::MiddlewareInstance session, string name, DataFlow::Node option
) {
  option = session.getOption(name)
}

query predicate test_RequestHeaderAccess_getAHeaderName(
  HTTP::RequestHeaderAccess access, string name
) {
  name = access.getAHeaderName()
}

query predicate test_HeaderDefinition_defines_getRouteHandler(
  HTTP::HeaderDefinition hd, string name, string value, Express::RouteHandler handler
) {
  hd.defines(name, value) and
  hd.getRouteHandler() = handler
}

query predicate test_HeaderDefinition_getAHeaderName_getRouteHandler(
  HTTP::HeaderDefinition hd, string name, Express::RouteHandler handler
) {
  hd.getAHeaderName() = name and
  hd.getRouteHandler() = handler
}

query predicate test_ExplicitHeaderDefinition_getNameExpr_getRouteHandler(
  HTTP::ExplicitHeaderDefinition hd, Expr expr, Express::RouteHandler handler
) {
  hd.getNameExpr() = expr and
  hd.getRouteHandler() = handler
}

query predicate test_HeaderDefinition_getRouteHandler(
  HTTP::HeaderDefinition hd, Express::RouteHandler handler
) {
  hd.getRouteHandler() = handler
}

query predicate test_isRequest(Expr nd) { Express::isRequest(nd) }

query predicate test_isResponse(Expr nd) { Express::isResponse(nd) }

query predicate test_routerCreation(DataFlow::Node nd) { nd = Express::routerCreation() }

query predicate test_RedirectInvocation_getRouteHandler(
  HTTP::RedirectInvocation red, Express::RouteHandler rh
) {
  rh = red.getRouteHandler()
}

query predicate test_RequestBodyAccess(Express::RequestBodyAccess rba) { any() }

query predicate test_RequestExpr_getRouteHandler(Express::RequestExpr e, Express::RouteHandler rh) {
  rh = e.getRouteHandler()
}

query predicate test_RequestInputAccess_getKind_getRouteHandler(
  Express::RequestInputAccess ria, string kind, Express::RouteHandler rh
) {
  rh = ria.getRouteHandler() and
  kind = ria.getKind()
}

query predicate test_ResponseBody_getRouteHandler(HTTP::ResponseBody rb, Express::RouteHandler rh) {
  rb.getRouteHandler() = rh
}

query predicate test_ResponseExpr_getRouteHandler(Express::ResponseExpr e, Express::RouteHandler rh) {
  e.getRouteHandler() = rh
}

query predicate test_ResponseSendArgument_getRouteHandler(
  HTTP::ResponseSendArgument send, Express::RouteHandler rh
) {
  rh = send.getRouteHandler()
}

query predicate test_RouteExpr_getRouter(Express::RouteExpr e, Express::RouterDefinition r) {
  r = e.getRouter()
}

query predicate test_RouteHandlerExpr_getAMatchingAncestor(
  Express::RouteHandlerExpr expr, Express::RouteHandlerExpr ancestor
) {
  ancestor = expr.getAMatchingAncestor()
}

query predicate test_RouteHandlerExpr_getAsSubRouter(
  Express::RouteHandlerExpr expr, Express::RouterDefinition router
) {
  router = expr.getAsSubRouter()
}

query predicate test_RouteHandlerExpr_getBody(
  Express::RouteHandlerExpr expr, Express::RouteHandler body
) {
  body = expr.getBody()
}

query predicate test_RouteHandlerExpr_getNextMiddleware(
  Express::RouteHandlerExpr expr, Express::RouteHandlerExpr next
) {
  next = expr.getNextMiddleware()
}

query predicate test_RouteHandlerExpr_getPreviousMiddleware(
  Express::RouteHandlerExpr expr, Express::RouteHandlerExpr next
) {
  next = expr.getPreviousMiddleware()
}

query predicate test_RouteHandlerExpr_isLastHandler(Express::RouteHandlerExpr rhe, boolean isLast) {
  if rhe.isLastHandler() then isLast = true else isLast = false
}

query predicate test_RouteHandler_getARequestBodyAccess(Express::RouteHandler rh, Expr body) {
  body = rh.getARequestBodyAccess()
}

query predicate test_RouteHandler_getARequestExpr(Express::RouteHandler rh, Expr req) {
  req = rh.getARequestExpr()
}

query predicate test_RouteHandler_getAResponseExpr(Express::RouteHandler rh, Expr res) {
  res = rh.getAResponseExpr()
}

query predicate test_RouteHandler_getAResponseHeader(
  Express::RouteHandler rh, string name, HTTP::HeaderDefinition h
) {
  h = rh.getAResponseHeader(name)
}

query predicate test_RouteHandler_getRequestParameter_getResponseParameter(
  Express::RouteHandler rh, SimpleParameter req, SimpleParameter res
) {
  req = rh.getRequestParameter() and
  res = rh.getResponseParameter()
}

query predicate test_RouterDefinition_getARouteHandler(
  Express::RouterDefinition r, HTTP::RouteHandler h
) {
  h = r.getARouteHandler()
}

query predicate test_RouterDefinition_getASubRouter(
  Express::RouterDefinition r, Express::RouterDefinition sub
) {
  sub = r.getASubRouter()
}

query predicate test_RouterDefinition_getMiddlewareStackAt(
  Express::RouterDefinition r, ControlFlowNode nd, Express::RouteHandlerExpr stack
) {
  stack = r.getMiddlewareStackAt(nd)
}

query predicate test_RouterDefinition_getMiddlewareStack(
  Express::RouterDefinition r, Express::RouteHandlerExpr stack
) {
  stack = r.getMiddlewareStack()
}

query predicate test_RouterDefinition(Express::RouterDefinition r) { any() }

query predicate test_RouteSetup_getARouteHandlerExpr(Express::RouteSetup r, Expr e) {
  e = r.getARouteHandlerExpr()
}

query predicate test_RouteSetup_getARouteHandler(Express::RouteSetup r, DataFlow::Node n) {
  n = r.getARouteHandler()
}

query predicate test_RouteSetup_getLastRouteHandlerExpr(Express::RouteSetup r, Expr last) {
  last = r.getLastRouteHandlerExpr()
}

query predicate test_RouteSetup_getRequestMethod(Express::RouteSetup r, HTTP::RequestMethodName name) {
  name = r.getRequestMethod()
}

query predicate test_RouteSetup_getRouteHandlerExpr_i(Express::RouteSetup r, Expr e, int i) {
  e = r.getRouteHandlerExpr(i)
}

query predicate test_RouteSetup_getRouter(Express::RouteSetup r, Express::RouterDefinition def) {
  def = r.getRouter()
}

query predicate test_RouteSetup_getServer(Express::RouteSetup r, Expr s) { s = r.getServer() }

query predicate test_RouteSetup_handlesAllRequestMethods(Express::RouteSetup r) {
  r.handlesAllRequestMethods()
}

query predicate test_RouteSetup_handlesSameRequestMethodAs(
  Express::RouteSetup rs, Express::RouteSetup rs2
) {
  rs.handlesSameRequestMethodAs(rs2) and
  rs.getLocation().getStartLine() < rs2.getLocation().getStartLine() and
  rs.getLocation().getFile().getBaseName() = "csurf-example.js" and
  rs2.getLocation().getFile().getBaseName() = "csurf-example.js"
}

query predicate test_RouteSetup_getServer_isUseCall(Express::RouteSetup r, Expr s, boolean isUseCall) {
  s = r.getServer() and
  if r.isUseCall() then isUseCall = true else isUseCall = false
}

query predicate test_CookieDefinition_getRouterHandler(
  HTTP::CookieDefinition cookiedef, Express::RouteHandler rh
) {
  rh = cookiedef.getRouteHandler()
}

query predicate test_StandardRouteHandler_getServer_getRequestParameter_getResponseParameter(
  Express::StandardRouteHandler rh, Expr server, SimpleParameter req, SimpleParameter res
) {
  server = rh.getServer() and
  req = rh.getRequestParameter() and
  res = rh.getResponseParameter()
}
