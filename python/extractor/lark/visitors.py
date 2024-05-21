from inspect import getmembers, getmro
from functools import wraps

from .utils import smart_decorator
from .tree import Tree

class Discard(Exception):
    pass


# Transformers

class Transformer:
    """Visits the tree recursively, starting with the leaves and finally the root (bottom-up)

    Calls its methods (provided by user via inheritance) according to tree.data
    The returned value replaces the old one in the structure.

    Can be used to implement map or reduce.
    """

    def _call_userfunc(self, tree, new_children=None):
        # Assumes tree is already transformed
        children = new_children if new_children is not None else tree.children
        try:
            f = getattr(self, tree.data)
        except AttributeError:
            return self.__default__(tree.data, children, tree.meta)
        else:
            if getattr(f, 'meta', False):
                return f(children, tree.meta)
            elif getattr(f, 'inline', False):
                return f(*children)
            elif getattr(f, 'whole_tree', False):
                if new_children is not None:
                    raise NotImplementedError("Doesn't work with the base Transformer class")
                return f(tree)
            else:
                return f(children)

    def _transform_children(self, children):
        for c in children:
            try:
                yield self._transform_tree(c) if isinstance(c, Tree) else c
            except Discard:
                pass

    def _transform_tree(self, tree):
        children = list(self._transform_children(tree.children))
        return self._call_userfunc(tree, children)

    def transform(self, tree):
        return self._transform_tree(tree)

    def __mul__(self, other):
        return TransformerChain(self, other)

    def __default__(self, data, children, meta):
        "Default operation on tree (for override)"
        return Tree(data, children, meta)

    @classmethod
    def _apply_decorator(cls, decorator, **kwargs):
        mro = getmro(cls)
        assert mro[0] is cls
        libmembers = {name for _cls in mro[1:] for name, _ in getmembers(_cls)}
        for name, value in getmembers(cls):
            if name.startswith('_') or name in libmembers:
                continue

            setattr(cls, name, decorator(value, **kwargs))
        return cls


class InlineTransformer(Transformer):   # XXX Deprecated
    def _call_userfunc(self, tree, new_children=None):
        # Assumes tree is already transformed
        children = new_children if new_children is not None else tree.children
        try:
            f = getattr(self, tree.data)
        except AttributeError:
            return self.__default__(tree.data, children, tree.meta)
        else:
            return f(*children)


class TransformerChain(object):
    def __init__(self, *transformers):
        self.transformers = transformers

    def transform(self, tree):
        for t in self.transformers:
            tree = t.transform(tree)
        return tree

    def __mul__(self, other):
        return TransformerChain(*self.transformers + (other,))


class Transformer_InPlace(Transformer):
    "Non-recursive. Changes the tree in-place instead of returning new instances"
    def _transform_tree(self, tree):           # Cancel recursion
        return self._call_userfunc(tree)

    def transform(self, tree):
        for subtree in tree.iter_subtrees():
            subtree.children = list(self._transform_children(subtree.children))

        return self._transform_tree(tree)


class Transformer_InPlaceRecursive(Transformer):
    "Recursive. Changes the tree in-place instead of returning new instances"
    def _transform_tree(self, tree):
        tree.children = list(self._transform_children(tree.children))
        return self._call_userfunc(tree)



# Visitors

class VisitorBase:
    def _call_userfunc(self, tree):
        return getattr(self, tree.data, self.__default__)(tree)

    def __default__(self, tree):
        "Default operation on tree (for override)"
        return tree


class Visitor(VisitorBase):
    """Bottom-up visitor, non-recursive

    Visits the tree, starting with the leaves and finally the root (bottom-up)
    Calls its methods (provided by user via inheritance) according to tree.data
    """


    def visit(self, tree):
        for subtree in tree.iter_subtrees():
            self._call_userfunc(subtree)
        return tree

class Visitor_Recursive(VisitorBase):
    """Bottom-up visitor, recursive

    Visits the tree, starting with the leaves and finally the root (bottom-up)
    Calls its methods (provided by user via inheritance) according to tree.data
    """

    def visit(self, tree):
        for child in tree.children:
            if isinstance(child, Tree):
                self.visit(child)

        f = getattr(self, tree.data, self.__default__)
        f(tree)
        return tree



def visit_children_decor(func):
    "See Interpreter"
    @wraps(func)
    def inner(cls, tree):
        values = cls.visit_children(tree)
        return func(cls, values)
    return inner


class Interpreter:
    """Top-down visitor, recursive

    Visits the tree, starting with the root and finally the leaves (top-down)
    Calls its methods (provided by user via inheritance) according to tree.data

    Unlike Transformer and Visitor, the Interpreter doesn't automatically visit its sub-branches.
    The user has to explicitly call visit_children, or use the @visit_children_decor
    """
    def visit(self, tree):
        return getattr(self, tree.data)(tree)

    def visit_children(self, tree):
        return [self.visit(child) if isinstance(child, Tree) else child
                for child in tree.children]

    def __getattr__(self, name):
        return self.__default__

    def __default__(self, tree):
        return self.visit_children(tree)




# Decorators

def _apply_decorator(obj, decorator, **kwargs):
    try:
        _apply = obj._apply_decorator
    except AttributeError:
        return decorator(obj, **kwargs)
    else:
        return _apply(decorator, **kwargs)



def _inline_args__func(func):
    @wraps(func)
    def create_decorator(_f, with_self):
        if with_self:
            def f(self, children):
                return _f(self, *children)
        else:
            def f(self, children):
                return _f(*children)
        return f

    return smart_decorator(func, create_decorator)


def inline_args(obj):   # XXX Deprecated
    return _apply_decorator(obj, _inline_args__func)



def _visitor_args_func_dec(func, inline=False, meta=False, whole_tree=False):
    assert [whole_tree, meta, inline].count(True) <= 1
    def create_decorator(_f, with_self):
        if with_self:
            def f(self, *args, **kwargs):
                return _f(self, *args, **kwargs)
        else:
            def f(self, *args, **kwargs):
                return _f(*args, **kwargs)
        return f

    f = smart_decorator(func, create_decorator)
    f.inline = inline
    f.meta = meta
    f.whole_tree = whole_tree
    return f

def v_args(inline=False, meta=False, tree=False):
    "A convenience decorator factory, for modifying the behavior of user-supplied visitor methods"
    if [tree, meta, inline].count(True) > 1:
        raise ValueError("Visitor functions can either accept tree, or meta, or be inlined. These cannot be combined.")
    def _visitor_args_dec(obj):
        return _apply_decorator(obj, _visitor_args_func_dec, inline=inline, meta=meta, whole_tree=tree)
    return _visitor_args_dec
