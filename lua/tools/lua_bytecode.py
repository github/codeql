"""Lua 5.1 bytecode loading and header validation for CodeQL facts."""

from __future__ import annotations

import struct
from dataclasses import dataclass, field
from enum import IntEnum
from typing import Any


LUA_MAGIC = b"\x1bLua"
PROFILE_FIELDS = (
    "version",
    "format",
    "little_endian",
    "int_size",
    "size_t_size",
    "instruction_size",
    "lua_number_size",
    "integral_flag",
)
LUA51_VERSION = 0x51


class BytecodeError(Exception):
    diagnostic_kind = "truncated-bytecode"
    message_category = "bytecode-error"


class NotLuaBytecode(BytecodeError):
    diagnostic_kind = "not-lua-bytecode"
    message_category = "bad-magic"


class TruncatedBytecode(BytecodeError):
    diagnostic_kind = "truncated-bytecode"
    message_category = "unexpected-eof"


class UnsupportedVersion(BytecodeError):
    diagnostic_kind = "unsupported-bytecode-version"
    message_category = "unsupported-version"


class UnsupportedProfile(BytecodeError):
    diagnostic_kind = "unsupported-bytecode-profile"
    message_category = "unsupported-profile"

    def __init__(self, message: str, message_category: str = "unsupported-profile"):
        super().__init__(message)
        self.message_category = message_category


class MalformedConstant(BytecodeError):
    diagnostic_kind = "malformed-constant"
    message_category = "bad-constant"


class MalformedOpcode(BytecodeError):
    diagnostic_kind = "malformed-opcode"
    message_category = "invalid-opcode"


class InstructionType(IntEnum):
    ABC = 0
    ABx = 1
    AsBx = 2


class Opcode(IntEnum):
    MOVE = 0
    LOADK = 1
    LOADBOOL = 2
    LOADNIL = 3
    GETUPVAL = 4
    GETGLOBAL = 5
    GETTABLE = 6
    SETGLOBAL = 7
    SETUPVAL = 8
    SETTABLE = 9
    NEWTABLE = 10
    SELF = 11
    ADD = 12
    SUB = 13
    MUL = 14
    DIV = 15
    MOD = 16
    POW = 17
    UNM = 18
    NOT = 19
    LEN = 20
    CONCAT = 21
    JMP = 22
    EQ = 23
    LT = 24
    LE = 25
    TEST = 26
    TESTSET = 27
    CALL = 28
    TAILCALL = 29
    RETURN = 30
    FORLOOP = 31
    FORPREP = 32
    TFORLOOP = 33
    SETLIST = 34
    CLOSE = 35
    CLOSURE = 36
    VARARG = 37


INSTRUCTION_TYPES = {
    Opcode.MOVE: InstructionType.ABC,
    Opcode.LOADK: InstructionType.ABx,
    Opcode.LOADBOOL: InstructionType.ABC,
    Opcode.LOADNIL: InstructionType.ABC,
    Opcode.GETUPVAL: InstructionType.ABC,
    Opcode.GETGLOBAL: InstructionType.ABx,
    Opcode.GETTABLE: InstructionType.ABC,
    Opcode.SETGLOBAL: InstructionType.ABx,
    Opcode.SETUPVAL: InstructionType.ABC,
    Opcode.SETTABLE: InstructionType.ABC,
    Opcode.NEWTABLE: InstructionType.ABC,
    Opcode.SELF: InstructionType.ABC,
    Opcode.ADD: InstructionType.ABC,
    Opcode.SUB: InstructionType.ABC,
    Opcode.MUL: InstructionType.ABC,
    Opcode.DIV: InstructionType.ABC,
    Opcode.MOD: InstructionType.ABC,
    Opcode.POW: InstructionType.ABC,
    Opcode.UNM: InstructionType.ABC,
    Opcode.NOT: InstructionType.ABC,
    Opcode.LEN: InstructionType.ABC,
    Opcode.CONCAT: InstructionType.ABC,
    Opcode.JMP: InstructionType.AsBx,
    Opcode.EQ: InstructionType.ABC,
    Opcode.LT: InstructionType.ABC,
    Opcode.LE: InstructionType.ABC,
    Opcode.TEST: InstructionType.ABC,
    Opcode.TESTSET: InstructionType.ABC,
    Opcode.CALL: InstructionType.ABC,
    Opcode.TAILCALL: InstructionType.ABC,
    Opcode.RETURN: InstructionType.ABC,
    Opcode.FORLOOP: InstructionType.AsBx,
    Opcode.FORPREP: InstructionType.AsBx,
    Opcode.TFORLOOP: InstructionType.ABC,
    Opcode.SETLIST: InstructionType.ABC,
    Opcode.CLOSE: InstructionType.ABC,
    Opcode.CLOSURE: InstructionType.ABx,
    Opcode.VARARG: InstructionType.ABC,
}


