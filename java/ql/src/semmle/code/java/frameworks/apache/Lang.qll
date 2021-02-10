/** Definitions related to the Apache Commons Lang library. */

import java
private import semmle.code.java.dataflow.FlowSteps

/** 
 * The class `org.apache.commons.lang.RandomStringUtils` or `org.apache.commons.lang3.RandomStringUtils`. 
 */
class TypeApacheRandomStringUtils extends Class {
  TypeApacheRandomStringUtils() {
    this.hasQualifiedName(["org.apache.commons.lang", "org.apache.commons.lang3"], "RandomStringUtils")
  }
}

/** 
 * The class `org.apache.commons.lang.ArrayUtils` or `org.apache.commons.lang3.ArrayUtils`. 
 */
class TypeApacheArrayUtils extends Class {
  TypeApacheArrayUtils() {
    hasQualifiedName(["org.apache.commons.lang", "org.apache.commons.lang3"], "ArrayUtils")
  }
}

/**
 * The method `deserialize` in either `org.apache.commons.lang.SerializationUtils`
 * or `org.apache.commons.lang3.SerializationUtils`.
 */
class MethodApacheSerializationUtilsDeserialize extends Method {
  MethodApacheSerializationUtilsDeserialize() {
    this.getDeclaringType().hasQualifiedName(["org.apache.commons.lang", "org.apache.commons.lang3"], "SerializationUtils") and
    this.hasName("deserialize")
  }
}

/**
 * A taint preserving method on `org.apache.commons.lang.ArrayUtils` or `org.apache.commons.lang3.ArrayUtils`
 */
private class ApacheLangArrayUtilsTaintPreservingMethod extends TaintPreservingCallable {
  ApacheLangArrayUtilsTaintPreservingMethod() {
    this.getDeclaringType() instanceof TypeApacheArrayUtils
  }

  override predicate returnsTaintFrom(int src) {
    this.hasName(["addAll", "addFirst"]) and
    src = [0 .. getNumberOfParameters()]
    or
    this.hasName(["clone", "nullToEmpty", "remove", "removeAll", "removeElement", "removeElements", "reverse", "shift", "shuffle", "subarray", "swap", "toArray", "toMap", "toObject", "toPrimitive", "toString", "toStringArray"]) and
    src = 0
    or
    this.hasName("add") and
    this.getNumberOfParameters() = 2 and
    src = [0,1,2]
    or
    this.hasName("add") and
    this.getNumberOfParameters() = 3 and
    src = [0, 2]
  }
}
