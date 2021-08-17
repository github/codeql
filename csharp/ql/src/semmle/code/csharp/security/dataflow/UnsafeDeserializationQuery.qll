/**
 * Provides a taint-tracking configuration for reasoning about uncontrolled data
 * in calls to unsafe deserializers (XML, JSON, XAML).
 */

import csharp
private import semmle.code.csharp.serialization.Deserializers
private import semmle.code.csharp.dataflow.TaintTracking2
private import semmle.code.csharp.security.dataflow.flowsources.Remote

/**
 * A data flow source for unsafe deserialization vulnerabilities.
 */
abstract class Source extends DataFlow::Node { }

/**
 * A data flow sink for unsafe deserialization vulnerabilities.
 */
abstract class Sink extends DataFlow::Node { }

/**
 * A data flow sink for unsafe deserialization vulnerabilities to an instance method.
 */
abstract private class InstanceMethodSink extends Sink {
  InstanceMethodSink() {
    not exists(
      SafeConstructorTrackingConfig safeConstructorTracking, DataFlow::Node safeTypeUsage,
      MethodCall mc
    |
      safeConstructorTracking.hasFlow(_, safeTypeUsage) and
      mc.getQualifier() = safeTypeUsage.asExpr() and
      mc.getAnArgument() = this.asExpr()
    )
  }
}

/**
 * A data flow sink for unsafe deserialization vulnerabilities to a static method or constructor call.
 */
abstract private class ConstructorOrStaticMethodSink extends Sink { }

/**
 * A sanitizer for unsafe deserialization vulnerabilities.
 */
abstract class Sanitizer extends DataFlow::Node { }

private class RemoteSource extends Source {
  RemoteSource() { this instanceof RemoteFlowSource }
}

/**
 * User input to object method call deserialization flow tracking.
 */
class TaintToObjectMethodTrackingConfig extends TaintTracking::Configuration {
  TaintToObjectMethodTrackingConfig() { this = "TaintToObjectMethodTrackingConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof InstanceMethodSink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * User input to `JsonConvert` call deserialization flow tracking.
 */
class JsonConvertTrackingConfig extends TaintTracking::Configuration {
  JsonConvertTrackingConfig() { this = "JsonConvertTrackingConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof NewtonsoftJsonConvertDeserializeObjectMethodSink
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * Tracks unsafe `TypeNameHandling` setting to `JsonConvert` call
 */
class TypeNameTrackingConfig extends DataFlow::Configuration {
  TypeNameTrackingConfig() { this = "TypeNameTrackingConfig" }

  override predicate isSource(DataFlow::Node source) {
    (
      source.asExpr() instanceof MemberConstantAccess and
      source.getType() instanceof TypeNameHandlingEnum
      or
      source.asExpr() instanceof IntegerLiteral
    ) and
    source.asExpr().hasValue() and
    not source.asExpr().getValue() = "0"
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc, Method m, Expr expr |
      m = mc.getTarget() and
      (
        not mc.getArgument(0).hasValue() and
        m instanceof NewtonsoftJsonConvertClassDeserializeObjectMethod
      ) and
      expr = mc.getAnArgument() and
      sink.asExpr() = expr and
      expr.getType() instanceof JsonSerializerSettingsClass
    )
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    node1.asExpr() instanceof IntegerLiteral and
    node2.asExpr().(CastExpr).getExpr() = node1.asExpr()
    or
    node1.getType() instanceof TypeNameHandlingEnum and
    exists(PropertyWrite pw, Property p, Assignment a |
      a.getLValue() = pw and
      pw.getProperty() = p and
      p.getDeclaringType() instanceof JsonSerializerSettingsClass and
      p.hasName("TypeNameHandling") and
      (
        node1.asExpr() = a.getRValue() and
        node2.asExpr() = pw.getQualifier()
        or
        exists(ObjectInitializer oi |
          node1.asExpr() = oi.getAMemberInitializer().getRValue() and
          node2.asExpr() = oi
        )
      )
    )
  }
}

/**
 * User input to static method or constructor call deserialization flow tracking.
 */
class TaintToConstructorOrStaticMethodTrackingConfig extends TaintTracking::Configuration {
  TaintToConstructorOrStaticMethodTrackingConfig() {
    this = "TaintToConstructorOrStaticMethodTrackingConfig"
  }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ConstructorOrStaticMethodSink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * User input to instance type flow tracking.
 */
class TaintToObjectTypeTrackingConfig extends TaintTracking2::Configuration {
  TaintToObjectTypeTrackingConfig() { this = "TaintToObjectTypeTrackingConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget() instanceof UnsafeDeserializer and
      sink.asExpr() = mc.getQualifier()
    )
  }

  override predicate isAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(MethodCall mc, Method m |
      m = mc.getTarget() and
      m.getDeclaringType().hasQualifiedName("System.Type") and
      m.hasName("GetType") and
      m.isStatic() and
      n1.asExpr() = mc.getArgument(0) and
      n2.asExpr() = mc
    )
    or
    exists(ObjectCreation oc |
      n1.asExpr() = oc.getAnArgument() and
      n2.asExpr() = oc and
      oc.getObjectType() instanceof StrongTypeDeserializer
    )
  }
}

/**
 * Unsafe deserializer creation to usage tracking config.
 */
class WeakTypeCreationToUsageTrackingConfig extends TaintTracking2::Configuration {
  WeakTypeCreationToUsageTrackingConfig() { this = "DeserializerCreationToUsageTrackingConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(ObjectCreation oc |
      oc.getObjectType() instanceof WeakTypeDeserializer and
      source.asExpr() = oc
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget() instanceof UnsafeDeserializer and
      sink.asExpr() = mc.getQualifier()
    )
  }
}

/**
 * Safe deserializer creation to usage tracking config.
 */
abstract class SafeConstructorTrackingConfig extends TaintTracking2::Configuration {
  bindingset[this]
  SafeConstructorTrackingConfig() { any() }
}

/** BinaryFormatter */
private predicate isBinaryFormatterCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  (
    not mc.getArgument(0).hasValue() and
    (
      m instanceof BinaryFormatterDeserializeMethod
      or
      m instanceof BinaryFormatterUnsafeDeserializeMethod
      or
      m instanceof BinaryFormatterUnsafeDeserializeMethodResponseMethod
    )
  )
}

