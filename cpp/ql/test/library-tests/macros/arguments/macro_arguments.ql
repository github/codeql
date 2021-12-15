import cpp

string prettyPrintMacroInvocation(MacroInvocation mi) {
  not exists(mi.getParentInvocation()) and
  result = mi.getMacro().getName()
  or
  result = prettyPrintMacroInvocation(mi.getParentInvocation()) + " -> " + mi.getMacro().getName()
}

from MacroInvocation mi, int arg_index, string unexpanded, string expanded
where
  unexpanded = mi.getUnexpandedArgument(arg_index) and
  expanded = mi.getExpandedArgument(arg_index)
select mi.getLocation().toString().regexpCapture(".*/([^/]*)$", 1),
  mi.getActualLocation().toString().regexpCapture(".*/([^/]*)$", 1), prettyPrintMacroInvocation(mi),
  arg_index, unexpanded, expanded
