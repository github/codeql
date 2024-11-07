import go

newtype TEntityWithDeclInfo =
  MkEntityWithDeclInfo(Entity e, int nDecls) { nDecls = count(e.getDeclaration()) and nDecls > 0 }

class EntityWithDeclInfo extends TEntityWithDeclInfo {
  Entity e;
  int nDecls;

  EntityWithDeclInfo() { this = MkEntityWithDeclInfo(e, nDecls) }

  string toString() { result = e.toString() + " (" + nDecls + " declaration sites)" }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    e.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

query predicate distinctDefinedFs(int ct) { ct = count(DeclaredFunction e | e.toString() = "F") }

query predicate declaredEntities(EntityWithDeclInfo e) { any() }
