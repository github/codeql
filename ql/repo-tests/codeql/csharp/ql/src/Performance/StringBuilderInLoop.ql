/**
 * @name StringBuilder creation in loop
 * @description Creating a 'StringBuilder' in a loop is less efficient than reusing a single 'StringBuilder'.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id cs/stringbuilder-creation-in-loop
 * @tags efficiency
 */

import csharp
import semmle.code.csharp.frameworks.system.Text

from ObjectCreation creation, LoopStmt loop, ControlFlow::Node loopEntryNode
where
  creation.getType() instanceof SystemTextStringBuilderClass and
  loopEntryNode = loop.getBody().getAControlFlowEntryNode() and
  loop.getBody().getAChild*() = creation and
  creation.getAControlFlowNode().postDominates(loopEntryNode)
select creation, "Creating a 'StringBuilder' in a loop."