class ConstType(IntEnum):
    NIL = 0
    BOOL = 1
    NUMBER = 3
    STRING = 4


@dataclass
class Instruction:
    opcode: Opcode
    op_type: InstructionType
    a: int
    b: int
    c: int = -1


@dataclass
class Constant:
    type_name: str
    value: Any

    def text(self) -> str:
        if self.value is None:
            return "nil"
        if self.type_name == "bool":
            return "true" if self.value else "false"
        return str(self.value)


@dataclass
class Local:
    name: str
    start: int
    end: int


@dataclass
class Chunk:
    name: str = ""
    first_line: int = 0
    last_line: int = 0
    num_upvalues: int = 0
    num_params: int = 0
    is_vararg: bool = False
    max_stack: int = 0
    instructions: list[Instruction] = field(default_factory=list)
    constants: list[Constant] = field(default_factory=list)
    protos: list["Chunk"] = field(default_factory=list)
    locals: list[Local] = field(default_factory=list)
    upvalues: list[str] = field(default_factory=list)


@dataclass
class LoadedArtifact:
    chunk: Chunk | None
    profile: dict[str, int]
    profile_id: str = "unavailable"
    diagnostic_kind: str | None = None
    message_category: str | None = None
    accepted: bool = False


def bits(num: int, pos: int, size: int) -> int:
    return (num >> pos) & (~((~0) << size))


def is_k(rk: int) -> bool:
    return (rk & (1 << 8)) > 0


def rk_k_index(rk: int) -> int:
    return rk & ~(1 << 8)


def profile_id_from_header(profile: dict[str, int]) -> str:
    endian = "little" if profile["little_endian"] else "big"
    number_mode = "integral" if profile["integral_flag"] else "float"
    return (
        f"lua51-{endian}-int{profile['int_size']}-size_t{profile['size_t_size']}"
        f"-instruction{profile['instruction_size']}-number{profile['lua_number_size']}-{number_mode}"
    )


def validate_implemented_header(profile: dict[str, int], *, endian_flag: int) -> None:
    if profile["format"] != 0:
        raise UnsupportedProfile(
            f"unsupported Lua 5.1 bytecode format {profile['format']}",
            "unsupported-format",
        )
    if endian_flag not in {0, 1}:
        raise UnsupportedProfile(
            f"unsupported Lua 5.1 endianness flag {endian_flag}",
            "unsupported-endianness",
        )
    if profile["int_size"] <= 0:
        raise UnsupportedProfile(
            f"unsupported Lua 5.1 int size {profile['int_size']}",
            "unsupported-int-size",
        )
    if profile["size_t_size"] <= 0:
        raise UnsupportedProfile(
            f"unsupported Lua 5.1 size_t size {profile['size_t_size']}",
            "unsupported-size_t-size",
        )
    if profile["instruction_size"] != 4:
        raise UnsupportedProfile(
            f"unsupported Lua 5.1 instruction size {profile['instruction_size']}",
            "unsupported-instruction-size",
        )
    if profile["lua_number_size"] != 8:
        raise UnsupportedProfile(
            f"unsupported Lua 5.1 lua_Number size {profile['lua_number_size']}",
            "unsupported-number-size",
        )
    if profile["integral_flag"] != 0:
        raise UnsupportedProfile(
            f"unsupported Lua 5.1 number mode integral_flag={profile['integral_flag']}",
            "unsupported-number-mode",
        )


