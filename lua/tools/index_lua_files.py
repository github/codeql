#!/usr/bin/env python3
"""Emit CodeQL TRAP facts for Lua source and Lua 5.1 bytecode smoke tests."""

from __future__ import annotations

import argparse
import hashlib
import shutil
from pathlib import Path

from corpus_analyzer import (
    AcceptedCorpus,
    AnalysisBoundary,
    ArtifactIdentityRelation,
    CallResolutionRelation,
    ControlFlowEdgeRelation,
    CorpusArtifact,
    DominatorTreeIntervalRelation,
    GlobalFlowRelation,
    InterproceduralFlowRelation,
    LiteralRequireRelation,
    ModuleExportRelation,
    ModuleResolutionRelation,
    TableFieldFlowRelation,
    UpvalueFlowRelation,
    ValueFlowRelation,
    analyze_corpus,
)
from lua_bytecode import (
    BytecodeError,
    Chunk,
    Instruction,
    LoadedArtifact,
    Lua51Loader,
)
from semantic_normalizer import (
    CallSite,
    ClosureValue,
    InstructionSemanticNormalizer,
    RegisterEvent,
    SemanticStep,
)
from trap_writer import TrapLabel, TrapWriter


SOURCE_ROOT_SUFFIXES = {".lua", ".luac"}


