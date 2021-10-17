import ql

query AstNode getTarget(Call call) { result = call.getTarget() }

query YAML::QLPack dependsOn(YAML::QLPack pack) { result = pack.getADependency() }

query Predicate exprPredicate(PredicateExpr expr) { result = expr.getResolvedPredicate() }
