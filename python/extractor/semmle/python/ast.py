'''
Abstract syntax tree classes.
This is designed to replace the stdlib ast module.
Unlike the stdlib module, it is version independent.

The classes in this file are based on the corresponding types in the cpython interpreter, copyright PSF.
'''


class AstBase(object):
    __slots__ = "lineno", "col_offset", "_end",

    def __repr__(self):
        args = ",".join(repr(getattr(self, field, None)) for field in self.__slots__)
        return "%s(%s)" % (self.__class__.__name__, args)

class Class(AstBase):
    'AST node representing a class definition'

    __slots__ = "name", "body",

    def __init__(self, name, body):
        self.name = name
        self.body = body


class Function(AstBase):
    'AST node representing a function definition'

    __slots__ = "is_async", "name", "type_parameters", "args", "vararg", "kwonlyargs", "kwarg", "body",

    def __init__(self, name, type_parameters, args, vararg, kwonlyargs, kwarg, body, is_async=False):
        self.name = name
        self.type_parameters = type_parameters
        self.args = args
        self.vararg = vararg
        self.kwonlyargs = kwonlyargs
        self.kwarg = kwarg
        self.body = body
        self.is_async = is_async


class Module(AstBase):

    def __init__(self, body):
        self.body = body


class StringPart(AstBase):
    '''Implicitly concatenated part of string literal'''

    __slots__ = "prefix", "text", "s",

    def __init__(self, prefix, text, s):
        self.prefix = prefix
        self.text = text
        self.s = s

class alias(AstBase):
    __slots__ = "value", "asname",

    def __init__(self, value, asname):
        self.value = value
        self.asname = asname


class arguments(AstBase):
    __slots__ = "defaults", "kw_defaults", "annotations", "varargannotation", "kwargannotation", "kw_annotations",

    def __init__(self, defaults, kw_defaults, annotations, varargannotation, kwargannotation, kw_annotations):
        if len(defaults) != len(annotations):
            raise AssertionError('len(defaults) != len(annotations)')
        if len(kw_defaults) != len(kw_annotations):
            raise AssertionError('len(kw_defaults) != len(kw_annotations)')
        self.kw_defaults = kw_defaults
        self.defaults = defaults
        self.annotations = annotations
        self.varargannotation = varargannotation
        self.kwargannotation = kwargannotation
        self.kw_annotations = kw_annotations


class boolop(AstBase):
    pass

class cmpop(AstBase):
    pass

class comprehension(AstBase):
    __slots__ = "is_async", "target", "iter", "ifs",

    def __init__(self, target, iter, ifs, is_async=False):
        self.target = target
        self.iter = iter
        self.ifs = ifs
        self.is_async = is_async

class dict_item(AstBase):
    pass

class type_parameter(AstBase):
    pass

class expr(AstBase):
    __slots__ = "parenthesised",

class expr_context(AstBase):
    pass

class operator(AstBase):
    pass

class stmt(AstBase):
    pass

class unaryop(AstBase):
    pass

class pattern(AstBase):
    __slots__ = "parenthesised",

class And(boolop):
    pass

class Or(boolop):
    pass

class Eq(cmpop):
    pass

class Gt(cmpop):
    pass

class GtE(cmpop):
    pass

class In(cmpop):
    pass

class Is(cmpop):
    pass

class IsNot(cmpop):
    pass

class Lt(cmpop):
    pass

class LtE(cmpop):
    pass

class NotEq(cmpop):
    pass

class NotIn(cmpop):
    pass

class DictUnpacking(dict_item):
    __slots__ = "value",

    def __init__(self, value):
        self.value = value


class KeyValuePair(dict_item):
    __slots__ = "key", "value",

    def __init__(self, key, value):
        self.key = key
        self.value = value


class keyword(dict_item):
    __slots__ = "arg", "value",

    def __init__(self, arg, value):
        self.arg = arg
        self.value = value


class AssignExpr(expr):
    __slots__ = "target", "value",

    def __init__(self, value, target):
        self.value = value
        self.target = target


class Attribute(expr):
    __slots__ = "value", "attr", "ctx",

    def __init__(self, value, attr, ctx):
        self.value = value
        self.attr = attr
        self.ctx = ctx


class Await(expr):
    __slots__ = "value",

    def __init__(self, value):
        self.value = value


class BinOp(expr):
    __slots__ = "left", "op", "right",

    def __init__(self, left, op, right):
        self.left = left
        self.op = op
        self.right = right


class BoolOp(expr):
    __slots__ = "op", "values",

    def __init__(self, op, values):
        self.op = op
        self.values = values


class Bytes(expr):
    __slots__ = "s", "prefix", "implicitly_concatenated_parts",

    def __init__(self, s, prefix, implicitly_concatenated_parts):
        self.s = s
        self.prefix = prefix
        self.implicitly_concatenated_parts = implicitly_concatenated_parts


