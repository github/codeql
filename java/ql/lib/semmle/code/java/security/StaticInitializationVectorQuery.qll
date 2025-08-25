/** Definitions for the Static Initialization Vector query. */

import java
import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.ExternalFlow

/**
 * Holds if `array` is initialized only with constants.
 */
private predicate initializedWithConstants(ArrayCreationExpr array) {
  // creating an array without an initializer, for example `new byte[8]`
  not exists(array.getInit())
  or
  initializedWithConstantsHelper(array.getInit())
}

private predicate initializedWithConstantsHelper(ArrayInit arInit) {
  forex(Expr element | element = arInit.getAnInit() |
    element instanceof CompileTimeConstantExpr
    or
    initializedWithConstantsHelper(element)
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
    exists(StaticMethodCall ma |
      ma.getMethod().hasQualifiedName("java.lang", "System", "arraycopy") and
      ma = this and
      ma.getArgument(2) = array
    )
    or
    exists(MethodCall ma, Method m |
      m = ma.getMethod() and
      ma = this and
      ma.getArgument(0) = array
    |
      m.getAnOverride*().hasQualifiedName("java.io", ["InputStream", "RandomAccessFile"], "read") or
      m.getAnOverride*().hasQualifiedName("java.io", "DataInput", "readFully") or
      m.hasQualifiedName("java.nio", "ByteBuffer", "get") or
      m.hasQualifiedName("java.security", "SecureRandom", "nextBytes") or
      m.hasQualifiedName("java.util", "Random", "nextBytes") or
      m.hasQualifiedName("java.util.zip", "Inflater", "inflate") or
      m.hasQualifiedName("io.netty.buffer", "ByteBuf", "readBytes") or
      m.getAnOverride*().hasQualifiedName("org.bouncycastle.crypto", "Digest", "doFinal")
    )
    or
    exists(MethodCall ma, Method m |
      m = ma.getMethod() and
      ma = this and
      ma.getArgument(1) = array
    |
      m.hasQualifiedName("org.apache.commons.io", "IOUtils", ["read", "readFully"]) or
      m.hasQualifiedName("io.netty.buffer", "ByteBuf", "getBytes") or
      m.hasQualifiedName("org.bouncycastle.crypto.generators",
        any(string s | s.matches("%BytesGenerator")), "generateBytes")
    )
  }

  /** Returns the updated array. */
  Expr getArray() { result = array }
}

private predicate arrayUpdateSrc(DataFlow::Node source) {
  source.asExpr() instanceof StaticByteArrayCreation
}

private predicate arrayUpdateSink(DataFlow::Node sink) {
  sink.asExpr() = any(ArrayUpdate upd).getArray()
}

private module ArrayUpdateFlowFwd = DataFlow::SimpleGlobal<arrayUpdateSrc/1>;

private module ArrayUpdateFlow = ArrayUpdateFlowFwd::Graph<arrayUpdateSink/1>;

private predicate arrayReachesUpdate(StaticByteArrayCreation array) {
  exists(ArrayUpdateFlow::PathNode src | src.isSource() and src.getNode().asExpr() = array)
}

/**
 * A source that defines an array that doesn't get updated.
 */
private class StaticInitializationVectorSource extends DataFlow::Node {
  StaticInitializationVectorSource() {
    exists(StaticByteArrayCreation array | array = this.asExpr() |
      not arrayReachesUpdate(array) and
      // Reduce FPs from utility methods that return an empty array in an exceptional case
      not exists(ReturnStmt ret |
        array.getADimension().(CompileTimeConstantExpr).getIntValue() = 0 and
        DataFlow::localExprFlow(array, ret.getResult())
      )
    )
  }
}

/**
 * A sink that initializes a cipher with unsafe parameters.
 */
private class EncryptionInitializationSink extends DataFlow::Node {
  EncryptionInitializationSink() { sinkNode(this, "encryption-iv") }
}

/**
 * A config that tracks dataflow to initializing a cipher with a static initialization vector.
 */
module StaticInitializationVectorConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof StaticInitializationVectorSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof EncryptionInitializationSink }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Tracks the flow from a static initialization vector to the initialization of a cipher */
module StaticInitializationVectorFlow = TaintTracking::Global<StaticInitializationVectorConfig>;
