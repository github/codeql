import go

newtype TEntityWithDeclInfo =
  MkEntityWithDeclInfo(Entity e, int nDecls) { nDecls = count(e.getDeclaration()) and nDecls > 0 }

class EntityWithDeclInfo extends TEntityWithDeclInfo {
  string toString() {
    exists(Entity e, int nDecls | this = MkEntityWithDeclInfo(e, nDecls) |
      result = e.toString() + " (" + nDecls + " declaration sites)"
    )
  }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(Entity e | this = MkEntityWithDeclInfo(e, _) |
      e.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    )
  }
}

query predicate distinctDefinedFs(int ct) { ct = count(DeclaredFunction e | e.toString() = "F") }

query predicate declaredEntities(EntityWithDeclInfo e) { any() }
