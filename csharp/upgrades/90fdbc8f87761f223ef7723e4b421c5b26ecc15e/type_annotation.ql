class Element extends @element {
  string toString() { none() }

  int getAnnotation() {
    exists(int mode | params(this, _, _, _, mode, _, _) |
      mode = 1 and result = 32 // ref
      or
      mode = 2 and result = 64 // out
      or
      mode = 5 and result = 16 // in
    )
    or
    ref_returns(this) and result = 32
    or
    ref_readonly_returns(this) and result = 16
  }
}

from Element element
select element, element.getAnnotation()
