/**
 * Contains a summary for `URLSearchParams` and `URL` objects.
 *
 * For now, the `URLSearchParams` object is modeled as a `Map` object.
 */

private import javascript

DataFlow::SourceNode urlConstructorRef() { result = DataFlow::globalVarRef("URL") }

DataFlow::SourceNode urlSearchParamsConstructorRef() {
  result = DataFlow::globalVarRef("URLSearchParams")
}

class URLSearchParams extends DataFlow::SummarizedCallable {
  URLSearchParams() { this = "URLSearchParams" }

  override DataFlow::InvokeNode getACallSimple() {
    result = urlSearchParamsConstructorRef().getAnInstantiation()
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    // Taint the MapKey and MapValue so methods named 'get' and 'forEach' etc can extract the taint.
    // Also taint the object itself since it has a tainted toString() value
    input = "Argument[0]" and
    output = ["ReturnValue", "ReturnValue.MapKey", "ReturnValue.MapValue"] and
    preservesValue = false
  }
}

class GetAll extends DataFlow::SummarizedCallable {
  GetAll() { this = "getAll" }

  override DataFlow::MethodCallNode getACallSimple() {
    result.getMethodName() = "getAll" and result.getNumArgument() = 1
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[this].MapValue" and
    output = "ReturnValue.ArrayElement" and
    preservesValue = true
  }
}

class URLConstructor extends DataFlow::SummarizedCallable {
  URLConstructor() { this = "URL" }

  override DataFlow::InvokeNode getACallSimple() {
    result = urlConstructorRef().getAnInstantiation()
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[0]" and
    output =
      [
        "ReturnValue.Member[searchParams].MapKey",
        "ReturnValue.Member[searchParams].MapValue",
        "ReturnValue.Member[searchParams,hash,search]",
      ] and
    preservesValue = false
  }
}
