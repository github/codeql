import semmle.code.java.frameworks.Kryo
import semmle.code.java.frameworks.XStream
import semmle.code.java.frameworks.SnakeYaml
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

predicate unsafeDeserialization(MethodAccess ma, Expr sink) {
  exists(Method m | m = ma.getMethod() |
    m instanceof ObjectInputStreamReadObjectMethod and
    sink = ma.getQualifier() and
    not exists(DataFlow::ExprNode node |
      node.getExpr() = sink and
      node
          .getTypeBound()
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
  )
}

class UnsafeDeserializationSink extends DataFlow::ExprNode {
  UnsafeDeserializationSink() { unsafeDeserialization(_, this.getExpr()) }

  MethodAccess getMethodAccess() { unsafeDeserialization(result, this.getExpr()) }
}
