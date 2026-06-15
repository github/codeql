
import ast

from .parser import parse
from collections import defaultdict
from .compiled import SuperState, StateTransitionTable, StateActionListPair


class Transition:

    def __init__(self, from_state, to_state, what, do):
        assert isinstance(from_state, State)
        assert isinstance(to_state, State)
        self.from_state = from_state
        self.what = what
        if not do:
            do = None
        else:
            assert isinstance(do, list)
            for item in do:
                assert isinstance(item, Action)
            do = tuple(do)
        self.action = StateActionListPair.get(to_state, do)

    def dump(self):
        if self.action.actionlist:
            return "%s -> %s for %s do %s" % (
                self.from_state,
                self.action.state,
                self.what,
                "; ".join(str(do) for do in self.action.actionlist.actions)
            )
        else:
            return "%s -> %s for %s" % (
                self.from_state,
                self.action.state,
                self.what
            )

next_state_id = 1
states = {}

class State:

    def __init__(self, name):
        global next_state_id
        if name.isdigit():
            assert name == "0"
            self.id = 0
            self.name = "START"
        else:
            self.name = name
            self.id = next_state_id
            next_state_id += 1

    @staticmethod
    def get(name):
        if name not in states:
            states[name] = State(name)
        return states[name]

    @staticmethod
    def count():
        return len(states)

    def __repr__(self):
        return "state_%s(%s)" % (self.id, self.name)

    @staticmethod
    def from_id(id):
        for state in states.values():
            if state.id == id:
                return state
        raise ValueError(id)

State.get("0")
ERROR_ACTION = StateActionListPair.get(State.get("error"), None)

next_super_state_id = 0
super_states = {}

class TransitionTable:

    def __init__(self, name):
        global next_super_state_id
        self.name = name
        self.id = next_super_state_id
        next_super_state_id += 1
        self.parent = None
        self.transitions = []
        self._table = None

    def add_transition(self, trans):
        self.transitions.append(trans)

    def dump(self):
        if self.parent:
            lines = [ "TransitionTable %s(%s extends %s)" % (self.id, self.name, self.parent.name) ]
        else:
            lines = [ "TransitionTable %s(%s):" % (self.id, self.name) ]
        lines.extend("    " + t.dump() for t in self.transitions)
        return "\n".join(lines)

    @staticmethod
    def get(name, parent=None):
        if name not in super_states:
            super_states[name] = TransitionTable(name)
        return super_states[name]

    @staticmethod
    def count():
        return len(super_states)

    def get_table(self, character_classes):
        '''Returns the transition table for all states in this super-state'''
        if self._table is None:
            from_transtions = defaultdict(list)
            for t in self.transitions:
                from_transtions[t.from_state].append(t)
            self._table = { state: self.get_transition_table(state, from_transtions.get(state, ()), character_classes) for state in states.values() }
        return self._table

    def get_transition_table(self, state, transition_list, character_classes):
        table = {}
        if self.parent:
            parent_table = self.parent.get_table(character_classes)
        else:
            parent_table = None
        default = None
        for t in transition_list:
            assert state == t.from_state
            if isinstance(t.what, Any):
                default = t.action
                continue
            action = t.action
            classes = set(character_classes[c] for c in t.what)
            for cls in classes:
                if cls in table:
                    raise ValueError("Duplicate transition from %s on %s" % (state, cls))
                else:
                    table[cls] = action
        on_identifier = table.get(IDENTIFIER_CLASS, None)
        for cls in character_classes.values():
            if cls in table:
                continue
            if on_identifier and cls.is_identifier:
                table[cls] = on_identifier
            elif default:
                table[cls] = default
            elif parent_table and state in parent_table:
                table[cls] = parent_table[state][cls]
            else:
                table[cls] = ERROR_ACTION
        return StateTransitionTable(table)

    def compile(self, character_classes):
        return SuperState(self.name, self.get_table(character_classes))

class Any:

    def __repr__(self):
        return "*"

class Action:

    def __repr__(self):
        return self.__class__.__name__.lower()

