#Much of the information in this file is hardcoded into parser.
#Modify with care and test well.
#It should be relatively safe to add fields.


from semmle.python.AstMeta import Node, PrimitiveNode, ClassNode, UnionNode, ListNode
from semmle.python.AstMeta import build_node_relations as _build_node_relations

string = PrimitiveNode('str', 'string',  'varchar(1)', 'string')
bytes_ = PrimitiveNode('bytes', 'string',  'varchar(1)')

location = PrimitiveNode('location', '@location', 'unique int')
variable = PrimitiveNode('variable', '@py_variable', 'int')

int_ = PrimitiveNode('int', 'int', 'int')
bool_ = PrimitiveNode('bool', 'boolean', 'boolean')
number = PrimitiveNode('number', 'string',  'varchar(1)')

Module = ClassNode('Module')
Class = ClassNode('Class')
Function = ClassNode('Function')

alias = ClassNode('alias')
arguments = ClassNode('arguments', None, 'parameters definition')
boolop = ClassNode('boolop', None, 'boolean operator')
cmpop = ClassNode('cmpop', None, 'comparison operator')
comprehension = ClassNode('comprehension')
comprehension.field('location', location)
expr = ClassNode('expr', None, 'expression')
expr.field('location', location)
expr.field('parenthesised', bool_, 'parenthesised')
expr_context = ClassNode('expr_context', None, 'expression context')
operator = ClassNode('operator')
stmt = ClassNode('stmt', None, 'statement')
stmt.field('location', location)
unaryop = ClassNode('unaryop', None, 'unary operation')
pattern = ClassNode('pattern')
pattern.field('location', location)
pattern.field('parenthesised', bool_, 'parenthesised')
Add = ClassNode('Add', operator, '+')
And = ClassNode('And', boolop, 'and')
Assert = ClassNode('Assert', stmt)
Assign = ClassNode('Assign', stmt, 'assignment')
Attribute = ClassNode('Attribute', expr)
AugAssign = ClassNode('AugAssign', stmt, 'augmented assignment statement')
AugLoad = ClassNode('AugLoad', expr_context, 'augmented-load')
AugStore = ClassNode('AugStore', expr_context, 'augmented-store')
BinOp = ClassNode('BinOp', expr, 'binary')
#Choose a name more consistent with other Exprs.
BinOp.set_name("BinaryExpr")
BitAnd = ClassNode('BitAnd', operator, '&')
BitOr = ClassNode('BitOr', operator, '|')
BitXor = ClassNode('BitXor', operator, '^')
BoolOp = ClassNode('BoolOp', expr, 'boolean')
#Avoid name clash with boolop
BoolOp.set_name('BoolExpr')
Break = ClassNode('Break', stmt)
Bytes = ClassNode('Bytes', expr)
Call = ClassNode('Call', expr)
ClassExpr = ClassNode('ClassExpr', expr, 'class definition')
Compare = ClassNode('Compare', expr)
Continue = ClassNode('Continue', stmt)
Del = ClassNode('Del', expr_context, 'deletion')
Delete = ClassNode('Delete', stmt)
Dict = ClassNode('Dict', expr, 'dictionary')
DictComp = ClassNode('DictComp', expr, 'dictionary comprehension')
Div = ClassNode('Div', operator, '/')
Ellipsis = ClassNode('Ellipsis', expr)
Eq = ClassNode('Eq', cmpop, '==')
ExceptStmt = ClassNode('ExceptStmt', stmt, 'except block')
ExceptGroupStmt = ClassNode('ExceptGroupStmt', stmt, 'except group block')
Exec = ClassNode('Exec', stmt)
Expr_stmt = ClassNode('Expr', stmt)
Expr_stmt.set_name('Expr_stmt')
FloorDiv = ClassNode('FloorDiv', operator, '//')
For = ClassNode('For', stmt)
FunctionExpr = ClassNode('FunctionExpr', expr, 'function definition')
GeneratorExp = ClassNode('GeneratorExp', expr, 'generator')
Global = ClassNode('Global', stmt)
Gt = ClassNode('Gt', cmpop, '>')
GtE = ClassNode('GtE', cmpop, '>=')
If = ClassNode('If', stmt)
IfExp = ClassNode('IfExp', expr, 'if')
Import = ClassNode('Import', stmt)
ImportExpr = ClassNode('ImportExpr', expr, 'import')
ImportMember = ClassNode('ImportMember', expr, 'from import')
ImportFrom = ClassNode('ImportFrom', stmt, 'import * statement')
In = ClassNode('In', cmpop)
Invert = ClassNode('Invert', unaryop, '~')
Is = ClassNode('Is', cmpop)
IsNot = ClassNode('IsNot', cmpop, 'is not')
LShift = ClassNode('LShift', operator, '<<')
Lambda = ClassNode('Lambda', expr)
List = ClassNode('List', expr)
ListComp = ClassNode('ListComp', expr, 'list comprehension')
Load = ClassNode('Load', expr_context)
Lt = ClassNode('Lt', cmpop, '<')
LtE = ClassNode('LtE', cmpop, '<=')
Match = ClassNode('Match', stmt)
#Avoid name clash with regex match
Match.set_name('MatchStmt')
Case = ClassNode('Case', stmt)
Guard = ClassNode('Guard', expr)
MatchAsPattern = ClassNode('MatchAsPattern', pattern)
MatchOrPattern = ClassNode('MatchOrPattern', pattern)
MatchLiteralPattern = ClassNode('MatchLiteralPattern', pattern)
MatchCapturePattern = ClassNode('MatchCapturePattern', pattern)
MatchWildcardPattern = ClassNode('MatchWildcardPattern', pattern)
MatchValuePattern = ClassNode('MatchValuePattern', pattern)
MatchSequencePattern = ClassNode('MatchSequencePattern', pattern)
MatchStarPattern = ClassNode('MatchStarPattern', pattern)
MatchMappingPattern = ClassNode('MatchMappingPattern', pattern)
MatchDoubleStarPattern = ClassNode('MatchDoubleStarPattern', pattern)
MatchKeyValuePattern = ClassNode('MatchKeyValuePattern', pattern)
MatchClassPattern = ClassNode('MatchClassPattern', pattern)
MatchKeywordPattern = ClassNode('MatchKeywordPattern', pattern)
Mod = ClassNode('Mod', operator, '%')
Mult = ClassNode('Mult', operator, '*')
Name = ClassNode('Name', expr)
Nonlocal = ClassNode('Nonlocal', stmt)
Not = ClassNode('Not', unaryop)
NotEq = ClassNode('NotEq', cmpop, '!=')
NotIn = ClassNode('NotIn', cmpop, 'not in')
Num = ClassNode('Num', expr, 'numeric literal')
Or = ClassNode('Or', boolop)
Param = ClassNode('Param', expr_context, 'parameter')
Pass = ClassNode('Pass', stmt)
Pow = ClassNode('Pow', operator, '**')
Print = ClassNode('Print', stmt)
RShift = ClassNode('RShift', operator, '>>')
Raise = ClassNode('Raise', stmt)
Repr = ClassNode('Repr', expr, 'backtick')
Return = ClassNode('Return', stmt)
Set = ClassNode('Set', expr)
SetComp = ClassNode('SetComp', expr, 'set comprehension')
#Add $ to name to prevent doc-gen adding sub type name
Slice = ClassNode('Slice', expr, '$slice')
Starred = ClassNode('Starred', expr)
Store = ClassNode('Store', expr_context)
Str = ClassNode('Str', expr, 'string literal')
Sub = ClassNode('Sub', operator, '-')
Subscript = ClassNode('Subscript', expr)
Try = ClassNode('Try', stmt)
Tuple = ClassNode('Tuple', expr)
UAdd = ClassNode('UAdd', unaryop, '+')
USub = ClassNode('USub', unaryop, '-')
UnaryOp = ClassNode('UnaryOp', expr, 'unary')
#Avoid name clash with 'unaryop'
UnaryOp.set_name('UnaryExpr')
While = ClassNode('While', stmt)
With = ClassNode('With', stmt)
Yield = ClassNode('Yield', expr)
YieldFrom = ClassNode('YieldFrom', expr, 'yield-from')
alias_list = ListNode(alias)
cmpop_list = ListNode(cmpop)
comprehension_list = ListNode(comprehension)
expr_list = ListNode(expr)
stmt_list = ListNode(stmt)
string_list = ListNode(string)
StringPart = ClassNode('StringPart', None, "implicitly concatenated part")
string_parts_list = ListNode(StringPart)
pattern_list = ListNode(pattern)

