
import unicodedata
from . import machine

class SuperState:

    def __init__(self, name, mapping):
        self.name = name
        self.mapping = mapping

    def as_list_of_bytes(self):
        lst = dict_to_list(self.mapping)
        return [ table.as_bytes() for table in lst ]

    def as_list_of_transitions(self):
        return dict_to_list(self.mapping)

action_id = 0
all_actions = {}

class ActionList:

    def __init__(self, actions, id):
        self.actions = actions
        self.id = id

    @staticmethod
    def get(actions):
        global action_id
        assert isinstance(actions, tuple)
        if actions not in all_actions:
            all_actions[actions] = ActionList(actions, action_id)
            action_id += 1
        return all_actions[actions]

    @staticmethod
    def listall():
        return sorted(all_actions.values(), key = lambda al: al.id)

next_pair_id = 0
pairs = {}

class StateActionListPair:

    def __init__(self, state, actionlist, id):
        self.state = state
        self.actionlist = actionlist
        self.id = id

    @staticmethod
    def get(state, actionlist):
        global next_pair_id
        if actionlist is not None and not isinstance(actionlist, ActionList):
            actionlist = ActionList.get(actionlist)
        if (state, actionlist) not in pairs:
            pairs[(state, actionlist)] = StateActionListPair(state, actionlist, next_pair_id)
            next_pair_id += 1
        return pairs[(state, actionlist)]

    @staticmethod
    def listall():
        return sorted(pairs.values(), key = lambda pair: pair.id)

next_table_id = 0
table_ids = {}

class StateTransitionTable:

    def __init__(self, mapping):
        self.mapping = mapping

    def as_bytes(self):
        lst = dict_to_list(self.mapping)
        return bytes(pair.id for pair in lst)

    def __getitem__(self, key):
        return self.mapping[key]

    @property
    def id(self):
        global next_table_id
        b = self.as_bytes()
        if not b in table_ids:
            table_ids[b] = next_table_id
            next_table_id += 1
        return table_ids[b]

def dict_to_list(mapping):
    assert isinstance(mapping, dict)
    result = []
    for key, value in mapping.items():
        while key.id >= len(result):
            result.append(None)
        result[key.id] = value
    return result


#Each character is one of id-start, id-continuation or other. Represent "other" as ERROR for all non-ascii characters.
#See https://www.python.org/dev/peps/pep-3131 for an explanation of what is an identifier.
OTHER_START = {0x1885, 0x1886, 0x2118, 0x212E, 0x309B, 0x309C}
OTHER_CONTINUE = {0x00B7, 0x0387, 0x19DA}
OTHER_CONTINUE.update(range(0x1369, 0x1372))
ID_CATEGORIES = {"Lu", "Ll", "Lt", "Lm", "Lo", "Nl"}
CONT_CATEGORIES = {"Mn", "Mc", "Nd", "Pc"}

CHUNK_SIZE = 64

class IdentifierTable:

    def __init__(self):
        classes = []
        for i in range(0x110000):
            try:
                c = chr(i)
            except:
                continue
            cat = unicodedata.category(c)
            if cat in ID_CATEGORIES or i in OTHER_START:
                cls = machine.IDENTIFIER_CLASS.id
            elif cat in CONT_CATEGORIES or i in OTHER_CONTINUE:
                cls = machine.IDENTIFIER_CONTINUE_CLASS.id
            else:
                cls = machine.ERROR_CLASS.id
            assert cls in (0,1,2,3)
            classes.append(cls)
        result = []
        for i, cls in enumerate(classes):
            byte, bits = i>>2, cls<<((i&3)*2)
            while byte >= len(result):
                result.append(0)
            result[byte] |= bits
        while result[-1] == 0:
            result.pop()
        while len(result) % CHUNK_SIZE:
            result.append(0)
        self.table = result

    def as_bytes(self):
        return bytes(self.table)

    def as_two_level_table(self):
        index = []
        chunks = {}
        next_id = 0
        the_bytes = self.as_bytes()
        for n in range(0, len(the_bytes), CHUNK_SIZE):
            chunk = the_bytes[n:n+CHUNK_SIZE]
            if chunk in chunks:
                index.append(chunks[chunk])
            else:
                index.append(next_id)
                chunks[chunk] = next_id
                next_id += 1
        chunks = [ chunk for (i, chunk) in sorted((i, chunk) for chunk, i in chunks.items())]
        return chunks, index
