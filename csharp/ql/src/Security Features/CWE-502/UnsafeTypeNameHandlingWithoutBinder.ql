/**
 * @name Unsafe TypeNameHandling without Binder to deserialize user input
 * @description Using an unsafe TypeNameHandling constant is a security vulnerability.
 * @kind path-problem
 * @id cs/unsafe-type-name-handling-without-binder
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-502
 */

import csharp
import semmle.code.csharp.serialization.Deserializers
import semmle.code.csharp.security.dataflow.TypeNameHandlingQuery

import UserInputToDeserializeObjectCallFlow::PathGraph

from 
UserInputToDeserializeObjectCallFlow::PathNode userInput, UserInputToDeserializeObjectCallFlow::PathNode deserializeArg,
DataFlow::Node badTypeNameHandling, DataFlow::Node typeNameHandlingSettingArg, 
BadTypeHandling bth
where 
UnsafeTypeNameHandlingFlow::flow(badTypeNameHandling, typeNameHandlingSettingArg) and 
not hasBinderSet(typeNameHandlingSettingArg.asExpr().(JsonSerializerSettingsArg)) and
UserInputToDeserializeObjectCallFlow::flowPath(userInput, deserializeArg) and 
deserializeArg.getNode().asExpr().(DeserializeArg).getDeserializeCall() =  typeNameHandlingSettingArg.asExpr().(JsonSerializerSettingsArg).getDeserializeCall() and
bth = badTypeNameHandling.asExpr()
select deserializeArg.getNode(), userInput, deserializeArg, "Use of $@ constant to deserialize user-controlled input is unsafe", bth, "this Json.net TypeNameHandling"