#Template AST Nodes
TemplateWrite = ClassNode('TemplateWrite', stmt, "template write statement")
TemplateDottedNotation = ClassNode('TemplateDottedNotation', expr, "template dotted notation expression")
Filter = ClassNode("Filter", expr, "template filter expression")
PlaceHolder = ClassNode('PlaceHolder', expr, "template place-holder expression")

Await = ClassNode('Await', expr)
MatMult = ClassNode('MatMult', operator, '@')

scope = UnionNode(Module, Class, Function)
scope.set_name('scope')

dict_item = ClassNode('dict_item')

#DoubleStar in calls fn(**{'a': 1, 'c': 3}, **{'b': 2, 'd': 4}) or dict displays {'a': 1, **{'b': 2, 'd': 4}}
DictUnpacking = ClassNode('DictUnpacking', dict_item, descriptive_name='dictionary unpacking')
KeyValuePair = ClassNode('KeyValuePair', dict_item, descriptive_name='key-value pair')
keyword = ClassNode('keyword', dict_item, descriptive_name='keyword argument')

#Initial name must match that in ast module.
FormattedStringLiteral = ClassNode("JoinedStr", expr, descriptive_name='formatted string literal')
FormattedStringLiteral.set_name("Fstring")

FormattedValue = ClassNode("FormattedValue", expr, descriptive_name='formatted value')