class SemanticEmitter:
    def __init__(self, trap: TrapWriter, fixture_id: str, artifact_key: str):
        self.trap = trap
        self.fixture_id = fixture_id
        self.artifact_key = artifact_key
        self.normalizer = InstructionSemanticNormalizer()
        self.prototype_labels: dict[str, TrapLabel] = {}
        self.instruction_labels: dict[tuple[str, int], TrapLabel] = {}
        self.closure_targets_by_ref: dict[str, str] = {}

    def pcslot(self, prototype_id: str, pc: int, slot: int) -> str:
        return f"{prototype_id}@pc{pc}:r{slot}"

    def constant_text(self, chunk: Chunk, index: int) -> str | None:
        if 0 <= index < len(chunk.constants):
            return chunk.constants[index].text()
        return None

    def emit_upvalues(self, proto: TrapLabel, chunk: Chunk, prototype_id: str) -> None:
        for idx in range(chunk.num_upvalues):
            name = chunk.upvalues[idx] if idx < len(chunk.upvalues) and chunk.upvalues[idx] else "unavailable"
            mapping_state = "debug-derived-candidate" if name != "unavailable" else "stripped/unavailable"
            provenance = (
                "bytecode-only,debug-info-derived" if name != "unavailable" else "bytecode-only"
            )
            row = self.trap.label(f"upvalue;{self.fixture_id};{self.artifact_key};{prototype_id};{idx}")
            self.trap.tuple(
                "lua_upvalues",
                row,
                proto,
                self.fixture_id,
                f"{prototype_id}:u{idx}",
                prototype_id,
                idx,
                name,
                mapping_state,
                provenance,
            )

    def emit_instruction(self, proto: TrapLabel, prototype_id: str, pc: int, instr: Instruction) -> TrapLabel:
        row = self.trap.label(f"instruction;{self.fixture_id};{self.artifact_key};{prototype_id};{pc}")
        self.instruction_labels[(prototype_id, pc)] = row
        self.trap.tuple(
            "lua_instructions",
            row,
            proto,
            self.fixture_id,
            prototype_id,
            pc,
            instr.opcode.name,
            instr.a,
            instr.b,
            instr.c,
        )
        return row

    def emit_register_event(
        self, instr_label: TrapLabel, prototype_id: str, pc: int, kind: str, slot: int
    ) -> None:
        row = self.trap.label(
            f"reg;{self.fixture_id};{self.artifact_key};{prototype_id};{pc};{kind};{slot}"
        )
        self.trap.tuple(
            "lua_register_events",
            row,
            instr_label,
            self.fixture_id,
            prototype_id,
            pc,
            kind,
            slot,
            self.pcslot(prototype_id, pc, slot),
        )

    def emit_semantic_step(self, instr_label: TrapLabel, source_ref: str, dest_ref: str, kind: str) -> None:
        row = self.trap.label(f"step;{self.fixture_id};{self.artifact_key};{source_ref};{dest_ref};{kind}")
        self.trap.tuple("lua_semantic_steps", row, instr_label, self.fixture_id, source_ref, dest_ref, kind)

    def emit_closure_value(
        self, instr_label: TrapLabel, value_ref: str, target_prototype_id: str, provenance: str
    ) -> None:
        row = self.trap.label(f"closure;{self.fixture_id};{self.artifact_key};{value_ref}")
        self.trap.tuple(
            "lua_closure_values",
            row,
            instr_label,
            self.fixture_id,
            value_ref,
            target_prototype_id,
            provenance,
        )
        self.closure_targets_by_ref[value_ref] = target_prototype_id

    def emit_call_site(self, instr_label: TrapLabel, prototype_id: str, item: CallSite) -> None:
        row = self.trap.label(f"call;{self.fixture_id};{self.artifact_key};{item.callsite_id}")
        pc = int(item.callsite_id.rsplit("@pc", 1)[1])
        self.trap.tuple(
            "lua_call_sites",
            row,
            instr_label,
            self.fixture_id,
            item.callsite_id,
            prototype_id,
            pc,
            item.opcode,
            item.target_value_ref,
            item.first_arg_slot,
            item.arg_count,
            item.first_return_slot,
            item.return_count,
        )

    def emit_local_flow(
        self,
        prototype_id: str,
        source_ref: str,
        sink_ref: str,
        edge_kind: str,
        provenance: str = "bytecode-only",
    ) -> None:
        if source_ref == sink_ref:
            return
        row = self.trap.label(
            f"local-flow;{self.fixture_id};{prototype_id};{source_ref};{sink_ref};{edge_kind}"
        )
        self.trap.tuple(
            "lua_local_flows",
            row,
            self.fixture_id,
            prototype_id,
            source_ref,
            sink_ref,
            edge_kind,
            provenance,
        )

    def emit_analyzed_local_flow(self, flow: ValueFlowRelation) -> None:
        if flow.module_path != self.fixture_id:
            raise ValueError(
                f"analysis flow module {flow.module_path!r} does not match {self.fixture_id!r}"
            )
        self.emit_local_flow(
            flow.prototype_id,
            flow.source_ref,
            flow.sink_ref,
            flow.kind,
            flow.provenance,
        )

    def emit_analyzed_control_flow_edge(
        self, edge: ControlFlowEdgeRelation
    ) -> None:
        if edge.module_path != self.fixture_id:
            raise ValueError(
                f"control-flow edge module {edge.module_path!r} does not match "
                f"{self.fixture_id!r}"
            )
        source = self.instruction_labels[(edge.prototype_id, edge.source_pc)]
        target = self.instruction_labels[(edge.prototype_id, edge.target_pc)]
        row = self.trap.label(
            f"control-flow-edge;{edge.module_path};{edge.prototype_id};"
            f"{edge.source_pc};{edge.target_pc}"
        )
        self.trap.tuple(
            "lua_control_flow_edges",
            row,
            source,
            target,
            edge.module_path,
            edge.prototype_id,
            edge.source_pc,
            edge.target_pc,
            edge.provenance,
        )

    def emit_analyzed_dominator_tree_interval(
        self, interval: DominatorTreeIntervalRelation
    ) -> None:
        if interval.module_path != self.fixture_id:
            raise ValueError(
                f"dominator interval module {interval.module_path!r} does not match "
                f"{self.fixture_id!r}"
            )
        instruction = self.instruction_labels[(interval.prototype_id, interval.pc)]
        row = self.trap.label(
            f"dominator-tree-interval;{interval.module_path};{interval.prototype_id};"
            f"{interval.pc}"
        )
        self.trap.tuple(
            "lua_dominator_tree_intervals",
            row,
            instruction,
            interval.module_path,
            interval.prototype_id,
            interval.pc,
            interval.start,
            interval.end,
            interval.provenance,
        )

    def emit_analysis_boundary(self, boundary: AnalysisBoundary) -> None:
        if boundary.module_path != self.fixture_id:
            raise ValueError(
                f"analysis boundary module {boundary.module_path!r} does not match "
                f"{self.fixture_id!r}"
            )
        row = self.trap.label(
            f"analysis-boundary;{boundary.module_path};{boundary.prototype_id};"
            f"{boundary.site_id};{boundary.boundary_kind}"
        )
        self.trap.tuple(
            "lua_analysis_boundaries",
            row,
            boundary.module_path,
            boundary.prototype_id,
            boundary.site_id,
            boundary.boundary_kind,
            boundary.reason,
            boundary.provenance,
        )

    def emit_analyzed_call_resolution(self, resolution: CallResolutionRelation) -> None:
        if resolution.caller_module_path != self.fixture_id:
            raise ValueError(
                f"call resolution module {resolution.caller_module_path!r} does not match "
                f"{self.fixture_id!r}"
            )
        row = self.trap.label(
            f"call-resolution;{resolution.caller_module_path};"
            f"{resolution.caller_prototype_id};{resolution.callsite_id};"
            f"{resolution.target_value_ref};{resolution.resolution_kind};"
            f"{resolution.target_module_path};{resolution.target_prototype_id};"
            f"{resolution.resolved_name}"
        )
        self.trap.tuple(
            "lua_call_resolutions",
            row,
            resolution.caller_module_path,
            resolution.caller_prototype_id,
            resolution.callsite_id,
            resolution.target_value_ref,
            resolution.resolved_name,
            resolution.resolution_kind,
            resolution.target_module_path,
            resolution.target_prototype_id,
            resolution.provenance,
        )

    def emit_analyzed_literal_require(self, require: LiteralRequireRelation) -> None:
        if require.caller_module_path != self.fixture_id:
            raise ValueError(
                f"literal require module {require.caller_module_path!r} does not match "
                f"{self.fixture_id!r}"
            )
        row = self.trap.label(
            f"literal-require;{require.caller_module_path};"
            f"{require.caller_prototype_id};{require.callsite_id};"
            f"{require.require_string};{require.argument_ref}"
        )
        self.trap.tuple(
            "lua_literal_requires",
            row,
            require.caller_module_path,
            require.caller_prototype_id,
            require.callsite_id,
            require.require_string,
            require.argument_ref,
            require.provenance,
        )

    def emit_analyzed_module_resolution(
        self, resolution: ModuleResolutionRelation
    ) -> None:
        if resolution.caller_module_path != self.fixture_id:
            raise ValueError(
                f"module resolution caller {resolution.caller_module_path!r} does not match "
                f"{self.fixture_id!r}"
            )
        row = self.trap.label(
            f"module-resolution;{resolution.caller_module_path};"
            f"{resolution.callsite_id};{resolution.require_string};{resolution.status};"
            f"{resolution.target_module_path};{resolution.reason}"
        )
        self.trap.tuple(
            "lua_module_resolutions",
            row,
            resolution.caller_module_path,
            resolution.callsite_id,
            resolution.require_string,
            resolution.status,
            resolution.target_module_path,
            resolution.reason,
            resolution.provenance,
        )

    def emit_analyzed_module_export(self, export: ModuleExportRelation) -> None:
        if export.module_path != self.fixture_id:
            raise ValueError(
                f"module export path {export.module_path!r} does not match "
                f"{self.fixture_id!r}"
            )
        row = self.trap.label(
            f"module-export;{export.module_path};{export.export_kind};"
            f"{export.field_name};{export.value_ref};{export.target_prototype_id};"
            f"{export.provenance}"
        )
        self.trap.tuple(
            "lua_module_exports",
            row,
            export.module_path,
            export.export_kind,
            export.field_name,
            export.value_ref,
            export.target_prototype_id,
            export.provenance,
        )

    def emit_analyzed_interprocedural_flow(
        self, flow: InterproceduralFlowRelation
    ) -> None:
        if flow.caller_module_path != self.fixture_id:
            raise ValueError(
                f"interprocedural flow caller {flow.caller_module_path!r} does not match "
                f"{self.fixture_id!r}"
            )
        row = self.trap.label(
            f"interprocedural-flow;{flow.caller_module_path};"
            f"{flow.caller_prototype_id};{flow.callsite_id};"
            f"{flow.callee_module_path};{flow.callee_prototype_id};"
            f"{flow.source_ref};{flow.sink_ref};{flow.flow_kind};"
            f"{flow.position};{flow.provenance}"
        )
        self.trap.tuple(
            "lua_interprocedural_flows",
            row,
            flow.caller_module_path,
            flow.caller_prototype_id,
            flow.callsite_id,
            flow.callee_module_path,
            flow.callee_prototype_id,
            flow.source_ref,
            flow.sink_ref,
            flow.flow_kind,
            flow.position,
            flow.provenance,
        )

    def emit_analyzed_table_field_flow(self, flow: TableFieldFlowRelation) -> None:
        if flow.module_path != self.fixture_id:
            raise ValueError(
                f"table flow module {flow.module_path!r} does not match {self.fixture_id!r}"
            )
        row = self.trap.label(
            f"table-flow;{flow.module_path};{flow.prototype_id};{flow.table_ref};"
            f"{flow.field_name};{flow.write_ref};{flow.read_ref}"
        )
        self.trap.tuple(
            "lua_table_field_flows",
            row,
            flow.module_path,
            flow.prototype_id,
            flow.table_ref,
            flow.field_name,
            flow.write_ref,
            flow.read_ref,
            flow.provenance,
        )
        self.emit_local_flow(
            flow.prototype_id,
            flow.write_ref,
            flow.read_ref,
            "table-write-to-read",
            flow.provenance,
        )

    def emit_analyzed_global_flow(self, flow: GlobalFlowRelation) -> None:
        if flow.module_path != self.fixture_id:
            raise ValueError(
                f"global flow module {flow.module_path!r} does not match {self.fixture_id!r}"
            )
        row = self.trap.label(
            f"global-flow;{flow.module_path};{flow.global_name};{flow.write_ref};"
            f"{flow.read_ref};{flow.value_ref}"
        )
        self.trap.tuple(
            "lua_global_flows",
            row,
            flow.module_path,
            flow.global_name,
            flow.write_ref,
            flow.read_ref,
            flow.value_ref,
            flow.provenance,
        )
        self.emit_local_flow(
            flow.prototype_id,
            flow.value_ref,
            flow.read_ref,
            "global-write-to-read",
            flow.provenance,
        )

    def emit_analyzed_upvalue_flow(self, flow: UpvalueFlowRelation) -> None:
        if flow.module_path != self.fixture_id:
            raise ValueError(
                f"upvalue flow module {flow.module_path!r} does not match {self.fixture_id!r}"
            )
        row = self.trap.label(
            f"upvalue-flow;{flow.module_path};{flow.upvalue_id};{flow.capture_ref};"
            f"{flow.read_ref};{flow.write_ref}"
        )
        self.trap.tuple(
            "lua_upvalue_flows",
            row,
            flow.module_path,
            flow.upvalue_id,
            flow.capture_ref,
            flow.read_ref,
            flow.write_ref,
            flow.provenance,
        )

    def emit_instruction_semantics(self, prototype_id: str, pc: int, instr: Instruction, chunk: Chunk) -> None:
        instr_label = self.instruction_labels[(prototype_id, pc)]
        semantics = self.normalizer.normalize(prototype_id, pc, instr, chunk)
        for item in semantics.effects:
            if isinstance(item, RegisterEvent):
                self.emit_register_event(instr_label, prototype_id, pc, item.kind, item.slot)
            elif isinstance(item, SemanticStep):
                self.emit_semantic_step(instr_label, item.source_ref, item.dest_ref, item.kind)
            elif isinstance(item, ClosureValue):
                self.emit_closure_value(
                    instr_label, item.value_ref, item.target_prototype_id, item.provenance
                )
            elif isinstance(item, CallSite):
                self.emit_call_site(instr_label, prototype_id, item)
            else:
                raise TypeError(f"unsupported instruction semantic effect: {type(item).__name__}")

    def emit_prototype_semantics(self, prototype_id: str, chunk: Chunk) -> None:
        for pc, instr in enumerate(chunk.instructions):
            self.emit_instruction_semantics(prototype_id, pc, instr, chunk)
        for idx, child in enumerate(chunk.protos):
            child_id = f"{prototype_id}.{idx}" if prototype_id else str(idx)
            self.emit_prototype_semantics(child_id, child)


