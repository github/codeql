'''Meta nodes for defining database relations'''

from abc import abstractmethod

from semmle.util import fprintf

PREFIX = 'py_'

__all__ = [ 'order' ]


parent_nodes = {}

class Node(object):
    'Node in the attribute tree, describing relations'

    next_id = 0

    def __init__(self):
        Node.next_id += 1
        self._index = Node.next_id
        self._unique_parent = None

    @property
    def parents(self):
        return parent_of(self)

    def add_child(self, child):
        child.add_parent(self)

    def db_key(self, name):
        return 'unique int ' + name + ' : ' + self.db_name()

    def is_sub_type(self):
        return False

    @staticmethod
    def is_union_type():
        return False

    def is_case_type(self):
        return False

    @staticmethod
    def is_list():
        return False

    @staticmethod
    def is_primitive():
        return False

    def prune(self, node_set):
        return self

    @abstractmethod
    def child_offsets(self, n):
        pass

    @abstractmethod
    def write_fields(self, out):
        pass

    @abstractmethod
    def ql_name(self):
        pass

    @property
    def unique_parent(self):
        if self._unique_parent is None:
            parents = self.parents
            if len(parents.child_offsets(self)) < 2:
                self._unique_parent = True
            elif parents.is_union_type():
                self._unique_parent = False
                for t in parents.types:
                    if len(t.child_offsets(self)) > 1:
                        break
                else:
                    self._unique_parent = True
        return self._unique_parent


class PrimitiveNode(Node):
    'A primitive node: int, str, etc'

    def __init__(self, name, db_name, key, descriptive_name = None):
        Node.__init__(self)
        assert isinstance(name, str)
        self.name = name
        self.super_type = None
        self.layout = []
        self.fields = []
        self.subclasses = set()
        self._key = key
        self._db_name = db_name
        if descriptive_name is None:
            self.descriptive_name = self.name
        else:
            self.descriptive_name = descriptive_name

    def db_key(self, name):
        return self._key + ' ' + name + ' : ' + self._db_name + ' ref'

    @property
    def __name__(self):
        return self.name

    def ql_name(self):
        'Return Java style name if a schema type, otherwise the specified name'
        if self._db_name[0] == '@':
            return capitalize(self.name)
        else:
            return self._db_name

    def relation_name(self):
        return pluralize(PREFIX + self.name)

    def db_name(self):
        return self._db_name

    def add_parent(self, p):
        parent_nodes[self] = UnionNode.join(parent_of(self), p)

    def fixup(self):
        pass

    @staticmethod
    def is_primitive():
        return True

    def child_offsets(self, n):
        return set()

    def write_init(self, out):
        fprintf(out, "%s = PrimitiveNode(%s, %s, %s)\n", self.name,
                self.name, self._db_name, self._key)

    def write_fields(self, out):
        pass


def parent_of(node):
    if node in parent_nodes:
        return parent_nodes[node]
    else:
        return None

