import cpp

from MemberFunction m, ClassTemplateInstantiation c, string specifiers
where
  c.getAMember() = m and
  specifiers = concat(string s | s = m.getASpecifier().getName() | s, ", ")
select c, c.getATemplateArgument(), m, specifiers
