/**
 * @name SimpleXMLRPCServer DoS vulnerability
 * @description SimpleXMLRPCServer is vulnerable to DoS attacks from untrusted user input
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id py/simple-xml-rpc-server-dos
 * @tags security
 *       external/cwe/cwe-776
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

from DataFlow::CallCfgNode call, string kinds
where
  call = API::moduleImport("xmlrpc").getMember("server").getMember("SimpleXMLRPCServer").getACall() and
  kinds =
    strictconcat(XML::XmlParsingVulnerabilityKind kind |
      kind.isBillionLaughs() or kind.isQuadraticBlowup()
    |
      kind, ", "
    )
select call, "SimpleXMLRPCServer is vulnerable to: " + kinds + "."
