import cpp

Type getDeclType(Declaration d) {
  result = d.(GlobalVariable).getType() or
  result = d.(Function).getType()
}

from Declaration d
select d, getDeclType(d).toString(), getDeclType(d).explain()