class ClassNode(Node):
    'A node corresponding to a single AST type'

    def __init__(self, name, super_type = None, descriptive_name = None):
        Node.__init__(self)
        assert isinstance(name, str)
        self.name = name
        self._db_name = name
        self.super_type = super_type
        self.layout = []
        if super_type:
            self.fields = list(super_type.fields)
        else:
            self.fields = []
        self.subclasses = set()
        if super_type:
            super_type.subclasses.add(self)
        if descriptive_name is None:
            self.descriptive_name = self.name.lower()
        else:
            self.descriptive_name = descriptive_name
        if self.descriptive_name[0] == '$':
            self.descriptive_name = self.descriptive_name[1:]
        elif super_type and ' ' not in self.descriptive_name:
            self.descriptive_name += ' ' + super_type.descriptive_name

    def field(self, name, field_type, descriptive_name = None, artificial=False, parser_type = None):
        if descriptive_name is None:
            self.fields.append((name, field_type, name, artificial, parser_type))
        else:
            self.fields.append((name, field_type, descriptive_name, artificial, parser_type))

    def is_stmt_or_expr_subclass(self):
        if self.super_type is None:
            return False
        return self.super_type.name in ('expr', 'stmt')

    def is_sub_type(self):
        if self.super_type is None:
            return False
        return self.super_type.is_case_type()

    def is_case_type(self):
        return (self.subclasses
                and parent_of(self))

    def fixup(self):
        self.add_children()
        self.compute_layout()

    def add_parent(self, p):
        parent_nodes[self] = UnionNode.join(parent_of(self), p)
        if self.super_type:
            self.super_type.add_parent(p)

    def add_children(self):
        for f, f_node, _, _, _ in self.fields:
             self.add_child(f_node)

    def compute_layout(self):
        fields = self.fields
        lists = 0
        for f, f_node, _, _, _ in fields:
            if (isinstance(f_node, ListNode) and
                f_node.item_type.__name__ != 'stmt'):
                lists += 1
        index = 0
        inc = 1
        for f, f_node, docname, artificial, pt in fields:
            self.layout.append((f, f_node, index, docname, artificial, pt))
            index += inc

    def relation_name(self):
        return pluralize(PREFIX + self._db_name)

    def set_name(self, name):
        self._db_name = name

    @property
    def __name__(self):
        return self.name

    def ql_name(self):
        if self._db_name == 'str':
            return 'string'
        elif self._db_name in ('int', 'float'):
            return self.db_name
        name = self._db_name
        return ''.join(capitalize(part) for part in name.split('_'))

    def db_name(self):
        return '@' + PREFIX + self._db_name

    def dump(self, out):
        def yes_no(b):
            return "yes" if b else "no"
        fprintf(out, "'%s' :\n", self.name)
        fprintf(out, "   QL name: %s\n", self.ql_name())
        fprintf(out, "   Relation name: %s\n", self.relation_name())
        fprintf(out, "   Is case_type %s\n", yes_no(self.is_case_type()))
        fprintf(out, "   Super type: %s\n", self.super_type)
        fprintf(out, "   Layout:\n")
        for l in self.layout:
            fprintf(out, "       %s, %s, %s, '%s, %s'\n" % l)
        fprintf(out, "   Parents: %s\n\n", parent_of(self))

    def write_init(self, out):
        if self.super_type:
            fprintf(out, "%s = ClassNode('%s', %s)\n", self.name,
                    self.name, self.super_type.name)
        else:
            fprintf(out, "%s = ClassNode('%s')\n", self.name, self.name)

    def write_fields(self, out):
        for name, field_type, docname, _, _ in self.fields:
            fprintf(out, "%s.field('%s', %s, '%s')\n", self.name,
                    name, field_type.__name__, docname)
        if self.layout:
            fprintf(out, "\n")

    def __repr__(self):
        return "Node('%s')" % self.name

    def child_offsets(self, n):
        #Only used by db-scheme generator, so can be slow
        found = set()
        for name, node, offset, _, artificial, _ in self.layout:
            if node is n:
                found.add(offset)
        if self.subclasses:
            for s in self.subclasses:
                found.update(s.child_offsets(n))
        return found

class ListNode(Node):
    "Node corresponding to a list, parameterized by its member's type"

    def __init__(self, item_node, name=None):
        Node.__init__(self)
        self.list_type = None
        self.layout = ()
        self.super_type = None
        self.item_type = item_node
        self.subclasses = ()
        self.add_child(item_node)
        self.name = name

    def relation_name(self):
        return pluralize(PREFIX + self.__name__)

    def dump(self, out):
        fprintf(out, "List of %s\n", self.name)
        fprintf(out, "   Parents: %s\n\n", parent_of(self))

    def write_init(self, out):
        fprintf(out, "%s = ListNode(%s)\n",
                self.__name__, self.item_type.__name__)

    def write_fields(self, out):
        pass

    @staticmethod
    def is_list():
        return True

    @property
    def __name__(self):
        if self.name is None:
            assert isinstance(self.item_type.__name__, str)
            return self.item_type.__name__ + '_list'
        else:
            return self.name

    @property
    def descriptive_name(self):
        return self.item_type.descriptive_name + ' list'

    def db_name(self):
        return '@' + PREFIX + self.__name__

    def ql_name(self):
        if self.name is not None:
            return capitalize(self.name)
        if self.item_type is str:
            return 'StringList'
        elif self.item_type is int:
            return 'IntList'
        elif self.item_type is float:
            return 'FloatList'
        return capitalize(self.item_type.ql_name()) + 'List'

    def __repr__(self):
        return "ListNode(%s)" % self.__name__

    def fixup(self):
        pass

    def add_parent(self, p):
        parent_nodes[self] = UnionNode.join(parent_of(self), p)

    def child_offsets(self, n):
        return set((0,1,2,3))

_all_unions = {}

