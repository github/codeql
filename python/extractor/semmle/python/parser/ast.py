from blib2to3.pgen2 import token
from ast import literal_eval
from semmle.python import ast
from blib2to3.pgen2.parse import ParseError
import sys

LOAD = ast.Load()
STORE = ast.Store()
PARAM = ast.Param()
DEL = ast.Del()

POSITIONAL = 1
KEYWORD = 2


class ParseTreeVisitor(object):
    '''Standard tree-walking visitor,
    using `node.name` rather than `type(node).__name__`
    '''

    def visit(self, node, extra_arg=None):
        method = 'visit_' + node.name
        if extra_arg is None:
            return getattr(self, method)(node)
        else:
            return getattr(self, method)(node, extra_arg)

class Convertor(ParseTreeVisitor):
    ''' Walk the conrete parse tree, returning an AST.
    The CPT is specified by  blib2to3/Grammar.txt.
    The AST specified by semmle/python/master.py.
    Each `visit_X` method takes a `X` node in the CFG and
    produces some part of the AST, usually a single node.
    '''

    def __init__(self, logger):
        self.logger = logger
        # To handle f-strings nested inside other f-strings, we must keep track of the stack of
        # surrounding prefixes while walking the tree. This is necessary because inside an f-string
        # like `f"hello{f'to{you}dear'}world"`, the string part containing "world" has (in terms of
        # the concrete parse tree) a prefix of `}`, which doesn't tell us how to interpret it (in
        # particular, we can't tell if it's a raw string or not). So instead we look at the top of
        # the prefix stack to figure out what the "current prefix" is. The nested f-string in the
        # example above demonstrates why we must do this as a stack -- we must restore the outer
        # `f"` prefix when we're done with the inner `f'`-prefix string.
        #
        # The stack manipulation itself takes place in the `visit_FSTRING_START` and
        # `visit_FSTRING_END` methods. The text wrangling takes place in the `parse_string` helper
        # function.

        self.outer_prefix_stack = []


    def visit_file_input(self, node):
        body = []
        for s in [self.visit(s) for s in node.children if s.name not in ("ENDMARKER", "NEWLINE")]:
            if isinstance(s, list):
                body.extend(s)
            else:
                body.append(s)
        result = ast.Module(body)
        set_location(result, node)
        return result

    def visit_import_from(self, node):
        level = 0
        index = 1
        module_start = node.children[index].start
        while is_token(node.children[index], "."):
            level += 1
            index += 1
        if is_token(node.children[index], "import"):
            module_end = node.children[index-1].end
            index += 1
            module_name = None
        else:
            module_end = node.children[index].end
            module_name = self.visit(node.children[index])
            index += 2
        if is_token(node.children[index], "*"):
            module = ast.ImportExpr(level, module_name, False)
            set_location(module, module_start, module_end)
            result = ast.ImportFrom(module)
            set_location(result, node)
            return result
        if is_token(node.children[index], "("):
            import_as_names = node.children[index+1]
        else:
            import_as_names = node.children[index]
        aliases = []
        for import_as_name in import_as_names.children[::2]:
            module = ast.ImportExpr(level, module_name, False)
            set_location(module, module_start, module_end)
            aliases.append(self._import_as_name(import_as_name, module))
        result = ast.Import(aliases)
        set_location(result, node)
        return result

    #Helper for visit_import_from
    def _import_as_name(self, node, module):
        name = node.children[0].value
        if len(node.children) == 3:
            asname = node.children[2]
        else:
            asname = node.children[0]
        expr = ast.ImportMember(module, name)
        set_location(expr, node)
        rhs = make_name(asname.value, STORE, asname.start, asname.end)
        result = ast.alias(expr, rhs)
        set_location(result, node)
        return result

    def visit_small_stmt(self, node):
        return self.visit(node.children[0])

    def visit_simple_stmt(self, node):
        return [self.visit(s) for s in node.children if s.name not in ("SEMI", "NEWLINE")]

    def visit_stmt(self, node):
        return self.visit(node.children[0])

    def visit_compound_stmt(self, node):
        return self.visit(node.children[0])

    def visit_pass_stmt(self, node):
        p = ast.Pass()
        set_location(p, node)
        return p

    def visit_classdef(self, node):
        if len(node.children) == 4:
            cls, name, colon, suite = node.children
            args, keywords = [], []
        elif len(node.children) == 7:
            cls, name, _, args, _, colon, suite = node.children
            args, keywords = self.visit(args)
        else:
            assert len(node.children) == 6
            cls, name, _, _, colon, suite = node.children
            args, keywords = [], []
        start = cls.start
        end = colon.end
        suite = self.visit(suite)
        inner = ast.Class(name.value, suite)
        set_location(inner, start, end)
        cls_expr = ast.ClassExpr(name.value, [], args, keywords, inner)
        set_location(cls_expr, start, end)
        name_expr = make_name(name.value, STORE, name.start, name.end)
        result = ast.Assign(cls_expr, [name_expr])
        set_location(result, start, end)
        return result

    def visit_arglist(self, node):
        all_args = self._visit_list(node.children[::2])
        args = [ arg for kind, arg in all_args if kind is POSITIONAL ]
        keywords  = [ arg for kind, arg in all_args if kind is KEYWORD ]
        return args, keywords

    def visit_argument(self, node):
        child = node.children[0]
        if is_token(child, "*"):
            kind, arg = POSITIONAL, ast.Starred(self.visit(node.children[1], LOAD), LOAD)
        elif is_token(child, "**"):
            kind, arg = KEYWORD, ast.DictUnpacking(self.visit(node.children[1], LOAD))
        elif len(node.children) == 3 and is_token(node.children[1], "="):
            try:
                name = get_node_value(child)
            except Exception:
                #Not a legal name
                name = None
                self.logger.warning("Illegal name for keyword on line %s", child.start[0])
            kind, arg = KEYWORD, ast.keyword(name, self.visit(node.children[2], LOAD))
        else:
            arg = self.visit(child, LOAD)
            if len(node.children) == 1:
                return POSITIONAL, arg
            elif len(node.children) == 3 and is_token(node.children[1], ":="):
                return POSITIONAL, self.visit_namedexpr_test(node, LOAD)
            generators = self.visit(node.children[1])
            kind, arg = POSITIONAL, ast.GeneratorExp(arg, generators)
            set_location(arg, node)
            rewrite_comp(arg)
        set_location(arg, node)
        return kind, arg

    def visit_namedexpr_test(self, node, ctx):
        if len(node.children) == 1:
            return self.visit(node.children[0], ctx)
        target = self.visit(node.children[0], STORE)
        value = self.visit(node.children[-1], LOAD)
        result = ast.AssignExpr(value, target)
        set_location(result, node)
        return result

    def visit_test(self, node, ctx):
        if len(node.children) == 1:
            return self.visit(node.children[0], ctx)
        else:
            if ctx is not LOAD:
                context_error(node)
            body = self.visit(node.children[0], ctx)
            test = self.visit(node.children[2], ctx)
            orelse = self.visit(node.children[4], ctx)
            ifexp = ast.IfExp(test, body, orelse)
            set_location(ifexp, node)
            return ifexp

    def visit_or_test(self, node, ctx):
        return self._boolop(node, ast.Or, ctx)

    def visit_and_test(self, node, ctx):
        return self._boolop(node, ast.And, ctx)

    def visit_not_test(self, node, ctx):
        if len(node.children) == 1:
            return self.visit(node.children[0], ctx)
        if ctx is not LOAD:
            context_error(node)
        result = ast.UnaryOp(
            ast.Not(),
            self.visit(node.children[1], ctx)
        )
        set_location(result, node)
        return result

    # Helper for `or` and `and`.
    def _boolop(self, node, opcls, ctx):
        if len(node.children) == 1:
            return self.visit(node.children[0], ctx)
        values = [ self.visit(s, ctx) for s in node.children[::2] ]
        result = ast.BoolOp(opcls(), values)
        set_location(result, node)
        return result

    # Helper for various binary expression visitors.
    def _binary(self, node, opfact, ctx):
        if len(node.children) == 1:
            return self.visit(node.children[0], ctx)
        if ctx is not LOAD:
            context_error(node)
        children = iter(node.children)
        result = self.visit(next(children), LOAD)
        for op in children:
            item = next(children)
            rhs = self.visit(item, LOAD)
            result = ast.BinOp(result, opfact(op), rhs)
            set_location(result, node.start, item.end)
        return result

    def visit_suite(self, node):
        if len(node.children) == 1:
            return self.visit(node.children[0])
        result = []
        for s in [self.visit(s) for s in node.children[2:-1]]:
            if isinstance(s, list):
                result.extend(s)
            else:
                result.append(s)
        return result

    def visit_expr_stmt(self, node):
        if len(node.children) == 1:
            result = ast.Expr(self.visit(node.children[0], LOAD))
            set_location(result, node)
            return result
        if len(node.children) > 1 and is_token(node.children[1], "="):
            return self._assign(node)
        if len(node.children) == 2:
            # Annotated assignment
            target = self.visit(node.children[0], STORE)
            ann = node.children[1]
            type_anno = self.visit(ann.children[1], LOAD)
            if len(ann.children) > 2:
                value = self.visit(ann.children[3], LOAD)
            else:
                value = None
            result = ast.AnnAssign(value, type_anno, target)
        else:
            #Augmented assignment
            lhs = self.visit(node.children[0], LOAD)
            op = self.visit(node.children[1])
            rhs = self.visit(node.children[2], LOAD)
            expr = ast.BinOp(lhs, op, rhs)
            set_location(expr, node)
            result = ast.AugAssign(expr)
        set_location(result, node)
        return result

    def visit_augassign(self, node):
        return AUG_ASSIGN_OPS[node.children[0].value]()

    #Helper for visit_expr_stmt (for assignment)
    def _assign(self, node):
        targets = [ self.visit(t, STORE) for t in node.children[:-1:2]]
        result = ast.Assign(self.visit(node.children[-1], LOAD), targets)
        set_location(result, node)
        return result

    def visit_testlist(self, node, ctx):
        if len(node.children) == 1:
            return self.visit(node.children[0], ctx)
        elts = self._visit_list(node.children[::2], ctx)
        result = ast.Tuple(elts, ctx)
        set_location(result, node)
        return result

    visit_testlist_star_expr = visit_testlist

    def visit_comparison(self, node, ctx):
        if len(node.children) == 1:
            return self.visit(node.children[0], ctx)
        if ctx is not LOAD:
            context_error(node)
        left = self.visit(node.children[0], ctx)
        ops = [ self.visit(op) for op in node.children[1::2]]
        comps = [ self.visit(op, ctx) for op in node.children[2::2]]
        result = ast.Compare(left, ops, comps)
        set_location(result, node)
        return result

    def visit_comp_op(self, node):
        if len(node.children) == 1:
            return COMP_OP_CLASSES[node.children[0].value]()
        else:
            assert len(node.children) == 2
            return ast.IsNot() if node.children[0].value == "is" else ast.NotIn()

    def visit_expr(self, node, ctx):
        return self._binary(node, lambda _: ast.BitOr(), ctx)

    def visit_xor_expr(self, node, ctx):
        return self._binary(node, lambda _: ast.BitXor(), ctx)

    def visit_and_expr(self, node, ctx):
        return self._binary(node, lambda _: ast.BitAnd(), ctx)

    def visit_shift_expr(self, node, ctx):
        return self._binary(
            node,
            lambda op: ast.LShift() if op.value == "<<" else ast.RShift(),
            ctx
        )

    def visit_arith_expr(self, node, ctx):
        return self._binary(
            node,
            lambda op: ast.Add() if op.value == "+" else ast.Sub(),
            ctx
        )

    def visit_term(self, node, ctx):
        return self._binary(
            node,
            lambda op: TERM_OP_CLASSES[op.value](),
            ctx
        )

    def visit_factor(self, node, ctx):
        if len(node.children) == 1:
            return self.visit(node.children[0], ctx)
        result = ast.UnaryOp(
            FACTOR_OP_CLASSES[node.children[0].value](),
            self.visit(node.children[1], ctx)
        )
        set_location(result, node)
        return result

    def visit_power(self, node, ctx):
        '''This part of the Grammar is formulated in a slightly
        awkward way, so we need to recursively handle the `await`
        prefix, then the `** factor` suffix, then the atom and trailers.
        '''

        # Because `await` was a valid identifier in earlier versions of Python,
        # we cannot assume it indicates an `await` expression. We therefore
        # have to look at what follows in order to make a decision. The
        # relevant part of the grammar is
        #
        # power: ['await'] atom trailer* ['**' factor]
        #
        # The case we wish to identify is when 'await' appears, but as an
        # `atom`, and not an `await` token.
        #
        # Because `atom` nodes may no longer be present (see
        # `SKIP_IF_SINGLE_CHILD_NAMES` in `__init__.py`) we instead look at the
        # node following the (potentially) skipped `atom`. In particular, if
        # the following node is a `trailer` or "**" token, we know that the
        # given node cannot be an `await` token, and must be an `atom` instead.
        try:
            next_node = node.children[1]
            next_is_atom = next_node.name != "trailer" and not is_token(next_node, "**")
        except (IndexError, AttributeError):
            # IndexError if `node` has at most one child.
            # AttributeError if `next_node` is a `Leaf` instead of a `Node`.
            next_is_atom = False
        if is_token(node.children[0], "await") and next_is_atom:
            if ctx is not LOAD:
                context_error(node)
            pow = self._power(node.children[1:], ctx)
            result = ast.Await(pow)
            set_location(result, node)
            return result
        else:
            return self._power(node.children, ctx)

    #Helper for visit_power
    def _power(self, children, ctx):
        start = children[0].start
        if len(children) > 1 and is_token(children[-2], "**"):
            if ctx is not LOAD:
                context_error(children[0])
            trailers = children[1:-2]
            pow_expr = self.visit(children[-1], ctx)
        else:
            trailers = children[1:]
            pow_expr = None
        if trailers:
            expr = self.visit(children[0], LOAD)
            for trailer in trailers[:-1]:
                expr = self._apply_trailer(expr, trailer, start, LOAD)
            expr = self._apply_trailer(expr, trailers[-1], start, ctx)
        else:
            expr = self.visit(children[0], ctx)
        if pow_expr:
            expr = ast.BinOp(expr, ast.Pow(), pow_expr)
            set_location(expr, children[0].start, children[-1].end)
        return expr

    #Helper for _power
    def _atom(self, children, ctx):
        start = children[0].start
        if len(children) == 1:
            return self.visit(children[0], ctx)
        atom = self.visit(children[0], LOAD)
        for trailer in children[1:-1]:
            atom = self._apply_trailer(atom, trailer, start, LOAD)
        atom = self._apply_trailer(atom, children[-1], start, ctx)
        return atom

    #Helper for _atom
    def _apply_trailer(self, atom, trailer, start, ctx):
        children = trailer.children
        left = children[0]
        if is_token(left, "("):
            if is_token(children[1], ")"):
                args, keywords = [], []
                end = children[1].end
            else:
                args, keywords = self.visit(children[1])
                end = children[2].end
            result = ast.Call(atom, args, keywords)
        elif is_token(left, "["):
            result = ast.Subscript(atom, self.visit(children[1], LOAD), ctx)
            end = children[2].end
        else:
            assert is_token(left, ".")
            result = ast.Attribute(atom, children[1].value, ctx)
            end = children[1].end
        set_location(result, start, end)
        return result

    def visit_atom(self, node, ctx):
        left = node.children[0]
        if left.value in "[({":
            n = node.children[1]
            if hasattr(n, "value") and n.value in "])}":
                if n.value == ")":
                    result = ast.Tuple([], ctx)
                elif n.value == "]":
                    result = ast.List([], ctx)
                else:
                    result = ast.Dict([])
                set_location(result, node)
                return result
            else:
                result = self.visit(node.children[1], ctx)
                if left.value == "(":
                    result.parenthesised = True
                else:
                    #Meaningful bracketing
                    set_location(result, node)
                if isinstance(result, (ast.GeneratorExp, ast.ListComp, ast.SetComp, ast.DictComp)):
                    rewrite_comp(result)
                return result
        if left.type == token.NAME:
            return make_name(left.value, ctx, left.start, left.end)
        if ctx is not LOAD:
            context_error(node)
        if left.type == token.NUMBER:
            val = get_numeric_value(left)
            result = ast.Num(val, left.value)
            set_location(result, left)
            return result
        if left.value == ".":
            assert len(node.children) == 3 and node.children[2].value == "."
            result = ast.Ellipsis()
            set_location(result, node)
            return result
        assert left.type == token.BACKQUOTE
        result = ast.Repr(self.visit(node.children[1], LOAD))
        set_location(result, node)
        return result

    def visit_STRING(self, node, ctx):
        if ctx is not LOAD:
            context_error(node)
        outer_prefix = self.outer_prefix_stack[-1] if self.outer_prefix_stack else None
        prefix, s = parse_string(node.value, self.logger, outer_prefix)
        text = get_text(node.value, outer_prefix)
        result = ast.StringPart(prefix, text, s)
        set_location(result, node)
        return result

    def visit_NUMBER(self, node, ctx):
        if ctx is not LOAD:
            context_error(node)
        val = get_numeric_value(node)
        result = ast.Num(val, node.value)
        set_location(result, node)
        return result

    def visit_funcdef(self, node, is_async=False):
        # funcdef: 'def' NAME parameters ['->' test] ':' suite
        name = node.children[1].value
        if node.children[3].value == "->":
            return_type = self.visit(node.children[4], LOAD)
            end = node.children[5].end
            body = self.visit(node.children[6])
        else:
            return_type = None
            end = node.children[3].end
            body = self.visit(node.children[4])
        start = node.children[0].start
        params = node.children[2]
        if len(params.children) == 2:
            args, vararg, kwonlyargs, kwarg = [], None, [], None
        else:
            args, vararg, kwonlyargs, kwarg = self._get_parameters(params.children[1])
        func = ast.Function(name, [], args, vararg, kwonlyargs, kwarg, body, is_async)
        set_location(func, start, end)
        if len(params.children) == 2:
            args = ast.arguments([], [], [], None, None, [])
        else:
            args = self._get_defaults_and_annotations(params.children[1])
        funcexpr = ast.FunctionExpr(name, args, return_type, func)
        set_location(funcexpr, start, end)
        name_expr = make_name(name, STORE, node.children[1].start, node.children[1].end)
        result = ast.Assign(funcexpr, [name_expr])
        set_location(result, start, end)
        return result

    #Helper for visit_funcdef and visit_lambdef
    def _get_parameters(self, node):
        '''Returns the quadruple: args, vararg, kwonlyargs, kwarg
        '''
        args = []
        vararg = None
        kwonlyargs = []
        kwarg = None
        children = iter(node.children)
        arg = None
        for child in children:
            if is_token(child, "*"):
                try:
                    child = next(children)
                except StopIteration:
                    pass
                else:
                    if not is_token(child, ","):
                        vararg = self.visit(child, PARAM)
                break
            if is_token(child, ","):
                pass
            elif is_token(child, "/"):
                pass
            elif is_token(child, "="):
                next(children)
            elif is_token(child, "**"):
                child = next(children)
                kwarg = self.visit(child, PARAM)
            else:
                arg = self.visit(child, PARAM)
                args.append(arg)
        #kwonly args
        for child in children:
            if is_token(child, ","):
                pass
            elif is_token(child, "="):
                next(children)
            elif is_token(child, "**"):
                child = next(children)
                kwarg = self.visit(child, PARAM)
            else:
                arg = self.visit(child, PARAM)
                kwonlyargs.append(arg)
        return args, vararg, kwonlyargs, kwarg

    #Helper for visit_funcdef and visit_lambdef
    def _get_defaults_and_annotations(self, node):
        defaults = []
        kw_defaults = []
        annotations = []
        varargannotation = None
        kwargannotation = None
        kw_annotations = []
        children = iter(node.children)
        # Because we want the i'th element of `kw_defaults` to be the default value for
        # the i'th keyword-only argument, when encountering the combined token for the
        # argument name and optional annotation, we add a `None` to `kw_defaults` assuming
        # that there is no default value. If there turns out to be a default value, we
        # remove the `None` and add the real default value. Like-wise for `defaults`.

        # positional-only args and "normal" args
        for child in children:
            if is_token(child, "*"):
                try:
                    child = next(children)
                except StopIteration:
                    pass
                else:
                    if not is_token(child, ","):
                        varargannotation = self.visit(child, LOAD)
                break
            if is_token(child, ","):
                pass
            elif is_token(child, "/"):
                pass
            elif is_token(child, "="):
                child = next(children)
                defaults.pop()
                defaults.append(self.visit(child, LOAD))
            elif is_token(child, "**"):
                child = next(children)
                kwargannotation = self.visit(child, LOAD)
                arg = None
            else:
                # Preemptively assume there is no default argument (indicated by None)
                defaults.append(None)
                annotations.append(self.visit(child, LOAD))

        #kwonly args
        for child in children:
            if is_token(child, ","):
                pass
            elif is_token(child, "="):
                child = next(children)
                kw_defaults.pop()
                kw_defaults.append(self.visit(child, LOAD))
            elif is_token(child, "**"):
                child = next(children)
                kwargannotation = self.visit(child, LOAD)
            else:
                # Preemptively assume there is no default argument (indicated by None)
                kw_defaults.append(None)
                kw_annotations.append(self.visit(child, LOAD))
        result = ast.arguments(defaults, kw_defaults, annotations, varargannotation, kwargannotation, kw_annotations)
        set_location(result, node)
        return result

    def visit_tfpdef(self, node, ctx):
        # TO DO Support tuple parameters
        # No one uses them any more, so this isn't super important.
        child = node.children[0]
        if is_token(child, "("):
            return None
        return self.visit(child, ctx)

    def visit_tname(self, node, ctx):
        if ctx is PARAM:
            child = node.children[0]
            return make_name(child.value, ctx, child.start, child.end)
        elif len(node.children) > 1:
            return self.visit(node.children[2], ctx)
        else:
            return None

    def visit_decorated(self, node):
        asgn = self.visit(node.children[1])
        value = asgn.value
        for deco in reversed(node.children[0].children):
            defn = value
            decorator = self.visit(deco)
            value = ast.Call(decorator, [defn], [])
            copy_location(decorator, value)
        asgn.value = value
        return asgn

    def visit_decorators(self, node):
        return self._visit_list(node.children)

    def visit_decorator(self, node):
        namedexpr_test = node.children[1]
        result = self.visit_namedexpr_test(namedexpr_test, LOAD)
        set_location(result, namedexpr_test)
        return result

    def _visit_list(self, items, ctx=None):
        if ctx is None:
            return [ self.visit(i) for i in items ]
        else:
            return [ self.visit(i, ctx) for i in items ]

    def visit_dotted_name(self, node):
        return ".".join(name.value for name in node.children[::2])

    def visit_NAME(self, name, ctx):
        return make_name(name.value, ctx, name.start, name.end)

    def visit_listmaker(self, node, ctx):
        if len(node.children) == 1 or is_token(node.children[1], ","):
            items = [self.visit(c, ctx) for c in node.children[::2]]
            result = ast.List(items, ctx)
        else:
            if ctx is not LOAD:
                context_error(node)
            elt = self.visit(node.children[0], ctx)
            generators = self.visit(node.children[1])
            result = ast.ListComp(elt, generators)
        set_location(result, node)
        return result

    def visit_testlist_gexp(self, node, ctx):
        if len(node.children) == 1:
            return self.visit(node.children[0], ctx)
        if is_token(node.children[1], ","):
            items = [self.visit(c, ctx) for c in node.children[::2]]
            result = ast.Tuple(items, ctx)
        else:
            if ctx is not LOAD:
                context_error(node)
            elt = self.visit(node.children[0], ctx)
            generators = self.visit(node.children[1])
            result = ast.GeneratorExp(elt, generators)
        set_location(result, node)
        return result

    def visit_comp_for(self, node):
        is_async = is_token(node.children[0], "async")
        target = self.visit(node.children[1+is_async], STORE)
        iter = self.visit(node.children[3+is_async], LOAD)
        if len(node.children) == 5+is_async:
            ifs = []
            end = iter._end
            comp_iter = self.visit(node.children[4+is_async])
            while comp_iter and not isinstance(comp_iter[0], ast.comprehension):
                ifs.append(comp_iter[0])
                end = comp_iter[0]._end
                comp_iter = comp_iter[1:]
            comp = ast.comprehension(target, iter, ifs)
            comp.is_async = is_async
            set_location(comp, node.children[0].start, end)
            return [comp] + comp_iter
        else:
            comp = ast.comprehension(target, iter, [])
            comp.is_async = is_async
            set_location(comp, node)
            return [comp]

    visit_old_comp_for = visit_comp_for

    def visit_comp_iter(self, node):
        return self.visit(node.children[0])

    def visit_comp_if(self, node):
        cond = self.visit(node.children[1], LOAD)
        if len(node.children) == 3:
            comp_list = self.visit(node.children[2])
            return [cond] + comp_list
        else:
            return [cond]

    visit_old_comp_if = visit_comp_if

    visit_old_comp_iter = visit_comp_iter

    def visit_exprlist(self, node, ctx):
        #Despite the name this returns a single expression
        if len(node.children) == 1:
            return self.visit(node.children[0], ctx)
        else:
            elts = self._visit_list(node.children[::2], ctx)
            result = ast.Tuple(elts, ctx)
            set_location(result, node)
            return result

    visit_testlist_safe = visit_exprlist

    def visit_old_test(self, node, ctx):
        return self.visit(node.children[0], ctx)

    def visit_if_stmt(self, node):
        endindex = len(node.children)
        if is_token(node.children[-3], "else"):
            orelse = self.visit(node.children[-1])
            endindex -= 3
        else:
            orelse = None
        while endindex:
            test = self.visit(node.children[endindex-3], LOAD)
            body = self.visit(node.children[endindex-1])
            result = ast.If(test, body, orelse)
            start = node.children[endindex-4].start
            end = node.children[endindex-2].end
            set_location(result, start, end)
            orelse = [result]
            endindex -= 4
        return result

    def visit_import_stmt(self, node):
        return self.visit(node.children[0])

    def visit_import_name(self, node):
        aliases = self.visit(node.children[1])
        result = ast.Import(aliases)
        set_location(result, node)
        return result

    def visit_dotted_as_names(self, node):
        return self._visit_list(node.children[::2])

    def visit_dotted_as_name(self, node):
        child0 = node.children[0]
        dotted_name = self.visit(child0)
        if len(node.children) == 3:
            value = ast.ImportExpr(0, dotted_name, False)
            child2 = node.children[2]
            asname = make_name(child2.value, STORE, child2.start, child2.end)
        else:
            value = ast.ImportExpr(0, dotted_name, True)
            topname = dotted_name.split(".")[0]
            asname = make_name(topname, STORE, child0.start, child0.end)
        set_location(value, child0)
        result = ast.alias(value, asname)
        set_location(result, node)
        return result

    def visit_dictsetmaker(self, node, ctx):
        if ctx is not LOAD:
            context_error(node)
        if is_token(node.children[0], "**") or len(node.children) > 1 and is_token(node.children[1], ":"):
            return self._dictmaker(node)
        else:
            return self._setmaker(node)

    #Helper for visit_dictsetmaker (for dictionaries)
    def _dictmaker(self, node):
        if len(node.children) == 4 and is_token(node.children[1], ":") and not is_token(node.children[3], ","):
            #Comprehension form
            key = self.visit(node.children[0], LOAD)
            value = self.visit(node.children[2], LOAD)
            generators = self.visit(node.children[3])
            result = ast.DictComp(key, value, generators)
            set_location(result, node)
            return result
        index = 0
        items = []
        while len(node.children) > index:
            if is_token(node.children[index], "**"):
                d = self.visit(node.children[index+1], LOAD)
                item = ast.DictUnpacking(d)
                set_location(item, node.children[index].start, node.children[index+1].end)
                index += 3
            else:
                key = self.visit(node.children[index], LOAD)
                value = self.visit(node.children[index+2], LOAD)
                item = ast.KeyValuePair(key, value)
                set_location(item, node.children[index].start, node.children[index+2].end)
                index += 4
            items.append(item)
        result = ast.Dict(items)
        set_location(result, node)
        return result

    #Helper for visit_dictsetmaker (for sets)
    def _setmaker(self, node):
        if len(node.children) == 2 and not is_token(node.children[1], ","):
            #Comprehension form
            elt = self.visit(node.children[0], LOAD)
            generators = self.visit(node.children[1])
            result = ast.SetComp(elt, generators)
            set_location(result, node)
            return result
        items = self._visit_list(node.children[::2], LOAD)
        result = ast.Set(items)
        set_location(result, node)
        return result

    def visit_while_stmt(self, node):
        test = self.visit(node.children[1], LOAD)
        body = self.visit(node.children[3])
        if len(node.children) == 7:
            orelse = self.visit(node.children[6])
        else:
            orelse = None
        result = ast.While(test, body, orelse)
        set_location(result, node.children[0].start, node.children[2].end)
        return result

    def visit_flow_stmt(self, node):
        return self.visit(node.children[0])

    def visit_break_stmt(self, node):
        result = ast.Break()
        set_location(result, node)
        return result

    def visit_continue_stmt(self, node):
        result = ast.Continue()
        set_location(result, node)
        return result

    def visit_return_stmt(self, node):
        if len(node.children) == 2:
            result = ast.Return(self.visit(node.children[1], LOAD))
        else:
            result = ast.Return(None)
        set_location(result, node)
        return result

    def visit_raise_stmt(self, node):
        result = ast.Raise()
        set_location(result, node)
        if len(node.children) == 1:
            return result
        result.exc = self.visit(node.children[1], LOAD)
        if len(node.children) > 3:
            if is_token(node.children[2], "from"):
                result.cause = self.visit(node.children[3], LOAD)
            else:
                result.type = result.exc
                del result.exc
                result.inst = self.visit(node.children[3], LOAD)
                if len(node.children) == 6:
                    result.tback = self.visit(node.children[5], LOAD)
        return result

    def visit_yield_stmt(self, node):
        result = ast.Expr(self.visit(node.children[0], LOAD))
        set_location(result, node)
        return result

    def visit_yield_expr(self, node, ctx):
        if ctx is not LOAD:
            context_error(node)
        if len(node.children) == 1:
            result = ast.Yield(None)
        else:
            if is_token(node.children[1].children[0], "from"):
                result = ast.YieldFrom(self.visit(node.children[1].children[1], LOAD))
            else:
                result = ast.Yield(self.visit(node.children[1].children[0], LOAD))
        set_location(result, node)
        return result

    def visit_try_stmt(self, node):
        body = self.visit(node.children[2])
        index = 3
        handlers = []
        while len(node.children) > index and not hasattr(node.children[index], "value"):
            #Except block.
            type, name = self.visit(node.children[index])
            handler_body = self.visit(node.children[index+2])
            handler = ast.ExceptStmt(type, name, handler_body)
            set_location(handler, node.children[index].start , node.children[index+1].end)
            handlers.append(handler)
            index += 3
        if len(node.children) > index and is_token(node.children[index], "else"):
            orelse = self.visit(node.children[index+2])
        else:
            orelse = []
        if is_token(node.children[-3], "finally"):
            finalbody = self.visit(node.children[-1])
        else:
            finalbody = []
        result = ast.Try(body, orelse, handlers, finalbody)
        set_location(result, node.start, node.children[1].end)
        return result

    def visit_except_clause(self, node):
        type, name = None, None
        if len(node.children) > 1:
            type = self.visit(node.children[1], LOAD)
        if len(node.children) > 3:
            name = self.visit(node.children[3], STORE)
        return type, name

    def visit_del_stmt(self, node):
        if len(node.children) > 1:
            result = ast.Delete(self._visit_list(node.children[1].children[::2], DEL))
        else:
            result = ast.Delete([])
        set_location(result, node)
        return result

    visit_subscriptlist = visit_testlist
    visit_testlist1 = visit_testlist

    def visit_subscript(self, node, ctx):
        if len(node.children) == 1 and not is_token(node.children[0], ":"):
            return self.visit(node.children[0], ctx)
        values = [None, None, None]
        index = 0
        for child in node.children:
            if is_token(child, ":"):
                index += 1
            else:
                values[index] = self.visit(child, LOAD)
        result = ast.Slice(*values)
        set_location(result, node)
        return result

    def visit_sliceop(self, node, ctx):
        if ctx is not LOAD:
            context_error(node)
        if len(node.children) == 2:
            return self.visit(node.children[1], LOAD)
        else:
            return None

    def visit_assert_stmt(self, node):
        test = self.visit(node.children[1], LOAD)
        if len(node.children) > 2:
            msg = self.visit(node.children[3], LOAD)
        else:
            msg = None
        result = ast.Assert(test, msg)
        set_location(result, node)
        return result

    def visit_for_stmt(self, node, is_async=False):
        target = self.visit(node.children[1], STORE)
        iter = self.visit(node.children[3], LOAD)
        body = self.visit(node.children[5])
        if len(node.children) == 9:
            orelse = self.visit(node.children[8])
        else:
            orelse = None
        result = ast.For(target, iter, body, orelse)
        result.is_async = is_async
        set_location(result, node.children[0].start, node.children[4].end)
        return result

    def visit_global_stmt(self, node):
        cls = ast.Global if node.children[0].value == "global" else ast.Nonlocal
        names = [child.value for child in node.children[1::2]]
        result = cls(names)
        set_location(result, node)
        return result

    def visit_lambdef(self, node, ctx):
        if ctx is not LOAD:
            context_error(node)
        test = self.visit(node.children[-1], LOAD)
        stmt = ast.Return(test)
        set_location(stmt, node.children[-1])
        if is_token(node.children[1], ":"):
            args, vararg, kwonlyargs, kwarg = [], None, [], None
        else:
            args, vararg, kwonlyargs, kwarg = self._get_parameters(node.children[1])
        func = ast.Function("lambda", [], args, vararg, kwonlyargs, kwarg, [stmt], False)
        set_location(func, node)
        if is_token(node.children[1], ":"):
            args = ast.arguments([], [], [], None, None, [])
        else:
            args = self._get_defaults_and_annotations(node.children[1])
        result = ast.Lambda(args, func)
        set_location(result, node)
        return result

    visit_old_lambdef = visit_lambdef

    visit_vfpdef = visit_tfpdef

    def visit_vname(self, node, ctx):
        if ctx is PARAM:
            child = node.children[0]
            return make_name(child.value, ctx, child.start, child.end)
        else:
            return None

    def visit_star_expr(self, node, ctx):
        result = ast.Starred(self.visit(node.children[1], ctx), ctx)
        set_location(result, node)
        return result

    def visit_with_stmt(self, node, is_async=False):
        body = self.visit(node.children[-1])
        for item in node.children[-3:0:-2]:
            ctx_mngr, opt_vars = self.visit(item)
            withstmt = ast.With(ctx_mngr, opt_vars, body)
            set_location(withstmt, item)
            body = [withstmt]
        set_location(withstmt, node.children[0].start, node.children[-2].end)
        withstmt.is_async = is_async
        return withstmt

    def visit_with_item(self, node):
        ctx_mngr = self.visit(node.children[0], LOAD)
        if len(node.children) == 1:
            return ctx_mngr, None
        else:
            return ctx_mngr, self.visit(node.children[2], STORE)

    def visit_async_stmt(self, node):
        return self.visit(node.children[1], True)

    visit_async_funcdef = visit_async_stmt

    def visit_print_stmt(self, node):
        if len(node.children) > 1 and is_token(node.children[1], ">>"):
            dest = self.visit(node.children[2], LOAD)
            items = node.children[4::2]
        else:
            dest = None
            items = node.children[1::2]
        values = self._visit_list(items, LOAD)
        nl = not is_token(node.children[-1], ",")
        result = ast.Print(dest, values, nl)
        set_location(result, node)
        return result

    def visit_exec_stmt(self, node):
        body = self.visit(node.children[1], LOAD)
        globals, locals = None, None
        if len(node.children) > 3:
            globals = self.visit(node.children[3], LOAD)
        if len(node.children) > 5:
            locals = self.visit(node.children[5], LOAD)
        result = ast.Exec(body, globals, locals)
        set_location(result, node)
        return result

    def visit_special_operation(self, node, ctx):
        if ctx is not LOAD:
            context_error(node)
        name = node.children[0].value
        if len(node.children) == 3:
            args = []
        else:
            args = self._visit_list(node.children[2].children[::2], LOAD)
        result = ast.SpecialOperation(name, args)
        set_location(result, node)
        return result

    def visit_string(self, node, ctx):

        def convert_parts_to_expr():
            if not current_parts:
                return None
            if len(current_parts) == 1:
                string = ast.Str(current_parts[0].s, current_parts[0].prefix, None)
            else:
                # Our string parts may be any combination of byte and unicode
                # strings, as this is valid in Python 2. We therefore decode
                # the strings into unicode before concatenating.
                text = "".join(decode_str(p.s) for p in current_parts)
                string = ast.Str(text, current_parts[0].prefix, current_parts[:])
            start = current_parts[0].lineno, current_parts[0].col_offset
            set_location(string, start, current_parts[-1]._end)
            current_parts[:] = []
            return string

        if ctx is not LOAD:
            context_error(node)
        parts = []
        for p in self._visit_list(node.children, LOAD):
            if isinstance(p, list):
                parts.extend(p)
            else:
                parts.append(p)
        current_parts = []
        exprs = []
        for part in parts:
            if part is None:
                #Conversion -- currently ignored.
                pass
            elif isinstance(part, ast.StringPart):
                current_parts.append(part)
            else:
                assert isinstance(part, ast.expr), part
                string = convert_parts_to_expr()
                if string:
                    exprs.append(string)
                exprs.append(part)
        string = convert_parts_to_expr()
        if string:
            exprs.append(string)
        if len(exprs) == 1:
            return exprs[0]
        result = ast.JoinedStr(exprs)
        set_location(result, node)
        return result

    def visit_fstring_part(self, node, ctx):
        nodes_to_visit = []
        for node in node.children:
            if node.name == 'format_specifier':
                # Flatten format_specifiers first
                nodes_to_visit += [ n for n in node.children if not n.name == 'FSTRING_SPEC' ]
            else:
                nodes_to_visit += [node]

        return self._visit_list(nodes_to_visit, ctx)

    def visit_format_specifier(self, node, ctx):
        # This will currently never be visited because of the above flattening
        assert ctx is LOAD
        #Currently ignored
        return None

    def visit_CONVERSION(self, node, ctx):
        return None

    def visit_COLON(self, node, ctx):
        return None

    def visit_EQUAL(self, node, ctx):
        return None

    def visit_FSTRING_START(self, node, ctx):
        string = self.visit_STRING(node, ctx)
        # Push the current prefix onto the prefix stack
        self.outer_prefix_stack.append(string.prefix)
        return string

    def visit_FSTRING_END(self, node, ctx):
        string = self.visit_STRING(node, ctx)
        # We're done with this f-string, so pop its prefix off the prefix stack
        self.outer_prefix_stack.pop()
        return string

    visit_FSTRING_MID = visit_STRING

