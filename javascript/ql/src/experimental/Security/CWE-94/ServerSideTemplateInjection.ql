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
    exists(CallNode compile, ModuleImportNode renderImport, Node sink |
      (renderImport = moduleImport("pug") or renderImport = moduleImport("jade")) and
      (
        compile = renderImport.getAMemberCall("compile") and
        compile.flowsTo(sink) and
        sink.getStartLine() != sink.getASuccessor().getStartLine()
        or
        compile = renderImport.getAMemberCall("render") and compile.flowsTo(sink)
      ) and
      this = compile.getArgument(0)
    )
  }
}

class SSTIDotSink extends ServerSideTemplateInjectionSink {
  SSTIDotSink() {
    exists(CallNode compile, Node sink |
      compile = moduleImport("dot").getAMemberCall("template") and
      compile.flowsTo(sink) and
      sink.getStartLine() != sink.getASuccessor().getStartLine() and
      this = compile.getArgument(0)
    )
  }
}

class SSTIEjsSink extends ServerSideTemplateInjectionSink {
  SSTIEjsSink() {
    exists(CallNode compile, Node sink |
      compile = moduleImport("ejs").getAMemberCall("render") and
      compile.flowsTo(sink) and
      this = compile.getArgument(0)
    )
  }
}

class SSTINunjucksSink extends ServerSideTemplateInjectionSink {
  SSTINunjucksSink() {
    exists(CallNode compile, Node sink |
      compile = moduleImport("nunjucks").getAMemberCall("renderString") and
      compile.flowsTo(sink) and
      this = compile.getArgument(0)
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, ServerSideTemplateInjectionConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and is used in an XPath expression.",
  source.getNode(), "User-provided value"