class Emit(Action):

    def __init__(self, kind, text):
        assert isinstance(kind, str)
        assert kind.upper() == kind
        self.kind = kind
        self.text = text

    def __repr__(self):
        if self.text is None:
            return "emit(" + self.kind + ")"
        else:
            return "emit(%s, %r)" % (self.kind, self.text)

    def __eq__(self, other):
        return type(other) is Emit and other.kind == self.kind and other.text == self.text

    def __hash__(self):
        return 353 ^ hash(self.kind) ^ hash(self.text)

class Push(Action):

    def __init__(self, state):
        assert isinstance(state, TransitionTable)
        self.state = state

    def __repr__(self):
        return "push(%s)" % self.state.name

    def __eq__(self, other):
        return type(other) is Push and other.state == self.state

    def __hash__(self):
        return 59 ^ hash(self.state)

class EmitIndent(Action):
    pass
EMIT_INDENT = EmitIndent()

class Pop(Action):
    pass
POP = Pop()

class Pushback(Action):
    pass
PUSHBACK = Pushback()

class Mark(Action):
    pass
MARK = Mark()

class Newline(Action):
    pass
NEWLINE = Newline()

class Identifier:

    def __repr__(self):
        return "UnicodeIdentifiers()"

IDENTIFIER = Identifier()

class IdentifierContinue:

    def __repr__(self):
        return "IdentifierContinue()"

IDENTIFIER_CONTINUE = IdentifierContinue()

next_char_class_id = 0

class CharacterClass:

    def __init__(self, chars, is_identifier = None):
        global next_char_class_id
        self.chars = chars
        self.id = next_char_class_id
        next_char_class_id += 1
        if is_identifier is None:
            self.is_identifier = chars.copy().pop().isidentifier()
        else:
            self.is_identifier = is_identifier

    def __repr__(self):
        if self == IDENTIFIER_CLASS:
            return "IDENTIFIER_CLASS(%d)" % self.id
        elif self == ERROR_CLASS:
            return "ERROR_CLASS(%d)" % self.id
        else:
            return "CharacterClass %s %r" % (self.id, sorted(self.chars))

ERROR_CLASS = CharacterClass(set(), False)
assert ERROR_CLASS.id == 0
IDENTIFIER_CLASS = CharacterClass(set(), True)
IDENTIFIER_CONTINUE_CLASS = CharacterClass(set(), False)

class Machine:

    def __init__(self):
        self.aliases = {}
        self.states = {}
        self.aliases["IDENTIFIER"] = IDENTIFIER
        self.aliases["IDENTIFIER_CONTINUE"] = IDENTIFIER_CONTINUE
        self.aliases['SPACE'] = {' '}
        self.start = None

    def add_state(self, name):
        assert name not in self.states
        result = TransitionTable.get(name)
        self.states[name] = result
        return result

    def add_alias(self, name, choices):
        assert name not in self.aliases
        assert isinstance(choices, set), choices
        self.aliases[name] = choices

    def dump(self):
        r = []
        a = r.append
        a("Starting super-state: %s" % self.start.name)
        a("")
        a("Aliases:")
        for name_alias in self.aliases.items():
            a("   %s = %r" % name_alias)
        a("")
        for name, state in self.states.items():
            a(state.dump())
        return "\n".join(r)

    @staticmethod
    def load(src):
        tree = parse(src)
        m = Machine()
        w = Walker(m)
        w.visit(tree)
        return m

    def get_classes(self):
        '''Get the character classes for this machine'''
        #There are two predefined classes: Unicode identifiers, and ERROR.
        #A character class is a set of characters, such that the transitions
        #and actions of the machine are identical for all characters in that class.
        char_to_transitions = defaultdict(set)
        for s in self.states.values():
            for t in s.transitions:
                w = t.what
                if isinstance(w, Any):
                    continue
                for c in w:
                    if c is IDENTIFIER or c is IDENTIFIER_CONTINUE:
                        continue
                    char_to_transitions[c].add((s, t.from_state, t.action))
        equivalence_sets = defaultdict(set)
        for c, transition_set in sorted(char_to_transitions.items()):
            equivalence_sets[frozenset(transition_set)].add(c)
        classes = {}
        for char_set in sorted(equivalence_sets.values()):
            charcls = CharacterClass(char_set)
            for c in char_set:
                classes[c] = charcls
        classes[IDENTIFIER] = IDENTIFIER_CLASS
        classes[IDENTIFIER_CONTINUE] = IDENTIFIER_CONTINUE_CLASS
        for i in range(128):
            c = chr(i)
            if c not in classes:
                if c.isidentifier():
                    classes[c] = IDENTIFIER_CLASS
                elif c in "0123456789":
                    classes[c] = IDENTIFIER_CONTINUE_CLASS
                else:
                    classes[c] = ERROR_CLASS
        for cls in classes.values():
            if cls is IDENTIFIER_CLASS or cls is IDENTIFIER_CONTINUE_CLASS or cls is ERROR_CLASS:
                continue
            assert { c for c in cls.chars if c.isidentifier() } == cls.chars or not { c for c in cls.chars if c.isidentifier() }
        return classes