AnnAssign = ClassNode("AnnAssign", stmt, descriptive_name='annotated assignment')

AssignExpr = ClassNode('AssignExpr', expr, "assignment expression")

SpecialOperation = ClassNode('SpecialOperation', expr, "special operation")

type_parameter = ClassNode('type_parameter', descriptive_name='type parameter')
type_parameter.field('location', location)
type_parameter_list = ListNode(type_parameter)

TypeAlias = ClassNode('TypeAlias', stmt, 'type alias')
ParamSpec = ClassNode('ParamSpec', type_parameter, 'parameter spec')
TypeVar = ClassNode('TypeVar', type_parameter, 'type variable')
TypeVarTuple = ClassNode('TypeVarTuple', type_parameter, 'type variable tuple')


expr_or_stmt = UnionNode(expr, stmt)

dict_item_list = ListNode(dict_item)

ast_node = UnionNode(expr, stmt, pattern, Module, Class, Function, comprehension, StringPart, dict_item, type_parameter)
ast_node.set_name('ast_node')

parameter = UnionNode(Name, Tuple)
parameter.set_name('parameter')

parameter_list = ListNode(parameter)

alias.field('value', expr)
alias.field('asname', expr, 'name')

arguments.field('kw_defaults', expr_list, 'keyword-only default values')
arguments.field('defaults', expr_list, 'default values')
arguments.field('annotations', expr_list)
arguments.field('varargannotation', expr, '*arg annotation')
arguments.field('kwargannotation', expr, '**kwarg annotation')
arguments.field('kw_annotations', expr_list, 'keyword-only annotations')

Assert.field('test', expr, 'value being tested')
Assert.field('msg', expr, 'failure message')

Assign.field('value', expr)
Assign.field('targets', expr_list, 'targets')

Attribute.field('value', expr, 'object')
Attribute.field('attr', string, 'attribute name')
Attribute.field('ctx', expr_context, 'context')

AugAssign.field('operation', BinOp)

BinOp.field('left', expr, 'left sub-expression')
BinOp.field('op', operator, 'operator')
BinOp.field('right', expr, 'right sub-expression')

BoolOp.field('op', boolop, 'operator')
BoolOp.field('values', expr_list, 'sub-expressions')

Bytes.field('s', bytes_, 'value')
Bytes.field('prefix', bytes_, 'prefix')
Bytes.field('implicitly_concatenated_parts', string_parts_list)

Call.field('func', expr, 'callable')
Call.field('positional_args', expr_list, 'positional arguments')
Call.field('named_args', dict_item_list, 'named arguments')

Class.field('name', string)
Class.field('body', stmt_list)

