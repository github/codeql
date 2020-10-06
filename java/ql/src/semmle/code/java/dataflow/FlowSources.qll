/**
 * Provides classes representing various flow sources for taint tracking.
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.DefUse
import semmle.code.java.frameworks.Jdbc
import semmle.code.java.frameworks.Networking
import semmle.code.java.frameworks.Properties
import semmle.code.java.frameworks.Rmi
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.ApacheHttp
import semmle.code.java.frameworks.android.XmlParsing
import semmle.code.java.frameworks.android.WebView
import semmle.code.java.frameworks.JaxWS
import semmle.code.java.frameworks.javase.WebSocket
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.frameworks.spring.SpringWeb
import semmle.code.java.frameworks.spring.SpringController
import semmle.code.java.frameworks.spring.SpringWebClient
import semmle.code.java.frameworks.Guice
import semmle.code.java.frameworks.struts.StrutsActions
import semmle.code.java.frameworks.Thrift

/** A data flow source of remote user input. */
abstract class RemoteFlowSource extends DataFlow::Node {
  /** Gets a string that describes the type of this remote flow source. */
  abstract string getSourceType();
}

private class RemoteTaintedMethodAccessSource extends RemoteFlowSource {
  RemoteTaintedMethodAccessSource() {
    this.asExpr().(MethodAccess).getMethod() instanceof RemoteTaintedMethod
  }

  override string getSourceType() { result = "network data source" }
}

private class RmiMethodParameterSource extends RemoteFlowSource {
  RmiMethodParameterSource() {
    exists(RemoteCallableMethod method |
      method.getAParameter() = this.asParameter() and
      (
        getType() instanceof PrimitiveType or
        getType() instanceof TypeString
      )
    )
  }

  override string getSourceType() { result = "RMI method parameter" }
}

private class JaxWsMethodParameterSource extends RemoteFlowSource {
  JaxWsMethodParameterSource() {
    exists(JaxWsEndpoint endpoint |
      endpoint.getARemoteMethod().getAParameter() = this.asParameter()
    )
  }

  override string getSourceType() { result = "Jax WS method parameter" }
}

private class JaxRsMethodParameterSource extends RemoteFlowSource {
  JaxRsMethodParameterSource() {
    exists(JaxRsResourceClass service |
      service.getAnInjectableCallable().getAParameter() = this.asParameter() or
      service.getAnInjectableField().getAnAccess() = this.asExpr()
    )
  }

  override string getSourceType() { result = "Jax Rs method parameter" }
}

private predicate variableStep(Expr tracked, VarAccess sink) {
  exists(VariableAssign def |
    def.getSource() = tracked and
    defUsePair(def, sink)
  )
}

private class ReverseDnsSource extends RemoteFlowSource {
  ReverseDnsSource() {
    // Try not to trigger on `localhost`.
    exists(MethodAccess m | m = this.asExpr() |
      m.getMethod() instanceof ReverseDNSMethod and
      not exists(MethodAccess l |
        (variableStep(l, m.getQualifier()) or l = m.getQualifier()) and
        l.getMethod().getName() = "getLocalHost"
      )
    )
  }

  override string getSourceType() { result = "reverse DNS lookup" }
}

private class MessageBodyReaderParameterSource extends RemoteFlowSource {
  MessageBodyReaderParameterSource() {
    exists(MessageBodyReaderRead m |
      m.getParameter(4) = this.asParameter() or
      m.getParameter(5) = this.asParameter()
    )
  }

  override string getSourceType() { result = "MessageBodyReader parameter" }
}

private class SpringMultipartRequestSource extends RemoteFlowSource {
  SpringMultipartRequestSource() {
    exists(MethodAccess ma, Method m |
      ma = this.asExpr() and
      m = ma.getMethod() and
      m
          .getDeclaringType()
          .getASourceSupertype*()
          .hasQualifiedName("org.springframework.web.multipart", "MultipartRequest") and
      m.getName().matches("get%")
    )
  }

  override string getSourceType() { result = "Spring MultipartRequest getter" }
}

private class SpringMultipartFileSource extends RemoteFlowSource {
  SpringMultipartFileSource() {
    exists(MethodAccess ma, Method m |
      ma = this.asExpr() and
      m = ma.getMethod() and
      m
          .getDeclaringType()
          .getASourceSupertype*()
          .hasQualifiedName("org.springframework.web.multipart", "MultipartFile") and
      m.getName().matches("get%")
    )
  }

  override string getSourceType() { result = "Spring MultipartFile getter" }
}

private class SpringServletInputParameterSource extends RemoteFlowSource {
  SpringServletInputParameterSource() {
    this.asParameter() = any(SpringRequestMappingParameter srmp | srmp.isTaintedInput())
  }

  override string getSourceType() { result = "Spring servlet input parameter" }
}

private class GuiceRequestParameterSource extends RemoteFlowSource {
  GuiceRequestParameterSource() {
    exists(GuiceRequestParametersAnnotation a |
      a = this.asParameter().getAnAnnotation() or
      a = this.asExpr().(FieldRead).getField().getAnAnnotation()
    )
  }

  override string getSourceType() { result = "Guice request parameter" }
}

private class Struts2ActionSupportClassFieldReadSource extends RemoteFlowSource {
  Struts2ActionSupportClassFieldReadSource() {
    exists(Struts2ActionSupportClass c |
      c.getASetterMethod().getField() = this.asExpr().(FieldRead).getField()
    )
  }

  override string getSourceType() { result = "Struts2 ActionSupport field" }
}

