class Declaration extends @declaration {
  string toString() { none() }
}

class MangledName extends @mangledname {
  string toString() { none() }
}

from Declaration d, MangledName n, boolean isComplete
where
  mangled_name(d, n) and
  if d instanceof @function then isComplete = false else isComplete = true
select d, n, isComplete
