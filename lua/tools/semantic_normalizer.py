"""Normalize Lua bytecode instructions into extractor-owned semantic facts."""

from __future__ import annotations

from dataclasses import dataclass

from lua_bytecode import Chunk, Instruction, Opcode, is_k


@dataclass(frozen=True)
class RegisterEvent:
    kind: str
    slot: int


@dataclass(frozen=True)
class SemanticStep:
    source_ref: str
    dest_ref: str
    kind: str


@dataclass(frozen=True)
class ClosureValue:
    slot: int
    value_ref: str
    target_prototype_id: str
    provenance: str


@dataclass(frozen=True)
class CallSite:
    callsite_id: str
    opcode: str
    target_value_ref: str
    first_arg_slot: int
    arg_count: int
    first_return_slot: int
    return_count: int


@dataclass(frozen=True)
class InstructionSemantics:
    effects: list[RegisterEvent | SemanticStep | ClosureValue | CallSite]


class InstructionSemanticNormalizer:
    """Produce bytecode-level normalized facts, not final flow/taint results."""

    def pcslot(self, prototype_id: str, pc: int, slot: int) -> str:
        return f"{prototype_id}@pc{pc}:r{slot}"

    def normalize(self, prototype_id: str, pc: int, instr: Instruction, chunk: Chunk) -> InstructionSemantics:
        effects: list[RegisterEvent | SemanticStep | ClosureValue | CallSite] = []

        def event(kind: str, slot: int) -> None:
            effects.append(RegisterEvent(kind, slot))

        def step(src_slot: int, dst_slot: int, kind: str) -> None:
            effects.append(
                SemanticStep(
                    self.pcslot(prototype_id, pc, src_slot),
                    self.pcslot(prototype_id, pc, dst_slot),
                    kind,
                )
            )

        op = instr.opcode
        a, b, c = instr.a, instr.b, instr.c
        if op == Opcode.MOVE:
            event("read", b)
            event("write", a)
            step(b, a, "move")
        elif op == Opcode.LOADK:
            event("write", a)
        elif op == Opcode.CLOSURE:
            event("write", a)
            effects.append(ClosureValue(a, self.pcslot(prototype_id, pc, a), f"{prototype_id}.{b}", "bytecode-only"))
        elif op in (Opcode.CALL, Opcode.TAILCALL):
            arg_count = b - 1 if b > 0 else max(chunk.max_stack - (a + 1), 0)
            ret_count = c - 1 if c > 0 else -1
            event("read", a)
            for slot in range(a + 1, a + 1 + max(arg_count, 0)):
                event("read", slot)
            if ret_count == -1:
                event("write", a)
            else:
                for slot in range(a, a + ret_count):
                    event("write", slot)
            effects.append(
                CallSite(
                    f"{prototype_id}@pc{pc}",
                    op.name,
                    self.pcslot(prototype_id, pc, a),
                    a + 1,
                    arg_count,
                    a,
                    ret_count,
                )
            )
        elif op == Opcode.CONCAT:
            for slot in range(b, c + 1):
                event("read", slot)
                step(slot, a, "concat")
            event("write", a)
        elif op == Opcode.GETUPVAL:
            event("write", a)
        elif op == Opcode.GETGLOBAL:
            event("write", a)
        elif op == Opcode.SETGLOBAL:
            event("read", a)
        elif op == Opcode.GETTABLE:
            event("read", b)
            event("write", a)
        elif op == Opcode.SELF:
            event("read", b)
            event("write", a)
            event("write", a + 1)
        elif op in (Opcode.SETTABLE,):
            event("read", a)
            if not is_k(b):
                event("read", b)
            if not is_k(c):
                event("read", c)
        elif op == Opcode.NEWTABLE:
            event("write", a)
        elif op == Opcode.RETURN:
            count = b - 1 if b > 0 else max(chunk.max_stack - a, 0)
            for slot in range(a, a + count):
                event("read", slot)
        elif op in (Opcode.EQ, Opcode.LT, Opcode.LE):
            if not is_k(b):
                event("read", b)
            if not is_k(c):
                event("read", c)

        return InstructionSemantics(effects)
