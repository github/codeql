import java
import semmle.code.java.Serializability
import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.internal.DataFlowForSerializability

/** The method `parseAs` in `com.google.api.client.http.HttpResponse`. */
private class ParseAsMethod extends Method {
  ParseAsMethod() {
    this.getDeclaringType().hasQualifiedName("com.google.api.client.http", "HttpResponse") and
    this.hasName("parseAs")
  }
}

private class TypeLiteralToParseAsFlowConfiguration extends DataFlowForSerializability::Configuration {
  TypeLiteralToParseAsFlowConfiguration() {
    this = "GoogleHttpClientApi::TypeLiteralToParseAsFlowConfiguration"
  }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof TypeLiteral }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getAnArgument() = sink.asExpr() and
      ma.getMethod() instanceof ParseAsMethod
    )
  }

  TypeLiteral getSourceWithFlowToParseAs() { this.hasFlow(DataFlow::exprNode(result), _) }
}

/** A field that is deserialized by `HttpResponse.parseAs`. */
class HttpResponseParseAsDeserializableField extends DeserializableField {
  HttpResponseParseAsDeserializableField() {
    exists(RefType decltype, TypeLiteralToParseAsFlowConfiguration conf |
      decltype = this.getDeclaringType() and
      conf.getSourceWithFlowToParseAs().getReferencedType() = decltype and
      decltype.fromSource()
    )
  }
}
