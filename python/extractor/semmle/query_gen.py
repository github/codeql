#Parse the dbscheme file

#Look for comments or declarations ending with ';'

import sys
import os.path

from semmle.python import master


def singularize(name):
    if name and name[-1] == 's':
        return name[:-1]
    elif name.endswith('_list'):
        return name[:-5]
    elif name.endswith('body'):
        return name[:-4] + 'stmt'
    else:
        return name

def singularize_text(name):
    if name.endswith('block'):
        return name[:-5] + 'statement'
    elif name.endswith('body'):
        return name[:-4] + 'statement'
    elif name.endswith(' list'):
        return name[:-5]
    else:
        return singularize(name)

def make_fields(field_type, index):
    if field_type.__name__ == 'bool':
        fields = []
    else:
        fields = [ 'result' ]
    if field_type.is_case_type():
        fields.append('_')
    fields.append('this')
    if not field_type.unique_parent:
        fields.append(str(index))
    return ', '.join(fields)

def get_a(name):
    name = capitalize_name(singularize(name))
    if name[0] in 'AEIOU':
        return 'getAn' + name
    else:
        return 'getA' + name

def indefinite_article(name):
    name = capitalize_name(singularize(name))
    if name[0] in 'AEIOU':
        return 'an'
    else:
        return 'a'

def capitalize_name(name):
    'Capitalize name, forming camel-case from undescores'
    return ''.join(part.capitalize() for part in name.split('_'))

def name_to_query(name):
    if name.startswith("is_"):
        return "i" + capitalize_name(name)[1:]
    else:
        return "is" + capitalize_name(name)

def longer_name(node, name, docname):
    return '%s of this %s' % (docname, node.descriptive_name)

def property_name(node, name, docname):
    return '%s property of this %s' % (docname, node.descriptive_name)

def make_getter(node, name, offset, field_type, docname, override):
    txt = [u'\n']
    if field_type.__name__ == 'bool':
        txt.append(u'    /** Whether the %s is true. */\n' % property_name(node, name, docname))
        txt.append(u'    predicate %s() {\n' % name_to_query(name))
    elif name == "location":
        txt.append(u'    /** Gets the %s. */\n' % longer_name(node, name, docname))
        txt.append(u'    %s%s get%s() {\n'%(override , field_type.ql_name(), capitalize_name(name)))
    else:
        txt.append(u'    /** Gets the %s. */\n' % longer_name(node, name, docname))
        txt.append(u'    %s get%s() {\n'%(field_type.ql_name(), capitalize_name(name)))
    if field_type.super_type:
        field_type = field_type.super_type
    fields = make_fields(field_type, offset)
    txt.append(u'        %s(%s)\n' % (field_type.relation_name(), fields))
    txt.append(u'    }\n\n')
    if field_type.is_list():
        item = field_type.item_type
        lname = longer_name(node, singularize(name), singularize_text(docname))
        txt.append('\n')
        txt.append('    /** Gets the nth %s. */\n' % lname)
        txt.append('    %s get%s(int index) {\n' %
                   (item.ql_name(), capitalize_name(singularize(name))))
        txt.append('        result = this.get%s().getItem(index)\n' %
                   capitalize_name(name))
        txt.append('    }\n')
        txt.append('\n')
        txt.append('    /** Gets %s %s. */\n' % (indefinite_article(lname), lname))
        txt.append('    %s %s() {\n' % (item.ql_name(), get_a(name)))
        txt.append('        result = this.get%s().getAnItem()\n' %
                   capitalize_name(name))
        txt.append('    }\n\n')

    return ''.join(txt)

def defined_in_supertype(node, name):
    if node.super_type:
        for fname, _, _, _, _, _ in node.super_type.layout:
            if fname == name:
                return True
    return False


