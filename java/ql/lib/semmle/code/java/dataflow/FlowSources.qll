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
import semmle.code.java.frameworks.android.ExternalStorage
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
private import codeql.threatmodels.ThreatModels

/**
 * A data flow source.
 */
abstract class SourceNode extends DataFlow::Node {
  /**
   * Gets a string that represents the source kind with respect to threat modeling.
   */
  abstract string getThreatModel();
}

/**
 * A class of data flow sources that respects the
 * current threat model configuration.
 */
class ThreatModelFlowSource extends DataFlow::Node {
  ThreatModelFlowSource() {
    exists(string kind |
      // Specific threat model.
      currentThreatModel(kind) and
      (this.(SourceNode).getThreatModel() = kind or sourceNode(this, kind))
    )
  }
}

/** A data flow source of remote user input. */
abstract class RemoteFlowSource extends SourceNode {
  /** Gets a string that describes the type of this remote flow source. */
  abstract string getSourceType();

  override string getThreatModel() { result = "remote" }
}

/**
 * A module for importing frameworks that define flow sources.
 */
private module FlowSources {
  private import semmle.code.java.frameworks.hudson.Hudson
  private import semmle.code.java.frameworks.stapler.Stapler
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
    exists(MethodCall m | m = this.asExpr() |
      m.getMethod() instanceof ReverseDnsMethod and
      not exists(MethodCall l |
        (variableStep(l, m.getQualifier()) or l = m.getQualifier()) and
        (l.getMethod().getName() = "getLocalHost" or l.getMethod().getName() = "getLoopbackAddress")
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

private class Struts2ActionSupportClassFieldSource extends RemoteFlowSource {
  Struts2ActionSupportClassFieldSource() {
    this.(DataFlow::FieldValueNode).getField() =
      any(Struts2ActionSupportClass c).getASetterMethod().getField()
  }

  override string getSourceType() { result = "Struts2 ActionSupport field" }
}

private class ThriftIfaceParameterSource extends RemoteFlowSource {
  ThriftIfaceParameterSource() {
    exists(ThriftIface i | i.getAnImplementingMethod().getAParameter() = this.asParameter())
  }

  override string getSourceType() { result = "Thrift Iface parameter" }
}

private class AndroidExternalStorageSource extends RemoteFlowSource {
  AndroidExternalStorageSource() { androidExternalStorageSource(this) }

  override string getSourceType() { result = "Android external storage" }
}

/** Class for `tainted` user input. */
abstract class UserInput extends SourceNode { }

/**
 * Input that may be controlled by a remote user.
 */
private class RemoteUserInput extends UserInput instanceof RemoteFlowSource {
  override string getThreatModel() { result = RemoteFlowSource.super.getThreatModel() }
}

/** A node with input that may be controlled by a local user. */
abstract class LocalUserInput extends UserInput {
  override string getThreatModel() { result = "local" }
}

/**
 * DEPRECATED: Use the threat models feature.
 * That is, use `ThreatModelFlowSource` as the class of nodes for sources
 * and set up the threat model configuration to filter source nodes.
 * Alternatively, use `getThreatModel` to filter nodes to create the
 * class of nodes you need.
 *
 * A node with input from the local environment, such as files, standard in,
 * environment variables, and main method parameters.
 */
deprecated class EnvInput extends DataFlow::Node {
  EnvInput() {
    this instanceof EnvironmentInput or
    this instanceof CliInput or
    this instanceof FileInput
  }
}

/**
 * A node with input from the local environment, such as
 * environment variables.
 */
private class EnvironmentInput extends LocalUserInput {
  EnvironmentInput() { sourceNode(this, "environment") }

  override string getThreatModel() { result = "environment" }
}

/**
 * A node with input from the command line, such as standard in
 * and main method parameters.
 */
private class CliInput extends LocalUserInput {
  CliInput() {
    // Parameters to a main method.
    exists(MainMethod main | this.asParameter() = main.getParameter(0))
    or
    // Args4j arguments.
    exists(Field f | this.asExpr() = f.getAnAccess() |
      f.getAnAnnotation().getType().getQualifiedName() = "org.kohsuke.args4j.Argument"
    )
    or
    // Access to `System.in`.
    exists(Field f | this.asExpr() = f.getAnAccess() | f instanceof SystemIn)
  }

  override string getThreatModel() { result = "commandargs" }
}

/**
 * A node with input from the local environment, such as files.
 */
private class FileInput extends LocalUserInput {
  FileInput() {
    // Access to files.
    sourceNode(this, "file")
  }

  override string getThreatModel() { result = "file" }
}

/**
 * DEPRECATED: Use the threat models feature.
 * That is, use `ThreatModelFlowSource` as the class of nodes for sources
 * and set up the threat model configuration to filter source nodes.
 * Alternatively, use `getThreatModel` to filter nodes to create the
 * class of nodes you need.
 *
 * A node with input from a database.
 */
deprecated class DatabaseInput = DbInput;

/**
 * A node with input from a database.
 */
private class DbInput extends LocalUserInput {
  DbInput() { sourceNode(this, "database") }

  override string getThreatModel() { result = "database" }
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
  TypeInetAddr() { this.hasQualifiedName("java.net", "InetAddress") }
}

/** A reverse DNS method. */
class ReverseDnsMethod extends Method {
  ReverseDnsMethod() {
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
    exists(MethodCall ma, AndroidGetIntentMethod m |
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
    or
    exists(Method m, AndroidServiceIntentMethod sI |
      m.overrides*(sI) and
      this.asParameter() = m.getParameter(0) and
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
  cached
  OnActivityResultIntentSource() { this.isRemoteSource() }

  override string getSourceType() { result = "Android onActivityResult incoming Intent" }
}

/**
 * A parameter of a method annotated with the `android.webkit.JavascriptInterface` annotation.
 */
class AndroidJavascriptInterfaceMethodParameter extends RemoteFlowSource {
  AndroidJavascriptInterfaceMethodParameter() {
    exists(JavascriptInterfaceMethod m | this.asParameter() = m.getAParameter())
  }

  override string getSourceType() {
    result = "Parameter of method with JavascriptInterface annotation"
  }
}

/**
 * A data flow source node for an API, which should be considered
 * supported for a modeling perspective.
 */
abstract class ApiSourceNode extends DataFlow::Node { }

private class AddSourceNodes extends ApiSourceNode instanceof SourceNode { }

/**
 * Add all source models as data sources.
 */
private class ApiSourceNodeExternal extends ApiSourceNode {
  ApiSourceNodeExternal() { sourceNode(this, _) }
}