def display_path(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(Path.cwd().resolve()))
    except ValueError:
        return str(path)


def copy_source(path: Path, source_archive_dir: Path) -> None:
    archive_path = str(path.resolve()).replace(":", "_").lstrip("/\\")
    target = source_archive_dir / archive_path
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(path, target)


def file_fact_labels(
    trap: TrapWriter, path: Path
) -> tuple[TrapLabel, TrapLabel, TrapLabel, str]:
    rel = display_path(path)
    file_label = trap.label(f"{rel};sourcefile")
    folder_label = trap.label(str(path.parent))
    loc_label = trap.label(f"loc,{rel},1,1,1,1")
    return file_label, folder_label, loc_label, rel


def emit_file_fact_tuples(
    trap: TrapWriter,
    file_label: TrapLabel,
    folder_label: TrapLabel,
    loc_label: TrapLabel,
    path: Path,
    rel: str,
) -> None:
    trap.tuple("files", file_label, rel)
    trap.tuple("folders", folder_label, str(path.parent))
    trap.tuple("containerparent", folder_label, file_label)
    trap.tuple("locations_default", loc_label, file_label, 1, 1, 1, 1)


def emit_lua_source_file(trap: TrapWriter, path: Path, source_archive_dir: Path) -> None:
    file_label, folder_label, loc_label, rel = file_fact_labels(trap, path)
    content = path.read_bytes()
    text = content.decode("utf-8")
    line_count = len(text.splitlines())
    byte_count = len(content)
    sha256 = hashlib.sha256(content).hexdigest()
    source_label = trap.label(f"lua-source-file;{rel}")
    emit_file_fact_tuples(trap, file_label, folder_label, loc_label, path, rel)
    trap.tuple("lua_source_files", source_label, file_label, rel, line_count, byte_count, sha256)
    copy_source(path, source_archive_dir)


