import java
import semmle.code.java.Serializability
import semmle.code.java.dataflow.DataFlow

/** The method `parseAs` in `com.google.api.client.http.HttpResponse`. */
private class ParseAsMethod extends Method {
  ParseAsMethod() {
    this.getDeclaringType().hasQualifiedName("com.google.api.client.http", "HttpResponse") and
    this.hasName("parseAs")
  }
}

private module TypeLiteralToParseAsFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof TypeLiteral }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma |
      ma.getAnArgument() = sink.asExpr() and
      ma.getMethod() instanceof ParseAsMethod
    )
  }
}

private module TypeLiteralToParseAsFlow = DataFlow::Global<TypeLiteralToParseAsFlowConfig>;

private TypeLiteral getSourceWithFlowToParseAs() {
  TypeLiteralToParseAsFlow::flow(DataFlow::exprNode(result), _)
}

/** A field that is deserialized by `HttpResponse.parseAs`. */
class HttpResponseParseAsDeserializableField extends DeserializableField {
  HttpResponseParseAsDeserializableField() {
    exists(RefType decltype |
      decltype = this.getDeclaringType() and
      getSourceWithFlowToParseAs().getReferencedType() = decltype and
      decltype.fromSource()
    )
  }
}
