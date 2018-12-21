import csharp

newtype TTargetAccessOption =
  TTargetAccessSome(AssignableAccess aa) or
  TTargetAccessNone(AssignableDefinition def)

class TargetAccessOption extends TTargetAccessOption {
  string toString() {
    result = som().toString()
    or
    exists(non()) and result = "<none>"
  }

  Location getLocation() {
    result = som().getLocation() or
    result = non().getLocation()
  }

  private AssignableAccess som() { this = TTargetAccessSome(result) }

  private AssignableDefinition non() { this = TTargetAccessNone(result) }

  predicate fromAssignableDefinition(AssignableDefinition def) {
    if exists(def.getTargetAccess()) then this.som() = def.getTargetAccess() else this.non() = def
  }
}

newtype TSourceOption =
  TSourceSome(Expr e) or
  TSourceNone(AssignableDefinition def)

class SourceOption extends TSourceOption {
  string toString() {
    result = som().toString()
    or
    exists(non()) and result = "<none>"
  }

  Location getLocation() {
    result = som().getLocation() or
    result = non().getLocation()
  }

  private Expr som() { this = TSourceSome(result) }

  private AssignableDefinition non() { this = TSourceNone(result) }

  predicate fromAssignableDefinition(AssignableDefinition def) {
    if exists(def.getSource()) then this.som() = def.getSource() else this.non() = def
  }
}

from AssignableDefinition def, TargetAccessOption access, SourceOption source, string certain
where
  (if def.isCertain() then certain = "certain" else certain = "uncertain") and
  access.fromAssignableDefinition(def) and
  source.fromAssignableDefinition(def)
select def.getTarget(), def, access, source, certain
