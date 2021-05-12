import semmle.code.java.frameworks.Kryo
import semmle.code.java.frameworks.XStream
import semmle.code.java.frameworks.SnakeYaml
import semmle.code.java.frameworks.FastJson
import semmle.code.java.frameworks.JYaml
import semmle.code.java.frameworks.JsonIo
import semmle.code.java.frameworks.YamlBeans
import semmle.code.java.frameworks.Hessian
import semmle.code.java.frameworks.Castor
import semmle.code.java.frameworks.apache.Lang

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
}

class SafeJsonIo extends DataFlow2::Configuration {
  SafeJsonIo() { this = "UnsafeDeserialization::SafeJsonIo" }

  override predicate isSource(DataFlow::Node src) {
    exists(MethodAccess ma |
      ma instanceof JsonIoSafeOptionalArgs and
      src.asExpr() = ma.getQualifier()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof JsonIoJsonToJavaMethod and
      sink.asExpr() = ma.getArgument(1)
    )
    or
    exists(ClassInstanceExpr cie |
      cie.getConstructor().getDeclaringType() instanceof JsonReader and
      sink.asExpr() = cie.getArgument(1)
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
    ma.getMethod() instanceof JYamlUnSafeLoadMethod and
    sink = ma.getArgument(0)
    or
    ma.getMethod() instanceof JYamlConfigUnSafeLoadMethod and
    sink = ma.getArgument(0)
    or
    ma.getMethod() instanceof JsonIoJsonToJavaMethod and
    sink = ma.getArgument(0) and
    not exists(SafeJsonIo sji | sji.hasFlowToExpr(ma.getArgument(1)))
    or
    ma.getMethod() instanceof JsonIoReadObjectMethod and
    sink = ma.getQualifier()
    or
    ma.getMethod() instanceof YamlReaderReadMethod and sink = ma.getQualifier()
    or
    ma.getMethod() instanceof UnSafeHessianInputReadObjectMethod and sink = ma.getQualifier()
    or
    ma.getMethod() instanceof UnmarshalMethod and sink = ma.getAnArgument()
    or
    ma.getMethod() instanceof BurlapInputReadObjectMethod and sink = ma.getQualifier()
  )
}

class UnsafeDeserializationSink extends DataFlow::ExprNode {
  UnsafeDeserializationSink() { unsafeDeserialization(_, this.getExpr()) }

  MethodAccess getMethodAccess() { unsafeDeserialization(result, this.getExpr()) }
}
