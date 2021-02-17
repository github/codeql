#!/usr/bin/python

# This script merges a number of stats files to produce a single stats file.

import sys
from lxml import etree
import argparse

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--output',              required=True,               help="Path of the output file.")
    parser.add_argument('--normalise',           required=True,               help="Name of the relation to normalise the sizes on.")
    parser.add_argument('--unscaled-stats',      default=[], action='append', help="A stats file which should not be normalised.")
    parser.add_argument('inputs',                nargs='*',                   help="The other stats files")
    return parser.parse_args()

def die(msg):
    sys.stderr.write('Error: ' + msg + '\n')
    sys.exit(1)

def main():
    args = parse_args()
    inputs    = args.inputs
    output    = args.output
    normalise = args.normalise
    unscaled_stats = args.unscaled_stats

    print("Merging %s into %s normalising on '%s'." % (', '.join(inputs), output, normalise))
    do_xml_files(output, inputs, unscaled_stats, normalise)

def read_sized_xml(xml_file, name):
    # Take the size of the named table as the size of the codebase
    xml = etree.parse(xml_file)
    ns = xml.xpath("stats/relation[name='%s']/cardinality" % name)
    if len(ns) == 0:
        die('Sized stats file ' + xml_file + ' does not have a cardinality for normalisation relation ' + name + '.')
    n = ns[0]
    size = int(n.text)
    return (xml, size)

def scale(xml, size, max_size):
    # Scale up the contents of all the <v> and <cardinality> tags
    for v in xml.xpath(".//v|.//cardinality"):
        v.text = str((int(v.text) * max_size) // size)

def do_xml_files(output, scaled_xml_files, unscaled_xml_files, name):
    # The result starts off empty
    result = etree.Element("dbstats")

    # Scale all of the stats so that they might have come code bases of
    # the same size
    sized_xmls = [read_sized_xml(xml_file, name)
                  for xml_file in scaled_xml_files]
    if sized_xmls != []:
        max_size = max([size for (xml, size) in sized_xmls])
        for (xml, size) in sized_xmls:
            scale(xml, size, max_size)
    unsized_xmls = list(map(etree.parse, unscaled_xml_files))
    xmls = [xml for (xml, size) in sized_xmls] + unsized_xmls

    # Put all the stats in a single XML doc so that we can search them
    # more easily
    merged_xml = etree.Element("merged")
    for xml in xmls:
        merged_xml.append(xml.getroot())

    # For each value of <e><k>, take the <e> tag with the biggest <e><v>
    typesizes = etree.SubElement(result, "typesizes")
    typenames = sorted(set ([ typesize.find("k").text for typesize in merged_xml.xpath("dbstats/typesizes/e")]))
    for typename in typenames:
        xs = merged_xml.xpath("dbstats/typesizes/e[k='" + typename + "']")
        sized_xs = [(int(x.find("v").text), x) for x in xs]
        (_, x) = max(sized_xs, key = lambda p: p[0])
        typesizes.append(x)

    # For each value of <relation><name>, take the <relation> tag with
    # the biggest <relation><cardinality>
    stats = etree.SubElement(result, "stats")
    
    relnames = sorted(set ([relation.find("name").text for relation in merged_xml.xpath("dbstats/stats/relation") ]))
    for relname in relnames:
        rels = merged_xml.xpath("dbstats/stats/relation[name='" + relname + "']")
        sized_rels = [(int(rel.find("cardinality").text), rel) for rel in rels]
        (_, rel) = max(sized_rels, key = lambda p: p[0])
        stats.append(rel)

    with open(output, 'wb') as f:
        f.write(etree.tostring(result, pretty_print=True))

main()
