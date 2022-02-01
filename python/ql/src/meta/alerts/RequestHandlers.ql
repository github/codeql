/**
 * @name Request Handlers
 * @description HTTP Server Request Handlers
 * @kind problem
 * @problem.severity recommendation
 * @id py/meta/alerts/request-handlers
 * @tags meta
 * @precision very-low
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import meta.MetaMetrics

from HTTP::Server::RequestHandler requestHandler, string title
where
  not requestHandler.getLocation().getFile() instanceof IgnoredFile and
  if requestHandler.isMethod()
  then
    title = "Method " + requestHandler.getScope().(Class).getName() + "." + requestHandler.getName()
  else title = requestHandler.toString()
select requestHandler, "RequestHandler: " + title
