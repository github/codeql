import cil

// Used only because native PDBs are only supported on Windows.
// They are included as tests but disabled here.
predicate filterMethod(CIL::Method m) {
  m.getDeclaringType().getNamespace().getName() = "EmbeddedPdb" or
  m.getDeclaringType().getNamespace().getName() = "PortablePdb"
}

from CIL::Method method, CIL::Location location, boolean primaryLocation
where
  location = method.getALocation() and
  exists(CIL::Location l | l = method.getALocation() | l.getFile().isPdbSourceFile()) and
  (if location = method.getLocation() then primaryLocation = true else primaryLocation = false) and
  filterMethod(method)
select method.toStringWithTypes(), location.toString(), primaryLocation
