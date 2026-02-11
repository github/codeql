## 5.4.0

### New Features

* Exposed various SSA-related classes (`Definition`, `PhiNode`, `ExplicitDefinition`, `DirectExplicitDefinition`, and `IndirectExplicitDefinition`) which were previously only usable inside the internal dataflow directory.

### Minor Analysis Improvements

* The `cpp/overrun-write` query now recognizes more bound checks and thus produces fewer false positives.
