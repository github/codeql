/**
 * Provides classes and predicates for working with the Java Servlet API.
 */

import semmle.code.java.Type

/**
 * The interface `javax.servlet.ServletRequest` or
 * `javax.servlet.http.HttpServletRequest`.
 */
library class ServletRequest extends RefType {
  ServletRequest() {
    this.hasQualifiedName("javax.servlet", "ServletRequest") or
    this instanceof HttpServletRequest
  }
}

/**
 * The interface `javax.servlet.http.HttpServletRequest`.
 */
library class HttpServletRequest extends RefType {
  HttpServletRequest() { this.hasQualifiedName("javax.servlet.http", "HttpServletRequest") }
}

/**
 * The method `getParameter(String)` or `getParameterValues(String)`
 * declared in `javax.servlet.ServletRequest`.
 */
library class ServletRequestGetParameterMethod extends Method {
  ServletRequestGetParameterMethod() {
    this.getDeclaringType() instanceof ServletRequest and
    (
      this.hasName("getParameter") or
      this.hasName("getParameterValues")
    ) and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType() instanceof TypeString
  }
}

/**
 * The method `getParameterNames()` declared in `javax.servlet.ServletRequest`.
 */
library class ServletRequestGetParameterNamesMethod extends Method {
  ServletRequestGetParameterNamesMethod() {
    this.getDeclaringType() instanceof ServletRequest and
    this.hasName("getParameterNames") and
    this.getNumberOfParameters() = 0
  }
}

/**
 * The method `getParameterMap()` declared in `javax.servlet.ServletRequest`.
 */
library class ServletRequestGetParameterMapMethod extends Method {
  ServletRequestGetParameterMapMethod() {
    this.getDeclaringType() instanceof ServletRequest and
    this.hasName("getParameterMap") and
    this.getNumberOfParameters() = 0
  }
}

/**
 * The method `getQueryString()` declared in `javax.servlet.http.HttpServletRequest`.
 */
library class HttpServletRequestGetQueryStringMethod extends Method {
  HttpServletRequestGetQueryStringMethod() {
    this.getDeclaringType() instanceof HttpServletRequest and
    this.hasName("getQueryString") and
    this.getNumberOfParameters() = 0
  }
}

/**
 * The method `getPathInfo()` declared in `javax.servlet.http.HttpServletRequest`.
 */
class HttpServletRequestGetPathMethod extends Method {
  HttpServletRequestGetPathMethod() {
    this.getDeclaringType() instanceof HttpServletRequest and
    this.hasName("getPathInfo") and
    this.getNumberOfParameters() = 0
  }
}

/**
 * The method `getHeader(String)` declared in `javax.servlet.http.HttpServletRequest`.
 */
library class HttpServletRequestGetHeaderMethod extends Method {
  HttpServletRequestGetHeaderMethod() {
    this.getDeclaringType() instanceof HttpServletRequest and
    this.hasName("getHeader") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType() instanceof TypeString
  }
}

/**
 * The method `getHeaders(String)` declared in `javax.servlet.http.HttpServletRequest`.
 */
library class HttpServletRequestGetHeadersMethod extends Method {
  HttpServletRequestGetHeadersMethod() {
    this.getDeclaringType() instanceof HttpServletRequest and
    this.hasName("getHeaders") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType() instanceof TypeString
  }
}

/**
 * The method `getHeaderNames()` declared in `javax.servlet.http.HttpServletRequest`.
 */
library class HttpServletRequestGetHeaderNamesMethod extends Method {
  HttpServletRequestGetHeaderNamesMethod() {
    this.getDeclaringType() instanceof HttpServletRequest and
    this.hasName("getHeaderNames") and
    this.getNumberOfParameters() = 0
  }
}

/**
 * The method `getRequestURL()` declared in `javax.servlet.http.HttpServletRequest`.
 */
class HttpServletRequestGetRequestUrlMethod extends Method {
  HttpServletRequestGetRequestUrlMethod() {
    this.getDeclaringType() instanceof HttpServletRequest and
    this.hasName("getRequestURL") and
    this.getNumberOfParameters() = 0
  }
}

/** DEPRECATED: Alias for HttpServletRequestGetRequestUrlMethod */
deprecated class HttpServletRequestGetRequestURLMethod = HttpServletRequestGetRequestUrlMethod;

