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
import semmle.code.csharp.dataflow.TaintTracking
import DataFlow::PathGraph

/*
 * The offending method is Parse from RazorEngine.Razor.
 */

class RazorEngineClass extends Class {
  RazorEngineClass() { this.hasQualifiedName("RazorEngine.Razor") }

  Method getIsValidMethod() {
    result.getDeclaringType() = this and
    result.hasName("Parse")
  }
}

/*
 * We are only interested in ASP.NET MVC Controller classes
 */

class ControllerMVC extends Class {
  ControllerMVC() { this.hasQualifiedName("System.Web.Mvc", "Controller") }
}

/*
 * We filter by the ActionResult. I think this might not be needed.
 */

class ActionResultCall extends Call {
  ActionResultCall() {
    this.getEnclosingCallable().getAnnotatedReturnType().toString() = "ActionResult"
  }
}

/*
 * TaintTracking configuration that will track any public method in MVC controllers that takes arguments that are parsed later by RazorEngine.Parse.
 */

class RazorEngineInjection extends TaintTracking::Configuration {
  RazorEngineInjection() { this = "RazorEngineInjection" }

  override predicate isSource(DataFlow::Node source) {
    exists(ActionResultCall ar |
      ar.getEnclosingCallable().getDeclaringType().getABaseType() instanceof ControllerMVC and
      source.asParameter() = ar.getEnclosingCallable().getAParameter()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(RazorEngineClass rec, MethodCall mc |
      mc.getQualifiedDeclaration() = rec.getIsValidMethod() and
      sink.asExpr() = mc.getArgument(0)
    )
  }
}

from RazorEngineInjection cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink,
  "Server-Side Template Injection in RazorEngine leads to Remote Code Execution"
