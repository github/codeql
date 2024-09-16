import go

newtype TEntityWithDeclInfo = MkEntityWithDeclInfo(Entity e)

class EntityWithDeclInfo extends TEntityWithDeclInfo {
  Entity e;

  EntityWithDeclInfo() { this = MkEntityWithDeclInfo(e) }

  string toString() {
    result = e.toString() + " (" + count(e.getDeclaration()) + " declaration sites)"
  }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    e.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

query predicate lowLevelDefs(Ident i, EntityWithDeclInfo ewrapped) {
  exists(Entity e | ewrapped = MkEntityWithDeclInfo(e) | defs(i, e))
}

query predicate lowLevelUses(Ident i, EntityWithDeclInfo ewrapped) {
  exists(Entity e | ewrapped = MkEntityWithDeclInfo(e) | uses(i, e))
}

query predicate distinctDefinedXs(int ct) {
  ct = count(Entity e | defs(_, e) and e.toString() = "x")
}

query predicate distinctUsedXs(int ct) { ct = count(Entity e | uses(_, e) and e.toString() = "x") }

query predicate fieldUseUsePairs(Ident i1, Ident i2) {
  exists(Field e | uses(i1, e) and uses(i2, e) and i1 != i2)
}