ClassExpr.field('name', string)
ClassExpr.field('bases', expr_list)
ClassExpr.field('keywords', dict_item_list, 'keyword arguments')
ClassExpr.field('inner_scope', Class, 'class scope')
ClassExpr.field('type_parameters', type_parameter_list, 'type parameters')

Compare.field('left', expr, 'left sub-expression')
Compare.field('ops', cmpop_list, 'comparison operators')
Compare.field('comparators', expr_list, 'right sub-expressions')

comprehension.field('iter', expr, 'iterable')
comprehension.field('target', expr)
comprehension.field('ifs', expr_list, 'conditions')

Delete.field('targets', expr_list)

Dict.field('items', dict_item_list)

DictUnpacking.field('location', location)
DictUnpacking.field('value', expr)

DictComp.field('function', Function, 'implementation')
DictComp.field('iterable', expr)

ExceptStmt.field('type', expr)
ExceptStmt.field('name', expr)
ExceptStmt.field('body', stmt_list)

ExceptGroupStmt.field('type', expr)
ExceptGroupStmt.field('name', expr)
ExceptGroupStmt.field('body', stmt_list)

Exec.field('body', expr)
Exec.field('globals', expr)
Exec.field('locals', expr)

Expr_stmt.field('value', expr)

For.field('target', expr)
For.field('iter', expr, 'iterable')
For.field('body', stmt_list)
For.field('orelse', stmt_list, 'else block')
For.field('is_async', bool_, 'async')

Function.field('name', string)
Function.field('args', parameter_list, 'positional parameter list')
Function.field('vararg', expr, 'tuple (*) parameter')
Function.field('kwonlyargs', expr_list, 'keyword-only parameter list')
Function.field('kwarg', expr, 'dictionary (**) parameter')
Function.field('body', stmt_list)
Function.field('is_async', bool_, 'async')
Function.field('type_parameters', type_parameter_list, 'type parameters')

FunctionExpr.field('name', string)
FunctionExpr.field('args', arguments, 'parameters')
FunctionExpr.field('returns', expr, 'return annotation')
FunctionExpr.field('inner_scope', Function, 'function scope')

GeneratorExp.field('function', Function, 'implementation')
GeneratorExp.field('iterable', expr)

Global.field('names', string_list)

If.field('test', expr)
If.field('body', stmt_list, 'if-true block')
If.field('orelse', stmt_list, 'if-false block')

IfExp.field('test', expr)
IfExp.field('body', expr, 'if-true expression')
IfExp.field('orelse', expr, 'if-false expression')

Import.field('names', alias_list, 'alias list')

ImportFrom.set_name('ImportStar')
ImportFrom.field('module', expr)

ImportMember.field('module', expr)
ImportMember.field('name', string)

keyword.field('location', location)
keyword.field('value', expr)
keyword.field('arg', string)

KeyValuePair.field('location', location)
KeyValuePair.field('value', expr)
KeyValuePair.field('key', expr)

Lambda.field('args', arguments, 'arguments')
Lambda.field('inner_scope', Function, 'function scope')

List.field('elts', expr_list, 'element list')
List.field('ctx', expr_context, 'context')

#For Python 3 a new scope is created and these fields are populated:
ListComp.field('function', Function, 'implementation')
ListComp.field('iterable', expr)
#For Python 2 no new scope is created and these are populated:
ListComp.field('generators', comprehension_list)
ListComp.field('elt', expr, 'elements')

Match.field('subject', expr)
Match.field('cases', stmt_list)
Case.field('pattern', pattern)
Case.field('guard', expr)
Case.field('body', stmt_list)
Guard.field('test', expr)
MatchStarPattern.field('target', pattern)
MatchDoubleStarPattern.field('target', pattern)
MatchKeyValuePattern.field('key', pattern)
MatchKeyValuePattern.field('value', pattern)
MatchClassPattern.field('class', expr)
MatchKeywordPattern.field('attribute', expr)
MatchKeywordPattern.field('value', pattern)
MatchAsPattern.field('pattern', pattern)
MatchAsPattern.field('alias', expr)
MatchOrPattern.field('patterns', pattern_list)
MatchLiteralPattern.field('literal', expr)
MatchCapturePattern.field('variable', expr)
MatchValuePattern.field('value', expr)
MatchSequencePattern.field('patterns', pattern_list)
MatchMappingPattern.field('mappings', pattern_list)
MatchClassPattern.field('class_name', expr)
MatchClassPattern.field('positional', pattern_list)
MatchClassPattern.field('keyword', pattern_list)

