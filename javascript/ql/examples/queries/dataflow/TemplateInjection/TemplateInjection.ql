/**
 * @name Template injection
 * @description Tracks user-controlled values to an unescaped lodash template placeholder.
 * @kind path-problem
 * @problem.severity error
 * @tags security
 * @id js/examples/template-injection
 */

import javascript

/**
 * Gets the name of an unescaped placeholder in a lodash template.
 *
 * For example, the string `"<h1><%= title %></h1>"` contains the placeholder "title".
 */
bindingset[s]
string getAPlaceholderInString(string s) {
  result = s.regexpCapture(".*<%=\\s*([a-zA-Z0-9_]+)\\s*%>.*", 1)
}

module TemplateInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node node) {
    exists(DataFlow::CallNode call, string placeholder |
      call = LodashUnderscore::member("template").getACall() and
      placeholder = getAPlaceholderInString(call.getArgument(0).getStringValue()) and
      node = call.getOptionArgument(1, placeholder)
    )
  }
}

module TemplateInjectionFlow = TaintTracking::Global<TemplateInjectionConfig>;

import TemplateInjectionFlow::PathGraph

from TemplateInjectionFlow::PathNode source, TemplateInjectionFlow::PathNode sink
where TemplateInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "User-controlled value from $@ occurs unescaped in a lodash template.", source.getNode(), "here."
