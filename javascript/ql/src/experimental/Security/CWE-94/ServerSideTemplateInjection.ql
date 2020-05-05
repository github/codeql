/**
 * @name Server Side Template Injection
 * @description Rendering templates with unsanitized user input allows a malicious user arbitrary
 *              code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/code-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import javascript
import DataFlow

class ServerSideTemplateInjectionConfiguration extends TaintTracking::Configuration {
  ServerSideTemplateInjectionConfiguration() { this = "ServerSideTemplateInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ServerSideTemplateInjectionSink }
}

abstract class ServerSideTemplateInjectionSink extends DataFlow::Node { }

class SSTIPugSink extends ServerSideTemplateInjectionSink {
  SSTIPugSink() {
    exists(CallNode compile, ModuleImportNode renderImport |
      renderImport = moduleImport(["pug", "jade"]) and
      (
        compile = renderImport.getAMemberCall("compile") and
        or
        compile = renderImport.getAMemberCall("render")
      ) and
      this = compile.getArgument(0)
    )
  }
}

class SSTIDotSink extends ServerSideTemplateInjectionSink {
  SSTIDotSink() {
    exists(CallNode compile |
      compile = moduleImport("dot").getAMemberCall("template") and
      exists(compile.getACall()) and
      this = compile.getArgument(0)
    )
  }
}

class SSTIEjsSink extends ServerSideTemplateInjectionSink {
  SSTIEjsSink() { this = moduleImport("ejs").getAMemberCall("render").getArgument(0) }
}

class SSTINunjucksSink extends ServerSideTemplateInjectionSink {
  SSTINunjucksSink() {
    this = moduleImport("nunjucks").getAMemberCall("renderString").getArgument(0)
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, ServerSideTemplateInjectionConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and unsafely used as part of rendered template",
  source.getNode(), "User-provided value"
