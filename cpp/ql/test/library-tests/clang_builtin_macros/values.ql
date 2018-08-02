import cpp

string varInit(Variable v) {
    if exists(v.getInitializer().getExpr().getValue())
    then result = v.getInitializer().getExpr().getValue().toString()
    else result = "<no initialiser value>"
}

from Variable v
select v.getFile().toString(), v.getName(), varInit(v)
