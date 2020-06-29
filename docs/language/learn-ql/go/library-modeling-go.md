# Modeling Go libraries for CodeQL

CodeQL does not examine the source code for external packages. To track the flow of untrusted data through them you need to create a model of the library. Existing models can be found in `ql/src/semmle/go/frameworks/`, and a good source of examples. You should make a new file in that folder, named after the library.

## Sources

To mark a source of data that is controlled by an untrusted user, we create a class extending `UntrustedFlowSource::Range`. Inheritance and the characteristic predicate of the class should be used to specify exactly the dataflow node that introduces the data. Here is a short example from `Mux.qll`.

```go
  class RequestVars extends DataFlow::UntrustedFlowSource::Range, DataFlow::CallNode {
    RequestVars() { this.getTarget().hasQualifiedName("github.com/gorilla/mux", "Vars") }
  }
```

## Flow propagation

By default, it is assumed that all functions in libraries do not have any data flow. To indicate that a particular function does, you need to create a class extending `TaintTracking::FunctionModel`. Inheritance and the characteristic predicate of the class should specify the function and a method with the signature `override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp)` is need. The body should specify either `inp.isReceiver()` or `inp.isParameter(i)` for some `i`. It should also specify either `outp.isResult()` (only valid if there is only one return value), `outp.isResult(i)` or `outp.isParameter(i)` for some `i`. Here is an example from `Gin.qll`, slightly modified for brevity.

```go
private class ParamsGet extends TaintTracking::FunctionModel, Method {
  ParamsGet() { this.hasQualifiedName("github.com/gin-gonic/gin", "Params", "Get") }

  override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
    inp.isReceiver() and outp.isResult(0)
  }
}
```

## Sanitizers

It is not necessary to indicate that library methods are sanitizers - because the body is not analysed it is assumed that data does not flow through them. 

## Sinks

Data-flow sinks are specified by queries rather than by library models. What library models can do is to indicate when functions belong to special categories of function, which queries can use when specifying sinks. Categories representing these special categories are contained in `ql/src/semmle/go/Concepts.qll`. For example, a call to a logging mechanism should be indicated by making a class that extends `LoggerCall::Range`, as in the following example from `Glog.qll`.

```go
private class GlogCall extends LoggerCall::Range, DataFlow::CallNode {
  GlogCall() {
    exists(string fn |
      fn.regexpMatch("Error(|f|ln)")
      or
      fn.regexpMatch("Exit(|f|ln)")
      or
      fn.regexpMatch("Fatal(|f|ln)")
      or
      fn.regexpMatch("Info(|f|ln)")
      or
      fn.regexpMatch("Warning(|f|ln)")
    |
      this.getTarget().hasQualifiedName("github.com/golang/glog", fn)
      or
      this.getTarget().(Method).hasQualifiedName("github.com/golang/glog", "Verbose", fn)
    )
  }

  override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
}
```

Other useful classes in `ql/src/semmle/go/Concepts.qll` include ones for HTTP response writers, HTTP redirects and marshaling and unmarshaling functions.
