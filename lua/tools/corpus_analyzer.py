"""Analyze an accepted Lua bytecode corpus into immutable generic relations."""

from __future__ import annotations

from collections import defaultdict, deque
from dataclasses import dataclass
from pathlib import PurePosixPath

from lua_bytecode import Chunk, LoadedArtifact


LUA_RK_CONSTANT_BIT = 1 << 8


@dataclass(frozen=True)
class CorpusArtifact:
    module_path: str
    loaded_artifact: LoadedArtifact


@dataclass(frozen=True)
class AcceptedCorpus:
    artifacts: tuple[CorpusArtifact, ...]


@dataclass(frozen=True)
class ArtifactIdentityRelation:
    module_path: str
    profile_id: str


@dataclass(frozen=True)
class PrototypeIdentityRelation:
    module_path: str
    prototype_id: str
    parent_prototype_id: str
    ordinal_index: int
    num_params: int
    is_vararg: bool
    max_stack: int
    upvalue_count: int


@dataclass(frozen=True)
class InstructionIdentityRelation:
    module_path: str
    prototype_id: str
    pc: int
    opcode: str
    operand_a: int
    operand_b: int
    operand_c: int


@dataclass(frozen=True)
class ValueIdentityRelation:
    module_path: str
    prototype_id: str
    value_ref: str
    value_kind: str
    pc: int
    slot: int


@dataclass(frozen=True)
class ValueFlowRelation:
    module_path: str
    prototype_id: str
    source_ref: str
    sink_ref: str
    kind: str
    provenance: str


@dataclass(frozen=True)
class ControlFlowEdgeRelation:
    module_path: str
    prototype_id: str
    source_pc: int
    target_pc: int
    provenance: str


@dataclass(frozen=True)
class DominatorTreeIntervalRelation:
    module_path: str
    prototype_id: str
    pc: int
    start: int
    end: int
    provenance: str


@dataclass(frozen=True)
class TableFieldFlowRelation:
    module_path: str
    prototype_id: str
    table_ref: str
    field_name: str
    write_ref: str
    read_ref: str
    provenance: str


@dataclass(frozen=True)
class GlobalFlowRelation:
    module_path: str
    prototype_id: str
    global_name: str
    write_ref: str
    read_ref: str
    value_ref: str
    provenance: str


@dataclass(frozen=True)
class UpvalueFlowRelation:
    module_path: str
    prototype_id: str
    upvalue_id: str
    capture_ref: str
    read_ref: str
    write_ref: str
    provenance: str


@dataclass(frozen=True)
class CallResolutionRelation:
    caller_module_path: str
    caller_prototype_id: str
    callsite_id: str
    target_value_ref: str
    resolved_name: str
    resolution_kind: str
    target_module_path: str
    target_prototype_id: str
    provenance: str


@dataclass(frozen=True)
class LiteralRequireRelation:
    caller_module_path: str
    caller_prototype_id: str
    callsite_id: str
    require_string: str
    argument_ref: str
    provenance: str


@dataclass(frozen=True)
class ModuleResolutionRelation:
    caller_module_path: str
    callsite_id: str
    require_string: str
    status: str
    target_module_path: str
    reason: str
    provenance: str


@dataclass(frozen=True)
class ModuleExportRelation:
    module_path: str
    export_kind: str
    field_name: str
    value_ref: str
    target_prototype_id: str
    provenance: str


@dataclass(frozen=True)
class InterproceduralFlowRelation:
    caller_module_path: str
    caller_prototype_id: str
    callsite_id: str
    callee_module_path: str
    callee_prototype_id: str
    source_ref: str
    sink_ref: str
    flow_kind: str
    position: int
    provenance: str


@dataclass(frozen=True)
class AnalysisBoundary:
    module_path: str
    prototype_id: str
    site_id: str
    boundary_kind: str
    reason: str
    provenance: str


@dataclass(frozen=True)
class AnalysisResult:
    artifact_identities: tuple[ArtifactIdentityRelation, ...]
    prototype_identities: tuple[PrototypeIdentityRelation, ...]
    instruction_identities: tuple[InstructionIdentityRelation, ...]
    value_identities: tuple[ValueIdentityRelation, ...]
    value_flows: tuple[ValueFlowRelation, ...]
    control_flow_edges: tuple[ControlFlowEdgeRelation, ...]
    dominator_tree_intervals: tuple[DominatorTreeIntervalRelation, ...]
    table_field_flows: tuple[TableFieldFlowRelation, ...]
    global_flows: tuple[GlobalFlowRelation, ...]
    upvalue_flows: tuple[UpvalueFlowRelation, ...]
    call_resolutions: tuple[CallResolutionRelation, ...]
    literal_requires: tuple[LiteralRequireRelation, ...]
    module_resolutions: tuple[ModuleResolutionRelation, ...]
    module_exports: tuple[ModuleExportRelation, ...]
    interprocedural_flows: tuple[InterproceduralFlowRelation, ...]
    boundaries: tuple[AnalysisBoundary, ...]


def _validate_module_path(module_path: str) -> None:
    path = PurePosixPath(module_path)
    if (
        not module_path
        or "\\" in module_path
        or path.is_absolute()
        or str(path) != module_path
        or ".." in path.parts
    ):
        raise ValueError(f"module path must be normalized and source-root-relative: {module_path!r}")


def _walk_prototypes(
    module_path: str,
    chunk: Chunk,
    prototype_id: str,
    parent_prototype_id: str,
    ordinal_index: int,
    captured_table_by_upvalue: dict[int, str] | None = None,
    table_object_values: dict[str, set[str]] | None = None,
    table_field_writes: dict[tuple[str, str], set[str]] | None = None,
) -> tuple[
    list[PrototypeIdentityRelation],
    list[InstructionIdentityRelation],
    list[ValueIdentityRelation],
    list[ValueFlowRelation],
    list[TableFieldFlowRelation],
    list[GlobalFlowRelation],
    list[UpvalueFlowRelation],
    list[AnalysisBoundary],
]:
    if captured_table_by_upvalue is None:
        captured_table_by_upvalue = {}
    if table_object_values is None:
        table_object_values = defaultdict(set)
    if table_field_writes is None:
        table_field_writes = defaultdict(set)

    prototypes = [
        PrototypeIdentityRelation(
            module_path=module_path,
            prototype_id=prototype_id,
            parent_prototype_id=parent_prototype_id,
            ordinal_index=ordinal_index,
            num_params=chunk.num_params,
            is_vararg=chunk.is_vararg,
            max_stack=chunk.max_stack,
            upvalue_count=chunk.num_upvalues,
        )
    ]
    instructions = [
        InstructionIdentityRelation(
            module_path=module_path,
            prototype_id=prototype_id,
            pc=pc,
            opcode=instruction.opcode.name,
            operand_a=instruction.a,
            operand_b=instruction.b,
            operand_c=instruction.c,
        )
        for pc, instruction in enumerate(chunk.instructions)
    ]
    values = [
        ValueIdentityRelation(
            module_path=module_path,
            prototype_id=prototype_id,
            value_ref=f"{prototype_id}:r{slot}",
            value_kind="entry-register",
            pc=-1,
            slot=slot,
        )
        for slot in range(chunk.num_params)
    ]
    flows = _prototype_value_flows(module_path, prototype_id, chunk)
    table_flows, table_object_flows, captured_table_candidates = _prototype_table_flows(
        module_path,
        prototype_id,
        chunk,
        captured_table_by_upvalue,
        table_object_values,
        table_field_writes,
    )
    global_flows = _prototype_global_flows(module_path, prototype_id, chunk)
    flows.extend(table_object_flows)
    upvalue_flows: list[UpvalueFlowRelation] = []
    boundaries = _prototype_boundaries(module_path, prototype_id, chunk)

    for child_index, child in enumerate(chunk.protos):
        child_id = f"{prototype_id}.{child_index}"
        child_capture_flows, child_capture_boundaries = _child_upvalue_analysis(
            module_path,
            prototype_id,
            chunk,
            child_id,
            child,
            child_index,
        )
        upvalue_flows.extend(child_capture_flows)
        boundaries.extend(child_capture_boundaries)
        (
            child_prototypes,
            child_instructions,
            child_values,
            child_flows,
            child_table_flows,
            child_global_flows,
            child_upvalue_flows,
            child_boundaries,
        ) = _walk_prototypes(
            module_path,
            child,
            child_id,
            prototype_id,
            child_index,
            {
                upvalue_index: next(iter(table_refs))
                for (candidate_child_index, upvalue_index), table_refs
                in captured_table_candidates.items()
                if candidate_child_index == child_index and len(table_refs) == 1
            },
            defaultdict(
                set,
                {
                    table_ref: set(value_refs)
                    for table_ref, value_refs in table_object_values.items()
                },
            ),
            defaultdict(
                set,
                {
                    field: set(write_refs)
                    for field, write_refs in table_field_writes.items()
                },
            ),
        )
        prototypes.extend(child_prototypes)
        instructions.extend(child_instructions)
        values.extend(child_values)
        flows.extend(child_flows)
        table_flows.extend(child_table_flows)
        global_flows.extend(child_global_flows)
        upvalue_flows.extend(child_upvalue_flows)
        boundaries.extend(child_boundaries)

    return (
        prototypes,
        instructions,
        values,
        flows,
        table_flows,
        global_flows,
        upvalue_flows,
        boundaries,
    )


def _prototype_boundaries(
    module_path: str,
    prototype_id: str,
    chunk: Chunk,
) -> list[AnalysisBoundary]:
    boundaries: list[AnalysisBoundary] = []
    for pc, instruction in enumerate(chunk.instructions):
        opcode = instruction.opcode.name
        kinds_and_reasons: list[tuple[str, str]] = []
        if opcode == "CALL" and instruction.b == 0:
            kinds_and_reasons.append(
                (
                    "open-call-argument-tail",
                    "only predecessor-proven argument slots are modeled",
                )
            )
        if opcode == "TAILCALL" and instruction.b == 0:
            kinds_and_reasons.append(
                (
                    "open-tailcall-argument-tail",
                    "only predecessor-proven argument slots are modeled",
                )
            )
        if opcode == "CALL" and instruction.c == 0:
            kinds_and_reasons.append(
                (
                    "open-call-result-tail",
                    "only the open producer base result is modeled",
                )
            )
        if opcode == "RETURN" and instruction.b == 0:
            kinds_and_reasons.append(
                (
                    "open-return-tail",
                    "only predecessor-proven return slots are modeled",
                )
            )
        if opcode == "VARARG" and instruction.b == 0:
            kinds_and_reasons.append(
                (
                    "open-vararg-tail",
                    "only the open vararg base result is modeled",
                )
            )
        for boundary_kind, reason in kinds_and_reasons:
            boundaries.append(
                AnalysisBoundary(
                    module_path=module_path,
                    prototype_id=prototype_id,
                    site_id=f"{prototype_id}@pc{pc}",
                    boundary_kind=boundary_kind,
                    reason=reason,
                    provenance="bytecode-only,open-slot-boundary",
                )
            )
    return boundaries


def _fixed_instruction_effects(
    opcode: str,
    operand_a: int,
    operand_b: int,
    operand_c: int,
) -> tuple[tuple[int, ...], tuple[int, ...], tuple[int, ...]] | None:
    if opcode == "MOVE":
        return (operand_b,), (operand_a,), (operand_b,)
    if opcode in {"CLOSURE", "LOADBOOL", "LOADK"}:
        return (), (operand_a,), ()
    if opcode == "LOADNIL":
        return (), tuple(range(operand_a, operand_b + 1)), ()
    if opcode == "NEWTABLE":
        return (operand_a,), (operand_a,), (operand_a,)
    if opcode in {"GETUPVAL", "GETGLOBAL"}:
        return (), (operand_a,), ()
    if opcode in {"SETGLOBAL", "SETUPVAL"}:
        return (operand_a,), (), ()
    if opcode == "GETTABLE":
        reads = (operand_b,) + (
            () if operand_c >= LUA_RK_CONSTANT_BIT else (operand_c,)
        )
        return reads, (operand_a,), (operand_b,)
    if opcode == "SETTABLE":
        reads = (operand_a,)
        if operand_b < LUA_RK_CONSTANT_BIT:
            reads += (operand_b,)
        if operand_c < LUA_RK_CONSTANT_BIT:
            reads += (operand_c,)
        return reads, (), ()
    if opcode == "SELF":
        reads = (operand_b,) + (
            () if operand_c >= LUA_RK_CONSTANT_BIT else (operand_c,)
        )
        return reads, (operand_a, operand_a + 1), reads
    if opcode == "CALL":
        reads = (
            (operand_a,)
            if operand_b == 0
            else tuple(range(operand_a, operand_a + operand_b))
        )
        writes = (
            (operand_a,)
            if operand_c == 0
            else tuple(range(operand_a, operand_a + operand_c - 1))
        )
        return reads, writes, tuple(slot for slot in reads if slot > operand_a)
    if opcode == "TAILCALL":
        if operand_b == 0:
            return (operand_a,), (), ()
        reads = tuple(range(operand_a, operand_a + operand_b))
        return reads, (), tuple(slot for slot in reads if slot > operand_a)
    if opcode == "RETURN":
        reads = (
            ()
            if operand_b == 0
            else tuple(range(operand_a, operand_a + operand_b - 1))
        )
        return reads, (), ()
    if opcode == "VARARG":
        writes = (
            (operand_a,)
            if operand_b == 0
            else tuple(range(operand_a, operand_a + operand_b - 1))
        )
        return (), writes, ()
    if opcode in {"ADD", "SUB", "MUL", "DIV", "MOD", "POW"}:
        reads = tuple(
            slot
            for slot in (operand_b, operand_c)
            if slot < LUA_RK_CONSTANT_BIT
        )
        return reads, (operand_a,), reads
    if opcode in {"UNM", "NOT", "LEN"}:
        return (operand_b,), (operand_a,), (operand_b,)
    if opcode == "CONCAT":
        reads = tuple(range(operand_b, operand_c + 1))
        return reads, (operand_a,), reads
    if opcode == "SETLIST":
        if operand_b == 0:
            return None
        return tuple(range(operand_a, operand_a + operand_b + 1)), (), ()
    if opcode in {"EQ", "LT", "LE"}:
        reads = tuple(
            slot
            for slot in (operand_b, operand_c)
            if slot < LUA_RK_CONSTANT_BIT
        )
        return reads, (), ()
    if opcode == "TESTSET":
        return (operand_b,), (operand_a,), (operand_b,)
    if opcode == "TFORLOOP":
        reads = (operand_a, operand_a + 1, operand_a + 2)
        writes = tuple(range(operand_a + 3, operand_a + 3 + operand_c)) + (
            operand_a + 2,
        )
        return reads, writes, (operand_a + 1, operand_a + 2)
    if opcode in {"FORLOOP", "FORPREP"}:
        return (
            (operand_a, operand_a + 1, operand_a + 2),
            (operand_a, operand_a + 2),
            (),
        )
    if opcode == "TEST":
        return (operand_a,), (), ()
    if opcode == "JMP":
        return (), (), ()
    if opcode == "CLOSE":
        return (), (), ()
    return None