# In the following function, we decode to `latin-1` in order to preserve
# the byte values present in the string. This is an undocumented feature of
# this encoding. See also the `test_python_sanity.py` test file in `/tests`.

def decode_str(s):
    if isinstance(s, bytes):
        return str(s, 'latin-1')
    else:
        return s

def context_error(node):
    s = SyntaxError("Invalid context")
    s.lineno, s.offset = node.start
    raise s

def is_token(node, text):
    '''Holds if `node` is a token (terminal) and its textual value is `text`'''
    return hasattr(node, "value") and node.value == text

def get_node_value(node):
    '''Get the value from a NAME node,
        stripping redundant CPT nodes'''
    while hasattr(node, "children"):
        assert len(node.children) == 1
        node = node.children[0]
    return node.value

#Mapping from comparison operator strings to ast classes.
COMP_OP_CLASSES = {
    "<": ast.Lt,
    "<=": ast.LtE,
    ">": ast.Gt,
    ">=": ast.GtE,
    "==": ast.Eq,
    "<>": ast.NotEq,
    "!=": ast.NotEq,
    "in": ast.In,
    "not in": ast.NotIn,
    "is": ast.Is,
    "is not": ast.IsNot,
}

#Mapping from multiplicative operator strings to ast classes.
TERM_OP_CLASSES = {
    '*': ast.Mult,
    '/': ast.Div,
    '%': ast.Mod,
    '//': ast.FloorDiv,
    '@': ast.MatMult,
}

