# Convert output of tree-sitter-graph to dot format.

import sys
import re

# regular expression to match a node
node_re = re.compile(r"node (?P<id>\d+)")

# regular expression to match an edge
edge_re = re.compile(r"edge (?P<from>\d+) -> (?P<to>\d+)")

# regular expression to match a property
prop_re = re.compile(r"\s+(?P<key>\w+): (?P<value>.*)")

# regular expression to match a link: "[graph node n]"
link_re = re.compile(r"\[graph node (?P<id>\d+)\]")

with open(sys.argv[1], 'r') as f, open(sys.argv[2], 'w') as out:
    out.write("digraph G {\n")
    label = []
    inside = False
    node_id = 0
    links = {}
    for line in f:

        m = node_re.match(line)
        if m:
            if inside:
                out.write('\\n'.join(label) + "\"];\n")
            for k, v in links.items():
                out.write("{} -> {} [label=\"{}\"];\n".format(node_id, v, k))
            out.write("{id} [label=\"".format(**m.groupdict()))
            label = ["id={id}".format(**m.groupdict())]
            inside = True
            node_id = m.group('id')
            links = {}

        m = edge_re.match(line)
        if m:
            if inside:
                out.write('\\n'.join(label) + "\"];\n")
            for k, v in links.items():
                out.write("{} -> {} [label=\"{}\"];\n".format(node_id, v, k))
            out.write("{from} -> {to} [label=\"".format(**m.groupdict()))
            label = []
            inside = True
            node_id = 0
            links = {}

        m = prop_re.match(line)
        if m:
            # escape quotes in value
            label.append("{key}={value}".format(**m.groupdict()).replace('"', '\\"').replace('\\\\"', ''))
            l = link_re.match(m.group('value'))
            if l:
                links[m.group('key')] = l.group('id')
    out.write('\\n'.join(label) + "\"];\n")
    for k, v in links.items():
        out.write("{} -> {} [label=\"{}\"];\n".format(node_id, v, k))
    out.write("}\n")
