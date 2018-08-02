import cpp

from Class t, string struct, string union
where if t instanceof Struct then struct = "struct" else struct = ""
  and if t instanceof Union  then union  = "union"  else union  = ""
select t, struct, union
