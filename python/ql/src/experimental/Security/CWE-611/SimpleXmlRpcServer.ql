/**
 * @name SimpleXMLRPCServer DoS vulnerability
 * @description SimpleXMLRPCServer is vulnerable to DoS attacks from untrusted user input
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id py/simple-xml-rpc-server
 * @tags security
 *       external/cwe/cwe-776
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

from DataFlow::CallCfgNode call, string kinds
where
  call = API::moduleImport("xmlrpc").getMember("server").getMember("SimpleXMLRPCServer").getACall() and
  kinds =
    strictconcat(XML::XMLVulnerabilityKind kind |
      kind.isBillionLaughs() or kind.isQuadraticBlowup()
    |
      kind, ", "
    )
select call, "SimpleXMLRPCServer is vulnerable to: " + kinds + "."