class Call(expr):
    __slots__ = "func", "positional_args", "named_args",

    def __init__(self, func, positional_args, named_args):
        self.func = func
        self.positional_args = positional_args
        self.named_args = named_args


class ClassExpr(expr):
    'AST node representing class creation'

    __slots__ = "name", "type_parameters", "bases", "keywords", "inner_scope",

    def __init__(self, name, type_parameters, bases, keywords, inner_scope):
        self.name = name
        self.type_parameters = type_parameters
        self.bases = bases
        self.keywords = keywords
        self.inner_scope = inner_scope


class Compare(expr):
    __slots__ = "left", "ops", "comparators",

    def __init__(self, left, ops, comparators):
        self.left = left
        self.ops = ops
        self.comparators = comparators


class Dict(expr):
    __slots__ = "items",

    def __init__(self, items):
        self.items = items


class DictComp(expr):
    __slots__ = "key", "value", "generators", "function", "iterable",

    def __init__(self, key, value, generators):
        self.key = key
        self.value = value
        self.generators = generators


class Ellipsis(expr):
    pass

class Filter(expr):
    '''Filtered expression in a template'''

    __slots__ = "value", "filter",

    def __init__(self, value, filter):
        self.value = value
        self.filter = filter


class FormattedValue(expr):
    __slots__ = "value", "conversion", "format_spec",

    def __init__(self, value, conversion, format_spec):
        self.value = value
        self.conversion = conversion
        self.format_spec = format_spec


class FunctionExpr(expr):

    'AST node representing function creation'

    __slots__ = "name", "args", "returns", "inner_scope",

    def __init__(self, name, args, returns, inner_scope):
        self.name = name
        self.args = args
        self.returns = returns
        self.inner_scope = inner_scope


class GeneratorExp(expr):
    __slots__ = "elt", "generators", "function", "iterable",

    def __init__(self, elt, generators):
        self.elt = elt
        self.generators = generators


class IfExp(expr):
    __slots__ = "test", "body", "orelse",

    def __init__(self, test, body, orelse):
        self.test = test
        self.body = body
        self.orelse = orelse


class ImportExpr(expr):
    '''AST node representing module import
    (roughly equivalent to the runtime call to __import__)'''

    __slots__ = "level", "name", "top",

    def __init__(self, level, name, top):
        self.level = level
        self.name = name
        self.top = top


class ImportMember(expr):
    '''AST node representing 'from import'. Similar to Attribute access,
       but during import'''

    __slots__ = "module", "name",

    def __init__(self, module, name):
        self.module = module
        self.name = name


class JoinedStr(expr):
    __slots__ = "values",

    def __init__(self, values):
        self.values = values


class Lambda(expr):
    __slots__ = "args", "inner_scope",

    def __init__(self, args, inner_scope):
        self.args = args
        self.inner_scope = inner_scope


class List(expr):
    __slots__ = "elts", "ctx",

    def __init__(self, elts, ctx):
        self.elts = elts
        self.ctx = ctx


class ListComp(expr):
    __slots__ = "elt", "generators", "function", "iterable",

    def __init__(self, elt, generators):
        self.elt = elt
        self.generators = generators

class Match(stmt):
    __slots__ = "subject", "cases",

    def __init__(self, subject, cases):
        self.subject = subject
        self.cases = cases

class Case(stmt):
    __slots__ = "pattern", "guard", "body",

    def __init__(self, pattern, guard, body):
        self.pattern = pattern
        self.guard = guard
        self.body = body

class Guard(expr):
    __slots__ = "test",

    def __init__(self, test):
        self.test = test

class MatchAsPattern(pattern):
    __slots__ = "pattern", "alias",

    def __init__(self, pattern, alias):
        self.pattern = pattern
        self.alias = alias

class MatchOrPattern(pattern):
    __slots__ = "patterns",

    def __init__(self, patterns):
        self.patterns = patterns

class MatchLiteralPattern(pattern):
    __slots__ = "literal",

    def __init__(self, literal):
        self.literal = literal

class MatchCapturePattern(pattern):
    __slots__ = "variable",

    def __init__(self, variable):
        self.variable = variable

class MatchWildcardPattern(pattern):
    __slots__ = []

class MatchValuePattern(pattern):
    __slots__ = "value",

    def __init__(self, value):
        self.value = value

class MatchSequencePattern(pattern):
    __slots__ = "patterns",

    def __init__(self, patterns):
        self.patterns = patterns

class MatchStarPattern(pattern):
    __slots__ = "target",

    def __init__(self, target):
        self.target = target

