import go

int countDecls(Entity e) { result = count(Ident decl | decl = e.getDeclaration()) }

query predicate entities(string fp, Entity e, int c, Type ty) {
  c = countDecls(e) and
  ty = e.getType() and
  exists(Location loc |
    loc = e.getDeclaration().getLocation() and
    fp = loc.getFile().getBaseName() and
    fp = "aliases.go"
  )
}

from FuncDecl decl, SignatureType sig
where
  decl.getFile().getAbsolutePath().matches("%aliases.go%") and
  decl.getName() = ["F", "G", "H"] and
  sig = decl.getType()
select decl.getName(), sig.pp()
