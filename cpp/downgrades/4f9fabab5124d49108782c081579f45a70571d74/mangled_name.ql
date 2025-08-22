class Declaration extends @declaration {
  string toString() { none() }
}

class MangledName extends @mangledname {
  string toString() { none() }
}

from Declaration d, MangledName n
where mangled_name(d, n, _)
select d, n