/**
 * The method `getRequestURI()` declared in `javax.servlet.http.HttpServletRequest`.
 */
class HttpServletRequestGetRequestURIMethod extends Method {
  HttpServletRequestGetRequestURIMethod() {
    this.getDeclaringType() instanceof HttpServletRequest and
    this.hasName("getRequestURI") and
    this.getNumberOfParameters() = 0
  }
}

/**
 * The method `getRemoteUser()` declared in `javax.servlet.http.HttpServletRequest`.
 */
library class HttpServletRequestGetRemoteUserMethod extends Method {
  HttpServletRequestGetRemoteUserMethod() {
    this.getDeclaringType() instanceof HttpServletRequest and
    this.hasName("getRemoteUser") and
    this.getNumberOfParameters() = 0
  }
}

/**
 * The method `getInputStream()` or `getReader()` declared in `javax.servlet.ServletRequest`.
 */
library class ServletRequestGetBodyMethod extends Method {
  ServletRequestGetBodyMethod() {
    this.getDeclaringType() instanceof ServletRequest and
    (this.hasName("getInputStream") or this.hasName("getReader"))
  }
}

/**
 * The interface `javax.servlet.ServletResponse` or
 * `javax.servlet.http.HttpServletResponse`.
 */
class ServletResponse extends RefType {
  ServletResponse() {
    this.hasQualifiedName("javax.servlet", "ServletResponse") or
    this instanceof HttpServletResponse
  }
}

/**
 * The interface `javax.servlet.http.HttpServletResponse`.
 */
class HttpServletResponse extends RefType {
  HttpServletResponse() { this.hasQualifiedName("javax.servlet.http", "HttpServletResponse") }
}

/**
 * The method `sendError(int,String)` declared in `javax.servlet.http.HttpServletResponse`.
 */
class HttpServletResponseSendErrorMethod extends Method {
  HttpServletResponseSendErrorMethod() {
    this.getDeclaringType() instanceof HttpServletResponse and
    this.hasName("sendError") and
    this.getNumberOfParameters() = 2 and
    this.getParameter(0).getType().hasName("int") and
    this.getParameter(1).getType() instanceof TypeString
  }
}

/**
 * The method `getRequestDispatcher(String)` declared in `javax.servlet.http.HttpServletRequest` or `javax.servlet.ServletRequest`.
 */
class ServletRequestGetRequestDispatcherMethod extends Method {
  ServletRequestGetRequestDispatcherMethod() {
    this.getDeclaringType() instanceof ServletRequest and
    this.hasName("getRequestDispatcher")
  }
}

/**
 * The method `sendRedirect(String)` declared in `javax.servlet.http.HttpServletResponse`.
 */
class HttpServletResponseSendRedirectMethod extends Method {
  HttpServletResponseSendRedirectMethod() {
    this.getDeclaringType() instanceof HttpServletResponse and
    this.hasName("sendRedirect") and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType() instanceof TypeString
  }
}

/**
 * The method `getWriter()` declared in `javax.servlet.ServletResponse`.
 */
class ServletResponseGetWriterMethod extends Method {
  ServletResponseGetWriterMethod() {
    this.getDeclaringType() instanceof ServletResponse and
    this.hasName("getWriter") and
    this.getNumberOfParameters() = 0
  }
}

/**
 * The method `getOutputStream()` declared in `javax.servlet.ServletResponse`.
 */
class ServletResponseGetOutputStreamMethod extends Method {
  ServletResponseGetOutputStreamMethod() {
    this.getDeclaringType() instanceof ServletResponse and
    this.hasName("getOutputStream") and
    this.getNumberOfParameters() = 0
  }
}

/** The class `javax.servlet.http.Cookie`. */
library class TypeCookie extends Class {
  TypeCookie() { this.hasQualifiedName("javax.servlet.http", "Cookie") }
}

/**
 * The method `getValue(String)` declared in `javax.servlet.http.Cookie`.
 */
library class CookieGetValueMethod extends Method {
  CookieGetValueMethod() {
    this.getDeclaringType() instanceof TypeCookie and
    this.hasName("getValue") and
    this.getReturnType() instanceof TypeString
  }
}

/**
 * The method `getName()` declared in `javax.servlet.http.Cookie`.
 */
library class CookieGetNameMethod extends Method {
  CookieGetNameMethod() {
    this.getDeclaringType() instanceof TypeCookie and
    this.hasName("getName") and
    this.getReturnType() instanceof TypeString and
    this.getNumberOfParameters() = 0
  }
}