abstract private class BinaryFormatterSink extends InstanceMethodSink { }

private class BinaryFormatterDeserializeMethodSink extends BinaryFormatterSink {
  BinaryFormatterDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      isBinaryFormatterCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

/** SoapFormatter */
private predicate isSoapFormatterCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  m instanceof SoapFormatterDeserializeMethod and
  not mc.getArgument(0).hasValue()
}

abstract private class SoapFormatterSink extends InstanceMethodSink { }

private class SoapFormatterDeserializeMethodSink extends SoapFormatterSink {
  SoapFormatterDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      isSoapFormatterCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

/** ObjectStateFormatter */
private predicate isObjectStateFormatterCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  m instanceof ObjectStateFormatterDeserializeMethod and
  not mc.getArgument(0).hasValue()
}

abstract private class ObjectStateFormatterSink extends InstanceMethodSink { }

private class ObjectStateFormatterDeserializeMethodSink extends ObjectStateFormatterSink {
  ObjectStateFormatterDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      isObjectStateFormatterCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

/** NetDataContractSerializer */
private predicate isNetDataContractSerializerCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  (
    (
      m instanceof NetDataContractSerializerDeserializeMethod
      or
      m instanceof NetDataContractSerializerReadObjectMethod
    ) and
    not mc.getArgument(0).hasValue()
  )
}

abstract private class NetDataContractSerializerSink extends InstanceMethodSink { }

private class NetDataContractSerializerDeserializeMethodSink extends NetDataContractSerializerSink {
  NetDataContractSerializerDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      isNetDataContractSerializerCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

/** DataContractJsonSerializer */
private predicate isDataContractJsonSerializerCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  m instanceof DataContractJsonSerializerReadObjectMethod and
  not mc.getArgument(0).hasValue()
}

abstract private class DataContractJsonSerializerSink extends InstanceMethodSink { }

