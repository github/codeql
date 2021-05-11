/**
 * Provides classes and predicates for working with the Json-io framework.
 */

import java
import semmle.code.java.Maps

/**
 * The class `com.cedarsoftware.util.io.JsonReader`.
 */
class JsonReader extends RefType {
  JsonReader() { this.hasQualifiedName("com.cedarsoftware.util.io", "JsonReader") }
}

<<<<<<< HEAD
/** A method with the name `jsonToJava` declared in `com.cedarsoftware.util.io.JsonReader`. */
=======
/**
 * A json-io jsonToJava method. This is either `JsonReader.jsonToJava`.
 */
>>>>>>> 6738bf5186... Add UnsafeDeserialization sink
class JsonIoJsonToJavaMethod extends Method {
  JsonIoJsonToJavaMethod() {
    this.getDeclaringType() instanceof JsonReader and
    this.getName() = "jsonToJava"
  }
}

<<<<<<< HEAD
/** A method with the name `readObject` declared in `com.cedarsoftware.util.io.JsonReader`. */
=======
/**
 * A json-io readObject method. This is either `JsonReader.readObject`.
 */
>>>>>>> 6738bf5186... Add UnsafeDeserialization sink
class JsonIoReadObjectMethod extends Method {
  JsonIoReadObjectMethod() {
    this.getDeclaringType() instanceof JsonReader and
    this.getName() = "readObject"
  }
}

<<<<<<< HEAD
/**
 * A call to `Map.put` method, set the value of the `USE_MAPS` key to `true`.
 * 
 */
=======
>>>>>>> 6738bf5186... Add UnsafeDeserialization sink
class JsonIoSafeOptionalArgs extends MethodAccess {
  JsonIoSafeOptionalArgs() {
    this.getMethod().getDeclaringType().getASourceSupertype*() instanceof MapType and
    this.getMethod().hasName("put") and
    this.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "USE_MAPS" and
    this.getArgument(1).(CompileTimeConstantExpr).getBooleanValue() = true
  }
}
