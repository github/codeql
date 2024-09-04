import go

int countDecls(Entity e) { result = count(Ident decl | decl = e.getDeclaration()) }

query predicate entities(string fp, Entity e, int c, Type ty) {
  c = countDecls(e) and
  ty = e.getType() and
  exists(DbLocation loc |
    loc = e.getDeclaration().getLocation() and
    fp = loc.getFile().getBaseName() and
    fp = "aliases.go"
  )
}

from string fp, FuncDecl decl, SignatureType sig
where
  decl.hasLocationInfo(fp, _, _, _, _) and
  decl.getName() = ["F", "G", "H"] and
  sig = decl.getType() and
  fp.matches("%aliases.go%")
select decl.getName(), sig.pp()
