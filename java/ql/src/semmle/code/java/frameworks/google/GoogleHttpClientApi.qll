import java
import semmle.code.java.Serializability
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.DataFlow5
private import semmle.code.java.dataflow.ExternalFlow

private class TypeLiteralToParseAsFlowConfiguration extends DataFlow5::Configuration {
  TypeLiteralToParseAsFlowConfiguration() {
    this = "GoogleHttpClientApi::TypeLiteralToParseAsFlowConfiguration"
  }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof TypeLiteral }

  override predicate isSink(DataFlow::Node sink) { sinkNode(sink, "google-parse-as") }

  TypeLiteral getSourceWithFlowToParseAs() { hasFlow(DataFlow::exprNode(result), _) }
}

private class ParseAsSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row = ["com.google.api.client.http;HttpResponse;false;parseAs;;;Argument;google-parse-as"]
  }
}

/** A field that is deserialized by `HttpResponse.parseAs`. */
class HttpResponseParseAsDeserializableField extends DeserializableField {
  HttpResponseParseAsDeserializableField() {
    exists(RefType decltype, TypeLiteralToParseAsFlowConfiguration conf |
      decltype = getDeclaringType() and
      conf.getSourceWithFlowToParseAs().getTypeName().getType() = decltype and
      decltype.fromSource()
    )
  }
}