def _closure_binding_pcs(chunk: Chunk) -> set[int]:
    binding_pcs: set[int] = set()
    for closure_pc, instruction in enumerate(chunk.instructions):
        if instruction.opcode.name != "CLOSURE" or instruction.b >= len(chunk.protos):
            continue
        child = chunk.protos[instruction.b]
        for offset in range(1, child.num_upvalues + 1):
            binding_pc = closure_pc + offset
            if binding_pc >= len(chunk.instructions):
                break
            binding = chunk.instructions[binding_pc]
            if binding.opcode.name not in {"MOVE", "GETUPVAL"}:
                break
            binding_pcs.add(binding_pc)
    return binding_pcs


def _control_flow_successors(
    instructions_by_pc: dict[int, tuple[str, int, int, int]],
) -> dict[int, set[int]]:
    pcs = sorted(instructions_by_pc)
    pc_set = set(pcs)
    successors = {pc: set() for pc in pcs}
    for index, pc in enumerate(pcs):
        opcode, _, operand_b, _ = instructions_by_pc[pc]
        next_pc = pcs[index + 1] if index + 1 < len(pcs) else None
        next_next_pc = pcs[index + 2] if index + 2 < len(pcs) else None
        if opcode in {"RETURN", "TAILCALL"}:
            continue
        if opcode == "JMP":
            target = pc + 1 + operand_b
            if target in pc_set:
                successors[pc].add(target)
        elif opcode in {"EQ", "LT", "LE", "TEST", "TESTSET", "TFORLOOP"}:
            if next_pc is not None:
                successors[pc].add(next_pc)
            if next_next_pc is not None:
                successors[pc].add(next_next_pc)
        elif opcode == "FORLOOP":
            target = pc + 1 + operand_b
            if target in pc_set:
                successors[pc].add(target)
            if next_pc is not None:
                successors[pc].add(next_pc)
        elif opcode == "FORPREP":
            target = pc + 1 + operand_b
            if target in pc_set:
                successors[pc].add(target)
        elif next_pc is not None:
            successors[pc].add(next_pc)
    return successors


def _control_flow_edges(
    instructions: list[InstructionIdentityRelation],
) -> list[ControlFlowEdgeRelation]:
    by_prototype: dict[
        tuple[str, str], dict[int, tuple[str, int, int, int]]
    ] = defaultdict(dict)
    for instruction in instructions:
        by_prototype[(instruction.module_path, instruction.prototype_id)][
            instruction.pc
        ] = (
            instruction.opcode,
            instruction.operand_a,
            instruction.operand_b,
            instruction.operand_c,
        )

    edges: list[ControlFlowEdgeRelation] = []
    for (module_path, prototype_id), instructions_by_pc in sorted(
        by_prototype.items()
    ):
        for source_pc, targets in sorted(
            _control_flow_successors(instructions_by_pc).items()
        ):
            for target_pc in sorted(targets):
                edges.append(
                    ControlFlowEdgeRelation(
                        module_path=module_path,
                        prototype_id=prototype_id,
                        source_pc=source_pc,
                        target_pc=target_pc,
                        provenance="bytecode-only,cfg-successor",
                    )
                )
    return edges


def _reverse_postorder(
    successors: dict[int, set[int]], entry: int
) -> list[int]:
    visited: set[int] = set()
    postorder: list[int] = []
    pending = [(entry, False)]
    while pending:
        pc, expanded = pending.pop()
        if expanded:
            postorder.append(pc)
            continue
        if pc in visited:
            continue
        visited.add(pc)
        pending.append((pc, True))
        for target in sorted(successors.get(pc, set()), reverse=True):
            if target not in visited:
                pending.append((target, False))
    return list(reversed(postorder))


def _prototype_dominator_tree_intervals(
    module_path: str,
    prototype_id: str,
    instructions_by_pc: dict[int, tuple[str, int, int, int]],
) -> list[DominatorTreeIntervalRelation]:
    if not instructions_by_pc:
        return []
    # Preserve every feasible static-field definition at CFG joins.
    successors = _control_flow_successors(instructions_by_pc)
    entry = min(instructions_by_pc)
    reverse_postorder = _reverse_postorder(successors, entry)
    order = {pc: index for index, pc in enumerate(reverse_postorder)}
    predecessors: dict[int, set[int]] = defaultdict(set)
    for source, targets in successors.items():
        for target in targets:
            predecessors[target].add(source)

    immediate_dominator = {entry: entry}

    def intersect(left: int, right: int) -> int:
        while left != right:
            while order[left] > order[right]:
                left = immediate_dominator[left]
            while order[right] > order[left]:
                right = immediate_dominator[right]
        return left

    changed = True
    while changed:
        changed = False
        for pc in reverse_postorder[1:]:
            defined_predecessors = sorted(
                predecessor
                for predecessor in predecessors.get(pc, set())
                if predecessor in immediate_dominator
            )
            if not defined_predecessors:
                continue
            new_dominator = defined_predecessors[0]
            for predecessor in defined_predecessors[1:]:
                new_dominator = intersect(predecessor, new_dominator)
            if immediate_dominator.get(pc) != new_dominator:
                immediate_dominator[pc] = new_dominator
                changed = True

    children: dict[int, list[int]] = defaultdict(list)
    for pc, dominator in immediate_dominator.items():
        if pc != entry:
            children[dominator].append(pc)
    intervals: dict[int, tuple[int, int]] = {}
    starts: dict[int, int] = {}
    next_start = 0
    pending = [(entry, False)]
    while pending:
        pc, expanded = pending.pop()
        if expanded:
            intervals[pc] = (starts[pc], next_start - 1)
            continue
        starts[pc] = next_start
        next_start += 1
        pending.append((pc, True))
        for child in sorted(children.get(pc, ()), reverse=True):
            pending.append((child, False))

    return [
        DominatorTreeIntervalRelation(
            module_path=module_path,
            prototype_id=prototype_id,
            pc=pc,
            start=start,
            end=end,
            provenance="bytecode-only,immediate-dominator-tree",
        )
        for pc, (start, end) in sorted(intervals.items())
    ]


def _dominator_tree_intervals(
    instructions: list[InstructionIdentityRelation],
) -> list[DominatorTreeIntervalRelation]:
    by_prototype: dict[
        tuple[str, str], dict[int, tuple[str, int, int, int]]
    ] = defaultdict(dict)
    for instruction in instructions:
        by_prototype[(instruction.module_path, instruction.prototype_id)][
            instruction.pc
        ] = (
            instruction.opcode,
            instruction.operand_a,
            instruction.operand_b,
            instruction.operand_c,
        )
    intervals: list[DominatorTreeIntervalRelation] = []
    for (module_path, prototype_id), instructions_by_pc in sorted(
        by_prototype.items()
    ):
        intervals.extend(
            _prototype_dominator_tree_intervals(
                module_path, prototype_id, instructions_by_pc
            )
        )
    return intervals


def _join_states(states: list[dict[int, set[str]]]) -> dict[int, set[str]]:
    joined: dict[int, set[str]] = {}
    for state in states:
        for slot, refs in state.items():
            joined.setdefault(slot, set()).update(refs)
    return joined


def _state_dependent_effects(
    instruction: tuple[str, int, int, int],
    fixed_effects: tuple[tuple[int, ...], tuple[int, ...], tuple[int, ...]],
    state: dict[int, set[str]],
    open_top_floor: int | None,
) -> tuple[tuple[int, ...], tuple[int, ...], tuple[int, ...]]:
    opcode, operand_a, operand_b, _ = instruction
    reads, writes, dependencies = fixed_effects
    if opcode in {"CALL", "TAILCALL"} and operand_b == 0:
        open_arguments = (
            ()
            if open_top_floor is None
            else tuple(
                sorted(
                    slot
                    for slot in state
                    if slot > operand_a
                )
            )
        )
        return (operand_a,) + open_arguments, writes, open_arguments
    if opcode == "RETURN" and operand_b == 0:
        open_returns = (
            ()
            if open_top_floor is None
            else tuple(
                sorted(
                    slot
                    for slot in state
                    if slot >= operand_a and slot >= open_top_floor
                )
            )
        )
        return open_returns, writes, dependencies
    return fixed_effects


def _open_top_floor(
    pc: int,
    predecessors: dict[int, set[int]],
    instructions_by_pc: dict[int, tuple[str, int, int, int]],
) -> int | None:
    incoming = predecessors.get(pc, set())
    if len(incoming) != 1:
        return None
    predecessor = instructions_by_pc[next(iter(incoming))]
    opcode, operand_a, operand_b, operand_c = predecessor
    if opcode == "CALL" and operand_c == 0:
        return operand_a
    if opcode == "VARARG" and operand_b == 0:
        return operand_a
    return None


def _prototype_value_flows(
    module_path: str,
    prototype_id: str,
    chunk: Chunk,
) -> list[ValueFlowRelation]:
    entry_state = {
        slot: {f"{prototype_id}:r{slot}"}
        for slot in range(chunk.num_params)
    }
    effects_by_pc: dict[int, tuple[tuple[int, ...], tuple[int, ...], tuple[int, ...]]] = {}
    instructions_by_pc: dict[int, tuple[str, int, int, int]] = {}
    closure_binding_pcs = _closure_binding_pcs(chunk)
    for pc, instruction in enumerate(chunk.instructions):
        if pc in closure_binding_pcs:
            effects = (
                ((instruction.b,), (), ())
                if instruction.opcode.name == "MOVE"
                else ((), (), ())
            )
        else:
            effects = _fixed_instruction_effects(
                instruction.opcode.name,
                instruction.a,
                instruction.b,
                instruction.c,
            )
        if effects is None:
            break
        effects_by_pc[pc] = effects
        instructions_by_pc[pc] = (
            instruction.opcode.name,
            instruction.a,
            instruction.b,
            instruction.c,
        )

    if not effects_by_pc:
        return []

    successors = _control_flow_successors(instructions_by_pc)
    predecessors: dict[int, set[int]] = defaultdict(set)
    for pc, targets in successors.items():
        for target in targets:
            predecessors[target].add(pc)

    pcs = sorted(effects_by_pc)
    in_states: dict[int, dict[int, set[str]]] = {pc: {} for pc in pcs}
    out_states: dict[int, dict[int, set[str]]] = {pc: {} for pc in pcs}
    pending = deque(pcs)
    queued = set(pcs)
    while pending:
        pc = pending.popleft()
        queued.remove(pc)
        incoming = [out_states[pred] for pred in predecessors.get(pc, set())]
        if pc == pcs[0]:
            incoming.append(entry_state)
        joined = _join_states(incoming)
        in_states[pc] = joined
        next_state = {slot: set(refs) for slot, refs in joined.items()}
        opcode, operand_a, operand_b, operand_c = instructions_by_pc[pc]
        _, write_slots, _ = effects_by_pc[pc]
        if (opcode == "CALL" and operand_c == 0) or (
            opcode == "VARARG" and operand_b == 0
        ):
            for slot in tuple(next_state):
                if slot >= operand_a:
                    del next_state[slot]
        for slot in write_slots:
            write_ref = f"{prototype_id}@pc{pc}:r{slot}"
            preserves_prior_definition = opcode == "FORLOOP" or (
                opcode == "CONCAT" and operand_b <= slot <= operand_c
            )
            if preserves_prior_definition:
                next_state.setdefault(slot, set()).add(write_ref)
            else:
                next_state[slot] = {write_ref}
        if next_state != out_states[pc]:
            out_states[pc] = next_state
            for target in successors.get(pc, set()):
                if target not in queued:
                    pending.append(target)
                    queued.add(target)

    flows: list[ValueFlowRelation] = []
    for pc in pcs:
        read_slots, write_slots, dependency_slots = _state_dependent_effects(
            instructions_by_pc[pc],
            effects_by_pc[pc],
            in_states[pc],
            _open_top_floor(pc, predecessors, instructions_by_pc),
        )
        read_refs = {
            slot: f"{prototype_id}@pc{pc}:r{slot}"
            for slot in read_slots
        }
        write_refs = {
            slot: f"{prototype_id}@pc{pc}:r{slot}"
            for slot in write_slots
        }
        for slot, read_ref in read_refs.items():
            for source_ref in sorted(in_states[pc].get(slot, set())):
                flows.append(
                    ValueFlowRelation(
                        module_path=module_path,
                        prototype_id=prototype_id,
                        source_ref=source_ref,
                        sink_ref=read_ref,
                        kind="reaching-definition",
                        provenance="bytecode-only,cfg-rda",
                    )
                )
        for slot in dependency_slots:
            read_ref = read_refs[slot]
            for write_ref in write_refs.values():
                flows.append(
                    ValueFlowRelation(
                        module_path=module_path,
                        prototype_id=prototype_id,
                        source_ref=read_ref,
                        sink_ref=write_ref,
                        kind="same-instruction-dependence",
                        provenance="bytecode-only,cfg-rda",
                    )
                )
    return flows