#Mapping from additive operator strings to ast classes.
FACTOR_OP_CLASSES = {
    '+': ast.UAdd,
    '-': ast.USub,
    '~': ast.Invert,
}

#Mapping from assignment operator strings to ast classes.
AUG_ASSIGN_OPS = {
    '+=': ast.Add,
    '-=': ast.Sub,
    '*=': ast.Mult,
    '/=': ast.Div,
    '%=': ast.Mod,
    '&=': ast.BitAnd,
    '|=': ast.BitOr,
    '^=': ast.BitXor,
    '<<=': ast.LShift,
    '>>=': ast.RShift,
    '**=': ast.Pow,
    '//=': ast.FloorDiv,
    '@=': ast.MatMult,
}

def make_name(name, ctx, start, end):
    '''Create a `Name` ast node'''
    variable = ast.Variable(name)
    node = ast.Name(variable, ctx)
    set_location(node, start, end)
    return node

def set_location(astnode, cptnode_or_start, end=None):
    '''Set the location of `astnode` from
    either the CPT node or pair of locations.
    '''
    if end is None:
        astnode.lineno, astnode.col_offset = cptnode_or_start.start
        astnode._end = cptnode_or_start.end
    else:
        astnode.lineno, astnode.col_offset = cptnode_or_start
        astnode._end = end

