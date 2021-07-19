import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Kryo
import semmle.code.java.frameworks.XStream
import semmle.code.java.frameworks.SnakeYaml
import semmle.code.java.frameworks.FastJson
import semmle.code.java.frameworks.JYaml
import semmle.code.java.frameworks.JsonIo
import semmle.code.java.frameworks.YamlBeans
import semmle.code.java.frameworks.HessianBurlap
import semmle.code.java.frameworks.Castor
import semmle.code.java.frameworks.JacksonQuery
import semmle.code.java.frameworks.apache.Lang
import semmle.code.java.Reflection

class ObjectInputStreamReadObjectMethod extends Method {
  ObjectInputStreamReadObjectMethod() {
    this.getDeclaringType().getASourceSupertype*().hasQualifiedName("java.io", "ObjectInputStream") and
    (this.hasName("readObject") or this.hasName("readUnshared"))
  }
}

class XMLDecoderReadObjectMethod extends Method {
  XMLDecoderReadObjectMethod() {
    this.getDeclaringType().hasQualifiedName("java.beans", "XMLDecoder") and
    this.hasName("readObject")
  }
}

class SafeXStream extends DataFlow2::Configuration {
  SafeXStream() { this = "UnsafeDeserialization::SafeXStream" }

  override predicate isSource(DataFlow::Node src) {
    any(XStreamEnableWhiteListing ma).getQualifier().(VarAccess).getVariable().getAnAccess() =
      src.asExpr()
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and
      ma.getMethod() instanceof XStreamReadObjectMethod
    )
  }
}

class SafeKryo extends DataFlow2::Configuration {
  SafeKryo() { this = "UnsafeDeserialization::SafeKryo" }

  override predicate isSource(DataFlow::Node src) {
    any(KryoEnableWhiteListing ma).getQualifier().(VarAccess).getVariable().getAnAccess() =
      src.asExpr()
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and
      ma.getMethod() instanceof KryoReadObjectMethod
    )
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    stepKryoPoolBuilderFactoryArgToConstructor(node1, node2) or
    stepKryoPoolRunMethodAccessQualifierToFunctionalArgument(node1, node2) or
    stepKryoPoolBuilderChainMethod(node1, node2) or
    stepKryoPoolBorrowMethod(node1, node2)
  }

  /**
   * Holds when a functional expression is used to create a `KryoPool.Builder`.
   * Eg. `new KryoPool.Builder(() -> new Kryo())`
   */
  private predicate stepKryoPoolBuilderFactoryArgToConstructor(
    DataFlow::Node node1, DataFlow::Node node2
  ) {
    exists(ConstructorCall cc, FunctionalExpr fe |
      cc.getConstructedType() instanceof KryoPoolBuilder and
      fe.asMethod().getBody().getAStmt().(ReturnStmt).getResult() = node1.asExpr() and
      node2.asExpr() = cc and
      cc.getArgument(0) = fe
    )
  }

  /**
   * Holds when a `KryoPool.run` is called to use a `Kryo` instance.
   * Eg. `pool.run(kryo -> ...)`
   */
  private predicate stepKryoPoolRunMethodAccessQualifierToFunctionalArgument(
    DataFlow::Node node1, DataFlow::Node node2
  ) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof KryoPoolRunMethod and
      node1.asExpr() = ma.getQualifier() and
      ma.getArgument(0).(FunctionalExpr).asMethod().getParameter(0) = node2.asParameter()
    )
  }

  /**
   * Holds when a `KryoPool.Builder` method is called fluently.
   */
  private predicate stepKryoPoolBuilderChainMethod(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof KryoPoolBuilderMethod and
      ma = node2.asExpr() and
      ma.getQualifier() = node1.asExpr()
    )
  }

  /**
   * Holds when a `KryoPool.borrow` method is called.
   */
  private predicate stepKryoPoolBorrowMethod(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodAccess ma |
      ma.getMethod() =
        any(Method m | m.getDeclaringType() instanceof KryoPool and m.hasName("borrow")) and
      node1.asExpr() = ma.getQualifier() and
      node2.asExpr() = ma
    )
  }
}