def _constant_string(chunk: Chunk, index: int) -> str | None:
    if index >= len(chunk.constants):
        return None
    constant = chunk.constants[index]
    if constant.type_name != "string":
        return None
    return constant.text()


def _constant_string_operand(chunk: Chunk, operand: int) -> str | None:
    if operand < LUA_RK_CONSTANT_BIT:
        return None
    return _constant_string(chunk, operand - LUA_RK_CONSTANT_BIT)


def _prototype_global_flows(
    module_path: str,
    prototype_id: str,
    chunk: Chunk,
) -> list[GlobalFlowRelation]:
    global_writes: dict[str, str] = {}
    flows: list[GlobalFlowRelation] = []

    for pc, instruction in enumerate(chunk.instructions):
        opcode = instruction.opcode.name
        if opcode == "SETGLOBAL":
            global_name = _constant_string(chunk, instruction.b)
            if global_name:
                global_writes[global_name] = f"{prototype_id}@pc{pc}:r{instruction.a}"
        elif opcode == "GETGLOBAL":
            global_name = _constant_string(chunk, instruction.b)
            if global_name and global_name in global_writes:
                write_ref = global_writes[global_name]
                flows.append(
                    GlobalFlowRelation(
                        module_path=module_path,
                        prototype_id=prototype_id,
                        global_name=global_name,
                        write_ref=write_ref,
                        read_ref=f"{prototype_id}@pc{pc}:r{instruction.a}",
                        value_ref=write_ref,
                        provenance="bytecode-only,precise-global-state",
                    )
                )

    return flows


def _child_upvalue_analysis(
    module_path: str,
    parent_prototype_id: str,
    parent_chunk: Chunk,
    child_prototype_id: str,
    child_chunk: Chunk,
    child_index: int,
) -> tuple[list[UpvalueFlowRelation], list[AnalysisBoundary]]:
    first_write_by_upvalue: dict[int, str] = {}
    for pc, instruction in enumerate(child_chunk.instructions):
        if instruction.opcode.name == "SETUPVAL":
            first_write_by_upvalue.setdefault(
                instruction.b,
                f"{child_prototype_id}@pc{pc}:r{instruction.a}",
            )

    flows: list[UpvalueFlowRelation] = []
    boundaries: list[AnalysisBoundary] = []
    for closure_pc, closure in enumerate(parent_chunk.instructions):
        if closure.opcode.name != "CLOSURE" or closure.b != child_index:
            continue
        for upvalue_index in range(child_chunk.num_upvalues):
            binding_pc = closure_pc + 1 + upvalue_index
            if binding_pc >= len(parent_chunk.instructions):
                boundaries.append(
                    AnalysisBoundary(
                        module_path=module_path,
                        prototype_id=parent_prototype_id,
                        site_id=f"{parent_prototype_id}@pc{closure_pc}:u{upvalue_index}",
                        boundary_kind="malformed-upvalue-capture",
                        reason=(
                            f"upvalue {upvalue_index} binding after "
                            f"{parent_prototype_id}@pc{closure_pc} is missing"
                        ),
                        provenance="bytecode-only,upvalue-capture-boundary",
                    )
                )
                continue
            binding = parent_chunk.instructions[binding_pc]
            if binding.opcode.name not in {"MOVE", "GETUPVAL"}:
                boundaries.append(
                    AnalysisBoundary(
                        module_path=module_path,
                        prototype_id=parent_prototype_id,
                        site_id=f"{parent_prototype_id}@pc{closure_pc}:u{upvalue_index}",
                        boundary_kind="malformed-upvalue-capture",
                        reason=(
                            f"upvalue {upvalue_index} binding at "
                            f"{parent_prototype_id}@pc{binding_pc} must use "
                            "MOVE or GETUPVAL"
                        ),
                        provenance="bytecode-only,upvalue-capture-boundary",
                    )
                )
                continue
            capture_slot = binding.b if binding.opcode.name == "MOVE" else binding.a
            capture_ref = f"{parent_prototype_id}@pc{binding_pc}:r{capture_slot}"
            upvalue_id = f"{child_prototype_id}:u{upvalue_index}"
            write_ref = first_write_by_upvalue.get(upvalue_index, "")
            for read_pc, instruction in enumerate(child_chunk.instructions):
                if (
                    instruction.opcode.name == "GETUPVAL"
                    and instruction.b == upvalue_index
                ):
                    flows.append(
                        UpvalueFlowRelation(
                            module_path=module_path,
                            prototype_id=child_prototype_id,
                            upvalue_id=upvalue_id,
                            capture_ref=capture_ref,
                            read_ref=(
                                f"{child_prototype_id}@pc{read_pc}:r{instruction.a}"
                            ),
                            write_ref=write_ref,
                            provenance="bytecode-only,derived-upvalue-flow",
                        )
                    )
    return flows, boundaries


def _prototype_table_flows(
    module_path: str,
    prototype_id: str,
    chunk: Chunk,
    captured_table_by_upvalue: dict[int, str],
    object_values: dict[str, set[str]],
    field_writes: dict[tuple[str, str], set[str]],
) -> tuple[
    list[TableFieldFlowRelation],
    list[ValueFlowRelation],
    dict[tuple[int, int], set[str]],
]:
    entry_field_writes = {
        field: set(write_refs) for field, write_refs in field_writes.items()
    }
    table_objects: dict[int, str] = {}
    captured_table_candidates: dict[tuple[int, int], set[str]] = defaultdict(set)
    object_flows: list[ValueFlowRelation] = []
    instructions_by_pc: dict[int, tuple[str, int, int, int]] = {}
    field_write_by_pc: dict[
        int, tuple[tuple[str, str], str | None]
    ] = {}
    field_read_by_pc: dict[int, tuple[tuple[str, str], str]] = {}
    closure_binding_pcs = _closure_binding_pcs(chunk)
    closure_binding_sites: dict[int, tuple[int, int]] = {}
    for closure_pc, closure in enumerate(chunk.instructions):
        if closure.opcode.name != "CLOSURE" or closure.b >= len(chunk.protos):
            continue
        for upvalue_index in range(chunk.protos[closure.b].num_upvalues):
            closure_binding_sites[closure_pc + upvalue_index + 1] = (
                closure.b,
                upvalue_index,
            )

    for pc, instruction in enumerate(chunk.instructions):
        opcode = instruction.opcode.name
        is_closure_binding = pc in closure_binding_pcs
        if is_closure_binding:
            table_ref = (
                table_objects.get(instruction.b)
                if opcode == "MOVE"
                else captured_table_by_upvalue.get(instruction.b)
                if opcode == "GETUPVAL"
                else None
            )
            if table_ref is not None:
                captured_table_candidates[closure_binding_sites[pc]].add(table_ref)
        if is_closure_binding:
            effects = (
                ((instruction.b,), (), ())
                if opcode == "MOVE"
                else ((), (), ())
            )
        else:
            effects = _fixed_instruction_effects(
                opcode,
                instruction.a,
                instruction.b,
                instruction.c,
            )
        if effects is None:
            break
        instructions_by_pc[pc] = (
            opcode,
            instruction.a,
            instruction.b,
            instruction.c,
        )

        moved_table_ref = (
            table_objects.get(instruction.b)
            if opcode == "MOVE" and not is_closure_binding
            else None
        )
        if opcode == "SETTABLE" and instruction.a not in table_objects:
            table_objects[instruction.a] = (
                f"{prototype_id}@pc{pc}:r{instruction.a}"
            )
        for slot in effects[0]:
            table_ref = table_objects.get(slot)
            if table_ref is None:
                continue
            for source_ref in sorted(object_values.get(table_ref, set())):
                object_flows.append(
                    ValueFlowRelation(
                        module_path=module_path,
                        prototype_id=prototype_id,
                        source_ref=source_ref,
                        sink_ref=f"{prototype_id}@pc{pc}:r{slot}",
                        kind="table-object-dependence",
                        provenance="bytecode-only,mutable-table-object",
                    )
                )

        if opcode == "SETTABLE":
            table_ref = table_objects.get(instruction.a)
            field_name = _constant_string_operand(chunk, instruction.b)
            field_key = (
                (table_ref, field_name)
                if table_ref is not None and field_name is not None
                else None
            )
            if field_key is not None:
                field_write_by_pc[pc] = (field_key, None)
            if table_ref is not None and instruction.c < LUA_RK_CONSTANT_BIT:
                value_ref = f"{prototype_id}@pc{pc}:r{instruction.c}"
                object_values[table_ref].add(value_ref)
                if field_key is not None:
                    field_write_by_pc[pc] = (field_key, value_ref)
        elif opcode == "SETLIST":
            table_ref = table_objects.get(instruction.a)
            if table_ref is not None:
                for slot in range(instruction.a + 1, instruction.a + instruction.b + 1):
                    object_values[table_ref].add(f"{prototype_id}@pc{pc}:r{slot}")
        elif opcode == "GETTABLE":
            table_ref = table_objects.get(instruction.b)
            field_name = _constant_string_operand(chunk, instruction.c)
            if table_ref is not None and field_name is not None:
                field_read_by_pc[pc] = (
                    (table_ref, field_name),
                    f"{prototype_id}@pc{pc}:r{instruction.a}",
                )

        for slot in effects[1]:
            table_objects.pop(slot, None)
        if opcode == "NEWTABLE":
            table_objects[instruction.a] = f"{prototype_id}@pc{pc}:r{instruction.a}"
        elif moved_table_ref is not None:
            table_objects[instruction.a] = moved_table_ref
        elif opcode == "GETUPVAL" and not is_closure_binding:
            captured_table_ref = captured_table_by_upvalue.get(instruction.b)
            if captured_table_ref is not None:
                table_objects[instruction.a] = captured_table_ref

    successors = _control_flow_successors(instructions_by_pc)
    predecessors: dict[int, set[int]] = defaultdict(set)
    for source_pc, target_pcs in successors.items():
        for target_pc in target_pcs:
            predecessors[target_pc].add(source_pc)

    pcs = sorted(instructions_by_pc)
    in_states: dict[int, dict[tuple[str, str], set[str]]] = {
        pc: {} for pc in pcs
    }
    out_states: dict[int, dict[tuple[str, str], set[str]]] = {
        pc: {} for pc in pcs
    }
    pending = deque(pcs)
    queued = set(pcs)
    while pending:
        pc = pending.popleft()
        queued.remove(pc)
        incoming = [out_states[pred] for pred in predecessors.get(pc, set())]
        if pc == pcs[0]:
            incoming.append(entry_field_writes)
        joined: dict[tuple[str, str], set[str]] = defaultdict(set)
        for state in incoming:
            for field_key, write_refs in state.items():
                joined[field_key].update(write_refs)
        in_states[pc] = dict(joined)
        next_state = {
            field_key: set(write_refs)
            for field_key, write_refs in joined.items()
        }
        field_write = field_write_by_pc.get(pc)
        if field_write is not None:
            field_key, write_ref = field_write
            next_state[field_key] = {write_ref} if write_ref is not None else set()
        if next_state != out_states[pc]:
            out_states[pc] = next_state
            for target_pc in successors.get(pc, set()):
                if target_pc not in queued:
                    pending.append(target_pc)
                    queued.add(target_pc)

    field_flows: list[TableFieldFlowRelation] = []
    for pc, (field_key, read_ref) in sorted(field_read_by_pc.items()):
        table_ref, field_name = field_key
        for write_ref in sorted(in_states[pc].get(field_key, set())):
            field_flows.append(
                TableFieldFlowRelation(
                    module_path=module_path,
                    prototype_id=prototype_id,
                    table_ref=table_ref,
                    field_name=field_name,
                    write_ref=write_ref,
                    read_ref=read_ref,
                    provenance="bytecode-only,precise-table-field",
                )
            )

    exit_state: dict[tuple[str, str], set[str]] = defaultdict(set)
    for pc in pcs:
        if not successors.get(pc):
            for field_key, write_refs in out_states[pc].items():
                exit_state[field_key].update(write_refs)
    field_writes.clear()
    for field_key, write_refs in exit_state.items():
        if write_refs:
            field_writes[field_key].update(write_refs)

    return field_flows, object_flows, captured_table_candidates


def _chunks_by_prototype(root_chunk: Chunk) -> dict[str, Chunk]:
    chunks: dict[str, Chunk] = {}
    pending = [("root", root_chunk)]
    while pending:
        prototype_id, chunk = pending.pop()
        chunks[prototype_id] = chunk
        pending.extend(
            (f"{prototype_id}.{child_index}", child)
            for child_index, child in enumerate(chunk.protos)
        )
    return chunks


def _closure_debug_local_name(
    instruction: InstructionIdentityRelation,
    chunk: Chunk,
) -> str | None:
    if instruction.opcode != "CLOSURE":
        return None
    activation_pc = instruction.pc + 1
    active_locals = [
        local
        for local in chunk.locals
        if local.start <= activation_pc < local.end
    ]
    if instruction.operand_a >= len(active_locals):
        return None
    local = active_locals[instruction.operand_a]
    if local.start != activation_pc or not local.name:
        return None
    return local.name