def split_full_prefix(s):
    """Splits a prefix (or a string starting with a prefix) into prefix and quote parts."""
    quote_start = 0
    # First, locate the end of the prefix (and the start of the quotes)
    while s[quote_start] not in "'\"}":
        quote_start += 1
    # Next, find the end of the quotes. This is either one character past `quote_start`, or three
    # (for triple-quoted strings).
    if s[quote_start:quote_start + 3] in ("'''",'"""'):
        prefix_end = quote_start + 3
    else:
        prefix_end = quote_start + 1

    return s[:quote_start], s[quote_start:prefix_end]


def split_string(s, outer_prefix):
    """Splits a string into prefix, quotes, and content."""
    s_prefix, s_quotes = split_full_prefix(s)

    quote_start = len(s_prefix)
    prefix_end = quote_start + len(s_quotes)

    # If the string starts with `}`, it is a non-inital string part of an f-string. In this case we
    # must use the prefix and quotes from the outer f-string.
    if s[0] == '}':
        prefix, quotes = split_full_prefix(outer_prefix)
    else:
        prefix, quotes = s_prefix, s_quotes

    # The string either ends with a `{` (if it comes before an interpolation inside an f-string)
    # or else it ends with the same quotes as it begins with.
    if s[-1] == "{":
        content = s[prefix_end:-1]
    else:
        content = s[prefix_end:-len(quotes)]

    return prefix.lower(), quotes, content

