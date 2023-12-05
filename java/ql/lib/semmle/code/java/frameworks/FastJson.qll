/**
 * Provides classes and predicates for working with the FastJson framework.
 */

import java

/**
 * The class `com.alibaba.fastjson.JSON`.
 */
class FastJson extends RefType {
  FastJson() { this.hasQualifiedName("com.alibaba.fastjson", "JSON") }
}

/**
 * A FastJson parse method. This is either `JSON.parse` or `JSON.parseObject`.
 */
class FastJsonParseMethod extends Method {
  FastJsonParseMethod() {
    this.getDeclaringType() instanceof FastJson and
    this.hasName(["parse", "parseObject"])
  }
}

/**
 * A call to `ParserConfig.setSafeMode`.
 */
class FastJsonSetSafeMode extends MethodCall {
  FastJsonSetSafeMode() {
    exists(Method m |
      this.getMethod() = m and
      m.hasName("setSafeMode") and
      m.getDeclaringType().hasQualifiedName("com.alibaba.fastjson.parser", "ParserConfig")
    )
  }

  /** Gets the constant value passed to this call, if any. */
  boolean getMode() { result = this.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() }
}

/**
 * Holds if there is some call to `ParserConfig.setSafeMode` that does not
 * explicitly disable safe mode.
 */
predicate fastJsonLooksSafe() {
  exists(FastJsonSetSafeMode setsafe | not setsafe.getMode() = false)
}