private class ThriftIfaceParameterSource extends RemoteFlowSource {
  ThriftIfaceParameterSource() {
    exists(ThriftIface i | i.getAnImplementingMethod().getAParameter() = this.asParameter())
  }

  override string getSourceType() { result = "Thrift Iface parameter" }
}

private class WebSocketMessageParameterSource extends RemoteFlowSource {
  WebSocketMessageParameterSource() {
    exists(WebsocketOnText t | t.getParameter(1) = this.asParameter())
  }

  override string getSourceType() { result = "Websocket onText parameter" }
}

/** Class for `tainted` user input. */
abstract class UserInput extends DataFlow::Node { }

/**
 * DEPRECATED: Use `RemoteFlowSource` instead.
 *
 * Input that may be controlled by a remote user.
 */
deprecated class RemoteUserInput extends UserInput {
  RemoteUserInput() { this instanceof RemoteFlowSource }
}

/** A node with input that may be controlled by a local user. */
abstract class LocalUserInput extends UserInput { }

/**
 * A node with input from the local environment, such as files, standard in,
 * environment variables, and main method parameters.
 */
class EnvInput extends LocalUserInput {
  EnvInput() {
    // Parameters to a main method.
    exists(MainMethod main | this.asParameter() = main.getParameter(0))
    or
    // Args4j arguments.
    exists(Field f | this.asExpr() = f.getAnAccess() |
      f.getAnAnnotation().getType().getQualifiedName() = "org.kohsuke.args4j.Argument"
    )
    or
    // Results from various specific methods.
    this.asExpr().(MethodAccess).getMethod() instanceof EnvTaintedMethod
    or
    // Access to `System.in`.
    exists(Field f | this.asExpr() = f.getAnAccess() | f instanceof SystemIn)
    or
    // Access to files.
    this
        .asExpr()
        .(ConstructorCall)
        .getConstructedType()
        .hasQualifiedName("java.io", "FileInputStream")
  }
}

/** A node with input from a database. */
class DatabaseInput extends LocalUserInput {
  DatabaseInput() { this.asExpr().(MethodAccess).getMethod() instanceof ResultSetGetStringMethod }
}

private class RemoteTaintedMethod extends Method {
  RemoteTaintedMethod() {
    this instanceof ServletRequestGetParameterMethod or
    this instanceof ServletRequestGetParameterMapMethod or
    this instanceof ServletRequestGetParameterNamesMethod or
    this instanceof HttpServletRequestGetQueryStringMethod or
    this instanceof HttpServletRequestGetHeaderMethod or
    this instanceof HttpServletRequestGetPathMethod or
    this instanceof HttpServletRequestGetHeadersMethod or
    this instanceof HttpServletRequestGetHeaderNamesMethod or
    this instanceof HttpServletRequestGetRequestURIMethod or
    this instanceof HttpServletRequestGetRequestURLMethod or
    this instanceof HttpServletRequestGetRemoteUserMethod or
    this instanceof SpringWebRequestGetMethod or
    this instanceof SpringRestTemplateResponseEntityMethod or
    this instanceof ServletRequestGetBodyMethod or
    this instanceof CookieGetValueMethod or
    this instanceof CookieGetNameMethod or
    this instanceof CookieGetCommentMethod or
    this instanceof URLConnectionGetInputStreamMethod or
    this instanceof SocketGetInputStreamMethod or
    this instanceof ApacheHttpGetParams or
    this instanceof ApacheHttpEntityGetContent or
    // In the setting of Android we assume that XML has been transmitted over
    // the network, so may be tainted.
    this instanceof XmlPullGetMethod or
    this instanceof XmlAttrSetGetMethod or
    // The current URL in a browser may be untrusted or uncontrolled.
    this instanceof WebViewGetUrlMethod
  }
}

private class SpringWebRequestGetMethod extends Method {
  SpringWebRequestGetMethod() {
    exists(SpringWebRequest swr | this = swr.getAMethod() |
      this.hasName("getDescription") or
      this.hasName("getHeader") or
      this.hasName("getHeaderNames") or
      this.hasName("getHeaderValues") or
      this.hasName("getParameter") or
      this.hasName("getParameterMap") or
      this.hasName("getParameterNames") or
      this.hasName("getParameterValues")
      // TODO consider getRemoteUser
    )
  }
}

private class EnvTaintedMethod extends Method {
  EnvTaintedMethod() {
    this instanceof MethodSystemGetenv or
    this instanceof PropertiesGetPropertyMethod or
    this instanceof MethodSystemGetProperty
  }
}

/** The type `java.net.InetAddress`. */
class TypeInetAddr extends RefType {
  TypeInetAddr() { this.getQualifiedName() = "java.net.InetAddress" }
}

/** A reverse DNS method. */
class ReverseDNSMethod extends Method {
  ReverseDNSMethod() {
    this.getDeclaringType() instanceof TypeInetAddr and
    (
      this.getName() = "getHostName" or
      this.getName() = "getCanonicalHostName"
    )
  }
}

/** Android `Intent` that may have come from a hostile application. */
class AndroidIntentInput extends DataFlow::Node {
  AndroidIntentInput() {
    exists(MethodAccess ma, AndroidGetIntentMethod m |
      ma.getMethod().overrides*(m) and
      this.asExpr() = ma
    )
    or
    exists(Method m, AndroidReceiveIntentMethod rI |
      m.overrides*(rI) and
      this.asParameter() = m.getParameter(1)
    )
  }
}