class MatchMappingPattern(pattern):
    __slots__ = "mappings",

    def __init__(self, mappings):
        self.mappings = mappings

class MatchDoubleStarPattern(pattern):
    __slots__ = "target",

    def __init__(self, target):
        self.target = target

class MatchKeyValuePattern(pattern):
    __slots__ = "key", "value",

    def __init__(self, key, value):
        self.key = key
        self.value = value

class MatchClassPattern(pattern):
    __slots__ = "class_name", "positional", "keyword",

    def __init__(self, class_name, positional, keyword):
        self.class_name = class_name
        self.positional = positional
        self.keyword = keyword

class MatchKeywordPattern(pattern):
    __slots__ = "attribute", "value",

    def __init__(self, attribute, value):
        self.attribute = attribute
        self.value = value

class Name(expr):
    __slots__ = "variable", "ctx",

    def __init__(self, variable, ctx):
        self.variable = variable
        self.ctx = ctx

    @property
    def id(self):
        return self.variable.id

class Num(expr):
    __slots__ = "n", "text",

    def __init__(self, n, text):
        self.n = n
        self.text = text

class ParamSpec(type_parameter):
    __slots__ = "name", "default",

    def __init__(self, name, default):
        self.name = name
        self.default = default



class PlaceHolder(expr):
    '''PlaceHolder variable in template ($name)'''

    __slots__ = "variable", "ctx",

    def __init__(self, variable, ctx):
        self.variable = variable
        self.ctx = ctx

    @property
    def id(self):
        return self.variable.id

class Repr(expr):
    __slots__ = "value",

    def __init__(self, value):
        self.value = value


class Set(expr):
    __slots__ = "elts",

    def __init__(self, elts):
        self.elts = elts


class SetComp(expr):
    __slots__ = "elt", "generators", "function", "iterable",

    def __init__(self, elt, generators):
        self.elt = elt
        self.generators = generators


class Slice(expr):
    '''AST node for a slice as a subclass of expr to simplify Subscripts'''

    __slots__ = "start", "stop", "step",

    def __init__(self, start, stop, step):
        self.start = start
        self.stop = stop
        self.step = step


class Starred(expr):
    __slots__ = "value", "ctx",

    def __init__(self, value, ctx):
        self.value = value
        self.ctx = ctx


class Str(expr):
    __slots__ = "s", "prefix", "implicitly_concatenated_parts",

    def __init__(self, s, prefix, implicitly_concatenated_parts):
        self.s = s
        self.prefix = prefix
        self.implicitly_concatenated_parts = implicitly_concatenated_parts


class Subscript(expr):
    __slots__ = "value", "index", "ctx",

    def __init__(self, value, index, ctx):
        self.value = value
        self.index = index
        self.ctx = ctx


class TemplateDottedNotation(expr):
    '''Unified dot notation expression in a template'''

    __slots__ = "value", "attr", "ctx",

    def __init__(self, value, attr, ctx):
        self.value = value
        self.attr = attr
        self.ctx = ctx


class Tuple(expr):
    __slots__ = "elts", "ctx",

    def __init__(self, elts, ctx):
        self.elts = elts
        self.ctx = ctx


class TypeAlias(stmt):
    __slots__ = "name", "type_parameters", "value",

    def __init__(self, name, type_parameters, value):
        self.name = name
        self.type_parameters = type_parameters
        self.value = value

class TypeVar(type_parameter):
    __slots__ = "name", "bound", "default"

    def __init__(self, name, bound, default):
        self.name = name
        self.bound = bound
        self.default = default

class TypeVarTuple(type_parameter):
    __slots__ = "name", "default",

    def __init__(self, name, default):
        self.name = name
        self.default = default

class UnaryOp(expr):
    __slots__ = "op", "operand",

    def __init__(self, op, operand):
        self.op = op
        self.operand = operand


class Yield(expr):
    __slots__ = "value",

    def __init__(self, value):
        self.value = value


class YieldFrom(expr):
    __slots__ = "value",

    def __init__(self, value):
        self.value = value


class SpecialOperation(expr):
    __slots__ = "name", "arguments"

    def __init__(self, name, arguments):
        self.name = name
        self.arguments = arguments


class AugLoad(expr_context):
    pass

class AugStore(expr_context):
    pass

class Del(expr_context):
    pass

class Load(expr_context):
    pass

class Param(expr_context):
    pass

class Store(expr_context):
    pass

class Add(operator):
    pass

class BitAnd(operator):
    pass

class BitOr(operator):
    pass

class BitXor(operator):
    pass

class Div(operator):
    pass

class FloorDiv(operator):
    pass

class LShift(operator):
    pass

class MatMult(operator):
    pass

class Mod(operator):
    pass

class Mult(operator):
    pass

class Pow(operator):
    pass