private class DataContractJsonSerializerDeserializeMethodSink extends DataContractJsonSerializerSink {
  DataContractJsonSerializerDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      isDataContractJsonSerializerCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

private class DataContractJsonSafeConstructorTrackingConfiguration extends SafeConstructorTrackingConfig {
  DataContractJsonSafeConstructorTrackingConfiguration() {
    this = "DataContractJsonSafeConstructorTrackingConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    exists(ObjectCreation oc |
      oc = source.asExpr() and
      exists(Constructor c |
        c = oc.getTarget() and
        c.getDeclaringType() instanceof DataContractJsonSerializerClass and
        c.getNumberOfParameters() > 0 and
        oc.getArgument(0) instanceof TypeofExpr
      )
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc, Method m |
      isDataContractJsonSerializerCall(mc, m) and
      mc.getQualifier() = sink.asExpr()
    )
  }
}

/** JavaScriptSerializer */
private predicate isJavaScriptSerializerCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  (
    (
      m instanceof JavaScriptSerializerClassDeserializeMethod
      or
      m instanceof JavaScriptSerializerClassDeserializeObjectMethod
    ) and
    not mc.getArgument(0).hasValue()
  )
}

abstract private class JavaScriptSerializerSink extends InstanceMethodSink { }

private class JavaScriptSerializerDeserializeMethodSink extends JavaScriptSerializerSink {
  JavaScriptSerializerDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      isJavaScriptSerializerCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

private class JavaScriptSerializerSafeConstructorTrackingConfiguration extends SafeConstructorTrackingConfig {
  JavaScriptSerializerSafeConstructorTrackingConfiguration() {
    this = "JavaScriptSerializerSafeConstructorTrackingConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    exists(ObjectCreation oc |
      oc = source.asExpr() and
      exists(Constructor c |
        c = oc.getTarget() and
        c.getDeclaringType() instanceof JavaScriptSerializerClass and
        c.getNumberOfParameters() = 0
      )
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc, Method m |
      isJavaScriptSerializerCall(mc, m) and
      mc.getQualifier() = sink.asExpr()
    )
  }
}

/** XmlObjectSerializer */
private predicate isXmlObjectSerializerCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  m instanceof XmlObjectSerializerReadObjectMethod and
  not mc.getArgument(0).hasValue() and
  not mc.targetIsLocalInstance()
}

abstract private class XmlObjectSerializerSink extends InstanceMethodSink { }

private class XmlObjectSerializerDeserializeMethodSink extends XmlObjectSerializerSink {
  XmlObjectSerializerDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      isXmlObjectSerializerCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

private class XmlObjectSerializerDerivedConstructorTrackingConfiguration extends SafeConstructorTrackingConfig {
  XmlObjectSerializerDerivedConstructorTrackingConfiguration() {
    this = "XmlObjectSerializerDerivedConstructorTrackingConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    exists(ObjectCreation oc |
      oc = source.asExpr() and
      exists(ValueOrRefType declaringType |
        declaringType = oc.getTarget().getDeclaringType() and
        declaringType.getABaseType+() instanceof XmlObjectSerializerClass and
        not (
          declaringType instanceof DataContractSerializerClass or
          declaringType instanceof NetDataContractSerializerClass
        )
      )
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc, Method m |
      isXmlObjectSerializerCall(mc, m) and
      mc.getQualifier() = sink.asExpr()
    )
  }
}

/** XmlSerializer */
private predicate isXmlSerializerCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  m instanceof XmlSerializerDeserializeMethod and
  not mc.getArgument(0).hasValue()
}

abstract private class XmlSerializerSink extends InstanceMethodSink { }

private class XmlSerializerDeserializeMethodSink extends XmlSerializerSink {
  XmlSerializerDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      isXmlSerializerCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

private class XmlSerializerSafeConstructorTrackingConfiguration extends SafeConstructorTrackingConfig {
  XmlSerializerSafeConstructorTrackingConfiguration() {
    this = "XmlSerializerSafeConstructorTrackingConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    exists(ObjectCreation oc |
      oc = source.asExpr() and
      exists(Constructor c |
        c = oc.getTarget() and
        c.getDeclaringType() instanceof XmlSerializerClass and
        c.getNumberOfParameters() > 0 and
        oc.getArgument(0) instanceof TypeofExpr
      )
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc, Method m |
      isXmlSerializerCall(mc, m) and
      mc.getQualifier() = sink.asExpr()
    )
  }
}

