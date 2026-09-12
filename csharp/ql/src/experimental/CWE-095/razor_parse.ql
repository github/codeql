/**
 * @name Server-Side Template Injection in RazorEngine
 * @description User-controlled data may be evaluated, leading to arbitrary code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id csharp/razor-injection
 * @tags security
 */

import csharp
import semmle.code.csharp.frameworks.microsoft.AspNetCore
import semmle.code.csharp.dataflow.TaintTracking
import semmle.code.csharp.dataflow.flowsources.Remote
import semmle.code.csharp.frameworks.system.web.Mvc as Mvc
import DataFlow::PathGraph

/*
 * The offending method is Parse from RazorEngine.Razor.
 */

class RazorEngineClass extends Class {
  RazorEngineClass() { this.hasQualifiedName("RazorEngine.Razor") }

  Method getParseMethod() {
    result.getDeclaringType() = this and
    result.hasName("Parse")
  }
}

class Controller extends Class {
  Controller() {
    this instanceof Mvc::Controller
    or
    this instanceof MicrosoftAspNetCoreMvcController
  }

  Method getAPostActionMethod() {
    result = this.(Mvc::Controller).getAPostActionMethod()
    or
    result = this.(MicrosoftAspNetCoreMvcController).getAnActionMethod() and
    result.getAnAttribute() instanceof MicrosoftAspNetCoreMvcHttpPostAttribute
  }
}

/*
 * TaintTracking configuration that will track any public method in MVC controllers that takes arguments that are parsed later by RazorEngine.Parse.
 */

class RazorEngineInjection extends TaintTracking::Configuration {
  RazorEngineInjection() { this = "RazorEngineInjection" }

  override predicate isSource(DataFlow::Node source) {
    source.asParameter() = any(Controller c).getAPostActionMethod().getAParameter()
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(RazorEngineClass rec, MethodCall mc |
      mc.getTarget() = rec.getParseMethod() and
      sink.asExpr() = mc.getArgument(0)
    )
  }
}

from RazorEngineInjection cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink,
  "Server-Side Template Injection in RazorEngine leads to Remote Code Execution"