def get_text(s, outer_prefix):
    """Returns a cleaned-up text version of the string, normalizing the quotes and removing any
    format string marker."""
    prefix, quotes, content = split_string(s, outer_prefix)
    return prefix.strip("fF") + quotes + content + quotes

def parse_string(s, logger, outer_prefix):
    '''Gets the prefix and escaped string text'''
    prefix, quotes, content = split_string(s, outer_prefix)
    saved_content = content
    try:
        ends_with_illegal_character = False
        # If the string ends with the same quote character as the outer quotes (and/or backslashes)
        # (e.g. the first string part of `f"""hello"{0}"""`), we must take care to not accidently create
        # the ending quotes at the wrong place. (`literal_eval` would be unhappy with `"""hello""""`
        # as an input.) To do this, we insert an extra space at the end (that we then must remember
        # to remove later on).
        if content.endswith(quotes[0]) or content.endswith('\\'):
            ends_with_illegal_character = True
            content = content + " "
        text = prefix.strip("fF") + quotes + content + quotes
        s = literal_eval(text)
    except Exception as ex:
        # Something has gone wrong, but we still have the original form - Should be OK.
        logger.warning("Unable to parse string %s: %s", text, ex)
        logger.traceback()
        ends_with_illegal_character = False
        s = saved_content
    if isinstance(s, bytes):
        try:
            s = s.decode(sys.getfilesystemencoding())
        except UnicodeDecodeError:
            s = decode_str(s)
    if ends_with_illegal_character:
        s = s[:-1]
    return prefix + quotes, s

