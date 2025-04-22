import powershell

query predicate positionalArguments(Argument a, int p) { p = a.getPosition() }

query predicate namedArguments(Argument a, string name) { name = a.getName() }
