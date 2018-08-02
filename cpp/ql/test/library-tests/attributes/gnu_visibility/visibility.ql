import cpp

from Element e, Attribute a
where a = ((Variable)e).getAnAttribute()
   or a = ((Function)e).getAnAttribute()
   or a = ((Struct  )e).getAnAttribute()
select e, a, a.getAnArgument()
