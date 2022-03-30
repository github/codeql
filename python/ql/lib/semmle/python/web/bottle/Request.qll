import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.External
import semmle.python.web.Http
import semmle.python.web.bottle.General

deprecated private Value theBottleRequestObject() { result = theBottleModule().attr("request") }

deprecated class BottleRequestKind extends TaintKind {
  BottleRequestKind() { this = "bottle.request" }

  override TaintKind getTaintOfAttribute(string name) {
    result instanceof BottleFormsDict and
    (name = "cookies" or name = "query" or name = "form")
    or
    result instanceof ExternalStringKind and
    (name = "query_string" or name = "url_args")
    or
    result.(DictKind).getValue() instanceof FileUpload and
    name = "files"
  }
}

deprecated private class RequestSource extends HttpRequestTaintSource {
  RequestSource() { this.(ControlFlowNode).pointsTo(theBottleRequestObject()) }

  override predicate isSourceOf(TaintKind kind) { kind instanceof BottleRequestKind }
}

deprecated class BottleFormsDict extends TaintKind {
  BottleFormsDict() { this = "bottle.FormsDict" }

  override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
    /* Cannot use `getTaintOfAttribute(name)` as it wouldn't bind `name` */
    exists(string name |
      fromnode = tonode.(AttrNode).getObject(name) and
      result instanceof ExternalStringKind
    |
      name != "get" and name != "getunicode" and name != "getall"
    )
  }

  override TaintKind getTaintOfMethodResult(string name) {
    (name = "get" or name = "getunicode") and
    result instanceof ExternalStringKind
    or
    name = "getall" and result.(SequenceKind).getItem() instanceof ExternalStringKind
  }
}

deprecated class FileUpload extends TaintKind {
  FileUpload() { this = "bottle.FileUpload" }

  override TaintKind getTaintOfAttribute(string name) {
    name = "filename" and result instanceof ExternalStringKind
    or
    name = "raw_filename" and result instanceof ExternalStringKind
    or
    name = "file" and result instanceof UntrustedFile
  }
}

deprecated class UntrustedFile extends TaintKind {
  UntrustedFile() { this = "Untrusted file" }
}

//
//   TO DO.. File uploads -- Should check about file uploads for other frameworks as well.
//  Move UntrustedFile to shared location
//
/** A parameter to a bottle request handler function */
deprecated class BottleRequestParameter extends HttpRequestTaintSource {
  BottleRequestParameter() {
    exists(BottleRoute route | route.getANamedArgument() = this.(ControlFlowNode).getNode())
  }

  override predicate isSourceOf(TaintKind kind) { kind instanceof ExternalStringKind }

  override string toString() { result = "bottle handler function argument" }
}