def debug_metadata_state(chunk: Chunk) -> tuple[str, str]:
    if chunk.name:
        return "debug-derived-candidate", "bytecode-only,debug-info-derived"
    return "stripped/unavailable", "bytecode-only"


def emit_profile(trap: TrapWriter, artifact: TrapLabel, loaded: LoadedArtifact) -> None:
    profile = loaded.profile
    trap.tuple(
        "lua_profiles",
        artifact,
        f"0x{profile['version']:02x}",
        profile["format"],
        profile["little_endian"],
        profile["int_size"],
        profile["size_t_size"],
        profile["instruction_size"],
        profile["lua_number_size"],
        profile["integral_flag"],
    )


def emit_chunk(
    trap: TrapWriter,
    artifact: TrapLabel,
    fixture_id: str,
    artifact_key: str,
    chunk: Chunk,
    prototype_id: str,
    parent_id: str,
    ordinal_index: int,
    semantic_emitter: SemanticEmitter | None = None,
) -> None:
    proto = trap.label(f"prototype;{fixture_id};{artifact_key};{prototype_id}")
    if semantic_emitter is not None:
        semantic_emitter.prototype_labels[prototype_id] = proto
    debug_name = chunk.name or "unavailable"
    mapping_state, provenance = debug_metadata_state(chunk)
    trap.tuple(
        "lua_prototypes",
        proto,
        artifact,
        fixture_id,
        prototype_id,
        parent_id,
        ordinal_index,
        chunk.num_params,
        1 if chunk.is_vararg else 0,
        chunk.max_stack,
        chunk.num_upvalues,
        debug_name,
        mapping_state,
        provenance,
    )

    for idx, const in enumerate(chunk.constants):
        const_label = trap.label(f"constant;{fixture_id};{artifact_key};{prototype_id};{idx}")
        trap.tuple(
            "lua_constants",
            const_label,
            proto,
            fixture_id,
            f"{prototype_id}:k{idx}",
            prototype_id,
            idx,
            const.type_name,
            const.text(),
        )

    if semantic_emitter is not None:
        semantic_emitter.emit_upvalues(proto, chunk, prototype_id)
        for pc, instr in enumerate(chunk.instructions):
            semantic_emitter.emit_instruction(proto, prototype_id, pc, instr)

    for idx, child in enumerate(chunk.protos):
        child_id = f"{prototype_id}.{idx}" if prototype_id else str(idx)
        emit_chunk(
            trap,
            artifact,
            fixture_id,
            artifact_key,
            child,
            child_id,
            prototype_id,
            idx,
            semantic_emitter,
        )


