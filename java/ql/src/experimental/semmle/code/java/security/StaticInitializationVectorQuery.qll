import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.TaintTracking2

/**
 * Holds if `array` is initialized only with constants.
 */
private predicate initializedWithConstants(ArrayCreationExpr array) {
  // creating an array without an initializer, for example `new byte[8]`
  not exists(array.getInit())
  or
  // creating a multidimensional array with an initializer like `{ new byte[8], new byte[16] }`
  // This works around https://github.com/github/codeql/issues/6552 -- change me once there is
  // a better way to distinguish nested initializers that create zero-filled arrays
  // (e.g. `new byte[1]`) from those with an initializer list (`new byte[] { 1 }` or just `{ 1 }`)
  array.getInit().getAnInit().getAChildExpr() instanceof IntegerLiteral
  or
  // creating an array wit an initializer like `new byte[] { 1, 2 }`
  forex(Expr element | element = array.getInit().getAnInit() |
    element instanceof CompileTimeConstantExpr
  )
}

/**
 * An expression that creates a byte array that is initialized with constants.
 */
private class StaticByteArrayCreation extends ArrayCreationExpr {
  StaticByteArrayCreation() {
    this.getType().(Array).getElementType().(PrimitiveType).getName() = "byte" and
    initializedWithConstants(this)
  }
}

/** An expression that updates `array`. */
private class ArrayUpdate extends Expr {
  Expr array;

  ArrayUpdate() {
    exists(Assignment assign |
      assign = this and
      assign.getDest().(ArrayAccess).getArray() = array and
      not assign.getSource() instanceof CompileTimeConstantExpr
    )
    or
    exists(StaticMethodAccess ma |
      ma.getMethod().hasQualifiedName("java.lang", "System", "arraycopy") and
      ma = this and
      ma.getArgument(2) = array
    )
    or
    exists(MethodAccess ma, Method m |
      m = ma.getMethod() and
      ma = this and
      ma.getArgument(0) = array
    |
      m.hasQualifiedName("java.io", "InputStream", "read") or
      m.hasQualifiedName("java.nio", "ByteBuffer", "get") or
      m.hasQualifiedName("java.security", "SecureRandom", "nextBytes") or
      m.hasQualifiedName("java.util", "Random", "nextBytes")
    )
  }

  /** Returns the updated array. */
  Expr getArray() { result = array }
}

/**
 * A config that tracks dataflow from creating an array to an operation that updates it.
 */
private class ArrayUpdateConfig extends TaintTracking2::Configuration {
  ArrayUpdateConfig() { this = "ArrayUpdateConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof StaticByteArrayCreation
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(ArrayUpdate update | update.getArray() = sink.asExpr())
  }
}

/**
 * A source that defines an array that doesn't get updated.
 */
private class StaticInitializationVectorSource extends DataFlow::Node {
  StaticInitializationVectorSource() {
    exists(StaticByteArrayCreation array | array = this.asExpr() |
      not exists(ArrayUpdateConfig config | config.hasFlow(DataFlow2::exprNode(array), _))
    )
  }
}

/**
 * A config that tracks initialization of a cipher for encryption.
 */
private class EncryptionModeConfig extends TaintTracking2::Configuration {
  EncryptionModeConfig() { this = "EncryptionModeConfig" }

  override predicate isSource(DataFlow::Node source) {
    source
        .asExpr()
        .(FieldRead)
        .getField()
        .hasQualifiedName("javax.crypto", "Cipher", "ENCRYPT_MODE")
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m.hasQualifiedName("javax.crypto", "Cipher", "init") and
      ma.getArgument(0) = sink.asExpr()
    )
  }
}

/**
 * A sink that initializes a cipher for encryption with unsafe parameters.
 */
private class EncryptionInitializationSink extends DataFlow::Node {
  EncryptionInitializationSink() {
    exists(MethodAccess ma, Method m, EncryptionModeConfig config | m = ma.getMethod() |
      m.hasQualifiedName("javax.crypto", "Cipher", "init") and
      m.getParameterType(2)
          .(RefType)
          .hasQualifiedName("java.security.spec", "AlgorithmParameterSpec") and
      ma.getArgument(2) = this.asExpr() and
      config.hasFlowToExpr(ma.getArgument(0))
    )
  }
}

/**
 * Holds if `fromNode` to `toNode` is a dataflow step
 * that creates cipher's parameters with initialization vector.
 */
private predicate createInitializationVectorSpecStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(ConstructorCall cc, RefType type |
    cc = toNode.asExpr() and type = cc.getConstructedType()
  |
    type.hasQualifiedName("javax.crypto.spec", "IvParameterSpec") and
    cc.getArgument(0) = fromNode.asExpr()
    or
    type.hasQualifiedName("javax.crypto.spec", ["GCMParameterSpec", "RC2ParameterSpec"]) and
    cc.getArgument(1) = fromNode.asExpr()
    or
    type.hasQualifiedName("javax.crypto.spec", "RC5ParameterSpec") and
    cc.getArgument(3) = fromNode.asExpr()
  )
}

/**
 * A config that tracks dataflow to initializing a cipher with a static initialization vector.
 */
class StaticInitializationVectorConfig extends TaintTracking::Configuration {
  StaticInitializationVectorConfig() { this = "StaticInitializationVectorConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof StaticInitializationVectorSource
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof EncryptionInitializationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    createInitializationVectorSpecStep(fromNode, toNode)
  }
}
