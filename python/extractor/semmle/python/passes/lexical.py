import ast
import sys
import math

from semmle.python.passes.ast_pass import iter_fields
from semmle.python import ast
from semmle.python.passes._pass import Pass

__all__ = [ 'LexicalPass' ]

STMT_OR_EXPR = ast.expr, ast.stmt
LOCATABLE = STMT_OR_EXPR + (ast.pattern, ast.comprehension, ast.StringPart, ast.keyword, ast.KeyValuePair, ast.DictUnpacking, ast.type_parameter)
CLASS_OR_FUNCTION = ast.Class, ast.Function
SCOPES = ast.Class, ast.Function, ast.Module

class LexicalPass(Pass):

    def extract(self, ast, comments, writer):
        'The entry point'
        LexicalModule(ast, comments, writer).extract()


class LexicalModule(object):
    'Object for extracting lexical information for the given module.'

    def __init__(self, ast, comments, writer):
        assert ast is not None and comments is not None
        self.ast = ast
        self.comments = comments
        self.writer = writer
        self.module_id = writer.get_node_id(ast)

    def extract(self):
        loc_id = self.get_location(0, 0, 0, 0)
        self.writer.write_tuple(u'py_scope_location', 'rr', loc_id, self.module_id)
        self.emit_line_info()
        self.emit_locations(self.ast)

    def emit_line_info(self):
        for text, start, end in self.comments:
            #Generate a unique string for comment based on location
            comment_id = str(start + end)
            loc_id = self.get_location(start[0], start[1]+1,
                                       end[0], end[1])
            try:
                self.writer.write_tuple(u'py_comments', 'nsr',
                            comment_id, text, loc_id)
            except UnicodeDecodeError:
                # Handle non-ascii comments. Should only happen in Py2
                assert sys.hexversion < 0x03000000
                text = text.decode("latin8")
                self.writer.write_tuple(u'py_comments', 'nsr',
                             comment_id, text, loc_id)
        comment_bits = get_comment_bits(self.comments)
        self.emit_line_counts(self.ast, set(), comment_bits)

    def emit_line_counts(self, node, code_lines, comment_bits):
        if isinstance(node, SCOPES) and node.body:
            doc_line_count = 0
            stmt0 = node.body[0]
            if type(stmt0) == ast.Expr:
                docstring = stmt0.value
                if isinstance(docstring, ast.Str):
                    doc_line_count = docstring._end[0] - docstring.lineno + 1
            inner_code_lines = set()
            inner_code_lines.add(node.lineno)
            for _, _, child_node in iter_fields(node):
                self.emit_line_counts(child_node, inner_code_lines, comment_bits)
            assert inner_code_lines
            startline = min(inner_code_lines)
            endline = max(inner_code_lines)
            if isinstance(node, ast.Module):
                endline = max(endline, last_line(comment_bits))
            comment_line_count = get_lines_in_range(comment_bits, startline, endline)
            code_line_count = len(inner_code_lines) - doc_line_count
            code_lines.update(inner_code_lines)
            self.print_lines(u'code', node, code_line_count)
            self.print_lines(u'comment', node, comment_line_count)
            self.print_lines(u'docstring', node, doc_line_count)
            self.print_lines(u'all', node, endline - startline + 1)
            if isinstance(node, ast.Module):
                total_lines = code_line_count + comment_line_count + doc_line_count
                self.writer.write_tuple(u'numlines', 'rddd', self.module_id, total_lines, code_line_count, comment_line_count + doc_line_count)
        elif isinstance(node, list):
            for n in node:
                self.emit_line_counts(n, code_lines, comment_bits)
        elif isinstance(node, STMT_OR_EXPR):
            for _, _, child_node in iter_fields(node):
                self.emit_line_counts(child_node, code_lines, comment_bits)
            assert hasattr(node, "lineno"), node
            line = node.lineno
            endline, _ = node._end
            while line <= endline:
                code_lines.add(line)
                line += 1

    def print_lines(self, name, node, count):
        self.writer.write_tuple(u'py_%slines' % name, 'nd', node, count)

    def get_location(self, bl, bc, el, ec):
        loc_id = self.writer.get_unique_id()
        self.writer.write_tuple(u'locations_ast', 'rrdddd',
                    loc_id, self.module_id, bl, bc, el, ec)
        return loc_id

    def emit_locations(self, node):
        if isinstance(node, ast.AstBase):
            if isinstance(node, LOCATABLE):
                self._write_location(node)
            elif isinstance(node, CLASS_OR_FUNCTION):
                bl, bc = node.lineno, node.col_offset+1
                el, ec = node._end
                loc_id = self.get_location(bl, bc, el, ec)
                self.writer.write_tuple(u'py_scope_location', 'rn', loc_id, node)
            for _, _, child_node in iter_fields(node):
                self.emit_locations(child_node)
        elif isinstance(node, list):
            for n in node:
                self.emit_locations(n)

    def _write_location(self, node):
        bl, bc = node.lineno, node.col_offset+1
        assert len(node._end) == 2, node
        el, ec = node._end
        loc_id = self.get_location(bl, bc, el, ec)
        self.writer.write_tuple(u'py_locations', 'rn', loc_id, node)

def get_comment_bits(comments):
    comment_bits = 0
    for _, start, end in comments:
        line, _ = start
        end_line, _ = end
        while line <= end_line:
            comment_bits |= (1<<line)
            line += 1
    return comment_bits


def get_lines_in_range(bits, start, end):
    if end >= 0:
        length = end - start + 1
        if length < 0:
            return 0
        section = bits >> start
        section &= (1 << length) - 1
    else:
        section = bits >> start
    return bin(section).count('1')

def last_line(n):
    if n <= 0:
        return 0
    return int(math.log(n, 2))