/** DataContractSerializer */
private predicate isDataContractSerializerCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  (
    m instanceof DataContractSerializerReadObjectMethod
    or
    m instanceof XmlObjectSerializerReadObjectMethod
  ) and
  not mc.getArgument(0).hasValue()
}

abstract private class DataContractSerializerSink extends InstanceMethodSink { }

private class DataContractSerializerDeserializeMethodSink extends DataContractSerializerSink {
  DataContractSerializerDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      isDataContractSerializerCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

private class DataContractSerializerSafeConstructorTrackingConfiguration extends SafeConstructorTrackingConfig {
  DataContractSerializerSafeConstructorTrackingConfiguration() {
    this = "DataContractSerializerSafeConstructorTrackingConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    exists(ObjectCreation oc |
      oc = source.asExpr() and
      exists(Constructor c |
        c = oc.getTarget() and
        c.getDeclaringType() instanceof DataContractSerializerClass and
        c.getNumberOfParameters() > 0 and
        oc.getArgument(0) instanceof TypeofExpr
      )
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc, Method m |
      isDataContractSerializerCall(mc, m) and
      mc.getQualifier() = sink.asExpr()
    )
  }
}

/** XmlMessageFormatter */
private predicate isXmlMessageFormatterCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  m instanceof XmlMessageFormatterReadMethod and
  not mc.getArgument(0).hasValue()
}

abstract private class XmlMessageFormatterSink extends InstanceMethodSink { }

private class XmlMessageFormatterDeserializeMethodSink extends XmlMessageFormatterSink {
  XmlMessageFormatterDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      isXmlMessageFormatterCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

private class XmlMessageFormatterSafeConstructorTrackingConfiguration extends SafeConstructorTrackingConfig {
  XmlMessageFormatterSafeConstructorTrackingConfiguration() {
    this = "XmlMessageFormatterSafeConstructorTrackingConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    exists(ObjectCreation oc |
      oc = source.asExpr() and
      exists(Constructor c |
        c = oc.getTarget() and
        c.getDeclaringType() instanceof XmlMessageFormatterClass and
        c.getNumberOfParameters() > 0 and
        oc.getArgument(0) instanceof TypeofExpr
      )
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc, Method m |
      isXmlMessageFormatterCall(mc, m) and
      mc.getQualifier() = sink.asExpr()
    )
  }
}

/** LosFormatter */
private predicate isLosFormatterCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  m instanceof LosFormatterDeserializeMethod and
  not mc.getArgument(0).hasValue()
}

abstract private class LosFormatterSink extends InstanceMethodSink { }

private class LosFormatterDeserializeMethodSink extends LosFormatterSink {
  LosFormatterDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      isLosFormatterCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

/** fastJSON */
private predicate isFastJsonCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  m instanceof FastJsonClassToObjectMethod and
  not mc.getArgument(0).hasValue()
}

abstract private class FastJsonSink extends ConstructorOrStaticMethodSink { }

private class FastJsonDeserializeMethodSink extends FastJsonSink {
  FastJsonDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      isFastJsonCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

/** Activity */
private predicate isActivityCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  m instanceof ActivityLoadMethod and
  not mc.getArgument(0).hasValue()
}

abstract private class ActivitySink extends InstanceMethodSink { }

