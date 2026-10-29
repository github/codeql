
from semmle.python import ast
from semmle.python.passes._pass import Pass

def write_exports(module, exports, writer):
    for sym in exports:
        writer.write_tuple(u'py_exports', 'ns', module, sym)

def list_of_symbols_from_expr(expr):
    #This should be a list of constant strings
    if isinstance(expr, (ast.List, ast.Tuple)):
        exports = []
        for item in expr.elts:
            if isinstance(item, ast.Str):
                exports.append(item.s)
        return exports
    return []

def is___all__(node):
    try:
        return isinstance(node, ast.Name) and node.variable.id == '__all__'
    except Exception:
        return False

def __all___from_stmt(stmt):
    '''Returns None if __all__ is not defined.
       If __all__ may be defined then return a conservative approximation'''
    assert isinstance(stmt, ast.stmt)
    if isinstance(stmt, ast.If):
        body_exports = __all___from_stmt_list(stmt.body)
        if stmt.orelse:
            orelse_exports = __all___from_stmt_list(stmt.orelse)
        else:
            orelse_exports = None
        # If __all__ = ... on one branch but not other then return []
        # If defined on neither branch return None
        if body_exports is None:
            if orelse_exports is None:
                return None
            else:
                return []
        else:
            if orelse_exports is None:
                return []
            else:
                return set(body_exports).intersection(set(orelse_exports))
    elif isinstance(stmt, ast.Assign):
        for target in stmt.targets:
            if is___all__(target):
                return list_of_symbols_from_expr(stmt.value)
    return None

def __all___from_stmt_list(stmts):
    assert isinstance(stmts, list)
    exports = None
    for stmt in stmts:
        ex = __all___from_stmt(stmt)
        if ex is not None:
            exports = ex
    return exports

def is_private_symbol(sym):
    if sym[0] != '_':
        return False
    if len(sym) >= 4 and sym[:2] == '__' and sym[-2:] == '__':
        return False
    return True

def globals_from_tree(node, names):
    'Add all globals defined in the tree to names'
    if isinstance(node, list):
        for subnode in node:
            globals_from_tree(subnode, names)
    elif isinstance(node, ast.Assign):
        for target in node.targets:
            if isinstance(target, ast.Name):
                names.add(target.variable.id)
    elif isinstance(node, ast.If):
        if node.orelse:
            left = set()
            right = set()
            globals_from_tree(node.body, left)
            globals_from_tree(node.orelse, right)
            names.update(left.intersection(right))
    # Don't decent into other nodes.

def exports_from_ast(node):
    'Get a list of symbols exported by the module from its ast.'
    #Look for assignments to __all__
    #If not available at top-level, then check if-statements,
    #but ignore try-except and loops
    assert type(node) is ast.Module
    exports = __all___from_stmt_list(node.body)
    if exports is not None:
        return exports
    # No explicit __all__ assignment so gather global assignments
    exports = set()
    globals_from_tree(node.body, exports)
    return [ ex for ex in exports if not is_private_symbol(ex) ]

class ExportsPass(Pass):
    '''Finds all 'exports' of a module. An export is a symbol that is defined
    in the __all__ list or, if __all__ is undefined, is defined at top-level
    and is not private'''

    name = "exports"

    def __init__(self):
        pass

    def extract(self, ast, writer):
        exported = exports_from_ast(ast)
        write_exports(ast, exported, writer)
