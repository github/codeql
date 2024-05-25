'''
Generate a state-machine based tokenizer from a state transition description and a template.

Parses the state transition description to compute a set of transition tables.
Each table maps (state, character-class) pairs to (state, action) pairs.
During tokenization each input character is converted to a class, then a new state and action is
looked up using the current state and character-class.

The generated tables are:
    CLASS_TABLE:
        Maps ASCII code points to character class.
    ID_TABLE:
        Maps all unicode points to one of Identifier, Identifier-continuation, or other.
    The transition tables:
        Each table maps each state to a per-class transition table.
        Each per-class transition table maps each character-class to an index in the action table.
    ACTION_TABLE:
        Embedded in code as `action_table`; maps each index to a (state, action) pair.

Since the number of character-classes, states and (state, action) pairs is small. Everything is represented as
a byte and tables as `bytes` object for Python 3, or `array.array` objects for Python 2.
'''


from .parser import parse
from . import machine
from .compiled import StateActionListPair, IdentifierTable

def emit_id_bytes(id_table):
    chunks, index = id_table.as_two_level_table()
    print("# %d entries in ID index" % len(index))
    index_bytes = bytes(index)
    print("ID_INDEX = toarray(")
    for n in range(0, len(index_bytes), 32):
        print("    %r" % index_bytes[n:n+32])
    print(")")
    print("ID_CHUNKS = (")
    for chunk in chunks:
        print("    toarray(%r)," % chunk)
    print(")")

def emit_transition_table(table, verbose=False):
    print("%s = (" % table.name.upper(), end="")
    for trans in table.as_list_of_transitions():
        print("B%02d," % trans.id, end=" ")
    print(")")

emitted_rows = set()

def emit_rows(table):
    for trans in table.as_list_of_transitions():
        id = trans.id
        if id in emitted_rows:
            continue
        emitted_rows.add(id)
        print("B%02d = toarray(%r)" % (id, trans.as_bytes()))

action_names = {}
next_action_id = 0

def get_action_id(action):
    global next_action_id
    assert action is not None
    if action in action_names:
        return action_names[action]
    result = next_action_id
    next_action_id += 1
    action_names[action] = result
    return result

def emit_actions(table, indent=""):
    for pair in table:
        if pair.actionlist is None:
            continue
        action = pair.actionlist
        get_action_function(action, indent)

def generate_action_table(table, indent):
    result = []
    result.append(indent + "action_table = [\n    " + indent)
    for i, pair in enumerate(table):
        if pair.actionlist is None:
            result.append("(%d, None), " % pair.state.id)
        else:
            result.append("(%d, self.action_%s), " % (pair.state.id, pair.actionlist.id))
        if (i & 3) == 3:
            result.append("\n    " + indent)
    result.append("\n" + indent + "]")
    return "".join(result)

action_functions = set()

def get_action_function(actionlist, indent=""):
    if actionlist in action_functions:
        return
    action_functions.add(actionlist)
    last = actionlist.actions[-1]
    print(indent + "def action_%d(self):" % actionlist.id)
    emit = False
    for action in actionlist.actions:
        if action is machine.PUSHBACK:
            print(indent + "    self.index -= 1")
            continue
        elif action is machine.POP:
            print(indent + "    self.super_state = self.state_stack.pop()")
        elif isinstance(action, machine.Push):
            print(indent + "    self.state_stack.append(self.super_state)")
            print(indent + "    self.super_state = %s" % action.state.name.upper())
        elif action is machine.MARK:
            print(indent + "    self.token_start_index = self.index")
            print(indent + "    self.token_start = self.line, self.index-self.line_start_index")
        elif isinstance(action, machine.Emit):
            emit = True
            print(indent + "    end = self.line, self.index-self.line_start_index+1")
            if action.text is None:
                print(indent + "    result = [%s, self.text[self.token_start_index:self.index+1], self.token_start, end]" % action.kind)
            else:
                print(indent + "    result = [%s, u%s, (self.line, self.index-self.line_start_index), end]" % (action.kind, action.text))
            print(indent + "    self.token_start = end")
            print(indent + "    self.token_start_index = self.index+1")
        elif action is machine.NEWLINE:
            print(indent + "    self.line_start_index = self.index+1")
            print(indent + "    self.line += 1")
        elif action is machine.EMIT_INDENT:
            assert action is last
            print(indent + "    return self.emit_indent()")
            print()
            return
        else:
            assert False, "Unexpected action: %s" % action
    print(indent + "    self.index += 1")
    if emit:
        print(indent + "    return result")
    else:
        print(indent + "    return None")
    print()
    return

