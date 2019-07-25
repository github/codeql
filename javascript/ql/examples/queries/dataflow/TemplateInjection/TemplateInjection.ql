/**
 * @name Template injection
 * @description Tracks user-controlled values to an unescaped lodash template placeholder.
 * @kind path-problem
 * @tags security
 * @id js/examples/template-injection
 */

import javascript
import DataFlow
import DataFlow::PathGraph

/**
 * Gets the name of an unescaped placeholder in a lodash template.
 *
 * For example, the string `<h1><%= title %></h1>` contains the placeholder `title`.
 */
bindingset[s]
string getAPlaceholderInString(string s) {
  result = s.regexpCapture(".*<%=\\s*([a-zA-Z0-9_]+)\\s*%>.*", 1)
}

class TemplateInjection extends TaintTracking::Configuration {
  TemplateInjection() { this = "TemplateInjection" }

  override predicate isSource(Node node) { node instanceof RemoteFlowSource }

  override predicate isSink(Node node) {
    exists(CallNode call, string placeholder |
      call = LodashUnderscore::member("template").getACall() and
      placeholder = getAPlaceholderInString(call.getArgument(0).getStringValue()) and
      node = call.getOptionArgument(1, placeholder)
    )
  }
}

from TemplateInjection cfg, PathNode source, PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "User-controlled value from $@ occurs unescaped in a lodash template.", source.getNode(), "here."
