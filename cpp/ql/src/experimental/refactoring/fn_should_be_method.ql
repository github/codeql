import cpp

from Function fn
where not exists(fn.getDeclaringType()) and is_relevant_result(fn.getFile())
