class PreprocessorDirective extends @preprocdirect {
  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

from PreprocessorDirective ppd, int kind, int kind_new, Location l
where
  preprocdirects(ppd, kind, l) and
  if kind = 17 then kind_new = /* ppd_warning */ 18 else kind_new = kind
select ppd, kind_new, l
