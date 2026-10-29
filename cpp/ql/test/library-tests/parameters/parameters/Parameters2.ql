import cpp

select count(Function f, Function g |
    f.getAParameter() = g.getAParameter() and
    f != g
  )