def _reaching_global_member_names(
    call: InstructionIdentityRelation,
    chunks_by_prototype: dict[str, Chunk],
    instruction_by_result_ref: dict[str, InstructionIdentityRelation],
    reaching_sources_by_ref: dict[str, set[str]],
    call_result_name_by_ref: dict[str, str],
) -> set[str]:
    target_ref = f"{call.prototype_id}@pc{call.pc}:r{call.operand_a}"

    def names_for_ref(source_ref: str, active: frozenset[str]) -> set[str]:
        if source_ref in active:
            return set()
        call_result_name = call_result_name_by_ref.get(source_ref)
        if call_result_name is not None:
            return {call_result_name}
        instruction = instruction_by_result_ref.get(source_ref)
        if instruction is None:
            return set()
        chunk = chunks_by_prototype[instruction.prototype_id]
        if instruction.opcode == "GETGLOBAL":
            name = _constant_string(chunk, instruction.operand_b)
            return {name} if name is not None else set()
        if instruction.opcode == "CLOSURE":
            name = _closure_debug_local_name(instruction, chunk)
            return {name} if name is not None else set()
        if instruction.opcode == "MOVE":
            base_slot = instruction.operand_b
            member_name = None
        elif instruction.opcode == "GETTABLE":
            base_slot = instruction.operand_b
            member_name = _constant_string_operand(chunk, instruction.operand_c)
            if member_name is None:
                return set()
        else:
            return set()
        base_read_ref = (
            f"{instruction.prototype_id}@pc{instruction.pc}:r{base_slot}"
        )
        base_names = {
            name
            for base_ref in reaching_sources_by_ref.get(base_read_ref, set())
            for name in names_for_ref(base_ref, active | {source_ref})
        }
        if member_name is None:
            return base_names
        return {f"{base_name}.{member_name}" for base_name in base_names}

    return {
        name
        for source_ref in reaching_sources_by_ref.get(target_ref, set())
        for name in names_for_ref(source_ref, frozenset())
    }


def _reaching_global_names(
    call: InstructionIdentityRelation,
    chunks_by_prototype: dict[str, Chunk],
    instruction_by_result_ref: dict[str, InstructionIdentityRelation],
    reaching_sources_by_ref: dict[str, set[str]],
) -> set[str]:
    target_ref = f"{call.prototype_id}@pc{call.pc}:r{call.operand_a}"
    names: set[str] = set()
    for global_ref in reaching_sources_by_ref.get(target_ref, set()):
        global_instruction = instruction_by_result_ref.get(global_ref)
        if global_instruction is None or global_instruction.opcode != "GETGLOBAL":
            continue
        chunk = chunks_by_prototype[global_instruction.prototype_id]
        global_name = _constant_string(chunk, global_instruction.operand_b)
        if global_name is not None:
            names.add(global_name)
    return names


def _reaching_upvalue_member_names(
    call: InstructionIdentityRelation,
    chunks_by_prototype: dict[str, Chunk],
    instruction_by_result_ref: dict[str, InstructionIdentityRelation],
    reaching_sources_by_ref: dict[str, set[str]],
    upvalue_flows_by_read_ref: dict[str, list[UpvalueFlowRelation]],
    call_result_name_by_ref: dict[str, str],
) -> set[str]:
    def captured_names_for_read(
        upvalue_ref: str,
        visiting: frozenset[str] = frozenset(),
    ) -> set[str]:
        if upvalue_ref in visiting:
            return set()
        upvalue_instruction = instruction_by_result_ref.get(upvalue_ref)
        if upvalue_instruction is None or upvalue_instruction.opcode != "GETUPVAL":
            return set()
        next_visiting = visiting | {upvalue_ref}
        captured_names: set[str] = set()
        for flow in upvalue_flows_by_read_ref.get(upvalue_ref, []):
            if (
                flow.prototype_id != upvalue_instruction.prototype_id or
                flow.read_ref != upvalue_ref
            ):
                continue
            if flow.write_ref:
                write_pc = int(
                    flow.write_ref.rsplit("@pc", 1)[1].split(":", 1)[0]
                )
                if write_pc < upvalue_instruction.pc:
                    continue
            capture_sources = reaching_sources_by_ref.get(
                flow.capture_ref,
                set(),
            ) | {flow.capture_ref}
            for source_ref in capture_sources:
                captured_name = call_result_name_by_ref.get(source_ref)
                if captured_name is not None:
                    captured_names.add(captured_name)
                captured_names.update(
                    captured_names_for_read(source_ref, next_visiting)
                )
        if captured_names:
            return captured_names
        upvalue_index = upvalue_instruction.operand_b
        upvalue_chunk = chunks_by_prototype[upvalue_instruction.prototype_id]
        if 0 <= upvalue_index < len(upvalue_chunk.upvalues):
            upvalue_name = upvalue_chunk.upvalues[upvalue_index]
            if upvalue_name:
                return {upvalue_name}
        return set()

    target_ref = f"{call.prototype_id}@pc{call.pc}:r{call.operand_a}"
    names: set[str] = set()
    for member_ref in reaching_sources_by_ref.get(target_ref, set()):
        member_instruction = instruction_by_result_ref.get(member_ref)
        if member_instruction is None or member_instruction.opcode != "GETTABLE":
            continue
        chunk = chunks_by_prototype[member_instruction.prototype_id]
        member_name = _constant_string_operand(chunk, member_instruction.operand_c)
        if member_name is None:
            continue
        base_read_ref = (
            f"{member_instruction.prototype_id}@pc{member_instruction.pc}:"
            f"r{member_instruction.operand_b}"
        )
        for upvalue_ref in reaching_sources_by_ref.get(base_read_ref, set()):
            upvalue_instruction = instruction_by_result_ref.get(upvalue_ref)
            if upvalue_instruction is None or upvalue_instruction.opcode != "GETUPVAL":
                continue
            captured_names = captured_names_for_read(upvalue_ref)
            if len(captured_names) == 1:
                names.add(f"{next(iter(captured_names))}.{member_name}")
                continue
            if captured_names:
                continue
    return names


def _literal_require_result_name(
    call: InstructionIdentityRelation,
    resolved_name: str,
    chunks_by_prototype: dict[str, Chunk],
    instruction_by_result_ref: dict[str, InstructionIdentityRelation],
    reaching_sources_by_ref: dict[str, set[str]],
) -> str | None:
    if resolved_name != "require":
        return resolved_name
    argument_ref = f"{call.prototype_id}@pc{call.pc}:r{call.operand_a + 1}"
    sources = reaching_sources_by_ref.get(argument_ref, set())
    if len(sources) != 1:
        return None
    source_instruction = instruction_by_result_ref.get(next(iter(sources)))
    if source_instruction is None or source_instruction.opcode != "LOADK":
        return None
    return _constant_string(
        chunks_by_prototype[source_instruction.prototype_id],
        source_instruction.operand_b,
    )


def _record_call_result_names(
    call: InstructionIdentityRelation,
    resolved_name: str,
    chunks_by_prototype: dict[str, Chunk],
    instruction_by_result_ref: dict[str, InstructionIdentityRelation],
    reaching_sources_by_ref: dict[str, set[str]],
    call_result_name_by_ref: dict[str, str],
) -> None:
    if call.opcode != "CALL" or call.operand_c in {0, 1}:
        return
    if resolved_name == "require" and call.operand_c != 2:
        return
    result_name = _literal_require_result_name(
        call,
        resolved_name,
        chunks_by_prototype,
        instruction_by_result_ref,
        reaching_sources_by_ref,
    )
    if result_name is not None:
        result_end = call.operand_a + call.operand_c - 1
        for result_slot in range(call.operand_a, result_end):
            call_result_name_by_ref[
                f"{call.prototype_id}@pc{call.pc}:r{result_slot}"
            ] = result_name


def _iterator_result_names(
    result_ref: str,
    reaching_sources_by_ref: dict[str, set[str]],
    call_result_name_by_ref: dict[str, str],
    iterator_target_ref_by_result_ref: dict[str, str],
    visited: set[str],
) -> set[str]:
    direct_name = call_result_name_by_ref.get(result_ref)
    if direct_name is not None:
        return {direct_name}
    if result_ref in visited:
        return set()
    target_ref = iterator_target_ref_by_result_ref.get(result_ref)
    if target_ref is None:
        return set()
    next_visited = visited | {result_ref}
    names = set().union(
        *(
            _iterator_result_names(
                source_ref,
                reaching_sources_by_ref,
                call_result_name_by_ref,
                iterator_target_ref_by_result_ref,
                next_visited,
            )
            for source_ref in reaching_sources_by_ref.get(target_ref, set())
        )
    )
    if len(names) == 1:
        call_result_name_by_ref[result_ref] = next(iter(names))
        return names
    return set()


def _reaching_self_parameter_names(
    call: InstructionIdentityRelation,
    chunks_by_prototype: dict[str, Chunk],
    instruction_by_result_ref: dict[str, InstructionIdentityRelation],
    reaching_sources_by_ref: dict[str, set[str]],
    parameter_name_by_ref: dict[str, str],
) -> set[str]:
    target_ref = f"{call.prototype_id}@pc{call.pc}:r{call.operand_a}"
    names: set[str] = set()
    for self_ref in reaching_sources_by_ref.get(target_ref, set()):
        self_instruction = instruction_by_result_ref.get(self_ref)
        if self_instruction is None or self_instruction.opcode != "SELF":
            continue
        chunk = chunks_by_prototype[self_instruction.prototype_id]
        member_name = _constant_string_operand(chunk, self_instruction.operand_c)
        if member_name is None:
            continue
        base_read_ref = (
            f"{self_instruction.prototype_id}@pc{self_instruction.pc}:"
            f"r{self_instruction.operand_b}"
        )
        for base_ref in reaching_sources_by_ref.get(base_read_ref, set()):
            base_name = parameter_name_by_ref.get(base_ref)
            if base_name is not None:
                names.add(f"{base_name}.{member_name}")
    return names


def _reaching_self_call_result_names(
    call: InstructionIdentityRelation,
    chunks_by_prototype: dict[str, Chunk],
    instruction_by_result_ref: dict[str, InstructionIdentityRelation],
    reaching_sources_by_ref: dict[str, set[str]],
    call_result_name_by_ref: dict[str, str],
    iterator_target_ref_by_result_ref: dict[str, str],
) -> set[str]:
    target_ref = f"{call.prototype_id}@pc{call.pc}:r{call.operand_a}"
    names: set[str] = set()
    for self_ref in reaching_sources_by_ref.get(target_ref, set()):
        self_instruction = instruction_by_result_ref.get(self_ref)
        if self_instruction is None or self_instruction.opcode != "SELF":
            continue
        chunk = chunks_by_prototype[self_instruction.prototype_id]
        member_name = _constant_string_operand(chunk, self_instruction.operand_c)
        if member_name is None:
            continue
        base_read_ref = (
            f"{self_instruction.prototype_id}@pc{self_instruction.pc}:"
            f"r{self_instruction.operand_b}"
        )
        for base_ref in reaching_sources_by_ref.get(base_read_ref, set()):
            for base_name in _iterator_result_names(
                base_ref,
                reaching_sources_by_ref,
                call_result_name_by_ref,
                iterator_target_ref_by_result_ref,
                set(),
            ):
                names.add(f"{base_name}.{member_name}")
    return names


