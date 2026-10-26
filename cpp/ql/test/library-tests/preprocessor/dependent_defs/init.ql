import cpp

// A variable may have more than one initializer because variables are merged
// when they have the same name and appear in the same source file, but their
// initializers are not merged.
from Variable v
select v, v.getInitializer().getExpr().getValue(), count(v.getInitializer().getExpr().getValue())
