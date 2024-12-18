# tsg_parser.py

# Functions and classes used for parsing Python files using `tree-sitter-graph`

from ast import literal_eval
import sys
import os
import semmle.python.parser
from semmle.python.parser.ast import copy_location, decode_str, split_string
from semmle.python import ast
import subprocess
from itertools import groupby

DEBUG = False
def debug_print(*args, **kwargs):
    if DEBUG:
        print(*args, **kwargs)

# Node ids are integers, and so to distinguish them from actual integers we wrap them in this class.
class Node(object):
    def __init__(self, id):
        self.id = id
    def __repr__(self):
        return "Node({})".format(self.id)

# A wrapper for nodes containing comments. The old parser does not create such nodes (and therefore
# there is no `ast.Comment` class) since it accesses the comments via the tokens for the given file.
class Comment(object):
    def __init__(self, text):
        self.text = text
    def __repr__(self):
        return "Comment({})".format(self.text)

class SyntaxErrorNode(object):
    def __init__(self, source):
        self.source = source
    def __repr__(self):
        return "SyntaxErrorNode({})".format(self.source)

# Mapping from tree-sitter CPT node kinds to their corresponding AST node classes.
tsg_to_ast = {name: cls
    for name, cls in semmle.python.ast.__dict__.items()
    if isinstance(cls, type) and ast.AstBase in cls.__mro__
}
tsg_to_ast["Comment"] = Comment
tsg_to_ast["SyntaxErrorNode"] = SyntaxErrorNode

# Mapping from AST node class to the fields of the node. The order of the fields is the order in
# which they will be output in the AST dump.
#
# These fields cannot be extracted automatically, so we set them manually.
ast_fields = {
    ast.Module: ("body",), # Note: has no `__slots__` to inspect
    Comment: ("text",), # Note: not an `ast` class
    SyntaxErrorNode: ("source",), # Note: not an `ast` class
    ast.Continue: (),
    ast.Break: (),
    ast.Pass: (),
    ast.Ellipsis: (),
    ast.MatchWildcardPattern: (),
}

# Fields that we don't want to dump on every single AST node. These are just the slots of the AST
# base class, consisting of all of the location information (which we print in a different way).
ignored_fields = semmle.python.ast.AstBase.__slots__

# Extract fields for the remaining AST classes
for name, cls in semmle.python.ast.__dict__.items():
    if name.startswith("_"):
        continue
    if not hasattr(cls, "__slots__"):
        continue
    slots = tuple(field for field in cls.__slots__ if field not in ignored_fields)
    if not slots:
        continue
    ast_fields[cls] = slots

# A mapping from strings to the AST node classes that represent things like operators.
# These have to be handled specially, because they have no location information.
locationless = {
    "and": ast.And,
    "or": ast.Or,
    "not": ast.Not,
    "uadd": ast.UAdd,
    "usub": ast.USub,
    "+": ast.Add,
    "-": ast.Sub,
    "~": ast.Invert,
    "**": ast.Pow,
    "<<": ast.LShift,
    ">>": ast.RShift,
    "&": ast.BitAnd,
    "|": ast.BitOr,
    "^": ast.BitXor,
    "load": ast.Load,
    "store": ast.Store,
    "del" : ast.Del,
    "param" : ast.Param,
}
locationless.update(semmle.python.parser.ast.TERM_OP_CLASSES)
locationless.update(semmle.python.parser.ast.COMP_OP_CLASSES)
locationless.update(semmle.python.parser.ast.AUG_ASSIGN_OPS)

if 'CODEQL_EXTRACTOR_PYTHON_ROOT' in os.environ:
    platform = os.environ['CODEQL_PLATFORM']
    ext = ".exe" if platform == "win64" else ""
    tools = os.path.join(os.environ['CODEQL_EXTRACTOR_PYTHON_ROOT'], "tools", platform)
    tsg_command = [os.path.join(tools, "tsg-python" + ext )]