class RShift(operator):
    pass

class Sub(operator):
    pass

class AnnAssign(stmt):
    __slots__ = "value", "annotation", "target",

    def __init__(self, value, annotation, target):
        self.value = value
        self.annotation = annotation
        self.target = target


class Assert(stmt):
    __slots__ = "test", "msg",

    def __init__(self, test, msg):
        self.test = test
        self.msg = msg


class Assign(stmt):
    __slots__ = "targets", "value",

    def __init__(self, value, targets):
        self.value = value
        assert isinstance(targets, list)
        self.targets = targets


class AugAssign(stmt):
    __slots__ = "operation",

    def __init__(self, operation):
        self.operation = operation


class Break(stmt):
    pass

class Continue(stmt):
    pass

class Delete(stmt):
    __slots__ = "targets",

    def __init__(self, targets):
        self.targets = targets


class ExceptStmt(stmt):
    '''AST node for except handler, as a subclass of stmt in order
       to better support location and flow control'''

    __slots__ = "type", "name", "body",

    def __init__(self, type, name, body):
        self.type = type
        self.name = name
        self.body = body


class ExceptGroupStmt(stmt):
    '''AST node for except* handler, as a subclass of stmt in order
       to better support location and flow control'''

    __slots__ = "type", "name", "body",

    def __init__(self, type, name, body):
        self.type = type
        self.name = name
        self.body = body


class Exec(stmt):
    __slots__ = "body", "globals", "locals",

    def __init__(self, body, globals, locals):
        self.body = body
        self.globals = globals
        self.locals = locals


class Expr(stmt):
    __slots__ = "value",

    def __init__(self, value):
        self.value = value


class For(stmt):
    __slots__ = "is_async", "target", "iter", "body", "orelse",

    def __init__(self, target, iter, body, orelse, is_async=False):
        self.target = target
        self.iter = iter
        self.body = body
        self.orelse = orelse
        self.is_async = is_async


class Global(stmt):
    __slots__ = "names",

    def __init__(self, names):
        self.names = names


class If(stmt):
    __slots__ = "test", "body", "orelse",

    def __init__(self, test, body, orelse):
        self.test = test
        self.body = body
        self.orelse = orelse


class Import(stmt):
    __slots__ = "names",

    def __init__(self, names):
        self.names = names


class ImportFrom(stmt):
    __slots__ = "module",

    def __init__(self, module):
        self.module = module


class Nonlocal(stmt):
    __slots__ = "names",

    def __init__(self, names):
        self.names = names


class Pass(stmt):
    pass

class Print(stmt):
    __slots__ = "dest", "values", "nl",

    def __init__(self, dest, values, nl):
        self.dest = dest
        self.values = values
        self.nl = nl


class Raise(stmt):
    __slots__ = "exc", "cause", "type", "inst", "tback",


class Return(stmt):
    __slots__ = "value",

    def __init__(self, value):
        self.value = value


class TemplateWrite(stmt):
    '''Template text'''

    __slots__ = "value",

    def __init__(self, value):
        self.value = value


class Try(stmt):
    __slots__ = "body", "orelse", "handlers", "finalbody",

    def __init__(self, body, orelse, handlers, finalbody):
        self.body = body
        self.orelse = orelse
        self.handlers = handlers
        self.finalbody = finalbody


class While(stmt):
    __slots__ = "test", "body", "orelse",

    def __init__(self, test, body, orelse):
        self.test = test
        self.body = body
        self.orelse = orelse


class With(stmt):
    __slots__ = "is_async", "context_expr", "optional_vars", "body",

    def __init__(self, context_expr, optional_vars, body, is_async=False):
        self.context_expr = context_expr
        self.optional_vars = optional_vars
        self.body = body
        self.is_async = is_async


class Invert(unaryop):
    pass

class Not(unaryop):
    pass

class UAdd(unaryop):
    pass

class USub(unaryop):
    pass


class Variable(object):
    'A variable'

    def __init__(self, var_id, scope = None):
        assert isinstance(var_id, str), type(var_id)
        self.id = var_id
        self.scope = scope

    def __repr__(self):
        return 'Variable(%r, %r)' % (self.id, self.scope)

    def __eq__(self, other):
        if type(other) is not Variable:
            return False
        if self.scope is None or other.scope is None:
            raise TypeError("Scope not set")
        return self.scope == other.scope and self.id == other.id

    def __ne__(self, other):
        return not self == other

    def __hash__(self):
        if self.scope is None:
            raise TypeError("Scope not set")
        return 391246 ^ hash(self.id) ^ hash(self.scope)

    def is_global(self):
        return isinstance(self.scope, Module)

def iter_fields(node):
    for name in node.__slots__:
        if hasattr(node, name):
            yield name, getattr(node, name)