class UnionNode(Node):
    'Node representing a set of AST types'

    def __init__(self, *types):
        Node.__init__(self)
        assert len(types) > 1
        self.types = frozenset(types)
        self.name = None
        self.super_type = None
        self.layout = []
        self.subclasses = ()
        #Whether this node should be visited in auto-generated extractor.
        self.visit = False

    @staticmethod
    def join(t1, t2):
        if t1 is None:
            return t2
        if t2 is None:
            return t1
        if isinstance(t1, UnionNode):
            all_types = set(t1.types)
        else:
            all_types = set([t1])
        if isinstance(t2, UnionNode):
            all_types = all_types.union(t2.types)
        else:
            all_types.add(t2)
        done = False
        while not done:
            for n in all_types:
                if n.super_type in all_types:
                    all_types.remove(n)
                    break
            else:
                done = True
        return UnionNode._make_union(all_types)

    @staticmethod
    def _make_union(all_types):
        if len(all_types) == 1:
            return next(iter(all_types))
        else:
            key = frozenset(all_types)
            if key in _all_unions:
                u = _all_unions[key]
            else:
                u = UnionNode(*all_types)
                _all_unions[key] = u
            return u

    def set_name(self, name):
        self.name = name

    @staticmethod
    def is_union_type():
        return True

    def write_init(self, out):
        fprintf(out, "%s = UnionNode(%s)\n", self.__name__,
                ', '.join(t.__name__ for t in self.types))
        if self.name:
            fprintf(out, "%s.setname('%s')\n", self.name, self.name)

    def write_fields(self, out):
        pass

    def fixup(self):
        pass

    def __hash__(self):
        return hash(self.types)

    def __eq__(self, other):
        assert len(self.types) > 1
        if isinstance(other, UnionNode):
            return self.types == other.types
        else:
            return False

    def __ne__(self, other):
        return not self.__eq__(other)

    @property
    def __name__(self):
        if self.name is None:
            names = [ n.__name__ for n in self.types ]
            return '_or_'.join(sorted(names))
        else:
            return self.name

    @property
    def descriptive_name(self):
        if self.name is None:
            names = [ n.descriptive_name for n in self.types ]
            return '_or_'.join(sorted(names))
        else:
            return self.name

    def db_name(self):
        return '@' + PREFIX + self.__name__

    def relation_name(self):
        return pluralize(PREFIX + self.__name__)

    def ql_name(self):
        if self.name is None:
            assert len(self.types) > 1
            names = [ n.ql_name() for n in self.types ]
            return 'Or'.join(sorted(names))
        else:

            return ''.join(capitalize(part) for part in self.name.split('_'))

    def add_parent(self, p):
        for n in self.types:
            n.add_parent(p)

    def child_offsets(self, n):
        res = set()
        for t in self.types:
            res = res.union(t.child_offsets(n))
        return res

    def prune(self, node_set):
        new_set = self.types.intersection(node_set)
        if len(new_set) == len(self.types):
            return self
        if not new_set:
            return None
        return UnionNode._make_union(new_set)

def shorten_name(node):
    p = parent_of(node)
    if (isinstance(p, UnionNode) and len(p.__name__) > 16
        and len(p.__name__) > len(node.__name__) + 4):
        p.set_name(node.__name__ + '_parent')


def build_node_relations(nodes):
    nodes = set(nodes)
    for node in nodes:
        node.fixup()
    for node in sorted(nodes, key=lambda n : n.__name__):
        shorten_name(node)
    node_set = set(nodes)
    for node in (str, int, float, bytes):
        p = parent_of(node)
        if p is not None:
            node_set.add(p)
    for node in nodes:
        p = parent_of(node)
        if p is not None:
            node_set.add(p)
    for n in nodes:
        sub_types = sorted(n.subclasses, key = lambda x : x._index)
        if n.is_case_type():
            for index, item in enumerate(sub_types):
                item.index = index
    for n in list(nodes):
        if not n.parents and n.is_list()  and n.name is None:
            #Discard lists with no parents and no name as unreachable
            node_set.remove(n)
    #Prune unused nodes from unions.
    node_set = set(node.prune(node_set) for node in node_set)
    for node in node_set:
        if node in parent_nodes:
            parent_nodes[node] = parent_nodes[node].prune(node_set)
    for node in node_set:
        shorten_name(node)
    result_nodes = {}
    for n in node_set:
        if n:
            result_nodes[n.__name__] = n
    return result_nodes

def pluralize(name):
    if name[-1] == 's':
        if name[-2] in 'aiuos':
            return name + 'es'
        else:
            #Already plural
            return name
    elif name.endswith('ex'):
        return name[:-2] + 'ices'
    elif name.endswith('y'):
        return name[:-1] + 'ies'
    else:
        return name + 's'

def capitalize(name):
    'Unlike the str method capitalize(), leave upper case letters alone'
    return name[0].upper() + name[1:]

def order(node):
    if node.is_primitive():
        return 0
    if isinstance(node, ClassNode):
        res = 1
        while node.super_type:
            node = node.super_type
            res += 1
        return res
    if isinstance(node, ListNode):
        return order(node.item_type) + 1
    else:
        assert isinstance(node, UnionNode)
        return max(order(t) for t in node.types)+1