predicate unsafeDeserialization(MethodAccess ma, Expr sink) {
  exists(Method m | m = ma.getMethod() |
    m instanceof ObjectInputStreamReadObjectMethod and
    sink = ma.getQualifier() and
    not exists(DataFlow::ExprNode node |
      node.getExpr() = sink and
      node.getTypeBound()
          .(RefType)
          .hasQualifiedName("org.apache.commons.io.serialization", "ValidatingObjectInputStream")
    )
    or
    m instanceof XMLDecoderReadObjectMethod and
    sink = ma.getQualifier()
    or
    m instanceof XStreamReadObjectMethod and
    sink = ma.getAnArgument() and
    not exists(SafeXStream sxs | sxs.hasFlowToExpr(ma.getQualifier()))
    or
    m instanceof KryoReadObjectMethod and
    sink = ma.getAnArgument() and
    not exists(SafeKryo sk | sk.hasFlowToExpr(ma.getQualifier()))
    or
    m instanceof MethodApacheSerializationUtilsDeserialize and
    sink = ma.getArgument(0)
    or
    ma instanceof UnsafeSnakeYamlParse and
    sink = ma.getArgument(0)
    or
    ma.getMethod() instanceof FastJsonParseMethod and
    not fastJsonLooksSafe() and
    sink = ma.getArgument(0)
    or
    ma.getMethod() instanceof JYamlLoaderUnsafeLoadMethod and
    sink = ma.getArgument(0)
    or
    ma.getMethod() instanceof JsonIoJsonToJavaMethod and
    sink = ma.getArgument(0)
    or
    ma.getMethod() instanceof JsonIoReadObjectMethod and
    sink = ma.getQualifier()
    or
    ma.getMethod() instanceof YamlBeansReaderReadMethod and sink = ma.getQualifier()
    or
    ma.getMethod() instanceof UnsafeHessianInputReadObjectMethod and sink = ma.getQualifier()
    or
    ma.getMethod() instanceof CastorUnmarshalMethod and sink = ma.getAnArgument()
    or
    ma.getMethod() instanceof BurlapInputReadObjectMethod and sink = ma.getQualifier()
    or
    ma.getMethod() instanceof ObjectMapperReadMethod and
    sink = ma.getArgument(0) and
    (
      exists(UnsafeTypeConfig config | config.hasFlowToExpr(ma.getAnArgument()))
      or
      exists(EnableJacksonDefaultTypingConfig config | config.hasFlowToExpr(ma.getQualifier()))
      or
      hasArgumentWithUnsafeJacksonAnnotation(ma)
    ) and
    not exists(SafeObjectMapperConfig config | config.hasFlowToExpr(ma.getQualifier()))
  )
}

class UnsafeDeserializationSink extends DataFlow::ExprNode {
  UnsafeDeserializationSink() { unsafeDeserialization(_, this.getExpr()) }

  MethodAccess getMethodAccess() { unsafeDeserialization(result, this.getExpr()) }
}

class UnsafeDeserializationConfig extends TaintTracking::Configuration {
  UnsafeDeserializationConfig() { this = "UnsafeDeserializationConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeDeserializationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(ClassInstanceExpr cie |
      cie.getArgument(0) = pred.asExpr() and
      cie = succ.asExpr() and
      (
        cie.getConstructor().getDeclaringType() instanceof JsonIoJsonReader or
        cie.getConstructor().getDeclaringType() instanceof YamlBeansReader or
        cie.getConstructor().getDeclaringType().getASupertype*() instanceof UnsafeHessianInput or
        cie.getConstructor().getDeclaringType() instanceof BurlapInput
      )
    )
    or
    exists(MethodAccess ma |
      ma.getMethod() instanceof BurlapInputInitMethod and
      ma.getArgument(0) = pred.asExpr() and
      ma.getQualifier() = succ.asExpr()
    )
    or
    createJacksonJsonParserStep(pred, succ)
    or
    createJacksonTreeNodeStep(pred, succ)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(ClassInstanceExpr cie |
      cie.getConstructor().getDeclaringType() instanceof JsonIoJsonReader and
      cie = node.asExpr() and
      exists(SafeJsonIoConfig sji | sji.hasFlowToExpr(cie.getArgument(1)))
    )
    or
    exists(MethodAccess ma |
      ma.getMethod() instanceof JsonIoJsonToJavaMethod and
      ma.getArgument(0) = node.asExpr() and
      exists(SafeJsonIoConfig sji | sji.hasFlowToExpr(ma.getArgument(1)))
    )
  }
}
