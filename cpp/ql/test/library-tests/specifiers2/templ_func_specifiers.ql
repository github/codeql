import cpp

from MemberFunction m, TemplateClass c, string specifiers
where
  c.getAMember() = m and
  specifiers = concat(string s | s = m.getASpecifier().getName() | s, ", ")
select m, specifiers
