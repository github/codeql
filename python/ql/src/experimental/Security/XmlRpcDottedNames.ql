/**
 * @name The allow_dotted_names option may allow intruders to execute arbitrary code
 * @description Enabling the allow_dotted_names option allows intruders to access your module’s global variables and may allow intruders to execute arbitrary code on your machine.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id python/xml-rpc-dotted-names
 * @tags reliability
 *       security
 */

import python

from CallNode call, ControlFlowNode allow_dotted_names, Attribute a
where
  a.getLocation().getStartLine() = call.getLocation().getStartLine() and
  a.getName() = "register_instance" and
  not call.getLocation().getFile().inStdlib() and
  (
    allow_dotted_names = call.getArgByName("allow_dotted_names") or
    allow_dotted_names = call.getArg(1)
  ) and
  allow_dotted_names.getNode().toString() = "True"
select a,
  "Enabling the allow_dotted_names option allows intruders to access your module’s global variables and may allow intruders to execute arbitrary code on your machine."
