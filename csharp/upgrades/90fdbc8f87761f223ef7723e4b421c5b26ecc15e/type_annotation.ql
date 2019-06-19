class Element extends @element {
  string toString() { none() }

  int getAnnotation() {
    exists(int mode | params(this, _, _, _, mode, _, _) |
      mode = 1 and result = 5 // ref
      or
      mode = 2 and result = 6 // out
      or
      mode = 5 and result = 4 // in
    )
    or
    ref_returns(this) and result = 5
    or
    ref_readonly_returns(this) and result = 4
  }
}

from Element element
select element, element.getAnnotation()