ESCAPES = ""

def get_numeric_value(node):
    '''Gets numeric value from a CPT leaf node.'''
    value = node.value
    value = value.replace("_", "")
    chars = set(value.lower())
    try:
        if u'.' in chars or u'e' in chars or u'j' in chars:
            # Probable float or hex or imaginary
            return literal_eval(value)
        if len(value) > 1 and value[0] == u'0' and value[1] not in u'boxlBOXL':
            # Old-style octal
            value = u'0o' + value[1:]
        if value[-1] in u'lL':
            return literal_eval(value[:-1])
        return literal_eval(value)
    except ValueError:
        raise ParseError("Not a valid numeric value", node.type, node.value, (node.start, node.end))

#This rewriting step is performed separately for two reasons.
# 1. It is complicated
# 2. In future, we may want to make the AST more like the syntax and less like the semantics.
#    Keeping step separate should make that a bit easier.
def rewrite_comp(node):
    if hasattr(node, "function"):
        return
    gens = node.generators
    if hasattr(node, "elt"):
        elt = node.elt
        del node.elt
    else:
        elt = ast.Tuple([node.value, node.key], LOAD)
        elt.lineno = node.key.lineno
        elt.col_offset = node.key.col_offset
        elt._end = node.value._end
        del node.key
        del node.value
    y = ast.Yield(elt)
    copy_location(elt, y)
    stmt = ast.Expr(y)
    copy_location(elt, stmt)
    for gen in reversed(gens[1:]):
        for if_ in gen.ifs:
            stmt = ast.If(if_, [stmt], None)
            copy_location(if_, stmt)
        stmt = ast.For(gen.target, gen.iter, [stmt], None)
        if getattr(gen, "is_async", False):
            stmt.is_async = True
        copy_location(node, stmt)
    for if_ in gens[0].ifs:
        stmt = ast.If(if_, [stmt], None)
        copy_location(if_, stmt)
    p0 = ".0"
    pvar = ast.Variable(p0)
    arg = ast.Name(pvar, LOAD)
    copy_location(node, arg)
    stmt = ast.For(gens[0].target, arg, [stmt], None)
    if getattr(gens[0], "is_async", False):
        stmt.is_async = True
    copy_location(node, stmt)
    pvar = ast.Variable(p0)
    arg = ast.Name(pvar, PARAM)
    copy_location(node, arg)
    function = ast.Function(COMP_NAMES[type(node).__name__], [],[arg], None, None, None, [ stmt ])
    copy_location(node, function)
    node.function = function
    node.iterable = gens[0].iter
    del node.generators


COMP_NAMES = {
    'GeneratorExp' : 'genexpr',
    'DictComp' : 'dictcomp',
    'ListComp' : 'listcomp',
    'SetComp' : 'setcomp'
}

def copy_location(src, dest):
    '''Copy location from `src` to `dest`'''
    dest.lineno = src.lineno
    dest.col_offset = src.col_offset
    dest._end = src._end

def convert(logger, cpt):
    '''Covert concrete parse tree as specified by blib2to3/Grammar.txt
    to the AST specified by semmle/python/master.py
    '''
    return Convertor(logger).visit(cpt)