else:
    # Get the path to the current script
    script_path = os.path.dirname(os.path.realpath(__file__))
    tsg_python_path = os.path.join(script_path, "../../../tsg-python")
    cargo_file = os.path.join(tsg_python_path, "Cargo.toml")
    tsg_command = ["cargo", "run", "--quiet", "--release", "--manifest-path="+cargo_file]

def read_tsg_python_output(path, logger):
    # Mapping from node id (an integer) to a dictionary containing attribute data.
    node_attr = {}
    # Mapping a start node to a map from attribute names to lists of (value, end_node) pairs.
    edge_attr = {}

    command_args = tsg_command + [path]
    p = subprocess.Popen(command_args, stdout=subprocess.PIPE)
    for line in p.stdout:
        line = line.decode(sys.getfilesystemencoding())
        line = line.rstrip()
        if line.startswith("node"): # e.g. `node 5`
            current_node = int(line.split(" ")[1])
            d = {}
            node_attr[current_node] = d
            in_node = True
        elif line.startswith("edge"): # e.g. `edge 5 -> 6`
            current_start, current_end = tuple(map(int, line[4:].split("->")))
            d = edge_attr.setdefault(current_start, {})
            in_node = False
        else: # attribute, e.g. `_kind: "Class"`
            key, value = line[2:].split(": ", 1)
            if value.startswith("[graph node"): # e.g. `_skip_to: [graph node 5]`
                value = Node(int(value.split(" ")[2][:-1]))
            elif value == "#true": # e.g. `_is_parenthesised: #true`
                value = True
            elif value == "#false": # e.g. `top: #false`
                value = False
            elif value == "#null": # e.g. `exc: #null`
                value = None
            else: # literal values, e.g. `name: "k1.k2"` or `level: 5`
                try:
                    if key =="s" and value[0] == '"': # e.g. `s: "k1.k2"`
                        value = evaluate_string(value)
                    else:
                        value  = literal_eval(value)
                        if isinstance(value, bytes):
                            try:
                                value = value.decode(sys.getfilesystemencoding())
                            except UnicodeDecodeError:
                                # just include the bytes as-is
                                pass
                except Exception as ex:
                    # We may not know the location at this point -- for instance if we forgot to set
                    # it -- but `get_location_info` will degrade gracefully in this case.
                    loc = ":".join(str(i) for i in get_location_info(d))
                    error = ex.args[0] if ex.args else "unknown"
                    logger.warning("Error '{}' while parsing value {} at {}:{}\n".format(error, repr(value), path, loc))
            if in_node:
                d[key] = value
            else:
                d.setdefault(key, []).append((value, current_end))
    p.stdout.close()
    p.terminate()
    p.wait()
    logger.debug("Read {} nodes and {} edges from TSG output".format(len(node_attr), len(edge_attr)))
    return node_attr, edge_attr

def evaluate_string(s):
    s = literal_eval(s)
    prefix, quotes, content = split_string(s, None)
    ends_with_illegal_character = False
    # If the string ends with the same quote character as the outer quotes (and/or backslashes)
    # (e.g. the first string part of `f"""hello"{0}"""`), we must take care to not accidently create
    # the ending quotes at the wrong place. To do this, we insert an extra space at the end (that we
    # then must remember to remove later on.)
    if content.endswith(quotes[0]) or content.endswith('\\'):
        ends_with_illegal_character = True
        content = content + " "
    s = prefix.strip("fF") + quotes + content + quotes
    s = literal_eval(s)
    if isinstance(s, bytes):
        s = decode_str(s)
    if ends_with_illegal_character:
        s = s[:-1]
    return s

def resolve_node_id(id, node_attr):
    """Finds the end of a sequence of nodes linked by `_skip_to` fields, starting at `id`."""
    while "_skip_to" in node_attr[id]:
        id = node_attr[id]["_skip_to"].id
    return id