def _artifact_call_resolutions(
    module_path: str,
    root_chunk: Chunk,
    prototypes: list[PrototypeIdentityRelation],
    instructions: list[InstructionIdentityRelation],
    flows: list[ValueFlowRelation],
    table_flows: list[TableFieldFlowRelation],
    global_flows: list[GlobalFlowRelation],
    upvalue_flows: list[UpvalueFlowRelation],
) -> tuple[list[CallResolutionRelation], list[AnalysisBoundary]]:
    chunks_by_prototype = _chunks_by_prototype(root_chunk)
    prototype_ids = {prototype.prototype_id for prototype in prototypes}
    parameter_name_by_ref = {
        f"{prototype.prototype_id}:r{slot}": f"Param_{slot}"
        for prototype in prototypes
        for slot in range(prototype.num_params)
    }
    closure_targets = {
        f"{instruction.prototype_id}@pc{instruction.pc}:r{instruction.operand_a}": target_prototype_id
        for instruction in instructions
        if instruction.opcode == "CLOSURE"
        for target_prototype_id in (
            f"{instruction.prototype_id}.{instruction.operand_b}",
        )
        if target_prototype_id in prototype_ids
    }
    adjacency: dict[str, set[tuple[str, str]]] = defaultdict(set)
    reaching_sources_by_ref: dict[str, set[str]] = defaultdict(set)
    for flow in flows:
        if flow.kind == "reaching-definition":
            adjacency[flow.source_ref].add((flow.sink_ref, ""))
            reaching_sources_by_ref[flow.sink_ref].add(flow.source_ref)
    for instruction in instructions:
        if instruction.opcode == "MOVE":
            adjacency[
                f"{instruction.prototype_id}@pc{instruction.pc}:r{instruction.operand_b}"
            ].add(
                (
                    f"{instruction.prototype_id}@pc{instruction.pc}:r{instruction.operand_a}",
                    "move",
                )
            )
    for flow in table_flows:
        adjacency[flow.write_ref].add((flow.read_ref, "table-field"))
    for flow in global_flows:
        adjacency[flow.write_ref].add((flow.read_ref, "global"))
    upvalue_read_pcs = {
        (
            instruction.prototype_id,
            f"{instruction.prototype_id}@pc{instruction.pc}:r{instruction.operand_a}",
        ): instruction.pc
        for instruction in instructions
        if instruction.opcode == "GETUPVAL"
    }
    upvalue_write_pcs = {
        (
            instruction.prototype_id,
            f"{instruction.prototype_id}@pc{instruction.pc}:r{instruction.operand_a}",
        ): instruction.pc
        for instruction in instructions
        if instruction.opcode == "SETUPVAL"
    }
    for flow in upvalue_flows:
        read_pc = upvalue_read_pcs[(flow.prototype_id, flow.read_ref)]
        source_ref = flow.capture_ref
        if flow.write_ref:
            write_pc = upvalue_write_pcs[(flow.prototype_id, flow.write_ref)]
            if write_pc < read_pc:
                source_ref = flow.write_ref
        adjacency[source_ref].add((flow.read_ref, "upvalue"))
    instruction_by_result_ref = {
        f"{instruction.prototype_id}@pc{instruction.pc}:r{instruction.operand_a}": instruction
        for instruction in instructions
        if instruction.opcode in {
            "GETGLOBAL",
            "GETUPVAL",
            "GETTABLE",
            "SELF",
            "MOVE",
            "CLOSURE",
            "LOADK",
        }
    }

    target_states_by_ref: dict[str, set[tuple[str, frozenset[str]]]] = {
        closure_ref: {(target_prototype, frozenset())}
        for closure_ref, target_prototype in closure_targets.items()
    }
    pending = deque(target_states_by_ref)
    queued = set(target_states_by_ref)
    while pending:
        source_ref = pending.popleft()
        queued.remove(source_ref)
        source_states = target_states_by_ref[source_ref]
        for sink_ref, carrier_kind in adjacency.get(source_ref, set()):
            next_states = {
                (
                    target_prototype,
                    carrier_kinds | ({carrier_kind} if carrier_kind else set()),
                )
                for target_prototype, carrier_kinds in source_states
            }
            sink_states = target_states_by_ref.setdefault(sink_ref, set())
            previous_count = len(sink_states)
            sink_states.update(next_states)
            if len(sink_states) != previous_count and sink_ref not in queued:
                pending.append(sink_ref)
                queued.add(sink_ref)

    parameter_derived_refs = set(parameter_name_by_ref)
    pending_parameter_refs = deque(parameter_derived_refs)
    while pending_parameter_refs:
        source_ref = pending_parameter_refs.popleft()
        for sink_ref, _ in adjacency.get(source_ref, set()):
            if sink_ref in parameter_derived_refs:
                continue
            parameter_derived_refs.add(sink_ref)
            pending_parameter_refs.append(sink_ref)

    resolutions: list[CallResolutionRelation] = []
    boundaries: list[AnalysisBoundary] = []
    call_result_name_by_ref: dict[str, str] = {}
    iterator_target_ref_by_result_ref = {
        f"{instruction.prototype_id}@pc{instruction.pc}:r{result_slot}": (
            f"{instruction.prototype_id}@pc{instruction.pc}:r{instruction.operand_a}"
        )
        for instruction in instructions
        if instruction.opcode == "TFORLOOP"
        for result_slot in range(
            instruction.operand_a + 3,
            instruction.operand_a + 3 + instruction.operand_c,
        )
    }
    upvalue_flows_by_read_ref: dict[str, list[UpvalueFlowRelation]] = defaultdict(list)
    for flow in upvalue_flows:
        upvalue_flows_by_read_ref[flow.read_ref].append(flow)
    for instruction in instructions:
        if instruction.opcode not in {"CALL", "TAILCALL"}:
            continue
        target_value_ref = (
            f"{instruction.prototype_id}@pc{instruction.pc}:r{instruction.operand_a}"
        )
        target_states = target_states_by_ref.get(target_value_ref, set())
        targets = {target_prototype for target_prototype, _ in target_states}
        resolved_names = set().union(
            _reaching_global_names(
                instruction,
                chunks_by_prototype,
                instruction_by_result_ref,
                reaching_sources_by_ref,
            ),
            _reaching_global_member_names(
                instruction,
                chunks_by_prototype,
                instruction_by_result_ref,
                reaching_sources_by_ref,
                call_result_name_by_ref,
            ),
            _reaching_upvalue_member_names(
                instruction,
                chunks_by_prototype,
                instruction_by_result_ref,
                reaching_sources_by_ref,
                upvalue_flows_by_read_ref,
                call_result_name_by_ref,
            ),
            _reaching_self_parameter_names(
                instruction,
                chunks_by_prototype,
                instruction_by_result_ref,
                reaching_sources_by_ref,
                parameter_name_by_ref,
            ),
            _reaching_self_call_result_names(
                instruction,
                chunks_by_prototype,
                instruction_by_result_ref,
                reaching_sources_by_ref,
                call_result_name_by_ref,
                iterator_target_ref_by_result_ref,
            ),
        )
        if len(targets) == 1:
            carrier_kinds = set().union(
                *(state_carriers for _, state_carriers in target_states)
            )
            if "upvalue" in carrier_kinds:
                resolution_kind = "closure-upvalue"
            elif "global" in carrier_kinds:
                resolution_kind = "closure-global"
            elif "table-field" in carrier_kinds:
                resolution_kind = "closure-table-field"
            elif "move" in carrier_kinds:
                resolution_kind = "closure-move"
            else:
                resolution_kind = "direct-closure"
            resolved_name = (
                next(iter(resolved_names)) if len(resolved_names) == 1 else ""
            )
            resolutions.append(
                CallResolutionRelation(
                    caller_module_path=module_path,
                    caller_prototype_id=instruction.prototype_id,
                    callsite_id=f"{instruction.prototype_id}@pc{instruction.pc}",
                    target_value_ref=target_value_ref,
                    resolved_name=resolved_name,
                    resolution_kind=resolution_kind,
                    target_module_path=module_path,
                    target_prototype_id=next(iter(targets)),
                    provenance=f"bytecode-only,{resolution_kind}-target",
                )
            )
            if resolved_name:
                _record_call_result_names(
                    instruction,
                    resolved_name,
                    chunks_by_prototype,
                    instruction_by_result_ref,
                    reaching_sources_by_ref,
                    call_result_name_by_ref,
                )
            continue
        if len(targets) > 1:
            boundaries.append(
                AnalysisBoundary(
                    module_path=module_path,
                    prototype_id=instruction.prototype_id,
                    site_id=f"{instruction.prototype_id}@pc{instruction.pc}",
                    boundary_kind="unresolved-call-target",
                    reason="multiple-candidates",
                    provenance="bytecode-only,call-resolution-boundary",
                )
            )
            continue

        chunk = chunks_by_prototype[instruction.prototype_id]
        if instruction.pc > 0:
            previous = chunk.instructions[instruction.pc - 1]
            if previous.opcode.name == "GETGLOBAL" and previous.a == instruction.operand_a:
                resolved_name = _constant_string(chunk, previous.b)
                if resolved_name is not None:
                    resolutions.append(
                        CallResolutionRelation(
                            caller_module_path=module_path,
                            caller_prototype_id=instruction.prototype_id,
                            callsite_id=f"{instruction.prototype_id}@pc{instruction.pc}",
                            target_value_ref=target_value_ref,
                            resolved_name=resolved_name,
                            resolution_kind="derived-adjacent-global-name",
                            target_module_path="",
                            target_prototype_id="",
                            provenance="bytecode-only,derived-call-target",
                        )
                    )
                    _record_call_result_names(
                        instruction,
                        resolved_name,
                        chunks_by_prototype,
                        instruction_by_result_ref,
                        reaching_sources_by_ref,
                        call_result_name_by_ref,
                    )
                    continue

        if len(resolved_names) > 1:
            boundaries.append(
                AnalysisBoundary(
                    module_path=module_path,
                    prototype_id=instruction.prototype_id,
                    site_id=f"{instruction.prototype_id}@pc{instruction.pc}",
                    boundary_kind="unresolved-call-target",
                    reason="multiple-candidates",
                    provenance="bytecode-only,call-resolution-boundary",
                )
            )
            continue
        resolved_name = next(iter(resolved_names), None)
        if resolved_name is None:
            reason = (
                "param-derived"
                if not target_states and target_value_ref in parameter_derived_refs
                else "no-proven-target"
            )
            boundaries.append(
                AnalysisBoundary(
                    module_path=module_path,
                    prototype_id=instruction.prototype_id,
                    site_id=f"{instruction.prototype_id}@pc{instruction.pc}",
                    boundary_kind="unresolved-call-target",
                    reason=reason,
                    provenance="bytecode-only,call-resolution-boundary",
                )
            )
            continue
        resolutions.append(
            CallResolutionRelation(
                caller_module_path=module_path,
                caller_prototype_id=instruction.prototype_id,
                callsite_id=f"{instruction.prototype_id}@pc{instruction.pc}",
                target_value_ref=target_value_ref,
                resolved_name=resolved_name,
                resolution_kind="derived-reaching-definition-call-target",
                target_module_path="",
                target_prototype_id="",
                provenance="bytecode-only,derived-call-target,reaching-definition",
            )
        )
        _record_call_result_names(
            instruction,
            resolved_name,
            chunks_by_prototype,
            instruction_by_result_ref,
            reaching_sources_by_ref,
            call_result_name_by_ref,
        )
    return resolutions, boundaries


def _artifact_literal_requires(
    module_path: str,
    root_chunk: Chunk,
    instructions: list[InstructionIdentityRelation],
    flows: list[ValueFlowRelation],
    call_resolutions: list[CallResolutionRelation],
) -> tuple[list[LiteralRequireRelation], list[AnalysisBoundary]]:
    chunks_by_prototype = _chunks_by_prototype(root_chunk)
    calls_by_site = {
        (instruction.prototype_id, f"{instruction.prototype_id}@pc{instruction.pc}"): instruction
        for instruction in instructions
        if instruction.opcode in {"CALL", "TAILCALL"}
    }
    loadk_by_result_ref = {
        f"{instruction.prototype_id}@pc{instruction.pc}:r{instruction.operand_a}": instruction
        for instruction in instructions
        if instruction.opcode == "LOADK"
    }
    reaching_sources_by_ref: dict[str, set[str]] = defaultdict(set)
    for flow in flows:
        if flow.kind == "reaching-definition":
            reaching_sources_by_ref[flow.sink_ref].add(flow.source_ref)

    literal_requires: list[LiteralRequireRelation] = []
    boundaries: list[AnalysisBoundary] = []
    for resolution in call_resolutions:
        if resolution.resolved_name != "require":
            continue
        call = calls_by_site[
            (resolution.caller_prototype_id, resolution.callsite_id)
        ]
        argument_ref = (
            f"{call.prototype_id}@pc{call.pc}:r{call.operand_a + 1}"
        )
        sources = reaching_sources_by_ref.get(argument_ref, set())
        source = next(iter(sources)) if len(sources) == 1 else None
        loadk = loadk_by_result_ref.get(source) if source is not None else None
        require_string = (
            _constant_string(chunks_by_prototype[loadk.prototype_id], loadk.operand_b)
            if loadk is not None
            else None
        )
        if require_string is not None:
            literal_requires.append(
                LiteralRequireRelation(
                    caller_module_path=module_path,
                    caller_prototype_id=call.prototype_id,
                    callsite_id=resolution.callsite_id,
                    require_string=require_string,
                    argument_ref=argument_ref,
                    provenance="bytecode-only,derived-literal-require",
                )
            )
            continue
        reason = "multiple-candidates" if len(sources) > 1 else "dynamic-argument"
        boundaries.append(
            AnalysisBoundary(
                module_path=module_path,
                prototype_id=call.prototype_id,
                site_id=resolution.callsite_id,
                boundary_kind="unresolved-literal-require",
                reason=reason,
                provenance="bytecode-only,literal-require-boundary",
            )
        )
    return literal_requires, boundaries


def _module_names_for_path(module_path: str) -> set[str]:
    path = module_path.removesuffix(".luac").removesuffix(".lua")
    parts = path.split("/")
    names: set[str] = set()
    for index in range(len(parts)):
        suffix = ".".join(parts[index:])
        if suffix:
            names.add(suffix)
    return names


def _module_resolutions(
    module_paths: list[str],
    literal_requires: list[LiteralRequireRelation],
) -> tuple[list[ModuleResolutionRelation], list[AnalysisBoundary]]:
    resolutions: list[ModuleResolutionRelation] = []
    boundaries: list[AnalysisBoundary] = []
    for require in literal_requires:
        candidates = sorted(
            {
                module_path
                for module_path in module_paths
                if module_path != require.caller_module_path
                and require.require_string in _module_names_for_path(module_path)
            }
        )
        if len(candidates) == 1:
            status = "matched"
            target_module_path = candidates[0]
            reason = ""
        elif candidates:
            status = "ambiguous"
            target_module_path = ""
            reason = "ambiguous-module-path-candidates"
        else:
            status = "unresolved"
            target_module_path = ""
            reason = "no-module-path-candidate"
        resolutions.append(
            ModuleResolutionRelation(
                caller_module_path=require.caller_module_path,
                callsite_id=require.callsite_id,
                require_string=require.require_string,
                status=status,
                target_module_path=target_module_path,
                reason=reason,
                provenance="bytecode-only,literal-require,module-path",
            )
        )
        if status != "matched":
            boundaries.append(
                AnalysisBoundary(
                    module_path=require.caller_module_path,
                    prototype_id=require.caller_prototype_id,
                    site_id=require.callsite_id,
                    boundary_kind="unresolved-module-require",
                    reason=reason,
                    provenance="bytecode-only,module-resolution-boundary",
                )
            )
    return resolutions, boundaries


