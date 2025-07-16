/**
 * @name Use of Binary Formatter deserialization
 * @description Use of Binary Formatter is unsafe
 * @kind problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id powershell/microsoft/public/binary-formatter-deserialization
 * @tags correctness
 *       security
 *       external/cwe/cwe-502
 */

import powershell
import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.dataflow.TaintTracking

from DataFlow::ObjectCreationNode source, DataFlow::CallNode cn 
where
source.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Runtime.Serialization.Formatters.Binary.BinaryFormatter" and
cn.getQualifier().getALocalSource() = source and 
cn.getLowerCaseName() = "deserialize" 
select cn, "Call to BinaryFormatter.Deserialize"
