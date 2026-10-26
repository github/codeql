import rust
import TestUtils

query predicate fieldless(Enum e) { toBeTested(e) and e.isFieldless() }

query predicate unitOnly(Enum e) { toBeTested(e) and e.isUnitOnly() }