def _cross_module_field_call_resolutions(
    chunks_by_module: dict[str, Chunk],
    instructions: list[InstructionIdentityRelation],
    flows: list[ValueFlowRelation],
    upvalue_flows: list[UpvalueFlowRelation],
    existing_resolutions: list[CallResolutionRelation],
    literal_requires: list[LiteralRequireRelation],
    module_resolutions: list[ModuleResolutionRelation],
    module_exports: list[ModuleExportRelation],
) -> tuple[
    list[CallResolutionRelation],
    set[tuple[str, str, str]],
    set[tuple[str, str, str]],
]:
    chunks_by_module_prototype = {
        (module_path, prototype_id): chunk
        for module_path, root_chunk in chunks_by_module.items()
        for prototype_id, chunk in _chunks_by_prototype(root_chunk).items()
    }
    instructions_by_module_prototype: dict[
        tuple[str, str], list[InstructionIdentityRelation]
    ] = defaultdict(list)
    instruction_by_site: dict[
        tuple[str, str, int], InstructionIdentityRelation
    ] = {}
    for instruction in instructions:
        key = (instruction.module_path, instruction.prototype_id)
        instructions_by_module_prototype[key].append(instruction)
        instruction_by_site[(key[0], key[1], instruction.pc)] = instruction

    reaching_sources: dict[tuple[str, str, str], set[str]] = defaultdict(set)
    carrier_adjacency: dict[tuple[str, str], set[str]] = defaultdict(set)
    for flow in flows:
        if flow.kind == "reaching-definition":
            reaching_sources[
                (flow.module_path, flow.prototype_id, flow.sink_ref)
            ].add(flow.source_ref)
            carrier_adjacency[(flow.module_path, flow.source_ref)].add(flow.sink_ref)
    for flow in upvalue_flows:
        carrier_adjacency[(flow.module_path, flow.capture_ref)].add(flow.read_ref)

    requires_by_site = {
        (require.caller_module_path, require.callsite_id): require
        for require in literal_requires
    }
    exports_by_module_field: dict[
        tuple[str, str], list[ModuleExportRelation]
    ] = defaultdict(list)
    export_path_prefixes_by_module: dict[str, set[tuple[str, ...]]] = (
        defaultdict(set)
    )
    for export in module_exports:
        exports_by_module_field[(export.module_path, export.field_name)].append(export)
        field_path = tuple(export.field_name.split("."))
        for prefix_length in range(1, len(field_path) + 1):
            export_path_prefixes_by_module[export.module_path].add(
                field_path[:prefix_length]
            )
    occupied_callsites = {
        (
            resolution.caller_module_path,
            resolution.caller_prototype_id,
            resolution.callsite_id,
        )
        for resolution in existing_resolutions
        if resolution.target_module_path or resolution.target_prototype_id
    }

    derived: list[CallResolutionRelation] = []
    resolved_sites: set[tuple[str, str, str]] = set()
    unresolved_sites: set[tuple[str, str, str]] = set()
    for module_resolution in module_resolutions:
        if module_resolution.status != "matched":
            continue
        require = requires_by_site.get(
            (module_resolution.caller_module_path, module_resolution.callsite_id)
        )
        if require is None:
            continue
        require_pc = int(require.callsite_id.rsplit("@pc", 1)[1])
        require_call = instruction_by_site.get(
            (
                require.caller_module_path,
                require.caller_prototype_id,
                require_pc,
            )
        )
        if (
            require_call is None
            or require_call.opcode != "CALL"
            or require_call.operand_c != 2
        ):
            continue
        require_result_ref = (
            f"{require.caller_prototype_id}@pc{require_pc}:r{require_call.operand_a}"
        )
        candidate_scopes = sorted(
            scope
            for scope in instructions_by_module_prototype
            if scope[0] == require.caller_module_path
        )
        static_fields: list[
            tuple[
                tuple[str, str],
                str,
                str,
                str,
            ]
        ] = []
        for scope in candidate_scopes:
            chunk = chunks_by_module_prototype[scope]
            scoped_instructions = instructions_by_module_prototype[scope]
            for field_instruction in scoped_instructions:
                if field_instruction.opcode != "GETTABLE":
                    continue
                field_name = _constant_string_operand(
                    chunk,
                    field_instruction.operand_c,
                )
                if field_name is None:
                    continue
                field_base_ref = (
                    f"{scope[1]}@pc{field_instruction.pc}:"
                    f"r{field_instruction.operand_b}"
                )
                field_result_ref = (
                    f"{scope[1]}@pc{field_instruction.pc}:"
                    f"r{field_instruction.operand_a}"
                )
                static_fields.append(
                    (
                        scope,
                        field_name,
                        field_base_ref,
                        field_result_ref,
                    )
                )

        static_paths_by_ref: dict[str, set[tuple[str, ...]]] = defaultdict(set)
        field_result_paths_by_ref: dict[str, set[tuple[str, ...]]] = {
            field_result_ref: set()
            for _, _, _, field_result_ref in static_fields
        }
        export_path_prefixes = export_path_prefixes_by_module.get(
            module_resolution.target_module_path,
            set(),
        )
        pending_paths: deque[tuple[str, tuple[str, ...]]] = deque(
            [(require_result_ref, ())]
        )
        while True:
            while pending_paths:
                source_ref, field_path = pending_paths.popleft()
                if field_path in static_paths_by_ref[source_ref]:
                    continue
                static_paths_by_ref[source_ref].add(field_path)
                for sink_ref in carrier_adjacency.get(
                    (require.caller_module_path, source_ref), set()
                ):
                    pending_paths.append((sink_ref, field_path))

            added_field_path = False
            for (
                scope,
                field_name,
                field_base_ref,
                field_result_ref,
            ) in static_fields:
                field_base_sources = reaching_sources.get(
                    (scope[0], scope[1], field_base_ref), set()
                )
                if not field_base_sources or not all(
                    field_result_paths_by_ref.get(
                        source_ref,
                        static_paths_by_ref.get(source_ref, set()),
                    )
                    for source_ref in field_base_sources
                ):
                    continue
                for source_ref in sorted(field_base_sources):
                    source_paths = field_result_paths_by_ref.get(
                        source_ref,
                        static_paths_by_ref.get(source_ref, set()),
                    )
                    for field_path in sorted(source_paths):
                        nested_path = (*field_path, field_name)
                        if (
                            len(nested_path) > 1
                            and nested_path not in export_path_prefixes
                        ):
                            continue
                        if (
                            nested_path
                            in field_result_paths_by_ref[field_result_ref]
                        ):
                            continue
                        field_result_paths_by_ref[field_result_ref].add(nested_path)
                        pending_paths.append((field_result_ref, nested_path))
                        added_field_path = True
            if not added_field_path:
                break

        for scope in candidate_scopes:
            for call in instructions_by_module_prototype[scope]:
                if call.opcode not in {"CALL", "TAILCALL"}:
                    continue
                callsite_id = f"{scope[1]}@pc{call.pc}"
                site = (scope[0], scope[1], callsite_id)
                if site in occupied_callsites or site in resolved_sites:
                    continue
                target_ref = f"{scope[1]}@pc{call.pc}:r{call.operand_a}"
                target_sources = reaching_sources.get(
                    (scope[0], scope[1], target_ref), set()
                )
                if len(target_sources) != 1:
                    continue
                target_source = next(iter(target_sources))
                field_paths = {
                    field_path
                    for field_path in field_result_paths_by_ref.get(
                        target_source,
                        set(),
                    )
                    if field_path
                }
                if not field_paths:
                    continue
                site_resolutions: list[CallResolutionRelation] = []
                for field_path in sorted(field_paths):
                    joined_field_path = ".".join(field_path)
                    exports = exports_by_module_field.get(
                        (
                            module_resolution.target_module_path,
                            joined_field_path,
                        ),
                        [],
                    )
                    target_prototypes = {
                        export.target_prototype_id for export in exports
                    }
                    for target_prototype_id in sorted(target_prototypes):
                        export = min(
                            (
                                export
                                for export in exports
                                if export.target_prototype_id == target_prototype_id
                            ),
                            key=lambda item: (item.provenance, item.value_ref),
                        )
                        provenance_suffix = export.provenance.split(",", 1)[1]
                        site_resolutions.append(
                            CallResolutionRelation(
                                caller_module_path=scope[0],
                                caller_prototype_id=scope[1],
                                callsite_id=callsite_id,
                                target_value_ref=target_ref,
                                resolved_name=(
                                    f"{require.require_string}."
                                    f"{joined_field_path}"
                                ),
                                resolution_kind="module-field-export",
                                target_module_path=(
                                    module_resolution.target_module_path
                                ),
                                target_prototype_id=target_prototype_id,
                                provenance=(
                                    "bytecode-only,literal-require,"
                                    f"{provenance_suffix}"
                                ),
                            )
                        )
                if site_resolutions:
                    derived.extend(site_resolutions)
                    resolved_sites.add(site)
                else:
                    unresolved_sites.add(site)
    return derived, resolved_sites, unresolved_sites


def _same_module_export_call_resolutions(
    call_resolutions: list[CallResolutionRelation],
    module_exports: list[ModuleExportRelation],
) -> list[CallResolutionRelation]:
    exports_by_module_name: dict[
        tuple[str, str], list[ModuleExportRelation]
    ] = defaultdict(list)
    for export in module_exports:
        if export.export_kind in {"module-global", "module-global-table-field"}:
            exports_by_module_name[(export.module_path, export.field_name)].append(
                export
            )

    upgraded: list[CallResolutionRelation] = []
    for resolution in call_resolutions:
        if resolution.target_module_path or resolution.target_prototype_id:
            upgraded.append(resolution)
            continue
        exports = exports_by_module_name.get(
            (resolution.caller_module_path, resolution.resolved_name),
            [],
        )
        target_prototypes = {export.target_prototype_id for export in exports}
        if len(target_prototypes) != 1:
            upgraded.append(resolution)
            continue
        target_prototype_id = next(iter(target_prototypes))
        export = min(
            (
                export
                for export in exports
                if export.target_prototype_id == target_prototype_id
            ),
            key=lambda item: (item.provenance, item.value_ref),
        )
        provenance_suffix = export.provenance.split(",", 1)[1]
        upgraded.append(
            CallResolutionRelation(
                caller_module_path=resolution.caller_module_path,
                caller_prototype_id=resolution.caller_prototype_id,
                callsite_id=resolution.callsite_id,
                target_value_ref=resolution.target_value_ref,
                resolved_name=resolution.resolved_name,
                resolution_kind="same-module-field-export",
                target_module_path=resolution.caller_module_path,
                target_prototype_id=target_prototype_id,
                provenance=f"bytecode-only,same-module,{provenance_suffix}",
            )
        )
    return upgraded


def _interprocedural_argument_flows(
    prototypes: list[PrototypeIdentityRelation],
    instructions: list[InstructionIdentityRelation],
    value_flows: list[ValueFlowRelation],
    call_resolutions: list[CallResolutionRelation],
) -> list[InterproceduralFlowRelation]:
    prototype_by_scope = {
        (prototype.module_path, prototype.prototype_id): prototype
        for prototype in prototypes
    }
    instruction_by_site = {
        (instruction.module_path, instruction.prototype_id, instruction.pc): instruction
        for instruction in instructions
    }
    fixed_varargs_by_scope: dict[
        tuple[str, str], list[InstructionIdentityRelation]
    ] = defaultdict(list)
    for instruction in instructions:
        if instruction.opcode == "VARARG" and instruction.operand_b > 0:
            fixed_varargs_by_scope[
                (instruction.module_path, instruction.prototype_id)
            ].append(instruction)
    proven_reads_by_site: dict[
        tuple[str, str, str], dict[int, str]
    ] = defaultdict(dict)
    for flow in value_flows:
        if flow.kind != "reaching-definition":
            continue
        site_id, separator, slot_text = flow.sink_ref.rpartition(":r")
        if not separator or not slot_text.isdigit():
            continue
        proven_reads_by_site[
            (flow.module_path, flow.prototype_id, site_id)
        ][int(slot_text)] = flow.sink_ref
    flows: list[InterproceduralFlowRelation] = []
    for resolution in call_resolutions:
        callee = prototype_by_scope.get(
            (resolution.target_module_path, resolution.target_prototype_id)
        )
        if callee is None:
            continue
        call_pc = int(resolution.callsite_id.rsplit("@pc", 1)[1])
        call = instruction_by_site.get(
            (
                resolution.caller_module_path,
                resolution.caller_prototype_id,
                call_pc,
            )
        )
        if call is None or call.opcode not in {"CALL", "TAILCALL"}:
            continue
        if call.opcode == "TAILCALL" and call.operand_b == 0:
            continue
        resolution_provenance = (
            "resolved-tailcall" if call.opcode == "TAILCALL" else "resolved-call"
        )
        if call.operand_b == 0:
            for slot, source_ref in sorted(
                proven_reads_by_site.get(
                    (
                        resolution.caller_module_path,
                        resolution.caller_prototype_id,
                        resolution.callsite_id,
                    ),
                    {},
                ).items()
            ):
                if slot <= call.operand_a:
                    continue
                position = slot - call.operand_a - 1
                if position < callee.num_params:
                    flows.append(
                        InterproceduralFlowRelation(
                            caller_module_path=resolution.caller_module_path,
                            caller_prototype_id=resolution.caller_prototype_id,
                            callsite_id=resolution.callsite_id,
                            callee_module_path=resolution.target_module_path,
                            callee_prototype_id=resolution.target_prototype_id,
                            source_ref=source_ref,
                            sink_ref=f"{resolution.target_prototype_id}:r{position}",
                            flow_kind="argument-to-parameter",
                            position=position,
                            provenance=(
                                "bytecode-only,resolved-call,"
                                "producer-proven-open-argument"
                            ),
                        )
                    )
                    continue
                if not callee.is_vararg:
                    continue
                vararg_offset = position - callee.num_params
                for vararg in fixed_varargs_by_scope.get(
                    (
                        resolution.target_module_path,
                        resolution.target_prototype_id,
                    ),
                    [],
                ):
                    if vararg_offset >= vararg.operand_b - 1:
                        continue
                    flows.append(
                        InterproceduralFlowRelation(
                            caller_module_path=resolution.caller_module_path,
                            caller_prototype_id=resolution.caller_prototype_id,
                            callsite_id=resolution.callsite_id,
                            callee_module_path=resolution.target_module_path,
                            callee_prototype_id=resolution.target_prototype_id,
                            source_ref=source_ref,
                            sink_ref=(
                                f"{resolution.target_prototype_id}@pc{vararg.pc}:"
                                f"r{vararg.operand_a + vararg_offset}"
                            ),
                            flow_kind="argument-to-vararg",
                            position=position,
                            provenance=(
                                "bytecode-only,resolved-call,"
                                "producer-proven-open-vararg"
                            ),
                        )
                    )
            continue
        argument_count = call.operand_b - 1
        for position in range(min(argument_count, callee.num_params)):
            flows.append(
                InterproceduralFlowRelation(
                    caller_module_path=resolution.caller_module_path,
                    caller_prototype_id=resolution.caller_prototype_id,
                    callsite_id=resolution.callsite_id,
                    callee_module_path=resolution.target_module_path,
                    callee_prototype_id=resolution.target_prototype_id,
                    source_ref=(
                        f"{resolution.caller_prototype_id}@pc{call_pc}:"
                        f"r{call.operand_a + 1 + position}"
                    ),
                    sink_ref=f"{resolution.target_prototype_id}:r{position}",
                    flow_kind="argument-to-parameter",
                    position=position,
                    provenance=(
                        f"bytecode-only,{resolution_provenance},fixed-argument"
                    ),
                )
            )
        if call.opcode == "TAILCALL":
            continue
        if not callee.is_vararg:
            continue
        extra_argument_count = argument_count - callee.num_params
        if extra_argument_count <= 0:
            continue
        for vararg in fixed_varargs_by_scope.get(
            (resolution.target_module_path, resolution.target_prototype_id),
            [],
        ):
            for offset in range(min(extra_argument_count, vararg.operand_b - 1)):
                position = callee.num_params + offset
                flows.append(
                    InterproceduralFlowRelation(
                        caller_module_path=resolution.caller_module_path,
                        caller_prototype_id=resolution.caller_prototype_id,
                        callsite_id=resolution.callsite_id,
                        callee_module_path=resolution.target_module_path,
                        callee_prototype_id=resolution.target_prototype_id,
                        source_ref=(
                            f"{resolution.caller_prototype_id}@pc{call_pc}:"
                            f"r{call.operand_a + 1 + position}"
                        ),
                        sink_ref=(
                            f"{resolution.target_prototype_id}@pc{vararg.pc}:"
                            f"r{vararg.operand_a + offset}"
                        ),
                        flow_kind="argument-to-vararg",
                        position=position,
                        provenance="bytecode-only,resolved-call,fixed-vararg",
                    )
                )
    return sorted(
        flows,
        key=lambda flow: (
            flow.caller_module_path,
            flow.caller_prototype_id,
            flow.callsite_id,
            flow.callee_module_path,
            flow.callee_prototype_id,
            flow.position,
            flow.source_ref,
            flow.sink_ref,
        ),
    )