Module.field('name', string)
Module.field('hash', string , 'hash (not populated)')
Module.field('body', stmt_list)
Module.field('kind', string)

ImportExpr.field('level', int_)
ImportExpr.field('name', string)
ImportExpr.field('top', bool_, 'top level')

Name.field('variable', variable)
Name.field('ctx', expr_context, 'context')

Nonlocal.field('names', string_list)

Num.field('n', number, 'value')
Num.field('text', number)

ParamSpec.field('name', expr)
ParamSpec.field('default', expr)

Print.field('dest', expr, 'destination')
Print.field('values', expr_list)
Print.field('nl', bool_, 'new line')

#Python3 has exc & cause
Raise.field('exc', expr, 'exception')
Raise.field('cause', expr)
#Python2 has type, inst, tback
Raise.field('type', expr)
Raise.field('inst', expr, 'instance')
Raise.field('tback', expr, 'traceback')

Repr.field('value', expr)

Return.field('value', expr)

Set.field('elts', expr_list, 'elements')

SetComp.field('function', Function, 'implementation')
SetComp.field('iterable', expr)

Slice.field('start', expr)
Slice.field('stop', expr)
Slice.field('step', expr)

Starred.field('value', expr)
Starred.field('ctx', expr_context, 'context')

Str.field('s', string, 'text')
Str.field('prefix', string, 'prefix')
Str.field('implicitly_concatenated_parts', string_parts_list)

Subscript.field('value', expr)
Subscript.field('index', expr)
Subscript.field('ctx', expr_context, 'context')

Try.field('body', stmt_list)
Try.field('orelse', stmt_list, 'else block')
Try.field('handlers', stmt_list, 'exception handlers')
Try.field('finalbody', stmt_list, 'finally block')

Tuple.field('elts', expr_list, 'elements')
Tuple.field('ctx', expr_context, 'context')

TypeAlias.field('name', expr)
TypeAlias.field('type_parameters', type_parameter_list)
TypeAlias.field('value', expr)

TypeVar.field('name', expr)
TypeVar.field('bound', expr)
TypeVar.field('default', expr)

TypeVarTuple.field('name', expr)
TypeVarTuple.field('default', expr)

UnaryOp.field('op', unaryop, 'operator')
UnaryOp.field('operand', expr)

While.field('test', expr)
While.field('body', stmt_list)
While.field('orelse', stmt_list, 'else block')

With.field('context_expr', expr, 'context manager')
With.field('optional_vars', expr, 'optional variable')
With.field('body', stmt_list)
With.field('is_async', bool_, 'async')

Yield.field('value', expr)

YieldFrom.field('value', expr)

#Template AST Nodes
TemplateWrite.field('value', expr)
TemplateDottedNotation.field('value', expr, 'object')
TemplateDottedNotation.field('attr', string, 'attribute name')
TemplateDottedNotation.field('ctx', expr_context, 'context')
Filter.field('value', expr, 'filtered value')
Filter.field('filter', expr, 'filter')

PlaceHolder.field('variable', variable)
PlaceHolder.field('ctx', expr_context, 'context')

StringPart.field('text', string)
StringPart.field('location', location)

Await.field('value', expr, 'expression waited upon')

FormattedStringLiteral.field('values', expr_list)

FormattedValue.field('value', expr, "expression to be formatted")
FormattedValue.field('conversion', string, 'type conversion')
FormattedValue.field('format_spec', FormattedStringLiteral, 'format specifier')

AnnAssign.field('value', expr)
AnnAssign.field('annotation', expr)
AnnAssign.field('target', expr)

SpecialOperation.field('name', string)
SpecialOperation.field('arguments', expr_list)

AssignExpr.field('value', expr)
AssignExpr.field('target', expr)

def all_nodes():
    nodes = [ val for val in globals().values() if isinstance(val, Node) ]
    return _build_node_relations(nodes)