def get_context(id, node_attr, logger):
    """Gets the context of the node with the given `id`. This is either whatever is stored in the
    `ctx` attribute of the node, or the result of dereferencing a sequence of `_inherited_ctx` attributes."""

    while "ctx" not in node_attr[id]:
        if "_inherited_ctx" not in node_attr[id]:
            logger.error("No context for node {} with attributes {}\n".format(id, node_attr[id]))
            # A missing context is most likely to be a "load", so return that.
            return ast.Load()
        id = node_attr[id]["_inherited_ctx"].id
    return locationless[node_attr[id]["ctx"]]()

def get_location_info(attrs):
    """Returns the location information for a node, depending on which fields are set.

    In particular, more specific fields take precedence over (and overwrite) less specific fields.
    So, `_start_line` and `_start_column` take precedence over `location_start`, which takes
    precedence over `_location`. Likewise when `end` replaces `start` above.

    If part of the location information is missing, the string `"???"` is substituted for the
    missing bits.
    """
    start_line = "???"
    start_column = "???"
    end_line = "???"
    end_column = "???"
    if "_location" in attrs:
        (start_line, start_column, end_line, end_column) = attrs["_location"]
    if "_location_start" in attrs:
        (start_line, start_column) = attrs["_location_start"]
    if "_location_end" in attrs:
        (end_line, end_column) = attrs["_location_end"]
    if "_start_line" in attrs:
        start_line = attrs["_start_line"]
    if "_start_column" in attrs:
        start_column = attrs["_start_column"]
    if "_end_line" in attrs:
        end_line = attrs["_end_line"]
    if "_end_column" in attrs:
        end_column = attrs["_end_column"]
    # Lines in the `tsg-python` output is 0-indexed, but the AST expects them to be 1-indexed.
    if start_line != "???":
        start_line += 1
    if end_line != "???":
        end_line += 1
    return (start_line, start_column, end_line, end_column)

list_fields = {
    ast.arguments: ("annotations", "defaults", "kw_defaults", "kw_annotations"),
    ast.Assign: ("targets",),
    ast.BoolOp: ("values",),
    ast.Bytes: ("implicitly_concatenated_parts",),
    ast.Call: ("positional_args", "named_args"),
    ast.Case: ("body",),
    ast.Class: ("body",),
    ast.ClassExpr: ("type_parameters", "bases", "keywords"),
    ast.Compare: ("ops", "comparators",),
    ast.comprehension: ("ifs",),
    ast.Delete: ("targets",),
    ast.Dict: ("items",),
    ast.ExceptStmt: ("body",),
    ast.For: ("body",),
    ast.Function: ("type_parameters", "args", "kwonlyargs", "body"),
    ast.Global: ("names",),
    ast.If: ("body",),
    ast.Import: ("names",),
    ast.List: ("elts",),
    ast.Match: ("cases",),
    ast.MatchClassPattern: ("positional", "keyword"),
    ast.MatchMappingPattern: ("mappings",),
    ast.MatchOrPattern: ("patterns",),
    ast.MatchSequencePattern: ("patterns",),
    ast.Module: ("body",),
    ast.Nonlocal: ("names",),
    ast.Print: ("values",),
    ast.Set: ("elts",),
    ast.Str: ("implicitly_concatenated_parts",),
    ast.TypeAlias: ("type_parameters",),
    ast.Try: ("body", "handlers", "orelse", "finalbody"),
    ast.Tuple: ("elts",),
    ast.While: ("body",),
#    ast.FormattedStringLiteral: ("arguments",),
}

def create_placeholder_args(cls):
    """ Returns a dictionary containing the placeholder arguments necessary to create an AST node.

    In most cases these arguments will be assigned the value `None`, however for a few classes we
    must substitute the empty list, as this is enforced by asserts in the constructor.
    """
    if cls in (ast.Raise, ast.Ellipsis):
        return {}
    fields = ast_fields[cls]
    args = {field: None for field in fields if field != "is_async"}
    for field in list_fields.get(cls, ()):
        args[field] = []
    if cls in (ast.GeneratorExp, ast.ListComp, ast.SetComp, ast.DictComp):
        del args["function"]
        del args["iterable"]
    return args