def _interprocedural_return_flows(
    instructions: list[InstructionIdentityRelation],
    value_flows: list[ValueFlowRelation],
    call_resolutions: list[CallResolutionRelation],
) -> list[InterproceduralFlowRelation]:
    instruction_by_site = {
        (instruction.module_path, instruction.prototype_id, instruction.pc): instruction
        for instruction in instructions
    }
    returns_by_scope: dict[
        tuple[str, str], list[InstructionIdentityRelation]
    ] = defaultdict(list)
    structural_tailcalls_by_scope: dict[
        tuple[str, str], list[InstructionIdentityRelation]
    ] = defaultdict(list)
    for instruction in instructions:
        if instruction.opcode == "RETURN" and instruction.operand_b != 1:
            returns_by_scope[
                (instruction.module_path, instruction.prototype_id)
            ].append(instruction)
        elif instruction.opcode == "TAILCALL" and instruction.operand_c != 1:
            structural_tailcalls_by_scope[
                (instruction.module_path, instruction.prototype_id)
            ].append(instruction)
    proven_reads_by_site: dict[
        tuple[str, str, str], dict[int, str]
    ] = defaultdict(dict)
    for flow in value_flows:
        if flow.kind != "reaching-definition":
            continue
        site_id, separator, slot_text = flow.sink_ref.rpartition(":r")
        if not separator or not slot_text.isdigit():
            continue
        proven_reads_by_site[
            (flow.module_path, flow.prototype_id, site_id)
        ][int(slot_text)] = flow.sink_ref
    resolved_callsites = {
        (
            resolution.caller_module_path,
            resolution.caller_prototype_id,
            resolution.callsite_id,
        )
        for resolution in call_resolutions
        if resolution.target_module_path and resolution.target_prototype_id
    }

    flows: list[InterproceduralFlowRelation] = []
    for resolution in call_resolutions:
        call_pc = int(resolution.callsite_id.rsplit("@pc", 1)[1])
        call = instruction_by_site.get(
            (
                resolution.caller_module_path,
                resolution.caller_prototype_id,
                call_pc,
            )
        )
        if call is None or call.opcode not in {"CALL", "TAILCALL"}:
            continue
        if call.opcode == "CALL" and call.operand_c == 1:
            continue
        if call.opcode == "TAILCALL" and call.operand_c != 0:
            continue
        resolution_provenance = (
            "resolved-tailcall" if call.opcode == "TAILCALL" else "resolved-call"
        )
        for return_instruction in returns_by_scope.get(
            (resolution.target_module_path, resolution.target_prototype_id),
            [],
        ):
            if return_instruction.operand_b == 0:
                if call.opcode == "TAILCALL":
                    continue
                return_site_id = (
                    f"{resolution.target_prototype_id}@pc{return_instruction.pc}"
                )
                for slot, source_ref in sorted(
                    proven_reads_by_site.get(
                        (
                            resolution.target_module_path,
                            resolution.target_prototype_id,
                            return_site_id,
                        ),
                        {},
                    ).items()
                ):
                    if slot < return_instruction.operand_a:
                        continue
                    position = slot - return_instruction.operand_a
                    if call.operand_c > 0 and position >= call.operand_c - 1:
                        continue
                    provenance = (
                        "bytecode-only,resolved-call,"
                        "producer-proven-open-return"
                    )
                    if call.operand_c == 0:
                        provenance += ",producer-proven-open-result"
                    flows.append(
                        InterproceduralFlowRelation(
                            caller_module_path=resolution.caller_module_path,
                            caller_prototype_id=resolution.caller_prototype_id,
                            callsite_id=resolution.callsite_id,
                            callee_module_path=resolution.target_module_path,
                            callee_prototype_id=resolution.target_prototype_id,
                            source_ref=source_ref,
                            sink_ref=(
                                f"{resolution.caller_prototype_id}@pc{call_pc}:"
                                f"r{call.operand_a + position}"
                            ),
                            flow_kind="return-to-result",
                            position=position,
                            provenance=provenance,
                        )
                    )
                continue
            if call.operand_c == 0:
                position_count = return_instruction.operand_b - 1
                provenance = (
                    f"bytecode-only,{resolution_provenance},"
                    "producer-proven-open-result"
                )
            else:
                position_count = min(
                    call.operand_c - 1,
                    return_instruction.operand_b - 1,
                )
                provenance = "bytecode-only,resolved-call,fixed-return"
            for position in range(position_count):
                flows.append(
                    InterproceduralFlowRelation(
                        caller_module_path=resolution.caller_module_path,
                        caller_prototype_id=resolution.caller_prototype_id,
                        callsite_id=resolution.callsite_id,
                        callee_module_path=resolution.target_module_path,
                        callee_prototype_id=resolution.target_prototype_id,
                        source_ref=(
                            f"{resolution.target_prototype_id}@pc"
                            f"{return_instruction.pc}:"
                            f"r{return_instruction.operand_a + position}"
                        ),
                        sink_ref=(
                            f"{resolution.caller_prototype_id}@pc{call_pc}:"
                            f"r{call.operand_a + position}"
                        ),
                        flow_kind="return-to-result",
                        position=position,
                        provenance=provenance,
                    )
                )
        if call.opcode != "CALL":
            continue
        for tailcall in structural_tailcalls_by_scope.get(
            (resolution.target_module_path, resolution.target_prototype_id),
            [],
        ):
            tailcall_site_id = (
                f"{resolution.target_prototype_id}@pc{tailcall.pc}"
            )
            if (
                resolution.target_module_path,
                resolution.target_prototype_id,
                tailcall_site_id,
            ) in resolved_callsites:
                continue
            flows.append(
                InterproceduralFlowRelation(
                    caller_module_path=resolution.caller_module_path,
                    caller_prototype_id=resolution.caller_prototype_id,
                    callsite_id=resolution.callsite_id,
                    callee_module_path=resolution.target_module_path,
                    callee_prototype_id=resolution.target_prototype_id,
                    source_ref=(
                        f"{resolution.target_prototype_id}@pc{tailcall.pc}:"
                        f"r{tailcall.operand_a}"
                    ),
                    sink_ref=(
                        f"{resolution.caller_prototype_id}@pc{call_pc}:"
                        f"r{call.operand_a}"
                    ),
                    flow_kind="return-to-result",
                    position=0,
                    provenance=(
                        f"bytecode-only,{resolution_provenance},"
                        "structural-tailcall-result"
                    ),
                )
            )
            if tailcall.operand_b == 0:
                argument_refs = [
                    (
                        source_ref,
                        (
                            "bytecode-only,resolved-call,"
                            "structural-tailcall-producer-proven-open-argument"
                        ),
                    )
                    for slot, source_ref in sorted(
                        proven_reads_by_site.get(
                            (
                                resolution.target_module_path,
                                resolution.target_prototype_id,
                                tailcall_site_id,
                            ),
                            {},
                        ).items()
                    )
                    if slot > tailcall.operand_a
                ]
            else:
                argument_refs = [
                    (
                        (
                            f"{resolution.target_prototype_id}@pc{tailcall.pc}:"
                            f"r{argument_slot}"
                        ),
                        (
                            "bytecode-only,resolved-call,"
                            "structural-tailcall-argument"
                        ),
                    )
                    for argument_slot in range(
                        tailcall.operand_a + 1,
                        tailcall.operand_a + tailcall.operand_b,
                    )
                ]
            for source_ref, argument_provenance in argument_refs:
                flows.append(
                    InterproceduralFlowRelation(
                        caller_module_path=resolution.caller_module_path,
                        caller_prototype_id=resolution.caller_prototype_id,
                        callsite_id=resolution.callsite_id,
                        callee_module_path=resolution.target_module_path,
                        callee_prototype_id=resolution.target_prototype_id,
                        source_ref=source_ref,
                        sink_ref=(
                            f"{resolution.caller_prototype_id}@pc{call_pc}:"
                            f"r{call.operand_a}"
                        ),
                        flow_kind="return-to-result",
                        position=0,
                        provenance=argument_provenance,
                    )
                )

    callers_by_target_scope: dict[
        tuple[str, str],
        list[tuple[CallResolutionRelation, InstructionIdentityRelation]],
    ] = defaultdict(list)
    for resolution in call_resolutions:
        call_pc = int(resolution.callsite_id.rsplit("@pc", 1)[1])
        call = instruction_by_site.get(
            (
                resolution.caller_module_path,
                resolution.caller_prototype_id,
                call_pc,
            )
        )
        if call is None or call.opcode not in {"CALL", "TAILCALL"}:
            continue
        if call.opcode == "CALL" and call.operand_c == 1:
            continue
        if call.opcode == "TAILCALL" and call.operand_c != 0:
            continue
        callers_by_target_scope[
            (resolution.target_module_path, resolution.target_prototype_id)
        ].append((resolution, call))

    tailcall_summaries = deque(
        flow
        for flow in flows
        if flow.provenance.startswith("bytecode-only,resolved-tailcall,")
    )
    forwarded: set[tuple[str, str, str, str, int]] = set()
    while tailcall_summaries:
        tailcall_return = tailcall_summaries.popleft()
        target_scope = (
            tailcall_return.caller_module_path,
            tailcall_return.caller_prototype_id,
        )
        for resolution, call in callers_by_target_scope.get(target_scope, []):
            position = tailcall_return.position
            if call.operand_c > 0 and position >= call.operand_c - 1:
                continue
            call_pc = int(resolution.callsite_id.rsplit("@pc", 1)[1])
            sink_ref = (
                f"{resolution.caller_prototype_id}@pc{call_pc}:"
                f"r{call.operand_a + position}"
            )
            key = (
                resolution.caller_module_path,
                resolution.callsite_id,
                tailcall_return.sink_ref,
                sink_ref,
                position,
            )
            if key in forwarded:
                continue
            forwarded.add(key)
            if call.opcode == "TAILCALL":
                provenance = (
                    "bytecode-only,resolved-tailcall,tailcall-chain-forward"
                )
            else:
                provenance = (
                    "bytecode-only,resolved-call,resolved-tailcall,"
                    "tailcall-forward"
                )
            forwarded_flow = InterproceduralFlowRelation(
                caller_module_path=resolution.caller_module_path,
                caller_prototype_id=resolution.caller_prototype_id,
                callsite_id=resolution.callsite_id,
                callee_module_path=resolution.target_module_path,
                callee_prototype_id=resolution.target_prototype_id,
                source_ref=tailcall_return.sink_ref,
                sink_ref=sink_ref,
                flow_kind="return-to-result",
                position=position,
                provenance=provenance,
            )
            flows.append(forwarded_flow)
            if call.opcode == "TAILCALL":
                tailcall_summaries.append(forwarded_flow)
    return flows


def _root_module_call_evidence(
    module_path: str,
    chunk: Chunk,
    flows: list[ValueFlowRelation],
    call_resolutions: list[CallResolutionRelation],
) -> tuple[str | None, bool]:
    reaching_sources_by_ref: dict[str, set[str]] = defaultdict(set)
    for flow in flows:
        if flow.prototype_id == "root" and flow.kind == "reaching-definition":
            reaching_sources_by_ref[flow.sink_ref].add(flow.source_ref)
    instruction_by_ref = {
        f"root@pc{pc}:r{instruction.a}": (pc, instruction)
        for pc, instruction in enumerate(chunk.instructions)
    }
    module_names: set[str] = set()
    seeall_module_names: set[str] = set()
    for resolution in call_resolutions:
        if (
            resolution.caller_prototype_id != "root"
            or resolution.resolved_name != "module"
        ):
            continue
        pc = int(resolution.callsite_id.rsplit("@pc", 1)[1])
        call = chunk.instructions[pc]
        argument_ref = f"root@pc{pc}:r{call.a + 1}"
        sources = reaching_sources_by_ref.get(argument_ref, set())
        if len(sources) != 1:
            continue
        loadk_entry = instruction_by_ref.get(next(iter(sources)))
        if loadk_entry is None or loadk_entry[1].opcode.name != "LOADK":
            continue
        loadk = loadk_entry[1]
        module_name = _constant_string(chunk, loadk.b)
        if module_name not in _module_names_for_path(module_path):
            continue
        module_names.add(module_name)
        if call.b < 3:
            continue
        seeall_ref = f"root@pc{pc}:r{call.a + 2}"
        seeall_names: set[str] = set()
        for member_ref in reaching_sources_by_ref.get(seeall_ref, set()):
            member_entry = instruction_by_ref.get(member_ref)
            if member_entry is None or member_entry[1].opcode.name != "GETTABLE":
                continue
            member_pc, member = member_entry
            member_name = _constant_string_operand(chunk, member.c)
            if member_name is None:
                continue
            base_ref = f"root@pc{member_pc}:r{member.b}"
            for global_ref in reaching_sources_by_ref.get(base_ref, set()):
                global_entry = instruction_by_ref.get(global_ref)
                if global_entry is None or global_entry[1].opcode.name != "GETGLOBAL":
                    continue
                global_name = _constant_string(chunk, global_entry[1].b)
                if global_name is not None:
                    seeall_names.add(f"{global_name}.{member_name}")
        if seeall_names == {"package.seeall"}:
            seeall_module_names.add(module_name)
    if len(module_names) != 1:
        return None, False
    module_name = next(iter(module_names))
    return module_name, module_name in seeall_module_names


