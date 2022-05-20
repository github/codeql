import cpp

from
  PreprocessorBranchDirective pbd_if, PreprocessorBranchDirective pbd, string pbd_next,
  string pbd_next_line, PreprocessorBranchDirective pbd_endif
where
  pbd_if = pbd.getIf() and
  (
    if exists(pbd.getNext())
    then (
      pbd_next = pbd.getNext().toString() and
      pbd_next_line = pbd.getNext().getLocation().getStartLine().toString()
    ) else (
      pbd_next = "N/A" and
      pbd_next_line = "N/A"
    )
  ) and
  pbd_endif = pbd.getEndIf()
select pbd, pbd_if, pbd_next_line, pbd_next, pbd_endif
