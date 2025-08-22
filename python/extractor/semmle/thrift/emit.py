
import os.path
import csv
import re
import semmle.util

IGNORE = re.compile("namespace|fieldreq")

class Emitter(object):

    def __init__(self, trap_folder):
        self.trap_folder = trap_folder
        self.lengths = {}
        self.next_id = 0
        self.uuid = semmle.util.uuid('thrift')

    def emit(self, file, tree):
        trapwriter = semmle.util.TrapWriter()
        vpath = self.trap_folder.get_virtual_path(file)
        self.emit_recursive(trapwriter, vpath, tree, None, None)
        trapwriter.write_file(vpath)
        self.trap_folder.write_trap("thrift", file, trapwriter.get_compressed())

    def emitrow(self, trapwriter, kind, *args):
        if kind in self.lengths:
            if len(args) != self.lengths[kind]:
                raise Exception("Inconsistent row for '%s': %s, expecting %d" % (kind, args, self.lengths[kind]))
        else:
            self.lengths[kind] = len(args)
        qpath = "thrift-"+kind
        id = trapwriter.get_unique_id()
        for index, value in enumerate(args):
            trapwriter.write_tuple("externalData", "rsds", id, qpath, index, value)

    def emit_recursive(self, trapwriter, file, node, index, parent):
        self.next_id += 1
        if hasattr(node, "type"):
            tag = node.type
            assert index >= 0
            name = "%s-%s-%s" % (tag, self.next_id, self.uuid)
            self.emitrow(trapwriter, tag, name, index, parent, node.value, file, node.line, node.column)
        else:
            tag = node.data
            if IGNORE.match(tag):
                return
            name = "%s-%s-%s" % (node.data, self.next_id, self.uuid)
            for cindex, child in enumerate(node.children):
                self.emit_recursive(trapwriter, file, child, cindex, name)
            if index is None:
                self.emitrow(trapwriter, tag, name)
            else:
                self.emitrow(trapwriter, tag, name, index, parent)
