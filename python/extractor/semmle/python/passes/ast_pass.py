
from semmle.python import ast
import semmle.python.master
import sys
from semmle.python.passes._pass import Pass
from semmle.util import get_analysis_major_version

__all__ = [ 'ASTPass' ]

class ASTPass(Pass):
    '''Extract relations from AST.
       Use AST.Node objects to guide _walking of AST'''

    name = "ast"

    def __init__(self):
        self.offsets = get_offset_table()

    #Entry point
    def extract(self, root, writer):
        try:
            self.writer = writer
            if root is None:
                return
            self._emit_variable(ast.Variable("__name__", root))
            self._emit_variable(ast.Variable("__package__", root))
            # Introduce special variable "$" for use by the points-to library.
            self._emit_variable(ast.Variable("$", root))
            writer.write_tuple(u'py_extracted_version', 'gs', root.trap_name, get_analysis_major_version())
            self._walk(root, None, 0, root, None)
        finally:
            self.writer = None

    #Tree _walkers

    def _get_walker(self, node):
        if isinstance(node, list):
            return self._walk_list
        elif isinstance(node, ast.AstBase):
            return self._walk_node
        else:
            return self._emit_primitive

    def _walk(self, node, parent, index, scope, description):
        self._get_walker(node)(node, parent, index, scope, description)

    def _walk_node(self, node, parent, index, scope, _unused):
        self._emit_node(node, parent, index, scope)
        if type(node) is ast.Name:
            assert (hasattr(node, 'variable') and
                    type(node.variable) is ast.Variable), (node, parent, index, scope)
        if type(node) in (ast.Class, ast.Function):
            scope = node
        # For scopes with a `from ... import *` statement introduce special variable "*" for use by the points-to library.
        if isinstance(node, ast.ImportFrom):
            self._emit_variable(ast.Variable("*", scope))
        for field_name, desc, child_node in iter_fields(node):
            try:
                index = self.offsets[(type(node).__name__, field_name)]
                self._walk(child_node, node, index, scope, desc)
            except ConsistencyError:
                ex = sys.exc_info()[1]
                ex.message += ' in ' + type(node).__name__
                if hasattr(node, 'rewritten') and node.rewritten:
                    ex.message += '(rewritten)'
                ex.message += '.' + field_name
                raise

    def _walk_list(self, node, parent, index, scope, description):
        assert description.is_list(), description
        if len(node) == 0:
            return
        else:
            self._emit_list(node, parent, index, description)
        for i, child in enumerate(node):
            self._get_walker(child)(child, node, i, scope, description.item_type)

    #Emitters
    def _emit_node(self, ast_node, parent, index, scope):
        t = type(ast_node)
        node = _ast_nodes[t.__name__]
        #Ensure all stmts have a list as a parent.
        if isinstance(ast_node, ast.stmt):
            assert isinstance(parent, list), (ast_node, parent)
        if node.is_sub_type():
            rel_name = node.super_type.relation_name()
            shared_parent = not node.super_type.unique_parent
        else:
            rel_name = node.relation_name()
            shared_parent = node.parents is None or not node.unique_parent
        if rel_name[-1] != 's':
            rel_name += 's'
        if t.__mro__[1] in (ast.cmpop, ast.operator, ast.expr_context, ast.unaryop, ast.boolop):
            #These nodes may be used more than once, but must have a
            #unique id for each occurrence in the AST
            fields = [ self.writer.get_unique_id() ]
            fmt = 'r'
        else:
            fields = [ ast_node ]
            fmt = 'n'
        if node.is_sub_type():
            fields.append(node.index)
            fmt += 'd'
        if parent:
            fields.append(parent)
            fmt += 'n'
            if shared_parent:
                fields.append(index)
                fmt += 'd'
        self.writer.write_tuple(rel_name, fmt, *fields)
        if t.__mro__[1] in (ast.expr, ast.stmt):
            self.writer.write_tuple(u'py_scopes', 'nn', ast_node, scope)

    def _emit_variable(self, ast_node):
        self.writer.write_tuple(u'variable', 'nns', ast_node, ast_node.scope, ast_node.id)

    def _emit_name(self, ast_node, parent):
        self._emit_variable(ast_node)
        self.writer.write_tuple(u'py_variables', 'nn', ast_node, parent)

    def _emit_primitive(self, val, parent, index, scope, description):
        if val is None or val is False:
            return
        if isinstance(val, ast.Variable):
            self._emit_name(val, parent)
            return
        assert not isinstance(val, ast.AstBase)
        rel = description.relation_name()
        if val is True:
            if description.unique_parent:
                self.writer.write_tuple(rel, 'n', parent)
            else:
                self.writer.write_tuple(rel, 'nd', parent, index)
        else:
            f = format_for_primitive(val, description)
            if description.unique_parent:
                self.writer.write_tuple(rel, f + 'n', val, parent)
            else:
                self.writer.write_tuple(rel, f + 'nd', val, parent, index)

    def _emit_list(self, node, parent, index, description):
        rel_name = description.relation_name()
        if description.unique_parent:
            self.writer.write_tuple(rel_name, 'nn', node, parent)
        else:
            self.writer.write_tuple(rel_name, 'nnd', node, parent, index)