def write_queries(nodes, out, lang):
    parents = {}
    nodes = set(nodes)
    done = set()
    out.write('import %s\n\n' % lang)
    while nodes:
        #Emit in (mostly) sorted order to reduce diffs.
        node = pop_least_value(nodes)
        done.add(node)
        if node.is_primitive():
            continue
        if node.is_list() and node.item_type.is_union_type():
            #List of unions are best ignored.
            #They can be implemented manually if needed.
            continue
        out.write('/** INTERNAL: See the class `%s` for further information. */\n' % node.ql_name())
        out.write('class %s_ extends %s' %
                  (node.ql_name(), node.db_name()))
        if node.super_type:
            out.write(', %s' % node.super_type.ql_name())
        override = "override " if node.super_type else ""
        out.write(' {\n\n')
        if node.is_sub_type() and node.super_type.is_union_type():
            out.write('    %s() {\n' % node.ql_name())
            out.write('        %s(this, %d, _, _' %
                (node.super_type.relation_name(), node.case_index))
            out.write(')\n')
            out.write('    }\n\n')
        else:
            body = []
            for name, field_type, offset, docname, _, _ in node.layout:
                if defined_in_supertype(node, name):
                    continue
                body.append(make_getter(node, name, offset, field_type, docname, override))
            out.write(''.join(body))
            if node.parents:
                if node.super_type and node.super_type.is_case_type():
                    child_node = node.super_type
                else:
                    child_node = node
                #Ensure closure
                if child_node.parents not in done:
                    nodes.add(child_node.parents)
                if not override:
                    out.write('    /** Gets a parent of this %s */\n' % node.descriptive_name)
                out.write('    %s%s getParent() {\n' %
                          (override, child_node.parents.ql_name()))
                out.write('        %s(' % child_node.relation_name())
                fields = [ 'this', ]
                if child_node.is_case_type():
                    fields.append('_')
                fields.append('result')
                if not child_node.unique_parent:
                    fields.append('_')
                out.write('%s)\n' % ', '.join(fields))
                out.write('    }\n\n')
                if child_node.parents.ql_name() not in parents:
                    parents[child_node.parents.ql_name()] = []
                parents[child_node.parents.ql_name()].append(child_node)
            if node.is_list():
                fields = [ 'result']
                item = node.item_type
                if item.super_type and item.super_type.is_case_type():
                    item = item.super_type
                if item.is_case_type():
                    fields.append('_')
                fields.append('this')
                fields = ', '.join(fields)
                out.write('    /** Gets an item of this %s */\n' % node.descriptive_name)
                out.write('    %s getAnItem() {\n' % item.ql_name())
                out.write('        %s(%s, _)\n' %
                          (item.relation_name(), fields))
                out.write('    }\n\n')
                out.write('    /** Gets the nth item of this %s */\n' % node.descriptive_name)
                out.write('    %s getItem(int index) {\n' % item.ql_name())
                out.write('        %s(%s, index)\n' %
                          (item.relation_name(), fields))
                out.write('    }\n\n')
        if not override:
            out.write('    /** Gets a textual representation of this element. */\n')
        out.write('    %sstring toString() {\n' % override)
        out.write('        result = "%s"\n' % node.ql_name())
        out.write('    }\n')
        out.write('\n}\n\n')
    out.close()

def pop_least_value(nodes):
    #This is inefficient, but it doesn't matter
    res = min(nodes, key = lambda n: n.__name__)
    nodes.remove(res)
    return res


HEADER = '''/**
 *      This library file is auto-generated by '%s'.
 *      WARNING: Any modifications to this file will be lost.
 *      Relations can be changed by modifying master.py.
 */
'''

def main():
    run(master)

def run(nodes_module, lang="python"):
    if len(sys.argv) != 2:
        print("Usage: %s output-directory" % sys.argv[0])
        sys.exit(1)
    outdir = sys.argv[1]
    nodes = nodes_module.all_nodes()
    outfile = os.path.join(outdir, 'AstGenerated.qll')
    with open(outfile, 'w') as out:
        out.write(HEADER % '/'.join(__file__.split(os.path.sep)[-2:]))
        write_queries(nodes.values(), out, lang)

if __name__ == '__main__':
    main()
