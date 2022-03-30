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
import semmle.code.java.frameworks.android.Android
import semmle.code.java.frameworks.android.OnActivityResultSource
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.frameworks.play.Play
import semmle.code.java.frameworks.spring.SpringWeb
import semmle.code.java.frameworks.spring.SpringController
import semmle.code.java.frameworks.spring.SpringWebClient
import semmle.code.java.frameworks.Guice
import semmle.code.java.frameworks.struts.StrutsActions
import semmle.code.java.frameworks.Thrift
import semmle.code.java.frameworks.javaee.jsf.JSFRenderer
private import semmle.code.java.dataflow.ExternalFlow

/** A data flow source of remote user input. */
abstract class RemoteFlowSource extends DataFlow::Node {
  /** Gets a string that describes the type of this remote flow source. */
  abstract string getSourceType();
}

private class ExternalRemoteFlowSource extends RemoteFlowSource {
  ExternalRemoteFlowSource() { sourceNode(this, "remote") }

  override string getSourceType() { result = "external" }
}

private class RmiMethodParameterSource extends RemoteFlowSource {
  RmiMethodParameterSource() {
    exists(RemoteCallableMethod method |
      method.getAParameter() = this.asParameter() and
      (
        this.getType() instanceof PrimitiveType or
        this.getType() instanceof TypeString
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

private class PlayParameterSource extends RemoteFlowSource {
  PlayParameterSource() { this.asParameter() instanceof PlayActionMethodQueryParameter }

  override string getSourceType() { result = "Play Query Parameters" }
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

/** Class for `tainted` user input. */
abstract class UserInput extends DataFlow::Node { }

/**
 * Input that may be controlled by a remote user.
 */
private class RemoteUserInput extends UserInput {
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
    this.asExpr().(MethodAccess).getMethod() instanceof EnvReadMethod
    or
    // Access to `System.in`.
    exists(Field f | this.asExpr() = f.getAnAccess() | f instanceof SystemIn)
    or
    // Access to files.
    this.asExpr()
        .(ConstructorCall)
        .getConstructedType()
        .hasQualifiedName("java.io", "FileInputStream")
  }
}

/** A node with input from a database. */
class DatabaseInput extends LocalUserInput {
  DatabaseInput() { this.asExpr().(MethodAccess).getMethod() instanceof ResultSetGetStringMethod }
}

/** A method that reads from the environment, such as `System.getProperty` or `System.getenv`. */
class EnvReadMethod extends Method {
  EnvReadMethod() {
    this instanceof MethodSystemGetenv or
    this instanceof PropertiesGetPropertyMethod or
    this instanceof PropertiesGetMethod or
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
  Type receiverType;

  AndroidIntentInput() {
    exists(MethodAccess ma, AndroidGetIntentMethod m |
      ma.getMethod().overrides*(m) and
      this.asExpr() = ma and
      receiverType = ma.getReceiverType()
    )
    or
    exists(Method m, AndroidReceiveIntentMethod rI |
      m.overrides*(rI) and
      this.asParameter() = m.getParameter(1) and
      receiverType = m.getDeclaringType()
    )
  }
}

/** Exported Android `Intent` that may have come from a hostile application. */
class ExportedAndroidIntentInput extends RemoteFlowSource, AndroidIntentInput {
  ExportedAndroidIntentInput() { receiverType.(ExportableAndroidComponent).isExported() }

  override string getSourceType() { result = "Exported Android intent source" }
}

/** A parameter of an entry-point method declared in a `ContentProvider` class. */
class AndroidContentProviderInput extends DataFlow::Node {
  AndroidContentProvider declaringType;

  AndroidContentProviderInput() {
    sourceNode(this, "contentprovider") and
    this.getEnclosingCallable().getDeclaringType() = declaringType
  }
}

/** A parameter of an entry-point method declared in an exported `ContentProvider` class. */
class ExportedAndroidContentProviderInput extends RemoteFlowSource, AndroidContentProviderInput {
  ExportedAndroidContentProviderInput() { declaringType.isExported() }

  override string getSourceType() { result = "Exported Android content provider source" }
}

/**
 * The data Intent parameter in the `onActivityResult` method in an Activity or Fragment that
 * calls `startActivityForResult` with an implicit Intent.
 */
class OnActivityResultIntentSource extends OnActivityResultIncomingIntent, RemoteFlowSource {
  OnActivityResultIntentSource() { this.isRemoteSource() }

  override string getSourceType() { result = "Android onActivityResult incoming Intent" }
}
