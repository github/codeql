import cpp
import relevant

from Function fn
where
  fn.getNamespace() instanceof GlobalNamespace and
  not exists(fn.getDeclaringType()) and
  is_relevant_result(fn.getFile())
select fn, "This function is not declared in a namespace", fn.getFile().getRelativePath()