private class ActivityDeserializeMethodSink extends ActivitySink {
  ActivityDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      isActivityCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

/** ResourceReader */
private predicate isResourceReaderCall(Call mc, Constructor m) {
  m = mc.getTarget() and
  m instanceof ResourceReaderConstructor and
  not mc.getArgument(0).hasValue()
}

abstract private class ResourceReaderSink extends ConstructorOrStaticMethodSink { }

private class ResourceReaderDeserializeMethodSink extends ResourceReaderSink {
  ResourceReaderDeserializeMethodSink() {
    exists(Call mc, Constructor m |
      isResourceReaderCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

/** BinaryMessageFormatter */
private predicate isBinaryMessageFormatterCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  m instanceof BinaryMessageFormatterReadMethod and
  not mc.getArgument(0).hasValue()
}

abstract private class BinaryMessageFormatterSink extends InstanceMethodSink { }

private class BinaryMessageFormatterDeserializeMethodSink extends BinaryMessageFormatterSink {
  BinaryMessageFormatterDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      isBinaryMessageFormatterCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

/** XamlReader */
private predicate isXamlReaderCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  (
    m instanceof XamlReaderParseMethod
    or
    m instanceof XamlReaderLoadMethod
    or
    m instanceof XamlReaderLoadAsyncMethod
  ) and
  not mc.getArgument(0).hasValue()
}

abstract private class XamlReaderSink extends ConstructorOrStaticMethodSink { }

private class XamlReaderDeserializeMethodSink extends XamlReaderSink {
  XamlReaderDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      isXamlReaderCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

/** ProxyObject */
private predicate isProxyObjectCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  (
    m instanceof ProxyObjectDecodeValueMethod
    or
    m instanceof ProxyObjectDecodeSerializedObjectMethod
  ) and
  not mc.getArgument(0).hasValue()
}

abstract private class ProxyObjectSink extends InstanceMethodSink { }

private class ProxyObjectDeserializeMethodSink extends ProxyObjectSink {
  ProxyObjectDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      isProxyObjectCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

/** SweetJayson */
private predicate isSweetJaysonCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  m instanceof JaysonConverterToObjectMethod and
  not mc.getArgument(0).hasValue()
}

abstract private class SweetJaysonSink extends ConstructorOrStaticMethodSink { }

private class SweetJaysonDeserializeMethodSink extends SweetJaysonSink {
  SweetJaysonDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      isSweetJaysonCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

/** ServiceStack.Text.JsonSerializer */
abstract private class ServiceStackTextJsonSerializerSink extends ConstructorOrStaticMethodSink { }

private class ServiceStackTextJsonSerializerDeserializeMethodSink extends ServiceStackTextJsonSerializerSink {
  ServiceStackTextJsonSerializerDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      m = mc.getTarget() and
      (
        m instanceof ServiceStackTextJsonSerializerDeserializeFromStringMethod
        or
        m instanceof ServiceStackTextJsonSerializerDeserializeFromReaderMethod
        or
        m instanceof ServiceStackTextJsonSerializerDeserializeFromStreamMethod
      ) and
      exists(Expr arg |
        arg = mc.getAnArgument() and
        not arg.hasValue() and
        not arg instanceof TypeofExpr and
        this.asExpr() = arg
      )
    )
  }
}

/** ServiceStack.Text.TypeSerializer */
abstract private class ServiceStackTextTypeSerializerSink extends ConstructorOrStaticMethodSink { }

private class ServiceStackTextTypeSerializerDeserializeMethodSink extends ServiceStackTextTypeSerializerSink {
  ServiceStackTextTypeSerializerDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      m = mc.getTarget() and
      (
        m instanceof ServiceStackTextTypeSerializerDeserializeFromStringMethod
        or
        m instanceof ServiceStackTextTypeSerializerDeserializeFromReaderMethod
        or
        m instanceof ServiceStackTextTypeSerializerDeserializeFromStreamMethod
      ) and
      exists(Expr arg |
        arg = mc.getAnArgument() and
        not arg.hasValue() and
        not arg instanceof TypeofExpr and
        this.asExpr() = arg
      )
    )
  }
}

/** ServiceStack.Text.CsvSerializer */
abstract private class ServiceStackTextCsvSerializerSink extends ConstructorOrStaticMethodSink { }

private class ServiceStackTextCsvSerializerDeserializeMethodSink extends ServiceStackTextCsvSerializerSink {
  ServiceStackTextCsvSerializerDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      m = mc.getTarget() and
      (
        m instanceof ServiceStackTextCsvSerializerDeserializeFromStringMethod
        or
        m instanceof ServiceStackTextCsvSerializerDeserializeFromReaderMethod
        or
        m instanceof ServiceStackTextCsvSerializerDeserializeFromStreamMethod
      ) and
      exists(Expr arg |
        arg = mc.getAnArgument() and
        not arg.hasValue() and
        not arg instanceof TypeofExpr and
        this.asExpr() = arg
      )
    )
  }
}