_ast_nodes = semmle.python.master.all_nodes()
if get_analysis_major_version() < 3:
    _ast_nodes['TryExcept'] = _ast_nodes['Try']
    _ast_nodes['TryFinally'] = _ast_nodes['Try']

class ConsistencyError(Exception):

    def __str__(self):
        return self.message

def iter_fields(node):
    desc = _ast_nodes[type(node).__name__]
    for name, description, _, _, _ in desc.fields:
        if hasattr(node, name):
            yield name, description, getattr(node, name)


NUMBER_TYPES = (int, float)

def check_matches(node, node_type, owner, field):
    if node_type is list:
        if node.is_list():
            return
    else:
        for t in node_type.__mro__:
            if t.__name__ == node.__name__:
                return
    if node_type in NUMBER_TYPES and node.__name__ == 'number':
        return
    raise ConsistencyError("Found %s expected %s for field %s of %s" %
                   (node_type.__name__, node.__name__, field, owner.__name__))

def get_offset_table():
    '''Returns mapping of (class_name, field_name)
    pairs to offsets (in relation)'''
    table = {}
    nodes = _ast_nodes.values()
    for node in nodes:
        for field, _, offset, _, _, _ in node.layout:
            table[(node.__name__, field)] = offset
    try_node = _ast_nodes['Try']
    for field, _, offset, _, _, _ in try_node.layout:
        table[('TryFinally', field)] = offset
        table[('TryExcept', field)] = offset
    return table


def format_for_primitive(val, description):
    if isinstance(val, str):
        return 'u'
    elif isinstance(val, bytes):
        return 'b'
    elif description.__name__ == 'int':
        return 'd'
    else:
        return 'q'

class ASTVisitor(object):
    """
    A node visitor base class that walks the abstract syntax tree and calls a
    visitor function for every node found.  This function may return a value
    which is forwarded by the `visit` method.

    This class is meant to be subclassed, with the subclass adding visitor
    methods.

    The visitor functions for the nodes are ``'visit_'`` + class name of the node.
    """

    def _get_visit_method(self, node):
        method = 'visit_' + node.__class__.__name__
        return getattr(self, method, self.generic_visit)

    def visit(self, node):
        """Visit a node."""
        self._get_visit_method(node)(node)

    def generic_visit(self, node):
        """Called if no explicit visitor function exists for a node."""
        if isinstance(node, ast.AstBase):
            for _, _, child in iter_fields(node):
                self.visit(child)
        elif isinstance(node, list):
            for item in node:
                self._get_visit_method(item)(item)