def emit_loaded_bytecode(
    trap: TrapWriter,
    path: Path,
    source_archive_dir: Path,
    loaded: LoadedArtifact,
    identity: ArtifactIdentityRelation,
    value_flows: tuple[ValueFlowRelation, ...],
    control_flow_edges: tuple[ControlFlowEdgeRelation, ...],
    dominator_tree_intervals: tuple[DominatorTreeIntervalRelation, ...],
    boundaries: tuple[AnalysisBoundary, ...],
    call_resolutions: tuple[CallResolutionRelation, ...],
    literal_requires: tuple[LiteralRequireRelation, ...],
    module_resolutions: tuple[ModuleResolutionRelation, ...],
    module_exports: tuple[ModuleExportRelation, ...],
    interprocedural_flows: tuple[InterproceduralFlowRelation, ...],
    table_field_flows: tuple[TableFieldFlowRelation, ...],
    global_flows: tuple[GlobalFlowRelation, ...],
    upvalue_flows: tuple[UpvalueFlowRelation, ...],
) -> None:
    file_label, folder_label, loc_label, _ = file_fact_labels(trap, path)
    rel = identity.module_path
    emit_file_fact_tuples(trap, file_label, folder_label, loc_label, path, rel)
    copy_source(path, source_archive_dir)
    fixture_id = rel
    artifact = trap.label(f"artifact;{fixture_id};{rel}")
    trap.tuple(
        "lua_artifacts",
        artifact,
        fixture_id,
        rel,
        "bytecode-only",
        loaded.profile_id,
        1,
        "bytecode-only",
    )
    emit_profile(trap, artifact, loaded)
    if loaded.chunk is None:
        raise RuntimeError(f"{rel}: accepted bytecode has no loaded chunk")
    semantic_emitter = SemanticEmitter(trap, fixture_id, rel)
    emit_chunk(trap, artifact, fixture_id, rel, loaded.chunk, "root", "", -1, semantic_emitter)
    semantic_emitter.emit_prototype_semantics("root", loaded.chunk)
    for flow in value_flows:
        semantic_emitter.emit_analyzed_local_flow(flow)
    for edge in control_flow_edges:
        semantic_emitter.emit_analyzed_control_flow_edge(edge)
    for interval in dominator_tree_intervals:
        semantic_emitter.emit_analyzed_dominator_tree_interval(interval)
    for boundary in boundaries:
        semantic_emitter.emit_analysis_boundary(boundary)
    for resolution in call_resolutions:
        semantic_emitter.emit_analyzed_call_resolution(resolution)
    for require in literal_requires:
        semantic_emitter.emit_analyzed_literal_require(require)
    for resolution in module_resolutions:
        semantic_emitter.emit_analyzed_module_resolution(resolution)
    for export in module_exports:
        semantic_emitter.emit_analyzed_module_export(export)
    for flow in interprocedural_flows:
        semantic_emitter.emit_analyzed_interprocedural_flow(flow)
    for flow in table_field_flows:
        semantic_emitter.emit_analyzed_table_field_flow(flow)
    for flow in global_flows:
        semantic_emitter.emit_analyzed_global_flow(flow)
    for flow in upvalue_flows:
        semantic_emitter.emit_analyzed_upvalue_flow(flow)


