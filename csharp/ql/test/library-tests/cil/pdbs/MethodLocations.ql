import cil

// Used only because native PDBs are only supported on Windows.
// They are included as tests but disabled here.
deprecated predicate filterMethod(CIL::Method m) {
  m.getDeclaringType().getNamespace().getName() = "EmbeddedPdb" or
  m.getDeclaringType().getNamespace().getName() = "PortablePdb"
}

deprecated query predicate methodLocations(string m, string loc, boolean primaryLocation) {
  exists(CIL::Method method, CIL::Location location |
    location = method.getALocation() and
    exists(CIL::Location l | l = method.getALocation() | l.getFile().isPdbSourceFile()) and
    (if location = method.getLocation() then primaryLocation = true else primaryLocation = false) and
    filterMethod(method) and
    m = method.toStringWithTypes() and
    loc = location.toString()
  )
}
