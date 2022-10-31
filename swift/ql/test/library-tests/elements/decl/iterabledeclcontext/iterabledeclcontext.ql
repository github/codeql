import swift

from IterableDeclContext decl, int index, Decl member
where
  decl.(Decl).getModule().getName() = "iterabledeclcontext" and
  member = decl.getMember(index)
select decl, index, member, member.getPrimaryQlClasses()
