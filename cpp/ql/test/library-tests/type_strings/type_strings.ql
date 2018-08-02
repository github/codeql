import cpp

Type getDeclType(Declaration d) {
    result = ((GlobalVariable)d).getType() or
    result = ((Function      )d).getType()
}

from Declaration d
select d,
       getDeclType(d).toString(),
       getDeclType(d).explain()

