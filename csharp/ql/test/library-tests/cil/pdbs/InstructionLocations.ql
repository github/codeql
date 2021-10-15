import cil

// Used only because native PDBs are only supported on Windows.
// They are included as tests but disabled here.
predicate filterMethod(CIL::Method m) {
  m.getDeclaringType().getNamespace().getName() = "EmbeddedPdb" or
  m.getDeclaringType().getNamespace().getName() = "PortablePdb"
}

from CIL::Instruction instruction, CIL::Location location
where
  location = instruction.getLocation() and
  filterMethod(instruction.getImplementation().getMethod())
select location.toString(), instruction.toStringExtra()