/**
 * The method `getComment()` declared in `javax.servlet.http.Cookie`.
 */
library class CookieGetCommentMethod extends Method {
  CookieGetCommentMethod() {
    this.getDeclaringType() instanceof TypeCookie and
    this.hasName("getComment") and
    this.getReturnType() instanceof TypeString and
    this.getNumberOfParameters() = 0
  }
}

/**
 * The method `addCookie(Cookie)` declared in `javax.servlet.http.HttpServletResponse`.
 */
class ResponseAddCookieMethod extends Method {
  ResponseAddCookieMethod() {
    this.getDeclaringType() instanceof HttpServletResponse and
    this.hasName("addCookie")
  }
}

/**
 * The method `addHeader` declared in `javax.servlet.http.HttpServletResponse`.
 */
class ResponseAddHeaderMethod extends Method {
  ResponseAddHeaderMethod() {
    this.getDeclaringType() instanceof HttpServletResponse and
    this.hasName("addHeader")
  }
}

/**
 * The method `setHeader` declared in `javax.servlet.http.HttpServletResponse`.
 */
class ResponseSetHeaderMethod extends Method {
  ResponseSetHeaderMethod() {
    this.getDeclaringType() instanceof HttpServletResponse and
    this.hasName("setHeader")
  }
}

/**
 * A class that has `javax.servlet.Servlet` as an ancestor.
 */
class ServletClass extends Class {
  ServletClass() { this.getAnAncestor().hasQualifiedName("javax.servlet", "Servlet") }
}

/**
 * The set of `Servlet` listener types that can be specified in a `web.xml` file.
 *
 * Note: There are a number of other listener interfaces in the `javax.servlet` package that cannot
 * be configured in `web.xml` and therefore are not covered by this class.
 */
class ServletWebXmlListenerType extends RefType {
  ServletWebXmlListenerType() {
    this.hasQualifiedName("javax.servlet", "ServletContextAttributeListener") or
    this.hasQualifiedName("javax.servlet", "ServletContextListener") or
    this.hasQualifiedName("javax.servlet", "ServletRequestAttributeListener") or
    this.hasQualifiedName("javax.servlet", "ServletRequestListener") or
    this.hasQualifiedName("javax.servlet.http", "HttpSessionAttributeListener") or
    this.hasQualifiedName("javax.servlet.http", "HttpSessionIdListener") or
    this.hasQualifiedName("javax.servlet.http", "HttpSessionListener")
    // Listeners that are not configured in `web.xml`:
    //  - `HttpSessionActivationListener`
    //  - `HttpSessionBindingListener`
  }
}

/** DEPRECATED: Alias for ServletWebXmlListenerType */
deprecated class ServletWebXMLListenerType = ServletWebXmlListenerType;

/** Holds if `m` is a request handler method (for example `doGet` or `doPost`). */
predicate isServletRequestMethod(Method m) {
  m.getDeclaringType() instanceof ServletClass and
  m.getNumberOfParameters() = 2 and
  m.getParameter(0).getType() instanceof ServletRequest and
  m.getParameter(1).getType() instanceof ServletResponse
}

/** Holds if `ma` is a call that gets a request parameter. */
predicate isRequestGetParamMethod(MethodAccess ma) {
  ma.getMethod() instanceof ServletRequestGetParameterMethod or
  ma.getMethod() instanceof ServletRequestGetParameterMapMethod or
  ma.getMethod() instanceof HttpServletRequestGetQueryStringMethod
}

/** The Java EE RequestDispatcher. */
class RequestDispatcher extends RefType {
  RequestDispatcher() {
    this.hasQualifiedName(["javax.servlet", "jakarta.servlet"], "RequestDispatcher") or
    this.hasQualifiedName("javax.portlet", "PortletRequestDispatcher")
  }
}

/** The `getRequestDispatcher` method. */
class GetRequestDispatcherMethod extends Method {
  GetRequestDispatcherMethod() {
    this.getReturnType() instanceof RequestDispatcher and
    this.getName() = "getRequestDispatcher"
  }
}

/** The request dispatch method. */
class RequestDispatchMethod extends Method {
  RequestDispatchMethod() {
    this.getDeclaringType() instanceof RequestDispatcher and
    this.hasName(["forward", "include"])
  }
}