class Walker:

    def __init__(self, machine):
        self.machine = machine

    def visit(self, node):
        if hasattr(node, "type"):
            tag = node.type
        else:
            tag = node.data
        meth = getattr(self, "visit_" + tag, None)
        if meth is None:
            self.fail(node, tag)
        else:
            return meth(node)

    def fail(self, node, tag):
        print(node)
        raise NotImplementedError(tag)

    def visit_first_child(self, node):
        assert len(node.children) == 1
        return self.visit(node.children[0])

    def visit_children(self, node):
        return [ self.visit(child) for child in node.children ]

    visit_start = visit_first_child
    visit_machine = visit_children
    visit_declaration = visit_first_child

    def visit_alias_decl(self, node):
        assert len(node.children) == 2
        choice = self.visit(node.children[1])
        self.machine.add_alias(node.children[0].value, choice)

    def visit_alias(self, node):
        return self.machine.aliases[node.children[0].value]

    def visit_char(self, node):
        c = ast.literal_eval(node.children[0].value)
        assert isinstance(c, str), c
        assert len(c) == 1, c
        return c

    def visit_choice(self, node):
        #Convert choices into a set of characters
        result = set()
        for child in node.children:
            item = self.visit(child)
            if isinstance(item, set):
                result.update(item)
            else:
                result.add(item)
        return result

    visit_item = visit_first_child

    def visit_table_decl(self, node):
        self.current_state = self.visit(node.children[0])
        for transition in node.children[1:]:
            self.visit(transition)

    def visit_table_header(self, node):
        name = node.children[0].value
        state = self.machine.add_state(name)
        if len(node.children) > 1:
            base = TransitionTable.get(node.children[1].value)
            state.parent = base
        return state

    def visit_transition(self, node):
        # state_choice "->" state "for" (choice | "*") action_list?
        from_states = self.visit(node.children[0])
        to_state = self.visit(node.children[1])
        what = self.visit(node.children[2])
        if len(node.children) > 3:
            do = self.visit(node.children[3])
        else:
            do = []
        for state in from_states:
            trans = Transition(state, to_state, what, do)
            self.current_state.add_transition(trans)

    visit_state_choice = visit_children

    def visit_state(self, node):
        return State.get(node.children[0].value)

    def visit_any(self, node):
        return Any()

    visit_action_list = visit_children
    visit_action = visit_first_child

    def visit_emit(self, node):
        if len(node.children) == 2:
            return Emit(node.children[0].value, self.visit(node.children[1]))
        else:
            return Emit(node.children[0].value, None)

    def visit_optional_text(self, node):
        return node.children[0].value

    def visit_push(self, node):
        state = TransitionTable.get(node.children[0].value)
        return Push(state)

    def visit_emit_indent(self, node):
        return EMIT_INDENT

    def visit_pushback(self, node):
        return PUSHBACK

    def visit_pop(self, node):
        return POP

    def visit_mark(self, node):
        return MARK

    def visit_newline(self, node):
        return NEWLINE

    def visit_start_decl(self, node):
        self.machine.start = TransitionTable.get(node.children[0].value)


def main():
    import sys
    file = sys.argv[1]
    with open(file) as fd:
        tree = parse(fd.read())
    m = Machine()
    w = Walker(m)
    w.visit(tree)
    print(m.dump())

if __name__ == "__main__":
    main()
