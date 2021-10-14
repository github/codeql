/**
 * @name Unsafe jQuery plugin
 * @description A jQuery plugin that unintentionally constructs HTML from some of its options may be unsafe to use for clients.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.1
 * @precision high
 * @id js/unsafe-jquery-plugin
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 *       frameworks/jquery
 */

import javascript
import semmle.javascript.security.dataflow.UnsafeJQueryPluginQuery
import DataFlow::PathGraph

from
  Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink,
  JQuery::JQueryPluginMethod plugin
where
  cfg.hasFlowPath(source, sink) and
  source.getNode().(Source).getPlugin() = plugin
select sink.getNode(), source, sink, "Potential XSS vulnerability in the $@.", plugin,
  "'$.fn." + plugin.getPluginName() + "' plugin"
