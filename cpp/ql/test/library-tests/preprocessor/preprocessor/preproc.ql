import cpp

from Location loc, PreprocessorDirective pd, string head, string body
where
  loc = pd.getLocation() and
  (if exists(pd.getHead()) then head = pd.getHead() else head = "N/A") and
  if pd instanceof Macro then body = pd.(Macro).getBody() else body = "N/A"
select loc.getFile(), loc.getStartLine(), loc.getStartColumn(), loc.getEndLine(),
  loc.getEndColumn(), concat(pd.getAQlClass(), ", "), head, body
