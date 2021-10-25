/**
 * @name Scopes1
 * @kind table
 */

import cpp

string describe(Element e) {
  if e instanceof GlobalNamespace
  then result = "GlobalNamespace"
  else
    if e instanceof Namespace
    then result = "Namespace"
    else
      if e instanceof NestedClass
      then result = "NestedClass"
      else
        if e instanceof Class
        then result = "Class"
        else result = ""
}

from Element parent, Element child
where
  (
    parent instanceof Namespace or
    parent instanceof Class or
    child instanceof Namespace or
    child instanceof Class
  ) and
  parent = child.getParentScope() and
  child.toString() != "__va_list_tag" // platform dependent
select parent, describe(parent), child, describe(child)
