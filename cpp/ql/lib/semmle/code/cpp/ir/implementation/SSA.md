# IR SSA Construction

This document describes how Static Single Assignment (SSA) form is constructed for the Intermediate
Representation (IR). The SSA form that we use is based on the traditional [SSA](https://en.wikipedia.org/wiki/Static_single_assignment_form)
commonly used in compilers, with additional extensions to support accesses to aliased memory
inspired by [ChowCLLS96](https://link.springer.com/chapter/10.1007%2F3-540-61053-7_66).

SSA construction takes as input an instance of the IR, and creates a new instance of the IR that is
in SSA form. If the input IR is already in SSA form, SSA construction will still recompute SSA form
from scratch. However, the input SSA information will be taken into account to improve the alias
analysis that guides the new SSA computation. The current implementation creates three successive
instances of the IR:
- *Raw IR* is constructed directly from the original AST. Raw IR does not have any of its memory
accesses in SSA form.
- *Unaliased SSA IR* is constructed from Raw IR. It places memory accesses in SSA form only for
accesses to unescaped local variables that are loaded or stored in their entirety, and as their
declared type. Accesses to aliased memory are not modeled, nor are accesses to variables that have
any partial reads or writes.
- *Aliased SSA IR* is constructed from Unaliased SSA IR. All memory accesses are placed in SSA form,
including accesses to aliased memory.

Constructing SSA form involves three steps in succession: Alias analysis, the memory model, and
the actual SSA construction itself. Each step is a module that is parameterized on an implementation
of the previous step, so the memory model and alias analysis modules can be replaced in order to
provide different analysis heuristics or performance/precision tradeoffs.

## Alias Analysis
The alias analysis component is responsible for determining two closely related sets of facts about
the input IR: What memory is being accessed by each memory operand or memory result, and which
variables "escape" such that the analysis can no longer precisely track all accesses to those
variables. This information is consumed by the memory model component, but is not consumed directly
by the actual SSA construction.

The current alias analysis exposes two predicates:

```
predicate resultPointsTo(Instruction instr, IRVariable var, IntValue bitOffset);

predicate variableAddressEscapes(IRVariable var);
```

The `resultPointsTo` predicate computes, for each `Instruction`, the `IRVariable` that is pointed
into by the result of that `Instruction`, and the bit offset that the result of the `Instruction`
points to within that variable. If it can not prove that the result points into exactly one
`IRVariable`, then the predicate does not hold. If the result is known to point into a specific
`IRVariable`, but the offset is unknown, then the predicate will hold, but the `bitOffset` parameter
will be `Ints::unknown()`. This is useful for cases including array accesses, where the array index
may be computed at runtime, but it is known that some element in the array, rather than to some
arbitrary unknown location.

The `variableAddressEscapes` predicate computes the set of `IRVariable`s whose address "escapes". A
variable's address escapes if there is a possibility that there exists a memory access somewhere in
the program that access the variable, without that access being modeled by the `resultPointsTo`
predicate. Common reasons for a variable's address escaping include:
- The address is assigned into a global variable, heap memory, or some other location where code may
be able to later dereference the address outside the scope of the `resultPointsTo` analysis.
- The address is passed as an argument to a function, unless the called function is known not to
retain that address after it returns.

### Current Implementation
The current alias analysis implementation can track the pointed-to variable and offset through
copies, pointer arithmetic, and field offset computations. If the input IR is already in SSA form,
even an address assigned to a local variable can be tracked.

## Memory Model
The memory model uses the results of alias analysis to describe the memory location accessed by each
memory operand or memory result in the function. It exposes two classes and three non-member
predicate:

```
class MemoryLocation {
    VirtualVariable getVirtualVariable();
}

class VirtualVariable extends MemoryLocation {
}

MemoryLocation getResultMemoryLocation(Instruction instr);

MemoryLocation getOperandMemoryLocation(MemoryOperand operand);

Overlap getOverlap(MemoryLocation def, MemoryLocation use);
```

A `MemoryLocation` represents the set of bits of memory read by a memory operand or written by a
memory result. The `getResultMemoryLocation` predicate returns the `MemoryLocation` written by the
result of the specified `Instruction`, and the `getOperandMemoryLocation` predicate returns the
`MemoryLocation` read by the specified `MemoryOperand`. From the point of view of the SSA
construction module, which consumes the memory model, `MemoryLocation` is essentially opaque. The
memory model can assign `MemoryLocation`s to memory accesses however it wants, as long as the few
basic constraints outlined later in this section are respected.

The `getOverlap` predicate returns the overlap relationship between a definition of location `def`
and a use of the location `use`. The possible overlap relationships are as follows:
- `MustExactlyOverlap` - The set of bits written by the definition is identical to the set of bits
read by the use, *and* the data type of both the definition and the use are the same.
- `MustTotallyOverlap` - Either the set of bits written by the definition is a proper superset of
the bits read by the use, or the set of bits written by the definition is identical to that of the
use, but the data type of the definition differs from that of the use.
- `MayPartiallyOverlap` - Neither of the two relationships above apply, but there may be at least
one bit written by the definition that is read by the use. `MayPartiallyOverlap` is always a sound
result, because it is technically correct even if the actual overlap at runtime is exact, total, or
even no overlap at all.
- (No result) - The definition does not overlap the use at all.

Each `MemoryLocation` is associated with exactly one `VirtualVariable`. A `VirtualVariable`
represents a set of `MemoryLocation`s such that any two `MemoryLocation`s that overlap have the same
`VirtualVariable`. Note that each `VirtualVariable` is itself a `MemoryLocation` that totally
overlaps each of its member `MemoryLocation`s. `VirtualVariable`s are used in SSA construction to
separate the problem of matching uses and definitions by partitioning memory locations into groups
that do not overlap with one another.

### Current Implementation
#### Unaliased SSA
The current memory model used to construct Unaliased SSA models only variables that are unescaped,
and always accessed in their entirety via their declared type. There is one `MemoryLocation` for
each unescaped `IRVariable`, and each `MemoryLocation` is its own `VirtualVariable`. The overlap
relationship is simple: Each `MemoryLocation` exactly overlaps itself, and does not overlap any
other `MemoryLocation`.

#### Aliased SSA
The current memory model used to construct Aliased SSA models every memory access. There are two
kinds of `MemoryLocation`:
- `VariableMemoryLocation` represents an access to a known `IRVariable` with a specific type, at a bit
offset that may or may not be a known constant. `VariableMemoryLocation` represents any access to a
known `IRVariable` even if that variable's address escapes.
- `UnknownMemoryLocation` represents an access where the memory being accessed is not known to be part
of a single specific `IRVariable`.

In addition, there are two different kinds of `VirtualVariable`:
- `VariableVirtualVariable` represents an `IRVariable` whose address does not escape. The
`VariableVirtualVariable` is just the `VariableMemoryLocation` that represents an access to the entire
`IRVariable` with its declared type.
- `UnknownVirtualVariable` represents all memory that is not covered by a `VariableVirtualVariable`.
This includes the `UnknownMemoryLocation`, as well as any `VariableMemoryLocation` whose
`IRVariable`'s address escapes.

The overlap relationship for this model is slightly more complex than that of Unaliased SSA. A
definition of a `VariableMemoryLocation` overlaps a use of another `VariableMemoryLocation` if both
locations have the same `IRVariable` and the offset ranges overlap. The overlap kind is determined
based on the overlap of the offset ranges, and may be any of the three overlaps kinds, or no overlap
at all if the offset ranges are disjoint. A definition of a `VariableMemoryLocation` overlaps a use
of the `UnknownMemoryLocation` (or vice versa) if and only if the address of the `IRVariable`
escapes; this is a `MayPartiallyOverlap` relationship.
