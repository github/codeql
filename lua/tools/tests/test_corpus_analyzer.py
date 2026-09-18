from __future__ import annotations

import shutil
import sys
import tempfile
import unittest
from pathlib import Path


TOOLS_DIR = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(TOOLS_DIR))

from corpus_analyzer import AcceptedCorpus, CorpusArtifact, analyze_corpus
from lua_bytecode import (
    Chunk,
    Constant,
    Instruction,
    InstructionType,
    LoadedArtifact,
    Lua51Loader,
    Opcode,
)


class CorpusAnalyzerPublicApiTests(unittest.TestCase):
    def test_structural_identities_are_stable_across_outer_directories(self) -> None:
        fixture = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/bytecode-model/bc-prototype-params/input.luac"
        )

        with tempfile.TemporaryDirectory() as first, tempfile.TemporaryDirectory() as second:
            first_path = Path(first) / "firmware/pkg/input.luac"
            second_path = Path(second) / "other-root/pkg/input.luac"
            first_path.parent.mkdir(parents=True)
            second_path.parent.mkdir(parents=True)
            shutil.copyfile(fixture, first_path)
            shutil.copyfile(fixture, second_path)

            first_result = analyze_corpus(
                AcceptedCorpus(
                    artifacts=(
                        CorpusArtifact(
                            module_path="pkg/input.luac",
                            loaded_artifact=Lua51Loader(first_path.read_bytes()).load(),
                        ),
                    )
                )
            )
            second_result = analyze_corpus(
                AcceptedCorpus(
                    artifacts=(
                        CorpusArtifact(
                            module_path="pkg/input.luac",
                            loaded_artifact=Lua51Loader(second_path.read_bytes()).load(),
                        ),
                    )
                )
            )

        self.assertEqual(first_result, second_result)
        self.assertEqual(first_result.artifact_identities[0].module_path, "pkg/input.luac")
        self.assertIn(
            ("pkg/input.luac", "root", ""),
            {
                (item.module_path, item.prototype_id, item.parent_prototype_id)
                for item in first_result.prototype_identities
            },
        )
        self.assertTrue(first_result.instruction_identities)
        self.assertIn(
            ("pkg/input.luac", "root.0", "root.0:r0", "entry-register", -1, 0),
            {
                (
                    item.module_path,
                    item.prototype_id,
                    item.value_ref,
                    item.value_kind,
                    item.pc,
                    item.slot,
                )
                for item in first_result.value_identities
            },
        )

    def test_duplicate_normalized_module_path_is_rejected(self) -> None:
        fixture = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/bytecode-model/bc-prototype-params/input.luac"
        )
        loaded = Lua51Loader(fixture.read_bytes()).load()

        with self.assertRaisesRegex(ValueError, "duplicate normalized module path"):
            analyze_corpus(
                AcceptedCorpus(
                    artifacts=(
                        CorpusArtifact("pkg/input.luac", loaded),
                        CorpusArtifact("pkg/input.luac", loaded),
                    )
                )
            )

    def test_straight_line_parameter_definition_reaches_only_matching_move_read(self) -> None:
        fixture = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/bytecode-model/bc-prototype-params/input.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/input.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        flows = {
            (
                flow.module_path,
                flow.prototype_id,
                flow.source_ref,
                flow.sink_ref,
                flow.kind,
            )
            for flow in result.value_flows
        }

        self.assertIn(
            (
                "pkg/input.luac",
                "root.0",
                "root.0:r0",
                "root.0@pc0:r0",
                "reaching-definition",
            ),
            flows,
        )
        self.assertIn(
            (
                "pkg/input.luac",
                "root.0",
                "root.0@pc0:r0",
                "root.0@pc0:r2",
                "same-instruction-dependence",
            ),
            flows,
        )
        self.assertNotIn(
            (
                "pkg/input.luac",
                "root.0",
                "root.0:r1",
                "root.0@pc0:r0",
                "reaching-definition",
            ),
            flows,
        )

    def test_later_write_kills_old_definition_before_sink_read(self) -> None:
        fixture = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/intraprocedural-semantics/bc-kill-overwrite/input.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/input.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        adjacency: dict[str, set[str]] = {}
        for flow in result.value_flows:
            adjacency.setdefault(flow.source_ref, set()).add(flow.sink_ref)

        def reachable(source: str, sink: str) -> bool:
            pending = [source]
            seen: set[str] = set()
            while pending:
                current = pending.pop()
                if current == sink:
                    return True
                if current in seen:
                    continue
                seen.add(current)
                pending.extend(adjacency.get(current, set()) - seen)
            return False

        self.assertTrue(reachable("root@pc4:r2", "root@pc7:r4"))
        self.assertFalse(reachable("root@pc3:r2", "root@pc6:r2"))

    def test_conditional_predecessors_merge_definitions_at_join_read(self) -> None:
        fixture = Path(__file__).resolve().parent / "fixtures/branch_merge.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/branch_merge.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        adjacency: dict[str, set[str]] = {}
        for flow in result.value_flows:
            adjacency.setdefault(flow.source_ref, set()).add(flow.sink_ref)

        def reachable(source: str, sink: str) -> bool:
            pending = [source]
            seen: set[str] = set()
            while pending:
                current = pending.pop()
                if current == sink:
                    return True
                if current in seen:
                    continue
                seen.add(current)
                pending.extend(adjacency.get(current, set()) - seen)
            return False

        self.assertTrue(reachable("root.0@pc0:r3", "root.0@pc4:r3"))
        self.assertTrue(reachable("root.0@pc3:r3", "root.0@pc4:r3"))
        self.assertFalse(reachable("root.0@pc3:r3", "root.0@pc1:r0"))

    def test_return_terminates_control_flow(self) -> None:
        loaded = LoadedArtifact(
            chunk=Chunk(
                max_stack=2,
                instructions=[
                    Instruction(Opcode.MOVE, InstructionType.ABC, 0, 1, 0),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                    Instruction(Opcode.MOVE, InstructionType.ABC, 0, 1, 0),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("neutral/return-terminal.luac", loaded),)
            )
        )

        self.assertEqual(
            {(0, 1), (2, 3)},
            {
                (edge.source_pc, edge.target_pc)
                for edge in result.control_flow_edges
            },
        )

    def test_tailcall_terminates_control_flow_but_call_falls_through(self) -> None:
        loaded = LoadedArtifact(
            chunk=Chunk(
                max_stack=2,
                instructions=[
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 1, 1),
                    Instruction(Opcode.TAILCALL, InstructionType.ABC, 0, 1, 0),
                    Instruction(Opcode.MOVE, InstructionType.ABC, 0, 1, 0),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("neutral/tailcall-terminal.luac", loaded),)
            )
        )

        self.assertEqual(
            {(0, 1), (2, 3)},
            {
                (edge.source_pc, edge.target_pc)
                for edge in result.control_flow_edges
            },
        )

    def test_generic_loop_carries_iterator_and_body_definitions(self) -> None:
        fixture = Path(__file__).resolve().parent / "fixtures/generic_loop.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/generic_loop.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        adjacency: dict[str, set[str]] = {}
        for flow in result.value_flows:
            adjacency.setdefault(flow.source_ref, set()).add(flow.sink_ref)

        def reachable(source: str, sink: str) -> bool:
            pending = [source]
            seen: set[str] = set()
            while pending:
                current = pending.pop()
                if current == sink:
                    return True
                if current in seen:
                    continue
                seen.add(current)
                pending.extend(adjacency.get(current, set()) - seen)
            return False

        self.assertTrue(reachable("root.0@pc6:r8", "root.0@pc5:r8"))
        self.assertTrue(reachable("root.0:r1", "root.0@pc5:r8"))
        self.assertTrue(reachable("root.0@pc5:r3", "root.0@pc8:r3"))
        self.assertFalse(reachable("root.0@pc6:r7", "root.0@pc5:r8"))
        self.assertFalse(reachable("root.0:r0", "root.0@pc5:r8"))

    def test_numeric_loop_preserves_entry_and_backedge_definitions(self) -> None:
        fixture = Path(__file__).resolve().parent / "fixtures/numeric_loop.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/numeric_loop.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        adjacency: dict[str, set[str]] = {}
        for flow in result.value_flows:
            adjacency.setdefault(flow.source_ref, set()).add(flow.sink_ref)

        def reachable(source: str, sink: str) -> bool:
            pending = [source]
            seen: set[str] = set()
            while pending:
                current = pending.pop()
                if current == sink:
                    return True
                if current in seen:
                    continue
                seen.add(current)
                pending.extend(adjacency.get(current, set()) - seen)
            return False

        self.assertTrue(reachable("root.0@pc0:r2", "root.0@pc7:r2"))
        self.assertTrue(reachable("root.0@pc5:r2", "root.0@pc7:r2"))
        self.assertFalse(reachable("root.0:r0", "root.0@pc7:r2"))

    def test_open_call_uses_only_producer_proven_argument_slots(self) -> None:
        fixture = Path(__file__).resolve().parent / "fixtures/open_call.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/open_call.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        flows = {
            (flow.source_ref, flow.sink_ref, flow.kind)
            for flow in result.value_flows
        }

        self.assertIn(
            ("root.0@pc3:r4", "root.0@pc4:r4", "reaching-definition"),
            flows,
        )
        self.assertNotIn(
            ("root.0@pc2:r5", "root.0@pc4:r5", "reaching-definition"),
            flows,
        )
        boundaries = {
            (item.prototype_id, item.site_id, item.boundary_kind)
            for item in result.boundaries
        }
        self.assertIn(
            ("root.0", "root.0@pc3", "open-call-result-tail"),
            boundaries,
        )
        self.assertIn(
            ("root.0", "root.0@pc4", "open-call-argument-tail"),
            boundaries,
        )

    def test_open_call_preserves_fixed_prefix_before_proven_tail(self) -> None:
        fixture = Path(__file__).resolve().parent / "fixtures/mixed_fixed_open_call.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "neutral/mixed-fixed-open-call.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        flows = {
            (flow.source_ref, flow.sink_ref, flow.kind)
            for flow in result.value_flows
        }

        self.assertIn(
            ("root.3@pc3:r3", "root.3@pc7:r3", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.3@pc6:r4", "root.3@pc7:r4", "reaching-definition"),
            flows,
        )

    def test_open_vararg_return_models_only_the_proven_base_slot(self) -> None:
        fixture = Path(__file__).resolve().parent / "fixtures/open_vararg_return.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/open_vararg_return.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        flows = {
            (flow.source_ref, flow.sink_ref, flow.kind)
            for flow in result.value_flows
        }
        boundaries = {
            (item.prototype_id, item.site_id, item.boundary_kind)
            for item in result.boundaries
        }

        self.assertIn(
            ("root.0@pc0:r1", "root.0@pc1:r1", "reaching-definition"),
            flows,
        )
        self.assertNotIn(
            ("root.0@pc0:r2", "root.0@pc1:r2", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.0", "root.0@pc0", "open-vararg-tail"),
            boundaries,
        )
        self.assertIn(
            ("root.0", "root.0@pc1", "open-return-tail"),
            boundaries,
        )

    def test_scalar_and_range_writes_reach_only_their_live_reads(self) -> None:
        fixture = Path(__file__).resolve().parent / "fixtures/scalar_range.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/scalar_range.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        flows = {
            (flow.source_ref, flow.sink_ref, flow.kind)
            for flow in result.value_flows
        }

        self.assertIn(
            ("root.0@pc1:r2", "root.0@pc4:r2", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.0@pc1:r3", "root.0@pc5:r3", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.0@pc2:r1", "root.0@pc3:r1", "reaching-definition"),
            flows,
        )
        self.assertNotIn(
            ("root.0@pc0:r1", "root.0@pc3:r1", "reaching-definition"),
            flows,
        )

    def test_arithmetic_and_concat_use_only_register_operands(self) -> None:
        fixture = Path(__file__).resolve().parent / "fixtures/arithmetic_concat.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/arithmetic_concat.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        flows = {
            (flow.source_ref, flow.sink_ref, flow.kind)
            for flow in result.value_flows
        }

        self.assertIn(
            ("root.0@pc0:r0", "root.0@pc0:r3", "same-instruction-dependence"),
            flows,
        )
        self.assertIn(
            ("root.0@pc0:r1", "root.0@pc0:r3", "same-instruction-dependence"),
            flows,
        )
        self.assertIn(
            ("root.0@pc1:r3", "root.0@pc1:r4", "same-instruction-dependence"),
            flows,
        )
        self.assertFalse(
            any(sink == "root.0@pc1:r256" for _, sink, _ in flows)
        )
        self.assertIn(
            ("root.0@pc5:r6", "root.0@pc5:r0", "same-instruction-dependence"),
            flows,
        )
        self.assertIn(
            ("root.0@pc5:r0", "root.0@pc6:r0", "reaching-definition"),
            flows,
        )
        self.assertNotIn(
            ("root.0:r0", "root.0@pc6:r0", "reaching-definition"),
            flows,
        )

    def test_overlapping_concat_preserves_prior_definition_for_tailcall(self) -> None:
        fixture = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/bytecode-model/bc-constants-call/input.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/concat_tailcall.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        flows = {
            (flow.source_ref, flow.sink_ref, flow.kind)
            for flow in result.value_flows
        }

        self.assertIn(
            ("root@pc6:r4", "root@pc7:r4", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root@pc4:r4", "root@pc7:r4", "reaching-definition"),
            flows,
        )
        self.assertNotIn(
            ("root@pc5:r5", "root@pc7:r5", "reaching-definition"),
            flows,
        )

    def test_unary_effects_depend_only_on_their_input_slot(self) -> None:
        fixture = Path(__file__).resolve().parent / "fixtures/unary_effects.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/unary_effects.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        observed = {
            (flow.source_ref, flow.sink_ref)
            for flow in result.value_flows
            if flow.kind == "same-instruction-dependence"
            and flow.source_ref
            in {"root.0@pc0:r0", "root.0@pc1:r0", "root.0@pc2:r0"}
        }

        self.assertEqual(
            {
                ("root.0@pc0:r0", "root.0@pc0:r1"),
                ("root.0@pc1:r0", "root.0@pc1:r2"),
                ("root.0@pc2:r0", "root.0@pc2:r3"),
            },
            observed,
        )

    def test_conditional_effects_merge_only_legitimate_definitions(self) -> None:
        fixture = Path(__file__).resolve().parent / "fixtures/conditional_effects.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/conditional_effects.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        flows = {
            (flow.source_ref, flow.sink_ref, flow.kind)
            for flow in result.value_flows
        }

        self.assertIn(
            ("root.0@pc0:r0", "root.0@pc0:r3", "same-instruction-dependence"),
            flows,
        )
        self.assertIn(
            ("root.0@pc0:r3", "root.0@pc15:r3", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.0@pc2:r3", "root.0@pc15:r3", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.0:r0", "root.0@pc3:r0", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.0:r1", "root.0@pc11:r1", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.0@pc6:r4", "root.0@pc16:r4", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.0@pc10:r5", "root.0@pc17:r5", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.0@pc14:r6", "root.0@pc18:r6", "reaching-definition"),
            flows,
        )
        self.assertNotIn(
            ("root.0:r2", "root.0@pc3:r0", "reaching-definition"),
            flows,
        )

    def test_state_access_opcodes_have_precise_register_effects(self) -> None:
        fixture = Path(__file__).resolve().parent / "fixtures/state_access_effects.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/state_access_effects.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        flows = {
            (flow.source_ref, flow.sink_ref, flow.kind)
            for flow in result.value_flows
        }

        self.assertIn(
            ("root.0@pc0:r3", "root.0@pc3:r3", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.0@pc1:r4", "root.0@pc3:r4", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.0@pc2:r5", "root.0@pc3:r5", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.0:r1", "root.0@pc4:r1", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.0@pc5:r3", "root.0@pc5:r4", "same-instruction-dependence"),
            flows,
        )
        self.assertNotIn(
            ("root.0@pc5:r1", "root.0@pc5:r4", "same-instruction-dependence"),
            flows,
        )
        self.assertIn(
            ("root.0@pc5:r4", "root.0@pc6:r4", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.0@pc7:r4", "root.0@pc8:r4", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.0@pc9:r4", "root.0@pc13:r4", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.0@pc10:r0", "root.0@pc10:r5", "same-instruction-dependence"),
            flows,
        )
        self.assertIn(
            ("root.0@pc10:r0", "root.0@pc10:r6", "same-instruction-dependence"),
            flows,
        )
        self.assertFalse(
            any(sink == "root.0@pc10:r257" for _, sink, _ in flows)
        )
        self.assertIn(
            ("root.0@pc10:r6", "root.0@pc12:r6", "reaching-definition"),
            flows,
        )
        self.assertIn(
            ("root.0@pc11:r7", "root.0@pc12:r7", "reaching-definition"),
            flows,
        )

    def test_fixed_vararg_writes_exactly_the_declared_result_slots(self) -> None:
        fixture = Path(__file__).resolve().parent / "fixtures/fixed_vararg.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/fixed_vararg.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        flows = {
            (flow.source_ref, flow.sink_ref, flow.kind)
            for flow in result.value_flows
        }

        for slot in (1, 2, 3):
            self.assertIn(
                (
                    f"root.0@pc0:r{slot}",
                    f"root.0@pc{slot}:r{slot}",
                    "reaching-definition",
                ),
                flows,
            )
        self.assertFalse(
            any(source == "root.0@pc0:r4" for source, _, _ in flows)
        )

    def test_close_preserves_ordinary_register_definitions(self) -> None:
        fixture = Path(__file__).resolve().parent / "fixtures/close_effect.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/close_effect.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        flows = {
            (flow.source_ref, flow.sink_ref, flow.kind)
            for flow in result.value_flows
        }

        self.assertIn(
            ("root.0@pc6:r1", "root.0@pc8:r1", "reaching-definition"),
            flows,
        )
        self.assertFalse(
            any(
                source.startswith("root.0@pc7:")
                or sink.startswith("root.0@pc7:")
                for source, sink, _ in flows
            )
        )

    def test_precise_table_field_flow_rejects_dynamic_and_missing_keys(self) -> None:
        fixture_root = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/intraprocedural-semantics"
        )
        positive_path = fixture_root / "bc-table-global-upvalue/input.luac"
        negative_path = fixture_root / "table-dynamic-key-negative/input.luac"

        positive = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "positive/input.luac",
                        Lua51Loader(positive_path.read_bytes()).load(),
                    ),
                )
            )
        )
        negative = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "negative/input.luac",
                        Lua51Loader(negative_path.read_bytes()).load(),
                    ),
                )
            )
        )
        self.assertEqual(
            {
                (
                    "positive/input.luac",
                    "root.0",
                    "root.0@pc0:r1",
                    "key",
                    "root.0@pc1:r0",
                    "root.0@pc3:r3",
                    "bytecode-only,precise-table-field",
                )
            },
            {
                (
                    flow.module_path,
                    flow.prototype_id,
                    flow.table_ref,
                    flow.field_name,
                    flow.write_ref,
                    flow.read_ref,
                    flow.provenance,
                )
                for flow in positive.table_field_flows
            },
        )
        self.assertEqual((), negative.table_field_flows)

    def test_table_alias_preserves_identity_and_replacement_drops_old_fields(self) -> None:
        fixture = Path(__file__).resolve().parent / "fixtures/table_alias_replacement.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/table_alias_replacement.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        flows = {
            (flow.table_ref, flow.field_name, flow.write_ref, flow.read_ref)
            for flow in result.table_field_flows
        }

        self.assertIn(
            ("root.0@pc0:r2", "value", "root.0@pc1:r0", "root.0@pc3:r4"),
            flows,
        )
        self.assertIn(
            ("root.0@pc4:r5", "value", "root.0@pc6:r1", "root.0@pc7:r5"),
            flows,
        )
        self.assertNotIn(
            ("root.0@pc0:r2", "value", "root.0@pc1:r0", "root.0@pc7:r5"),
            flows,
        )

    def test_static_table_field_definitions_join_across_control_flow(self) -> None:
        fixture_root = (
            Path(__file__).resolve().parents[2]
            / "ql/test/experimental/query-tests/rules-sanitizer-report"
            / "table-field-sanitizer-overwrite"
        )
        expected_writes_by_fixture = {
            "same-field.luac": {
                ("root@pc11:r1", "root@pc18:r2"),
                ("root@pc16:r1", "root@pc18:r2"),
            },
            "optional-branch.luac": {
                ("root@pc3:r1", "root@pc13:r2"),
                ("root@pc11:r1", "root@pc13:r2"),
            },
            "unrelated-field.luac": {
                ("root@pc3:r1", "root@pc18:r2"),
            },
            "dynamic-key.luac": {
                ("root@pc3:r1", "root@pc15:r2"),
            },
        }

        for fixture_name, expected_writes in expected_writes_by_fixture.items():
            with self.subTest(fixture=fixture_name):
                result = analyze_corpus(
                    AcceptedCorpus(
                        artifacts=(
                            CorpusArtifact(
                                fixture_name,
                                Lua51Loader(
                                    (fixture_root / fixture_name).read_bytes()
                                ).load(),
                            ),
                        )
                    )
                )
                final_read_pc = max(
                    int(flow.read_ref.split("@pc", 1)[1].split(":", 1)[0])
                    for flow in result.table_field_flows
                    if flow.field_name == "command"
                )
                self.assertEqual(
                    expected_writes,
                    {
                        (flow.write_ref, flow.read_ref)
                        for flow in result.table_field_flows
                        if flow.field_name == "command"
                        and f"@pc{final_read_pc}:" in flow.read_ref
                    },
                )

    def test_table_object_values_reach_only_reads_of_the_current_object(self) -> None:
        fixtures = Path(__file__).resolve().parent / "fixtures"
        state_result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/state_access_effects.luac",
                        Lua51Loader((fixtures / "state_access_effects.luac").read_bytes()).load(),
                    ),
                )
            )
        )
        replacement_result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/table_alias_replacement.luac",
                        Lua51Loader((fixtures / "table_alias_replacement.luac").read_bytes()).load(),
                    ),
                )
            )
        )
        state_flows = {
            (flow.source_ref, flow.sink_ref)
            for flow in state_result.value_flows
            if flow.kind == "table-object-dependence"
        }
        replacement_flows = {
            (flow.source_ref, flow.sink_ref)
            for flow in replacement_result.value_flows
            if flow.kind == "table-object-dependence"
        }

        self.assertIn(("root.0@pc3:r4", "root.0@pc5:r3"), state_flows)
        self.assertIn(("root.0@pc3:r5", "root.0@pc5:r3"), state_flows)
        self.assertIn(("root.0@pc4:r2", "root.0@pc5:r3"), state_flows)
        self.assertNotIn(("root.0@pc3:r3", "root.0@pc5:r3"), state_flows)
        self.assertIn(
            ("root.0@pc1:r0", "root.0@pc2:r2"),
            replacement_flows,
        )
        self.assertIn(
            ("root.0@pc1:r0", "root.0@pc3:r3"),
            replacement_flows,
        )
        self.assertIn(
            ("root.0@pc6:r1", "root.0@pc7:r2"),
            replacement_flows,
        )
        self.assertNotIn(
            ("root.0@pc1:r0", "root.0@pc7:r2"),
            replacement_flows,
        )

    def test_call_result_table_carries_written_value_to_later_read(self) -> None:
        fixture = Path(__file__).resolve().parent / "fixtures/call_result_table.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/call_result_table.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )
        object_flows = {
            (flow.source_ref, flow.sink_ref)
            for flow in result.value_flows
            if flow.kind == "table-object-dependence"
        }

        self.assertIn(("root.1@pc2:r0", "root.1@pc3:r2"), object_flows)
        self.assertEqual((), result.table_field_flows)

    def test_precise_global_writes_reach_only_matching_later_reads(self) -> None:
        fixtures = Path(__file__).resolve().parent / "fixtures"
        positive = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/state_access_effects.luac",
                        Lua51Loader((fixtures / "state_access_effects.luac").read_bytes()).load(),
                    ),
                )
            )
        )
        negative_path = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/intraprocedural-semantics"
            / "global-dynamic-environment-negative/input.luac"
        )
        negative = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/dynamic-env.luac",
                        Lua51Loader(negative_path.read_bytes()).load(),
                    ),
                )
            )
        )
        replacement = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/global-replacement.luac",
                        LoadedArtifact(
                            chunk=Chunk(
                                max_stack=3,
                                instructions=[
                                    Instruction(Opcode.SETGLOBAL, InstructionType.ABx, 0, 0),
                                    Instruction(Opcode.SETGLOBAL, InstructionType.ABx, 1, 0),
                                    Instruction(Opcode.GETGLOBAL, InstructionType.ABx, 2, 0),
                                ],
                                constants=[Constant("string", "global_value")],
                            ),
                            profile={},
                            profile_id="test-profile",
                            accepted=True,
                        ),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "pkg/state_access_effects.luac",
                    "root.0",
                    "global_value",
                    "root.0@pc6:r4",
                    "root.0@pc7:r4",
                    "root.0@pc6:r4",
                    "bytecode-only,precise-global-state",
                )
            },
            {
                (
                    flow.module_path,
                    flow.prototype_id,
                    flow.global_name,
                    flow.write_ref,
                    flow.read_ref,
                    flow.value_ref,
                    flow.provenance,
                )
                for flow in positive.global_flows
            },
        )
        self.assertEqual((), negative.global_flows)
        self.assertEqual(
            {("root@pc1:r1", "root@pc2:r2")},
            {(flow.write_ref, flow.read_ref) for flow in replacement.global_flows},
        )

    def test_upvalue_rows_preserve_capture_read_and_first_write_evidence(self) -> None:
        fixture_root = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/intraprocedural-semantics"
        )
        positive = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "positive/input.luac",
                        Lua51Loader(
                            (fixture_root / "bc-table-global-upvalue/input.luac").read_bytes()
                        ).load(),
                    ),
                )
            )
        )
        mutation = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "mutation/input.luac",
                        Lua51Loader(
                            (fixture_root / "upvalue-mutation-negative/input.luac").read_bytes()
                        ).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "positive/input.luac",
                    "root.0",
                    "root.0:u0",
                    "root@pc2:r0",
                    "root.0@pc4:r4",
                    "",
                    "bytecode-only,derived-upvalue-flow",
                )
            },
            {
                (
                    flow.module_path,
                    flow.prototype_id,
                    flow.upvalue_id,
                    flow.capture_ref,
                    flow.read_ref,
                    flow.write_ref,
                    flow.provenance,
                )
                for flow in positive.upvalue_flows
            },
        )
        self.assertEqual(
            {
                (
                    "root.0:u0",
                    "root@pc2:r0",
                    "root.0@pc0:r0",
                    "root.0@pc2:r1",
                ),
                (
                    "root.0:u0",
                    "root@pc2:r0",
                    "root.0@pc3:r1",
                    "root.0@pc2:r1",
                ),
            },
            {
                (
                    flow.upvalue_id,
                    flow.capture_ref,
                    flow.read_ref,
                    flow.write_ref,
                )
                for flow in mutation.upvalue_flows
            },
        )
        self.assertFalse(
            any(
                flow.capture_ref == "root.0@pc0:r0"
                and flow.read_ref == "root.0@pc3:r1"
                for flow in mutation.upvalue_flows
            )
        )

    def test_malformed_upvalue_bindings_emit_boundaries_without_guessing(self) -> None:
        def loaded_with_binding(binding: Instruction | None) -> LoadedArtifact:
            child = Chunk(
                num_upvalues=1,
                max_stack=1,
                instructions=[
                    Instruction(Opcode.GETUPVAL, InstructionType.ABC, 0, 0, 0),
                ],
            )
            instructions = [
                Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
            ]
            if binding is not None:
                instructions.append(binding)
            return LoadedArtifact(
                chunk=Chunk(
                    max_stack=1,
                    instructions=instructions,
                    constants=[Constant("string", "unused")],
                    protos=[child],
                ),
                profile={},
                profile_id="test-profile",
                accepted=True,
            )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "invalid/input.luac",
                        loaded_with_binding(
                            Instruction(Opcode.LOADK, InstructionType.ABx, 0, 0)
                        ),
                    ),
                    CorpusArtifact(
                        "missing/input.luac",
                        loaded_with_binding(None),
                    ),
                )
            )
        )

        self.assertEqual((), result.upvalue_flows)
        self.assertEqual(
            {
                (
                    "invalid/input.luac",
                    "root",
                    "root@pc0:u0",
                    "malformed-upvalue-capture",
                    "upvalue 0 binding at root@pc1 must use MOVE or GETUPVAL",
                    "bytecode-only,upvalue-capture-boundary",
                ),
                (
                    "missing/input.luac",
                    "root",
                    "root@pc0:u0",
                    "malformed-upvalue-capture",
                    "upvalue 0 binding after root@pc0 is missing",
                    "bytecode-only,upvalue-capture-boundary",
                ),
            },
            {
                (
                    boundary.module_path,
                    boundary.prototype_id,
                    boundary.site_id,
                    boundary.boundary_kind,
                    boundary.reason,
                    boundary.provenance,
                )
                for boundary in result.boundaries
                if boundary.boundary_kind == "malformed-upvalue-capture"
            },
        )

    def test_named_upvalue_member_call_has_public_resolved_name(self) -> None:
        fixture = Path(__file__).resolve().parent / "fixtures/upvalue_member_call.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "neutral/upvalue-member.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertIn(
            ("root.1", "root.1@pc2", "provider.source"),
            {
                (
                    resolution.caller_prototype_id,
                    resolution.callsite_id,
                    resolution.resolved_name,
                )
                for resolution in result.call_resolutions
            },
        )

    def test_stripped_captured_table_member_resolves_target_without_name(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/upvalue_member_call_stripped.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "neutral/upvalue-member-stripped.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "root.1",
                    "root.1@pc2",
                    "",
                    "closure-table-field",
                    "root.0",
                )
            },
            {
                (
                    resolution.caller_prototype_id,
                    resolution.callsite_id,
                    resolution.resolved_name,
                    resolution.resolution_kind,
                    resolution.target_prototype_id,
                )
                for resolution in result.call_resolutions
                if resolution.caller_prototype_id == "root.1"
            },
        )
        self.assertFalse(
            any(
                boundary.prototype_id == "root.1"
                and boundary.site_id == "root.1@pc2"
                and boundary.boundary_kind == "unresolved-call-target"
                for boundary in result.boundaries
            )
        )

    def test_stripped_upvalue_member_call_recovers_literal_require_capture(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/stripped_literal_require_upvalue_member.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "neutral/stripped-literal-require-upvalue.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertIn(
            ("root.0", "neutral.api.source"),
            {
                (resolution.caller_prototype_id, resolution.resolved_name)
                for resolution in result.call_resolutions
            },
        )
        self.assertFalse(
            any(
                boundary.prototype_id == "root.0" and
                boundary.boundary_kind == "unresolved-call-target"
                for boundary in result.boundaries
            )
        )

    def test_sibling_closure_binding_does_not_clobber_capture_name(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/stripped_literal_require_sibling_capture.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "neutral/stripped-literal-require-siblings.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertIn(
            ("root.1", "neutral.api.source"),
            {
                (resolution.caller_prototype_id, resolution.resolved_name)
                for resolution in result.call_resolutions
            },
        )

    def test_literal_require_result_member_call_has_qualified_name(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/stripped_literal_require_member_call.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "neutral/stripped-literal-require-member.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertIn(
            (
                "neutral.api.source",
                "derived-reaching-definition-call-target",
                "",
            ),
            {
                (
                    resolution.resolved_name,
                    resolution.resolution_kind,
                    resolution.target_prototype_id,
                )
                for resolution in result.call_resolutions
            },
        )

    def test_nested_getupval_binding_preserves_captured_call_name(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/stripped_nested_getupval_capture.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "neutral/stripped-nested-getupval-capture.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertIn(
            (
                "root.0.0",
                "neutral.api.source",
                "derived-reaching-definition-call-target",
                "",
            ),
            {
                (
                    resolution.caller_prototype_id,
                    resolution.resolved_name,
                    resolution.resolution_kind,
                    resolution.target_prototype_id,
                )
                for resolution in result.call_resolutions
            },
        )
        self.assertNotIn(
            ("root.0.0", "root.0.0"),
            {
                (
                    resolution.caller_prototype_id,
                    resolution.target_prototype_id,
                )
                for resolution in result.call_resolutions
            },
        )

    def test_direct_closure_call_resolves_only_the_reaching_target(self) -> None:
        child = Chunk(max_stack=1, instructions=[])
        positive = LoadedArtifact(
            chunk=Chunk(
                max_stack=4,
                protos=[child, child],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 2, 0),
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 3, 1),
                    Instruction(Opcode.CALL, InstructionType.ABC, 2, 1, 1),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )
        parameter_derived = LoadedArtifact(
            chunk=Chunk(
                num_params=1,
                max_stack=1,
                instructions=[
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 1, 1),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact("positive/direct.luac", positive),
                    CorpusArtifact("negative/parameter.luac", parameter_derived),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "positive/direct.luac",
                    "root",
                    "root@pc2",
                    "root@pc2:r2",
                    "",
                    "direct-closure",
                    "positive/direct.luac",
                    "root.0",
                    "bytecode-only,direct-closure-target",
                )
            },
            {
                (
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
                for resolution in result.call_resolutions
            },
        )

    def test_closure_call_target_propagates_through_move_only(self) -> None:
        fixture = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/intraprocedural-semantics"
            / "bc-call-candidate-unresolved/input.luac"
        )
        non_move_transform = LoadedArtifact(
            chunk=Chunk(
                max_stack=2,
                protos=[Chunk(max_stack=1, instructions=[])],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.CONCAT, InstructionType.ABC, 1, 0, 0),
                    Instruction(Opcode.CALL, InstructionType.ABC, 1, 1, 1),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/closure-move.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                    CorpusArtifact("negative/non-move.luac", non_move_transform),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "pkg/closure-move.luac",
                    "root",
                    "root@pc5",
                    "root@pc5:r2",
                    "invoke",
                    "closure-move",
                    "pkg/closure-move.luac",
                    "root.1",
                    "bytecode-only,closure-move-target",
                )
            },
            {
                (
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
                for resolution in result.call_resolutions
            },
        )

    def test_parameter_derived_call_emits_boundary_without_resolution(self) -> None:
        fixture = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/intraprocedural-semantics"
            / "bc-call-candidate-unresolved/input.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "bc-call-candidate-unresolved/input.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {("root@pc5", "root.1")},
            {
                (resolution.callsite_id, resolution.target_prototype_id)
                for resolution in result.call_resolutions
            },
        )
        self.assertEqual(
            {
                (
                    "bc-call-candidate-unresolved/input.luac",
                    "root.1",
                    "root.1@pc2",
                    "unresolved-call-target",
                    "param-derived",
                    "bytecode-only,call-resolution-boundary",
                )
            },
            {
                (
                    boundary.module_path,
                    boundary.prototype_id,
                    boundary.site_id,
                    boundary.boundary_kind,
                    boundary.reason,
                    boundary.provenance,
                )
                for boundary in result.boundaries
                if boundary.boundary_kind == "unresolved-call-target"
            },
        )

    def test_multiple_closure_targets_emit_boundary_without_selection(self) -> None:
        loaded = LoadedArtifact(
            chunk=Chunk(
                max_stack=2,
                protos=[
                    Chunk(max_stack=1, instructions=[]),
                    Chunk(max_stack=1, instructions=[]),
                ],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.LOADBOOL, InstructionType.ABC, 1, 0, 0),
                    Instruction(Opcode.TEST, InstructionType.ABC, 1, 0, 0),
                    Instruction(Opcode.JMP, InstructionType.AsBx, 0, 1),
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 1),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 1, 1),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("ambiguous/call.luac", loaded),)
            )
        )

        self.assertEqual(
            {"root@pc0:r0", "root@pc4:r0"},
            {
                flow.source_ref
                for flow in result.value_flows
                if flow.sink_ref == "root@pc5:r0"
                and flow.kind == "reaching-definition"
            },
        )
        self.assertEqual((), result.call_resolutions)
        self.assertEqual(
            {
                (
                    "ambiguous/call.luac",
                    "root",
                    "root@pc5",
                    "unresolved-call-target",
                    "multiple-candidates",
                    "bytecode-only,call-resolution-boundary",
                )
            },
            {
                (
                    boundary.module_path,
                    boundary.prototype_id,
                    boundary.site_id,
                    boundary.boundary_kind,
                    boundary.reason,
                    boundary.provenance,
                )
                for boundary in result.boundaries
                if boundary.boundary_kind == "unresolved-call-target"
            },
        )

    def test_multiple_symbolic_names_emit_boundary_without_selection(self) -> None:
        loaded = LoadedArtifact(
            chunk=Chunk(
                max_stack=2,
                constants=[
                    Constant("string", "os"),
                    Constant("string", "execute"),
                    Constant("string", "io"),
                    Constant("string", "popen"),
                ],
                instructions=[
                    Instruction(Opcode.GETGLOBAL, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.GETTABLE, InstructionType.ABC, 0, 0, 257),
                    Instruction(Opcode.LOADBOOL, InstructionType.ABC, 1, 0, 0),
                    Instruction(Opcode.TEST, InstructionType.ABC, 1, 0, 0),
                    Instruction(Opcode.JMP, InstructionType.AsBx, 0, 2),
                    Instruction(Opcode.GETGLOBAL, InstructionType.ABx, 0, 2),
                    Instruction(Opcode.GETTABLE, InstructionType.ABC, 0, 0, 259),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 1, 1),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("ambiguous/names.luac", loaded),)
            )
        )

        self.assertEqual(
            {"root@pc1:r0", "root@pc6:r0"},
            {
                flow.source_ref
                for flow in result.value_flows
                if flow.sink_ref == "root@pc7:r0"
                and flow.kind == "reaching-definition"
            },
        )
        self.assertEqual((), result.call_resolutions)
        self.assertEqual(
            {
                (
                    "ambiguous/names.luac",
                    "root",
                    "root@pc7",
                    "unresolved-call-target",
                    "multiple-candidates",
                    "bytecode-only,call-resolution-boundary",
                )
            },
            {
                (
                    boundary.module_path,
                    boundary.prototype_id,
                    boundary.site_id,
                    boundary.boundary_kind,
                    boundary.reason,
                    boundary.provenance,
                )
                for boundary in result.boundaries
                if boundary.boundary_kind == "unresolved-call-target"
            },
        )

    def test_dynamic_call_emits_no_proven_target_boundary(self) -> None:
        loaded = LoadedArtifact(
            chunk=Chunk(
                max_stack=2,
                constants=[Constant("string", "handler")],
                instructions=[
                    Instruction(Opcode.NEWTABLE, InstructionType.ABC, 0, 0, 0),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 1, 0),
                    Instruction(Opcode.GETTABLE, InstructionType.ABC, 0, 0, 1),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 1, 1),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("dynamic/call.luac", loaded),)
            )
        )

        self.assertIn(
            ("root@pc2:r0", "root@pc3:r0", "reaching-definition"),
            {
                (flow.source_ref, flow.sink_ref, flow.kind)
                for flow in result.value_flows
            },
        )
        self.assertEqual((), result.call_resolutions)
        self.assertEqual(
            {
                (
                    "dynamic/call.luac",
                    "root",
                    "root@pc3",
                    "unresolved-call-target",
                    "no-proven-target",
                    "bytecode-only,call-resolution-boundary",
                )
            },
            {
                (
                    boundary.module_path,
                    boundary.prototype_id,
                    boundary.site_id,
                    boundary.boundary_kind,
                    boundary.reason,
                    boundary.provenance,
                )
                for boundary in result.boundaries
                if boundary.boundary_kind == "unresolved-call-target"
            },
        )

    def test_same_callsite_text_remains_scoped_to_each_module(self) -> None:
        resolved = LoadedArtifact(
            chunk=Chunk(
                max_stack=1,
                constants=[Constant("string", "handler")],
                instructions=[
                    Instruction(Opcode.GETGLOBAL, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 1, 1),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )
        unresolved = LoadedArtifact(
            chunk=Chunk(
                max_stack=1,
                instructions=[
                    Instruction(Opcode.NEWTABLE, InstructionType.ABC, 0, 0, 0),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 1, 1),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact("a/resolved.luac", resolved),
                    CorpusArtifact("b/unresolved.luac", unresolved),
                )
            )
        )

        self.assertEqual(
            {("a/resolved.luac", "root", "root@pc1", "handler")},
            {
                (
                    resolution.caller_module_path,
                    resolution.caller_prototype_id,
                    resolution.callsite_id,
                    resolution.resolved_name,
                )
                for resolution in result.call_resolutions
            },
        )
        self.assertEqual(
            {("b/unresolved.luac", "root", "root@pc1", "no-proven-target")},
            {
                (
                    boundary.module_path,
                    boundary.prototype_id,
                    boundary.site_id,
                    boundary.reason,
                )
                for boundary in result.boundaries
                if boundary.boundary_kind == "unresolved-call-target"
            },
        )

    def test_exact_global_call_name_reaches_across_argument_setup(self) -> None:
        fixture = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/interprocedural-module-taint"
            / "cross-module-webcmd-popen/controller.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "pkg/controller.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertIn(
            (
                "pkg/controller.luac",
                "root",
                "root@pc10",
                "require",
                "derived-reaching-definition-call-target",
                "bytecode-only,derived-call-target,reaching-definition",
            ),
            {
                (
                    resolution.caller_module_path,
                    resolution.caller_prototype_id,
                    resolution.callsite_id,
                    resolution.resolved_name,
                    resolution.resolution_kind,
                    resolution.provenance,
                )
                for resolution in result.call_resolutions
            },
        )

    def test_literal_require_requires_reaching_string_argument(self) -> None:
        fixture_root = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/interprocedural-module-taint"
        )
        literal_path = "cross-module-webcmd-popen/controller.luac"
        dynamic_path = (
            "ambiguous-unresolved-dynamic-module-negative/controller.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=tuple(
                    CorpusArtifact(
                        module_path,
                        Lua51Loader((fixture_root / module_path).read_bytes()).load(),
                    )
                    for module_path in (literal_path, dynamic_path)
                )
            )
        )

        self.assertEqual(
            {
                (
                    literal_path,
                    "root",
                    "root@pc10",
                    "mtkwifi",
                    "root@pc10:r1",
                    "bytecode-only,derived-literal-require",
                )
            },
            {
                (
                    require.caller_module_path,
                    require.caller_prototype_id,
                    require.callsite_id,
                    require.require_string,
                    require.argument_ref,
                    require.provenance,
                )
                for require in result.literal_requires
            },
        )
        self.assertEqual(
            {
                (
                    dynamic_path,
                    "root.0",
                    "root.0@pc2",
                    "unresolved-literal-require",
                    "dynamic-argument",
                    "bytecode-only,literal-require-boundary",
                )
            },
            {
                (
                    boundary.module_path,
                    boundary.prototype_id,
                    boundary.site_id,
                    boundary.boundary_kind,
                    boundary.reason,
                    boundary.provenance,
                )
                for boundary in result.boundaries
                if boundary.boundary_kind == "unresolved-literal-require"
            },
        )

    def test_conflicting_literal_require_does_not_select_branch(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/conflicting_literal_require.luac"
        )
        module_path = "neutral/conflicting_literal_require.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        module_path,
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {"root@pc3:r0", "root@pc5:r0"},
            {
                flow.source_ref
                for flow in result.value_flows
                if flow.sink_ref == "root@pc7:r0"
                and flow.kind == "reaching-definition"
            },
        )
        self.assertIn(
            (module_path, "root@pc8", "require"),
            {
                (
                    resolution.caller_module_path,
                    resolution.callsite_id,
                    resolution.resolved_name,
                )
                for resolution in result.call_resolutions
            },
        )
        self.assertEqual((), result.literal_requires)
        self.assertEqual(
            {
                (
                    module_path,
                    "root",
                    "root@pc8",
                    "unresolved-literal-require",
                    "dynamic-argument",
                    "bytecode-only,literal-require-boundary",
                )
            },
            {
                (
                    boundary.module_path,
                    boundary.prototype_id,
                    boundary.site_id,
                    boundary.boundary_kind,
                    boundary.reason,
                    boundary.provenance,
                )
                for boundary in result.boundaries
                if boundary.boundary_kind == "unresolved-literal-require"
            },
        )

    def test_literal_require_resolves_one_matching_module_path(self) -> None:
        fixture_root = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/interprocedural-module-taint"
        )
        caller_path = "cross-module-webcmd-popen/controller.luac"
        target_path = "cross-module-webcmd-popen/mtkwifi.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=tuple(
                    CorpusArtifact(
                        module_path,
                        Lua51Loader((fixture_root / module_path).read_bytes()).load(),
                    )
                    for module_path in (caller_path, target_path)
                )
            )
        )

        self.assertEqual(
            {
                (
                    caller_path,
                    "root@pc10",
                    "mtkwifi",
                    "matched",
                    target_path,
                    "",
                    "bytecode-only,literal-require,module-path",
                )
            },
            {
                (
                    resolution.caller_module_path,
                    resolution.callsite_id,
                    resolution.require_string,
                    resolution.status,
                    resolution.target_module_path,
                    resolution.reason,
                    resolution.provenance,
                )
                for resolution in result.module_resolutions
            },
        )

    def test_nonunique_module_paths_remain_explicitly_unresolved(self) -> None:
        fixture_root = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/interprocedural-module-taint"
        )
        caller_fixture = (
            fixture_root
            / "cross-module-webcmd-popen/controller.luac"
        )
        target_fixture = (
            fixture_root
            / "cross-module-webcmd-popen/mtkwifi.luac"
        )
        missing_fixture = (
            fixture_root
            / "ambiguous-unresolved-dynamic-module-negative/missing.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "caller/controller.luac",
                        Lua51Loader(caller_fixture.read_bytes()).load(),
                    ),
                    CorpusArtifact(
                        "left/mtkwifi.luac",
                        Lua51Loader(target_fixture.read_bytes()).load(),
                    ),
                    CorpusArtifact(
                        "right/mtkwifi.luac",
                        Lua51Loader(target_fixture.read_bytes()).load(),
                    ),
                    CorpusArtifact(
                        "missing/requester.luac",
                        Lua51Loader(missing_fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "caller/controller.luac",
                    "root@pc10",
                    "mtkwifi",
                    "ambiguous",
                    "",
                    "ambiguous-module-path-candidates",
                ),
                (
                    "missing/requester.luac",
                    "root.0@pc2",
                    "missing.module",
                    "unresolved",
                    "",
                    "no-module-path-candidate",
                ),
            },
            {
                (
                    resolution.caller_module_path,
                    resolution.callsite_id,
                    resolution.require_string,
                    resolution.status,
                    resolution.target_module_path,
                    resolution.reason,
                )
                for resolution in result.module_resolutions
            },
        )
        self.assertEqual(
            {
                (
                    "caller/controller.luac",
                    "root",
                    "root@pc10",
                    "ambiguous-module-path-candidates",
                ),
                (
                    "missing/requester.luac",
                    "root.0",
                    "root.0@pc2",
                    "no-module-path-candidate",
                ),
            },
            {
                (
                    boundary.module_path,
                    boundary.prototype_id,
                    boundary.site_id,
                    boundary.reason,
                )
                for boundary in result.boundaries
                if boundary.boundary_kind == "unresolved-module-require"
                and boundary.provenance
                == "bytecode-only,module-resolution-boundary"
            },
        )

    def test_module_resolution_uses_suffix_names_across_path_renames(self) -> None:
        fixture_root = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/interprocedural-module-taint"
            / "cross-module-webcmd-popen"
        )
        caller = Lua51Loader((fixture_root / "controller.luac").read_bytes()).load()
        target = Lua51Loader((fixture_root / "mtkwifi.luac").read_bytes()).load()

        def resolved_target(caller_path: str, target_path: str) -> str:
            result = analyze_corpus(
                AcceptedCorpus(
                    artifacts=(
                        CorpusArtifact(caller_path, caller),
                        CorpusArtifact(target_path, target),
                    )
                )
            )
            self.assertEqual("matched", result.module_resolutions[0].status)
            return result.module_resolutions[0].target_module_path

        self.assertEqual(
            "tree/mtkwifi.lua",
            resolved_target("tree/controller.lua", "tree/mtkwifi.lua"),
        )
        self.assertEqual(
            "renamed/deep/mtkwifi.luac",
            resolved_target(
                "renamed/deep/controller.luac",
                "renamed/deep/mtkwifi.luac",
            ),
        )

    def test_module_resolution_excludes_self_and_package_init_guess(self) -> None:
        fixture_root = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/interprocedural-module-taint"
        )
        controller = Lua51Loader(
            (
                fixture_root
                / "cross-module-webcmd-popen/controller.luac"
            ).read_bytes()
        ).load()
        missing = Lua51Loader(
            (
                fixture_root
                / "ambiguous-unresolved-dynamic-module-negative/missing.luac"
            ).read_bytes()
        ).load()
        target = Lua51Loader(
            (
                fixture_root
                / "cross-module-webcmd-popen/mtkwifi.luac"
            ).read_bytes()
        ).load()

        self_result = analyze_corpus(
            AcceptedCorpus(artifacts=(CorpusArtifact("mtkwifi.luac", controller),))
        )
        init_result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact("caller/requester.luac", missing),
                    CorpusArtifact("missing/module/init.lua", target),
                )
            )
        )

        self.assertEqual(
            ("unresolved", "", "no-module-path-candidate"),
            (
                self_result.module_resolutions[0].status,
                self_result.module_resolutions[0].target_module_path,
                self_result.module_resolutions[0].reason,
            ),
        )
        self.assertEqual(
            ("missing.module", "unresolved", "", "no-module-path-candidate"),
            (
                init_result.module_resolutions[0].require_string,
                init_result.module_resolutions[0].status,
                init_result.module_resolutions[0].target_module_path,
                init_result.module_resolutions[0].reason,
            ),
        )
        self.assertEqual(
            {"root@pc10"},
            {
                boundary.site_id
                for boundary in self_result.boundaries
                if boundary.boundary_kind == "unresolved-module-require"
            },
        )
        self.assertEqual(
            {"root.0@pc2"},
            {
                boundary.site_id
                for boundary in init_result.boundaries
                if boundary.boundary_kind == "unresolved-module-require"
            },
        )

    def test_returned_table_closure_field_is_a_module_export(self) -> None:
        fixture = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/interprocedural-module-taint"
            / "module-return-table-field-call/samplelib.luac"
        )
        module_path = "pkg/library.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        module_path,
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    module_path,
                    "returned-table-field",
                    "run",
                    "root@pc1:r1",
                    "root.0",
                    "bytecode-only,module-return-table",
                )
            },
            {
                (
                    export.module_path,
                    export.export_kind,
                    export.field_name,
                    export.value_ref,
                    export.target_prototype_id,
                    export.provenance,
                )
                for export in result.module_exports
            },
        )

    def test_returned_table_alias_preserves_closure_field_export(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/returned_table_alias.luac"
        )
        module_path = "neutral/returned_table_alias.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        module_path,
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    module_path,
                    "returned-table-field",
                    "run",
                    "root@pc2:r2",
                    "root.0",
                )
            },
            {
                (
                    export.module_path,
                    export.export_kind,
                    export.field_name,
                    export.value_ref,
                    export.target_prototype_id,
                )
                for export in result.module_exports
            },
        )

    def test_returned_table_export_rejects_stale_alias_and_dynamic_key(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/returned_table_replacement.luac"
        )
        module_path = "neutral/returned_table_replacement.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        module_path,
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "returned-table-field",
                    "live",
                    "root@pc6:r2",
                    "root.1",
                )
            },
            {
                (
                    export.export_kind,
                    export.field_name,
                    export.value_ref,
                    export.target_prototype_id,
                )
                for export in result.module_exports
            },
        )

    def test_direct_returned_closure_is_a_module_export(self) -> None:
        fixture = Path(__file__).resolve().parent / "fixtures/returned_closure.luac"
        module_path = "neutral/returned_closure.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        module_path,
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    module_path,
                    "returned-closure",
                    "",
                    "root@pc0:r0",
                    "root.0",
                    "bytecode-only,module-return-closure",
                )
            },
            {
                (
                    export.module_path,
                    export.export_kind,
                    export.field_name,
                    export.value_ref,
                    export.target_prototype_id,
                    export.provenance,
                )
                for export in result.module_exports
            },
        )

    def test_validated_module_call_exposes_global_closure_export(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/module_global_export.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "sample.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "sample.luac",
                    "module-global",
                    "run",
                    "root@pc3:r0",
                    "root.0",
                    "bytecode-only,module-global-export,module-call",
                )
            },
            {
                (
                    export.module_path,
                    export.export_kind,
                    export.field_name,
                    export.value_ref,
                    export.target_prototype_id,
                    export.provenance,
                )
                for export in result.module_exports
            },
        )

    def test_module_name_must_match_path_to_expose_global_export(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/module_global_export.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "other/path.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertTrue(
            any(
                resolution.caller_module_path == "other/path.luac"
                and resolution.callsite_id == "root@pc2"
                and resolution.resolved_name == "module"
                for resolution in result.call_resolutions
            )
        )
        self.assertEqual((), result.module_exports)

    def test_package_seeall_is_preserved_as_module_export_provenance(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/module_seeall_export.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "sample.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "module-global",
                    "run",
                    "root@pc5:r0",
                    "root.0",
                    "bytecode-only,module-global-export,module-call",
                ),
                (
                    "module-global",
                    "run",
                    "root@pc5:r0",
                    "root.0",
                    "bytecode-only,module-global-export,module-seeall",
                ),
            },
            {
                (
                    export.export_kind,
                    export.field_name,
                    export.value_ref,
                    export.target_prototype_id,
                    export.provenance,
                )
                for export in result.module_exports
            },
        )

    def test_package_seeall_exports_static_global_closure_alias(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/module_global_export_alias.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "sample.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "primary",
                    "root@pc5:r0",
                    "root.0",
                    "bytecode-only,module-global-export,module-call",
                ),
                (
                    "primary",
                    "root@pc5:r0",
                    "root.0",
                    "bytecode-only,module-global-export,module-seeall",
                ),
                (
                    "alias",
                    "root@pc5:r0",
                    "root.0",
                    "bytecode-only,module-global-export,module-seeall",
                ),
            },
            {
                (
                    export.field_name,
                    export.value_ref,
                    export.target_prototype_id,
                    export.provenance,
                )
                for export in result.module_exports
            },
        )

    def test_module_global_table_closure_field_is_an_export(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/module_global_table_export.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "sample.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "sample.luac",
                    "module-global-table-field",
                    "handlers.run",
                    "root@pc6:r1",
                    "root.0",
                    "bytecode-only,module-global-table-field-export,module-call",
                )
            },
            {
                (
                    export.module_path,
                    export.export_kind,
                    export.field_name,
                    export.value_ref,
                    export.target_prototype_id,
                    export.provenance,
                )
                for export in result.module_exports
            },
        )

    def test_seeall_global_table_export_preserves_both_provenances(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/module_global_table_seeall_export.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "sample.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "handlers.run",
                    "root@pc8:r1",
                    "root.0",
                    "bytecode-only,module-global-table-field-export,module-call",
                ),
                (
                    "handlers.run",
                    "root@pc8:r1",
                    "root.0",
                    "bytecode-only,module-global-table-field-export,module-seeall",
                ),
            },
            {
                (
                    export.field_name,
                    export.value_ref,
                    export.target_prototype_id,
                    export.provenance,
                )
                for export in result.module_exports
            },
        )

    def test_global_table_replacement_rejects_stale_and_dynamic_exports(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/module_global_table_replacement.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "sample.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "handlers.live",
                    "root@pc11:r2",
                    "root.1",
                    "bytecode-only,module-global-table-field-export,module-call",
                )
            },
            {
                (
                    export.field_name,
                    export.value_ref,
                    export.target_prototype_id,
                    export.provenance,
                )
                for export in result.module_exports
            },
        )

    def test_required_returned_field_resolves_cross_module_call_target(self) -> None:
        fixture_dir = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/interprocedural-module-taint"
            / "module-return-table-field-call"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "app/controller.luac",
                        Lua51Loader((fixture_dir / "controller.luac").read_bytes()).load(),
                    ),
                    CorpusArtifact(
                        "lib/samplelib.luac",
                        Lua51Loader((fixture_dir / "samplelib.luac").read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "app/controller.luac",
                    "root.0",
                    "root.0@pc10",
                    "root.0@pc10:r2",
                    "samplelib.run",
                    "module-field-export",
                    "lib/samplelib.luac",
                    "root.0",
                    "bytecode-only,literal-require,module-return-table",
                )
            },
            {
                (
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
                for resolution in result.call_resolutions
                if resolution.callsite_id == "root.0@pc10"
            },
        )
        self.assertFalse(
            any(
                boundary.module_path == "app/controller.luac"
                and boundary.site_id == "root.0@pc10"
                and boundary.boundary_kind == "unresolved-call-target"
                for boundary in result.boundaries
            )
        )

    def test_required_field_target_flows_through_closure_upvalue(self) -> None:
        fixture_dir = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/interprocedural-module-taint"
            / "cross-module-webcmd-popen"
        )
        controller_path = "cross-module-webcmd-popen/controller.luac"
        target_path = "cross-module-webcmd-popen/mtkwifi.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        controller_path,
                        Lua51Loader((fixture_dir / "controller.luac").read_bytes()).load(),
                    ),
                    CorpusArtifact(
                        target_path,
                        Lua51Loader((fixture_dir / "mtkwifi.luac").read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    controller_path,
                    "root.1",
                    "root.1@pc8",
                    "root.1@pc8:r1",
                    "mtkwifi.func_unknow_0_12",
                    "module-field-export",
                    target_path,
                    "root.1",
                    "bytecode-only,literal-require,module-return-table",
                )
            },
            {
                (
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
                for resolution in result.call_resolutions
                if resolution.caller_module_path == controller_path
                and resolution.callsite_id == "root.1@pc8"
            },
        )
        self.assertFalse(
            any(
                boundary.module_path == controller_path
                and boundary.site_id == "root.1@pc8"
                and boundary.boundary_kind == "unresolved-call-target"
                for boundary in result.boundaries
            )
        )

    def test_fixed_argument_flows_to_fixed_parameter_of_proven_target(self) -> None:
        fixture = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/interprocedural-module-taint"
            / "same-module-formvalue-execute/input.luac"
        )
        module_path = "same-module-formvalue-execute/input.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        module_path,
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    module_path,
                    "root",
                    "root@pc18",
                    module_path,
                    "root.3",
                    "root@pc18:r4",
                    "root.3:r0",
                    "argument-to-parameter",
                    0,
                    "bytecode-only,resolved-call,fixed-argument",
                )
            },
            {
                (
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
                for flow in result.interprocedural_flows
                if flow.flow_kind == "argument-to-parameter"
            },
        )

    def test_structural_tailcall_result_flows_to_resolved_outer_call_result(
        self,
    ) -> None:
        fixture = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/interprocedural-module-taint"
            / "same-module-formvalue-execute/input.luac"
        )
        module_path = "same-module-formvalue-execute/input.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        module_path,
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    module_path,
                    "root",
                    "root@pc15",
                    module_path,
                    "root.2",
                    "root.2@pc4:r0",
                    "root@pc15:r2",
                    "return-to-result",
                    0,
                    "bytecode-only,resolved-call,structural-tailcall-result",
                )
            },
            {
                (
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
                for flow in result.interprocedural_flows
                if flow.callsite_id == "root@pc15"
                and flow.source_ref == "root.2@pc4:r0"
            },
        )

    def test_structural_tailcall_argument_flows_to_resolved_outer_call_result(
        self,
    ) -> None:
        fixture = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/interprocedural-module-taint"
            / "same-module-formvalue-execute/input.luac"
        )
        module_path = "same-module-formvalue-execute/input.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        module_path,
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    module_path,
                    "root",
                    "root@pc15",
                    module_path,
                    "root.2",
                    "root.2@pc4:r1",
                    "root@pc15:r2",
                    "return-to-result",
                    0,
                    "bytecode-only,resolved-call,structural-tailcall-argument",
                )
            },
            {
                (
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
                for flow in result.interprocedural_flows
                if flow.callsite_id == "root@pc15"
                and flow.source_ref == "root.2@pc4:r1"
            },
        )

    def test_structural_open_tailcall_uses_producer_proven_argument_reads(
        self,
    ) -> None:
        producer = Chunk(
            num_params=0,
            is_vararg=False,
            max_stack=1,
            instructions=[],
        )
        wrapper = Chunk(
            num_params=0,
            is_vararg=False,
            max_stack=3,
            protos=[producer],
            constants=[Constant("string", "external")],
            instructions=[
                Instruction(Opcode.GETGLOBAL, InstructionType.ABx, 0, 0),
                Instruction(Opcode.CLOSURE, InstructionType.ABx, 1, 0),
                Instruction(Opcode.CALL, InstructionType.ABC, 1, 1, 0),
                Instruction(Opcode.TAILCALL, InstructionType.ABC, 0, 0, 0),
                Instruction(Opcode.RETURN, InstructionType.ABC, 0, 0, 0),
            ],
        )
        artifact = LoadedArtifact(
            chunk=Chunk(
                max_stack=1,
                protos=[wrapper],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 1, 2),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact("neutral/open-tailcall.luac", artifact),
                )
            )
        )

        self.assertEqual(
            (
                (
                    "root.0@pc3:r1",
                    "root@pc1:r0",
                    0,
                    (
                        "bytecode-only,resolved-call,"
                        "structural-tailcall-producer-proven-open-argument"
                    ),
                ),
            ),
            tuple(
                (
                    flow.source_ref,
                    flow.sink_ref,
                    flow.position,
                    flow.provenance,
                )
                for flow in result.interprocedural_flows
                if "structural-tailcall-producer-proven-open-argument"
                in flow.provenance
            ),
        )
        self.assertIn(
            ("root.0@pc3", "open-tailcall-argument-tail"),
            {
                (boundary.site_id, boundary.boundary_kind)
                for boundary in result.boundaries
            },
        )

    def test_fixed_arguments_map_only_to_existing_nonvararg_parameters(self) -> None:
        callee = Chunk(
            num_params=2,
            is_vararg=False,
            max_stack=2,
            instructions=[],
        )
        caller = LoadedArtifact(
            chunk=Chunk(
                max_stack=4,
                protos=[callee],
                constants=[
                    Constant("string", "first"),
                    Constant("string", "second"),
                    Constant("string", "discarded"),
                ],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 1, 0),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 2, 1),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 3, 2),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 4, 1),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("neutral/fixed.luac", caller),)
            )
        )

        self.assertEqual(
            (
                (
                    "neutral/fixed.luac",
                    "root",
                    "root@pc4",
                    "neutral/fixed.luac",
                    "root.0",
                    "root@pc4:r1",
                    "root.0:r0",
                    "argument-to-parameter",
                    0,
                    "bytecode-only,resolved-call,fixed-argument",
                ),
                (
                    "neutral/fixed.luac",
                    "root",
                    "root@pc4",
                    "neutral/fixed.luac",
                    "root.0",
                    "root@pc4:r2",
                    "root.0:r1",
                    "argument-to-parameter",
                    1,
                    "bytecode-only,resolved-call,fixed-argument",
                ),
            ),
            tuple(
                (
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
                for flow in result.interprocedural_flows
            ),
        )
        self.assertFalse(
            any(boundary.site_id == "root@pc4" for boundary in result.boundaries)
        )

    def test_fixed_extra_arguments_flow_only_to_proven_vararg_outputs(self) -> None:
        callee = Chunk(
            num_params=1,
            is_vararg=True,
            max_stack=3,
            instructions=[
                Instruction(Opcode.VARARG, InstructionType.ABC, 1, 3, 0),
            ],
        )
        caller = LoadedArtifact(
            chunk=Chunk(
                max_stack=5,
                protos=[callee],
                constants=[
                    Constant("string", "fixed"),
                    Constant("string", "first"),
                    Constant("string", "second"),
                    Constant("string", "unused"),
                ],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 1, 0),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 2, 1),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 3, 2),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 4, 3),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 5, 1),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("neutral/vararg.luac", caller),)
            )
        )

        self.assertEqual(
            (
                (
                    "root@pc5:r1",
                    "root.0:r0",
                    "argument-to-parameter",
                    0,
                    "bytecode-only,resolved-call,fixed-argument",
                ),
                (
                    "root@pc5:r2",
                    "root.0@pc0:r1",
                    "argument-to-vararg",
                    1,
                    "bytecode-only,resolved-call,fixed-vararg",
                ),
                (
                    "root@pc5:r3",
                    "root.0@pc0:r2",
                    "argument-to-vararg",
                    2,
                    "bytecode-only,resolved-call,fixed-vararg",
                ),
            ),
            tuple(
                (
                    flow.source_ref,
                    flow.sink_ref,
                    flow.flow_kind,
                    flow.position,
                    flow.provenance,
                )
                for flow in result.interprocedural_flows
            ),
        )
        self.assertFalse(
            any(flow.source_ref == "root@pc5:r4" for flow in result.interprocedural_flows)
        )

    def test_open_call_maps_only_producer_proven_argument_to_parameter(self) -> None:
        callee = Chunk(
            num_params=1,
            is_vararg=False,
            max_stack=1,
            instructions=[],
        )
        producer = Chunk(
            num_params=0,
            is_vararg=False,
            max_stack=1,
            instructions=[],
        )
        caller = LoadedArtifact(
            chunk=Chunk(
                max_stack=2,
                protos=[callee, producer],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 1, 1),
                    Instruction(Opcode.CALL, InstructionType.ABC, 1, 1, 0),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 0, 1),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("neutral/open-call.luac", caller),)
            )
        )

        self.assertEqual(
            (
                (
                    "neutral/open-call.luac",
                    "root",
                    "root@pc3",
                    "neutral/open-call.luac",
                    "root.0",
                    "root@pc3:r1",
                    "root.0:r0",
                    "argument-to-parameter",
                    0,
                    "bytecode-only,resolved-call,producer-proven-open-argument",
                ),
            ),
            tuple(
                (
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
                for flow in result.interprocedural_flows
            ),
        )
        self.assertIn(
            ("root@pc3", "open-call-argument-tail"),
            {
                (boundary.site_id, boundary.boundary_kind)
                for boundary in result.boundaries
            },
        )

    def test_open_call_maps_proven_argument_to_fixed_vararg_output(self) -> None:
        callee = Chunk(
            num_params=0,
            is_vararg=True,
            max_stack=1,
            instructions=[
                Instruction(Opcode.VARARG, InstructionType.ABC, 0, 2, 0),
            ],
        )
        producer = Chunk(
            num_params=0,
            is_vararg=False,
            max_stack=1,
            instructions=[],
        )
        caller = LoadedArtifact(
            chunk=Chunk(
                max_stack=2,
                protos=[callee, producer],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 1, 1),
                    Instruction(Opcode.CALL, InstructionType.ABC, 1, 1, 0),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 0, 1),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("neutral/open-vararg.luac", caller),)
            )
        )

        self.assertEqual(
            (
                (
                    "root@pc3:r1",
                    "root.0@pc0:r0",
                    "argument-to-vararg",
                    0,
                    "bytecode-only,resolved-call,producer-proven-open-vararg",
                ),
            ),
            tuple(
                (
                    flow.source_ref,
                    flow.sink_ref,
                    flow.flow_kind,
                    flow.position,
                    flow.provenance,
                )
                for flow in result.interprocedural_flows
            ),
        )
        self.assertIn(
            ("root@pc3", "open-call-argument-tail"),
            {
                (boundary.site_id, boundary.boundary_kind)
                for boundary in result.boundaries
            },
        )

    def test_fixed_callee_return_flows_to_fixed_caller_result(self) -> None:
        callee = Chunk(
            num_params=1,
            is_vararg=False,
            max_stack=1,
            instructions=[
                Instruction(Opcode.RETURN, InstructionType.ABC, 0, 2, 0),
            ],
        )
        caller = LoadedArtifact(
            chunk=Chunk(
                max_stack=2,
                protos=[callee],
                constants=[Constant("string", "value")],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 1, 0),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 2, 2),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("neutral/fixed-return.luac", caller),)
            )
        )

        self.assertEqual(
            (
                (
                    "neutral/fixed-return.luac",
                    "root",
                    "root@pc2",
                    "neutral/fixed-return.luac",
                    "root.0",
                    "root.0@pc0:r0",
                    "root@pc2:r0",
                    "return-to-result",
                    0,
                    "bytecode-only,resolved-call,fixed-return",
                ),
            ),
            tuple(
                (
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
                for flow in result.interprocedural_flows
                if flow.flow_kind == "return-to-result"
            ),
        )
        self.assertIn(
            ("root@pc2:r1", "root.0:r0", "argument-to-parameter"),
            {
                (flow.source_ref, flow.sink_ref, flow.flow_kind)
                for flow in result.interprocedural_flows
            },
        )

    def test_fixed_returns_map_only_to_accepted_caller_results(self) -> None:
        callee = Chunk(
            num_params=3,
            is_vararg=False,
            max_stack=3,
            instructions=[
                Instruction(Opcode.RETURN, InstructionType.ABC, 0, 4, 0),
            ],
        )
        caller = LoadedArtifact(
            chunk=Chunk(
                max_stack=4,
                protos=[callee],
                constants=[
                    Constant("string", "first"),
                    Constant("string", "second"),
                    Constant("string", "third"),
                ],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 1, 0),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 2, 1),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 3, 2),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 4, 3),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("neutral/multiple-return.luac", caller),)
            )
        )

        self.assertEqual(
            (
                (
                    "neutral/multiple-return.luac",
                    "root",
                    "root@pc4",
                    "neutral/multiple-return.luac",
                    "root.0",
                    "root.0@pc0:r0",
                    "root@pc4:r0",
                    "return-to-result",
                    0,
                    "bytecode-only,resolved-call,fixed-return",
                ),
                (
                    "neutral/multiple-return.luac",
                    "root",
                    "root@pc4",
                    "neutral/multiple-return.luac",
                    "root.0",
                    "root.0@pc0:r1",
                    "root@pc4:r1",
                    "return-to-result",
                    1,
                    "bytecode-only,resolved-call,fixed-return",
                ),
            ),
            tuple(
                (
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
                for flow in result.interprocedural_flows
                if flow.flow_kind == "return-to-result"
            ),
        )

    def test_multiple_return_sites_preserve_caller_callsite_ownership(self) -> None:
        callee = Chunk(
            num_params=1,
            is_vararg=False,
            max_stack=1,
            instructions=[
                Instruction(Opcode.TEST, InstructionType.ABC, 0, 0, 0),
                Instruction(Opcode.RETURN, InstructionType.ABC, 0, 2, 0),
                Instruction(Opcode.RETURN, InstructionType.ABC, 0, 2, 0),
            ],
        )
        caller = LoadedArtifact(
            chunk=Chunk(
                max_stack=4,
                protos=[callee],
                constants=[
                    Constant("string", "first"),
                    Constant("string", "second"),
                ],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.MOVE, InstructionType.ABC, 2, 0, 0),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 1, 0),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 2, 2),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 3, 1),
                    Instruction(Opcode.CALL, InstructionType.ABC, 2, 2, 2),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("neutral/balanced-return.luac", caller),)
            )
        )

        self.assertEqual(
            (
                ("root@pc3", "root.0@pc1:r0", "root@pc3:r0", 0),
                ("root@pc3", "root.0@pc2:r0", "root@pc3:r0", 0),
                ("root@pc5", "root.0@pc1:r0", "root@pc5:r2", 0),
                ("root@pc5", "root.0@pc2:r0", "root@pc5:r2", 0),
            ),
            tuple(
                (
                    flow.callsite_id,
                    flow.source_ref,
                    flow.sink_ref,
                    flow.position,
                )
                for flow in result.interprocedural_flows
                if flow.flow_kind == "return-to-result"
            ),
        )

    def test_cross_module_fixed_return_preserves_module_ownership(self) -> None:
        fixture_dir = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/interprocedural-module-taint"
            / "module-return-table-field-call"
        )
        controller = Lua51Loader((fixture_dir / "controller.luac").read_bytes()).load()
        samplelib = Lua51Loader((fixture_dir / "samplelib.luac").read_bytes()).load()
        controller.chunk.protos[0].instructions[10] = Instruction(
            Opcode.CALL,
            InstructionType.ABC,
            2,
            2,
            2,
        )
        samplelib.chunk.protos[0].instructions[4] = Instruction(
            Opcode.RETURN,
            InstructionType.ABC,
            1,
            2,
            0,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact("app/controller.luac", controller),
                    CorpusArtifact("lib/samplelib.luac", samplelib),
                )
            )
        )

        self.assertEqual(
            (
                (
                    "app/controller.luac",
                    "root.0@pc10",
                    "lib/samplelib.luac",
                    "root.0@pc3:r1",
                    "root.0@pc10:r2",
                    0,
                    "bytecode-only,resolved-call,structural-tailcall-result",
                ),
                (
                    "app/controller.luac",
                    "root.0@pc10",
                    "lib/samplelib.luac",
                    "root.0@pc3:r2",
                    "root.0@pc10:r2",
                    0,
                    "bytecode-only,resolved-call,structural-tailcall-argument",
                ),
                (
                    "app/controller.luac",
                    "root.0@pc10",
                    "lib/samplelib.luac",
                    "root.0@pc4:r1",
                    "root.0@pc10:r2",
                    0,
                    "bytecode-only,resolved-call,fixed-return",
                ),
            ),
            tuple(
                (
                    flow.caller_module_path,
                    flow.callsite_id,
                    flow.callee_module_path,
                    flow.source_ref,
                    flow.sink_ref,
                    flow.position,
                    flow.provenance,
                )
                for flow in result.interprocedural_flows
                if flow.flow_kind == "return-to-result"
                and flow.callsite_id == "root.0@pc10"
            ),
        )

    def test_open_callee_return_maps_only_producer_proven_fixed_result(self) -> None:
        callee = Chunk(
            num_params=0,
            is_vararg=True,
            max_stack=1,
            instructions=[
                Instruction(Opcode.VARARG, InstructionType.ABC, 0, 0, 0),
                Instruction(Opcode.RETURN, InstructionType.ABC, 0, 0, 0),
            ],
        )
        caller = LoadedArtifact(
            chunk=Chunk(
                max_stack=1,
                protos=[callee],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 1, 2),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("neutral/open-return.luac", caller),)
            )
        )

        self.assertEqual(
            (
                (
                    "root.0@pc1:r0",
                    "root@pc1:r0",
                    "return-to-result",
                    0,
                    "bytecode-only,resolved-call,producer-proven-open-return",
                ),
            ),
            tuple(
                (
                    flow.source_ref,
                    flow.sink_ref,
                    flow.flow_kind,
                    flow.position,
                    flow.provenance,
                )
                for flow in result.interprocedural_flows
                if flow.flow_kind == "return-to-result"
            ),
        )
        self.assertTrue(
            {
                ("root.0@pc0", "open-vararg-tail"),
                ("root.0@pc1", "open-return-tail"),
            }.issubset(
                {
                    (boundary.site_id, boundary.boundary_kind)
                    for boundary in result.boundaries
                }
            )
        )

    def test_fixed_returns_map_only_proven_open_caller_results(self) -> None:
        callee = Chunk(
            num_params=2,
            is_vararg=False,
            max_stack=2,
            instructions=[
                Instruction(Opcode.RETURN, InstructionType.ABC, 0, 3, 0),
            ],
        )
        caller = LoadedArtifact(
            chunk=Chunk(
                max_stack=4,
                protos=[callee],
                constants=[
                    Constant("string", "first"),
                    Constant("string", "second"),
                ],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 1, 0),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 2, 1),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 3, 0),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact("neutral/open-caller-results.luac", caller),
                )
            )
        )

        self.assertEqual(
            (
                (
                    "root.0@pc0:r0",
                    "root@pc3:r0",
                    "return-to-result",
                    0,
                    "bytecode-only,resolved-call,producer-proven-open-result",
                ),
                (
                    "root.0@pc0:r1",
                    "root@pc3:r1",
                    "return-to-result",
                    1,
                    "bytecode-only,resolved-call,producer-proven-open-result",
                ),
            ),
            tuple(
                (
                    flow.source_ref,
                    flow.sink_ref,
                    flow.flow_kind,
                    flow.position,
                    flow.provenance,
                )
                for flow in result.interprocedural_flows
                if flow.flow_kind == "return-to-result"
            ),
        )
        self.assertFalse(
            any(
                flow.position >= 2
                for flow in result.interprocedural_flows
                if flow.flow_kind == "return-to-result"
            )
        )
        self.assertIn(
            ("root@pc3", "open-call-result-tail"),
            {
                (boundary.site_id, boundary.boundary_kind)
                for boundary in result.boundaries
            },
        )

    def test_proven_open_return_maps_only_proven_open_caller_result(self) -> None:
        callee = Chunk(
            num_params=0,
            is_vararg=True,
            max_stack=1,
            instructions=[
                Instruction(Opcode.VARARG, InstructionType.ABC, 0, 0, 0),
                Instruction(Opcode.RETURN, InstructionType.ABC, 0, 0, 0),
            ],
        )
        caller = LoadedArtifact(
            chunk=Chunk(
                max_stack=2,
                protos=[callee],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 1, 0),
                    Instruction(Opcode.MOVE, InstructionType.ABC, 1, 0, 0),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact("neutral/open-return-open-result.luac", caller),
                )
            )
        )

        self.assertEqual(
            (
                (
                    "root.0@pc1:r0",
                    "root@pc1:r0",
                    "return-to-result",
                    0,
                    (
                        "bytecode-only,resolved-call,producer-proven-open-return,"
                        "producer-proven-open-result"
                    ),
                ),
            ),
            tuple(
                (
                    flow.source_ref,
                    flow.sink_ref,
                    flow.flow_kind,
                    flow.position,
                    flow.provenance,
                )
                for flow in result.interprocedural_flows
                if flow.flow_kind == "return-to-result"
            ),
        )
        self.assertTrue(
            {
                ("root.0@pc0", "open-vararg-tail"),
                ("root.0@pc1", "open-return-tail"),
                ("root@pc1", "open-call-result-tail"),
            }.issubset(
                {
                    (boundary.site_id, boundary.boundary_kind)
                    for boundary in result.boundaries
                }
            )
        )

    def test_resolved_tailcall_maps_fixed_argument_to_parameter(self) -> None:
        callee = Chunk(
            num_params=1,
            is_vararg=False,
            max_stack=1,
            instructions=[
                Instruction(Opcode.RETURN, InstructionType.ABC, 0, 2, 0),
            ],
        )
        wrapper = LoadedArtifact(
            chunk=Chunk(
                num_params=1,
                is_vararg=False,
                max_stack=3,
                protos=[callee],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 1, 0),
                    Instruction(Opcode.MOVE, InstructionType.ABC, 2, 0, 0),
                    Instruction(Opcode.TAILCALL, InstructionType.ABC, 1, 2, 0),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 1, 0, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("neutral/tailcall-argument.luac", wrapper),)
            )
        )

        self.assertEqual(
            (
                (
                    "root@pc2:r2",
                    "root.0:r0",
                    "argument-to-parameter",
                    0,
                    "bytecode-only,resolved-tailcall,fixed-argument",
                ),
            ),
            tuple(
                (
                    flow.source_ref,
                    flow.sink_ref,
                    flow.flow_kind,
                    flow.position,
                    flow.provenance,
                )
                for flow in result.interprocedural_flows
                if flow.flow_kind == "argument-to-parameter"
            ),
        )
        self.assertIn(
            ("root@pc3", "open-return-tail"),
            {
                (boundary.site_id, boundary.boundary_kind)
                for boundary in result.boundaries
            },
        )

    def test_fixed_return_maps_to_resolved_tailcall_result(self) -> None:
        callee = Chunk(
            num_params=1,
            is_vararg=False,
            max_stack=1,
            instructions=[
                Instruction(Opcode.RETURN, InstructionType.ABC, 0, 2, 0),
            ],
        )
        wrapper = LoadedArtifact(
            chunk=Chunk(
                num_params=1,
                is_vararg=False,
                max_stack=3,
                protos=[callee],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 1, 0),
                    Instruction(Opcode.MOVE, InstructionType.ABC, 2, 0, 0),
                    Instruction(Opcode.TAILCALL, InstructionType.ABC, 1, 2, 0),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 1, 0, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("neutral/tailcall-return.luac", wrapper),)
            )
        )

        self.assertEqual(
            (
                (
                    "root.0@pc0:r0",
                    "root@pc2:r1",
                    "return-to-result",
                    0,
                    "bytecode-only,resolved-tailcall,producer-proven-open-result",
                ),
            ),
            tuple(
                (
                    flow.source_ref,
                    flow.sink_ref,
                    flow.flow_kind,
                    flow.position,
                    flow.provenance,
                )
                for flow in result.interprocedural_flows
                if flow.flow_kind == "return-to-result"
            ),
        )
        self.assertIn(
            ("root@pc2:r2", "root.0:r0"),
            {
                (flow.source_ref, flow.sink_ref)
                for flow in result.interprocedural_flows
                if flow.flow_kind == "argument-to-parameter"
            },
        )
        self.assertIn(
            ("root@pc3", "open-return-tail"),
            {
                (boundary.site_id, boundary.boundary_kind)
                for boundary in result.boundaries
            },
        )

    def test_resolved_tailcall_result_forwards_to_outer_call_result(self) -> None:
        inner = Chunk(
            num_params=1,
            is_vararg=False,
            max_stack=1,
            instructions=[
                Instruction(Opcode.RETURN, InstructionType.ABC, 0, 2, 0),
            ],
        )
        wrapper = Chunk(
            num_params=1,
            is_vararg=False,
            max_stack=3,
            protos=[inner],
            instructions=[
                Instruction(Opcode.CLOSURE, InstructionType.ABx, 1, 0),
                Instruction(Opcode.MOVE, InstructionType.ABC, 2, 0, 0),
                Instruction(Opcode.TAILCALL, InstructionType.ABC, 1, 2, 0),
                Instruction(Opcode.RETURN, InstructionType.ABC, 1, 0, 0),
            ],
        )
        outer = LoadedArtifact(
            chunk=Chunk(
                max_stack=2,
                protos=[wrapper],
                constants=[Constant("string", "value")],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 1, 0),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 2, 2),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("neutral/tailcall-forward.luac", outer),)
            )
        )

        self.assertEqual(
            (
                (
                    "root",
                    "root@pc2",
                    "root.0",
                    "root.0@pc2:r1",
                    "root@pc2:r0",
                    0,
                    (
                        "bytecode-only,resolved-call,resolved-tailcall,"
                        "tailcall-forward"
                    ),
                ),
                (
                    "root.0",
                    "root.0@pc2",
                    "root.0.0",
                    "root.0.0@pc0:r0",
                    "root.0@pc2:r1",
                    0,
                    "bytecode-only,resolved-tailcall,producer-proven-open-result",
                ),
            ),
            tuple(
                (
                    flow.caller_prototype_id,
                    flow.callsite_id,
                    flow.callee_prototype_id,
                    flow.source_ref,
                    flow.sink_ref,
                    flow.position,
                    flow.provenance,
                )
                for flow in result.interprocedural_flows
                if flow.flow_kind == "return-to-result"
            ),
        )
        self.assertNotIn(
            ("root.0.0@pc0:r0", "root@pc2:r0"),
            {
                (flow.source_ref, flow.sink_ref)
                for flow in result.interprocedural_flows
            },
        )

    def test_resolved_tailcall_chain_forwards_each_wrapper_result(self) -> None:
        def tail_wrapper(child: Chunk) -> Chunk:
            return Chunk(
                num_params=1,
                is_vararg=False,
                max_stack=3,
                protos=[child],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 1, 0),
                    Instruction(Opcode.MOVE, InstructionType.ABC, 2, 0, 0),
                    Instruction(Opcode.TAILCALL, InstructionType.ABC, 1, 2, 0),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 1, 0, 0),
                ],
            )

        inner = Chunk(
            num_params=1,
            is_vararg=False,
            max_stack=1,
            instructions=[
                Instruction(Opcode.RETURN, InstructionType.ABC, 0, 2, 0),
            ],
        )
        wrapper_two = tail_wrapper(inner)
        wrapper_one = tail_wrapper(wrapper_two)
        outer = LoadedArtifact(
            chunk=Chunk(
                max_stack=2,
                protos=[wrapper_one],
                constants=[Constant("string", "value")],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 1, 0),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 2, 2),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("neutral/tailcall-chain.luac", outer),)
            )
        )

        self.assertEqual(
            (
                (
                    "root",
                    "root@pc2",
                    "root.0",
                    "root.0@pc2:r1",
                    "root@pc2:r0",
                    "bytecode-only,resolved-call,resolved-tailcall,tailcall-forward",
                ),
                (
                    "root.0",
                    "root.0@pc2",
                    "root.0.0",
                    "root.0.0@pc2:r1",
                    "root.0@pc2:r1",
                    "bytecode-only,resolved-tailcall,tailcall-chain-forward",
                ),
                (
                    "root.0.0",
                    "root.0.0@pc2",
                    "root.0.0.0",
                    "root.0.0.0@pc0:r0",
                    "root.0.0@pc2:r1",
                    "bytecode-only,resolved-tailcall,producer-proven-open-result",
                ),
            ),
            tuple(
                (
                    flow.caller_prototype_id,
                    flow.callsite_id,
                    flow.callee_prototype_id,
                    flow.source_ref,
                    flow.sink_ref,
                    flow.provenance,
                )
                for flow in result.interprocedural_flows
                if flow.flow_kind == "return-to-result"
            ),
        )
        self.assertTrue(
            {
                ("root.0.0.0@pc0:r0", "root.0@pc2:r1"),
                ("root.0.0.0@pc0:r0", "root@pc2:r0"),
                ("root.0.0@pc2:r1", "root@pc2:r0"),
            }.isdisjoint(
                {
                    (flow.source_ref, flow.sink_ref)
                    for flow in result.interprocedural_flows
                }
            )
        )

    def test_cross_module_tailcall_preserves_scope_and_rejects_unresolved_chain(
        self,
    ) -> None:
        fixture_dir = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/interprocedural-module-taint"
            / "module-return-table-field-call"
        )

        def load_artifacts() -> tuple[LoadedArtifact, LoadedArtifact]:
            return (
                Lua51Loader((fixture_dir / "controller.luac").read_bytes()).load(),
                Lua51Loader((fixture_dir / "samplelib.luac").read_bytes()).load(),
            )

        controller, samplelib = load_artifacts()
        original = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact("app/controller.luac", controller),
                    CorpusArtifact("lib/samplelib.luac", samplelib),
                )
            )
        )
        self.assertFalse(
            any(
                flow.flow_kind == "return-to-result"
                for flow in original.interprocedural_flows
            )
        )

        controller, samplelib = load_artifacts()
        inner = Chunk(
            num_params=1,
            is_vararg=False,
            max_stack=1,
            instructions=[
                Instruction(Opcode.RETURN, InstructionType.ABC, 0, 2, 0),
            ],
        )
        samplelib.chunk.protos[0] = Chunk(
            num_params=1,
            is_vararg=False,
            max_stack=3,
            protos=[inner],
            instructions=[
                Instruction(Opcode.CLOSURE, InstructionType.ABx, 1, 0),
                Instruction(Opcode.MOVE, InstructionType.ABC, 2, 0, 0),
                Instruction(Opcode.TAILCALL, InstructionType.ABC, 1, 2, 0),
                Instruction(Opcode.RETURN, InstructionType.ABC, 1, 0, 0),
            ],
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact("app/controller.luac", controller),
                    CorpusArtifact("lib/samplelib.luac", samplelib),
                )
            )
        )

        self.assertEqual(
            (
                (
                    "app/controller.luac",
                    "root.0",
                    "root.0@pc10",
                    "lib/samplelib.luac",
                    "root.0",
                    "root.0@pc2:r1",
                    "root.0@pc10:r2",
                    "bytecode-only,resolved-tailcall,tailcall-chain-forward",
                ),
                (
                    "app/controller.luac",
                    "root.1",
                    "root.1@pc10",
                    "lib/samplelib.luac",
                    "root.0",
                    "root.0@pc2:r1",
                    "root.1@pc10:r1",
                    "bytecode-only,resolved-tailcall,tailcall-chain-forward",
                ),
                (
                    "lib/samplelib.luac",
                    "root.0",
                    "root.0@pc2",
                    "lib/samplelib.luac",
                    "root.0.0",
                    "root.0.0@pc0:r0",
                    "root.0@pc2:r1",
                    "bytecode-only,resolved-tailcall,producer-proven-open-result",
                ),
            ),
            tuple(
                (
                    flow.caller_module_path,
                    flow.caller_prototype_id,
                    flow.callsite_id,
                    flow.callee_module_path,
                    flow.callee_prototype_id,
                    flow.source_ref,
                    flow.sink_ref,
                    flow.provenance,
                )
                for flow in result.interprocedural_flows
                if flow.flow_kind == "return-to-result"
            ),
        )

    def test_required_field_target_survives_source_before_require_order(self) -> None:
        fixture_dir = (
            Path(__file__).resolve().parents[2]
            / "ql/test/library-tests/interprocedural-module-taint"
            / "module-return-table-field-call"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "app/controller.luac",
                        Lua51Loader((fixture_dir / "controller.luac").read_bytes()).load(),
                    ),
                    CorpusArtifact(
                        "lib/samplelib.luac",
                        Lua51Loader((fixture_dir / "samplelib.luac").read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "root.1@pc10:r1",
                    "samplelib.run",
                    "module-field-export",
                    "lib/samplelib.luac",
                    "root.0",
                    "bytecode-only,literal-require,module-return-table",
                )
            },
            {
                (
                    resolution.target_value_ref,
                    resolution.resolved_name,
                    resolution.resolution_kind,
                    resolution.target_module_path,
                    resolution.target_prototype_id,
                    resolution.provenance,
                )
                for resolution in result.call_resolutions
                if resolution.caller_module_path == "app/controller.luac"
                and resolution.callsite_id == "root.1@pc10"
            },
        )
        self.assertFalse(
            any(
                boundary.module_path == "app/controller.luac"
                and boundary.site_id == "root.1@pc10"
                and boundary.boundary_kind == "unresolved-call-target"
                for boundary in result.boundaries
            )
        )

    def test_missing_required_module_field_retains_unresolved_boundary(self) -> None:
        test_dir = Path(__file__).resolve().parent
        library = (
            test_dir.parents[1]
            / "ql/test/library-tests/interprocedural-module-taint"
            / "module-return-table-field-call/samplelib.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "app/controller.luac",
                        Lua51Loader(
                            (test_dir / "fixtures/module_missing_field_caller.luac").read_bytes()
                        ).load(),
                    ),
                    CorpusArtifact(
                        "lib/samplelib.luac",
                        Lua51Loader(library.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual("matched", result.module_resolutions[0].status)
        self.assertEqual(
            "lib/samplelib.luac",
            result.module_resolutions[0].target_module_path,
        )
        self.assertFalse(
            any(
                resolution.caller_module_path == "app/controller.luac"
                and resolution.callsite_id == "root@pc5"
                for resolution in result.call_resolutions
            )
        )
        self.assertEqual(
            {("root@pc5", "no-proven-target")},
            {
                (boundary.site_id, boundary.reason)
                for boundary in result.boundaries
                if boundary.module_path == "app/controller.luac"
                and boundary.boundary_kind == "unresolved-call-target"
                and boundary.site_id == "root@pc5"
            },
        )

    def test_multiple_required_module_field_targets_are_all_resolved(self) -> None:
        test_dir = Path(__file__).resolve().parent
        controller = (
            test_dir.parents[1]
            / "ql/test/library-tests/interprocedural-module-taint"
            / "module-return-table-field-call/controller.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "app/controller.luac",
                        Lua51Loader(controller.read_bytes()).load(),
                    ),
                    CorpusArtifact(
                        "lib/samplelib.luac",
                        Lua51Loader(
                            (test_dir / "fixtures/module_multiple_field_exports.luac").read_bytes()
                        ).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {"root.0", "root.1"},
            {
                export.target_prototype_id
                for export in result.module_exports
                if export.module_path == "lib/samplelib.luac"
                and export.field_name == "run"
            },
        )
        self.assertEqual(
            {
                (
                    "root.0",
                    "root.0@pc10:r2",
                    "samplelib.run",
                    "bytecode-only,literal-require,module-global-export,module-call",
                ),
                (
                    "root.1",
                    "root.0@pc10:r2",
                    "samplelib.run",
                    "bytecode-only,literal-require,module-global-export,module-call",
                ),
            },
            {
                (
                    resolution.target_prototype_id,
                    resolution.target_value_ref,
                    resolution.resolved_name,
                    resolution.provenance,
                )
                for resolution in result.call_resolutions
                if resolution.caller_module_path == "app/controller.luac"
                and resolution.callsite_id == "root.0@pc10"
            },
        )
        self.assertEqual(
            {
                (
                    "root.0",
                    "root.0@pc10:r3",
                    "root.0:r0",
                    "bytecode-only,resolved-tailcall,fixed-argument",
                ),
                (
                    "root.1",
                    "root.0@pc10:r3",
                    "root.1:r0",
                    "bytecode-only,resolved-tailcall,fixed-argument",
                ),
            },
            {
                (
                    flow.callee_prototype_id,
                    flow.source_ref,
                    flow.sink_ref,
                    flow.provenance,
                )
                for flow in result.interprocedural_flows
                if flow.caller_module_path == "app/controller.luac"
                and flow.callsite_id == "root.0@pc10"
                and flow.flow_kind == "argument-to-parameter"
            },
        )
        self.assertEqual(
            {
                (
                    "root.0",
                    "root.0@pc0:r0",
                    "root.0@pc10:r2",
                    "bytecode-only,resolved-tailcall,producer-proven-open-result",
                ),
                (
                    "root.1",
                    "root.1@pc0:r0",
                    "root.0@pc10:r2",
                    "bytecode-only,resolved-tailcall,producer-proven-open-result",
                ),
            },
            {
                (
                    flow.callee_prototype_id,
                    flow.source_ref,
                    flow.sink_ref,
                    flow.provenance,
                )
                for flow in result.interprocedural_flows
                if flow.caller_module_path == "app/controller.luac"
                and flow.callsite_id == "root.0@pc10"
                and flow.flow_kind == "return-to-result"
            },
        )
        self.assertFalse(
            any(
                boundary.module_path == "app/controller.luac"
                and boundary.site_id == "root.0@pc10"
                and boundary.boundary_kind == "unresolved-call-target"
                for boundary in result.boundaries
            )
        )

    def test_required_nested_static_module_field_resolves_exact_closure(self) -> None:
        test_dir = Path(__file__).resolve().parent
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "app/controller.luac",
                        Lua51Loader(
                            (test_dir / "fixtures/module_nested_field_caller.luac").read_bytes()
                        ).load(),
                    ),
                    CorpusArtifact(
                        "lib/sample.luac",
                        Lua51Loader(
                            (test_dir / "fixtures/module_nested_field_provider.luac").read_bytes()
                        ).load(),
                    ),
                )
            )
        )

        positive = [
            resolution
            for resolution in result.call_resolutions
            if resolution.caller_module_path == "app/controller.luac"
            and resolution.resolved_name == "sample.handlers.run"
        ]
        self.assertEqual(1, len(positive))
        self.assertEqual("module-field-export", positive[0].resolution_kind)
        self.assertEqual("lib/sample.luac", positive[0].target_module_path)
        self.assertEqual("root.0", positive[0].target_prototype_id)

        self.assertEqual(
            {"argument-to-parameter", "return-to-result"},
            {
                flow.flow_kind
                for flow in result.interprocedural_flows
                if flow.caller_module_path == "app/controller.luac"
                and flow.callsite_id == positive[0].callsite_id
                and flow.callee_module_path == "lib/sample.luac"
                and flow.callee_prototype_id == "root.0"
            },
        )

        unresolved_names = {
            resolution.resolved_name
            for resolution in result.call_resolutions
            if resolution.caller_module_path == "app/controller.luac"
            and not resolution.target_module_path
            and not resolution.target_prototype_id
        }
        self.assertIn("sample.handlers.missing", unresolved_names)
        self.assertEqual(
            ["no-proven-target"],
            [
                boundary.reason
                for boundary in result.boundaries
                if boundary.module_path == "app/controller.luac"
                and boundary.boundary_kind == "unresolved-call-target"
            ],
        )
        self.assertFalse(
            any(
                resolution.target_module_path == "lib/sample.luac"
                and resolution.target_prototype_id == "root.0"
                and resolution.resolved_name != "sample.handlers.run"
                for resolution in result.call_resolutions
            )
        )

    def test_same_module_global_call_resolves_exported_closure(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/module_same_module_export_call.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "samplelib.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "samplelib.luac",
                    "root.1",
                    "root.1@pc2",
                    "root.1@pc2:r1",
                    "helper",
                    "same-module-field-export",
                    "samplelib.luac",
                    "root.0",
                    "bytecode-only,same-module,module-global-export,module-call",
                )
            },
            {
                (
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
                for resolution in result.call_resolutions
                if resolution.callsite_id == "root.1@pc2"
            },
        )

    def test_same_module_global_table_call_resolves_exported_closure(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/module_same_module_global_table_call.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "sample.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "sample.luac",
                    "root.1",
                    "root.1@pc3",
                    "root.1@pc3:r1",
                    "handlers.run",
                    "same-module-field-export",
                    "sample.luac",
                    "root.0",
                    (
                        "bytecode-only,same-module,"
                        "module-global-table-field-export,module-call"
                    ),
                )
            },
            {
                (
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
                for resolution in result.call_resolutions
                if resolution.callsite_id == "root.1@pc3"
            },
        )

    def test_multiple_same_module_global_targets_remain_name_only(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/module_multiple_same_module_exports.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "sample.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {"root.0", "root.1"},
            {
                export.target_prototype_id
                for export in result.module_exports
                if export.export_kind == "module-global"
                and export.field_name == "helper"
            },
        )
        self.assertEqual(
            {
                (
                    "helper",
                    "derived-reaching-definition-call-target",
                    "",
                    "",
                )
            },
            {
                (
                    resolution.resolved_name,
                    resolution.resolution_kind,
                    resolution.target_module_path,
                    resolution.target_prototype_id,
                )
                for resolution in result.call_resolutions
                if resolution.caller_module_path == "sample.luac"
                and resolution.callsite_id == "root.2@pc2"
            },
        )

    def test_multiple_same_module_table_field_targets_remain_name_only(
        self,
    ) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/module_multiple_same_module_global_table_exports.luac"
        )
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "sample.luac",
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {"root.0", "root.1"},
            {
                export.target_prototype_id
                for export in result.module_exports
                if export.export_kind == "module-global-table-field"
                and export.field_name == "handlers.run"
            },
        )
        self.assertEqual(
            {
                (
                    "handlers.run",
                    "derived-reaching-definition-call-target",
                    "",
                    "",
                )
            },
            {
                (
                    resolution.resolved_name,
                    resolution.resolution_kind,
                    resolution.target_module_path,
                    resolution.target_prototype_id,
                )
                for resolution in result.call_resolutions
                if resolution.caller_module_path == "sample.luac"
                and resolution.callsite_id == "root.2@pc3"
            },
        )

    def test_closure_call_target_uses_only_precise_table_field_flow(self) -> None:
        def loaded(read_key_index: int) -> LoadedArtifact:
            return LoadedArtifact(
                chunk=Chunk(
                    max_stack=3,
                    constants=[
                        Constant("string", "handler"),
                        Constant("string", "missing"),
                    ],
                    protos=[Chunk(max_stack=1, instructions=[])],
                    instructions=[
                        Instruction(Opcode.NEWTABLE, InstructionType.ABC, 0, 0, 0),
                        Instruction(Opcode.CLOSURE, InstructionType.ABx, 1, 0),
                        Instruction(Opcode.SETTABLE, InstructionType.ABC, 0, 256, 1),
                        Instruction(
                            Opcode.GETTABLE,
                            InstructionType.ABC,
                            2,
                            0,
                            256 + read_key_index,
                        ),
                        Instruction(Opcode.CALL, InstructionType.ABC, 2, 1, 1),
                        Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                    ],
                ),
                profile={},
                profile_id="test-profile",
                accepted=True,
            )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact("positive/table.luac", loaded(0)),
                    CorpusArtifact("negative/missing-field.luac", loaded(1)),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "positive/table.luac",
                    "root",
                    "root@pc4",
                    "root@pc4:r2",
                    "",
                    "closure-table-field",
                    "positive/table.luac",
                    "root.0",
                    "bytecode-only,closure-table-field-target",
                )
            },
            {
                (
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
                for resolution in result.call_resolutions
            },
        )

    def test_captured_local_table_field_call_resolves_unique_closure(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/captured_local_table_field_closure.luac"
        )
        module_path = "neutral/captured-local-table-field-closure.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        module_path,
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    module_path,
                    "root.1",
                    "root.1@pc3",
                    module_path,
                    "root.0",
                )
            },
            {
                (
                    resolution.caller_module_path,
                    resolution.caller_prototype_id,
                    resolution.callsite_id,
                    resolution.target_module_path,
                    resolution.target_prototype_id,
                )
                for resolution in result.call_resolutions
                if resolution.callsite_id == "root.1@pc3"
            },
        )
        self.assertFalse(
            any(
                boundary.prototype_id == "root.1"
                and boundary.site_id == "root.1@pc3"
                and boundary.boundary_kind == "unresolved-call-target"
                for boundary in result.boundaries
            )
        )

    def test_captured_local_table_field_overwrite_drops_old_closure(self) -> None:
        fixture = (
            Path(__file__).resolve().parent
            / "fixtures/captured_local_table_field_overwrite.luac"
        )
        module_path = "neutral/captured-local-table-field-overwrite.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        module_path,
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertNotIn(
            ("root.1", "root.1@pc3"),
            {
                (resolution.caller_prototype_id, resolution.callsite_id)
                for resolution in result.call_resolutions
            },
        )
        self.assertIn(
            ("root.1", "root.1@pc3", "unresolved-call-target"),
            {
                (
                    boundary.prototype_id,
                    boundary.site_id,
                    boundary.boundary_kind,
                )
                for boundary in result.boundaries
            },
        )

    def test_closure_call_target_uses_only_precise_global_flow(self) -> None:
        def loaded(read_name_index: int) -> LoadedArtifact:
            return LoadedArtifact(
                chunk=Chunk(
                    max_stack=2,
                    constants=[
                        Constant("string", "handler"),
                        Constant("string", "missing"),
                    ],
                    protos=[Chunk(max_stack=1, instructions=[])],
                    instructions=[
                        Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
                        Instruction(Opcode.SETGLOBAL, InstructionType.ABx, 0, 0),
                        Instruction(
                            Opcode.GETGLOBAL,
                            InstructionType.ABx,
                            1,
                            read_name_index,
                        ),
                        Instruction(Opcode.CALL, InstructionType.ABC, 1, 1, 1),
                        Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                    ],
                ),
                profile={},
                profile_id="test-profile",
                accepted=True,
            )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact("positive/global.luac", loaded(0)),
                    CorpusArtifact("negative/missing-global.luac", loaded(1)),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "positive/global.luac",
                    "root",
                    "root@pc3",
                    "root@pc3:r1",
                    "handler",
                    "closure-global",
                    "positive/global.luac",
                    "root.0",
                    "bytecode-only,closure-global-target",
                )
            },
            {
                (
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
                for resolution in result.call_resolutions
                if resolution.target_prototype_id
            },
        )

    def test_resolved_closure_target_retains_reaching_name(self) -> None:
        fixture = (
            Path(__file__).resolve().parents[2]
            / "ql/test/experimental/query-tests/rules-sanitizer-report"
            / "sanitizer-on-path/input.luac"
        )
        module_path = "neutral/named-closure-sink.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        module_path,
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertIn(
            (
                module_path,
                "root@pc24",
                "os.execute",
                "closure-global",
                module_path,
                "root.0",
            ),
            {
                (
                    resolution.caller_module_path,
                    resolution.callsite_id,
                    resolution.resolved_name,
                    resolution.resolution_kind,
                    resolution.target_module_path,
                    resolution.target_prototype_id,
                )
                for resolution in result.call_resolutions
            },
        )

    def test_closure_call_target_uses_upvalue_capture_and_first_mutation(self) -> None:
        caller = Chunk(
            num_upvalues=1,
            max_stack=3,
            protos=[Chunk(max_stack=1, instructions=[])],
            instructions=[
                Instruction(Opcode.GETUPVAL, InstructionType.ABC, 0, 0, 0),
                Instruction(Opcode.CALL, InstructionType.ABC, 0, 1, 1),
                Instruction(Opcode.CLOSURE, InstructionType.ABx, 1, 0),
                Instruction(Opcode.SETUPVAL, InstructionType.ABC, 1, 0, 0),
                Instruction(Opcode.GETUPVAL, InstructionType.ABC, 2, 0, 0),
                Instruction(Opcode.CALL, InstructionType.ABC, 2, 1, 1),
                Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
            ],
        )
        loaded = LoadedArtifact(
            chunk=Chunk(
                max_stack=2,
                protos=[Chunk(max_stack=1, instructions=[]), caller],
                instructions=[
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.CLOSURE, InstructionType.ABx, 1, 1),
                    Instruction(Opcode.MOVE, InstructionType.ABC, 0, 0, 0),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("positive/upvalue.luac", loaded),)
            )
        )

        self.assertEqual(
            {
                (
                    "root.1@pc1",
                    "root.1@pc1:r0",
                    "closure-upvalue",
                    "root.0",
                    "bytecode-only,closure-upvalue-target",
                ),
                (
                    "root.1@pc5",
                    "root.1@pc5:r2",
                    "closure-upvalue",
                    "root.1.0",
                    "bytecode-only,closure-upvalue-target",
                ),
            },
            {
                (
                    resolution.callsite_id,
                    resolution.target_value_ref,
                    resolution.resolution_kind,
                    resolution.target_prototype_id,
                    resolution.provenance,
                )
                for resolution in result.call_resolutions
            },
        )

    def test_adjacent_global_call_uses_only_exact_string_name(self) -> None:
        def loaded(constants: list[Constant]) -> LoadedArtifact:
            return LoadedArtifact(
                chunk=Chunk(
                    max_stack=1,
                    constants=constants,
                    instructions=[
                        Instruction(Opcode.GETGLOBAL, InstructionType.ABx, 0, 0),
                        Instruction(Opcode.CALL, InstructionType.ABC, 0, 1, 1),
                        Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                    ],
                ),
                profile={},
                profile_id="test-profile",
                accepted=True,
            )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "positive/global-name.luac",
                        loaded([Constant("string", "handler")]),
                    ),
                    CorpusArtifact("negative/missing-name.luac", loaded([])),
                    CorpusArtifact(
                        "negative/non-string-name.luac",
                        loaded([Constant("number", 1.0)]),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "positive/global-name.luac",
                    "root",
                    "root@pc1",
                    "root@pc1:r0",
                    "handler",
                    "derived-adjacent-global-name",
                    "",
                    "",
                    "bytecode-only,derived-call-target",
                )
            },
            {
                (
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
                for resolution in result.call_resolutions
            },
        )

    def test_reaching_global_member_call_requires_exact_member_key(self) -> None:
        def loaded(member_operand: int) -> LoadedArtifact:
            return LoadedArtifact(
                chunk=Chunk(
                    max_stack=3,
                    constants=[
                        Constant("string", "os"),
                        Constant("string", "execute"),
                        Constant("string", "argument"),
                    ],
                    instructions=[
                        Instruction(Opcode.GETGLOBAL, InstructionType.ABx, 1, 0),
                        Instruction(
                            Opcode.GETTABLE,
                            InstructionType.ABC,
                            1,
                            1,
                            member_operand,
                        ),
                        Instruction(Opcode.LOADK, InstructionType.ABx, 2, 2),
                        Instruction(Opcode.CALL, InstructionType.ABC, 1, 2, 1),
                        Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                    ],
                ),
                profile={},
                profile_id="test-profile",
                accepted=True,
            )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "positive/reaching-member.luac",
                        loaded(256 + 1),
                    ),
                    CorpusArtifact("negative/dynamic-member.luac", loaded(1)),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "positive/reaching-member.luac",
                    "root@pc3",
                    "root@pc3:r1",
                    "os.execute",
                    "derived-reaching-definition-call-target",
                    "bytecode-only,derived-call-target,reaching-definition",
                )
            },
            {
                (
                    resolution.caller_module_path,
                    resolution.callsite_id,
                    resolution.target_value_ref,
                    resolution.resolved_name,
                    resolution.resolution_kind,
                    resolution.provenance,
                )
                for resolution in result.call_resolutions
            },
        )

    def test_reaching_global_member_chain_resolves_exact_name(self) -> None:
        fixture = (
            Path(__file__).resolve().parents[2]
            / "ql/test/experimental/query-tests/rules-sanitizer-report"
            / "formvalue-os-execute-chain/input.luac"
        )
        module_path = "neutral/source-sink-chain.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        module_path,
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertIn(
            (
                module_path,
                "root",
                "root@pc16",
                "root@pc16:r0",
                "luci.http.formvalue",
                "derived-reaching-definition-call-target",
                "bytecode-only,derived-call-target,reaching-definition",
            ),
            {
                (
                    resolution.caller_module_path,
                    resolution.caller_prototype_id,
                    resolution.callsite_id,
                    resolution.target_value_ref,
                    resolution.resolved_name,
                    resolution.resolution_kind,
                    resolution.provenance,
                )
                for resolution in result.call_resolutions
            },
        )
        self.assertFalse(
            any(
                boundary.site_id == "root@pc16" and
                boundary.boundary_kind == "unresolved-call-target"
                for boundary in result.boundaries
            )
        )

    def test_local_closure_call_retains_exact_debug_local_name(self) -> None:
        fixture = (
            Path(__file__).resolve().parents[2]
            / "ql/test/experimental/query-tests/rules-sanitizer-report"
            / "sanitizer-on-path/input.luac"
        )
        module_path = "neutral/local-closure-call.luac"
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        module_path,
                        Lua51Loader(fixture.read_bytes()).load(),
                    ),
                )
            )
        )

        self.assertIn(
            (
                module_path,
                "root",
                "root@pc20",
                "root@pc20:r2",
                "tonumber",
                "closure-move",
                "bytecode-only,closure-move-target",
            ),
            {
                (
                    resolution.caller_module_path,
                    resolution.caller_prototype_id,
                    resolution.callsite_id,
                    resolution.target_value_ref,
                    resolution.resolved_name,
                    resolution.resolution_kind,
                    resolution.provenance,
                )
                for resolution in result.call_resolutions
            },
        )

    def test_local_closure_call_without_debug_local_remains_unnamed(self) -> None:
        fixture = (
            Path(__file__).resolve().parents[2]
            / "ql/test/experimental/query-tests/rules-sanitizer-report"
            / "sanitizer-on-path/input.luac"
        )
        loaded = Lua51Loader(fixture.read_bytes()).load()
        assert loaded.chunk is not None
        loaded.chunk.locals = []
        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact("neutral/stripped-local.luac", loaded),
                )
            )
        )

        self.assertIn(
            (
                "root@pc20",
                "",
                "closure-move",
                "root.1",
            ),
            {
                (
                    resolution.callsite_id,
                    resolution.resolved_name,
                    resolution.resolution_kind,
                    resolution.target_prototype_id,
                )
                for resolution in result.call_resolutions
            },
        )

    def test_self_parameter_member_call_requires_exact_member_key(self) -> None:
        def loaded(member_operand: int) -> LoadedArtifact:
            return LoadedArtifact(
                chunk=Chunk(
                    num_params=1,
                    max_stack=2,
                    constants=[Constant("string", "match")],
                    instructions=[
                        Instruction(Opcode.JMP, InstructionType.AsBx, 0, 0),
                        Instruction(
                            Opcode.SELF,
                            InstructionType.ABC,
                            0,
                            0,
                            member_operand,
                        ),
                        Instruction(Opcode.CALL, InstructionType.ABC, 0, 2, 1),
                        Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                    ],
                ),
                profile={},
                profile_id="test-profile",
                accepted=True,
            )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "positive/self-parameter.luac",
                        loaded(256),
                    ),
                    CorpusArtifact("negative/dynamic-self.luac", loaded(0)),
                )
            )
        )

        self.assertEqual(
            {
                (
                    "positive/self-parameter.luac",
                    "root@pc2",
                    "root@pc2:r0",
                    "Param_0.match",
                    "derived-reaching-definition-call-target",
                    "bytecode-only,derived-call-target,reaching-definition",
                )
            },
            {
                (
                    resolution.caller_module_path,
                    resolution.callsite_id,
                    resolution.target_value_ref,
                    resolution.resolved_name,
                    resolution.resolution_kind,
                    resolution.provenance,
                )
                for resolution in result.call_resolutions
            },
        )

    def test_self_member_call_reuses_every_named_call_result(self) -> None:
        def regular_call(
            result_operand: int,
            base_register: int,
            member_operand: int = 256 + 1,
        ) -> LoadedArtifact:
            return LoadedArtifact(
                chunk=Chunk(
                    max_stack=5,
                    constants=[
                        Constant("string", "factory"),
                        Constant("string", "run"),
                    ],
                    instructions=[
                        Instruction(Opcode.GETGLOBAL, InstructionType.ABx, 0, 0),
                        Instruction(
                            Opcode.CALL,
                            InstructionType.ABC,
                            0,
                            1,
                            result_operand,
                        ),
                        Instruction(
                            Opcode.SELF,
                            InstructionType.ABC,
                            3,
                            base_register,
                            member_operand,
                        ),
                        Instruction(Opcode.CALL, InstructionType.ABC, 3, 2, 1),
                        Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                    ],
                ),
                profile={},
                profile_id="test-profile",
                accepted=True,
            )

        require_multiple_results = LoadedArtifact(
            chunk=Chunk(
                max_stack=5,
                constants=[
                    Constant("string", "require"),
                    Constant("string", "sample.module"),
                    Constant("string", "run"),
                ],
                instructions=[
                    Instruction(Opcode.GETGLOBAL, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.LOADK, InstructionType.ABx, 1, 1),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 2, 3),
                    Instruction(
                        Opcode.SELF,
                        InstructionType.ABC,
                        3,
                        1,
                        256 + 2,
                    ),
                    Instruction(Opcode.CALL, InstructionType.ABC, 3, 2, 1),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        iterator_derived_result = LoadedArtifact(
            chunk=Chunk(
                max_stack=7,
                constants=[
                    Constant("string", "factory"),
                    Constant("string", "run"),
                ],
                instructions=[
                    Instruction(Opcode.GETGLOBAL, InstructionType.ABx, 0, 0),
                    Instruction(Opcode.CALL, InstructionType.ABC, 0, 1, 4),
                    Instruction(Opcode.TFORLOOP, InstructionType.ABC, 0, 0, 2),
                    Instruction(
                        Opcode.SELF,
                        InstructionType.ABC,
                        5,
                        4,
                        256 + 1,
                    ),
                    Instruction(Opcode.CALL, InstructionType.ABC, 5, 2, 1),
                    Instruction(Opcode.RETURN, InstructionType.ABC, 0, 1, 0),
                ],
            ),
            profile={},
            profile_id="test-profile",
            accepted=True,
        )

        result = analyze_corpus(
            AcceptedCorpus(
                artifacts=(
                    CorpusArtifact(
                        "positive/single-call-result.luac",
                        regular_call(2, 0),
                    ),
                    CorpusArtifact(
                        "positive/fixed-multiple-call-results.luac",
                        regular_call(4, 1),
                    ),
                    CorpusArtifact(
                        "positive/iterator-derived-call-result.luac",
                        iterator_derived_result,
                    ),
                    CorpusArtifact(
                        "negative/unproven-open-call-results.luac",
                        regular_call(0, 2),
                    ),
                    CorpusArtifact(
                        "negative/zero-call-results.luac",
                        regular_call(1, 1),
                    ),
                    CorpusArtifact(
                        "negative/require-multiple-results.luac",
                        require_multiple_results,
                    ),
                    CorpusArtifact(
                        "negative/dynamic-call-result-member.luac",
                        regular_call(4, 1, 2),
                    ),
                )
            )
        )

        self.assertEqual(
            {
                (
                    module_path,
                    target_value_ref,
                    "factory.run",
                    "derived-reaching-definition-call-target",
                    "bytecode-only,derived-call-target,reaching-definition",
                )
                for module_path, target_value_ref in {
                    ("positive/single-call-result.luac", "root@pc3:r3"),
                    (
                        "positive/fixed-multiple-call-results.luac",
                        "root@pc3:r3",
                    ),
                    (
                        "positive/iterator-derived-call-result.luac",
                        "root@pc4:r5",
                    ),
                }
            },
            {
                (
                    resolution.caller_module_path,
                    resolution.target_value_ref,
                    resolution.resolved_name,
                    resolution.resolution_kind,
                    resolution.provenance,
                )
                for resolution in result.call_resolutions
                if resolution.callsite_id in {"root@pc3", "root@pc4"}
            },
        )


if __name__ == "__main__":
    unittest.main()