def parse(path, logger):
    node_attr, edge_attr = read_tsg_python_output(path, logger)
    debug_print("node_attr:", node_attr)
    debug_print("edge_attr:", edge_attr)
    nodes = {}
    # Nodes that need to be fixed up after building the graph
    fixups = {}
    # Reverse index from node object to node id.
    node_id = {}
    # Create all the node objects
    for id, attrs in node_attr.items():
        if "_is_literal" in attrs:
            nodes[id] = attrs["_is_literal"]
            continue
        if "_kind" not in attrs:
            logger.error("Error: Graph node {} with attributes {} has no `_kind`!\n".format(id, attrs))
            continue
        # This is not the node we are looking for (so don't bother creating it).
        if "_skip_to" in attrs:
            continue
        cls = tsg_to_ast[attrs["_kind"]]
        args = ast_fields[cls]
        obj = cls(**create_placeholder_args(cls))
        nodes[id] = obj
        node_id[obj] = id
        # If this node needs fixing up afterwards, add it to the fixups map.
        if "_fixup" in attrs:
            fixups[id] = obj
    # Set all of the node attributes
    for id, node in nodes.items():
        attrs = node_attr[id]
        if "_is_literal" in attrs:
            continue
        expected_fields = ast_fields[type(node)]

        # Set up location information.
        node.lineno, node.col_offset, end_line, end_column = get_location_info(attrs)
        node._end = (end_line, end_column)

        if isinstance(node, SyntaxErrorNode):
            exc = SyntaxError("Syntax Error")
            exc.lineno = node.lineno
            exc.offset = node.col_offset
            raise exc

        # Set up context information, if any
        if "ctx" in expected_fields:
            node.ctx = get_context(id, node_attr, logger)
        # Set the fields.
        for field, val in attrs.items():
            if field.startswith("_"): continue
            if field == "ctx": continue
            if field != "parenthesised" and field not in expected_fields:
                logger.warning("Unknown field {} found among {} in node {}\n".format(field, attrs, id))

            # For fields that point to other AST nodes.
            if isinstance(val, Node):
                val = resolve_node_id(val.id, node_attr)
                setattr(node, field, nodes[val])
            # Special case for `Num.n`, which should be coerced to an int.
            elif isinstance(node, ast.Num) and field == "n":
                node.n = literal_eval(val.rstrip("lL"))
            # Special case for `Name.variable`, for which we must create a new `Variable` object
            elif isinstance(node, ast.Name) and field == "variable":
                node.variable = ast.Variable(val)
            # Special case for location-less leaf-node subclasses of `ast.Node`, such as `ast.Add`.
            elif field == "op" and val in locationless.keys():
                setattr(node, field, locationless[val]())
            else: # Any other value, usually literals of various kinds.
                setattr(node, field, val)

    # Create all fields pointing to lists of values.
    for start, field_map in edge_attr.items():
        start = resolve_node_id(start, node_attr)
        parent = nodes[start]
        extra_fields = {}
        for field_name, value_end in field_map.items():
            # Sort children by index (in case they were visited out of order)
            children = [nodes[resolve_node_id(end, node_attr)] for _index, end in sorted(value_end)]
            # Skip any comments.
            children = [child for child in children if not isinstance(child, Comment)]
            # Special case for `Compare.ops`, a list of comparison operators
            if isinstance(parent, ast.Compare) and field_name == "ops":
                parent.ops = [locationless[v]() for v in children]
            elif field_name.startswith("_"):
                # We can only set the attributes given in `__slots__` on the `start` node, and so we
                # must handle fields starting with `_` specially. In this case, we simply record the
                # values and then subsequently update `edge_attr` to refer to these values. This
                # makes it act as a pseudo-field, that we can access as long as we know the `id`
                # corresponding to a given node (for which we have the `node_id` map).
                extra_fields[field_name] = children
            else:
                setattr(parent, field_name, children)
        if extra_fields:
            # Extend the existing map in `node_attr` with the extra fields.
            node_attr[start].update(extra_fields)

    # Fixup any nodes that need it.
    for id, node in fixups.items():
        if isinstance(node, (ast.JoinedStr, ast.Str)):
            fix_strings(id, node, node_attr, node_id, logger)

    debug_print("nodes:", nodes)
    if not nodes:
        # if the file referenced by path is empty, return an empty module:
        if os.path.getsize(path) == 0:
            module = ast.Module([])
            module.lineno = 1
            module.col_offset = 0
            module._end = (1, 0)
            return module
        else:
            raise SyntaxError("Syntax Error")
    # Fix up start location of outer `Module`.
    module = nodes[0]
    if module.body:
        # Get the location of the first non-comment node.
        module.lineno = module.body[0].lineno
    else:
        # No children! File must contain only comments! Pick the end location as the start location.
        module.lineno = module._end[0]
    return module