def _root_returned_table_exports(
    module_path: str,
    chunk: Chunk,
    flows: list[ValueFlowRelation],
    call_resolutions: list[CallResolutionRelation],
) -> list[ModuleExportRelation]:
    module_call_name, module_seeall = _root_module_call_evidence(
        module_path,
        chunk,
        flows,
        call_resolutions,
    )
    table_by_slot: dict[int, str] = {}
    closure_by_slot: dict[int, tuple[str, str]] = {}
    global_closure_by_name: dict[str, tuple[str, str]] = {}
    aliased_closure_slots: set[int] = set()
    fields_by_table: dict[str, dict[str, tuple[str, str]]] = defaultdict(dict)
    global_table_by_name: dict[str, str] = {}
    global_names_by_table: dict[str, set[str]] = defaultdict(set)
    returned_tables: set[str] = set()
    returned_closures: set[tuple[str, str]] = set()
    global_exports: list[ModuleExportRelation] = []
    closure_binding_pcs = _closure_binding_pcs(chunk)

    def clear_slot(slot: int) -> None:
        table_by_slot.pop(slot, None)
        closure_by_slot.pop(slot, None)
        aliased_closure_slots.discard(slot)

    for pc, instruction in enumerate(chunk.instructions):
        if pc in closure_binding_pcs:
            continue
        opcode = instruction.opcode.name
        if opcode == "NEWTABLE":
            clear_slot(instruction.a)
            table_ref = f"root@pc{pc}:r{instruction.a}"
            table_by_slot[instruction.a] = table_ref
            fields_by_table.setdefault(table_ref, {})
        elif opcode == "CLOSURE":
            clear_slot(instruction.a)
            if instruction.b < len(chunk.protos):
                closure_by_slot[instruction.a] = (
                    f"root@pc{pc}:r{instruction.a}",
                    f"root.{instruction.b}",
                )
        elif opcode == "MOVE":
            table_ref = table_by_slot.get(instruction.b)
            closure = closure_by_slot.get(instruction.b)
            closure_is_alias = instruction.b in aliased_closure_slots
            clear_slot(instruction.a)
            if table_ref is not None:
                table_by_slot[instruction.a] = table_ref
            if closure is not None:
                closure_by_slot[instruction.a] = closure
                if closure_is_alias:
                    aliased_closure_slots.add(instruction.a)
        elif opcode == "GETGLOBAL":
            clear_slot(instruction.a)
            global_name = _constant_string(chunk, instruction.b)
            table_ref = (
                global_table_by_name.get(global_name)
                if global_name is not None
                else None
            )
            if table_ref is not None:
                table_by_slot[instruction.a] = table_ref
            closure = (
                global_closure_by_name.get(global_name)
                if module_seeall and global_name is not None
                else None
            )
            if closure is not None:
                closure_by_slot[instruction.a] = closure
                aliased_closure_slots.add(instruction.a)
        elif opcode == "SETTABLE":
            table_ref = table_by_slot.get(instruction.a)
            field_name = _constant_string_operand(chunk, instruction.b)
            closure = (
                closure_by_slot.get(instruction.c)
                if instruction.c < LUA_RK_CONSTANT_BIT
                else None
            )
            if table_ref is not None and field_name is not None and closure is not None:
                fields_by_table[table_ref][field_name] = closure
                if module_call_name is not None:
                    for global_name in sorted(global_names_by_table[table_ref]):
                        global_exports.append(
                            ModuleExportRelation(
                                module_path=module_path,
                                export_kind="module-global-table-field",
                                field_name=f"{global_name}.{field_name}",
                                value_ref=closure[0],
                                target_prototype_id=closure[1],
                                provenance=(
                                    "bytecode-only,module-global-table-field-export,"
                                    "module-call"
                                ),
                            )
                        )
                        if module_seeall:
                            global_exports.append(
                                ModuleExportRelation(
                                    module_path=module_path,
                                    export_kind="module-global-table-field",
                                    field_name=f"{global_name}.{field_name}",
                                    value_ref=closure[0],
                                    target_prototype_id=closure[1],
                                    provenance=(
                                        "bytecode-only,module-global-table-field-export,"
                                        "module-seeall"
                                    ),
                                )
                            )
        elif opcode == "SETGLOBAL":
            closure = closure_by_slot.get(instruction.a)
            table_ref = table_by_slot.get(instruction.a)
            field_name = _constant_string(chunk, instruction.b)
            if module_call_name is not None and field_name:
                previous_table_ref = global_table_by_name.pop(field_name, None)
                if previous_table_ref is not None:
                    global_names_by_table[previous_table_ref].discard(field_name)
                if table_ref is not None:
                    global_table_by_name[field_name] = table_ref
                    global_names_by_table[table_ref].add(field_name)
            if module_call_name is not None and closure is not None and field_name:
                if module_seeall:
                    global_closure_by_name[field_name] = closure
                if instruction.a not in aliased_closure_slots:
                    global_exports.append(
                        ModuleExportRelation(
                            module_path=module_path,
                            export_kind="module-global",
                            field_name=field_name,
                            value_ref=closure[0],
                            target_prototype_id=closure[1],
                            provenance="bytecode-only,module-global-export,module-call",
                        )
                    )
                if module_seeall:
                    global_exports.append(
                        ModuleExportRelation(
                            module_path=module_path,
                            export_kind="module-global",
                            field_name=field_name,
                            value_ref=closure[0],
                            target_prototype_id=closure[1],
                            provenance="bytecode-only,module-global-export,module-seeall",
                        )
                    )
        elif opcode == "RETURN" and instruction.b == 2:
            table_ref = table_by_slot.get(instruction.a)
            if table_ref is not None:
                returned_tables.add(table_ref)
            closure = closure_by_slot.get(instruction.a)
            if closure is not None:
                returned_closures.add(closure)
        else:
            effects = _fixed_instruction_effects(
                opcode,
                instruction.a,
                instruction.b,
                instruction.c,
            )
            if effects is not None:
                for slot in effects[1]:
                    clear_slot(slot)

    exports = list(global_exports)
    for table_ref in sorted(returned_tables):
        for field_name, (value_ref, target_prototype_id) in sorted(
            fields_by_table[table_ref].items()
        ):
            exports.append(
                ModuleExportRelation(
                    module_path=module_path,
                    export_kind="returned-table-field",
                    field_name=field_name,
                    value_ref=value_ref,
                    target_prototype_id=target_prototype_id,
                    provenance="bytecode-only,module-return-table",
                )
            )
    for value_ref, target_prototype_id in sorted(returned_closures):
        exports.append(
            ModuleExportRelation(
                module_path=module_path,
                export_kind="returned-closure",
                field_name="",
                value_ref=value_ref,
                target_prototype_id=target_prototype_id,
                provenance="bytecode-only,module-return-closure",
            )
        )
    return exports


def analyze_corpus(corpus: AcceptedCorpus) -> AnalysisResult:
    artifact_identities: list[ArtifactIdentityRelation] = []
    prototype_identities: list[PrototypeIdentityRelation] = []
    instruction_identities: list[InstructionIdentityRelation] = []
    value_identities: list[ValueIdentityRelation] = []
    value_flows: list[ValueFlowRelation] = []
    table_field_flows: list[TableFieldFlowRelation] = []
    global_flows: list[GlobalFlowRelation] = []
    upvalue_flows: list[UpvalueFlowRelation] = []
    call_resolutions: list[CallResolutionRelation] = []
    literal_requires: list[LiteralRequireRelation] = []
    module_exports: list[ModuleExportRelation] = []
    boundaries: list[AnalysisBoundary] = []
    chunks_by_module: dict[str, Chunk] = {}
    seen_module_paths: set[str] = set()

    for artifact in sorted(corpus.artifacts, key=lambda item: item.module_path):
        _validate_module_path(artifact.module_path)
        if artifact.module_path in seen_module_paths:
            raise ValueError(f"duplicate normalized module path: {artifact.module_path}")
        seen_module_paths.add(artifact.module_path)

        loaded = artifact.loaded_artifact
        if not loaded.accepted or loaded.chunk is None:
            raise ValueError(f"corpus artifact is not accepted bytecode: {artifact.module_path}")
        chunks_by_module[artifact.module_path] = loaded.chunk

        artifact_identities.append(
            ArtifactIdentityRelation(
                module_path=artifact.module_path,
                profile_id=loaded.profile_id,
            )
        )
        (
            prototypes,
            instructions,
            values,
            flows,
            table_flows,
            prototype_global_flows,
            prototype_upvalue_flows,
            prototype_boundaries,
        ) = _walk_prototypes(
            artifact.module_path,
            loaded.chunk,
            "root",
            "",
            -1,
        )
        prototype_call_resolutions, call_boundaries = _artifact_call_resolutions(
            artifact.module_path,
            loaded.chunk,
            prototypes,
            instructions,
            flows,
            table_flows,
            prototype_global_flows,
            prototype_upvalue_flows,
        )
        prototype_literal_requires, literal_require_boundaries = (
            _artifact_literal_requires(
                artifact.module_path,
                loaded.chunk,
                instructions,
                flows,
                prototype_call_resolutions,
            )
        )
        prototype_identities.extend(prototypes)
        instruction_identities.extend(instructions)
        value_identities.extend(values)
        value_flows.extend(flows)
        table_field_flows.extend(table_flows)
        global_flows.extend(prototype_global_flows)
        upvalue_flows.extend(prototype_upvalue_flows)
        call_resolutions.extend(prototype_call_resolutions)
        literal_requires.extend(prototype_literal_requires)
        module_exports.extend(
            _root_returned_table_exports(
                artifact.module_path,
                loaded.chunk,
                flows,
                prototype_call_resolutions,
            )
        )
        boundaries.extend(prototype_boundaries)
        boundaries.extend(call_boundaries)
        boundaries.extend(literal_require_boundaries)

    module_resolutions, module_resolution_boundaries = _module_resolutions(
        [identity.module_path for identity in artifact_identities],
        literal_requires,
    )
    boundaries.extend(module_resolution_boundaries)
    (
        module_field_resolutions,
        resolved_module_field_sites,
        unresolved_module_field_sites,
    ) = (
        _cross_module_field_call_resolutions(
            chunks_by_module,
            instruction_identities,
            value_flows,
            upvalue_flows,
            call_resolutions,
            literal_requires,
            module_resolutions,
            module_exports,
        )
    )
    reconciled_module_field_sites = (
        resolved_module_field_sites | unresolved_module_field_sites
    )
    call_resolutions = [
        resolution
        for resolution in call_resolutions
        if (
            resolution.caller_module_path,
            resolution.caller_prototype_id,
            resolution.callsite_id,
        ) not in reconciled_module_field_sites
    ]
    call_resolutions.extend(module_field_resolutions)
    call_resolutions = _same_module_export_call_resolutions(
        call_resolutions,
        module_exports,
    )
    interprocedural_flows = _interprocedural_argument_flows(
        prototype_identities,
        instruction_identities,
        value_flows,
        call_resolutions,
    )
    interprocedural_flows.extend(
        _interprocedural_return_flows(
            instruction_identities,
            value_flows,
            call_resolutions,
        )
    )
    interprocedural_flows.sort(
        key=lambda flow: (
            flow.caller_module_path,
            flow.caller_prototype_id,
            flow.callsite_id,
            flow.callee_module_path,
            flow.callee_prototype_id,
            flow.flow_kind,
            flow.position,
            flow.source_ref,
            flow.sink_ref,
        )
    )
    boundaries = [
        boundary
        for boundary in boundaries
        if not (
            boundary.boundary_kind == "unresolved-call-target"
            and (boundary.module_path, boundary.prototype_id, boundary.site_id)
            in resolved_module_field_sites
        )
    ]
    unresolved_boundary_sites = {
        (boundary.module_path, boundary.prototype_id, boundary.site_id)
        for boundary in boundaries
        if boundary.boundary_kind == "unresolved-call-target"
    }
    boundaries.extend(
        AnalysisBoundary(
            module_path=module_path,
            prototype_id=prototype_id,
            site_id=callsite_id,
            boundary_kind="unresolved-call-target",
            reason="no-proven-target",
            provenance="bytecode-only,call-resolution-boundary",
        )
        for module_path, prototype_id, callsite_id in sorted(
            unresolved_module_field_sites
        )
        if (module_path, prototype_id, callsite_id) not in unresolved_boundary_sites
    )
    control_flow_edges = _control_flow_edges(instruction_identities)
    dominator_tree_intervals = _dominator_tree_intervals(instruction_identities)
    return AnalysisResult(
        artifact_identities=tuple(artifact_identities),
        prototype_identities=tuple(prototype_identities),
        instruction_identities=tuple(instruction_identities),
        value_identities=tuple(value_identities),
        value_flows=tuple(value_flows),
        control_flow_edges=tuple(control_flow_edges),
        dominator_tree_intervals=tuple(dominator_tree_intervals),
        table_field_flows=tuple(table_field_flows),
        global_flows=tuple(global_flows),
        upvalue_flows=tuple(upvalue_flows),
        call_resolutions=tuple(call_resolutions),
        literal_requires=tuple(literal_requires),
        module_resolutions=tuple(module_resolutions),
        module_exports=tuple(module_exports),
        interprocedural_flows=tuple(interprocedural_flows),
        boundaries=tuple(boundaries),
    )