def emit_bytecode_diagnostic(trap: TrapWriter, path: Path, source_archive_dir: Path, exc: BytecodeError) -> None:
    file_label, folder_label, loc_label, rel = file_fact_labels(trap, path)
    emit_file_fact_tuples(trap, file_label, folder_label, loc_label, path, rel)
    copy_source(path, source_archive_dir)
    fixture_id = rel
    diagnostic_kind = exc.diagnostic_kind
    message_category = exc.message_category
    artifact = trap.label(f"artifact;{fixture_id};{rel}")
    trap.tuple(
        "lua_artifacts",
        artifact,
        fixture_id,
        rel,
        "malformed-bytecode",
        "unavailable",
        0,
        "malformed/unsupported",
    )
    diag = trap.label(f"diagnostic;{fixture_id};{diagnostic_kind};{rel}")
    trap.tuple(
        "lua_diagnostics",
        diag,
        artifact,
        fixture_id,
        f"{fixture_id}:{diagnostic_kind}",
        diagnostic_kind,
        rel,
        "error",
        message_category,
        0,
        "malformed/unsupported",
    )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--file-list")
    parser.add_argument("--source-root")
    parser.add_argument("--source-archive-dir", required=True)
    parser.add_argument("--output-dir", required=True)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    trap = TrapWriter()
    source_archive_dir = Path(args.source_archive_dir)
    if args.file_list:
        paths = [
            Path(line)
            for line in Path(args.file_list).read_text(encoding="utf-8").splitlines()
            if line
        ]
    elif args.source_root:
        paths = sorted(
            path
            for path in Path(args.source_root).rglob("*")
            if path.is_file() and path.suffix in SOURCE_ROOT_SUFFIXES
        )
    else:
        raise SystemExit("Either --file-list or --source-root is required")

    accepted_bytecode: list[tuple[Path, LoadedArtifact]] = []
    for path in paths:
        if path.suffix == ".lua":
            emit_lua_source_file(trap, path, source_archive_dir)
        elif path.suffix == ".luac":
            try:
                loaded = Lua51Loader(path.read_bytes()).load()
            except BytecodeError as exc:
                emit_bytecode_diagnostic(trap, path, source_archive_dir, exc)
                continue
            accepted_bytecode.append((path, loaded))

    analysis = analyze_corpus(
        AcceptedCorpus(
            artifacts=tuple(
                CorpusArtifact(module_path=display_path(path), loaded_artifact=loaded)
                for path, loaded in accepted_bytecode
            )
        )
    )
    identity_by_module = {
        identity.module_path: identity for identity in analysis.artifact_identities
    }
    value_flows_by_module: dict[str, list[ValueFlowRelation]] = {}
    for flow in analysis.value_flows:
        value_flows_by_module.setdefault(flow.module_path, []).append(flow)
    control_flow_edges_by_module: dict[str, list[ControlFlowEdgeRelation]] = {}
    for edge in analysis.control_flow_edges:
        control_flow_edges_by_module.setdefault(edge.module_path, []).append(edge)
    dominator_tree_intervals_by_module: dict[
        str, list[DominatorTreeIntervalRelation]
    ] = {}
    for interval in analysis.dominator_tree_intervals:
        dominator_tree_intervals_by_module.setdefault(
            interval.module_path, []
        ).append(interval)
    boundaries_by_module: dict[str, list[AnalysisBoundary]] = {}
    for boundary in analysis.boundaries:
        boundaries_by_module.setdefault(boundary.module_path, []).append(boundary)
    call_resolutions_by_module: dict[str, list[CallResolutionRelation]] = {}
    for resolution in analysis.call_resolutions:
        call_resolutions_by_module.setdefault(
            resolution.caller_module_path, []
        ).append(resolution)
    literal_requires_by_module: dict[str, list[LiteralRequireRelation]] = {}
    for require in analysis.literal_requires:
        literal_requires_by_module.setdefault(
            require.caller_module_path, []
        ).append(require)
    module_resolutions_by_module: dict[str, list[ModuleResolutionRelation]] = {}
    for resolution in analysis.module_resolutions:
        module_resolutions_by_module.setdefault(
            resolution.caller_module_path, []
        ).append(resolution)
    module_exports_by_module: dict[str, list[ModuleExportRelation]] = {}
    for export in analysis.module_exports:
        module_exports_by_module.setdefault(export.module_path, []).append(export)
    interprocedural_flows_by_module: dict[str, list[InterproceduralFlowRelation]] = {}
    for flow in analysis.interprocedural_flows:
        interprocedural_flows_by_module.setdefault(
            flow.caller_module_path, []
        ).append(flow)
    table_field_flows_by_module: dict[str, list[TableFieldFlowRelation]] = {}
    for flow in analysis.table_field_flows:
        table_field_flows_by_module.setdefault(flow.module_path, []).append(flow)
    global_flows_by_module: dict[str, list[GlobalFlowRelation]] = {}
    for flow in analysis.global_flows:
        global_flows_by_module.setdefault(flow.module_path, []).append(flow)
    upvalue_flows_by_module: dict[str, list[UpvalueFlowRelation]] = {}
    for flow in analysis.upvalue_flows:
        upvalue_flows_by_module.setdefault(flow.module_path, []).append(flow)
    for path, loaded in accepted_bytecode:
        module_path = display_path(path)
        emit_loaded_bytecode(
            trap,
            path,
            source_archive_dir,
            loaded,
            identity_by_module[module_path],
            tuple(value_flows_by_module.get(module_path, ())),
            tuple(control_flow_edges_by_module.get(module_path, ())),
            tuple(dominator_tree_intervals_by_module.get(module_path, ())),
            tuple(boundaries_by_module.get(module_path, ())),
            tuple(call_resolutions_by_module.get(module_path, ())),
            tuple(literal_requires_by_module.get(module_path, ())),
            tuple(module_resolutions_by_module.get(module_path, ())),
            tuple(module_exports_by_module.get(module_path, ())),
            tuple(interprocedural_flows_by_module.get(module_path, ())),
            tuple(table_field_flows_by_module.get(module_path, ())),
            tuple(global_flows_by_module.get(module_path, ())),
            tuple(upvalue_flows_by_module.get(module_path, ())),
        )

    trap.write(Path(args.output_dir) / "lua-source-files.trap")


if __name__ == "__main__":
    main()