/** ServiceStack.Text.XmlSerializer */
abstract private class ServiceStackTextXmlSerializerSink extends ConstructorOrStaticMethodSink { }

private class ServiceStackTextXmlSerializerDeserializeMethodSink extends ServiceStackTextXmlSerializerSink {
  ServiceStackTextXmlSerializerDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      m = mc.getTarget() and
      (
        m instanceof ServiceStackTextXmlSerializerDeserializeFromStringMethod
        or
        m instanceof ServiceStackTextXmlSerializerDeserializeFromReaderMethod
        or
        m instanceof ServiceStackTextXmlSerializerDeserializeFromStreamMethod
      ) and
      exists(Expr arg |
        arg = mc.getAnArgument() and
        not arg.hasValue() and
        not arg instanceof TypeofExpr and
        this.asExpr() = arg
      )
    )
  }
}

/** FsPickler */
private predicate isWeakTypeFsPicklerCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  (
    m instanceof FsPicklerSerializerClassUnPickleUntypedMethod or
    m instanceof FsPicklerSerializerClassDeserializeUntypedMethod or
    m instanceof FsPicklerSerializerClassDeserializeSequenceUntypedMethod
  ) and
  not mc.getArgument(0).hasValue()
}

abstract private class FsPicklerWeakTypeSink extends ConstructorOrStaticMethodSink { }

private class FsPicklerDeserializeWeakTypeMethodSink extends FsPicklerWeakTypeSink {
  FsPicklerDeserializeWeakTypeMethodSink() {
    exists(MethodCall mc, Method m |
      isWeakTypeFsPicklerCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

private predicate isStrongTypeFsPicklerCall(MethodCall mc, Method m) {
  m = mc.getTarget() and
  (
    m instanceof FsPicklerSerializerClassDeserializeMethod or
    m instanceof FsPicklerSerializerClassDeserializeSequenceMethod or
    m instanceof FsPicklerSerializerClasDeserializeSiftedMethod or
    m instanceof FsPicklerSerializerClassUnPickleMethod or
    m instanceof FsPicklerSerializerClassUnPickleSiftedMethod or
    m instanceof CsPicklerSerializerClassDeserializeMethod or
    m instanceof CsPicklerSerializerClassUnPickleMethod or
    m instanceof CsPicklerSerializerClassUnPickleOfStringMethod
  ) and
  not mc.getArgument(0).hasValue()
}

abstract private class FsPicklerStrongTypeSink extends InstanceMethodSink { }

private class FsPicklerDeserializeStrongTypeMethodSink extends FsPicklerStrongTypeSink {
  FsPicklerDeserializeStrongTypeMethodSink() {
    exists(MethodCall mc, Method m |
      isStrongTypeFsPicklerCall(mc, m) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

/** SharpSerializer */
private class SharpSerializerDeserializeMethodSink extends InstanceMethodSink {
  SharpSerializerDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      m = mc.getTarget() and
      (
        not mc.getArgument(0).hasValue() and
        m instanceof SharpSerializerClassDeserializeMethod
      ) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

/** YamlDotNet */
private class YamlDotNetDeserializerDeserializeMethodSink extends ConstructorOrStaticMethodSink {
  YamlDotNetDeserializerDeserializeMethodSink() {
    exists(MethodCall mc, Method m |
      m = mc.getTarget() and
      (
        not mc.getArgument(0).hasValue() and
        m instanceof YamlDotNetDeserializerClasseserializeMethod
      ) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

/** Newtonsoft.Json.JsonConvert */
private class NewtonsoftJsonConvertDeserializeObjectMethodSink extends ConstructorOrStaticMethodSink {
  NewtonsoftJsonConvertDeserializeObjectMethodSink() {
    exists(MethodCall mc, Method m |
      m = mc.getTarget() and
      (
        not mc.getArgument(0).hasValue() and
        m instanceof NewtonsoftJsonConvertClassDeserializeObjectMethod
      ) and
      this.asExpr() = mc.getArgument(0)
    )
  }
}
