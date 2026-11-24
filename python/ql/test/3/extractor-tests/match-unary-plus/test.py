match value:
    case +1:
        pass
    case +1.5:
        pass
    case +2j:
        pass
    case +1+2j:
        pass
    case +1-2j:
        pass
    case +0x10 | +0o10 | +0b10:
        pass
    case [+0, -0.0]:
        pass
    case {+1: x, +1.5: y, +2j: z}:
        pass
    case -1+2j:
        pass
    case -1-2j:
        pass
