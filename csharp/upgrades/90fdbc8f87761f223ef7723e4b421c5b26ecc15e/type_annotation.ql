from @element element, int annotation
where 
  exists(int mode | 
    params(param, _, _, _, mode, _, _)
  |
    mode = 1 and annotation = 5 // ref
    or
    mode = 2 and annotation = 6 // out
    or
    mode = 5 and annotation = 4 // in
  )
  or
  returns_ref(element) and annotation = 5
  or
  returns_readonly_ref(element) and annotation = 4
select element, annotation