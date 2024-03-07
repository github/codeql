import cil

// Used only because native PDBs are only supported on Windows.
// They are included as tests but disabled here.
deprecated predicate filterMethod(CIL::Method m) {
  m.getDeclaringType().getNamespace().getName() = "EmbeddedPdb" or
  m.getDeclaringType().getNamespace().getName() = "PortablePdb"
}

deprecated query predicate instructionLocations(string loc, string extra) {
  exists(CIL::Instruction instruction, CIL::Location location |
    location = instruction.getLocation() and
    filterMethod(instruction.getImplementation().getMethod()) and
    loc = location.toString() and
    extra = instruction.toStringExtra()
  )
}
