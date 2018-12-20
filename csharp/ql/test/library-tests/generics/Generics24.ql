import csharp

from UnboundGenericInterface ugi, TypeParameter tp, string s
where
  ugi.fromSource() and
  ugi.getATypeParameter() = tp and
  (
    tp.isOut() and s = "out"
    or
    tp.isIn() and s = "in"
  )
select ugi, tp, s
