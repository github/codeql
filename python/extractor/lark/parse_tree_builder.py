from .exceptions import GrammarError
from .utils import suppress
from .lexer import Token
from .grammar import Rule
from .tree import Tree
from .visitors import InlineTransformer # XXX Deprecated

###{standalone
from functools import partial, wraps


class ExpandSingleChild:
    def __init__(self, node_builder):
        self.node_builder = node_builder

    def __call__(self, children):
        if len(children) == 1:
            return children[0]
        else:
            return self.node_builder(children)


class PropagatePositions:
    def __init__(self, node_builder):
        self.node_builder = node_builder

    def __call__(self, children):
        res = self.node_builder(children)

        if children and isinstance(res, Tree):
            for a in children:
                if isinstance(a, Tree):
                    res.meta.line = a.meta.line
                    res.meta.column = a.meta.column
                elif isinstance(a, Token):
                    res.meta.line = a.line
                    res.meta.column = a.column
                break

            for a in reversed(children):
                # with suppress(AttributeError):
                if isinstance(a, Tree):
                    res.meta.end_line = a.meta.end_line
                    res.meta.end_column = a.meta.end_column
                elif isinstance(a, Token):
                    res.meta.end_line = a.end_line
                    res.meta.end_column = a.end_column

                break

        return res


class ChildFilter:
    def __init__(self, to_include, node_builder):
        self.node_builder = node_builder
        self.to_include = to_include

    def __call__(self, children):
        filtered = []
        for i, to_expand in self.to_include:
            if to_expand:
                filtered += children[i].children
            else:
                filtered.append(children[i])

        return self.node_builder(filtered)

class ChildFilterLALR(ChildFilter):
    "Optimized childfilter for LALR (assumes no duplication in parse tree, so it's safe to change it)"

    def __call__(self, children):
        filtered = []
        for i, to_expand in self.to_include:
            if to_expand:
                if filtered:
                    filtered += children[i].children
                else:   # Optimize for left-recursion
                    filtered = children[i].children
            else:
                filtered.append(children[i])

        return self.node_builder(filtered)

def _should_expand(sym):
    return not sym.is_term and sym.name.startswith('_')

def maybe_create_child_filter(expansion, keep_all_tokens, ambiguous):
    to_include = [(i, _should_expand(sym)) for i, sym in enumerate(expansion)
                  if keep_all_tokens or not (sym.is_term and sym.filter_out)]

    if len(to_include) < len(expansion) or any(to_expand for i, to_expand in to_include):
        return partial(ChildFilter if ambiguous else ChildFilterLALR, to_include)


class Callback(object):
    pass


def inline_args(func):
    @wraps(func)
    def f(children):
        return func(*children)
    return f



class ParseTreeBuilder:
    def __init__(self, rules, tree_class, propagate_positions=False, keep_all_tokens=False, ambiguous=False):
        self.tree_class = tree_class
        self.propagate_positions = propagate_positions
        self.always_keep_all_tokens = keep_all_tokens
        self.ambiguous = ambiguous

        self.rule_builders = list(self._init_builders(rules))

        self.user_aliases = {}

    def _init_builders(self, rules):
        for rule in rules:
            options = rule.options
            keep_all_tokens = self.always_keep_all_tokens or (options.keep_all_tokens if options else False)
            expand_single_child = options.expand1 if options else False

            wrapper_chain = filter(None, [
                (expand_single_child and not rule.alias) and ExpandSingleChild,
                maybe_create_child_filter(rule.expansion, keep_all_tokens, self.ambiguous),
                self.propagate_positions and PropagatePositions,
            ])

            yield rule, wrapper_chain


    def create_callback(self, transformer=None):
        callback = Callback()

        i = 0
        for rule, wrapper_chain in self.rule_builders:
            internal_callback_name = '_cb%d_%s' % (i, rule.origin)
            i += 1

            user_callback_name = rule.alias or rule.origin.name
            try:
                f = getattr(transformer, user_callback_name)
                assert not getattr(f, 'meta', False), "Meta args not supported for internal transformer"
                # XXX InlineTransformer is deprecated!
                if getattr(f, 'inline', False) or isinstance(transformer, InlineTransformer):
                    f = inline_args(f)
            except AttributeError:
                f = partial(self.tree_class, user_callback_name)

            self.user_aliases[rule] = rule.alias
            rule.alias = internal_callback_name

            for w in wrapper_chain:
                f = w(f)

            if hasattr(callback, internal_callback_name):
                raise GrammarError("Rule '%s' already exists" % (rule,))
            setattr(callback, internal_callback_name, f)

        return callback

###}
