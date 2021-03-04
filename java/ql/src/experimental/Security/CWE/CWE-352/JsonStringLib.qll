import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

/** Json string type data */
abstract class JsonpStringSource extends DataFlow::Node { }

/** Convert to String using Gson library. */
private class GsonString extends JsonpStringSource {
  GsonString() {
    exists(MethodAccess ma, Method m | ma.getMethod() = m |
      m.hasName("toJson") and
      m.getDeclaringType().getASupertype*().hasQualifiedName("com.google.gson", "Gson") and
      this.asExpr() = ma
    )
  }
}

/** Convert to String using Fastjson library. */
private class FastjsonString extends JsonpStringSource {
  FastjsonString() {
    exists(MethodAccess ma, Method m | ma.getMethod() = m |
      m.hasName("toJSONString") and
      m.getDeclaringType().getASupertype*().hasQualifiedName("com.alibaba.fastjson", "JSON") and
      this.asExpr() = ma
    )
  }
}

/** Convert to String using Jackson library. */
private class JacksonString extends JsonpStringSource {
  JacksonString() {
    exists(MethodAccess ma, Method m | ma.getMethod() = m |
      m.hasName("writeValueAsString") and
      m.getDeclaringType()
          .getASupertype*()
          .hasQualifiedName("com.fasterxml.jackson.databind", "ObjectMapper") and
      this.asExpr() = ma
    )
  }
}