def emit_char_classes(char_classes, verbose=False):
    for cls in sorted(set(char_classes.values()), key=lambda x : x.id):
        print("#%d = %r" % (cls.id, cls))
    table = [None] * 128
    by_id = {
        machine.IDENTIFIER_CLASS.id : machine.IDENTIFIER_CLASS,
        machine.IDENTIFIER_CONTINUE_CLASS.id : machine.IDENTIFIER_CONTINUE_CLASS,
        machine.ERROR_CLASS.id : machine.ERROR_CLASS
    }
    for c, cls in char_classes.items():
        by_id[cls.id] = cls
        if c is machine.IDENTIFIER or c is machine.IDENTIFIER_CONTINUE:
            continue
        table[ord(c)] = cls.id
        by_id[cls.id] = cls
    for i in range(128):
        assert table[i] is not None
    bytes_table = bytes(table)
    if verbose:
        print("# Class Table")
        for i in range(len(bytes_table)):
            b = bytes_table[i]
            print("# %r -> %s" % (chr(i), by_id[b]))
    print("CLASS_TABLE = toarray(%r)" % bytes_table)



PREFACE = """
import codecs
import re
import sys

from blib2to3.pgen2.token import *

if sys.version < '3':
    from array import array
    def toarray(b):
        return array('B', b)
else:
    def toarray(b):
        return b
"""

def main():
    verbose = False
    import sys
    if len(sys.argv) != 3:
        print("Usage %s DESCRIPTION TEMPLATE" % sys.argv[0])
        sys.exit(1)
    descriptionfile = sys.argv[1]
    with open(descriptionfile) as fd:
        m = machine.Machine.load(fd.read())
    templatefile = sys.argv[2]
    with open(templatefile) as fd:
        template = fd.read()
    print("# This file is AUTO-GENERATED. DO NOT MODIFY")
    print('# To regenerate: run "python3 -m tokenizer_generator.gen_state_machine %s %s"' % (descriptionfile, templatefile))
    print(PREFACE)
    print("IDENTIFIER_CLASS = %d" % machine.IDENTIFIER_CLASS.id)
    print("IDENTIFIER_CONTINUE_CLASS = %d" % machine.IDENTIFIER_CONTINUE_CLASS.id)
    print("ERROR_CLASS = %d" % machine.ERROR_CLASS.id)
    emit_id_bytes(IdentifierTable())
    char_classes = m.get_classes()
    emit_char_classes(char_classes, verbose)
    print()
    tables = [state.compile(char_classes) for state in m.states.values() ]
    for table in tables:
        emit_rows(table)
    print()
    for table in tables:
        #pprint(table)
        emit_transition_table(table, verbose)
    print()
    print("TRANSITION_STATE_NAMES = {")
    for state in m.states.values():
        print("    id(%s): '%s'," % (state.name.upper(), state.name))
    print("}")
    print("START_SUPER_STATE = %s" % m.start.name.upper())
    prefix, suffix = template.split("#ACTIONS-HERE")
    print(prefix)
    actions = StateActionListPair.listall()
    emit_actions(actions, "    ")
    action_table = generate_action_table(actions, "        ")
    print(suffix.replace("#ACTION_TABLE_HERE", action_table))

if __name__ == "__main__":
    main()
