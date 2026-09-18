from pathlib import Path
import sys
from tempfile import TemporaryDirectory
import unittest


TOOLS_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(TOOLS_ROOT))

from corpus_analyzer import (  # noqa: E402
    AcceptedCorpus,
    CorpusArtifact,
    analyze_corpus,
)
from index_lua_files import emit_loaded_bytecode  # noqa: E402
from lua_bytecode import (  # noqa: E402
    Chunk,
    Constant,
    Instruction,
    InstructionType,
    LoadedArtifact,
    Opcode,
)
from trap_writer import TrapWriter  # noqa: E402


class ExtractorTrapTests(unittest.TestCase):
    def test_repeated_overwrites_use_analyzer_flow_without_legacy_kill_rows(self) -> None:
        instructions: list[Instruction] = []
        for _ in range(32):
            instructions.append(
                Instruction(Opcode.LOADK, InstructionType.ABx, a=0, b=0)
            )
            instructions.append(
                Instruction(Opcode.MOVE, InstructionType.ABC, a=1, b=0, c=0)
            )
        instructions.append(
            Instruction(Opcode.RETURN, InstructionType.ABC, a=1, b=2, c=0)
        )
        loaded = LoadedArtifact(
            chunk=Chunk(
                max_stack=2,
                instructions=instructions,
                constants=[Constant("string", "value")],
            ),
            profile={
                "version": 0x51,
                "format": 0,
                "little_endian": 1,
                "int_size": 4,
                "size_t_size": 8,
                "instruction_size": 4,
                "lua_number_size": 8,
                "integral_flag": 0,
            },
            profile_id="lua51-test",
            accepted=True,
        )
        analysis = analyze_corpus(
            AcceptedCorpus(
                artifacts=(CorpusArtifact("scale/input.luac", loaded),)
            )
        )
        local_edges = {
            (flow.source_ref, flow.sink_ref)
            for flow in analysis.value_flows
            if flow.module_path == "scale/input.luac"
        }
        self.assertIn(("root@pc62:r0", "root@pc63:r0"), local_edges)
        self.assertNotIn(("root@pc60:r0", "root@pc63:r0"), local_edges)

        with TemporaryDirectory() as directory:
            temporary_root = Path(directory)
            bytecode_path = temporary_root / "input.luac"
            bytecode_path.write_bytes(b"public extractor test artifact")
            trap = TrapWriter()
            emit_loaded_bytecode(
                trap,
                bytecode_path,
                temporary_root / "source-archive",
                loaded,
                analysis.artifact_identities[0],
                analysis.value_flows,
                analysis.control_flow_edges,
                analysis.dominator_tree_intervals,
                analysis.boundaries,
                analysis.call_resolutions,
                analysis.literal_requires,
                analysis.module_resolutions,
                analysis.module_exports,
                analysis.interprocedural_flows,
                analysis.table_field_flows,
                analysis.global_flows,
                analysis.upvalue_flows,
            )

        legacy_kill_rows = [
            line for line in trap.lines if line.startswith("lua_kill_overwrites(")
        ]
        self.assertEqual(0, len(legacy_kill_rows))


if __name__ == "__main__":
    unittest.main()
