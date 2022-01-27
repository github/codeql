import ruby

query Callable getTarget(Call call) { result = call.getATarget() }

query predicate unresolvedCall(Call call) { not exists(call.getATarget()) }

query predicate privateMethod(MethodBase m) { m.isPrivate() }
