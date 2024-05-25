try:
    from future_builtins import filter
except ImportError:
    pass

from copy import deepcopy

class Meta:
    pass

###{standalone
class Tree(object):
    def __init__(self, data, children, meta=None):
        self.data = data
        self.children = children
        self._meta = meta

    @property
    def meta(self):
        if self._meta is None:
            self._meta = Meta()
        return self._meta

    def __repr__(self):
        return 'Tree(%s, %s)' % (self.data, self.children)

    def _pretty_label(self):
        return self.data

    def _pretty(self, level, indent_str):
        if len(self.children) == 1 and not isinstance(self.children[0], Tree):
            return [ indent_str*level, self._pretty_label(), '\t', '%s' % (self.children[0],), '\n']

        l = [ indent_str*level, self._pretty_label(), '\n' ]
        for n in self.children:
            if isinstance(n, Tree):
                l += n._pretty(level+1, indent_str)
            else:
                l += [ indent_str*(level+1), '%s' % (n,), '\n' ]

        return l

    def pretty(self, indent_str='  '):
        return ''.join(self._pretty(0, indent_str))
###}

    def expand_kids_by_index(self, *indices):
        "Expand (inline) children at the given indices"
        for i in sorted(indices, reverse=True): # reverse so that changing tail won't affect indices
            kid = self.children[i]
            self.children[i:i+1] = kid.children

    def __eq__(self, other):
        try:
            return self.data == other.data and self.children == other.children
        except AttributeError:
            return False

    def __ne__(self, other):
        return not (self == other)

    def __hash__(self):
        return hash((self.data, tuple(self.children)))

    def find_pred(self, pred):
        "Find all nodes where pred(tree) == True"
        return filter(pred, self.iter_subtrees())

    def find_data(self, data):
        "Find all nodes where tree.data == data"
        return self.find_pred(lambda t: t.data == data)

    def scan_values(self, pred):
        for c in self.children:
            if isinstance(c, Tree):
                for t in c.scan_values(pred):
                    yield t
            else:
                if pred(c):
                    yield c

    def iter_subtrees(self):
        # TODO: Re-write as a more efficient version

        visited = set()
        q = [self]

        l = []
        while q:
            subtree = q.pop()
            l.append( subtree )
            if id(subtree) in visited:
                continue    # already been here from another branch
            visited.add(id(subtree))
            q += [c for c in subtree.children if isinstance(c, Tree)]

        seen = set()
        for x in reversed(l):
            if id(x) not in seen:
                yield x
                seen.add(id(x))


    def __deepcopy__(self, memo):
        return type(self)(self.data, deepcopy(self.children, memo))

    def copy(self):
        return type(self)(self.data, self.children)
    def set(self, data, children):
        self.data = data
        self.children = children

    # XXX Deprecated! Here for backwards compatibility <0.6.0
    @property
    def line(self):
        return self.meta.line
    @property
    def column(self):
        return self.meta.column
    @property
    def end_line(self):
        return self.meta.end_line
    @property
    def end_column(self):
        return self.meta.end_column


class SlottedTree(Tree):
    __slots__ = 'data', 'children', 'rule', '_meta'


def pydot__tree_to_png(tree, filename):
    "Creates a colorful image that represents the tree (data+children, without meta)"

    import pydot
    graph = pydot.Dot(graph_type='digraph', rankdir="LR")

    i = [0]

    def new_leaf(leaf):
        node = pydot.Node(i[0], label=repr(leaf))
        i[0] += 1
        graph.add_node(node)
        return node

    def _to_pydot(subtree):
        color = hash(subtree.data) & 0xffffff
        color |= 0x808080

        subnodes = [_to_pydot(child) if isinstance(child, Tree) else new_leaf(child)
                    for child in subtree.children]
        node = pydot.Node(i[0], style="filled", fillcolor="#%x"%color, label=subtree.data)
        i[0] += 1
        graph.add_node(node)

        for subnode in subnodes:
            graph.add_edge(pydot.Edge(node, subnode))

        return node

    _to_pydot(tree)
    graph.write_png(filename)
