# dump_ast.py

# Functions for dumping the internal Python AST in a human-readable format.

import sys
import semmle.python.parser.tokenizer
import semmle.python.parser.tsg_parser
from semmle.python.parser.tsg_parser import ast_fields
from semmle.python import ast
from semmle import logging
from semmle.python.modules import PythonSourceModule



def get_fields(cls):
    """Gets the fields of the given class, followed by the fields of its (single-inheritance)
    superclasses, if any.
    Only includes fields for classes in `ast_fields`."""
    if cls not in ast_fields:
        return ()
    s = cls.__bases__[0]
    return ast_fields[cls] + get_fields(s)

def missing_fields(known, node):
    """Returns a list of fields in `node` that are not in `known`."""
    return [field
        for field in dir(node)
        if field not in known
        and not field.startswith("_")
        and not field in ("lineno", "col_offset")
        and not (isinstance(node, ast.Name) and field == "id")
    ]

class AstDumper(object):
    def __init__(self, output=sys.stdout, no_locations=False):
        self.output = output
        self.show_locations = not no_locations

    def visit(self, node, level=0, visited=None):
        if visited is None:
            visited = set()
        if node in visited:
            output.write("{} CYCLE DETECTED!\n".format(indent))
            return
        visited = visited.union({node})
        output = self.output
        cls = node.__class__
        name = cls.__name__
        indent = '  ' * level
        if node is None: # Special case for `None` to avoid printing `NoneType`.
            name = 'None'
        if cls == str: # Special case for bare strings
            output.write("{}{}\n".format(indent, repr(node)))
            return
        # In some places, we have non-AST nodes in lists, and since these don't have a location, we
        # simply print their name instead.
        # `ast.arguments` is special -- it has fields but no location
        if hasattr(node, 'lineno') and not isinstance(node, ast.arguments) and self.show_locations:
            position = (node.lineno, node.col_offset, node._end[0], node._end[1])
            output.write("{}{}: [{}, {}] - [{}, {}]\n".format(indent, name, *position))
        else:
            output.write("{}{}\n".format(indent, name))


        fields = get_fields(cls)
        unknown = missing_fields(fields, node)
        if unknown:
            output.write("{}UNKNOWN FIELDS: {}\n".format(indent, unknown))
        for field in fields:
            value = getattr(node, field, None)
            # By default, the `parenthesised` field on expressions has no value, so it's easier to
            # just not print it in that case.
            if field == "parenthesised" and value is None:
                continue
            # Likewise, the default value for `is_async` is `False`, so we don't need to print it.
            if field == "is_async" and value is False:
                continue
            output.write("{}  {}:".format(indent,field))
            if isinstance(value, list):
                output.write(" [")
                if len(value) == 0:
                    output.write("]\n")
                    continue
                output.write("\n")
                for n in value:
                    self.visit(n, level+2, visited)
                output.write("{}  ]\n".format(indent))
            # Some AST classes are special in that the identity of the object is the only thing
            # that matters (and they have no location info). For this reason we simply print the name.
            elif isinstance(value, (ast.expr_context, ast.boolop, ast.cmpop, ast.operator, ast.unaryop)):
                output.write(' {}\n'.format(value.__class__.__name__))
            elif isinstance(value, ast.AstBase):
                output.write("\n")
                self.visit(value, level+2, visited)
            else:
                output.write(' {}\n'.format(repr(value)))


class StdoutLogger(logging.Logger):
    error_count = 0
    def log(self, level, fmt, *args):
        sys.stdout.write(fmt % args + "\n")

    def info(self, fmt, *args):
        self.log(logging.INFO, fmt, *args)

    def warn(self, fmt, *args):
        self.log(logging.WARN, fmt, *args)
        self.error_count += 1

    def error(self, fmt, *args):
        self.log(logging.ERROR, fmt, *args)
        self.error_count += 1

    def had_errors(self):
        return self.error_count > 0

    def reset_error_count(self):
        self.error_count = 0

def old_parser(inputfile, logger):
    mod = PythonSourceModule(None, inputfile, logger)
    logger.close()
    return mod.old_py_ast

def args_parser():
    'Parse command_line, returning options, arguments'
    from optparse import OptionParser
    usage = "usage: %prog [options] python-file"
    parser = OptionParser(usage=usage)
    parser.add_option("-o", "--old", help="Dump old AST.", action="store_true")
    parser.add_option("-n", "--new", help="Dump new AST.", action="store_true")
    parser.add_option("-l", "--no-locations", help="Don't include location info in dump", action="store_true")
    parser.add_option("-d", "--debug", help="Print debug information.", action="store_true")
    return parser

def main():
    parser = args_parser()
    options, args = parser.parse_args(sys.argv[1:])

    if options.debug:
        global DEBUG
        DEBUG = True

    if len(args) != 1:
        sys.stderr.write("Error: wrong number of arguments.\n")
        parser.print_help()
        sys.exit(1)

    inputfile = args[0]

    if options.old and options.new:
        sys.stderr.write("Error: options --old and --new are mutually exclusive.\n")
        sys.exit(1)

    if not (options.old or options.new):
        sys.stderr.write("Error: Must specify either --old or --new.\n")
        sys.exit(1)

    with StdoutLogger() as logger:

        if options.old:
            ast = old_parser(inputfile, logger)
        else:
            ast = semmle.python.parser.tsg_parser.parse(inputfile, logger)
    AstDumper(no_locations=options.no_locations).visit(ast)

if __name__ == '__main__':
    main()
