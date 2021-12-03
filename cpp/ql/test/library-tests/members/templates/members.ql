import cpp

string mem(Class c) {
  if exists(c.getAMember())
  then exists(int i | result = i.toString() + " " + c.getAMember(i).getQualifiedName())
  else result = "<none>"
}

from Class c
select c, mem(c)
