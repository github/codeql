/**
 * Provides classes and predicates for working with the Json-io framework.
 */

import java
import semmle.code.java.Maps
import semmle.code.java.dataflow.DataFlow

/**
 * The class `com.cedarsoftware.util.io.JsonReader`.
 */
class JsonIoJsonReader extends RefType {
  JsonIoJsonReader() { this.hasQualifiedName("com.cedarsoftware.util.io", "JsonReader") }
}

/** A method with the name `jsonToJava` declared in `com.cedarsoftware.util.io.JsonReader`. */
class JsonIoJsonToJavaMethod extends Method {
  JsonIoJsonToJavaMethod() {
    this.getDeclaringType() instanceof JsonIoJsonReader and
    this.getName() = "jsonToJava"
  }
}

/** A method with the name `readObject` declared in `com.cedarsoftware.util.io.JsonReader`. */
class JsonIoReadObjectMethod extends Method {
  JsonIoReadObjectMethod() {
    this.getDeclaringType() instanceof JsonIoJsonReader and
    this.getName() = "readObject"
  }
}

/**
 * A call to `Map.put` method, set the value of the `USE_MAPS` key to `true`.
 */
class JsonIoUseMapsSetter extends MethodCall {
  JsonIoUseMapsSetter() {
    this.getMethod().getDeclaringType().getASourceSupertype*() instanceof MapType and
    this.getMethod().hasName("put") and
    this.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "USE_MAPS" and
    this.getArgument(1).(CompileTimeConstantExpr).getBooleanValue() = true
  }
}

/**
 * A data flow configuration tracing flow from JsonIo safe settings.
 */
module SafeJsonIoConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    exists(MethodCall ma |
      ma instanceof JsonIoUseMapsSetter and
      src.asExpr() = ma.getQualifier()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma |
      ma.getMethod() instanceof JsonIoJsonToJavaMethod and
      sink.asExpr() = ma.getArgument(1)
    )
    or
    exists(ClassInstanceExpr cie |
      cie.getConstructor().getDeclaringType() instanceof JsonIoJsonReader and
      sink.asExpr() = cie.getArgument(1)
    )
  }
}

/** Tracks flow from JsonIo safe settings. */
module SafeJsonIoFlow = DataFlow::Global<SafeJsonIoConfig>;
