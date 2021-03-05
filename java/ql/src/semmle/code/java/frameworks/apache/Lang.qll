/** Definitions related to the Apache Commons Lang library. */

import java
private import semmle.code.java.dataflow.FlowSteps

/**
 * The class `org.apache.commons.lang.RandomStringUtils` or `org.apache.commons.lang3.RandomStringUtils`.
 */
class TypeApacheRandomStringUtils extends Class {
  TypeApacheRandomStringUtils() {
    this.hasQualifiedName(["org.apache.commons.lang", "org.apache.commons.lang3"],
      "RandomStringUtils")
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
    this.getDeclaringType()
        .hasQualifiedName(["org.apache.commons.lang", "org.apache.commons.lang3"],
          "SerializationUtils") and
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
    src = [0 .. getNumberOfParameters() - 1]
    or
    this.hasName([
        "clone", "nullToEmpty", "remove", "removeAll", "removeElement", "removeElements", "reverse",
        "shift", "shuffle", "subarray", "swap", "toArray", "toMap", "toObject", "toPrimitive",
        "toString", "toStringArray"
      ]) and
    src = 0
    or
    this.hasName("add") and
    this.getNumberOfParameters() = 2 and
    src = [0, 1]
    or
    this.hasName("add") and
    this.getNumberOfParameters() = 3 and
    src = [0, 2]
  }
}

private Type getAnExcludedParameterType() {
  result instanceof PrimitiveType or
  result.(RefType).hasQualifiedName("java.nio.charset", "Charset") or
  result.(RefType).hasQualifiedName("java.util", "Locale")
}

private class ApacheStringUtilsTaintPreservingMethod extends TaintPreservingCallable {
  ApacheStringUtilsTaintPreservingMethod() {
    this.getDeclaringType().hasQualifiedName("org.apache.commons.lang3", "StringUtils") and
    this.hasName([
        "abbreviate", "abbreviateMiddle", "appendIfMissing", "appendIfMissingIgnoreCase",
        "capitalize", "center", "chomp", "chop", "defaultIfBlank", "defaultIfEmpty",
        "defaultString", "deleteWhitespace", "difference", "firstNonBlank", "firstNonEmpty",
        "getBytes", "getCommonPrefix", "getDigits", "getIfBlank", "getIfEmpty", "join", "joinWith",
        "left", "leftPad", "lowerCase", "mid", "normalizeSpace", "overlay", "prependIfMissing",
        "prependIfMissingIgnoreCase", "remove", "removeAll", "removeEnd", "removeEndIgnoreCase",
        "removeFirst", "removeIgnoreCase", "removePattern", "removeStart", "removeStartIgnoreCase",
        "repeat", "replace", "replaceAll", "replaceChars", "replaceEach", "replaceEachRepeatedly",
        "replaceFirst", "replaceIgnoreCase", "replaceOnce", "replaceOnceIgnoreCase",
        "replacePattern", "reverse", "reverseDelimited", "right", "rightPad", "rotate", "split",
        "splitByCharacterType", "splitByCharacterTypeCamelCase", "splitByWholeSeparator",
        "splitByWholeSeparatorPreserveAllTokens", "splitPreserveAllTokens", "strip", "stripAccents",
        "stripAll", "stripEnd", "stripStart", "stripToEmpty", "stripToNull", "substring",
        "substringAfter", "substringAfterLast", "substringBefore", "substringBeforeLast",
        "substringBetween", "substringsBetween", "swapCase", "toCodePoints", "toEncodedString",
        "toRootLowerCase", "toRootUpperCase", "toString", "trim", "trimToEmpty", "trimToNull",
        "truncate", "uncapitalize", "unwrap", "upperCase", "valueOf", "wrap", "wrapIfMissing"
      ])
  }

  private predicate isExcludedParameter(int arg) {
    this.getName().matches(["appendIfMissing%", "prependIfMissing%"]) and arg = [2, 3]
    or
    this.getName().matches(["remove%", "split%", "substring%", "strip%"]) and
    arg = [1 .. getNumberOfParameters() - 1]
    or
    this.getName().matches(["chomp", "getBytes", "replace%", "toString", "unwrap"]) and arg = 1
    or
    this.getName() = "join" and
    // Exclude joins of types that render numerically (char[] and non-primitive arrays
    // are still considered taint sources)
    exists(PrimitiveType pt |
      this.getParameterType(arg).(Array).getComponentType() = pt and
      not pt instanceof CharacterType
    ) and
    arg = 0
  }

  override predicate returnsTaintFrom(int arg) {
    arg = [0 .. getNumberOfParameters() - 1] and
    not this.getParameterType(arg) = getAnExcludedParameterType() and
    not isExcludedParameter(arg)
  }
}
