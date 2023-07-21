/**
 * @name SimpleXMLRPCServer denial of service
 * @description SimpleXMLRPCServer is vulnerable to denial of service attacks from untrusted user input
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id py/simple-xml-rpc-server-dos
 * @tags security
 *       experimental
 *       external/cwe/cwe-776
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

from DataFlow::CallCfgNode call
where
  call = API::moduleImport("xmlrpc").getMember("server").getMember("SimpleXMLRPCServer").getACall()
select call, "SimpleXMLRPCServer is vulnerable to XML bombs."
