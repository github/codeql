deprecated module;

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources

/** Json string type data. */
abstract class JsonStringSource extends DataFlow::Node { }

/**
 * Convert to String using Gson library. *
 *
 * For example, in the method access `Gson.toJson(...)`,
 * the `Object` type data is converted to the `String` type data.
 */
private class GsonString extends JsonStringSource {
  GsonString() {
    exists(MethodCall ma, Method m | ma.getMethod() = m |
      m.hasName("toJson") and
      m.getDeclaringType().getAnAncestor().hasQualifiedName("com.google.gson", "Gson") and
      this.asExpr() = ma
    )
  }
}

/**
 * Convert to String using Fastjson library.
 *
 * For example, in the method access `JSON.toJSONString(...)`,
 * the `Object` type data is converted to the `String` type data.
 */
private class FastjsonString extends JsonStringSource {
  FastjsonString() {
    exists(MethodCall ma, Method m | ma.getMethod() = m |
      m.hasName("toJSONString") and
      m.getDeclaringType().getAnAncestor().hasQualifiedName("com.alibaba.fastjson", "JSON") and
      this.asExpr() = ma
    )
  }
}

/**
 * Convert to String using Jackson library.
 *
 * For example, in the method access `ObjectMapper.writeValueAsString(...)`,
 * the `Object` type data is converted to the `String` type data.
 */
private class JacksonString extends JsonStringSource {
  JacksonString() {
    exists(MethodCall ma, Method m | ma.getMethod() = m |
      m.hasName("writeValueAsString") and
      m.getDeclaringType()
          .getAnAncestor()
          .hasQualifiedName("com.fasterxml.jackson.databind", "ObjectMapper") and
      this.asExpr() = ma
    )
  }
}
