import csharp

from Modifiable m, string s
where m.fromSource()
  and (m.isEffectivelyInternal() and not m.isInternal() and s = "internal" or
       m.isEffectivelyPrivate() and not m.isPrivate() and s = "private")
select m, s
