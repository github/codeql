import swift
import Relevant

from Decl d
where relevant(d)
select d, d.getPrimaryQlClasses()