class Lua51Loader:
    """Load one Lua 5.1 bytecode artifact using header-driven field sizes."""

    def __init__(self, data: bytes):
        self.data = data
        self.index = 0
        self.profile: dict[str, int] = {}
        self.endian_flag = 1

    def read(self, size: int) -> bytes:
        if self.index + size > len(self.data):
            raise TruncatedBytecode("unexpected end of Lua bytecode")
        out = self.data[self.index : self.index + size]
        self.index += size
        return out

    def byte(self) -> int:
        return self.read(1)[0]

    def uint(self) -> int:
        return int.from_bytes(self.read(self.profile["int_size"]), self.endian(), signed=False)

    def uint32(self) -> int:
        return int.from_bytes(self.read(4), self.endian(), signed=False)

    def size_t(self) -> int:
        return int.from_bytes(self.read(self.profile["size_t_size"]), self.endian(), signed=False)

    def number(self) -> float:
        if self.profile["lua_number_size"] != 8:
            raise UnsupportedProfile(
                "unsupported Lua 5.1 lua_Number size",
                "unsupported-number-size",
            )
        return struct.unpack("<d" if self.profile["little_endian"] else ">d", self.read(8))[0]

    def endian(self) -> str:
        return "little" if self.profile["little_endian"] else "big"

    def string(self) -> str:
        size = self.size_t()
        if size == 0:
            return ""
        raw = self.read(size)
        return raw[:-1].decode("latin-1")

    def load(self) -> LoadedArtifact:
        if len(self.data) < 4 or self.data[:4] != LUA_MAGIC:
            raise NotLuaBytecode("Lua bytecode magic expected")
        self.index = 4
        version = self.byte()
        format_byte = self.byte()
        self.endian_flag = self.byte()
        self.profile = {
            "version": version,
            "format": format_byte,
            "little_endian": 1 if self.endian_flag == 1 else 0,
            "int_size": self.byte(),
            "size_t_size": self.byte(),
            "instruction_size": self.byte(),
            "lua_number_size": self.byte(),
            "integral_flag": self.byte(),
        }
        if self.profile["version"] != LUA51_VERSION:
            raise UnsupportedVersion("unsupported Lua bytecode version")
        validate_implemented_header(self.profile, endian_flag=self.endian_flag)
        profile_id = profile_id_from_header(self.profile)
        return LoadedArtifact(self.chunk(), self.profile, profile_id=profile_id, accepted=True)

    def chunk(self) -> Chunk:
        chunk = Chunk()
        chunk.name = self.string()
        chunk.first_line = self.uint()
        chunk.last_line = self.uint()
        chunk.num_upvalues = self.byte()
        chunk.num_params = self.byte()
        chunk.is_vararg = self.byte() != 0
        chunk.max_stack = self.byte()
        for _ in range(self.uint()):
            chunk.instructions.append(self.instruction())
        for _ in range(self.uint()):
            chunk.constants.append(self.constant())
        for _ in range(self.uint()):
            chunk.protos.append(self.chunk())
        for _ in range(self.uint()):
            self.uint()
        for _ in range(self.uint()):
            chunk.locals.append(Local(self.string(), self.uint(), self.uint()))
        for _ in range(self.uint()):
            chunk.upvalues.append(self.string())
        return chunk

    def instruction(self) -> Instruction:
        raw = self.uint32()
        opcode_value = bits(raw, 0, 6)
        if opcode_value not in Opcode._value2member_map_:
            raise MalformedOpcode(f"unknown Lua opcode {opcode_value}")
        op = Opcode(opcode_value)
        op_type = INSTRUCTION_TYPES[op]
        a = bits(raw, 6, 8)
        if op_type == InstructionType.ABC:
            return Instruction(op, op_type, a, bits(raw, 23, 9), bits(raw, 14, 9))
        b = bits(raw, 14, 18)
        if op_type == InstructionType.AsBx:
            b -= 131071
        return Instruction(op, op_type, a, b)

    def constant(self) -> Constant:
        tag = self.byte()
        if tag == ConstType.NIL:
            return Constant("nil", None)
        if tag == ConstType.BOOL:
            return Constant("bool", self.byte() != 0)
        if tag == ConstType.NUMBER:
            return Constant("number", self.number())
        if tag == ConstType.STRING:
            return Constant("string", self.string())
        raise MalformedConstant(f"unknown Lua constant type {tag}")
