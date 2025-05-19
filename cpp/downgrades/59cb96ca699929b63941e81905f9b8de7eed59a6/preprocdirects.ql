class PreprocessorDirective extends @preprocdirect {
  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

bindingset[kind]
int getKind(int kind) {
  if kind = 14
  then result = 6 // Represent MSFT #import as #include
  else
    if kind = 15 or kind = 6
    then result = 3 // Represent #elifdef and #elifndef as #elif
    else result = kind
}

from PreprocessorDirective ppd, int kind, Location l
where preprocdirects(ppd, kind, l)
select ppd, getKind(kind), l