def get_JoinedStr_children(children):
    """
    Folds the `Str` and `expr` parts of a `JoinedStr` into a single list, and does this for each
    `JoinedStr` in `children`. Top-level `StringPart`s are included in the output directly.
    """
    for child in children:
        if isinstance(child, ast.JoinedStr):
            for value in child.values:
                yield value
        elif isinstance(child, ast.StringPart):
            yield child
        else:
            raise ValueError("Unexpected node type: {}".format(type(child)))

def concatenate_stringparts(stringparts, logger):
    """Concatenates the strings contained in the list of `stringparts`."""
    try:
        return "".join(decode_str(stringpart.s) for stringpart in stringparts)
    except Exception as ex:
        logger.error("Unable to concatenate string {} getting error {}".format(stringparts, ex))
        return stringparts[0].s


def fix_strings(id, node, node_attr, node_id, logger):
    """
    Reassociates the `StringPart` children of an implicitly concatenated f-string (`JoinedStr`)
    """
    # Tests whether something is a string child
    is_string = lambda node: isinstance(node, ast.StringPart)

    # We have two cases to consider. Either we're given something that came from a
    # `concatenated_string`, or something that came from an `formatted_string`. The latter case can
    # be seen as a special case of the former where the list of children we consider is just the
    # single f-string.
    children = node_attr[id].get("_children", [node])
    if isinstance(node, ast.Str):
        # If the outer node is a `Str`, then we don't have to reassociate, since there are no
        # f-strings.
        # In this case we simply have to create the concatenation of its constituent parts.
        node.implicitly_concatenated_parts = children
        node.s = concatenate_stringparts(children, logger)
        node.prefix = children[0].prefix
    else:
        # Otherwise, we first have to get the flattened list of all of the strings and/or
        # expressions.
        flattened_children = get_JoinedStr_children(children)
        groups = [list(n) for _, n in groupby(flattened_children, key=is_string)]
        # At this point, `values` is a list of lists, where each sublist is either:
        # - a list of `StringPart`s, or
        # - a singleton list containing an `expr`.
        # Crucially, `StringPart` is _not_ an `expr`.
        combined_values = []
        for group in groups:
            first = group[0]
            if isinstance(first, ast.expr):
                # If we have a list of expressions (which may happen if an interpolation contains
                # multiple distinct expressions, such as f"{foo:{bar}}", which uses interpolation to
                # also specify the padding dynamically), we simply append it.
                combined_values.extend(group)
            else:
                # Otherwise, we have a list of `StringPart`s, and we need to create a `Str` node to
                # it.

                combined_string = concatenate_stringparts(group, logger)
                str_node = ast.Str(combined_string, first.prefix, None)
                copy_location(first, str_node)
                # The end location should be the end of the last part (even if there is only one part).
                str_node._end = group[-1]._end
                if len(group) > 1:
                    str_node.implicitly_concatenated_parts = group
                combined_values.append(str_node)
        node.values = combined_values
